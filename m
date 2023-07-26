Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B907638AA
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 16:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbjGZOMa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 10:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbjGZOLz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 10:11:55 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF3E2D43
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:11:19 -0700 (PDT)
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1F5F44241D
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1690380648;
        bh=2wRsV5VoJJC+a/Nnh0k6h5YuKsT02FRfB/wC7z4rT6w=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=mWnlX0xUY/njknTI8nuJPNpsXSjn+6wj3BMcL8PFRtjK70xzELB1xi4UMOrsDXJ/m
         Gyk+6jXIM/QCaDVWjOTaZmM7sVv0eRN7tTlZeduPOugGz7tN4OPDeVi/XjEMGhCAxj
         vJACVfWNmDFBjzSNu7DThfzDuvloNRGmR7GeFofxiZw74zUZ1cnnqmu9kA8EqqkDYP
         PyRHIe7g5B9HN8N5SlkfyKQli68xOcAW96Y18G99f1h6NTia816zCviyA5rQV5s8+P
         IPRGTdARgGrVmqjBam3c0BGqjDfGU0eGJugIS+ZC375s41SMc9C6sE7aMB+Ov6te4E
         mitBhjx6jYpsw==
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b6fdb7eeafso56083801fa.2
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690380643; x=1690985443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wRsV5VoJJC+a/Nnh0k6h5YuKsT02FRfB/wC7z4rT6w=;
        b=VTttZVGRWQiTP7JKh5gPVnjgIHy0fsDxwq6HNFi204sf8H1+CM5NmlbSVH3/aTdavU
         LChbF1w0WhpBQUXPPfQdjC6ZibKIOl4cE3BDw7TtEfBHYOSWzNqwvYDuum1UC7ztiO0P
         2HiQ/zPkB3GqC7oOtp2DvlD13mlNwMJ9M3MOTCmzTyg35I7PmQnXm1D4kMj5Per3PBZh
         XrmbYySSDhcxn/uuybMoMuzQqv3K4QgX6aXh9u/kN6Zb1owfS4UZgAEgPSQll/UKwINg
         QBBMbfmFXazJhVzQZp8vEv42fRbHvwazyqjmwrSDi/3ArYOJBhjCyjvLz668JXjwVPRr
         WiAQ==
X-Gm-Message-State: ABy/qLZCNCXVUdxGbnwO++7UnM7fh3rnRDpT9bBxiamuOcYX4X3exknr
        XyWaAraUSSS0ecnezo88aLzVSIvI6qGyAklbfP5EAMs0Kr0KJnR1i4k1OyGehC/QZal9tbZakLy
        cCOINjg6lCMcUpuFgvwXuGoPwj+H4NNARo/QZKIg=
X-Received: by 2002:a2e:984b:0:b0:2b6:decf:5cbd with SMTP id e11-20020a2e984b000000b002b6decf5cbdmr1578253ljj.36.1690380643777;
        Wed, 26 Jul 2023 07:10:43 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFzfOvSVHgN1R2U97B5NMYqDDnWYxKIdEobLA7c0AI/5Ct5RedFqzwWPJru7Kk1HPoq0AB4Rg==
X-Received: by 2002:a2e:984b:0:b0:2b6:decf:5cbd with SMTP id e11-20020a2e984b000000b002b6decf5cbdmr1578241ljj.36.1690380643620;
        Wed, 26 Jul 2023 07:10:43 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k14-20020a7bc30e000000b003fc02219081sm2099714wmj.33.2023.07.26.07.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 07:10:43 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 04/11] ceph: pass an idmapping to mknod/symlink/mkdir
Date:   Wed, 26 Jul 2023 16:10:19 +0200
Message-Id: <20230726141026.307690-5-aleksandr.mikhalitsyn@canonical.com>
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

Enable mknod/symlink/mkdir iops to handle idmapped mounts.
This is just a matter of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v4:
	- call mnt_idmap_get
v7:
	- don't pass idmapping for ceph_rename (no need)
---
 fs/ceph/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index b752ed3ccdf0..397656ae7787 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -952,6 +952,7 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	req->r_args.mknod.mode = cpu_to_le32(mode);
 	req->r_args.mknod.rdev = cpu_to_le32(rdev);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL |
@@ -1067,6 +1068,7 @@ static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	}
 
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL |
@@ -1146,6 +1148,7 @@ static int ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	req->r_args.mkdir.mode = cpu_to_le32(mode);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL |
 			     CEPH_CAP_XATTR_EXCL;
-- 
2.34.1

