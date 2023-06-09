Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5AE7295E7
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jun 2023 11:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241880AbjFIJxJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Jun 2023 05:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241034AbjFIJw0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Jun 2023 05:52:26 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26025BB6
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 02:44:56 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6B0F53F373
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 09:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686303163;
        bh=LI2l8EJ+sB/HFX7H7shv6XhttNoaeY5XoeYDpHH2kwI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=AMMyW/NK+XcsRtAcYWPGiSDChEYT1Ej+2sM67810W4WhrtpRy4UerOgzFyoo6HkTS
         hTr2LY2UWrDntAyvtD0m1mfYocjm4Cl20RxaW4jUwoXcI0jE1k9SmWpsvYqtvadlXI
         mx1s9eqQfT2rfdycg95gem7N88obloUfXRv0mf555g6JtJQCcOp0Up7mXKb2ckj50/
         pX1E+rOkIZjiQTdZu6WgZvN5E87bWZHSpgFSm8R0uwSNWb7HIsggYh1Z6pYO/DDchi
         tORhSWC4FoIxy1yM1K3xIlHiOuCTD8agGK+UELcZFGoow/CpPYhGKrv6y6mKFaCAhu
         lvigP3aBY+M3g==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9715654ab36so152702166b.0
        for <ceph-devel@vger.kernel.org>; Fri, 09 Jun 2023 02:32:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686303162; x=1688895162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LI2l8EJ+sB/HFX7H7shv6XhttNoaeY5XoeYDpHH2kwI=;
        b=NHHEK+n5rpuU8zN1ySrQ5xyR8izquGHb7+cDsjDkYPrVSriSmwpcPiGZrU9vK8lfXk
         U8xn6jiJKVFZxUETdbNgpwjfj0eBJQx144OKeOQkZCE6vaHMj2WBkav7ND49+4HNOs21
         tJsr9EvS2uUCLb4VfKTKd+0tJ4z20qo7E3bSSsZbANWhYPDndw1g4InIOYha4PQkPC7A
         3K3uGSsbzcKRDBs+aF3Bebj3qhscoMo4F42D6lCmeylZu4Q5cv+QF+zJHEdECremovqh
         y7NPnUTHnnR/excVdzLuQ2QZUGvW/8/EqMrS2XD5Yj5uE+yx5kzygIKmJgPlls8kbXwX
         kSdg==
X-Gm-Message-State: AC+VfDxDFAWFq7Ej85CHWcjRNsPGZylnPHBEq4hdhVKCbI/k9/DPnibn
        ZdWy4qC7rQy5qfSe9Ra3fmR2h2SVnjRb20lkQoJ+BFFIHXwQoZD8pZjuTIQn5rP5oQ+SobR4sl6
        pEW3yWZvbssrYd/XdDd506KXIoPDp9i//ZEMvs6Y=
X-Received: by 2002:a17:906:9b85:b0:96f:dd14:f749 with SMTP id dd5-20020a1709069b8500b0096fdd14f749mr1013831ejc.23.1686303162164;
        Fri, 09 Jun 2023 02:32:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ77wxEqwisvkM7+2vPR5pOe0yqJEVm3fqKHexLUXhCzHN6fLXH9IQYibj/vo6ANsqqCr7Q5EA==
X-Received: by 2002:a17:906:9b85:b0:96f:dd14:f749 with SMTP id dd5-20020a1709069b8500b0096fdd14f749mr1013810ejc.23.1686303161710;
        Fri, 09 Jun 2023 02:32:41 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id e25-20020a170906081900b0094ee3e4c934sm1031248ejd.221.2023.06.09.02.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:32:41 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 04/15] ceph: pass an idmapping to mknod/symlink/mkdir/rename
Date:   Fri,  9 Jun 2023 11:31:15 +0200
Message-Id: <20230609093125.252186-5-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
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

Enable mknod/symlink/mkdir/rename iops to handle idmapped mounts.
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
---
 fs/ceph/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 1b46f2b998c3..2c0c2c98085b 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -923,6 +923,7 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	req->r_args.mknod.mode = cpu_to_le32(mode);
 	req->r_args.mknod.rdev = cpu_to_le32(rdev);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL;
@@ -1035,6 +1036,7 @@ static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	}
 
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL;
@@ -1111,6 +1113,7 @@ static int ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	req->r_args.mkdir.mode = cpu_to_le32(mode);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
@@ -1422,6 +1425,7 @@ static int ceph_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	req->r_old_dentry_unless = CEPH_CAP_FILE_EXCL;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_XATTR_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	/* release LINK_RDCACHE on source inode (mds will lock it) */
 	req->r_old_inode_drop = CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EXCL;
 	if (d_really_is_positive(new_dentry)) {
-- 
2.34.1

