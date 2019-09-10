Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200C2AE266
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 04:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392748AbfIJCna (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Sep 2019 22:43:30 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:44026 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392694AbfIJCn3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Sep 2019 22:43:29 -0400
Received: by mail-pg1-f170.google.com with SMTP id u72so8961379pgb.10
        for <ceph-devel@vger.kernel.org>; Mon, 09 Sep 2019 19:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=J1r0uUmGKa1GkSMAjeFMiSSU9M+PPccmqV9wcqokyBY=;
        b=htZ7Mll84UBYS8P3Qb8rIvzGTedT2H6o7sjpybBl+ySdkuWP0O3YJwPV904PXqYe6C
         B7s2gUhsNZLWJ3SA6H2t4avEZKOhtSwhL0a9ZFVlWFCTQakvBDnCXigj380UJgFci+Hl
         xrs6chwi9cIznWeF/23Fcr1oiqcE43cFn/veN6fgAZyguvpYvKhcJR9z6uPsDkhWWEW4
         a69hteMFq3Z8EG1qqSgp/dQ4tiKTiMRF9d8/PhAb/n/lGmfEN40m5rMbkx4k2KKxmofi
         e1VWTlNmdEkpPKDvC5yeBV0K8rh3SYPJf8USTXeQJrVcX+SSdUEDpxemTgFmMi2PtD1R
         +ZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=J1r0uUmGKa1GkSMAjeFMiSSU9M+PPccmqV9wcqokyBY=;
        b=Di76nVBd45bYNWQmQYEqJOdY5i0dorRLj6KKlwyXryWjoE5zarrb5Lv15yKN7r+ZA7
         B+3QEkZOcyktL0VCyTD5hQ1zsj0QQRiw3F2rb+9OjZZ2nZFn7mQU+A8nV0r7CGHWWpID
         ExonU1cpcg67ZKMLbda4kiQ/9cq8wJPU++QKDSd1j6gLohW2Hl6Pk1zjFy8Wy4z7pyCA
         joTCpG+p25PeNz3655zFEUCmCi5NBjAFlhY4f0By30IwRTm2cPZA319qQjA93gxzWp2R
         zIXJtWt2dGJVfeUkrZy+CcssQEW7kCabUNyUJOI+g1W9K/KehIMGZld/MtkiB8OYvPvK
         yKbw==
X-Gm-Message-State: APjAAAVYud+FcPyYkmrxvPply4xy71QGQHAqlUtBv+Y4JDX3WXn8Oxgk
        sVrhDdPOl0+uHPAVgQ3EbhVb8Gm6bfk=
X-Google-Smtp-Source: APXvYqyNODotCIy2oOPjr4SBBvw0rogZ+I/kf8NecyP6mu/5pC063GI7ViTh/63k6jFDyRaEr53+ew==
X-Received: by 2002:a63:d615:: with SMTP id q21mr24503453pgg.296.1568083407236;
        Mon, 09 Sep 2019 19:43:27 -0700 (PDT)
Received: from centos7.localdomain ([103.112.79.192])
        by smtp.gmail.com with ESMTPSA id 193sm20591318pfc.59.2019.09.09.19.43.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 19:43:26 -0700 (PDT)
From:   simon gao <simon29rock@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     simon gao <simon29rock@gmail.com>
Subject: [PATCH] ceph: add mount opt, always_auth
Date:   Mon,  9 Sep 2019 22:43:11 -0400
Message-Id: <1568083391-920-1-git-send-email-simon29rock@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In larger clusters (hundreds of millions of files). We have to pin the
directory on a fixed mds now. Some op of client use USE_ANY_MDS mode
to access mds, which may result in requests being sent to noauth mds
and then forwarded to authmds.
the opt is used to reduce forward ops by sending req to auth mds.
---
 fs/ceph/mds_client.c | 7 ++++++-
 fs/ceph/super.c      | 7 +++++++
 fs/ceph/super.h      | 1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 920e9f0..aca4490 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -878,6 +878,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
 static int __choose_mds(struct ceph_mds_client *mdsc,
 			struct ceph_mds_request *req)
 {
+	struct ceph_mount_options *ma = mdsc->fsc->mount_options;
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 	struct ceph_cap *cap;
@@ -900,7 +901,11 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 
 	if (mode == USE_RANDOM_MDS)
 		goto random;
-
+	// force to send the req to auth mds
+	if (ma->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH && mode != USE_AUTH_MDS){
+		dout("change mode %d => USE_AUTH_MDS", mode);
+		mode = USE_AUTH_MDS;
+	}
 	inode = NULL;
 	if (req->r_inode) {
 		if (ceph_snap(req->r_inode) != CEPH_SNAPDIR) {
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index ab4868c..1e81ebc 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -169,6 +169,7 @@ enum {
 	Opt_noquotadf,
 	Opt_copyfrom,
 	Opt_nocopyfrom,
+	Opt_always_auth,
 };
 
 static match_table_t fsopt_tokens = {
@@ -210,6 +211,7 @@ enum {
 	{Opt_noquotadf, "noquotadf"},
 	{Opt_copyfrom, "copyfrom"},
 	{Opt_nocopyfrom, "nocopyfrom"},
+	{Opt_always_auth, "always_auth"},
 	{-1, NULL}
 };
 
@@ -381,6 +383,9 @@ static int parse_fsopt_token(char *c, void *private)
 	case Opt_noacl:
 		fsopt->sb_flags &= ~SB_POSIXACL;
 		break;
+	case Opt_always_auth:
+		fsopt->flags |= CEPH_MOUNT_OPT_ALWAYS_AUTH;
+		break;
 	default:
 		BUG_ON(token);
 	}
@@ -563,6 +568,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",nopoolperm");
 	if (fsopt->flags & CEPH_MOUNT_OPT_NOQUOTADF)
 		seq_puts(m, ",noquotadf");
+	if (fsopt->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH)
+		seq_puts(m, ",always_auth");
 
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 	if (fsopt->sb_flags & SB_POSIXACL)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 6b9f1ee..65f6423 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -41,6 +41,7 @@
 #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
 #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
 #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
+#define CEPH_MOUNT_OPT_ALWAYS_AUTH     (1<<15) /* send op to auth mds, not to replicative mds */
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-- 
1.8.3.1

