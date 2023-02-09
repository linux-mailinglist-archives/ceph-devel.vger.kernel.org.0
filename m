Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F90D6906CA
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Feb 2023 12:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjBILUo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Feb 2023 06:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjBILT7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Feb 2023 06:19:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C91E6A71A;
        Thu,  9 Feb 2023 03:17:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CB4361A22;
        Thu,  9 Feb 2023 11:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163A3C433A4;
        Thu,  9 Feb 2023 11:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941448;
        bh=uNI3u5CQRuvGQjo23KX+Yf6Qs08aWCjpPQxuw2T5mEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYxTLK+hgTuUnFZ+jET2cvazc7xaNNglqcESwXEkvEpfFs1EJrgl9binoTUfAgzXf
         tlwYLCi9inSDsV3v3Q6aMthQu0xp7LWzo22XnzKFQEYo6HeCo/+cF2R+KCvCmIrZSo
         K/Zo5yOAdd/gRe59Xcj9vnTENXpjhJcrt8w9gZVGqZzchWhyXWd3EfEJNflgzRdtHr
         UjumGbebbMGp0PtAMk2Gc7QJCA3XAkFzDGAOMemyXwbi5CwWoBBXet+48tZdozdrOU
         /Ydfh5YrgnKksCvOtD6WW7mkC2kp0BAYY32N+vvcuz9FvhBTN4arRwwLpGKFwM7mCy
         rqhZBPI8JIuTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Venky Shankar <vshankar@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 38/38] ceph: blocklist the kclient when receiving corrupted snap trace
Date:   Thu,  9 Feb 2023 06:14:57 -0500
Message-Id: <20230209111459.1891941-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit a68e564adcaa69b0930809fb64d9d5f7d9c32ba9 ]

When received corrupted snap trace we don't know what exactly has
happened in MDS side. And we shouldn't continue IOs and metadatas
access to MDS, which may corrupt or get incorrect contents.

This patch will just block all the further IO/MDS requests
immediately and then evict the kclient itself.

The reason why we still need to evict the kclient just after
blocking all the further IOs is that the MDS could revoke the caps
faster.

Link: https://tracker.ceph.com/issues/57686
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c       | 17 +++++++++++++++--
 fs/ceph/caps.c       | 16 +++++++++++++---
 fs/ceph/file.c       |  3 +++
 fs/ceph/mds_client.c | 30 +++++++++++++++++++++++++++---
 fs/ceph/snap.c       | 36 ++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h      |  1 +
 6 files changed, 93 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index dcf701b05cc1c..b6737ee920b22 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -305,7 +305,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_osd_request *req;
+	struct ceph_osd_request *req = NULL;
 	struct ceph_vino vino = ceph_vino(inode);
 	struct iov_iter iter;
 	struct page **pages;
@@ -313,6 +313,11 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	int err = 0;
 	u64 len = subreq->len;
 
+	if (ceph_inode_is_shutdown(inode)) {
+		err = -EIO;
+		goto out;
+	}
+
 	if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
 		return;
 
@@ -563,6 +568,9 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 
 	dout("writepage %p idx %lu\n", page, page->index);
 
+	if (ceph_inode_is_shutdown(inode))
+		return -EIO;
+
 	/* verify this is a writeable snap context */
 	snapc = page_snap_context(page);
 	if (!snapc) {
@@ -1643,7 +1651,7 @@ int ceph_uninline_data(struct file *file)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req = NULL;
-	struct ceph_cap_flush *prealloc_cf;
+	struct ceph_cap_flush *prealloc_cf = NULL;
 	struct folio *folio = NULL;
 	u64 inline_version = CEPH_INLINE_NONE;
 	struct page *pages[1];
@@ -1657,6 +1665,11 @@ int ceph_uninline_data(struct file *file)
 	dout("uninline_data %p %llx.%llx inline_version %llu\n",
 	     inode, ceph_vinop(inode), inline_version);
 
+	if (ceph_inode_is_shutdown(inode)) {
+		err = -EIO;
+		goto out;
+	}
+
 	if (inline_version == CEPH_INLINE_NONE)
 		return 0;
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index cd69bf267d1b1..795fd6d84bde0 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4081,6 +4081,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	void *p, *end;
 	struct cap_extra_info extra_info = {};
 	bool queue_trunc;
+	bool close_sessions = false;
 
 	dout("handle_caps from mds%d\n", session->s_mds);
 
@@ -4218,9 +4219,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		realm = NULL;
 		if (snaptrace_len) {
 			down_write(&mdsc->snap_rwsem);
-			ceph_update_snap_trace(mdsc, snaptrace,
-					       snaptrace + snaptrace_len,
-					       false, &realm);
+			if (ceph_update_snap_trace(mdsc, snaptrace,
+						   snaptrace + snaptrace_len,
+						   false, &realm)) {
+				up_write(&mdsc->snap_rwsem);
+				close_sessions = true;
+				goto done;
+			}
 			downgrade_write(&mdsc->snap_rwsem);
 		} else {
 			down_read(&mdsc->snap_rwsem);
@@ -4280,6 +4285,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	iput(inode);
 out:
 	ceph_put_string(extra_info.pool_ns);
+
+	/* Defer closing the sessions after s_mutex lock being released */
+	if (close_sessions)
+		ceph_mdsc_close_sessions(mdsc);
+
 	return;
 
 flush_cap_releases:
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 04fd34557de84..ecdd64780e8cd 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2004,6 +2004,9 @@ static int ceph_zero_partial_object(struct inode *inode,
 	loff_t zero = 0;
 	int op;
 
+	if (ceph_inode_is_shutdown(inode))
+		return -EIO;
+
 	if (!length) {
 		op = offset ? CEPH_OSD_OP_DELETE : CEPH_OSD_OP_TRUNCATE;
 		length = &zero;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 26a0a8b9975ef..e163f58ff3c50 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -806,6 +806,9 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 {
 	struct ceph_mds_session *s;
 
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return ERR_PTR(-EIO);
+
 	if (mds >= mdsc->mdsmap->possible_max_rank)
 		return ERR_PTR(-EINVAL);
 
@@ -1478,6 +1481,9 @@ static int __open_session(struct ceph_mds_client *mdsc,
 	int mstate;
 	int mds = session->s_mds;
 
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return -EIO;
+
 	/* wait for mds to go active? */
 	mstate = ceph_mdsmap_get_state(mdsc->mdsmap, mds);
 	dout("open_session to mds%d (%s)\n", mds,
@@ -2860,6 +2866,11 @@ static void __do_request(struct ceph_mds_client *mdsc,
 		return;
 	}
 
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
+		dout("do_request metadata corrupted\n");
+		err = -EIO;
+		goto finish;
+	}
 	if (req->r_timeout &&
 	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {
 		dout("do_request timed out\n");
@@ -3245,6 +3256,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	u64 tid;
 	int err, result;
 	int mds = session->s_mds;
+	bool close_sessions = false;
 
 	if (msg->front.iov_len < sizeof(*head)) {
 		pr_err("mdsc_handle_reply got corrupt (short) reply\n");
@@ -3351,10 +3363,17 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	realm = NULL;
 	if (rinfo->snapblob_len) {
 		down_write(&mdsc->snap_rwsem);
-		ceph_update_snap_trace(mdsc, rinfo->snapblob,
+		err = ceph_update_snap_trace(mdsc, rinfo->snapblob,
 				rinfo->snapblob + rinfo->snapblob_len,
 				le32_to_cpu(head->op) == CEPH_MDS_OP_RMSNAP,
 				&realm);
+		if (err) {
+			up_write(&mdsc->snap_rwsem);
+			close_sessions = true;
+			if (err == -EIO)
+				ceph_msg_dump(msg);
+			goto out_err;
+		}
 		downgrade_write(&mdsc->snap_rwsem);
 	} else {
 		down_read(&mdsc->snap_rwsem);
@@ -3412,6 +3431,10 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 				     req->r_end_latency, err);
 out:
 	ceph_mdsc_put_request(req);
+
+	/* Defer closing the sessions after s_mutex lock being released */
+	if (close_sessions)
+		ceph_mdsc_close_sessions(mdsc);
 	return;
 }
 
@@ -5011,7 +5034,7 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
 }
 
 /*
- * called after sb is ro.
+ * called after sb is ro or when metadata corrupted.
  */
 void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 {
@@ -5301,7 +5324,8 @@ static void mds_peer_reset(struct ceph_connection *con)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 
 	pr_warn("mds%d closed our session\n", s->s_mds);
-	send_mds_reconnect(mdsc, s);
+	if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO)
+		send_mds_reconnect(mdsc, s);
 }
 
 static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index e4151852184e0..87007203f130e 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/ceph/ceph_debug.h>
 
+#include <linux/fs.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
 #include <linux/iversion.h>
@@ -766,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
+	struct ceph_client *client = mdsc->fsc->client;
 	int rebuild_snapcs;
 	int err = -ENOMEM;
+	int ret;
 	LIST_HEAD(dirty_realms);
 
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
@@ -884,6 +887,27 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	if (first_realm)
 		ceph_put_snap_realm(mdsc, first_realm);
 	pr_err("%s error %d\n", __func__, err);
+
+	/*
+	 * When receiving a corrupted snap trace we don't know what
+	 * exactly has happened in MDS side. And we shouldn't continue
+	 * writing to OSD, which may corrupt the snapshot contents.
+	 *
+	 * Just try to blocklist this kclient and then this kclient
+	 * must be remounted to continue after the corrupted metadata
+	 * fixed in the MDS side.
+	 */
+	WRITE_ONCE(mdsc->fsc->mount_state, CEPH_MOUNT_FENCE_IO);
+	ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
+	if (ret)
+		pr_err("%s failed to blocklist %s: %d\n", __func__,
+		       ceph_pr_addr(&client->msgr.inst.addr), ret);
+
+	WARN(1, "%s: %s%sdo remount to continue%s",
+	     __func__, ret ? "" : ceph_pr_addr(&client->msgr.inst.addr),
+	     ret ? "" : " was blocklisted, ",
+	     err == -EIO ? " after corrupted snaptrace is fixed" : "");
+
 	return err;
 }
 
@@ -984,6 +1008,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	__le64 *split_inos = NULL, *split_realms = NULL;
 	int i;
 	int locked_rwsem = 0;
+	bool close_sessions = false;
 
 	/* decode */
 	if (msg->front.iov_len < sizeof(*h))
@@ -1092,8 +1117,12 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	 * update using the provided snap trace. if we are deleting a
 	 * snap, we can avoid queueing cap_snaps.
 	 */
-	ceph_update_snap_trace(mdsc, p, e,
-			       op == CEPH_SNAP_OP_DESTROY, NULL);
+	if (ceph_update_snap_trace(mdsc, p, e,
+				   op == CEPH_SNAP_OP_DESTROY,
+				   NULL)) {
+		close_sessions = true;
+		goto bad;
+	}
 
 	if (op == CEPH_SNAP_OP_SPLIT)
 		/* we took a reference when we created the realm, above */
@@ -1112,6 +1141,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 out:
 	if (locked_rwsem)
 		up_write(&mdsc->snap_rwsem);
+
+	if (close_sessions)
+		ceph_mdsc_close_sessions(mdsc);
 	return;
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 735279b2ceb55..3599fefa91f99 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -108,6 +108,7 @@ enum {
 	CEPH_MOUNT_UNMOUNTED,
 	CEPH_MOUNT_SHUTDOWN,
 	CEPH_MOUNT_RECOVER,
+	CEPH_MOUNT_FENCE_IO,
 };
 
 #define CEPH_ASYNC_CREATE_CONFLICT_BITS 8
-- 
2.39.0

