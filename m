Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE627638BD
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 16:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbjGZONe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 10:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbjGZOL7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 10:11:59 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEB92D4E
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:11:26 -0700 (PDT)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5A7C742471
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 14:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1690380659;
        bh=V+geJeK43HRcagd4RPosGF8b069CSl1zVYPfJFF5DgU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=eJq6wrruPzn9weL7+AIH2e8i/jQYOM+TuP0puNOlo+4qQgY5/KxDgHxfXHJWMHQrC
         1SHyHtRzvy1qH92UmvAYXPPLeY2mvfTFMS0OKgayK5tevnI6LW9cLeX+/t8JpciiFG
         /5U1uMNYGK3wto4Y1h0KwrrRpTbJkOdu80DE3iz1fgWt2Wi1iOi6VJS9fI3tREuDvk
         8p6WUoAtMMNOhIqb6HlgkeVNXO9Rm08BvTF2bf3JjWk+K3TD9NZkqwXFWBYIzWSi4K
         W7SDQwOy2+FhdWtLebk01uKP0CZn7k+03iLgtQ8ejzIjlC/vXSiwM3kHDqsdeAGAtM
         t9daEuBSXQdGg==
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso34315315e9.2
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:10:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690380659; x=1690985459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V+geJeK43HRcagd4RPosGF8b069CSl1zVYPfJFF5DgU=;
        b=OiKP8v1KFwXKUTeNDcGYc8VkqmHe7qmXOl54ZICrzZWtgh/qnbH7Q+3XbEEVjJpvnb
         yi5TP6B6waLO2ghco8hEbQAArYkWdQDbu1558UZN71j6KM86Ih3plGZs5YwmctaMe1Ju
         plgA3rCYoJb64unzJVM0P194C9BvPbSTAtsaM4H4v/scgzXqQUlMKRs5qHfWzWmFz4HX
         eQUqZEud4MtzR37kd4LWbTLp7A9vzhFtl/VJSNCdvzuRu7/S0i1nYzrVn6KJVo9GGKxG
         4lposUoO/lJNMpafHnH8khId7rVnXlVhvzw4j/kuQnRR+TRFNWXSSja59bPzE8PuVAJ8
         KUmQ==
X-Gm-Message-State: ABy/qLZyYD2wGRSFaPrcYuQ57bnOeo/+mHVFXNp6YXEaVsP2Xzvn4k59
        BvgSEIXMjL9SgCy8L/C850Jj9E2CHZIlNOzH91Ft6e4dnxWDa1uupwXs2pDxAAbTns9hFx4JBF7
        7qbU4Kyi7g83OHRhbWAFzP3IBFd2i5OVOO/wv1Kk=
X-Received: by 2002:a1c:cc08:0:b0:3fb:dbd0:a7ea with SMTP id h8-20020a1ccc08000000b003fbdbd0a7eamr1439453wmb.37.1690380658870;
        Wed, 26 Jul 2023 07:10:58 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEIWQs4zQ3W3/YfffTF9QwaQh3tob3Vdd0DEnPyLt818r49Fpkk08smHP7Awq3GxxXYqPpH8A==
X-Received: by 2002:a1c:cc08:0:b0:3fb:dbd0:a7ea with SMTP id h8-20020a1ccc08000000b003fbdbd0a7eamr1439440wmb.37.1690380658568;
        Wed, 26 Jul 2023 07:10:58 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k14-20020a7bc30e000000b003fc02219081sm2099714wmj.33.2023.07.26.07.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 07:10:58 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 11/11] ceph: allow idmapped mounts
Date:   Wed, 26 Jul 2023 16:10:26 +0200
Message-Id: <20230726141026.307690-12-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Now that we converted cephfs internally to account for idmapped mounts
allow the creation of idmapped mounts on by setting the FS_ALLOW_IDMAP
flag.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 49fd17fbba9f..6326ab32e7b3 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1581,7 +1581,7 @@ static struct file_system_type ceph_fs_type = {
 	.name		= "ceph",
 	.init_fs_context = ceph_init_fs_context,
 	.kill_sb	= ceph_kill_sb,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE,
+	.fs_flags	= FS_RENAME_DOES_D_MOVE | FS_ALLOW_IDMAP,
 };
 MODULE_ALIAS_FS("ceph");
 
-- 
2.34.1

