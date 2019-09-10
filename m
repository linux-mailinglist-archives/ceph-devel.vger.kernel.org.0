Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A493AE256
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 04:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392729AbfIJC2w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Sep 2019 22:28:52 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:40585 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389281AbfIJC2v (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Sep 2019 22:28:51 -0400
Received: by mail-pf1-f180.google.com with SMTP id x127so10574674pfb.7
        for <ceph-devel@vger.kernel.org>; Mon, 09 Sep 2019 19:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1yvypgCwgBIaDaKKdhVXOWYjJK3iDLXuqFFpmOfi2xQ=;
        b=AMwBEH0FO4u+D732aasqr1699tS50OU+fa0QCYXymD9HjLnY0hVtieODcumPl/rwSF
         PqS3EdE0Gty83huATBWtDMf/1cNEHAznHvj9MGc4woMCJe7ueVYjeiglVeJgiIX1jad6
         P4TVAZoyoerncofrcP8OZDgNsPNtxn9af0JoGxX3XownpqdDjS4892JgZvzZZS8CE8Fk
         BBfI5Y/ksul5B//ikmJTObMugc5KP8U+RZlksXTz/oTNm8fLvr9X9JvsgvnAZovGn2Xo
         B2CYIlsdTvS2Q6h3GeEKtb5Ythqg+uDxF5EFoNAu2TwgTz/6R7CsULPuSiHi4DsYe1/y
         Zb2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1yvypgCwgBIaDaKKdhVXOWYjJK3iDLXuqFFpmOfi2xQ=;
        b=iWvp/j42McFYmCN+zfT9n1hDkjhEBSQIM5LKMit5nRzkwwZ9Gin5LRi2TOP5RAjBbT
         mln5Dae48XhIY+GXV2ZpXAQ54JXS4jsGT+t47ADsrtO+XNF2+M5P/7cnQMnEJuyRQKjJ
         M8wdo2+cBvtX7P2PDkLTD9ZkZT4aGgCDkoMz+LxuPVDV4uwqkR1jZXh9kVeiu9ipwrD3
         qB/PPBrx8IpSdYkmyGktKkrerZ1OvMyi1F7osv0gpD4YqmjCLHMtam/sOeizqT9MiSrq
         gbTSVVo8idKXygS1S6Abv8bHU/EzNRCl5T7bYr+S00ozcWIENOx2kCzLwQHyeQzDUNss
         kCGA==
X-Gm-Message-State: APjAAAU3jkeCoo8vY+V8DRjAH6GZDFGki5bwITX0CUizkq7NKoH0Jgg4
        yp5j5D+3OOLuiQiJx6vjTSk2WC1Q88Y=
X-Google-Smtp-Source: APXvYqzivNrh3eR2EUHQ2WTcr4KskFqMmM28X8VKKeV/Os23S+GeU2I4xfjwfhBc1BBbqlZqJPISrw==
X-Received: by 2002:a63:7e17:: with SMTP id z23mr25290785pgc.14.1568082530887;
        Mon, 09 Sep 2019 19:28:50 -0700 (PDT)
Received: from centos7.localdomain ([103.112.79.192])
        by smtp.gmail.com with ESMTPSA id v12sm16178330pff.40.2019.09.09.19.28.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 19:28:50 -0700 (PDT)
From:   simon gao <simon29rock@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     simon gao <simon29rock@gmail.com>
Subject: [PATCH] add mount opt, always_auth, to force to send req to auth mds
Date:   Mon,  9 Sep 2019 22:28:31 -0400
Message-Id: <1568082511-805-1-git-send-email-simon29rock@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In larger clusters (hundreds of millions of files). We have to pin the
directory on a fixed mds now. Some op of client use USE_ANY_MDS mode
to access mds, which may result in requests being sent to noauth mds
and then forwarded to authmds.
the opt is used to reduce forward op.
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

