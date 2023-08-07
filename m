Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4517725C2
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Aug 2023 15:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbjHGNas (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Aug 2023 09:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbjHGNag (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Aug 2023 09:30:36 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AD52723
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 06:29:33 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CA3B3417C8
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691414920;
        bh=xpiLhv9pMb/Lv4/5VSZ89gvBpTNtUdWbUPiCds9RH7k=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=iJdIbKPg+O2J7DvQ41pX+v1KpvDdLawPhVQ3otT2ublXvA5eTTXhRyE1BeaHxsmIY
         q3YlYlQEHWELsLdU61BRBC2lf7qf/1ZYsWhjN4rYx8Qt+1TfPSp3FxxhFY+j3k4um+
         PNWXITW3Wi7bWsdlGoGBPYXuZdsMli9RGG8zpjxu14RL2sd5n5h/4Lnyb2+unv7hIj
         58hzlz7DCZwqmtjETt1FvLJAZxH65cGcMJlumZ/IGaLJ3YWMTep5FQbG4veodJ3iH3
         ZlZJvytKUQH5ybBXLeeFyLepg1kF4D6GPbGApSNhMEhqY+YP7tAKYzGy6biswxqWTM
         HqDY7Xn53220Q==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-997c891a88dso330032466b.3
        for <ceph-devel@vger.kernel.org>; Mon, 07 Aug 2023 06:28:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691414917; x=1692019717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xpiLhv9pMb/Lv4/5VSZ89gvBpTNtUdWbUPiCds9RH7k=;
        b=atKIqErf2ASId64F/11tStz6KEGFQgeCusDKyiLhLtp2VQCPKnFuroIsvFZnR5q8H4
         ayg9CtNfVwcDMuKRZv1ZddvOGsWZvHwF3Y+5IUgGNuFi8UTQSUujI3q/lYtxppxSgZ0t
         A5cdRx+UrnxiBgNMZakDQwzR/FiFBOLbSq1TJXLd+gFvZ7/yc2LwiTJ6xL6jA39/2bA3
         Dzb3j3CnQVHzv1YDHLQkXUYoFl4TwfgzEk80KlcBbAYl+oLMZGN23zy4Ie5QMs7aLeTc
         EVPJZqUc3YfPV7koy9Wtts8O2jYDhWBH60V8Yu4BL6ezvjaRS1zp5+dpAZDezCwj3gMY
         8ciQ==
X-Gm-Message-State: AOJu0YxZYjpCz4tUSRBsvAtZ4Ku1sWxDtbUa9Jm/AR2S534jwwT8gWiA
        wSztjUvVQrd3+1a0neAaQhYKYBTrH1tsIP0S9dqlEEg6aPv4pTtMUJopwlJ7dWfbZYY6vr6pqYD
        nQHcZsbai5Nn0kri2M0VBIUsu7MCYa15kRU/E6Dz2VvaMcYo=
X-Received: by 2002:a17:907:2c5b:b0:99b:d1d8:d747 with SMTP id hf27-20020a1709072c5b00b0099bd1d8d747mr9319740ejc.27.1691414917347;
        Mon, 07 Aug 2023 06:28:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtpifuTuuc4crxqNMY+VAWpJwdyowZ7ngPgg9io1b455puHMLlf5TLmqcm6c+4ofOhD5eVqA==
X-Received: by 2002:a17:907:2c5b:b0:99b:d1d8:d747 with SMTP id hf27-20020a1709072c5b00b0099bd1d8d747mr9319727ejc.27.1691414917152;
        Mon, 07 Aug 2023 06:28:37 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id lg12-20020a170906f88c00b00992ca779f42sm5175257ejb.97.2023.08.07.06.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 06:28:36 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 11/12] ceph/file: allow idmapped atomic_open inode op
Date:   Mon,  7 Aug 2023 15:26:25 +0200
Message-Id: <20230807132626.182101-12-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

Enable ceph_atomic_open() to handle idmapped mounts. This is just a
matter of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ adapted to 5fadbd9929 ("ceph: rely on vfs for setgid stripping") ]
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v10:
	- set req->r_mnt_idmap only for CEPH_MDS_OP_CREATE as userspace client does
v4:
	- call mnt_idmap_get
---
 fs/ceph/file.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 7470daafe595..4a12174b7bc0 100644
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
@@ -802,6 +807,8 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		mask |= CEPH_CAP_XATTR_SHARED;
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
+	if (req->r_op == CEPH_MDS_OP_CREATE)
+		req->r_mnt_idmap = mnt_idmap_get(idmap);
 	ihold(dir);
 	if (IS_ENCRYPTED(dir)) {
 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
-- 
2.34.1

