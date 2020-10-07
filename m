Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3468285F27
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 14:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgJGMZj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 08:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728204AbgJGMZj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 08:25:39 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3448206D9;
        Wed,  7 Oct 2020 12:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602073538;
        bh=U+YT3iyheanQwSI76+JyBEqgLlDEOCur5vX0MBGoFJ0=;
        h=From:To:Cc:Subject:Date:From;
        b=fDivb8tpX7LjKhAWKPfx9IfWvQlKTwq180MB+jX0AHKjnLWiysUCtdlHv5amtGKdk
         ElQuR/EDDO0NtfayXX8dF5n9zGEaEmFma/n3tpCEpefVvawsQh00DRS3E2eDa4+tcq
         MbcOSJaDZPWOe+iGHSCRonm9n8fpih3PNo/gEpRQ=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com
Subject: [PATCH] ceph: break up send_cap_msg
Date:   Wed,  7 Oct 2020 08:25:36 -0400
Message-Id: <20201007122536.13354-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Push the allocation of the msg and the send into the caller. Rename
the function to marshal_cap_msg and make it void return.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 61 +++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 4e84b39a6ebd..6f4adfaf761f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1222,36 +1222,29 @@ struct cap_msg_args {
 };
 
 /*
- * Build and send a cap message to the given MDS.
- *
- * Caller should be holding s_mutex.
+ * cap struct size + flock buffer size + inline version + inline data size +
+ * osd_epoch_barrier + oldest_flush_tid
  */
-static int send_cap_msg(struct cap_msg_args *arg)
+#define CAP_MSG_SIZE (sizeof(struct ceph_mds_caps) + \
+		      4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4)
+
+/* Marshal up the cap msg to the MDS */
+static void marshal_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
 {
 	struct ceph_mds_caps *fc;
-	struct ceph_msg *msg;
 	void *p;
-	size_t extra_len;
 	struct ceph_osd_client *osdc = &arg->session->s_mdsc->fsc->client->osdc;
 
-	dout("send_cap_msg %s %llx %llx caps %s wanted %s dirty %s"
+	dout("%s %s %llx %llx caps %s wanted %s dirty %s"
 	     " seq %u/%u tid %llu/%llu mseq %u follows %lld size %llu/%llu"
-	     " xattr_ver %llu xattr_len %d\n", ceph_cap_op_name(arg->op),
-	     arg->cid, arg->ino, ceph_cap_string(arg->caps),
-	     ceph_cap_string(arg->wanted), ceph_cap_string(arg->dirty),
-	     arg->seq, arg->issue_seq, arg->flush_tid, arg->oldest_flush_tid,
-	     arg->mseq, arg->follows, arg->size, arg->max_size,
-	     arg->xattr_version,
+	     " xattr_ver %llu xattr_len %d\n", __func__,
+	     ceph_cap_op_name(arg->op), arg->cid, arg->ino,
+	     ceph_cap_string(arg->caps), ceph_cap_string(arg->wanted),
+	     ceph_cap_string(arg->dirty), arg->seq, arg->issue_seq,
+	     arg->flush_tid, arg->oldest_flush_tid, arg->mseq, arg->follows,
+	     arg->size, arg->max_size, arg->xattr_version,
 	     arg->xattr_buf ? (int)arg->xattr_buf->vec.iov_len : 0);
 
-	/* flock buffer size + inline version + inline data size +
-	 * osd_epoch_barrier + oldest_flush_tid */
-	extra_len = 4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4;
-	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, sizeof(*fc) + extra_len,
-			   GFP_NOFS, false);
-	if (!msg)
-		return -ENOMEM;
-
 	msg->hdr.version = cpu_to_le16(10);
 	msg->hdr.tid = cpu_to_le64(arg->flush_tid);
 
@@ -1323,9 +1316,6 @@ static int send_cap_msg(struct cap_msg_args *arg)
 
 	/* Advisory flags (version 10) */
 	ceph_encode_32(&p, arg->flags);
-
-	ceph_con_send(&arg->session->s_con, msg);
-	return 0;
 }
 
 /*
@@ -1456,22 +1446,24 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
  */
 static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 {
+	struct ceph_msg *msg;
 	struct inode *inode = &ci->vfs_inode;
-	int ret;
 
-	ret = send_cap_msg(arg);
-	if (ret < 0) {
-		pr_err("error sending cap msg, ino (%llx.%llx) "
-		       "flushing %s tid %llu, requeue\n",
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, CAP_MSG_SIZE, GFP_NOFS, false);
+	if (!msg) {
+		pr_err("error allocating cap msg: ino (%llx.%llx) "
+		       "flushing %s tid %llu, requeuing cap.\n",
 		       ceph_vinop(inode), ceph_cap_string(arg->dirty),
 		       arg->flush_tid);
 		spin_lock(&ci->i_ceph_lock);
 		__cap_delay_requeue(arg->session->s_mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
+		return;
 	}
 
+	marshal_cap_msg(msg, arg);
+	ceph_con_send(&arg->session->s_con, msg);
 	ceph_buffer_put(arg->old_xattr_buf);
-
 	if (arg->wake)
 		wake_up_all(&ci->i_cap_wq);
 }
@@ -1482,6 +1474,11 @@ static inline int __send_flush_snap(struct inode *inode,
 				    u32 mseq, u64 oldest_flush_tid)
 {
 	struct cap_msg_args	arg;
+	struct ceph_msg		*msg;
+
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, CAP_MSG_SIZE, GFP_NOFS, false);
+	if (!msg)
+		return -ENOMEM;
 
 	arg.session = session;
 	arg.ino = ceph_vino(inode).ino;
@@ -1520,7 +1517,9 @@ static inline int __send_flush_snap(struct inode *inode,
 	arg.flags = 0;
 	arg.wake = false;
 
-	return send_cap_msg(&arg);
+	marshal_cap_msg(msg, &arg);
+	ceph_con_send(&arg.session->s_con, msg);
+	return 0;
 }
 
 /*
-- 
2.26.2

