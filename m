Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E007725B0
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Aug 2023 15:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjHGN3Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Aug 2023 09:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbjHGN3O (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Aug 2023 09:29:14 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA952107
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 06:28:52 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DBA0D44274
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 13:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691414893;
        bh=dSSVvNS5h70J5u6vsFuPYT4MXnye3oVzKXsF0V62fVM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=P2/vAXc7Bbz09iex+UErlyuv34chXKMALZx/orp8v79P/HPubtjVSe5GPWc1Ifp1P
         Q/qpIz1YzN5gsKo4/1eNE1Y1SXX4+zkqkTuGg7spsh57F2fQnKxTwLw1NlFSpeNIxQ
         s2dNvtt3hg47YLBjrCKaxzvQpTOdiJCTCJrxW3FIMtOkg7rRxXQKIoAq1evhoin+Be
         dXaleWsyF2Mgk9UtVOOhnpjKzSCBOXmbkRSZmv+NMDYFyrs38D+DmDo3JdEylIvwsw
         Z2Vkcvy/4bhMrhp/ZgjVPnXvzhXUTZhI/SLdD9SAlALf3wPQW8lsR4gJZe2bqiEtf4
         enZq1fvotTO0A==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-99cc32f2ec5so124061366b.1
        for <ceph-devel@vger.kernel.org>; Mon, 07 Aug 2023 06:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691414893; x=1692019693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dSSVvNS5h70J5u6vsFuPYT4MXnye3oVzKXsF0V62fVM=;
        b=WPBMZkU1dAkopbboN4lDKBwuDMvEMhV709yJS2GjOCW6F6M1MdShpfenal0Xyj4K8I
         0oHBmHj84dFXFLGrix9g7NPXFDiDkbA99yzJjAMxnTgI3BrmmiC/7jWpkpRcPCEo0SPq
         FaO3tgBGLfzxVZ9Bx0PTvUq9FzOCUpurbmCUo9IOHieWIz/wFyhBKdubeK7v4f6iXAkC
         GD89/epOawJCXDcEon5mUGE071/EH4xoaXMFj4ai9AKwoulaGAGhLgSEfS2ORUuHdoIq
         ZMYu+fdauV15ICXHmCoQ3TS9I/fq1GjkBoo5xmokC8lgqYtuSPBjJlQhvu8v1ejBYEq+
         eDEQ==
X-Gm-Message-State: AOJu0Yz/GL6o7fFvcmM80c2GNR1c10bcuwpd8nGZhjhEBOXkq2URo1hP
        SCeM1QCe2Ot9jn2HAodQHsIp744cCp5MrQoHFQPSqSsYOd4E0gEp49Uh8ZGKWV/WwGQsT2idn/V
        rf0kU4N2q5b1paD7dn9oiMOUMkoy6tS/1Wybwb1M=
X-Received: by 2002:a17:906:259:b0:99c:3b4:940f with SMTP id 25-20020a170906025900b0099c03b4940fmr8960493ejl.27.1691414893696;
        Mon, 07 Aug 2023 06:28:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGa0CjsHfJWZ04OQaM2nEIQHZnEMwjGZHzg3KFBLXF85/4ug5/dORHqOGj+uj7M8E5GiyJxWQ==
X-Received: by 2002:a17:906:259:b0:99c:3b4:940f with SMTP id 25-20020a170906025900b0099c03b4940fmr8960481ejl.27.1691414893493;
        Mon, 07 Aug 2023 06:28:13 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id lg12-20020a170906f88c00b00992ca779f42sm5175257ejb.97.2023.08.07.06.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 06:28:13 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 05/12] ceph: pass an idmapping to mknod/symlink/mkdir
Date:   Mon,  7 Aug 2023 15:26:19 +0200
Message-Id: <20230807132626.182101-6-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

Enable mknod/symlink/mkdir iops to handle idmapped mounts.
This is just a matter of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v4:
	- call mnt_idmap_get
v7:
	- don't pass idmapping for ceph_rename (no need)
v10:
	- do not set req->r_mnt_idmap for MKSNAP operation
---
 fs/ceph/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index b752ed3ccdf0..d6db6d861cd9 100644
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
@@ -1146,6 +1148,8 @@ static int ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	if (op == CEPH_MDS_OP_MKDIR)
+		req->r_mnt_idmap = mnt_idmap_get(idmap);
 	req->r_args.mkdir.mode = cpu_to_le32(mode);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL |
 			     CEPH_CAP_XATTR_EXCL;
-- 
2.34.1

