Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FEB76EBA5
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Aug 2023 16:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbjHCOCY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Aug 2023 10:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbjHCOB2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Aug 2023 10:01:28 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632E04482
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 07:00:56 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id ED34E42485
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 14:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691071237;
        bh=ARhwDsiPa3Ci/G2xteJutduXCGuj42UUR3o8sfJhjpo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=YPaEm74UBhZ4IswqsnXdrKtiZbfGJIDdznc2z5O/+/Hw7R9h1SUf8zDpa5fl/i7uQ
         hhO8ROyTwnrq4du4AkmmqVw1ChicBQ6AURI2Q0yJnh689LIN7YRTzsEj8ia9wTU7Xh
         AcqXQo4YPLWw54oqezQUVi7CaQMnfJg72CyH+BnA2u2sOssyESlTMcO1RgaP4NR0mK
         HLSW3j/eho+ucQ+bhpfiJ348Bsj+WZjimmD+REjsTgz8ZnK3o4NSVP0br3BEDDroqw
         cs8LKK9cKSfzc/pjXjYTqmVhwcZbXeUUyiaJHw6SHsJIn2xAVC0ywkhuMwcRuE1ibj
         L4U0/SeC+FQow==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-51bee352ffcso791219a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 03 Aug 2023 07:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071236; x=1691676036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ARhwDsiPa3Ci/G2xteJutduXCGuj42UUR3o8sfJhjpo=;
        b=dg4zSjeYVkPyRIAqq+RtAHRHnjD7gOX7mGFrmy/jD6Bc5/r4hHEFQjjUCozIBU01gs
         56U2/7i3a+ZKkmRTN3+kxP+DzwxWiCl0Ysp+eiV+L9rppk191dIzSShMojuuuYsVS9s/
         TEAFJjKKL6M+g59YPGm/ILutSb3n59LoZA590vPkZnrdjcGfl+8g2+SmXVa5aqA4fEQw
         tZnQFyRAnrlxVeyUgsgaAUznbyEyt8YcVyc5mgR4huVCuiyheAXSNb5ouESsPwNj+ZE6
         LSjm/S6bxOUivGdVHN383B4BtT7omrU/7Kt6NwlUqOUHOxTmo+7fzM9ANC3BR79rmMFy
         evcg==
X-Gm-Message-State: ABy/qLaXrnCoH7wXNDOJ+QKs1F2846F0wI7MtSZPA2IGrP9ubTP475pK
        Z3Lst6gLJw4BONlpirLln57NzRGWexOgw3AbJlLG89cXkmr1So5+b6Y/I/jwJfVqajugJcrLp5j
        vMGz3N73y9E1iNBg2pL3op1XXi1BJhGjJjS4HUJU=
X-Received: by 2002:a05:6402:3d8:b0:522:3a0d:38c2 with SMTP id t24-20020a05640203d800b005223a0d38c2mr7901999edw.9.1691071235957;
        Thu, 03 Aug 2023 07:00:35 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHqUeh1b6pdCPnI6/QplOiCygliR0OiJNslAGmiFZTzhfRRFy9liUqsb+aWN3xG2roMQBYCqw==
X-Received: by 2002:a05:6402:3d8:b0:522:3a0d:38c2 with SMTP id t24-20020a05640203d800b005223a0d38c2mr7901988edw.9.1691071235823;
        Thu, 03 Aug 2023 07:00:35 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id bc21-20020a056402205500b0052229882fb0sm10114822edb.71.2023.08.03.07.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:35 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 10/12] ceph/acl: allow idmapped set_acl inode op
Date:   Thu,  3 Aug 2023 15:59:53 +0200
Message-Id: <20230803135955.230449-11-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

