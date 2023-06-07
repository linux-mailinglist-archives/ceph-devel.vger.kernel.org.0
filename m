Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EA372643D
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 17:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbjFGPWx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 11:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241335AbjFGPWV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 11:22:21 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7068626B1
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 08:21:45 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DD0ED3F203
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 15:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686151303;
        bh=/It8VSgZDTEKktJxHTMOOJHpvqL0RXNtakCJDr6cWYA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=dFjetVHDMVLaNbrnBpHs0i9uLy+QQMkC4H4gxGEjyoqRwEmlAjKfuZCQEYZ2/Td/M
         Zr1xq73g6GdxV9jn3YPDzxPOtUGEA92MlUHNXTXuuvJUzdlrwMFZMC/qSW6zsAArlC
         /+KAdPfa5/L9ZRh/XSd4aDPedQM+nwPq7jUyiqjceQCzzVWufxZCjDqDqlY9CRCnpy
         4dLGp1TNJzEb3YiJbIB9tskAzJmajFVAin+wfv/DtdHKG6lXFwCtYb7iHluZuHoi0u
         AmKECDsV6KB7xjmeViS8msF9pnTb/6clgXhN/2OHJHKsvWCPSyniF5cJo/JLp2a5xo
         JaCEv3/VkWE1w==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-513f337d478so832523a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 08:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151303; x=1688743303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/It8VSgZDTEKktJxHTMOOJHpvqL0RXNtakCJDr6cWYA=;
        b=Ow8+vpnEpK5hGDY7RAfUBJ2PkhXAwNXonpihwL0+Bt3GQgaQzxOC0TjduUuCDRafxZ
         a10IyPDM4LUXHs/lXsjKET005IsNjxZvpWCnY/hyoMvVZmaJJ3UnKJHBYtCcteqgNExX
         a2hS/T+UFAfio2vdB6LSYMpwKlcEi+SH2m7RCgXvy0DnBhJQd1G6fV6BVAfEOoUqDwad
         K8iPFJLepDgcxdhHDdovEq9a7Xb+1W+r7L7oyrEEthFNDtN73Lzh0Z7BMP+TgXCm3u/Q
         dG32UbggNOSz7zweFy/eAdl1j41vs0MD5FgLi32ChHOYfvRJHLC5AV6129nzceAL+tYh
         dvFg==
X-Gm-Message-State: AC+VfDxIRzUxMtcRc5P3W0uyjqOJrom8Oyja1J3wPs4ZhgrBovY+xexf
        lYLsCHV19wRcSL+UHhYr4Hr/9Fq2RePQZDQEE+NkTrPLKdJtF+bQh7wZdw9Um/aVc3h2QOgQ37O
        X7H3+ZNHn1IMvDEdixmVd6tpS5nAvTPfDfaaVqk8=
X-Received: by 2002:aa7:d6d1:0:b0:514:9b64:e16b with SMTP id x17-20020aa7d6d1000000b005149b64e16bmr4291083edr.35.1686151303273;
        Wed, 07 Jun 2023 08:21:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ549H6QwL6/dPEtGgtxmi5qPiQgs+YkY6irYHiRo8gsOZQw2QXXW6qBLDYK5KPmgsOY3/heBg==
X-Received: by 2002:aa7:d6d1:0:b0:514:9b64:e16b with SMTP id x17-20020aa7d6d1000000b005149b64e16bmr4291070edr.35.1686151303150;
        Wed, 07 Jun 2023 08:21:43 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402129100b005147503a238sm6263441edv.17.2023.06.07.08.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:21:42 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 12/14] ceph/acl: allow idmapped set_acl inode op
Date:   Wed,  7 Jun 2023 17:20:36 +0200
Message-Id: <20230607152038.469739-13-aleksandr.mikhalitsyn@canonical.com>
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
index 51ffef848429..d0ca5a0060d8 100644
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

