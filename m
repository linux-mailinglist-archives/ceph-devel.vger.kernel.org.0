Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D947295A7
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jun 2023 11:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241783AbjFIJlX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Jun 2023 05:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242213AbjFIJkm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Jun 2023 05:40:42 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCC36191
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 02:35:48 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9F0813F364
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 09:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686303178;
        bh=0OC8c+cJXxBkdMyTeJgnYb4yY2v9uQR7p5VsG0G1Yao=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=mrUaKFj+XOfLwURNixxNEM3p7PHqtKZY1kcDCUMH3IC7XWdWsxdkkbgqcuk+YyvdO
         HOY0yxWTDY4WJLqgC+UHqeg1ehQ7K63piqyiweGpFd43JgH8XAjBT0Wsr3Uf2qnHa5
         0E6y5oJy09HRP5ZRlG7A1pYOQ4hQMLHHY/Y/9pPYx2cBYVCz6PTzydCFnZbK4gSDpE
         fVHs/P01WIXwSaT1gjRFp76sNZqv57kU0woYMlDUYU0lbzuFuokCdS8UVHql5eSImn
         6qewdoZcouRl54uYo5U/F/Dms4JK2AWtIhgtAvg8veKZiX4cjDcHMOM9bY2DwP3YnK
         5PR3d3Zv8bQSQ==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a35b0d4ceso151199366b.3
        for <ceph-devel@vger.kernel.org>; Fri, 09 Jun 2023 02:32:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686303178; x=1688895178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0OC8c+cJXxBkdMyTeJgnYb4yY2v9uQR7p5VsG0G1Yao=;
        b=K0iutQ++r4+5cYxZbgZahZX81feXlTlwIVN13fKwqzxWUNuIqK//geUXX8diyFBQWm
         YOHx8pr4WSXAkIGpTktO8Eg39LXNMNgy8DFPi3ea3LAsyBsUUSDtTt1NNLN5E+cxkRwS
         8Gg/kTFzFD6D6cQPu0EujvDc3+cz6piVnJbZnIDRWl62POlnQTK8Fv8h5B8ohXqAE76a
         akSqxy4tXiOE2i3aEhRzWUGQZ/TM+cNW8SgyKGr4/lGqHAshE7qWU5sR+gJ4t1wwijfo
         04YkA0m5DBVC78lYRxpfySd5/PFo9YXJcnS3NagNldcmaHSAN7NmJz6CADBP/+hyc/SV
         GMgw==
X-Gm-Message-State: AC+VfDzB3c9P7rBxk6De8YBUUSweYhu0rBdGpW6a5Uh6qZ/RIvbrAY30
        GZ3l/cMxTJMMOf/S480H+vAmwJauHDBMB/fwKEcA0Wza6sIhJuAUOJiSJaFVmB9Wam0aMTBFaVo
        RkGYCTaktxqg7FfvOpQTajb+GA94dLjpsoTHgL/A=
X-Received: by 2002:a17:906:da82:b0:979:7624:1f71 with SMTP id xh2-20020a170906da8200b0097976241f71mr941170ejb.26.1686303178484;
        Fri, 09 Jun 2023 02:32:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5voXOwgPC15uM3+uocYLZ+BUkJYuHnkJgTaXNTEd5xkSD1BuZvardnf3r8WW0Z6UUfuUwMfQ==
X-Received: by 2002:a17:906:da82:b0:979:7624:1f71 with SMTP id xh2-20020a170906da8200b0097976241f71mr941163ejb.26.1686303178315;
        Fri, 09 Jun 2023 02:32:58 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id e25-20020a170906081900b0094ee3e4c934sm1031248ejd.221.2023.06.09.02.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:32:57 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 10/15] ceph/file: allow idmapped atomic_open inode op
Date:   Fri,  9 Jun 2023 11:31:21 +0200
Message-Id: <20230609093125.252186-11-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
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
index e878a462c7c3..7be172f29c0b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -655,7 +655,9 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 	in.truncate_seq = cpu_to_le32(1);
 	in.truncate_size = cpu_to_le64(-1ULL);
 	in.xattr_version = cpu_to_le64(1);
-	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
+	in.uid = cpu_to_le32(from_kuid(&init_user_ns,
+				       mapped_fsuid(req->r_mnt_idmap,
+						    &init_user_ns)));
 	if (dir->i_mode & S_ISGID) {
 		in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_gid));
 
@@ -663,7 +665,9 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
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
 	struct inode *new_inode = NULL;
@@ -788,6 +793,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		mask |= CEPH_CAP_XATTR_SHARED;
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	ihold(dir);
 	if (IS_ENCRYPTED(dir)) {
 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
-- 
2.34.1

