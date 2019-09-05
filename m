Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B4CAA383
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Sep 2019 14:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388127AbfIEMwZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Sep 2019 08:52:25 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44311 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733259AbfIEMwZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Sep 2019 08:52:25 -0400
Received: by mail-pl1-f193.google.com with SMTP id k1so1248814pls.11
        for <ceph-devel@vger.kernel.org>; Thu, 05 Sep 2019 05:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Yoq50xcOTAJCDG9uI6Um7YTQyXegb6YGqsGB6mwobr8=;
        b=pdc++rD+huW+AXwfEYyPkKsCj5tSYAxGUYRxT3xJWrG7WJkUFysicibQbOsy+aAKOe
         0gULdRx5RMkPtqyJl+h2Q0k9296pIksR0AKMnXMGMmi4dEjJqNCNDlZGYEWy50u2sc9y
         1pGRr6aqBRG9gPAoXC7bWN6LWvEDFNdUxE5O5zdJfAbV5LNASBA4digjIvVqD7BHoINO
         5Xv4iw1/tGT/+Ej4yE/LVXXVcVaplrcUg+00z49uexwva3PWOJR9N5PBp9KJRZ5fpwrV
         BoyctS1vmhO55SK0zUinGaN0qwkHEa8k40b0ZHLm/hdbvo/yDqkpJNsQ5Mh14sFNAFhS
         CgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Yoq50xcOTAJCDG9uI6Um7YTQyXegb6YGqsGB6mwobr8=;
        b=TorsCzTeLxhFhJZgNFrTQBHl6gmO4i4L12z3Bemz5DOI4SRXjWdGpxntMjGoIxRykU
         B0QIAgD/IdPQbrsOj9HlYXoW1ZVSgqzFgTYOQCkrx5yBoVgIO3hmBUVUhPao8w1RC9H1
         45rdeq58kg4StaDVyv05Zdo2SZSaMZajoQ2NC2TdnIup/NoGhwDcUbKscUNt3bXtWHJt
         CTXj2MJ57swgenJibq3OyV24vXJhb3Dq8Azd+5S5ZI1lwS7SNPv5JKiBgmqbpc6DcVg3
         yhG+Ni3VLWIzb2CRMSB8Xy3sE2rMGSo4d60yuCZ4NYUpuQp+hfe6pl5Xw4Uu4+Vr5QFx
         EAtA==
X-Gm-Message-State: APjAAAV+VI+g89zfFzixJ5SLQtaucl26LfBgH1PqBixN0MbeAmzcq4P2
        jd8TKptPTzddzwwrxqb08ZMiQsXE
X-Google-Smtp-Source: APXvYqx0fyRoSoHOLHx836J/OkobhNSnklZJ3jweV20JvgOMX4rc+dORt7mC7OJGwxEoAaL4helrkQ==
X-Received: by 2002:a17:902:830c:: with SMTP id bd12mr3231045plb.237.1567687944404;
        Thu, 05 Sep 2019 05:52:24 -0700 (PDT)
Received: from centos7.localdomain ([103.112.79.192])
        by smtp.gmail.com with ESMTPSA id j11sm3219498pfa.113.2019.09.05.05.52.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 05:52:23 -0700 (PDT)
From:   simon gao <simon29rock@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     simon gao <simon29rock@gmail.com>
Subject: [PATCH] modify the mode of req from  USE_ANY_MDS to USE_AUTH_MDS to reduce the cache size of mds and forward op.
Date:   Thu,  5 Sep 2019 08:51:55 -0400
Message-Id: <1567687915-121426-1-git-send-email-simon29rock@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

---
 fs/ceph/dir.c        | 4 ++--
 fs/ceph/export.c     | 8 ++++----
 fs/ceph/file.c       | 2 +-
 fs/ceph/inode.c      | 2 +-
 fs/ceph/mds_client.c | 1 +
 fs/ceph/super.c      | 2 +-
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 4ca0b8f..a441b8d 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -771,7 +771,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 
 	op = ceph_snap(dir) == CEPH_SNAPDIR ?
 		CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
-	req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
+	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
 	if (IS_ERR(req))
 		return ERR_CAST(req);
 	req->r_dentry = dget(dentry);
@@ -1600,7 +1600,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 
 		op = ceph_snap(dir) == CEPH_SNAPDIR ?
 			CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
-		req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
+		req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
 		if (!IS_ERR(req)) {
 			req->r_dentry = dget(dentry);
 			req->r_num_caps = 2;
diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 15ff1b0..a7d5174 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -135,7 +135,7 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
 		int mask;
 
 		req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
-					       USE_ANY_MDS);
+					       USE_AUTH_MDS);
 		if (IS_ERR(req))
 			return ERR_CAST(req);
 
@@ -210,7 +210,7 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
 		return d_obtain_alias(inode);
 
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
-				       USE_ANY_MDS);
+				       USE_AUTH_MDS);
 	if (IS_ERR(req))
 		return ERR_CAST(req);
 
@@ -294,7 +294,7 @@ static struct dentry *__get_parent(struct super_block *sb,
 	int err;
 
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPPARENT,
-				       USE_ANY_MDS);
+				       USE_AUTH_MDS);
 	if (IS_ERR(req))
 		return ERR_CAST(req);
 
@@ -509,7 +509,7 @@ static int ceph_get_name(struct dentry *parent, char *name,
 
 	mdsc = ceph_inode_to_client(inode)->mdsc;
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPNAME,
-				       USE_ANY_MDS);
+				       USE_AUTH_MDS);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 685a03c..79533f2 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -182,7 +182,7 @@ static void put_bvecs(struct bio_vec *bvecs, int num_bvecs, bool should_dirty)
 	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
-	int want_auth = USE_ANY_MDS;
+	int want_auth = USE_AUTH_MDS;
 	int op = (flags & O_CREAT) ? CEPH_MDS_OP_CREATE : CEPH_MDS_OP_OPEN;
 
 	if (flags & (O_WRONLY|O_RDWR|O_CREAT|O_TRUNC))
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 18500ede..6c67548 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2247,7 +2247,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 	if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
 		return 0;
 
-	mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
+	mode = USE_AUTH_MDS;
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 920e9f0..acfb969 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -867,6 +867,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
 	return inode;
 }
 
+static struct inode *get_parent()
 /*
  * Choose mds to send request to next.  If there is a hint set in the
  * request (e.g., due to a prior forward hint from the mds), use that.
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index ab4868c..517e605 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -867,7 +867,7 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
 
 	/* open dir */
 	dout("open_root_inode opening '%s'\n", path);
-	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
+	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_AUTH_MDS);
 	if (IS_ERR(req))
 		return ERR_CAST(req);
 	req->r_path1 = kstrdup(path, GFP_NOFS);
-- 
1.8.3.1

