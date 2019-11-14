Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A88FC4D9
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 11:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKNK5k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 05:57:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:33300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbfKNK5k (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 05:57:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E0BFACD8;
        Thu, 14 Nov 2019 10:57:38 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH v2 0/4] ceph: safely use 'copy-from' Op on Octopus OSDs
Date:   Thu, 14 Nov 2019 10:57:32 +0000
Message-Id: <20191114105736.8636-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

So, after the feedback I got from v1 [1] I've sent out a pull-request
for the OSDs [2] which encodes require_osd_release into the OSDMap
client data.  This allows the client to figure out which ceph release
the OSDs cluster is running and decide whether or not it's safe to use
the copy-from Op for copy_file_range.

This new patchset I'm sending simply adds enough functionality to the
kernel client so that it can take advantage of this OSD patch:

0001 - adds the ability to decode TYPE_MSGR2 addresses.  This is a
       required functionality for enabling SERVER_NAUTILUS in the
       client.  I hope I got the new format right, as I couldn't figure
       out what the hard-coded values (see comments) really mean.

0002 - allows the client to retrieve the new require_osd_release field
       from the OSDMap if available.  This patch also adds SERVER_MIMIC,
       SERVER_NAUTILUS and SERVER_OCTOPUS to the supported features,
       which TBH I'm not sure if that's a safe thing to do -- the only
       issue I've seen was that Nautilus requires the ability to decode
       TYPE_MSGR2 address, but I may have missed others.

0003 - debug code to add require_osd_release to the osdmap debugfs file.

0004 - adds the truncate_{seq,size} fields to the 'copy-from' operation
       if the OSDs are >= Octopus.

Also note that, as suggested by Ilya, I've dropped the patch that would
change the default mount options to 'copyfrom'.

These patches have been tested with the xfstests generic test suite, and
with a couple of other (local) tests that exercise the cephfs
copy_file_range syscall.  I didn't saw any issues, but as I said above,
I'm not really sure if adding the SERVER_* flags to the supported
features have other side effects.

[1] https://lore.kernel.org/lkml/20191108141555.31176-1-lhenriques@suse.com/
[2] https://github.com/ceph/ceph/pull/31611

Cheers,
--
Luis

Luis Henriques (4):
  ceph: add support for TYPE_MSGR2 address decode
  ceph: get the require_osd_release field from the osdmap
  ceph: add require_osd_release field to osdmap debugfs
  ceph: add support for sending truncate_{seq,size} in 'copy-from' Op

 fs/ceph/file.c                     | 10 +++++++-
 include/linux/ceph/ceph_features.h | 10 ++++++--
 include/linux/ceph/decode.h        |  3 ++-
 include/linux/ceph/osd_client.h    |  1 +
 include/linux/ceph/osdmap.h        |  1 +
 include/linux/ceph/rados.h         | 23 ++++++++++++++++++
 net/ceph/ceph_strings.c            | 38 ++++++++++++++++++++++++++++++
 net/ceph/debugfs.c                 |  2 ++
 net/ceph/decode.c                  | 33 ++++++++++++++++++++++++--
 net/ceph/osd_client.c              |  7 +++++-
 net/ceph/osdmap.c                  | 21 +++++++++++++++++
 11 files changed, 142 insertions(+), 7 deletions(-)

