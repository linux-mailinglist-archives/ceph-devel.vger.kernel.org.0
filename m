Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D7976EBB0
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Aug 2023 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbjHCOCc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Aug 2023 10:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbjHCOB3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Aug 2023 10:01:29 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3498449D
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 07:00:57 -0700 (PDT)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4DDE0413E8
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691071243;
        bh=VUgFUdqFi9+fVf4KBmHgMSHcrOKks48HLHXKSZR7nM0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=C7BCdiRBul4QfjxUOnXsGw1mv1e3bxAA3Rz4VmZIh2oOA8cuTQ7tFa8mmDnGHcMoU
         wKU/AmteQYA3jPUpzkFUFYxF/zSMKLjxXkoylxWSkfHDjErwcfWGV0pgEojXVGsX99
         jLzXfQcmWey6GHRi3hvtJavH7mqFzTFWr9MDs5xCUshzDAUzxq2rKEH8gfKObwS7A4
         1IoVL9MGYP5QK7y0NQG49hDyBeLENY64W7ZFUV3PNhaxTwFaymvz2V2hqwr6NMROSc
         hv+goSrjz7+/4z5R7IM/Sks7mYIUzDP7vNgLl87CHzBWms78MYcAG8r2jNOXt9mEYj
         oG+Vhl6+FX6mA==
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-52258599da2so678665a12.3
        for <ceph-devel@vger.kernel.org>; Thu, 03 Aug 2023 07:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071240; x=1691676040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUgFUdqFi9+fVf4KBmHgMSHcrOKks48HLHXKSZR7nM0=;
        b=WmJqV71CX+OfXChQeEDLMaNgCTWg6PtsjFaWI0TocffNTvEmnMAo+XZ21SSXB1UAJs
         fMioS6g1xSosLypLDonJgzWgPae85w0VdMDFw48/QxsAQP2UxFk6e4ZqylMp4YEmXOwT
         fVpRxI3KW490MOxSbq5yuimAtXbz5wsWdHoqbNiD6zIRypiN6Dv4v9L58JPhZUcbWCs+
         lVgjaGMFpnSZD8iwH/QLu0IzX7WGzH2z5OwoJFRQzboFrh7w4fF8nDAzjP9fdC3rTJGQ
         rGuBiXehzFhoj32oKsHEHTY0C+R4/N1k43coBLLi4JeGQ9YxLS2txx4kuP/v2JeakeDm
         IpKA==
X-Gm-Message-State: ABy/qLadlZqxCJWl1HNLH1LV3SR4HSfh6dIhwrhMP279HCPzbkUKRUsS
        zIO1S5M0apRRs96SrJ/rTIdSNlv/Z958/TgB7KYf8Y8OCFYMCg6UqyVOizqmV6s6pcjPENECvKr
        kqV93jScaZP86r/41GTw/rTiHbKt3UM/u2CnlxS0=
X-Received: by 2002:aa7:cb48:0:b0:522:37ca:a51c with SMTP id w8-20020aa7cb48000000b0052237caa51cmr7051508edt.40.1691071240822;
        Thu, 03 Aug 2023 07:00:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG6Q02R9Pwuh55imXZTjVXNaetMucDVc5mJ3+DcQHv4FmT8HpUH72N1OhXDUzrzxEYbQpmVdA==
X-Received: by 2002:aa7:cb48:0:b0:522:37ca:a51c with SMTP id w8-20020aa7cb48000000b0052237caa51cmr7051500edt.40.1691071240663;
        Thu, 03 Aug 2023 07:00:40 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id bc21-20020a056402205500b0052229882fb0sm10114822edb.71.2023.08.03.07.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:40 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 12/12] ceph: allow idmapped mounts
Date:   Thu,  3 Aug 2023 15:59:55 +0200
Message-Id: <20230803135955.230449-13-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

Now that we converted cephfs internally to account for idmapped mounts
allow the creation of idmapped mounts on by setting the FS_ALLOW_IDMAP
flag.

https://github.com/ceph/ceph/pull/52575
https://tracker.ceph.com/issues/62217

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 18bfdfd48cef..ad6d40309ebe 100644
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

