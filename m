Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D912672C378
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Jun 2023 13:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbjFLLwU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jun 2023 07:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjFLLv7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Jun 2023 07:51:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A22C0
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 04:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686570386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S420XYnVeAb4kbexCP3KFf7n2Q2F1cpWnmlexwJMhVc=;
        b=OmHy/Zkvhsyd4SzBomWsD+ynTyRF1zBkQAl31VFZThxWH5A1vocR2UrGbgvedF13n5Qm2B
        ZlhxobFHE9rLjCbxoYUJZ7R02Yvm5gk24kQVg9XJDQn8F1WmKZnBdwmC0FkZLgRiqQLpBf
        68JOyvPJrjAhadY7RtstqDbY3zet1hc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-dtwwlaQbPo6OQuwG9yt3Bg-1; Mon, 12 Jun 2023 07:46:23 -0400
X-MC-Unique: dtwwlaQbPo6OQuwG9yt3Bg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B86163802136;
        Mon, 12 Jun 2023 11:46:22 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5061C1121315;
        Mon, 12 Jun 2023 11:46:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, khiremat@redhat.com,
        mchangir@redhat.com, pdonnell@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/6] ceph: add the *_client debug macros support
Date:   Mon, 12 Jun 2023 19:43:54 +0800
Message-Id: <20230612114359.220895-2-xiubli@redhat.com>
In-Reply-To: <20230612114359.220895-1-xiubli@redhat.com>
References: <20230612114359.220895-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will help print the client's global_id in debug logs.

URL: https://tracker.ceph.com/issues/61590
Cc: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/ceph_debug.h | 38 ++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
index d5a5da838caf..41bfbdb5dd85 100644
--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -19,12 +19,22 @@
 	pr_debug("%.*s %12.12s:%-4d : " fmt,				\
 		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
 		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
+#  define dout_client(client, fmt, ...)					\
+	pr_debug("%.*s %12.12s:%-4d : [client.%lld] " fmt,		\
+		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
+		 kbasename(__FILE__), __LINE__,				\
+		 client->monc.auth->global_id,				\
+		 ##__VA_ARGS__)
 # else
 /* faux printk call just to see any compiler warnings. */
 #  define dout(fmt, ...)	do {				\
 		if (0)						\
 			printk(KERN_DEBUG fmt, ##__VA_ARGS__);	\
 	} while (0)
+#  define dout_client(client, fmt, ...)	do {			\
+		if (0)						\
+			printk(KERN_DEBUG fmt, ##__VA_ARGS__);	\
+	} while (0)
 # endif
 
 #else
@@ -33,7 +43,33 @@
  * or, just wrap pr_debug
  */
 # define dout(fmt, ...)	pr_debug(" " fmt, ##__VA_ARGS__)
-
+# define dout_client(client, fmt, ...)					 \
+	pr_debug(" [client.%lld] " fmt,	client->monc.auth->global_id,	 \
+		 ##__VA_ARGS__)
 #endif
 
+# define pr_notice_client(client, fmt, ...)				 \
+	pr_notice(" [client.%lld] " fmt, client->monc.auth->global_id,	 \
+		##__VA_ARGS__)
+# define pr_info_client(client, fmt, ...)				 \
+	pr_info(" [client.%lld] " fmt, client->monc.auth->global_id,	 \
+		##__VA_ARGS__)
+# define pr_warn_client(client, fmt, ...)				 \
+	pr_warn(" [client.%lld] " fmt, client->monc.auth->global_id,	 \
+		##__VA_ARGS__)
+# define pr_warn_once_client(client, fmt, ...)				 \
+	pr_warn_once(" [client.%lld] " fmt, client->monc.auth->global_id,\
+		##__VA_ARGS__)
+# define pr_err_client(client, fmt, ...)				 \
+	pr_err(" [client.%lld] " fmt, client->monc.auth->global_id,	 \
+		##__VA_ARGS__)
+# define pr_warn_ratelimited_client(client, fmt, ...)			 \
+	pr_warn_ratelimited(" [client.%lld] " fmt,			 \
+			    client->monc.auth->global_id,		 \
+			    ##__VA_ARGS__)
+# define pr_err_ratelimited_client(client, fmt, ...)			 \
+	pr_err_ratelimited(" [client.%lld] " fmt,			 \
+			    client->monc.auth->global_id,		 \
+			    ##__VA_ARGS__)
+
 #endif
-- 
2.40.1

