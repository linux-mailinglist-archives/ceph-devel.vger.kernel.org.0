Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6617638B7
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 16:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjGZONa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 10:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjGZOL7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 10:11:59 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF5F273E
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:11:26 -0700 (PDT)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D742942420
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1690380657;
        bh=dyH4eLS/ZCdAMtA+4CRaXqW6UBtXDh7SsBX0oiAwXGM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=vrFemL4Ec2smk+Sa0QZbh1MiSHejdza8xOU55FXcQ7Aheo4MisBcsHYdpdPrJ6y6O
         vcxXcWJiznmVtWalliJzCbu74qLnwL2wQTDJaqMJnQEGm/j75IdLHA1gElREqpib4M
         B47belt8c9Mbh8QzsfcKYamjR6jlraE5t0XyLK0bIYVbHNjh4Cearl7R6u6WiaKi0b
         6/067sAjAEqqFnIOxl/x1PKkKcPVJSlQx/nue5wlvOAPFutl2iybmj0zez02eoKZyO
         cP5YW+Eo3dEskR0KJPAm0OSUgy45/ZTmVz8qKdvcYHQhWV9G6hwNAJA57qj3FGutXI
         p05eXP996F6Sw==
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fbdf341934so40279865e9.3
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:10:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690380656; x=1690985456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dyH4eLS/ZCdAMtA+4CRaXqW6UBtXDh7SsBX0oiAwXGM=;
        b=a+W0CymMSLp5kn8UUX/TKXmxGTtnwOd1HWeuF/oyM1hw9yDrgLYiPjTX00ZXDPLGMT
         j+YGkVT5Zs4s3ZJLMHp+PZ86XP5/0Zga/X3ziCR35ho3LEWx/26mjqdcWxtVU5lb9Yki
         Ia3DfuiAp7sDFEtQvfv0e0TazG/yzu1JkX91ynCDEWlgctgN/sJqhGVnxwPvVQEDMCkm
         n8vJCcXr+rANkewJdpZRhzIYtrNQdHhhIz+P9D4hzPlWPCCQDyIi/JEbHa5A6VgSArU+
         I9MWkc9wN8bef/nFm5nT8BWQfDQGoGYNTYENm2lzaMvv/gfJXNLv4edw/nRrRNiUnUNt
         MJwA==
X-Gm-Message-State: ABy/qLZS6K6Ibn1TbcqXdu58ur0rCFJcDBsW3lh78P4mQ5van7LPKD6h
        c+/s73SprSH+jW8USRiuB5/P798RddLAcCaN4udT9ms8v69TFkOFmiXyHw/ZMxk7JvTev//IciN
        hLZDQWezgUpEJOt+8A2HPJdsKBLQKi7lhnBqxJAg=
X-Received: by 2002:a7b:c3d9:0:b0:3fc:855:db42 with SMTP id t25-20020a7bc3d9000000b003fc0855db42mr1517993wmj.34.1690380656673;
        Wed, 26 Jul 2023 07:10:56 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH7igXsZCdDZ+9aNp4I+OUG6/RPWtxjCijXvhNNhLiLg/iak67y70pTTfQ0BN6X+GC66gvhgQ==
X-Received: by 2002:a7b:c3d9:0:b0:3fc:855:db42 with SMTP id t25-20020a7bc3d9000000b003fc0855db42mr1517986wmj.34.1690380656489;
        Wed, 26 Jul 2023 07:10:56 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k14-20020a7bc30e000000b003fc02219081sm2099714wmj.33.2023.07.26.07.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 07:10:56 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 10/11] ceph/file: allow idmapped atomic_open inode op
Date:   Wed, 26 Jul 2023 16:10:25 +0200
Message-Id: <20230726141026.307690-11-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com>
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
index 7470daafe595..f73d8b760682 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -668,7 +668,9 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 	in.truncate_seq = cpu_to_le32(1);
 	in.truncate_size = cpu_to_le64(-1ULL);
 	in.xattr_version = cpu_to_le64(1);
-	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
+	in.uid = cpu_to_le32(from_kuid(&init_user_ns,
+				       mapped_fsuid(req->r_mnt_idmap,
+						    &init_user_ns)));
 	if (dir->i_mode & S_ISGID) {
 		in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_gid));
 
@@ -676,7 +678,9 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
+		in.gid = cpu_to_le32(from_kgid(&init_user_ns,
+				     mapped_fsgid(req->r_mnt_idmap,
+						  &init_user_ns)));
 	}
 	in.mode = cpu_to_le32((u32)mode);
 
@@ -743,6 +747,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		     struct file *file, unsigned flags, umode_t mode)
 {
+	struct mnt_idmap *idmap = file_mnt_idmap(file);
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(dir->i_sb);
 	struct ceph_client *cl = fsc->client;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
@@ -802,6 +807,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		mask |= CEPH_CAP_XATTR_SHARED;
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	ihold(dir);
 	if (IS_ENCRYPTED(dir)) {
 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
-- 
2.34.1

