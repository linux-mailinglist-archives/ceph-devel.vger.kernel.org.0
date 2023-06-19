Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D47734C3D
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Jun 2023 09:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjFSHSP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Jun 2023 03:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjFSHSO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Jun 2023 03:18:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9D9106
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jun 2023 00:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687159048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYMJBHe9cHgzDT4OrWzCd81iey8gjyg5QYgB6BMkadQ=;
        b=QtnbMRxJ5brCaC1K+ahZ4cozfbN47nvEdnQnPOyLLPJ72+ZptwZKqQXV1JHiJEth4q63ut
        kqiqtaHR2J5jUsNe5ah1eaiUrBwnyqj7n0Co4RTV/i7kZPU30/Vx276CiHyCJxB6+TrYYa
        0E/i2R/QB9q3e/w1KbiN8jM3xnafxq8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-r62fymRbNJihKFdB6aHOfQ-1; Mon, 19 Jun 2023 03:17:24 -0400
X-MC-Unique: r62fymRbNJihKFdB6aHOfQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C64043C0F184;
        Mon, 19 Jun 2023 07:17:23 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD03AC1604C;
        Mon, 19 Jun 2023 07:17:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH v4 1/6] ceph: add the *_client debug macros support
Date:   Mon, 19 Jun 2023 15:14:33 +0800
Message-Id: <20230619071438.7000-2-xiubli@redhat.com>
In-Reply-To: <20230619071438.7000-1-xiubli@redhat.com>
References: <20230619071438.7000-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

This will help print the fsid and client's global_id in debug logs,
and also print the function names.

URL: https://tracker.ceph.com/issues/61590
Cc: Patrick Donnelly <pdonnell@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/ceph_debug.h | 48 ++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
index d5a5da838caf..0b5f210ca977 100644
--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -19,12 +19,26 @@
 	pr_debug("%.*s %12.12s:%-4d : " fmt,				\
 		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
 		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
+#  define doutc(client, fmt, ...)					\
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
+#  define doutc(client, fmt, ...)	do {			\
+		if (0)						\
+			printk(KERN_DEBUG "[%pU %lld] " fmt,	\
+			&client->fsid,				\
+			client->monc.auth->global_id,		\
+			##__VA_ARGS__);				\
+		} while (0)
+
 # endif
 
 #else
@@ -33,7 +47,39 @@
  * or, just wrap pr_debug
  */
 # define dout(fmt, ...)	pr_debug(" " fmt, ##__VA_ARGS__)
-
+# define doutc(client, fmt, ...)					\
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

