Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6D51F7EC
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 17:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfEOPpo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 11:45:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:60964 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbfEOPpo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 May 2019 11:45:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3D7ACAEE1;
        Wed, 15 May 2019 15:45:43 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        David Disseldorp <ddiss@suse.de>
Subject: [PATCH] ceph: fix "ceph.snap.btime" vxattr value
Date:   Wed, 15 May 2019 17:45:35 +0200
Message-Id: <20190515154535.29662-1-ddiss@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190418121549.30128-4-ddiss@suse.de>
References: <20190418121549.30128-4-ddiss@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This fixes a cut-n-paste error from "ceph.dir.rctime":
The vxattr value incorrectly places a "09" prefix to the nanoseconds
field, instead of providing it as a zero-pad width specifier after '%'.

Link: https://tracker.ceph.com/issues/39705
Fixes: 7e03e7214470 ("ceph: add ceph.snap.btime vxattr")
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
XXX: The erroneous change hasn't gone into mainline yet, so feel free to
squash this in with 7e03e7214470 in the ceph-client repo.

 fs/ceph/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 5778acaf5bcf..57350e4b7da0 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -282,7 +282,7 @@ static bool ceph_vxattrcb_snap_btime_exists(struct ceph_inode_info *ci)
 static size_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
 				       size_t size)
 {
-	return snprintf(val, size, "%lld.09%ld", ci->i_snap_btime.tv_sec,
+	return snprintf(val, size, "%lld.%09ld", ci->i_snap_btime.tv_sec,
 			ci->i_snap_btime.tv_nsec);
 }
 
-- 
2.16.4

