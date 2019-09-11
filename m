Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4FBAF67A
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 09:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfIKHLg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 03:11:36 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:43277 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfIKHLg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Sep 2019 03:11:36 -0400
Received: by mail-pf1-f179.google.com with SMTP id d15so13061868pfo.10
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2019 00:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8HKEHExe5VuNCqB10le6mufrtNt74I9YVGQoHZHPGow=;
        b=W0jCBYw4N5L9TPg4CDvMDTsD2vVhxO94/NzaV/QDp4CXNabzqSBItwaLE1X9xjr75n
         C/g88CiudETa7ofgh0E9WjMteAPKpxHOn87MJlaiq+RnITEpzZy80YxbdgI+52WWAzUK
         ruJix0mOdPxg0+jpZfHCJJlxloZ8BbytDoXNjHUhZYR58DjbpFBsGw+IMD+/6r1yzJFG
         P86uW429ehKWK/ske6D8vaNVdtJ+65mXv+yg8iOTmHSSqZYy57GHVufKCnrZSIcOAj7I
         C3YY2oj1LPoBTgAc1nCfkvlTb98z7csuWCbEmXaeXMaM/Erc5KHWSqqfQbrqARF0IRNy
         mTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8HKEHExe5VuNCqB10le6mufrtNt74I9YVGQoHZHPGow=;
        b=CJvTLPQ4cR71zneGlRKg+Uz4iXZiSDhiiJpCPtG/ADdM+EOKnVjj5RCXOmuMUXM4Tn
         BAxDMzX6ydDC1+1R7vOLqaAxuR/d7bzm3FByQMA7GhpXC4xGSqRiz/hFsb0K2NNp4L+c
         bCwsIIUAaepCCybBgga2bjn1eKo4sIJFsb/NQ7WDtojNQlprzXqClNj/2RcHYTG8wBxQ
         nX2uyOkaCVbYt5N7fn0AFEgCXlJbrUbnn7Tyft3bNrXgxhPbJwtPiKlj0HKuZgdpCI3F
         PhKo04thGACjQ0juGWH+h/xc7GfuHSxo85IXzeKILm2TRb6unnkvUhoZDAjHqXPBATa8
         vwHQ==
X-Gm-Message-State: APjAAAWC0iWyxgaWFd0vP7RiT+weP3RnMMAl7xlkBo1/iYu7LgeaevL/
        hTjDqt+g40P/BirR3B2OPX8vU4uIMLrJNg==
X-Google-Smtp-Source: APXvYqxQZOtKhfhiom4bMSPBWND4GpAMnG5TxzUn0yyh03M2vmCPm39y0ZuqekKWRXTqzhF9YxsjZA==
X-Received: by 2002:aa7:980c:: with SMTP id e12mr39017264pfl.79.1568185895501;
        Wed, 11 Sep 2019 00:11:35 -0700 (PDT)
Received: from centos7.localdomain ([103.112.79.192])
        by smtp.gmail.com with ESMTPSA id b26sm5162774pfd.61.2019.09.11.00.11.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 00:11:35 -0700 (PDT)
From:   simon gao <simon29rock@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     simon gao <simon29rock@gmail.com>
Subject: [PATCH] ceph: add mount opt, always_auth
Date:   Wed, 11 Sep 2019 03:11:28 -0400
Message-Id: <1568185888-6256-1-git-send-email-simon29rock@gmail.com>
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
 fs/ceph/mds_client.c | 6 +++++-
 fs/ceph/super.c      | 7 +++++++
 fs/ceph/super.h      | 1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 920e9f0..d4adc3a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -900,7 +900,11 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 
 	if (mode == USE_RANDOM_MDS)
 		goto random;
-
+	// force to send the req to auth mds
+	if (ceph_test_mount_opt(mdsc->fsc, ALWAYS_AUTH) && mode != USE_AUTH_MDS){
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

