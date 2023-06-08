Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D557E728403
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 17:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbjFHPpA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 11:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbjFHPog (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 11:44:36 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D4D30E1
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 08:44:04 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id ECC143F466
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 15:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686239027;
        bh=Q8ymt4aVYk7+c3UhjbPSUCbNsUrFX+gS8T8907goBG0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=BGqEI8qCHxOYtapB0SRpXTz3tiuulDWtRLvtxc5YNoZQLqUCE2dV3meQV1Mgol7j/
         QYbNWw8Ja2pa+Wgv1PSW3sg8oIRKFyeauYeNNxRKVNRlBkcpkSpQuuIyJRXQMgGAqI
         o6MNP+5A7M2GHkfY7Z5wO06pGpSlUaLaVLRfozNNLz/1lEFwFpXTbJ4rEHpG0bu3ZJ
         H8K6Kd19QF7gavUk5prBU4YGxfBV/NiwZfZWlKQu6JIxP0mpYN7ftSTUipw40IOD2W
         AE5GbFRSNwIsqTWePhJxTe1CwOgXUZ97bUNtIZjGUuP+8zg0ed6rkV1LFM8D+NOG84
         wV7Av5Bkb1Dcg==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-514a6909c35so793668a12.3
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 08:43:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686239027; x=1688831027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8ymt4aVYk7+c3UhjbPSUCbNsUrFX+gS8T8907goBG0=;
        b=Zo8sjwnyAYnGBNyM1a1aYNyAA2Mn6YTFiRPd/a+diUQDX4O71XMyDYkMCRvkaVvwzl
         gUdPKt/ZAcHWJwhg3yTkKuYcmZJ5T0X6MjmvdrhvYFi0lHaWfgoU3h1vXRfx+qzzhmpF
         X01TXArjLndsRT9SGPy9InSQfAsS1iBy/1ZRM2NdqgR/rBESs9sO3rQy3buwHefzbmWK
         5ogS7HXnvGTaup+cRiC7+G5r2iTxAA4gQ+cf8Y4LgZNaI2Vg6ybI1CC6xIRg2xk9UHyW
         8bffvlnTVP4yWQVqP+F2aSuGOikUPT9hytlDc38VJCZMyNGpJ8z3uu+ia1AsT1o9CO/x
         b0/A==
X-Gm-Message-State: AC+VfDwsgyl4T09R4GVoEzcC0ngWuYFuXOpGggh/B3p0NtG8Ffs5SyN/
        D6tUV8pwn2YyZJMg/4+V9JKsI/dJIvs6Edm2+46Xte0OvEoih6IWNQJsXbiAOzOM2dd9TsAGbdu
        dHemVJ1QZIiSZ39xje2/uI7NhGrSn7GHJc+9FlCQ=
X-Received: by 2002:aa7:c7d4:0:b0:510:f462:fc47 with SMTP id o20-20020aa7c7d4000000b00510f462fc47mr7221337eds.7.1686239027038;
        Thu, 08 Jun 2023 08:43:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5SIwlHUtUQuOR+2n8x3ozlfAhG+H692BA1AqZYBvyR8GuRlxkZ3QdxFRxS1M3KIsoA0ELo3A==
X-Received: by 2002:aa7:c7d4:0:b0:510:f462:fc47 with SMTP id o20-20020aa7c7d4000000b00510f462fc47mr7221325eds.7.1686239026831;
        Thu, 08 Jun 2023 08:43:46 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id y8-20020aa7c248000000b005164ae1c482sm678387edo.11.2023.06.08.08.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 08:43:46 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 10/14] ceph/file: allow idmapped atomic_open inode op
Date:   Thu,  8 Jun 2023 17:42:51 +0200
Message-Id: <20230608154256.562906-11-aleksandr.mikhalitsyn@canonical.com>
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

Enable ceph_atomic_open() to handle idmapped mounts. This is just a
matter of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
[ adapted to 5fadbd9929 ("ceph: rely on vfs for setgid stripping") ]
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v4:
	- call mnt_idmap_get
---
 fs/ceph/file.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index f4d8bf7dec88..d46b6b8b5fcb 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -654,7 +654,9 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	in.truncate_seq = cpu_to_le32(1);
 	in.truncate_size = cpu_to_le64(-1ULL);
 	in.xattr_version = cpu_to_le64(1);
-	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
+	in.uid = cpu_to_le32(from_kuid(&init_user_ns,
+				       mapped_fsuid(req->r_mnt_idmap,
+						    &init_user_ns)));
 	if (dir->i_mode & S_ISGID) {
 		in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_gid));
 
@@ -662,7 +664,9 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
+		in.gid = cpu_to_le32(from_kgid(&init_user_ns,
+				     mapped_fsgid(req->r_mnt_idmap,
+						  &init_user_ns)));
 	}
 	in.mode = cpu_to_le32((u32)mode);
 
@@ -731,6 +735,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		     struct file *file, unsigned flags, umode_t mode)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
+	struct mnt_idmap *idmap = file_mnt_idmap(file);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
 	struct dentry *dn;
@@ -786,6 +791,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		mask |= CEPH_CAP_XATTR_SHARED;
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	ihold(dir);
 
 	if (flags & O_CREAT) {
-- 
2.34.1

