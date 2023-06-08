Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6507283FE
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237430AbjFHPor (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 11:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbjFHPo2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 11:44:28 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8F235A1
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 08:43:58 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0FF9B3F36D
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 15:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686239027;
        bh=/It8VSgZDTEKktJxHTMOOJHpvqL0RXNtakCJDr6cWYA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ObtfvNV2iw12/IKKewTsdrTLGAno9BpIqYam4KC64dfWEm5G0JJ64DRHJ1e8mkoyx
         ttRgItwONHhWFfcR0VBUtG5prTqxUtw7N0FU/SqUyXqp5Qc3OhIbAj5iVfRrCKZfKC
         p+wEgBekwUAU/KGv9+VQFUGWptT8kBiDkQcMwsMNTuTt3ewQEPA5EO2MvMZGBdcfVv
         M30u0rfxNRykbLTcLy9wVQK2+xigYKplbtsuWxToDgs3YacfdnEflTOjK4B05WGtDA
         4ybidUpvrKd0K+kFa63W/ovy7UUrw0BRw25yJu9B0qVG4HKtxuJhDSVpuwhS8Bn/3P
         0mxOuwC67Te1Q==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5149385acd0so825219a12.3
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 08:43:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686239024; x=1688831024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/It8VSgZDTEKktJxHTMOOJHpvqL0RXNtakCJDr6cWYA=;
        b=Rf/VjYzSkuhDe+klhMlv3zdHNWVJMbrNgHlK1M7KAxeevTKxsBk6L8gLu1uWdOrkAA
         wV8L8c4/zmkGGzaptfHobwY9F3j2vKEMUeVKCqKVMmuYyYFqwclln29k+2r5p2FcXwP1
         kyjp279M4Y7HNghoOokLhVfX4gDlXpnTUg1pCM7caxpnj7z7VqmhS7xMWLpBu/AW+OM3
         1RsZR7Y0f8ga8Dxm+uYAKb8OmcZGGp4Y5H4YihC+eYs14TEq+K0NyECvJaTydsxrpfV5
         T+hTUFuUySYrLI/RqxNRrGE519cNTDLjUyOdccfJpWPtwh6mefY/Ci3OSU2tC5TmdJJr
         MnWw==
X-Gm-Message-State: AC+VfDzokQrxn97e2ncGT/WCatllhKztma2tPPJXPEgD57jMv+KrmuNP
        X17plB90CtF9jXD55QelHHIW2S7NiiTGUISDvMvzxnVvJII0/BduvtAOjCNds/HCYW7qIDyEFjI
        DcnmGXQlRZ57tCiYDpLcB1jX5DKgso6o3Sf6pVzQ=
X-Received: by 2002:aa7:d88a:0:b0:50c:cde7:285b with SMTP id u10-20020aa7d88a000000b0050ccde7285bmr7205762edq.29.1686239024658;
        Thu, 08 Jun 2023 08:43:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5tT5xavWGRWqFP+Xk984KHDRSysXvYgAU9oqoxCsm4e3n0WS1ECv+yEbe0VUIEcNDMbW8raA==
X-Received: by 2002:aa7:d88a:0:b0:50c:cde7:285b with SMTP id u10-20020aa7d88a000000b0050ccde7285bmr7205750edq.29.1686239024530;
        Thu, 08 Jun 2023 08:43:44 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id y8-20020aa7c248000000b005164ae1c482sm678387edo.11.2023.06.08.08.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 08:43:43 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/14] ceph/acl: allow idmapped set_acl inode op
Date:   Thu,  8 Jun 2023 17:42:50 +0200
Message-Id: <20230608154256.562906-10-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

