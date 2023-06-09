Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CAF7295A0
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jun 2023 11:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbjFIJk6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Jun 2023 05:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241942AbjFIJkD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Jun 2023 05:40:03 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E26C4683
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 02:35:02 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B9DB53F37D
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 09:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686303175;
        bh=kRtya9vNnJsHnlJFsQiUMmcKKT8ZGQqP3swgCnXRiRw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=I480jqjgTHO+N8GD2mnA2TB7qcTsCHkLUsvfTKkrRvRcDIzDbpb8IwtAJxg8MLQYX
         xucTQCkq+/ee9bCI4I9CjlXN1vZusZR2W2jV+2xsYPg3kxqlAMcVdtJD78YGcSTqUC
         B8yzSXdoi4pxQVG0Y53nNGnJG6RLx+JNYOiburjBPCBshrd18xlKQjZbN11lKXIGa5
         DPEyBpvHTQCG3fAH/0OY+zq4yy8iisHFmqAJRJKI/jcvLzxXKlp2kq/SpT1yMQkOkI
         UJSEYOo9MfkLafDZe1Vr2b/J/k4c+hy0L05+i3qW0RqrUXChvy94wvkh7sQyzYvQgC
         pZe13DNR0Go4w==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-516302ba604so1585011a12.2
        for <ceph-devel@vger.kernel.org>; Fri, 09 Jun 2023 02:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686303174; x=1688895174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRtya9vNnJsHnlJFsQiUMmcKKT8ZGQqP3swgCnXRiRw=;
        b=gmP35N5GBOrEUV+d7lNWL3sAALeMSH6ubWv2bEYwjUanHk3oB5aOuz3Fe276U/CEOa
         BY0hKMbcACWjz9fMeWLyygIJvhRivy4y469vE/NhVoS4KDnvCDKDPi470/QXpD+oL/yF
         lZuiEfgwOaZzItVuydX2N3gPQPFfH6c1nZ1g+KqROHA5dhnqOPelx0Cag4YHvSLnLzOX
         GA+WAmohqrvGOx+1mv2biEHh/eNhNZxQQIsX68OhLyb/wahGyy/bCA7ixTcOydf66ucp
         8OSWVUJTumeQhUEh0wEKq94c/m7DgVXh2xvFqyV0ipBKqfhtfkTugM4zLaEbjOCI2crC
         fYlw==
X-Gm-Message-State: AC+VfDxSwgjGRgvY20q9w4jX+fRZtNVWNMaE5IYQ0r/9sEtgA+RKEHpw
        Y3SnPD7NA8vgLPqSEtUx440RxoEPZSI9z69FP5152tPNEPOGPyw4Kafc6S/q4NOs8bQFqBXoTxV
        6V74EJoPgVAL9E2CbJqZqMWDa8doYIbR3m4Aw4Rs=
X-Received: by 2002:a17:907:9801:b0:973:fd02:a40f with SMTP id ji1-20020a170907980100b00973fd02a40fmr1311019ejc.59.1686303174470;
        Fri, 09 Jun 2023 02:32:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4b1muZvFfgb/c2k7vkkSmRjeDpssO36RsAZdwjRFiNmZVFVAU5M9RWcnkHYxbMHbPnv7UcuQ==
X-Received: by 2002:a17:907:9801:b0:973:fd02:a40f with SMTP id ji1-20020a170907980100b00973fd02a40fmr1310997ejc.59.1686303174276;
        Fri, 09 Jun 2023 02:32:54 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id e25-20020a170906081900b0094ee3e4c934sm1031248ejd.221.2023.06.09.02.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:32:53 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 09/15] ceph/acl: allow idmapped set_acl inode op
Date:   Fri,  9 Jun 2023 11:31:20 +0200
Message-Id: <20230609093125.252186-10-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_set_acl() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index f53f7a758c05..d4be4c2d63c3 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -105,7 +105,7 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
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

