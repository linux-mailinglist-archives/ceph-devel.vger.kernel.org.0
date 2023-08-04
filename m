Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B4976FC98
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Aug 2023 10:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjHDIve (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Aug 2023 04:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjHDItx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Aug 2023 04:49:53 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871F14ED6
        for <ceph-devel@vger.kernel.org>; Fri,  4 Aug 2023 01:49:49 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AD770417BB
        for <ceph-devel@vger.kernel.org>; Fri,  4 Aug 2023 08:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691138987;
        bh=ARhwDsiPa3Ci/G2xteJutduXCGuj42UUR3o8sfJhjpo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=GkddBikpB2/vEVvij461v8mB4ZowSfYppuqPoI9H0KEPxpVdSkHpctJYbs3pq66tr
         E/Pg6HFpHqp/dIyV5OdhhTXQdNlH+M2bOAgpagRxAS3y8VeGb9teARxVsO9phgBW3C
         XiHQsHgQyDHV2dx/hIpfGG0oP6sLpJdK6aey/YWPggCLfNmCQNsYuMzerZkQVD4Jzt
         R9PjVQVWUM1qe/p6JPkJWSEYBe7cN6tuz0KRQOC5CVs6bANEUYqXtaPa3bAjQbOCKu
         Ml3BUcTSQJ4+7YAOJ5uwDohDlVkMFDcz4riwbKBDSCJ/Io6OoGOP9AibNoeTbX3Hil
         zPzJ/EJfbMMFA==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-993831c639aso124203166b.2
        for <ceph-devel@vger.kernel.org>; Fri, 04 Aug 2023 01:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691138987; x=1691743787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ARhwDsiPa3Ci/G2xteJutduXCGuj42UUR3o8sfJhjpo=;
        b=gLSouRGAbgS//0VeXLgmjnlF7mdH960Dx2eug4i/SLUlzr2SKZXf6UYCEom3l/arM5
         DpzWY4kiBN0GGuX2PHTyBkkcjog7qsYjZY/hryGHnqPrVVw2qCP/tJRqULCuAc25Xj1V
         3J1U0Y/imtUXy6D/p2x+wwQdk0Aez3ZLbNus+5s4CyDmHOmWUs5unG1EMrYqnd/mBzMq
         J0gFTEejY4tqaWiQm4u5IWYfsIUSQAHm8ODvg7T2nOxC9LKZ2+FqW77p3ZNrb4CYyjQY
         qzkFH2K9aFkGnpPDnfmMWcYKcuyJLpDsBHz8yBbcO+3tN/N3ChITZ+PJEAP1Zw71sGDH
         6hLw==
X-Gm-Message-State: AOJu0YwnwR9nL9GIlhGmReeov34FV5c7Fanx/R5lr7FUE/aCa7u+cDs8
        YPn6S+HCmWXD5kVW8kPLptN+tD87RhzU4Bf5tkWx4jNuBbbJGVgn6clGowW3BWcnnXd+VbkxnwY
        jdW0GPj3spBf2sHT7VePp+a2tQsKIarr+ee0rXTk=
X-Received: by 2002:a17:907:77d0:b0:994:5577:aeed with SMTP id kz16-20020a17090777d000b009945577aeedmr995713ejc.5.1691138987400;
        Fri, 04 Aug 2023 01:49:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFij2ZN/HuBWc4Nu5STOSW9BVGSH6Wz3WtoLMx8eDAi/KUmbdzucsXu/L2vGnsUCM+iyzwOrQ==
X-Received: by 2002:a17:907:77d0:b0:994:5577:aeed with SMTP id kz16-20020a17090777d000b009945577aeedmr995708ejc.5.1691138987251;
        Fri, 04 Aug 2023 01:49:47 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k25-20020a17090646d900b00992e94bcfabsm979279ejs.167.2023.08.04.01.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 01:49:46 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9 10/12] ceph/acl: allow idmapped set_acl inode op
Date:   Fri,  4 Aug 2023 10:48:56 +0200
Message-Id: <20230804084858.126104-11-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230804084858.126104-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230804084858.126104-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

Enable ceph_set_acl() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 89280c168acb..ffc6a1c02388 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -107,7 +107,7 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	case ACL_TYPE_ACCESS:
 		name = XATTR_NAME_POSIX_ACL_ACCESS;
 		if (acl) {
-			ret = posix_acl_update_mode(&nop_mnt_idmap, inode,
+			ret = posix_acl_update_mode(idmap, inode,
 						    &new_mode, &acl);
 			if (ret)
 				goto out;
-- 
2.34.1

