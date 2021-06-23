Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780E83B1D55
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Jun 2021 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhFWPPS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Jun 2021 11:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFWPPR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Jun 2021 11:15:17 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFF3C061574
        for <ceph-devel@vger.kernel.org>; Wed, 23 Jun 2021 08:12:59 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s6so3932382edu.10
        for <ceph-devel@vger.kernel.org>; Wed, 23 Jun 2021 08:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MxGoroSQRg5u22gxfZ1MCQS2LwSHnnhjfeTo8ynOAr0=;
        b=pFDeUHqYGuTVn//RET0RtVklQa+x/toMIFFRBonN0Q62u2MXOiWjFOCiobC71dDFvf
         5KEHDiJRLCb5BQmzwpxZkAxuTFQsGCAsLz8MZz0Bh9aPJJtGQohoOse/DWpk4ttpDUyN
         QF0lvfkzGBOQDEXK7V0pXlVtnVnBK6D9pyqqswRlU3uPFTagCex7g9XnIDoIiQzBrCfj
         Wnl0OIW5+LIFo4OuDR522iGahn83NWVFHve8NF30Grb08Mg7fw1G3ZuxDsigfJvCHQjC
         74XjhNNrXOinfHzyfg3zDfGvuug6GzcL0UVGZ1eTcU5QxHBXs3AqbLbQrypXM1c2UAwF
         UArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MxGoroSQRg5u22gxfZ1MCQS2LwSHnnhjfeTo8ynOAr0=;
        b=J+VkWYjynfLJ69ToToekWPzTMF6b5Lst0lGHwmGyUsr88iS+le7z7j40qoe+1GP/GZ
         G00R0E/dXp5BZTgAs/XUODDF35Apf789n1ag3nDKQN+42cBhyDd0OoFfCXWXOnsYnxls
         QX2v9ZHi8KLBuEkutQbkaNWLOhxMTXSlM/XkCIUlOSMRAix4Qoyxvzbb1/vBv6Qfj+2v
         IEDN6n4dMNZr9pZknlV73QkGBXBHStadfp/kLqLs14qCGaQGcZc5sVwWlMCWkEcPTGvL
         T8Y2OqWuFc9yp51C9RImUJzjdE7iW0deKK+uWMAr/RYv2bxranzk0+8TbpWHn6qeC9lr
         cocg==
X-Gm-Message-State: AOAM531J+7whPR577az/tDm1A7QckgYiXNZknzuDnwdx+DlbOv+vpi/R
        41/KXchLRMuX3uW83f51GDdoBXGInF0clg==
X-Google-Smtp-Source: ABdhPJxQr3H8p+U9eaiFAu3OtF+PhgzRHypaxgJT7QBXTnycDBz4kRId8IA/VKZlrerFMnxpezxvJQ==
X-Received: by 2002:a05:6402:411:: with SMTP id q17mr181531edv.313.1624461177964;
        Wed, 23 Jun 2021 08:12:57 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id ce26sm46477ejc.4.2021.06.23.08.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:12:57 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Sage Weil <sage@redhat.com>
Subject: [PATCH] libceph: don't pass result into ac->ops->handle_reply()
Date:   Wed, 23 Jun 2021 17:12:47 +0200
Message-Id: <20210623151247.18734-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

There is no result to pass in msgr2 case because authentication
failures are reported through auth_bad_method frame and in MAuth
case an error is returned immediately.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/auth.h |  2 +-
 net/ceph/auth.c           | 15 ++++++++++-----
 net/ceph/auth_none.c      |  4 ++--
 net/ceph/auth_x.c         |  6 ++----
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
index 71b5d481c653..39425e2f7cb2 100644
--- a/include/linux/ceph/auth.h
+++ b/include/linux/ceph/auth.h
@@ -50,7 +50,7 @@ struct ceph_auth_client_ops {
 	 * another request.
 	 */
 	int (*build_request)(struct ceph_auth_client *ac, void *buf, void *end);
-	int (*handle_reply)(struct ceph_auth_client *ac, int result,
+	int (*handle_reply)(struct ceph_auth_client *ac,
 			    void *buf, void *end, u8 *session_key,
 			    int *session_key_len, u8 *con_secret,
 			    int *con_secret_len);
diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index b824a48a4c47..d07c8cd6cb46 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -255,14 +255,19 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 		ac->negotiating = false;
 	}
 
-	ret = ac->ops->handle_reply(ac, result, payload, payload_end,
+	if (result) {
+		pr_err("auth protocol '%s' mauth authentication failed: %d\n",
+		       ceph_auth_proto_name(ac->protocol), result);
+		ret = result;
+		goto out;
+	}
+
+	ret = ac->ops->handle_reply(ac, payload, payload_end,
 				    NULL, NULL, NULL, NULL);
 	if (ret == -EAGAIN) {
 		ret = build_request(ac, true, reply_buf, reply_len);
 		goto out;
 	} else if (ret) {
-		pr_err("auth protocol '%s' mauth authentication failed: %d\n",
-		       ceph_auth_proto_name(ac->protocol), result);
 		goto out;
 	}
 
@@ -475,7 +480,7 @@ int ceph_auth_handle_reply_more(struct ceph_auth_client *ac, void *reply,
 	int ret;
 
 	mutex_lock(&ac->mutex);
-	ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
+	ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
 				    NULL, NULL, NULL, NULL);
 	if (ret == -EAGAIN)
 		ret = build_request(ac, false, buf, buf_len);
@@ -493,7 +498,7 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
 	int ret;
 
 	mutex_lock(&ac->mutex);
-	ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
+	ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
 				    session_key, session_key_len,
 				    con_secret, con_secret_len);
 	if (!ret)
diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
index dbf22df10a85..533a2d85dbb9 100644
--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -69,7 +69,7 @@ static int build_request(struct ceph_auth_client *ac, void *buf, void *end)
  * the generic auth code decode the global_id, and we carry no actual
  * authenticate state, so nothing happens here.
  */
-static int handle_reply(struct ceph_auth_client *ac, int result,
+static int handle_reply(struct ceph_auth_client *ac,
 			void *buf, void *end, u8 *session_key,
 			int *session_key_len, u8 *con_secret,
 			int *con_secret_len)
@@ -77,7 +77,7 @@ static int handle_reply(struct ceph_auth_client *ac, int result,
 	struct ceph_auth_none_info *xi = ac->private;
 
 	xi->starting = false;
-	return result;
+	return 0;
 }
 
 static void ceph_auth_none_destroy_authorizer(struct ceph_authorizer *a)
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index 79641c4afee9..cab99c5581b0 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -661,7 +661,7 @@ static int handle_auth_session_key(struct ceph_auth_client *ac,
 	return -EINVAL;
 }
 
-static int ceph_x_handle_reply(struct ceph_auth_client *ac, int result,
+static int ceph_x_handle_reply(struct ceph_auth_client *ac,
 			       void *buf, void *end,
 			       u8 *session_key, int *session_key_len,
 			       u8 *con_secret, int *con_secret_len)
@@ -669,13 +669,11 @@ static int ceph_x_handle_reply(struct ceph_auth_client *ac, int result,
 	struct ceph_x_info *xi = ac->private;
 	struct ceph_x_ticket_handler *th;
 	int len = end - buf;
+	int result;
 	void *p;
 	int op;
 	int ret;
 
-	if (result)
-		return result;  /* XXX hmm? */
-
 	if (xi->starting) {
 		/* it's a hello */
 		struct ceph_x_server_challenge *sc = buf;
-- 
2.19.2

