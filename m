Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C81E40C664
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Sep 2021 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhION2T (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Sep 2021 09:28:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233612AbhION2S (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 09:28:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3904C61247;
        Wed, 15 Sep 2021 13:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631712419;
        bh=JqinzSvxFEOcqMrRbSmB935l22a2vBjFqpWuWEHBfWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgycvFKIXgsl2qm1pAxlbBVH6/RhS8mf/L48zkH7uuP4eW/RWR/4XjCwLVpICrEm8
         NDEZTFBPs7vZkecTarZPLJjARNpLYmqXsp6+13umlVQrSWPQVcFsz0z/dnCmaBzqC/
         Yj4gyhUvfhXi0qzb52Qa/iOhjBb3RJZCRi5yfGxv+XYubYsMmjD2e/WKX5A2UAUmSl
         HwXor+Dt/vHLI3Q8/8tqtZlVJDYNYW6YnbhbrWb6yI0ekVYxpKXz32zq9HSpmPcyya
         1ZFYL11PVhg0K3/sDcBZySHNrVxUzMbKKVJ3DgNsnATGutip5z1Aw9bU5Dx8+zZ25X
         J3wXuyOrE/voA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, mnelson@redhat.com
Subject: [RFC PATCH 2/2] libceph: allow tasks to submit messages without taking con->mutex
Date:   Wed, 15 Sep 2021 09:26:56 -0400
Message-Id: <20210915132656.30347-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915132656.30347-1-jlayton@kernel.org>
References: <20210915132656.30347-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, the out_queue is protected by the con->mutex. ceph_con_send
takes the mutex but just does some in-memory operations, followed by
kicking the workqueue job to do the actual send. This means that while
the workqueue job is operating, any task that wants to send a new
message will end up blocked.

Given that none of ceph_con_send's operations aside from the mutex
acquisition will block, we should be able to allow tasks to submit new
messages under a spinlock rather than taking the mutex, which should
reduce this contention and (hopefully) improve throughput for both
cephfs and rbd in highly contended situations.

Add a new spinlock to protect the out_queue, and ensure we take it while
holding the con->mutex when accessing the out_queue. Stop taking the
con->mutex in ceph_con_send, and instead just take the spinlock around
the list_add to the out_queue.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  1 +
 net/ceph/messenger.c           | 16 +++++++++++-----
 net/ceph/messenger_v1.c        | 35 +++++++++++++++++-----------------
 net/ceph/messenger_v2.c        |  5 +++++
 4 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 0a455b05f17e..155dd8a8e8ce 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -448,6 +448,7 @@ struct ceph_connection {
 	struct mutex mutex;
 
 	/* out queue */
+	spinlock_t out_queue_lock; /* protects out_queue */
 	struct list_head out_queue;
 	struct list_head out_sent;   /* sending or sent but unacked */
 	u64 out_seq;		     /* last message queued for send */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d14ff578cace..b539d3359ef4 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -633,6 +633,7 @@ void ceph_con_init(struct ceph_connection *con, void *private,
 	con_sock_state_init(con);
 
 	mutex_init(&con->mutex);
+	spin_lock_init(&con->out_queue_lock);
 	INIT_LIST_HEAD(&con->out_queue);
 	INIT_LIST_HEAD(&con->out_sent);
 	INIT_DELAYED_WORK(&con->work, ceph_con_workfn);
@@ -691,6 +692,7 @@ void ceph_con_discard_requeued(struct ceph_connection *con, u64 reconnect_seq)
 	u64 seq;
 
 	dout("%s con %p reconnect_seq %llu\n", __func__, con, reconnect_seq);
+	spin_lock(&con->out_queue_lock);
 	while (!list_empty(&con->out_queue)) {
 		msg = list_first_entry(&con->out_queue, struct ceph_msg,
 				       list_head);
@@ -704,6 +706,7 @@ void ceph_con_discard_requeued(struct ceph_connection *con, u64 reconnect_seq)
 		     msg, seq);
 		ceph_msg_remove(msg);
 	}
+	spin_unlock(&con->out_queue_lock);
 }
 
 #ifdef CONFIG_BLOCK
@@ -1601,16 +1604,19 @@ static void con_fault(struct ceph_connection *con)
 	}
 
 	/* Requeue anything that hasn't been acked */
+	spin_lock(&con->out_queue_lock);
 	list_splice_init(&con->out_sent, &con->out_queue);
 
 	/* If there are no messages queued or keepalive pending, place
 	 * the connection in a STANDBY state */
 	if (list_empty(&con->out_queue) &&
 	    !ceph_con_flag_test(con, CEPH_CON_F_KEEPALIVE_PENDING)) {
+		spin_unlock(&con->out_queue_lock);
 		dout("fault %p setting STANDBY clearing WRITE_PENDING\n", con);
 		ceph_con_flag_clear(con, CEPH_CON_F_WRITE_PENDING);
 		con->state = CEPH_CON_S_STANDBY;
 	} else {
+		spin_unlock(&con->out_queue_lock);
 		/* retry after a delay. */
 		con->state = CEPH_CON_S_PREOPEN;
 		if (!con->delay) {
@@ -1691,19 +1697,18 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 	BUG_ON(msg->front.iov_len != le32_to_cpu(msg->hdr.front_len));
 	msg->needs_out_seq = true;
 
-	mutex_lock(&con->mutex);
-
-	if (con->state == CEPH_CON_S_CLOSED) {
+	if (READ_ONCE(con->state) == CEPH_CON_S_CLOSED) {
 		dout("con_send %p closed, dropping %p\n", con, msg);
 		ceph_msg_put(msg);
-		mutex_unlock(&con->mutex);
 		return;
 	}
 
 	msg_con_set(msg, con);
 
 	BUG_ON(!list_empty(&msg->list_head));
+	spin_lock(&con->out_queue_lock);
 	list_add_tail(&msg->list_head, &con->out_queue);
+	spin_unlock(&con->out_queue_lock);
 	dout("----- %p to %s%lld %d=%s len %d+%d+%d -----\n", msg,
 	     ENTITY_NAME(con->peer_name), le16_to_cpu(msg->hdr.type),
 	     ceph_msg_type_name(le16_to_cpu(msg->hdr.type)),
@@ -1712,7 +1717,6 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 	     le32_to_cpu(msg->hdr.data_len));
 
 	ceph_con_flag_set(con, CEPH_CON_F_CLEAR_STANDBY);
-	mutex_unlock(&con->mutex);
 
 	/* if there wasn't anything waiting to send before, queue
 	 * new work */
@@ -2058,6 +2062,8 @@ void ceph_con_get_out_msg(struct ceph_connection *con)
 {
 	struct ceph_msg *msg;
 
+	lockdep_assert_held(&con->out_queue_lock);
+
 	BUG_ON(list_empty(&con->out_queue));
 	msg = list_first_entry(&con->out_queue, struct ceph_msg, list_head);
 	WARN_ON(msg->con != con);
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 2cb5ffdf071a..db864be73b60 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -194,25 +194,9 @@ static void prepare_write_message_footer(struct ceph_connection *con)
  */
 static void prepare_write_message(struct ceph_connection *con)
 {
-	struct ceph_msg *m;
+	struct ceph_msg *m = con->out_msg;
 	u32 crc;
 
-	con_out_kvec_reset(con);
-	con->v1.out_msg_done = false;
-
-	/* Sneak an ack in there first?  If we can get it into the same
-	 * TCP packet that's a good thing. */
-	if (con->in_seq > con->in_seq_acked) {
-		con->in_seq_acked = con->in_seq;
-		con_out_kvec_add(con, sizeof (tag_ack), &tag_ack);
-		con->v1.out_temp_ack = cpu_to_le64(con->in_seq_acked);
-		con_out_kvec_add(con, sizeof(con->v1.out_temp_ack),
-			&con->v1.out_temp_ack);
-	}
-
-	ceph_con_get_out_msg(con);
-	m = con->out_msg;
-
 	dout("prepare_write_message %p seq %lld type %d len %d+%d+%zd\n",
 	     m, con->out_seq, le16_to_cpu(m->hdr.type),
 	     le32_to_cpu(m->hdr.front_len), le32_to_cpu(m->hdr.middle_len),
@@ -1427,10 +1411,27 @@ int ceph_con_v1_try_write(struct ceph_connection *con)
 			goto more;
 		}
 		/* is anything else pending? */
+		spin_lock(&con->out_queue_lock);
 		if (!list_empty(&con->out_queue)) {
+			con_out_kvec_reset(con);
+			con->v1.out_msg_done = false;
+
+			/* Sneak an ack in there first?  If we can get it into the same
+			 * TCP packet that's a good thing. */
+			if (con->in_seq > con->in_seq_acked) {
+				con->in_seq_acked = con->in_seq;
+				con_out_kvec_add(con, sizeof (tag_ack), &tag_ack);
+				con->v1.out_temp_ack = cpu_to_le64(con->in_seq_acked);
+				con_out_kvec_add(con, sizeof(con->v1.out_temp_ack),
+						 &con->v1.out_temp_ack);
+			}
+
+			ceph_con_get_out_msg(con);
+			spin_unlock(&con->out_queue_lock);
 			prepare_write_message(con);
 			goto more;
 		}
+		spin_unlock(&con->out_queue_lock);
 		if (con->in_seq > con->in_seq_acked) {
 			prepare_write_ack(con);
 			goto more;
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index cc40ce4e02fb..1a1c2c282120 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -3001,7 +3001,9 @@ static int populate_out_iter(struct ceph_connection *con)
 	}
 
 	WARN_ON(con->v2.out_state != OUT_S_GET_NEXT);
+	spin_lock(&con->out_queue_lock);
 	if (ceph_con_flag_test_and_clear(con, CEPH_CON_F_KEEPALIVE_PENDING)) {
+		spin_unlock(&con->out_queue_lock);
 		ret = prepare_keepalive2(con);
 		if (ret) {
 			pr_err("prepare_keepalive2 failed: %d\n", ret);
@@ -3009,18 +3011,21 @@ static int populate_out_iter(struct ceph_connection *con)
 		}
 	} else if (!list_empty(&con->out_queue)) {
 		ceph_con_get_out_msg(con);
+		spin_unlock(&con->out_queue_lock);
 		ret = prepare_message(con);
 		if (ret) {
 			pr_err("prepare_message failed: %d\n", ret);
 			return ret;
 		}
 	} else if (con->in_seq > con->in_seq_acked) {
+		spin_unlock(&con->out_queue_lock);
 		ret = prepare_ack(con);
 		if (ret) {
 			pr_err("prepare_ack failed: %d\n", ret);
 			return ret;
 		}
 	} else {
+		spin_unlock(&con->out_queue_lock);
 		goto nothing_pending;
 	}
 
-- 
2.31.1

