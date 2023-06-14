Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6372F1F8
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jun 2023 03:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjFNBds (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 21:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjFNBdr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 21:33:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703E3C0
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 18:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686706382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sKJMPsTY589cwJV/dDaV1CtDL25z5sDkw6mgeUd2PVM=;
        b=hMkoow0WGZCIEdNyKKs1xyphYr9LlwtGoGQQr/a5aImdGMB4mKo2J7h9ovSMYALaRYxlkr
        wDrlOllQ/WBGcL4oRiyxX08gfpftQcfbLwnHiA9/MZbxYdW3PvS9zNEc9XMzNgqnnPoYCG
        LG1KRBEOlQVyCjGqcygHFxLEJwvLnBw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-_bpRPMKkMjCHyLA8hTv3zA-1; Tue, 13 Jun 2023 21:33:00 -0400
X-MC-Unique: _bpRPMKkMjCHyLA8hTv3zA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D47B3806703;
        Wed, 14 Jun 2023 01:33:00 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 220E6492CA6;
        Wed, 14 Jun 2023 01:32:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        khiremat@redhat.com, pdonnell@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 1/6] ceph: add the *_client debug macros support
Date:   Wed, 14 Jun 2023 09:30:20 +0800
Message-Id: <20230614013025.291314-2-xiubli@redhat.com>
In-Reply-To: <20230614013025.291314-1-xiubli@redhat.com>
References: <20230614013025.291314-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will help print the fsid and client's global_id in debug logs,
and also print the function names.

URL: https://tracker.ceph.com/issues/61590
Cc: Patrick Donnelly <pdonnell@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/ceph_debug.h | 44 ++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
index d5a5da838caf..26b9212bf359 100644
--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -19,12 +19,22 @@
 	pr_debug("%.*s %12.12s:%-4d : " fmt,				\
 		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
 		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
+#  define dout_client(client, fmt, ...)					\
+	pr_debug("%.*s %12.12s:%-4d : [%pU %lld] " fmt,			\
+		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
+		 kbasename(__FILE__), __LINE__,				\
+		 &client->fsid, client->monc.auth->global_id,		\
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
@@ -33,7 +43,39 @@
  * or, just wrap pr_debug
  */
 # define dout(fmt, ...)	pr_debug(" " fmt, ##__VA_ARGS__)
-
+# define dout_client(client, fmt, ...)					\
+	pr_debug("[%pU %lld] %s: " fmt, &client->fsid,			\
+		 client->monc.auth->global_id, __func__,		\
+		 ##__VA_ARGS__)
 #endif
 
+# define pr_notice_client(client, fmt, ...)				\
+	pr_notice("[%pU %lld] %s: " fmt, &client->fsid,			\
+		  client->monc.auth->global_id, __func__,		\
+		  ##__VA_ARGS__)
+# define pr_info_client(client, fmt, ...)				\
+	pr_info("[%pU %lld] %s: " fmt, &client->fsid,			\
+		client->monc.auth->global_id, __func__,			\
+		##__VA_ARGS__)
+# define pr_warn_client(client, fmt, ...)				\
+	pr_warn("[%pU %lld] %s: " fmt, &client->fsid,			\
+		client->monc.auth->global_id, __func__,			\
+		##__VA_ARGS__)
+# define pr_warn_once_client(client, fmt, ...)				\
+	pr_warn_once("[%pU %lld] %s: " fmt, &client->fsid,		\
+		     client->monc.auth->global_id, __func__,		\
+		     ##__VA_ARGS__)
+# define pr_err_client(client, fmt, ...)				\
+	pr_err("[%pU %lld] %s: " fmt, &client->fsid,			\
+	       client->monc.auth->global_id, __func__,			\
+	       ##__VA_ARGS__)
+# define pr_warn_ratelimited_client(client, fmt, ...)			\
+	pr_warn_ratelimited("[%pU %lld] %s: " fmt, &client->fsid,	\
+			    client->monc.auth->global_id, __func__,	\
+			    ##__VA_ARGS__)
+# define pr_err_ratelimited_client(client, fmt, ...)			\
+	pr_err_ratelimited("[%pU %lld] %s: " fmt, &client->fsid,	\
+			   client->monc.auth->global_id, __func__,	\
+			   ##__VA_ARGS__)
+
 #endif
-- 
2.40.1

