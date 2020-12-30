Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679512E7B97
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Dec 2020 18:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgL3Rcl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Dec 2020 12:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgL3Rcl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Dec 2020 12:32:41 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC9DC061575
        for <ceph-devel@vger.kernel.org>; Wed, 30 Dec 2020 09:32:01 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id j22so22675830eja.13
        for <ceph-devel@vger.kernel.org>; Wed, 30 Dec 2020 09:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1/jkr+Dc99L/1x2jX+YALoe7r32aPFZgQbZy+mRa6jU=;
        b=YXq9D2CRCxrxRyzBuPEKHota/b3IkOIynUaUACo7nOoWEy8k194cUMWxpYqeg7wMWz
         RMhHUYFidQyWn7Fz89XDQc4usyBwfX9FhFD8pdGAYu85Jmub5Z8IvSIdCP80O9GTa2Nn
         gTDt71s2jmrnTuL7FUnX7CzCxSWO91ixFWmMxd7ZyNkrY2kJqaUwEf+UriA6hK87e8Gp
         +32ovjGJctwzDmYuFO+m1kdzQwZpx/43bcWEcVbB6Jvjwl6c5nNx/YTAs9stpfrN/QLG
         Zu9tHFQngM8eHODjrQRMiz9BZFmxnvwcDBhQov4STqOrgY+cu/9tSMQOs9OXG0DYb//f
         H0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1/jkr+Dc99L/1x2jX+YALoe7r32aPFZgQbZy+mRa6jU=;
        b=VV3IwrhxTQku9VukrMETHmk+3Z9EYBMQFMlJy2ctB7vTonZrAhZWgt3gAMs28L+uTC
         JuJya2uT+BfvOxotT0Szl1al/kAsGeoldroppKnfUBEZToyHSUcyvVBCUfaOV9wKxAHH
         cULuEBaWa2I3fp7SQE+ZGVue0DbiFdYY+HOFtvLnjnCApsFUGduNcdvxTVSi3PgwtvCo
         cLO3voTfBR3uscGICMuN/iok2D31scNRdsSS0yPLy447hozyziFTze75PtbR2MQm7arS
         O3nENFBOcD45I11Euw5ocC2u7YvkWYszuEbDfKHi1D7nb7xmpbzRmN20SIKaY2J33rMx
         nljg==
X-Gm-Message-State: AOAM532mtoccibdt3e8P3HAJ9X4Zu+abT5WbAIfzrgQ7m7GZW7xUlP8L
        CJL5ZaWiFkAz5Fix9ZYTOktAwX9bEI4=
X-Google-Smtp-Source: ABdhPJy3eHyJjxA//XxygydLU3baJWgdDwJKMVDo99+UvoXWCrsuhV7zlZsknJi8VO4D9I81pJaHIg==
X-Received: by 2002:a17:906:40c1:: with SMTP id a1mr49484151ejk.520.1609349519895;
        Wed, 30 Dec 2020 09:31:59 -0800 (PST)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id u2sm19391789ejb.65.2020.12.30.09.31.58
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 09:31:59 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] libceph: disambiguate ceph_connection_operations handlers
Date:   Wed, 30 Dec 2020 18:31:57 +0100
Message-Id: <20201230173157.2556-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Since a few years, kernel addresses are no longer included in oops
dumps, at least on x86.  All we get is a symbol name with offset and
size.

This is a problem for ceph_connection_operations handlers, especially
con->ops->dispatch().  All three handlers have the same name and there
is little context to disambiguate between e.g. monitor and OSD clients
because almost everything is inlined.  gdb sneakily stops at the first
matching symbol, so one has to resort to nm and addr2line.

Some of these are already prefixed with mon_, osd_ or mds_.  Let's do
the same for all others.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/mds_client.c  | 34 +++++++++++++++++-----------------
 net/ceph/mon_client.c | 14 +++++++-------
 net/ceph/osd_client.c | 40 ++++++++++++++++++++--------------------
 3 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 840587037b59..d87bd852ed96 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5038,7 +5038,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 	return;
 }
 
-static struct ceph_connection *con_get(struct ceph_connection *con)
+static struct ceph_connection *mds_get_con(struct ceph_connection *con)
 {
 	struct ceph_mds_session *s = con->private;
 
@@ -5047,7 +5047,7 @@ static struct ceph_connection *con_get(struct ceph_connection *con)
 	return NULL;
 }
 
-static void con_put(struct ceph_connection *con)
+static void mds_put_con(struct ceph_connection *con)
 {
 	struct ceph_mds_session *s = con->private;
 
@@ -5058,7 +5058,7 @@ static void con_put(struct ceph_connection *con)
  * if the client is unresponsive for long enough, the mds will kill
  * the session entirely.
  */
-static void peer_reset(struct ceph_connection *con)
+static void mds_peer_reset(struct ceph_connection *con)
 {
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
@@ -5067,7 +5067,7 @@ static void peer_reset(struct ceph_connection *con)
 	send_mds_reconnect(mdsc, s);
 }
 
-static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
+static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
@@ -5125,8 +5125,8 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
  * Note: returned pointer is the address of a structure that's
  * managed separately.  Caller must *not* attempt to free it.
  */
-static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
-					int *proto, int force_new)
+static struct ceph_auth_handshake *
+mds_get_authorizer(struct ceph_connection *con, int *proto, int force_new)
 {
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
@@ -5142,7 +5142,7 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 	return auth;
 }
 
-static int add_authorizer_challenge(struct ceph_connection *con,
+static int mds_add_authorizer_challenge(struct ceph_connection *con,
 				    void *challenge_buf, int challenge_buf_len)
 {
 	struct ceph_mds_session *s = con->private;
@@ -5153,7 +5153,7 @@ static int add_authorizer_challenge(struct ceph_connection *con,
 					    challenge_buf, challenge_buf_len);
 }
 
-static int verify_authorizer_reply(struct ceph_connection *con)
+static int mds_verify_authorizer_reply(struct ceph_connection *con)
 {
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
@@ -5165,7 +5165,7 @@ static int verify_authorizer_reply(struct ceph_connection *con)
 		NULL, NULL, NULL, NULL);
 }
 
-static int invalidate_authorizer(struct ceph_connection *con)
+static int mds_invalidate_authorizer(struct ceph_connection *con)
 {
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
@@ -5288,15 +5288,15 @@ static int mds_check_message_signature(struct ceph_msg *msg)
 }
 
 static const struct ceph_connection_operations mds_con_ops = {
-	.get = con_get,
-	.put = con_put,
-	.dispatch = dispatch,
-	.get_authorizer = get_authorizer,
-	.add_authorizer_challenge = add_authorizer_challenge,
-	.verify_authorizer_reply = verify_authorizer_reply,
-	.invalidate_authorizer = invalidate_authorizer,
-	.peer_reset = peer_reset,
+	.get = mds_get_con,
+	.put = mds_put_con,
 	.alloc_msg = mds_alloc_msg,
+	.dispatch = mds_dispatch,
+	.peer_reset = mds_peer_reset,
+	.get_authorizer = mds_get_authorizer,
+	.add_authorizer_challenge = mds_add_authorizer_challenge,
+	.verify_authorizer_reply = mds_verify_authorizer_reply,
+	.invalidate_authorizer = mds_invalidate_authorizer,
 	.sign_message = mds_sign_message,
 	.check_message_signature = mds_check_message_signature,
 	.get_auth_request = mds_get_auth_request,
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index b9d54ed9f338..195ceb8afb06 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1433,7 +1433,7 @@ static int mon_handle_auth_bad_method(struct ceph_connection *con,
 /*
  * handle incoming message
  */
-static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
+static void mon_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	struct ceph_mon_client *monc = con->private;
 	int type = le16_to_cpu(msg->hdr.type);
@@ -1565,21 +1565,21 @@ static void mon_fault(struct ceph_connection *con)
  * will come from the messenger workqueue, which is drained prior to
  * mon_client destruction.
  */
-static struct ceph_connection *con_get(struct ceph_connection *con)
+static struct ceph_connection *mon_get_con(struct ceph_connection *con)
 {
 	return con;
 }
 
-static void con_put(struct ceph_connection *con)
+static void mon_put_con(struct ceph_connection *con)
 {
 }
 
 static const struct ceph_connection_operations mon_con_ops = {
-	.get = con_get,
-	.put = con_put,
-	.dispatch = dispatch,
-	.fault = mon_fault,
+	.get = mon_get_con,
+	.put = mon_put_con,
 	.alloc_msg = mon_alloc_msg,
+	.dispatch = mon_dispatch,
+	.fault = mon_fault,
 	.get_auth_request = mon_get_auth_request,
 	.handle_auth_reply_more = mon_handle_auth_reply_more,
 	.handle_auth_done = mon_handle_auth_done,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index bd2a994bf0f1..6bf7c981874c 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5468,7 +5468,7 @@ void ceph_osdc_cleanup(void)
 /*
  * handle incoming message
  */
-static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
+static void osd_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	struct ceph_osd *osd = con->private;
 	struct ceph_osd_client *osdc = osd->o_osdc;
@@ -5590,9 +5590,9 @@ static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
 	return m;
 }
 
-static struct ceph_msg *alloc_msg(struct ceph_connection *con,
-				  struct ceph_msg_header *hdr,
-				  int *skip)
+static struct ceph_msg *osd_alloc_msg(struct ceph_connection *con,
+				      struct ceph_msg_header *hdr,
+				      int *skip)
 {
 	struct ceph_osd *osd = con->private;
 	int type = le16_to_cpu(hdr->type);
@@ -5616,7 +5616,7 @@ static struct ceph_msg *alloc_msg(struct ceph_connection *con,
 /*
  * Wrappers to refcount containing ceph_osd struct
  */
-static struct ceph_connection *get_osd_con(struct ceph_connection *con)
+static struct ceph_connection *osd_get_con(struct ceph_connection *con)
 {
 	struct ceph_osd *osd = con->private;
 	if (get_osd(osd))
@@ -5624,7 +5624,7 @@ static struct ceph_connection *get_osd_con(struct ceph_connection *con)
 	return NULL;
 }
 
-static void put_osd_con(struct ceph_connection *con)
+static void osd_put_con(struct ceph_connection *con)
 {
 	struct ceph_osd *osd = con->private;
 	put_osd(osd);
@@ -5638,8 +5638,8 @@ static void put_osd_con(struct ceph_connection *con)
  * Note: returned pointer is the address of a structure that's
  * managed separately.  Caller must *not* attempt to free it.
  */
-static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
-					int *proto, int force_new)
+static struct ceph_auth_handshake *
+osd_get_authorizer(struct ceph_connection *con, int *proto, int force_new)
 {
 	struct ceph_osd *o = con->private;
 	struct ceph_osd_client *osdc = o->o_osdc;
@@ -5655,7 +5655,7 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 	return auth;
 }
 
-static int add_authorizer_challenge(struct ceph_connection *con,
+static int osd_add_authorizer_challenge(struct ceph_connection *con,
 				    void *challenge_buf, int challenge_buf_len)
 {
 	struct ceph_osd *o = con->private;
@@ -5666,7 +5666,7 @@ static int add_authorizer_challenge(struct ceph_connection *con,
 					    challenge_buf, challenge_buf_len);
 }
 
-static int verify_authorizer_reply(struct ceph_connection *con)
+static int osd_verify_authorizer_reply(struct ceph_connection *con)
 {
 	struct ceph_osd *o = con->private;
 	struct ceph_osd_client *osdc = o->o_osdc;
@@ -5678,7 +5678,7 @@ static int verify_authorizer_reply(struct ceph_connection *con)
 		NULL, NULL, NULL, NULL);
 }
 
-static int invalidate_authorizer(struct ceph_connection *con)
+static int osd_invalidate_authorizer(struct ceph_connection *con)
 {
 	struct ceph_osd *o = con->private;
 	struct ceph_osd_client *osdc = o->o_osdc;
@@ -5787,18 +5787,18 @@ static int osd_check_message_signature(struct ceph_msg *msg)
 }
 
 static const struct ceph_connection_operations osd_con_ops = {
-	.get = get_osd_con,
-	.put = put_osd_con,
-	.dispatch = dispatch,
-	.get_authorizer = get_authorizer,
-	.add_authorizer_challenge = add_authorizer_challenge,
-	.verify_authorizer_reply = verify_authorizer_reply,
-	.invalidate_authorizer = invalidate_authorizer,
-	.alloc_msg = alloc_msg,
+	.get = osd_get_con,
+	.put = osd_put_con,
+	.alloc_msg = osd_alloc_msg,
+	.dispatch = osd_dispatch,
+	.fault = osd_fault,
 	.reencode_message = osd_reencode_message,
+	.get_authorizer = osd_get_authorizer,
+	.add_authorizer_challenge = osd_add_authorizer_challenge,
+	.verify_authorizer_reply = osd_verify_authorizer_reply,
+	.invalidate_authorizer = osd_invalidate_authorizer,
 	.sign_message = osd_sign_message,
 	.check_message_signature = osd_check_message_signature,
-	.fault = osd_fault,
 	.get_auth_request = osd_get_auth_request,
 	.handle_auth_reply_more = osd_handle_auth_reply_more,
 	.handle_auth_done = osd_handle_auth_done,
-- 
2.19.2

