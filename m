Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB37725BE
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Aug 2023 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjHGNaF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Aug 2023 09:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbjHGN3T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Aug 2023 09:29:19 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EBD2123
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 06:28:59 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3D27844277
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 13:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691414901;
        bh=dyWOzKMsgYqMEu72C+uRJxx6NqzlAitmeRu8HoKY4M0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=kM05WPvONwmOxJ76VhmPQscD4eahAPaI6K7gyMXLKVtk3+b8/ANE86DpouGTV9ZSY
         JSFuOWLIuQIzQFchmhf2noKOX30FcUPWf9vVkDjf8UOPLsQhdVldeB4R6phd1TTLEF
         RzD/y5OdLRdWVuselFcn2jkFGuQzTvtxd7XR9FlphNjfLXVu5wbaFWHmeV8w4eflp2
         2wOL3b3s1rRdzGa3WefQxykRibLcfiltdaU9UA5vWvkED+ShBZQTfr5W6TLCK+4xbj
         PSk6JMdoOKpGLIgNJ2lbfw0/iTS9PAp+YIJqwW2cTeALMNxyE24BM3XFiLnFKA5mT9
         f2vJvqOf+/05A==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-993c2d9e496so316018966b.0
        for <ceph-devel@vger.kernel.org>; Mon, 07 Aug 2023 06:28:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691414901; x=1692019701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dyWOzKMsgYqMEu72C+uRJxx6NqzlAitmeRu8HoKY4M0=;
        b=CzJRTwWb/2DFLNrqxUVV3h73Uvb1GqcYhoDX39M573LawgrYGkZm8cMQ/bEyEHrjyk
         zG27y/8NLrsICf0o92k+fCAILpYk9s6bNsaE9NjLWuW7e0xzw5yE6KyV8/PGutZIAnK+
         PmApxRogT6dYjVf7o9WpK6iF0OlZcvajNXsrQ2nOHdXmhvZHVcMS8QCTw3oAAyVDjpNA
         p/hgRbI5fqnIYHMufm1+jr9nse9W7+x9W1kUXESUq5fVLZOtMnkw8RAg54xUL8EWJwcZ
         5dgNhsR0RsQtRaNJ+ndw7bi19O0ZDWbO05kMbCSrSY6Zs23BtOgHqCzgkO56Dyjx73dB
         spiQ==
X-Gm-Message-State: AOJu0Yyu2XhngVgIanK0MuIGuN6D4PnOhdPIqSXfrd11KABeREw3hkQx
        Jxl9tfu/JCnJG8FC/3imbk0DWt3gFVrlwsgpO8OiEtcPGIN0TF18rS70V5eXnmhK6Pe14557nZO
        WK07XYs20jdp9gkIkjrxk8icHXHcwhJwpkhkRKpQ=
X-Received: by 2002:a17:906:1011:b0:99c:3b4:940c with SMTP id 17-20020a170906101100b0099c03b4940cmr9039178ejm.7.1691414900866;
        Mon, 07 Aug 2023 06:28:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3ADA4o2cJQwyFlv49UMgDsjmvjuXfeU1vTiwFnYE1XpiRQKXsUX4t+Epk7AEPPGhbvKUbow==
X-Received: by 2002:a17:906:1011:b0:99c:3b4:940c with SMTP id 17-20020a170906101100b0099c03b4940cmr9039165ejm.7.1691414900716;
        Mon, 07 Aug 2023 06:28:20 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id lg12-20020a170906f88c00b00992ca779f42sm5175257ejb.97.2023.08.07.06.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 06:28:20 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 07/12] ceph: allow idmapped permission inode op
Date:   Mon,  7 Aug 2023 15:26:21 +0200
Message-Id: <20230807132626.182101-8-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

Enable ceph_permission() to handle idmapped mounts. This is just a
matter of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 136b68ccdbef..9b50861bd2b5 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2977,7 +2977,7 @@ int ceph_permission(struct mnt_idmap *idmap, struct inode *inode,
 	err = ceph_do_getattr(inode, CEPH_CAP_AUTH_SHARED, false);
 
 	if (!err)
-		err = generic_permission(&nop_mnt_idmap, inode, mask);
+		err = generic_permission(idmap, inode, mask);
 	return err;
 }
 
-- 
2.34.1

