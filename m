Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248E6726822
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 20:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbjFGSLb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 14:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbjFGSLI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 14:11:08 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D004A1FD7
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 11:11:02 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E2DD93F19A
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686161461;
        bh=/It8VSgZDTEKktJxHTMOOJHpvqL0RXNtakCJDr6cWYA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=nHsfOAM2JTgdYRXYMwvgVrNqXFmxcPJLy2hz/PsgwFP+vqTbNRiWAuWxhT3AGa87/
         PF7aLiMkf2yCuUcKBGmXPky05NZJDv9EkbZI7YhigPg5czx0ZUmfdZJl3J3Kuqvb9z
         uv947aSvfsXGSD9ldetYGafHV1F6YUUr+uKY6Ca+EY1URK73oInKQK3FKubrMFLmMI
         HPo6KmmkispFyhTbK2NDCF/z4o5n6OMwJlBPmPreoiSr3JLcHbCCncyx7ZR6AGUwIW
         1ttNVj7Uh8P29TY+k0esvUiH6kjiFZekSnGDfh4CWUr0p08q+z6e0kgXXl8LKpatkk
         1EgmYOScgB/Fg==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-977c516686aso503056866b.1
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 11:11:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686161460; x=1688753460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/It8VSgZDTEKktJxHTMOOJHpvqL0RXNtakCJDr6cWYA=;
        b=H1RNnjb7qHG0gPtrTDD3BHKzgLUN3KuZR3llPQBjOglkPVMTB3Vrqz4IS8QTbcPzeg
         FO7A7HMDqwMRKtysxNLWZGK9+PUZF4naTZPo35AUHNJX3Rdioz5OZBskbsuphZHpAxv3
         OI/pv5Q/8IMfTcla7JgskS/fJUOM9DqhCMUJ4LZVbfYlUVB4pJKjj2lzkzYzru3mTUx0
         6zKHEFsyZBJyoi/64NX1XAJnnUGlMZUpNKF1O3rV0OVcFQkVtRZ1+yw6gZxxAHnKbs99
         OYw77ZsUS+VxXCiOdzu/Z3xtca0vVCKMS2g1k2TQWpuQmcYW5meGnrnB/wAbh8S1dchd
         dOJg==
X-Gm-Message-State: AC+VfDznDUlkWkMatPbAFYZFuOMyYEV2tnySNsvnV/aYrZDBfIgtXm4x
        LcvR0VPLAt3pJhxvAceRPtWZV6X1iY8f3ZMfV5kvkKGfU+Y+93lMUPMF1UEZTfPbEcILMaDRwhO
        cdyoOCpSe98SHQ02Ff1d7Ur861lrI5OPpjNZK1VkYH6WYeJ8=
X-Received: by 2002:a17:907:3e1e:b0:96f:b58e:7e21 with SMTP id hp30-20020a1709073e1e00b0096fb58e7e21mr7447667ejc.52.1686161460433;
        Wed, 07 Jun 2023 11:11:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6E8Zoczui2SA997DiFkrKyZP1txEaL4imA8LjlOgAING0rY1a/TfTWY9iSvaNKd09APPPgiw==
X-Received: by 2002:a17:907:3e1e:b0:96f:b58e:7e21 with SMTP id hp30-20020a1709073e1e00b0096fb58e7e21mr7447637ejc.52.1686161460189;
        Wed, 07 Jun 2023 11:11:00 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id oz17-20020a170906cd1100b009745edfb7cbsm7170494ejb.45.2023.06.07.11.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:10:59 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 12/14] ceph/acl: allow idmapped set_acl inode op
Date:   Wed,  7 Jun 2023 20:09:55 +0200
Message-Id: <20230607180958.645115-13-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
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

