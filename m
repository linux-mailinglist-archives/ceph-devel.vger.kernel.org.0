Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9928B27E884
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Sep 2020 14:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgI3M0J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Sep 2020 08:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgI3M0J (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 08:26:09 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D0A82071E;
        Wed, 30 Sep 2020 12:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601468768;
        bh=A+reefeSSN1H48HheKmitm32fTVQLsiRj4IzWR7NorI=;
        h=From:To:Cc:Subject:Date:From;
        b=t6Pm2OvlOn+3gVJib7F53iH9dj5uYfLH0r0nZEYKGjJ26M3d7cAl6ze91fea5USG9
         F2RjPKNojgehwyxLzRByf6c44e7Z8R1Ge37FkT6lDtC7aw5M0Op1dx6s6JUzGeMa1l
         GtP+PVHzeDK8ebCa/mR8N/spSrWxQ7LcO3KcfKVY=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: fix up some warnings on W=1 builds
Date:   Wed, 30 Sep 2020 08:26:06 -0400
Message-Id: <20200930122606.16777-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Convert some decodes into unused variables into skips, and fix up some
non-kerneldoc comment headers to not start with "/**".

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 11 ++++-------
 fs/ceph/locks.c      |  8 ++++----
 fs/ceph/mds_client.c | 26 +++++++-------------------
 3 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 2ee3f316afcf..4c967f176ebd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4016,15 +4016,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	}
 
 	if (msg_version >= 8) {
-		u64 flush_tid;
-		u32 caller_uid, caller_gid;
 		u32 pool_ns_len;
 
 		/* version >= 6 */
-		ceph_decode_64_safe(&p, end, flush_tid, bad);
+		ceph_decode_skip_64(&p, end, bad);	// flush_tid
 		/* version >= 7 */
-		ceph_decode_32_safe(&p, end, caller_uid, bad);
-		ceph_decode_32_safe(&p, end, caller_gid, bad);
+		ceph_decode_skip_32(&p, end, bad);	// caller_uid
+		ceph_decode_skip_32(&p, end, bad);	// caller_gid
 		/* version >= 8 */
 		ceph_decode_32_safe(&p, end, pool_ns_len, bad);
 		if (pool_ns_len > 0) {
@@ -4047,9 +4045,8 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	}
 
 	if (msg_version >= 11) {
-		u32 flags;
 		/* version >= 10 */
-		ceph_decode_32_safe(&p, end, flags, bad);
+		ceph_decode_skip_32(&p, end, bad);
 		/* version >= 11 */
 		extra_info.dirstat_valid = true;
 		ceph_decode_64_safe(&p, end, extra_info.nfiles, bad);
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 048a435a29be..fa8a847743d0 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -57,7 +57,7 @@ static const struct file_lock_operations ceph_fl_lock_ops = {
 	.fl_release_private = ceph_fl_release_lock,
 };
 
-/**
+/*
  * Implement fcntl and flock locking functions.
  */
 static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
@@ -225,7 +225,7 @@ static int try_unlock_file(struct file *file, struct file_lock *fl)
 	return 1;
 }
 
-/**
+/*
  * Attempt to set an fcntl lock.
  * For now, this just goes away to the server. Later it may be more awesome.
  */
@@ -408,7 +408,7 @@ static int lock_to_ceph_filelock(struct file_lock *lock,
 	return err;
 }
 
-/**
+/*
  * Encode the flock and fcntl locks for the given inode into the ceph_filelock
  * array. Must be called with inode->i_lock already held.
  * If we encounter more of a specific lock type than expected, return -ENOSPC.
@@ -458,7 +458,7 @@ int ceph_encode_locks_to_buffer(struct inode *inode,
 	return err;
 }
 
-/**
+/*
  * Copy the encoded flock and fcntl locks into the pagelist.
  * Format is: #fcntl locks, sequential fcntl locks, #flock locks,
  * sequential flock locks.
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1190710f63af..a178580e6d40 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -516,13 +516,9 @@ static int parse_reply_info_create(void **p, void *end,
 			/* Malformed reply? */
 			info->has_create_ino = false;
 		} else if (test_bit(CEPHFS_FEATURE_DELEG_INO, &s->s_features)) {
-			u8 struct_v, struct_compat;
-			u32 len;
-
 			info->has_create_ino = true;
-			ceph_decode_8_safe(p, end, struct_v, bad);
-			ceph_decode_8_safe(p, end, struct_compat, bad);
-			ceph_decode_32_safe(p, end, len, bad);
+			/* struct_v, struct_compat, and len */
+			ceph_decode_skip_n(p, end, 2 + sizeof(u32), bad);
 			ceph_decode_64_safe(p, end, info->ino, bad);
 			ret = ceph_parse_deleg_inos(p, end, s);
 			if (ret)
@@ -4851,10 +4847,8 @@ void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 	void *p = msg->front.iov_base;
 	void *end = p + msg->front.iov_len;
 	u32 epoch;
-	u32 map_len;
 	u32 num_fs;
 	u32 mount_fscid = (u32)-1;
-	u8 struct_v, struct_cv;
 	int err = -EINVAL;
 
 	ceph_decode_need(&p, end, sizeof(u32), bad);
@@ -4862,24 +4856,18 @@ void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 
 	dout("handle_fsmap epoch %u\n", epoch);
 
-	ceph_decode_need(&p, end, 2 + sizeof(u32), bad);
-	struct_v = ceph_decode_8(&p);
-	struct_cv = ceph_decode_8(&p);
-	map_len = ceph_decode_32(&p);
-
-	ceph_decode_need(&p, end, sizeof(u32) * 3, bad);
-	p += sizeof(u32) * 2; /* skip epoch and legacy_client_fscid */
+	/* struct_v, struct_cv, map_len, epoch, legacy_client_fscid */
+	ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 3, bad);
 
-	num_fs = ceph_decode_32(&p);
+	ceph_decode_32_safe(&p, end, num_fs, bad);
 	while (num_fs-- > 0) {
 		void *info_p, *info_end;
 		u32 info_len;
-		u8 info_v, info_cv;
 		u32 fscid, namelen;
 
 		ceph_decode_need(&p, end, 2 + sizeof(u32), bad);
-		info_v = ceph_decode_8(&p);
-		info_cv = ceph_decode_8(&p);
+		p += 1;		// info_v
+		p += 1;		// info_cv
 		info_len = ceph_decode_32(&p);
 		ceph_decode_need(&p, end, info_len, bad);
 		info_p = p;
-- 
2.26.2

