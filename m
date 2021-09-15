Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EE840C663
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Sep 2021 15:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhION2S (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Sep 2021 09:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233440AbhION2R (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 09:28:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F40A610FF;
        Wed, 15 Sep 2021 13:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631712419;
        bh=iTGtJ7nVVzZtI0v+6xan//G8RjfZsvHWuZ/IQTYQfaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUTQSsMOeeSUb89vWm5mZFp3kRdGJCWLBQjwd7cSBJ9/l3By4VP+MDv4Lt9TZfvJC
         sxk85akmaoar+WodHmRFnApp38uBtNojta3EZhBiOkjYBz7yISJzcc5UmZ9usg+NKV
         nhF9mmNZR+dTsZtFleXM49/Krn+e1NjuEXzMQS8YKhNX0WfCS0DLKiuuacCkHm62X+
         SmqAtxq62OF4CxK/yfP2Xit20Zz+l/mvteZNpyrhrVBCU1RUb00EB+7XfhelUSJ3pS
         eYGhX/oTpO8W4MdcYt/F04lmI96x1+kYBV/6LA1Xp8lUPprjKvj5KdTdQ+zIa25Jn5
         xdEkyyF1zaHpA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, mnelson@redhat.com
Subject: [RFC PATCH 1/2] libceph: defer clearing standby state to work function
Date:   Wed, 15 Sep 2021 09:26:55 -0400
Message-Id: <20210915132656.30347-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915132656.30347-1-jlayton@kernel.org>
References: <20210915132656.30347-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In both cases where we call clear_standby, we queue the workqueue job
just afterward.

Add a new flag and to the con and set that instead of calling
clear_standby immediately.  When the workqueue job runs, test_and_clear
the flag and call clear_standby if it was set.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  1 +
 net/ceph/messenger.c           | 32 ++++++++++++++++++--------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index c9675ee33f51..0a455b05f17e 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -284,6 +284,7 @@ struct ceph_msg {
 #define CEPH_CON_F_SOCK_CLOSED		3  /* socket state changed to closed */
 #define CEPH_CON_F_BACKOFF		4  /* need to retry queuing delayed
 					      work */
+#define CEPH_CON_F_CLEAR_STANDBY	5  /* clear standby state */
 
 /* ceph connection fault delay defaults, for exponential backoff */
 #define BASE_DELAY_INTERVAL	(HZ / 4)
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index c93d103fe343..d14ff578cace 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -90,6 +90,7 @@ static bool con_flag_valid(unsigned long con_flag)
 	case CEPH_CON_F_WRITE_PENDING:
 	case CEPH_CON_F_SOCK_CLOSED:
 	case CEPH_CON_F_BACKOFF:
+	case CEPH_CON_F_CLEAR_STANDBY:
 		return true;
 	default:
 		return false;
@@ -1488,6 +1489,18 @@ static void con_fault_finish(struct ceph_connection *con)
 		con->ops->fault(con);
 }
 
+static void clear_standby(struct ceph_connection *con)
+{
+	/* come back from STANDBY? */
+	if (con->state == CEPH_CON_S_STANDBY) {
+		dout("clear_standby %p and ++connect_seq\n", con);
+		con->state = CEPH_CON_S_PREOPEN;
+		con->v1.connect_seq++;
+		WARN_ON(ceph_con_flag_test(con, CEPH_CON_F_WRITE_PENDING));
+		WARN_ON(ceph_con_flag_test(con, CEPH_CON_F_KEEPALIVE_PENDING));
+	}
+}
+
 /*
  * Do some work on a connection.  Drop a connection ref when we're done.
  */
@@ -1498,6 +1511,9 @@ static void ceph_con_workfn(struct work_struct *work)
 	bool fault;
 
 	mutex_lock(&con->mutex);
+	if (ceph_con_flag_test_and_clear(con, CEPH_CON_F_CLEAR_STANDBY))
+		clear_standby(con);
+
 	while (true) {
 		int ret;
 
@@ -1663,18 +1679,6 @@ static void msg_con_set(struct ceph_msg *msg, struct ceph_connection *con)
 	BUG_ON(msg->con != con);
 }
 
-static void clear_standby(struct ceph_connection *con)
-{
-	/* come back from STANDBY? */
-	if (con->state == CEPH_CON_S_STANDBY) {
-		dout("clear_standby %p and ++connect_seq\n", con);
-		con->state = CEPH_CON_S_PREOPEN;
-		con->v1.connect_seq++;
-		WARN_ON(ceph_con_flag_test(con, CEPH_CON_F_WRITE_PENDING));
-		WARN_ON(ceph_con_flag_test(con, CEPH_CON_F_KEEPALIVE_PENDING));
-	}
-}
-
 /*
  * Queue up an outgoing message on the given connection.
  *
@@ -1707,7 +1711,7 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 	     le32_to_cpu(msg->hdr.middle_len),
 	     le32_to_cpu(msg->hdr.data_len));
 
-	clear_standby(con);
+	ceph_con_flag_set(con, CEPH_CON_F_CLEAR_STANDBY);
 	mutex_unlock(&con->mutex);
 
 	/* if there wasn't anything waiting to send before, queue
@@ -1793,8 +1797,8 @@ void ceph_con_keepalive(struct ceph_connection *con)
 {
 	dout("con_keepalive %p\n", con);
 	mutex_lock(&con->mutex);
-	clear_standby(con);
 	ceph_con_flag_set(con, CEPH_CON_F_KEEPALIVE_PENDING);
+	ceph_con_flag_set(con, CEPH_CON_F_CLEAR_STANDBY);
 	mutex_unlock(&con->mutex);
 
 	if (!ceph_con_flag_test_and_set(con, CEPH_CON_F_WRITE_PENDING))
-- 
2.31.1

