Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914FF726445
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 17:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241362AbjFGPXO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 11:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbjFGPW0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 11:22:26 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88C62721
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 08:21:53 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 261FE3F7EC
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686151310;
        bh=sitF6aKufbc7DklTCjus/+uMnJoHcKEt7G8gHEJda3g=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=P/D8AjrULi8QbykhmIESppG2V5dwmDG65C6+Y/Lc/lyH0PwChBwUDbTr4nb5QiRH+
         AzfvzI0UoVv8ng85DoP90cKJBO2bjPXewzWA8ALtYxm/8PlLklLwE0jdOaCQZRWs1b
         voEY8gDTEW/lXDAzoQMTYuYsO1Nq1NDNjWc/dlOyK/cYL6kP9JDh7hQZlhBE2s4LfW
         v5ohY6pCKOwCOBE7UQSt7KP7AJOj99GbY6qmgTm8ycB7YPptofCEfY9ayYiaIlAJE8
         n+ZNuWnmJ13K7qVI4ZkQiHdCNt8yNqauTdfZgImKHCYHUaILMLtKTB+Mkt4eABVPse
         y5o/M7Ol6uz8Q==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-514a6909c35so1106977a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 08:21:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151308; x=1688743308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sitF6aKufbc7DklTCjus/+uMnJoHcKEt7G8gHEJda3g=;
        b=AAXZi9ambNd6QUDKoL1N6c3sT9KLsWPUksy9rMZck//lj8fD5geAa5SKMaK23gGDOG
         OufBPiaqymog5sPgf0C/hOedgOD4qHs40zBeRdAaum7vaWSOToaYpdqCU2SndR7VFQoK
         BrZ4+pKqlmLqMqYe1ZNP6YtEpd4R64IZwyD9ZswTuqfiSovnckyDcDdLNfskFtCn9mqh
         wQqQsYyjdy2kWwlELvYGVQxFMv3iwoMX4ErMeZ+R/qmWNFBqHZTw/lmMD3Z2B3ELIRZv
         zFMpGuGBKbEVAhWvkwAcuhfFiAAgTbtb2VvzGS6HG4BLjh6bZ21QTiHSVh3V7ycR8r4i
         iY4w==
X-Gm-Message-State: AC+VfDwGjexa1ug4jAetO8nSFbFwOQMaysO/y9Hwfu/vyVdy0KOUkqOR
        vJ+/xTwHAlnHn4+8Dc8eNBIL7bkleRXswiopmJ63n7Vnvyzye4TPpKELIbxZ61zOpkZ0jcqrYZL
        MDH6t6fixC8Xt2nH6OnMWqdulxh2HIpmNN4K762A=
X-Received: by 2002:a05:6402:31e5:b0:514:9422:37dc with SMTP id dy5-20020a05640231e500b00514942237dcmr4479644edb.6.1686151308084;
        Wed, 07 Jun 2023 08:21:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6RVi6/fukZeNZcvZRzUwSUGXDPAwHYX90ZNHPzdh9z1jOlvF2lCQ3DOS9NFUQhNAtgVCXjxQ==
X-Received: by 2002:a05:6402:31e5:b0:514:9422:37dc with SMTP id dy5-20020a05640231e500b00514942237dcmr4479639edb.6.1686151307933;
        Wed, 07 Jun 2023 08:21:47 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402129100b005147503a238sm6263441edv.17.2023.06.07.08.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:21:47 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 14/14] ceph: allow idmapped mounts
Date:   Wed,  7 Jun 2023 17:20:38 +0200
Message-Id: <20230607152038.469739-15-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
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
index 3fc48b43cab0..4f6e6d57f3f1 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1389,7 +1389,7 @@ static struct file_system_type ceph_fs_type = {
 	.name		= "ceph",
 	.init_fs_context = ceph_init_fs_context,
 	.kill_sb	= ceph_kill_sb,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE,
+	.fs_flags	= FS_RENAME_DOES_D_MOVE | FS_ALLOW_IDMAP,
 };
 MODULE_ALIAS_FS("ceph");
 
-- 
2.34.1

