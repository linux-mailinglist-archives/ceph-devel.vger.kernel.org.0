Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D07FF4DE7
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Nov 2019 15:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfKHOP7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Nov 2019 09:15:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:58048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726200AbfKHOP7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 8 Nov 2019 09:15:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4FE6EB49F;
        Fri,  8 Nov 2019 14:15:57 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH 0/2] ceph: safely use 'copy-from' Op on Octopus OSDs
Date:   Fri,  8 Nov 2019 14:15:53 +0000
Message-Id: <20191108141555.31176-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

(Sorry for the long cover letter!)

Since the fix for [1] has finally been merged and should be available in
the next (Octopus) ceph release, I'm trying to clean-up my kernel client
patch that tries to find out whether or not it's safe to use the
'copy-from' RADOS operation for copy_file_range.

So, the fix for [1] was to modify the 'copy-from' operation to allow
clients to optionally (using the CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ
flag) send the extra truncate_seq and truncate_size parameters.  Since
only Octopus will have this fix (no backports planned), the client
simply needs to ensure the OSDs being used have SERVER_OCTOPUS in their
features.

My initial solution was to add an extra test in __submit_request,
looping all the request ops and checking if the connection has the
required features for that operation.  Obviously, at the moment only the
copy-from operation has a restriction but I guess others may be added in
the future.  I believe that doing this at this point (__submit_request)
allows to cover cases where a cluster is being upgraded to Octopus and
we have different OSDs running with different feature bits.

Unfortunately, this solution is racy because the connection state
machine may be changing and the peer_features field isn't yet set.  For
example: if the connection to an OSD is being re-open when we're about
to check the features, the con->state will be CON_STATE_PREOPEN and the
con->peer_features will be 0.  I tried to find ways to move the feature
check further down in the stack, but that can't be easily done without
adding more infrastructure.  A solution that came to my mind was to add
a new con->ops, invoked in the context of ceph_con_workfn, under the
con->mutex.  This callback could then verify the available features,
aborting the operation if needed.

Note that the race in this patchset doesn't seem to be a huge problem,
other than occasionally reverting to a VFS generic copy_file_range, as
-EOPNOTSUPP will be returned here.  But it's still a race, and there are
probably other cases that I'm missing.

Anyway, maybe I'm missing an obvious solution for checking these OSD
features, but I'm open to any suggestions on other options (or some
feedback on the new callback in ceph_connection_operations option).

[1] https://tracker.ceph.com/issues/37378

Cheers,
--
Luis

Luis Henriques (2):
  ceph: add support for sending truncate_{seq,size} in 'copy-from' Op
  ceph: make 'copyfrom' a default mount option again

 fs/ceph/file.c                     |  4 +++-
 fs/ceph/super.c                    |  4 ++--
 fs/ceph/super.h                    |  4 +---
 include/linux/ceph/ceph_features.h |  6 ++++-
 include/linux/ceph/osd_client.h    |  1 +
 include/linux/ceph/rados.h         |  1 +
 net/ceph/osd_client.c              | 37 +++++++++++++++++++++++++++++-
 7 files changed, 49 insertions(+), 8 deletions(-)

