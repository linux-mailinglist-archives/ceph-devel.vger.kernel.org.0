Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EEC72840E
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 17:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbjFHPqW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 11:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237416AbjFHPqD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 11:46:03 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352053C0E
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 08:45:15 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 566373F537
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 15:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686239035;
        bh=MRxl+h7O52u/Mhs3Xvpqf/AHss8SBrlV6qztFSPEq4E=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=oAjswmV0RQuZTyKzf4M1ahiTaVsJJ7Y0Jd7y7lbClp5uoJ+45k9JHag2Y3r+Hd1Sx
         ryw1yQizFXPmAglU0+9D5zR8u3sXuqW8xz1X558LP5ekSeOcxD8Wzf27DCWUiX3cOV
         NZcK/+cw/hmgs9xLmaFpu9/eFsKh6doTNucHnyAmaGLDIsQq0CHlex5GHSG+ICJ1iv
         jHvRVpL/of4hgvXBlfjgJa1qfI93xcSz0iYELeA9oXJ3TKfi7ZLw5FArQoea9yNcg+
         BC7v41GUQJO29RqcQIB29ObBM1yumjDAc536xqhlh0ZPfkpFAM5IrWmvqPMmHEFU7P
         PoZzVgXsLXU9Q==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5147e3dfccdso699106a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 08:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686239035; x=1688831035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRxl+h7O52u/Mhs3Xvpqf/AHss8SBrlV6qztFSPEq4E=;
        b=dH8eXXGOu7norXkblcTtf7O0o6D+tKW9Lv9xHFDp3IN3TXjOFIMLlHlqqtIHLvcTNV
         8zQLnhyqooOTg7C2cZVGz0cTCJkY1Dr0XA/4ZzQVWQL+hV7nFzZKEqeY5uCP0gbwuJ8m
         DaPARvCC7jyZS6VjyTMVFP0+SUpIsBKRFNEkiM0/BBLJmzNrr31A5QZrYReErP9epZSx
         kohvOKvw32d5PzDHkiMSY2YUfd5k2NQ64n71bV14N+wZr+mAuA3DXkwCmeNWWy0OqbDN
         lXei6nY8OTP+PBatGa1ThmfcNpIsmL+G4qxp966p8YMWrtGy/uWw0Mr3YG6/b0QwpxGy
         bg/A==
X-Gm-Message-State: AC+VfDxMAazN7gLLcjYCVc08VRwy9wLpkpWv7GZ9JT15AjzC8LpmRJ8b
        iC781FPfL8EX2vtwO6iOjxV5l5xJ8XH7LQqcsBXrsHuTa2bxIs9HYJ8RSxvTQTEyOPN7gIUtuCZ
        mt3KGn8AuimkNq1zWmCo9cG6V1bfC5vDO5IQhQGc=
X-Received: by 2002:aa7:d9c3:0:b0:50c:4b9:1483 with SMTP id v3-20020aa7d9c3000000b0050c04b91483mr7476587eds.37.1686239035009;
        Thu, 08 Jun 2023 08:43:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7WAkIvBTLPsLVlcLZqIpFHfhaWbyyodUjVhRbSKji4rGeOK/h76P85OgiyBExHW4hLqYTozg==
X-Received: by 2002:aa7:d9c3:0:b0:50c:4b9:1483 with SMTP id v3-20020aa7d9c3000000b0050c04b91483mr7476574eds.37.1686239034873;
        Thu, 08 Jun 2023 08:43:54 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id y8-20020aa7c248000000b005164ae1c482sm678387edo.11.2023.06.08.08.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 08:43:54 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 13/14] ceph: pass idmap to ceph_open/ioctl_set_layout
Date:   Thu,  8 Jun 2023 17:42:54 +0200
Message-Id: <20230608154256.562906-14-aleksandr.mikhalitsyn@canonical.com>
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

Pass an idmapping to:
- ceph_open
- ceph_ioctl_set_layout

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: brauner@kernel.org
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/file.c  | 2 ++
 fs/ceph/ioctl.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0019d5b4ae3c..3c3aacbf900b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -356,6 +356,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
 	struct ceph_file_info *fi = file->private_data;
+	struct mnt_idmap *idmap = file_mnt_idmap(file);
 	int err;
 	int flags, fmode, wanted;
 
@@ -426,6 +427,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	ihold(inode);
 
 	req->r_num_caps = 1;
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
 	if (!err)
 		err = ceph_init_file(inode, file, req->r_fmode);
diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 07be54ecc94d..d3568643d0af 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -113,6 +113,7 @@ static long ceph_ioctl_set_layout(struct file *file, void __user *arg)
 	req->r_inode = inode;
 	ihold(inode);
 	req->r_num_caps = 1;
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 
 	req->r_inode_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL;
 
@@ -138,6 +139,7 @@ static long ceph_ioctl_set_layout(struct file *file, void __user *arg)
 static long ceph_ioctl_set_layout_policy (struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
+	struct mnt_idmap *idmap = file_mnt_idmap(file);
 	struct ceph_mds_request *req;
 	struct ceph_ioctl_layout l;
 	int err;
@@ -159,6 +161,7 @@ static long ceph_ioctl_set_layout_policy (struct file *file, void __user *arg)
 	req->r_inode = inode;
 	ihold(inode);
 	req->r_num_caps = 1;
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 
 	req->r_args.setlayout.layout.fl_stripe_unit =
 			cpu_to_le32(l.stripe_unit);
-- 
2.34.1

