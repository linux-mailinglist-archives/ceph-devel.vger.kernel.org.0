Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF5E76C064
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Aug 2023 00:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbjHAWZ6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Aug 2023 18:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjHAWZ5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Aug 2023 18:25:57 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A530DB
        for <ceph-devel@vger.kernel.org>; Tue,  1 Aug 2023 15:25:56 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-52256241c66so617591a12.1
        for <ceph-devel@vger.kernel.org>; Tue, 01 Aug 2023 15:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690928755; x=1691533555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IVdQ4i4B1hKzwfai1mby40N7+7bXAVlbyz0mMdkVtJ4=;
        b=aYEi+xmM2E9R3LyO2X3aZALPNVkj4XtLpT4LrHUWdUODQ1qMq/5cZWSk0hb5qswoJl
         xOBXZiL85mdRP1Qgukp+7eof56HsfcCjN3OGice7i9N2/oLYbJ6rwWVPtzZ3XMuUZOy8
         2Kj8iiDUmHOCzoSwuBxlAtONViAg06bpGOJkh6yjiYTQ7O41uXwhAjbiy03bSgxQLSNL
         Dh2ASVAIDOn3+ifq+nOMbGXFk+A+vOgWb8z+NTZHkz3wbvVpLnjGPYxTiAfMEnQsmnu9
         /BQq1BggD3As9p6aUBrRjP92QZrWla9HndoP5VGvHC1k5IyaCQROUCXHgupiUEfNaUW6
         x54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928755; x=1691533555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVdQ4i4B1hKzwfai1mby40N7+7bXAVlbyz0mMdkVtJ4=;
        b=SphokMgPHqZkZVEVa+6s5LpawN6wBasAsHELFMGe7pOG1+hD6hlwB3zuLFqpMJEFkg
         vQ6Xt5a/YrsWXJrU58ASVosLKG8xqyalhXVjbaQGzCyjaQA3zmqH44nLSkoqET0+K453
         Y3ggaH90pkVMo3m/rMkaK5kKSsr/prXDOizPynDhfglWdjS2CKwLJqDjVNKtztTa8w5g
         8t/hCIIkT2zlGJf+B4kxKF7DrxqsT85nYPnbyC2XqTyom8xMrLXwCuN1XxUdNAxuz1OR
         och1ERDgd7eq26wa+AmJhGe6MtWagULDA16wPdlehiww2b+8JUfwQxS53zcGUU8FP2B5
         UxFw==
X-Gm-Message-State: ABy/qLZ+ht6lTXeZZac8qA5OUqv+gS0/RPd+0pTcAfceUz1eqkdsWD5o
        +ofAXLwsVxjE4VavbV3xdy2VYqXIXPY=
X-Google-Smtp-Source: APBJJlG5WS0bLA5lll51wWAdKjQnwF4/jZTf1bsYAoH8jbQXUP9/HFWxUNC1sSJL4TBZjDRziOk3Pw==
X-Received: by 2002:a05:6402:268c:b0:521:ef0f:8ef9 with SMTP id w12-20020a056402268c00b00521ef0f8ef9mr4970255edd.19.1690928754554;
        Tue, 01 Aug 2023 15:25:54 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id h22-20020a50ed96000000b00522b7c5d53esm5014266edr.54.2023.08.01.15.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:25:54 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH] libceph: fix potential hang in ceph_osdc_notify()
Date:   Wed,  2 Aug 2023 00:25:28 +0200
Message-ID: <20230801222529.674721-1-idryomov@gmail.com>
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

If the cluster becomes unavailable, ceph_osdc_notify() may hang even
with osd_request_timeout option set because linger_notify_finish_wait()
waits for MWatchNotify NOTIFY_COMPLETE message with no associated OSD
request in flight -- it's completely asynchronous.

Introduce an additional timeout, derived from the specified notify
timeout.  While at it, switch both waits to killable which is more
correct.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/osd_client.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 11c04e7d928e..658a6f2320cf 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3334,17 +3334,24 @@ static int linger_reg_commit_wait(struct ceph_osd_linger_request *lreq)
 	int ret;
 
 	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
-	ret = wait_for_completion_interruptible(&lreq->reg_commit_wait);
+	ret = wait_for_completion_killable(&lreq->reg_commit_wait);
 	return ret ?: lreq->reg_commit_error;
 }
 
-static int linger_notify_finish_wait(struct ceph_osd_linger_request *lreq)
+static int linger_notify_finish_wait(struct ceph_osd_linger_request *lreq,
+				     unsigned long timeout)
 {
-	int ret;
+	long left;
 
 	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
-	ret = wait_for_completion_interruptible(&lreq->notify_finish_wait);
-	return ret ?: lreq->notify_finish_error;
+	left = wait_for_completion_killable_timeout(&lreq->notify_finish_wait,
+						ceph_timeout_jiffies(timeout));
+	if (left <= 0)
+		left = left ?: -ETIMEDOUT;
+	else
+		left = lreq->notify_finish_error; /* completed */
+
+	return left;
 }
 
 /*
@@ -4896,7 +4903,8 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 	linger_submit(lreq);
 	ret = linger_reg_commit_wait(lreq);
 	if (!ret)
-		ret = linger_notify_finish_wait(lreq);
+		ret = linger_notify_finish_wait(lreq,
+				 msecs_to_jiffies(2 * timeout * MSEC_PER_SEC));
 	else
 		dout("lreq %p failed to initiate notify %d\n", lreq, ret);
 
-- 
2.41.0

