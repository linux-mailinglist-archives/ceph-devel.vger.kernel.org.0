Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A764D4877A
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfFQPiK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbfFQPiJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:38:09 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 906EC21882;
        Mon, 17 Jun 2019 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785889;
        bh=gIKkq5mIVUK2QAdQphahGiEgVy4BD8vuIMOejT43afM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhDQrua2nzXVi+QwE2i3nwZ6qY0uGfDQhhpqCqxmJiHC8J5WaDFr0Ykdd5uLu/4Oy
         o0GLQYoduufQtIXO9Im32lMhv7qXQTbDUsfHYFZO+MkPE+5pL4fEXfJ/pQOeTkCYqT
         cjBfUCigVkQ1NHs6EybOjota1RxO/oTlTxD3R36M=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 17/18] ceph: handle change_attr in cap messages
Date:   Mon, 17 Jun 2019 11:37:52 -0400
Message-Id: <20190617153753.3611-18-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 19 ++++++++++---------
 fs/ceph/snap.c  |  2 ++
 fs/ceph/super.h |  1 +
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 623b82684e90..2e22efd79b0c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
 #include <linux/writeback.h>
+#include <linux/iversion.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -1138,6 +1139,7 @@ struct cap_msg_args {
 	u64			ino, cid, follows;
 	u64			flush_tid, oldest_flush_tid, size, max_size;
 	u64			xattr_version;
+	u64			change_attr;
 	struct ceph_buffer	*xattr_buf;
 	struct timespec64	atime, mtime, ctime, btime;
 	int			op, caps, wanted, dirty;
@@ -1244,15 +1246,10 @@ static int send_cap_msg(struct cap_msg_args *arg)
 	/* pool namespace (version 8) (mds always ignores this) */
 	ceph_encode_32(&p, 0);
 
-	/*
-	 * btime and change_attr (version 9)
-	 *
-	 * We just zero these out for now, as the MDS ignores them unless
-	 * the requisite feature flags are set (which we don't do yet).
-	 */
+	/* btime and change_attr (version 9) */
 	ceph_encode_timespec64(p, &arg->btime);
 	p += sizeof(struct ceph_timespec);
-	ceph_encode_64(&p, 0);
+	ceph_encode_64(&p, arg->change_attr);
 
 	/* Advisory flags (version 10) */
 	ceph_encode_32(&p, arg->flags);
@@ -1379,6 +1376,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	arg.atime = inode->i_atime;
 	arg.ctime = inode->i_ctime;
 	arg.btime = ci->i_btime;
+	arg.change_attr = inode_peek_iversion_raw(inode);
 
 	arg.op = op;
 	arg.caps = cap->implemented;
@@ -1439,6 +1437,7 @@ static inline int __send_flush_snap(struct inode *inode,
 	arg.mtime = capsnap->mtime;
 	arg.ctime = capsnap->ctime;
 	arg.btime = capsnap->btime;
+	arg.change_attr = capsnap->change_attr;
 
 	arg.op = CEPH_CAP_OP_FLUSHSNAP;
 	arg.caps = capsnap->issued;
@@ -3043,6 +3042,7 @@ struct cap_extra_info {
 	bool dirstat_valid;
 	u64 nfiles;
 	u64 nsubdirs;
+	u64 change_attr;
 	/* currently issued */
 	int issued;
 	struct timespec64 btime;
@@ -3127,6 +3127,8 @@ static void handle_cap_grant(struct inode *inode,
 
 	__check_cap_issue(ci, cap, newcaps);
 
+	inode_set_max_iversion_raw(inode, extra_info->change_attr);
+
 	if ((newcaps & CEPH_CAP_AUTH_SHARED) &&
 	    (extra_info->issued & CEPH_CAP_AUTH_EXCL) == 0) {
 		inode->i_mode = le32_to_cpu(grant->mode);
@@ -3856,14 +3858,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 
 	if (msg_version >= 9) {
 		struct ceph_timespec *btime;
-		u64 change_attr;
 
 		if (p + sizeof(*btime) > end)
 			goto bad;
 		btime = p;
 		ceph_decode_timespec64(&extra_info.btime, btime);
 		p += sizeof(*btime);
-		ceph_decode_64_safe(&p, end, change_attr, bad);
+		ceph_decode_64_safe(&p, end, extra_info.change_attr, bad);
 	}
 
 	if (msg_version >= 11) {
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 854308e13f12..4c6494eb02b5 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -3,6 +3,7 @@
 
 #include <linux/sort.h>
 #include <linux/slab.h>
+#include <linux/iversion.h>
 #include "super.h"
 #include "mds_client.h"
 #include <linux/ceph/decode.h>
@@ -607,6 +608,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 	capsnap->atime = inode->i_atime;
 	capsnap->ctime = inode->i_ctime;
 	capsnap->btime = ci->i_btime;
+	capsnap->change_attr = inode_peek_iversion_raw(inode);
 	capsnap->time_warp_seq = ci->i_time_warp_seq;
 	capsnap->truncate_size = ci->i_truncate_size;
 	capsnap->truncate_seq = ci->i_truncate_seq;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c3cb942e08b0..8ecbcd7d45e8 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -197,6 +197,7 @@ struct ceph_cap_snap {
 	u64 xattr_version;
 
 	u64 size;
+	u64 change_attr;
 	struct timespec64 mtime, atime, ctime, btime;
 	u64 time_warp_seq;
 	u64 truncate_size;
-- 
2.21.0

