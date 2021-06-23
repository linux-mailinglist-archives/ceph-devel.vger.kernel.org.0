Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF153B1D5B
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Jun 2021 17:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhFWPQX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Jun 2021 11:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhFWPQW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Jun 2021 11:16:22 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC8BC061574
        for <ceph-devel@vger.kernel.org>; Wed, 23 Jun 2021 08:14:04 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bg14so4558558ejb.9
        for <ceph-devel@vger.kernel.org>; Wed, 23 Jun 2021 08:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cbUqaBxZ9wZuVRZ3+oCvrrB6jrnmFLDluxmtsU0p4Nc=;
        b=deXYeM00rKR8A0AfiO+5Mp2R3eFhRIoP9DnBw7awBqZ1TjUkELaw1EvO73J9fVnRvR
         uMHOVIGsvWE+FW8rqXxmkg9w+1DCF8AvWyOe4BkAbh4nHbqc4l6YmjzPdBXqlcLr2c2d
         1Ycs9tm28I8MCAFLC17jXteidU+M6ev/lAACFnhOGKXgmPlwotqNK3wCxXwuhKCSVGuP
         eUCDiFcg8uiWD8n3z+XtVHOd0HJBGKvI4Rg2VhrEK5u5Nck6SgFAn2TvuHl3gh9qYymi
         BuqHnF6zmcJMLp4aGdgYcKL7HB0BWGXcqHg1wERbby8u+B6yf240WGEpnsqcJcT1M+Rl
         xlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cbUqaBxZ9wZuVRZ3+oCvrrB6jrnmFLDluxmtsU0p4Nc=;
        b=Vc0ILJr5eDepbrru8+F7RC/9wrxY3D76eIht4JYZ73fT8HA29W5xFpHlH6ngQzwkn6
         ObpOA/r+loctypbigJVyys23GTDwHZ/TL9b/XUdgfxsVQnDwnTEo55FuSABdHMZ6+LeM
         WSCGRb8ccqWBUenNG68r8ZEekWPUo51B5zER3AAQ5HW7DfizQUVOw/qveUOFHlrAgx1J
         p5Q2/3a9o2CTqedhla0C+zHzArhQA/bjCWmQxjAomwCr7w3XRIIg+yEX2nDbZiK/vwkX
         i04IqMU8wjQDDpJM1DqkmVGkp7Tzn2hce5vWSKc9BRoQOWyjGN3WMamdnlqCsB9cjFB7
         V2Og==
X-Gm-Message-State: AOAM530YPo2XtMU7CdTYCh03rLVh8ZmfYGrDlf8ps84mPOjz+9m/o0u1
        53AYRM2DL2//63GNt/CoPFEzjkIkxxx/lQ==
X-Google-Smtp-Source: ABdhPJy5zLEz5wTtC7co7qJ1g6lRxjyhzsk4lJTDi/LWKjKD0EEH0YXfnigr1buCFA5HYVFnGfe3Iw==
X-Received: by 2002:a17:906:a0a:: with SMTP id w10mr535410ejf.416.1624461243171;
        Wed, 23 Jun 2021 08:14:03 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id l22sm199841edr.15.2021.06.23.08.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:14:02 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Sage Weil <sage@redhat.com>
Subject: [PATCH] libceph: set global_id as soon as we get an auth ticket
Date:   Wed, 23 Jun 2021 17:13:52 +0200
Message-Id: <20210623151352.18840-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Commit 61ca49a9105f ("libceph: don't set global_id until we get an
auth ticket") delayed the setting of global_id too much.  It is set
only after all tickets are received, but in pre-nautilus clusters an
auth ticket and the service tickets are obtained in separate steps
(for a total of three MAuth replies).  When the service tickets are
requested, global_id is used to build an authorizer; if global_id is
still 0 we never get them and fail to establish the session.

Moving the setting of global_id into protocol implementations.  This
way global_id can be set exactly when an auth ticket is received, not
sooner nor later.

Fixes: 61ca49a9105f ("libceph: don't set global_id until we get an auth ticket")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/auth.h |  4 +++-
 net/ceph/auth.c           | 13 +++++--------
 net/ceph/auth_none.c      |  3 ++-
 net/ceph/auth_x.c         | 11 ++++++-----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
index 39425e2f7cb2..6b138fa97db8 100644
--- a/include/linux/ceph/auth.h
+++ b/include/linux/ceph/auth.h
@@ -50,7 +50,7 @@ struct ceph_auth_client_ops {
 	 * another request.
 	 */
 	int (*build_request)(struct ceph_auth_client *ac, void *buf, void *end);
-	int (*handle_reply)(struct ceph_auth_client *ac,
+	int (*handle_reply)(struct ceph_auth_client *ac, u64 global_id,
 			    void *buf, void *end, u8 *session_key,
 			    int *session_key_len, u8 *con_secret,
 			    int *con_secret_len);
@@ -104,6 +104,8 @@ struct ceph_auth_client {
 	struct mutex mutex;
 };
 
+void ceph_auth_set_global_id(struct ceph_auth_client *ac, u64 global_id);
+
 struct ceph_auth_client *ceph_auth_init(const char *name,
 					const struct ceph_crypto_key *key,
 					const int *con_modes);
diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index d07c8cd6cb46..d38c9eadbe2f 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -36,7 +36,7 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
 	}
 }
 
-static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
+void ceph_auth_set_global_id(struct ceph_auth_client *ac, u64 global_id)
 {
 	dout("%s global_id %llu\n", __func__, global_id);
 
@@ -262,7 +262,7 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 		goto out;
 	}
 
-	ret = ac->ops->handle_reply(ac, payload, payload_end,
+	ret = ac->ops->handle_reply(ac, global_id, payload, payload_end,
 				    NULL, NULL, NULL, NULL);
 	if (ret == -EAGAIN) {
 		ret = build_request(ac, true, reply_buf, reply_len);
@@ -271,8 +271,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 		goto out;
 	}
 
-	set_global_id(ac, global_id);
-
 out:
 	mutex_unlock(&ac->mutex);
 	return ret;
@@ -480,7 +478,7 @@ int ceph_auth_handle_reply_more(struct ceph_auth_client *ac, void *reply,
 	int ret;
 
 	mutex_lock(&ac->mutex);
-	ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
+	ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
 				    NULL, NULL, NULL, NULL);
 	if (ret == -EAGAIN)
 		ret = build_request(ac, false, buf, buf_len);
@@ -498,11 +496,10 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
 	int ret;
 
 	mutex_lock(&ac->mutex);
-	ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
+	ret = ac->ops->handle_reply(ac, global_id, reply, reply + reply_len,
 				    session_key, session_key_len,
 				    con_secret, con_secret_len);
-	if (!ret)
-		set_global_id(ac, global_id);
+	WARN_ON(ret == -EAGAIN || ret > 0);
 	mutex_unlock(&ac->mutex);
 	return ret;
 }
diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
index 533a2d85dbb9..77b5519bc45f 100644
--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -69,7 +69,7 @@ static int build_request(struct ceph_auth_client *ac, void *buf, void *end)
  * the generic auth code decode the global_id, and we carry no actual
  * authenticate state, so nothing happens here.
  */
-static int handle_reply(struct ceph_auth_client *ac,
+static int handle_reply(struct ceph_auth_client *ac, u64 global_id,
 			void *buf, void *end, u8 *session_key,
 			int *session_key_len, u8 *con_secret,
 			int *con_secret_len)
@@ -77,6 +77,7 @@ static int handle_reply(struct ceph_auth_client *ac,
 	struct ceph_auth_none_info *xi = ac->private;
 
 	xi->starting = false;
+	ceph_auth_set_global_id(ac, global_id);
 	return 0;
 }
 
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index cab99c5581b0..b71b1635916e 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -597,7 +597,7 @@ static int decode_con_secret(void **p, void *end, u8 *con_secret,
 	return -EINVAL;
 }
 
-static int handle_auth_session_key(struct ceph_auth_client *ac,
+static int handle_auth_session_key(struct ceph_auth_client *ac, u64 global_id,
 				   void **p, void *end,
 				   u8 *session_key, int *session_key_len,
 				   u8 *con_secret, int *con_secret_len)
@@ -613,6 +613,7 @@ static int handle_auth_session_key(struct ceph_auth_client *ac,
 	if (ret)
 		return ret;
 
+	ceph_auth_set_global_id(ac, global_id);
 	if (*p == end) {
 		/* pre-nautilus (or didn't request service tickets!) */
 		WARN_ON(session_key || con_secret);
@@ -661,7 +662,7 @@ static int handle_auth_session_key(struct ceph_auth_client *ac,
 	return -EINVAL;
 }
 
-static int ceph_x_handle_reply(struct ceph_auth_client *ac,
+static int ceph_x_handle_reply(struct ceph_auth_client *ac, u64 global_id,
 			       void *buf, void *end,
 			       u8 *session_key, int *session_key_len,
 			       u8 *con_secret, int *con_secret_len)
@@ -695,9 +696,9 @@ static int ceph_x_handle_reply(struct ceph_auth_client *ac,
 	switch (op) {
 	case CEPHX_GET_AUTH_SESSION_KEY:
 		/* AUTH ticket + [connection secret] + service tickets */
-		ret = handle_auth_session_key(ac, &p, end, session_key,
-					      session_key_len, con_secret,
-					      con_secret_len);
+		ret = handle_auth_session_key(ac, global_id, &p, end,
+					      session_key, session_key_len,
+					      con_secret, con_secret_len);
 		break;
 
 	case CEPHX_GET_PRINCIPAL_SESSION_KEY:
-- 
2.19.2

