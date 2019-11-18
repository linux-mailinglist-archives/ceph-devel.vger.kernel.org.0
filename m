Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88D10055B
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 13:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfKRMJk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 07:09:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:43620 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726490AbfKRMJj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 07:09:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33DBCB219;
        Mon, 18 Nov 2019 12:09:38 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH v3] ceph: add new obj copy OSD Op 
Date:   Mon, 18 Nov 2019 12:09:33 +0000
Message-Id: <20191118120935.7013-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Before going ahead with a pull-request for ceph I would like to make sure
we're all on the same page regarding the final fix for this problem.
Thus, following this email, I'm sending 2 patches: one for ceph OSDs and
the another for the kernel client.

* osd: add new 'copy-from-notrunc' operation
  This patch shall be applied to ceph master after reverting commit
  ba152435fd85 ("osd: add flag to prevent truncate_seq copy in copy-from
  operation").  It adds a new operation that will be exactly the same as
  the original 'copy-from' operation, but with the extra 2 parameters
  (truncate_{seq,size})

* ceph: switch copy_file_range to 'copy-from-notrunc' operation
  This will make the kernel client use the new OSD op in
  copy_file_range.  One extra thing that could probably be added is
  changing the mount options to NOCOPYFROM if the first call to
  ceph_osdc_copy_from() fails.

Does this look good, or did I missed something from the previous
discussion?

(One advantage of this approach: the OSD patch can be easily backported!)

Cheers,
-- 
Luis

Luis Henriques (1):
  osd: add new 'copy-from-notrunc' operation

 src/include/rados.h     |  1 +
 src/osd/OSD.cc          |  3 ++-
 src/osd/PrimaryLogPG.cc | 24 +++++++++++++++++++-----
 3 files changed, 22 insertions(+), 6 deletions(-)

  ceph: switch copy_file_range to 'copy-from-notrunc' operation

 fs/ceph/file.c                  |  3 ++-
 include/linux/ceph/osd_client.h |  1 +
 include/linux/ceph/rados.h      |  1 +
 net/ceph/osd_client.c           | 18 ++++++++++++------
 4 files changed, 16 insertions(+), 7 deletions(-)

