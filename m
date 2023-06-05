Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54F272314F
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 22:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbjFEU1a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 16:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbjFEU11 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 16:27:27 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B99DEC
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 13:27:26 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9741a0fd134so875855466b.0
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 13:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685996845; x=1688588845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rTXKmlUfaxsweCr9txnhSwKRBLs4KBaD4wqyu/rzXwA=;
        b=E1we858Hhh8gQG8m+/zb1bAdNY8ZSoOLEd5tNO7RJDwOQEGm+wmykVbZ1TxMaL6jLx
         Xu+LYVo+N3PLspECnzPTbIb+qYwbxxhQCL1u4JpKyfvz6uTAcKxzIUYIhs/CLBjhwhms
         4mY7mp+eeeCQOe72xN3qOrpFdmnCJD6J0KA8pUcjx/gqF0UTU6bsHYlAc7Y89xSeD7Bb
         yahbNfuPY5wo192HwcVZXcCG8VRYcLITbe04RAzg6CHJQOlmSrdFd//tCYDfEd8pCg1z
         CLxKrGeWWBLVWB2O10LbM88d7sR88vTUj/zNVoWhHGwXSJlYLYkFINwTfw/CKeKvgpwG
         Eorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685996845; x=1688588845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTXKmlUfaxsweCr9txnhSwKRBLs4KBaD4wqyu/rzXwA=;
        b=NbZbdGVjzmfCLS4jDb1Ruha1a0MXKvbZMsAmPMCb75pfWfRPA+nYRC/KPXBJnh00kH
         O2aL/+dKbsSKx6UuhjMrBhbLCpG1ITtPrsIANZ6WUI0M5DWV02F440/MrhAGQCG6T1UM
         Ce2k9hebTUopvSBwAUEcUT9RKXle66q7N6zrM3i+9oMjwxyXDGSzIdWRj+L9hQzX1LEn
         tUcD/Ob2N6WDLOe4/lzLtv6oS/qtQ5RJzSrKjyUTo14nMrrX8yHxHDK0tbfULjLq9puZ
         dXa2IHB+fqlCplpvCe7+R82tCMX3MQ8lNaoN3kROBkYCZnCSzAfBc8E8a9pt62k7WVnI
         Kd6w==
X-Gm-Message-State: AC+VfDwByglnsMOc0a6Ku2wMq9GbX8K7Pbk2j9KuA9EsfxOxkDf2F/Af
        oNbame9HtLk+imA3MQKKDw25p/u1vmg=
X-Google-Smtp-Source: ACHHUZ6fQ1I3kuPRuFBRqM5W25cToIrTZ1n2neJC1lIt3vSEAWYE47RHuSl89BzUUTgxwUr8dFUyww==
X-Received: by 2002:a17:906:730c:b0:96a:f09b:373e with SMTP id di12-20020a170906730c00b0096af09b373emr23663ejc.15.1685996844870;
        Mon, 05 Jun 2023 13:27:24 -0700 (PDT)
Received: from zambezi.redhat.com (ip-94-112-104-28.bb.vodafone.cz. [94.112.104.28])
        by smtp.gmail.com with ESMTPSA id i15-20020a170906a28f00b00968242f8c37sm4619808ejz.50.2023.06.05.13.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 13:27:24 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 1/2] rbd: move RBD_OBJ_FLAG_COPYUP_ENABLED flag setting
Date:   Mon,  5 Jun 2023 22:27:14 +0200
Message-Id: <20230605202715.968962-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230605202715.968962-1-idryomov@gmail.com>
References: <20230605202715.968962-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Move RBD_OBJ_FLAG_COPYUP_ENABLED flag setting into the object request
state machine to allow for the snapshot context to be captured in the
image request state machine rather than in rbd_queue_workfn().

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 84ad3b17956f..6c847db6ee2c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1334,14 +1334,28 @@ static bool rbd_obj_is_tail(struct rbd_obj_request *obj_req)
 /*
  * Must be called after rbd_obj_calc_img_extents().
  */
-static bool rbd_obj_copyup_enabled(struct rbd_obj_request *obj_req)
+static void rbd_obj_set_copyup_enabled(struct rbd_obj_request *obj_req)
 {
-	if (!obj_req->num_img_extents ||
-	    (rbd_obj_is_entire(obj_req) &&
-	     !obj_req->img_request->snapc->num_snaps))
-		return false;
+	if (obj_req->img_request->op_type == OBJ_OP_DISCARD) {
+		dout("%s %p objno %llu discard\n", __func__, obj_req,
+		     obj_req->ex.oe_objno);
+		return;
+	}
 
-	return true;
+	if (!obj_req->num_img_extents) {
+		dout("%s %p objno %llu not overlapping\n", __func__, obj_req,
+		     obj_req->ex.oe_objno);
+		return;
+	}
+
+	if (rbd_obj_is_entire(obj_req) &&
+	    !obj_req->img_request->snapc->num_snaps) {
+		dout("%s %p objno %llu entire\n", __func__, obj_req,
+		     obj_req->ex.oe_objno);
+		return;
+	}
+
+	obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
 }
 
 static u64 rbd_obj_img_extents_bytes(struct rbd_obj_request *obj_req)
@@ -2233,9 +2247,6 @@ static int rbd_obj_init_write(struct rbd_obj_request *obj_req)
 	if (ret)
 		return ret;
 
-	if (rbd_obj_copyup_enabled(obj_req))
-		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
-
 	obj_req->write_state = RBD_OBJ_WRITE_START;
 	return 0;
 }
@@ -2341,8 +2352,6 @@ static int rbd_obj_init_zeroout(struct rbd_obj_request *obj_req)
 	if (ret)
 		return ret;
 
-	if (rbd_obj_copyup_enabled(obj_req))
-		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
 	if (!obj_req->num_img_extents) {
 		obj_req->flags |= RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT;
 		if (rbd_obj_is_entire(obj_req))
@@ -3286,6 +3295,7 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
 	case RBD_OBJ_WRITE_START:
 		rbd_assert(!*result);
 
+		rbd_obj_set_copyup_enabled(obj_req);
 		if (rbd_obj_write_is_noop(obj_req))
 			return true;
 
-- 
2.39.2

