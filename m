Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199D7175CBA
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 15:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgCBOOt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Mar 2020 09:14:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgCBOOo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 09:14:44 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E17222B48;
        Mon,  2 Mar 2020 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583158483;
        bh=5Jt8MTUrWakTda+2huNCyJWACG9WqjG2kxVim8//6zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQETuF/MZ/XC+PjkhL7U21K5KrfCmKqslLcOfTk3etlQk9fSaxct7KEh6eY0rfvaK
         HIAZqxQy1IAud0HxkU1IOtrS6R1ipwVZrq4FyY/Ba7oU2LYDbHDwU04G4eDmQTar33
         9ECJnkCsk6MXGfB+ydRaiPdmtBizFikmrrv4S4Tk=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH v6 10/13] ceph: decode interval_sets for delegated inos
Date:   Mon,  2 Mar 2020 09:14:31 -0500
Message-Id: <20200302141434.59825-11-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302141434.59825-1-jlayton@kernel.org>
References: <20200302141434.59825-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Starting in Octopus, the MDS will hand out caps that allow the client
to do asynchronous file creates under certain conditions. As part of
that, the MDS will delegate ranges of inode numbers to the client.

Add the infrastructure to decode these ranges, and stuff them into an
xarray for later consumption by the async creation code.

Because the xarray code currently only handles unsigned long indexes,
and those are 32-bits on 32-bit arches, we only enable the decoding when
running on a 64-bit arch.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 122 +++++++++++++++++++++++++++++++++++++++----
 fs/ceph/mds_client.h |   9 +++-
 2 files changed, 121 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index db8304447f35..87f75d05b004 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -415,21 +415,121 @@ static int parse_reply_info_filelock(void **p, void *end,
 	return -EIO;
 }
 
+
+#if BITS_PER_LONG == 64
+
+#define DELEGATED_INO_AVAILABLE		xa_mk_value(1)
+
+static int ceph_parse_deleg_inos(void **p, void *end,
+				 struct ceph_mds_session *s)
+{
+	u32 sets;
+
+	ceph_decode_32_safe(p, end, sets, bad);
+	dout("got %u sets of delegated inodes\n", sets);
+	while (sets--) {
+		u64 start, len, ino;
+
+		ceph_decode_64_safe(p, end, start, bad);
+		ceph_decode_64_safe(p, end, len, bad);
+		while (len--) {
+			int err = xa_insert(&s->s_delegated_inos, ino = start++,
+					    DELEGATED_INO_AVAILABLE,
+					    GFP_KERNEL);
+			if (!err) {
+				dout("added delegated inode 0x%llx\n",
+				     start - 1);
+			} else if (err == -EBUSY) {
+				pr_warn("ceph: MDS delegated inode 0x%llx more than once.\n",
+					start - 1);
+			} else {
+				return err;
+			}
+		}
+	}
+	return 0;
+bad:
+	return -EIO;
+}
+
+u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
+{
+	unsigned long ino;
+	void *val;
+
+	xa_for_each(&s->s_delegated_inos, ino, val) {
+		val = xa_erase(&s->s_delegated_inos, ino);
+		if (val == DELEGATED_INO_AVAILABLE)
+			return ino;
+	}
+	return 0;
+}
+
+int ceph_restore_deleg_ino(struct ceph_mds_session *s, u64 ino)
+{
+	return xa_insert(&s->s_delegated_inos, ino, DELEGATED_INO_AVAILABLE,
+			 GFP_KERNEL);
+}
+#else /* BITS_PER_LONG == 64 */
+/*
+ * FIXME: xarrays can't handle 64-bit indexes on a 32-bit arch. For now, just
+ * ignore delegated_inos on 32 bit arch. Maybe eventually add xarrays for top
+ * and bottom words?
+ */
+static int ceph_parse_deleg_inos(void **p, void *end,
+				 struct ceph_mds_session *s)
+{
+	u32 sets;
+
+	ceph_decode_32_safe(p, end, sets, bad);
+	if (sets)
+		ceph_decode_skip_n(p, end, sets * 2 * sizeof(__le64), bad);
+	return 0;
+bad:
+	return -EIO;
+}
+
+u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
+{
+	return 0;
+}
+
+int ceph_restore_deleg_ino(struct ceph_mds_session *s, u64 ino)
+{
+	return 0;
+}
+#endif /* BITS_PER_LONG == 64 */
+
 /*
  * parse create results
  */
 static int parse_reply_info_create(void **p, void *end,
 				  struct ceph_mds_reply_info_parsed *info,
-				  u64 features)
+				  u64 features, struct ceph_mds_session *s)
 {
+	int ret;
+
 	if (features == (u64)-1 ||
 	    (features & CEPH_FEATURE_REPLY_CREATE_INODE)) {
-		/* Malformed reply? */
 		if (*p == end) {
+			/* Malformed reply? */
 			info->has_create_ino = false;
-		} else {
+		} else if (test_bit(CEPHFS_FEATURE_DELEG_INO, &s->s_features)) {
+			u8 struct_v, struct_compat;
+			u32 len;
+
 			info->has_create_ino = true;
+			ceph_decode_8_safe(p, end, struct_v, bad);
+			ceph_decode_8_safe(p, end, struct_compat, bad);
+			ceph_decode_32_safe(p, end, len, bad);
+			ceph_decode_64_safe(p, end, info->ino, bad);
+			ret = ceph_parse_deleg_inos(p, end, s);
+			if (ret)
+				return ret;
+		} else {
+			/* legacy */
 			ceph_decode_64_safe(p, end, info->ino, bad);
+			info->has_create_ino = true;
 		}
 	} else {
 		if (*p != end)
@@ -448,7 +548,7 @@ static int parse_reply_info_create(void **p, void *end,
  */
 static int parse_reply_info_extra(void **p, void *end,
 				  struct ceph_mds_reply_info_parsed *info,
-				  u64 features)
+				  u64 features, struct ceph_mds_session *s)
 {
 	u32 op = le32_to_cpu(info->head->op);
 
@@ -457,7 +557,7 @@ static int parse_reply_info_extra(void **p, void *end,
 	else if (op == CEPH_MDS_OP_READDIR || op == CEPH_MDS_OP_LSSNAP)
 		return parse_reply_info_readdir(p, end, info, features);
 	else if (op == CEPH_MDS_OP_CREATE)
-		return parse_reply_info_create(p, end, info, features);
+		return parse_reply_info_create(p, end, info, features, s);
 	else
 		return -EIO;
 }
@@ -465,7 +565,7 @@ static int parse_reply_info_extra(void **p, void *end,
 /*
  * parse entire mds reply
  */
-static int parse_reply_info(struct ceph_msg *msg,
+static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
 			    struct ceph_mds_reply_info_parsed *info,
 			    u64 features)
 {
@@ -490,7 +590,7 @@ static int parse_reply_info(struct ceph_msg *msg,
 	ceph_decode_32_safe(&p, end, len, bad);
 	if (len > 0) {
 		ceph_decode_need(&p, end, len, bad);
-		err = parse_reply_info_extra(&p, p+len, info, features);
+		err = parse_reply_info_extra(&p, p+len, info, features, s);
 		if (err < 0)
 			goto out_bad;
 	}
@@ -558,6 +658,7 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
 	if (refcount_dec_and_test(&s->s_ref)) {
 		if (s->s_auth.authorizer)
 			ceph_auth_destroy_authorizer(s->s_auth.authorizer);
+		xa_destroy(&s->s_delegated_inos);
 		kfree(s);
 	}
 }
@@ -645,6 +746,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	refcount_set(&s->s_ref, 1);
 	INIT_LIST_HEAD(&s->s_waiting);
 	INIT_LIST_HEAD(&s->s_unsafe);
+	xa_init(&s->s_delegated_inos);
 	s->s_num_cap_releases = 0;
 	s->s_cap_reconnect = 0;
 	s->s_cap_iterator = NULL;
@@ -2975,9 +3077,9 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	dout("handle_reply tid %lld result %d\n", tid, result);
 	rinfo = &req->r_reply_info;
 	if (test_bit(CEPHFS_FEATURE_REPLY_ENCODING, &session->s_features))
-		err = parse_reply_info(msg, rinfo, (u64)-1);
+		err = parse_reply_info(session, msg, rinfo, (u64)-1);
 	else
-		err = parse_reply_info(msg, rinfo, session->s_con.peer_features);
+		err = parse_reply_info(session, msg, rinfo, session->s_con.peer_features);
 	mutex_unlock(&mdsc->mutex);
 
 	mutex_lock(&session->s_mutex);
@@ -3673,6 +3775,8 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 	if (!reply)
 		goto fail_nomsg;
 
+	xa_destroy(&session->s_delegated_inos);
+
 	mutex_lock(&session->s_mutex);
 	session->s_state = CEPH_MDS_SESSION_RECONNECTING;
 	session->s_seq = 0;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index f10d342ea585..4c3b71707470 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -23,8 +23,9 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_RECLAIM_CLIENT,
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,
 	CEPHFS_FEATURE_MULTI_RECONNECT,
+	CEPHFS_FEATURE_DELEG_INO,
 
-	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_MULTI_RECONNECT,
+	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_DELEG_INO,
 };
 
 /*
@@ -37,6 +38,7 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_REPLY_ENCODING,		\
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
+	CEPHFS_FEATURE_DELEG_INO,		\
 						\
 	CEPHFS_FEATURE_MAX,			\
 }
@@ -201,6 +203,7 @@ struct ceph_mds_session {
 
 	struct list_head  s_waiting;  /* waiting requests */
 	struct list_head  s_unsafe;   /* unsafe requests */
+	struct xarray	  s_delegated_inos;
 };
 
 /*
@@ -542,6 +545,7 @@ extern void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
 extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
 			  struct ceph_mds_session *session,
 			  int max_caps);
+
 static inline int ceph_wait_on_async_create(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -549,4 +553,7 @@ static inline int ceph_wait_on_async_create(struct inode *inode)
 	return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
 			   TASK_INTERRUPTIBLE);
 }
+
+extern u64 ceph_get_deleg_ino(struct ceph_mds_session *session);
+extern int ceph_restore_deleg_ino(struct ceph_mds_session *session, u64 ino);
 #endif
-- 
2.24.1

