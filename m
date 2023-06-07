Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3ED726820
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 20:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjFGSLd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 14:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbjFGSLK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 14:11:10 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389251FD8
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 11:11:05 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B29CC3F15F
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686161462;
        bh=Q8ymt4aVYk7+c3UhjbPSUCbNsUrFX+gS8T8907goBG0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=tsLYUKSii5zxtQ5kKmxikcnkrgLlRShfTyUE6e61a+5VuR1S6Isp41BE4bTGGXazQ
         8Vd0UkZU1An400qfxwlpaa8zwBLqlsF4D/uNkw6n/GAZtFGpFAp9DiTE0VK6SwPijF
         hkCLeJEXcgx+SUpb1JADnGsROAd81JELj4QfCvB2xl9djQPIaUQijsKHEHRumJDitk
         UO0ygbfHj9fRBJJsHCrBfPlVm1UsU8WEC3goJ6TPX/q3WG4iCynpNYC5X008sMaYCB
         3eYEcrzbJawHtqyvhapRWd8/txOxG6OE0K7IRYXESVpj05rR7qjd6haNoQSR3Jj/dX
         AdANcN6QDyyaQ==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-977d0333523so459108466b.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 11:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686161462; x=1688753462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8ymt4aVYk7+c3UhjbPSUCbNsUrFX+gS8T8907goBG0=;
        b=f75SkqTRelh+uM9ts6XaqJ+oEgCFXBCqGFZCdfRWh+OOUo0PaHf6sb/mCX14YW+/7J
         0/t4OfP8IEhzr3hG7+0Qi+5uXy4wasfhYFQuqO1/tWuI4Q9gikJpKYtrUwOJYekWnkct
         mSzCzDZT7vyGQGUU9WQzRF/eQ+IMJEE6x1q/3JpSK2RxRb+bLQ0b5b5bVmQSaIz0UIJ5
         gN6Hxo62NtKCmxKcGgNwxD3XSC0/fiBwuXGeBmJp4mOutSf79JISXNLJWMiG0pt/pwrs
         cm4C0CvduaLLJIh/K0STTYbCOifgkBsG1+bk7m4QBISQwuIpjwFXP31jR96K6YNzLGod
         6RSQ==
X-Gm-Message-State: AC+VfDw9acoqOROkvt2WzRhoNoUEUVEPOrrjbNfSA9MitNt1LGlxw8YB
        tqpU2FxItSkXBGEERMF2sxOevo4VZ8geT9iaxvL6UFRHvP1zz288POudr4yUThnig0RNiwM6c4U
        gHdn1CQH+YUTwp4Mjo1dGRZjDY+uVbZXZkbhQLb0=
X-Received: by 2002:a17:907:7f1f:b0:974:55ea:1ad8 with SMTP id qf31-20020a1709077f1f00b0097455ea1ad8mr7592636ejc.63.1686161462572;
        Wed, 07 Jun 2023 11:11:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5AO95yaH2w6TNG96NHW4iHdRlf1vZtWQEuXgXYJPWouo+o/lvalFHXgEOHSNKj0+5C3pDw1w==
X-Received: by 2002:a17:907:7f1f:b0:974:55ea:1ad8 with SMTP id qf31-20020a1709077f1f00b0097455ea1ad8mr7592617ejc.63.1686161462384;
        Wed, 07 Jun 2023 11:11:02 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id oz17-20020a170906cd1100b009745edfb7cbsm7170494ejb.45.2023.06.07.11.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:11:01 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 13/14] ceph/file: allow idmapped atomic_open inode op
Date:   Wed,  7 Jun 2023 20:09:56 +0200
Message-Id: <20230607180958.645115-14-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
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

