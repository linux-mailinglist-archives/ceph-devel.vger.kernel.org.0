Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F4570FA51
	for <lists+ceph-devel@lfdr.de>; Wed, 24 May 2023 17:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbjEXPfO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 11:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbjEXPfD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 11:35:03 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4C1E5A
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:43 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E2B483F438
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684942444;
        bh=VOsvDeo72Li4A+MGz8y/FXCiDvmbWTjb5uUMq09Z+GE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=gWZurhxT3fpyDMIpY77JZvx4PwqkyY55Hc00DdcdOYztydiLIGYoifVtCs4mY8MIa
         ZcsHOyJkkF4TImSP8JTVQ3o6LuOPpT0l/y/hlaf2s6QXPAF8bYWqmKwHHGkR9hBBrL
         JR6JDvFZ0j4k16Kq91Cdd1QRvMd8AkU+++VHZYxiz7PphVXcvGAeUk6s5gz7ZKO95E
         MZjGao1DtzPoAPe/70t/3FmgTniZj6iDRtIIa5gkSpOrdewvRvZFvhEcR0sGwe6GXC
         OvbqVUp0s9LIjXIjkFb1hlcl+6PnYJ3DK/lKKIpsqy8ze78clGszML8MEKIdxJeMn3
         TG10RXmVv5ceQ==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-96fd3757bd1so132721066b.1
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942444; x=1687534444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOsvDeo72Li4A+MGz8y/FXCiDvmbWTjb5uUMq09Z+GE=;
        b=STpHw/+J/2869zUVZJulPxftIQwVY/RnvNGrf71TY7qT6vgBZq6ZDyDmv0qR+mN4JN
         6sR4hNB+Ym+X2uT03F4h20pKWzEOAou5w2pTvNvCQTUus2ijuD/CLeXi88bOBAb3cU99
         jO0SNHTULgk6WAtQbEioD1iQRgcw2rSPnE7SavsDYmsfAVLjeR+KxXl4SY/k6CzGh4tX
         BCgA50C93Cte0yn/LNVOfw2R1l45zPdGGf9V30P+rVpKhCuMostoWQOFVu3a+CYL99yq
         55GG5OWB4rMtkUyrYYXxl8wJDcuAkHqX2KXilPw8xb2gEJzfh291HclvwFE9XJBF/88I
         V/Qg==
X-Gm-Message-State: AC+VfDwKD8XXjd6j9c0tn3r3w774EVLu0G8YsbVhKSe11y/Y9tPMruYN
        Zu0HlnkX6Lh4CdrAvkmyfoc86X73QpzkT7Cs74p2LChmtTdT+q3CEI52DEXhToobTHM5Q2LK/pZ
        VgtWNzaMXUJa8B0nM809vBM92awEg4hgKjGfpDMI=
X-Received: by 2002:a17:906:5044:b0:96a:63d4:24c5 with SMTP id e4-20020a170906504400b0096a63d424c5mr16834952ejk.77.1684942444422;
        Wed, 24 May 2023 08:34:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7gBpqHitu+lLhIckipr6Iw+ZMNPeoZej+/zA1KHtSCkxGa9OwcqI2J/tv0ifrYtmEPsQMuyg==
X-Received: by 2002:a17:906:5044:b0:96a:63d4:24c5 with SMTP id e4-20020a170906504400b0096a63d424c5mr16834933ejk.77.1684942444258;
        Wed, 24 May 2023 08:34:04 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p26-20020a17090664da00b0096f7105b3a6sm5986979ejn.189.2023.05.24.08.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 08:34:03 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/13] ceph: allow idmapped symlink inode op
Date:   Wed, 24 May 2023 17:33:07 +0200
Message-Id: <20230524153316.476973-6-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_symlink() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 8d3fedb3629b..3996572060da 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -956,6 +956,7 @@ static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_num_caps = 2;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
+	req->r_mnt_idmap = idmap;
 	if (as_ctx.pagelist) {
 		req->r_pagelist = as_ctx.pagelist;
 		as_ctx.pagelist = NULL;
-- 
2.34.1

