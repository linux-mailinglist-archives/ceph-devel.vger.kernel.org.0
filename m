Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EBD75078F
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jul 2023 14:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjGLMHr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jul 2023 08:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjGLMHl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Jul 2023 08:07:41 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8975C1FE1
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jul 2023 05:07:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-992acf67388so793345666b.1
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jul 2023 05:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689163646; x=1691755646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=muW0MSMXAWU0NEgym29rcsHLpBa8BTkJu8VSzYzZ+PM=;
        b=sIiUccyYHQfF43bUraBRcyz0kbduUeX4Ba1lAq6lASuBj+m/fBr6MTdN5ITDXoG9F+
         C6i9yNHo4H3ogob/G85pD0P5Z01iNfg3qGvyka6U+ONbcvMw53X7A/v4O9z0zSIcXt6F
         NcwWot2tUnGOt742xPbmRd0WQBavs2HWqZH/hVD4bBhYaMk96YWqnJjrA5RtqMenexUZ
         EMzIVnIjGuVw3EznSRBUr72CZJoBYGwpk7ASu6rZadrvOc+5Pv5iLUO5qP93bmAs2Heg
         Ff+YCGDsfaWERvyxAumQgjNHOrzbjCmx4RU0QFkJCW296zcfBING+hWQzEfqdmXRHFNC
         dK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689163646; x=1691755646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=muW0MSMXAWU0NEgym29rcsHLpBa8BTkJu8VSzYzZ+PM=;
        b=X8Rrbd9jCYNmkqxn7G6EyKtP3yzHnJylVJsEyBcfBXAwwR7sZfUS3nUSKm335VoQbS
         14SePL0NBffiHB3mHaUw4nvYjcv9qrQlmde2A+J23NB8CCWi520AvPz6u0kxGG9l+NRI
         lhe9ESqUsm936q7IyftsuVrzpOGXIpRT33BOi0HVm3SWdy0DDHI3JjKwZIhz1NAgGJ7v
         NX7N3vwlMaKlaVmOl2GoG1RFmtj4LPlLPFarCoEbPMVlAGzrcGX8WbwAmmo+JYtFMOd7
         t0bbHddQ3tLgYToM1e6R/d3717eaYPZ3Bvb3OLVsnTlNBwEnN5WcNPGY+//YFAiuNlBH
         i/Kw==
X-Gm-Message-State: ABy/qLbeoHnGTTeF0KyF4eg2bl8dYnGGbpaNFJGOqeTqMXWetr8ACffP
        v9AfgXWl4+FBa+Jm18zXYP8aS3gqgik=
X-Google-Smtp-Source: APBJJlGqZAWAWsGLjOh89ukU9m9juEu2m/f6ygvfqWIzujn6nMq6udITDgNQ5EHeMYDahdtymuYn9w==
X-Received: by 2002:a17:906:19:b0:982:82aa:86b1 with SMTP id 25-20020a170906001900b0098282aa86b1mr17815980eja.43.1689163645549;
        Wed, 12 Jul 2023 05:07:25 -0700 (PDT)
Received: from zambezi.local (ip-94-112-104-28.bb.vodafone.cz. [94.112.104.28])
        by smtp.gmail.com with ESMTPSA id gg21-20020a170906e29500b0099207b3bc49sm2473063ejb.30.2023.07.12.05.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 05:07:24 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Thelford Williams <thelford@google.com>
Subject: [PATCH] libceph: harden msgr2.1 frame segment length checks
Date:   Wed, 12 Jul 2023 14:07:15 +0200
Message-ID: <20230712120718.28904-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph_frame_desc::fd_lens is an int array.  decode_preamble() thus
effectively casts u32 -> int but the checks for segment lengths are
written as if on unsigned values.  While reading in HELLO or one of the
AUTH frames (before authentication is completed), arithmetic in
head_onwire_len() can get duped by negative ctrl_len and produce
head_len which is less than CEPH_PREAMBLE_LEN but still positive.
This would lead to a buffer overrun in prepare_read_control() as the
preamble gets copied to the newly allocated buffer of size head_len.

Cc: stable@vger.kernel.org
Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc and secure modes)")
Reported-by: Thelford Williams <thelford@google.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/messenger_v2.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 1a888b86a494..1df1d29dee92 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -390,6 +390,8 @@ static int head_onwire_len(int ctrl_len, bool secure)
 	int head_len;
 	int rem_len;
 
+	BUG_ON(ctrl_len < 0 || ctrl_len > CEPH_MSG_MAX_CONTROL_LEN);
+
 	if (secure) {
 		head_len = CEPH_PREAMBLE_SECURE_LEN;
 		if (ctrl_len > CEPH_PREAMBLE_INLINE_LEN) {
@@ -408,6 +410,10 @@ static int head_onwire_len(int ctrl_len, bool secure)
 static int __tail_onwire_len(int front_len, int middle_len, int data_len,
 			     bool secure)
 {
+	BUG_ON(front_len < 0 || front_len > CEPH_MSG_MAX_FRONT_LEN ||
+	       middle_len < 0 || middle_len > CEPH_MSG_MAX_MIDDLE_LEN ||
+	       data_len < 0 || data_len > CEPH_MSG_MAX_DATA_LEN);
+
 	if (!front_len && !middle_len && !data_len)
 		return 0;
 
@@ -520,29 +526,34 @@ static int decode_preamble(void *p, struct ceph_frame_desc *desc)
 		desc->fd_aligns[i] = ceph_decode_16(&p);
 	}
 
-	/*
-	 * This would fire for FRAME_TAG_WAIT (it has one empty
-	 * segment), but we should never get it as client.
-	 */
-	if (!desc->fd_lens[desc->fd_seg_cnt - 1]) {
-		pr_err("last segment empty\n");
+	if (desc->fd_lens[0] < 0 ||
+	    desc->fd_lens[0] > CEPH_MSG_MAX_CONTROL_LEN) {
+		pr_err("bad control segment length %d\n", desc->fd_lens[0]);
 		return -EINVAL;
 	}
-
-	if (desc->fd_lens[0] > CEPH_MSG_MAX_CONTROL_LEN) {
-		pr_err("control segment too big %d\n", desc->fd_lens[0]);
+	if (desc->fd_lens[1] < 0 ||
+	    desc->fd_lens[1] > CEPH_MSG_MAX_FRONT_LEN) {
+		pr_err("bad front segment length %d\n", desc->fd_lens[1]);
 		return -EINVAL;
 	}
-	if (desc->fd_lens[1] > CEPH_MSG_MAX_FRONT_LEN) {
-		pr_err("front segment too big %d\n", desc->fd_lens[1]);
+	if (desc->fd_lens[2] < 0 ||
+	    desc->fd_lens[2] > CEPH_MSG_MAX_MIDDLE_LEN) {
+		pr_err("bad middle segment length %d\n", desc->fd_lens[2]);
 		return -EINVAL;
 	}
-	if (desc->fd_lens[2] > CEPH_MSG_MAX_MIDDLE_LEN) {
-		pr_err("middle segment too big %d\n", desc->fd_lens[2]);
+	if (desc->fd_lens[3] < 0 ||
+	    desc->fd_lens[3] > CEPH_MSG_MAX_DATA_LEN) {
+		pr_err("bad data segment length %d\n", desc->fd_lens[3]);
 		return -EINVAL;
 	}
-	if (desc->fd_lens[3] > CEPH_MSG_MAX_DATA_LEN) {
-		pr_err("data segment too big %d\n", desc->fd_lens[3]);
+
+	/*
+	 * This would fire for FRAME_TAG_WAIT (it has one empty
+	 * segment), but we should never get it as client.
+	 */
+	if (!desc->fd_lens[desc->fd_seg_cnt - 1]) {
+		pr_err("last segment empty, segment count %d\n",
+		       desc->fd_seg_cnt);
 		return -EINVAL;
 	}
 
-- 
2.41.0

