Return-Path: <ceph-devel+bounces-3411-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84CF6B223D7
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 11:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3054617EEE2
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 09:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD432EAB64;
	Tue, 12 Aug 2025 09:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QMtM2cQG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11752EA730
	for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 09:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754992673; cv=none; b=GuAaBHz0G5j5cwdp+g+yOc1ZbGsTSPrD0kvEN7u21T9zrMmjEBFbUK+/mqY03Me67YDRdOBGVSV/OvjOXF8PuNi+q7jHr7kOGdgV0gXQAVvSii3INaWq9lhY+OJog6rwMSPpYsTR1rb/mrXl0r8x38GIx6jXcolp6FyiISe5MWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754992673; c=relaxed/simple;
	bh=SklPlbBvDoSPnXKeDj95J8xaphdcnRklEvsYG5qYoik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ewLobNpBHnpHvqvLNgvgF34TS3MeNtTN7gfuXT7HSyt5iz8WRQSmXs5G9yYtZHMryhLOTCAtHAkafE5znHkAcMGOdoXTm9wecGPqztRhnySu+P+YDDUqRVtfj5kNvrg07CajQZ4eZOkLvbhGTUnKRral9Yzv7j6F0e+gr5LaK24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QMtM2cQG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754992668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/+35zgVMREp5iu4WHb0LfnIA1EFTWDo15YR87u+kvI=;
	b=QMtM2cQGruZe4WWnM4e1tjOICyEKChtfnLZ9GqWOB077c8v8rGri3UyaPGT8mxpTGl9J+0
	C24+1DyCCDc7+S4P4L3neNPe9wijJrkkhDsiaatIYQpeSGIbhH1oHCX1sY2u6Nj78OSLzD
	Y6JjYKIvGVI2AalqmYvja12I6WriMpY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-tB3C4Ce5PZuNxmnlBPFl-w-1; Tue, 12 Aug 2025 05:57:47 -0400
X-MC-Unique: tB3C4Ce5PZuNxmnlBPFl-w-1
X-Mimecast-MFC-AGG-ID: tB3C4Ce5PZuNxmnlBPFl-w_1754992666
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-af9a8a53e75so317449766b.0
        for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 02:57:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754992666; x=1755597466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8/+35zgVMREp5iu4WHb0LfnIA1EFTWDo15YR87u+kvI=;
        b=rMZ7n6jTzBJB4HTtumdFGhM3uJaJlih4Lga0BHsgjwsKWdh0eIEoTDE/MNPSxYWsb5
         DUwSw/Noq7eoUtylmB0qF4PXcCOVyZ2dTr7Qvm4tul+kSPiCFhEoXFbFJXGMsqsZZJkh
         CC0XlOomMStjFrABNJN5/zMAqn491eimfT5RLy3Gmq7Z3QI/YXdFAAFl99GHPgC/VnP8
         OVzis1RzJVFNBsS9TdNnRJ+JQxS68dMqPWmDPbAq5jQKQkivIRyrzaQuPlDOgge6J/k5
         tqsIxfGpetl/hVPAyvZJcbFfmHqgMcrhZ8VYFzPuygq6jpXfkrfPivTHPLDt7h9LU/P4
         qdig==
X-Gm-Message-State: AOJu0YwTiJx2OA3+IbtaCcvv37zlCiE3CHcdnCxNXxmVEQcIsdH/JBbS
	KA9PLXntUfJDdDl1si4+bNoML2FIgqWseJEIGNXayfXw944tct8jeKNVtyda8E3D9na0Fg05zJB
	1GlG3FIgn5OF5+ffjjUZRgSqTe9WMrlCiPi/auTSrVMOBrfKKFiTc/t+sCuBW80yDijLpOeNKeb
	5i1BLue6E3R8rLTuzjYwMNrC7PznHubf57y/cUhXH1ObRX4Sz3Pw==
X-Gm-Gg: ASbGncvYUQRA+39aOHDZtdj8Opw9Gr1kFpRDEN5fg2/v/MDycazJsp1UiNjs1mr8RAp
	X/J2e/dlweIf2p/rNVQfpmaXs0DVdTuFjyncMnzHh1lPGHYOx9rB8/tvpcQk2lXFe6nSltW2OL4
	ipZ5WhPqpTB6RFk41PMy2S9O03pEiHOiUd3uy0QPpmGcUArAOHle/MDEfUnK512EcTQ10hip0vG
	rLcR8orkoAo+sEpiocNI7ya8rGp0Va9EjFX2piL/W1kv88KYdOuph7m7w3uQC/+wa80d6NSdsV+
	RfsblxPxYqb7WiGJisawlr8hfD4blM1+NeSVpf58iz+ll9n6cDdLy4CX84oaTCVerkpSayU+Qw=
	=
X-Received: by 2002:a17:907:3e94:b0:af9:a4de:f092 with SMTP id a640c23a62f3a-afa1e1279a7mr263601866b.55.1754992665325;
        Tue, 12 Aug 2025 02:57:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbp8tb+iGKIzm9Y8BOOySGRPuBHGHBQarfskNX2G2WxlpFe/XIuH3JTRIQ3ji8UW0emz5hXw==
X-Received: by 2002:a17:907:3e94:b0:af9:a4de:f092 with SMTP id a640c23a62f3a-afa1e1279a7mr263598566b.55.1754992664739;
        Tue, 12 Aug 2025 02:57:44 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a21c0a4sm2180821466b.109.2025.08.12.02.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 02:57:44 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH v4 1/2] ceph: fix client race condition validating r_parent before applying state
Date: Tue, 12 Aug 2025 09:57:38 +0000
Message-Id: <20250812095739.3194337-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250812095739.3194337-1-amarkuze@redhat.com>
References: <20250812095739.3194337-1-amarkuze@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add validation to ensure the cached parent directory inode matches the
directory info in MDS replies. This prevents client-side race conditions
where concurrent operations (e.g. rename) cause r_parent to become stale
between request initiation and reply processing, which could lead to
applying state changes to incorrect directory inodes.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/debugfs.c    |  14 ++--
 fs/ceph/dir.c        |  17 ++---
 fs/ceph/file.c       |  24 +++----
 fs/ceph/inode.c      |   7 +-
 fs/ceph/mds_client.c | 165 ++++++++++++++++++++++++++-----------------
 fs/ceph/mds_client.h |  18 +++--
 6 files changed, 139 insertions(+), 106 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index fdd404fc8112..f3fe786b4143 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -55,8 +55,6 @@ static int mdsc_show(struct seq_file *s, void *p)
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
 	struct rb_node *rp;
-	int pathlen = 0;
-	u64 pathbase;
 	char *path;
 
 	mutex_lock(&mdsc->mutex);
@@ -81,8 +79,8 @@ static int mdsc_show(struct seq_file *s, void *p)
 		if (req->r_inode) {
 			seq_printf(s, " #%llx", ceph_ino(req->r_inode));
 		} else if (req->r_dentry) {
-			path = ceph_mdsc_build_path(mdsc, req->r_dentry, &pathlen,
-						    &pathbase, 0);
+			struct ceph_path_info path_info;
+			path = ceph_mdsc_build_path(mdsc, req->r_dentry, &path_info, 0);
 			if (IS_ERR(path))
 				path = NULL;
 			spin_lock(&req->r_dentry->d_lock);
@@ -91,7 +89,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 				   req->r_dentry,
 				   path ? path : "");
 			spin_unlock(&req->r_dentry->d_lock);
-			ceph_mdsc_free_path(path, pathlen);
+			ceph_mdsc_free_path_info(&path_info);
 		} else if (req->r_path1) {
 			seq_printf(s, " #%llx/%s", req->r_ino1.ino,
 				   req->r_path1);
@@ -100,8 +98,8 @@ static int mdsc_show(struct seq_file *s, void *p)
 		}
 
 		if (req->r_old_dentry) {
-			path = ceph_mdsc_build_path(mdsc, req->r_old_dentry, &pathlen,
-						    &pathbase, 0);
+			struct ceph_path_info path_info;
+			path = ceph_mdsc_build_path(mdsc, req->r_old_dentry, &path_info, 0);
 			if (IS_ERR(path))
 				path = NULL;
 			spin_lock(&req->r_old_dentry->d_lock);
@@ -111,7 +109,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 				   req->r_old_dentry,
 				   path ? path : "");
 			spin_unlock(&req->r_old_dentry->d_lock);
-			ceph_mdsc_free_path(path, pathlen);
+			ceph_mdsc_free_path_info(&path_info);
 		} else if (req->r_path2 && req->r_op != CEPH_MDS_OP_SYMLINK) {
 			if (req->r_ino2.ino)
 				seq_printf(s, " #%llx/%s", req->r_ino2.ino,
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 1535b6540e9d..08c3129cd25d 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1271,10 +1271,8 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 
 	/* If op failed, mark everyone involved for errors */
 	if (result) {
-		int pathlen = 0;
-		u64 base = 0;
-		char *path = ceph_mdsc_build_path(mdsc, dentry, &pathlen,
-						  &base, 0);
+		struct ceph_path_info path_info = {0};
+		char *path = ceph_mdsc_build_path(mdsc, dentry, &path_info, 0);
 
 		/* mark error on parent + clear complete */
 		mapping_set_error(req->r_parent->i_mapping, result);
@@ -1288,8 +1286,8 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 		mapping_set_error(req->r_old_inode->i_mapping, result);
 
 		pr_warn_client(cl, "failure path=(%llx)%s result=%d!\n",
-			       base, IS_ERR(path) ? "<<bad>>" : path, result);
-		ceph_mdsc_free_path(path, pathlen);
+			       path_info.vino.ino, IS_ERR(path) ? "<<bad>>" : path, result);
+		ceph_mdsc_free_path_info(&path_info);
 	}
 out:
 	iput(req->r_old_inode);
@@ -1347,8 +1345,6 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	int err = -EROFS;
 	int op;
 	char *path;
-	int pathlen;
-	u64 pathbase;
 
 	if (ceph_snap(dir) == CEPH_SNAPDIR) {
 		/* rmdir .snap/foo is RMSNAP */
@@ -1367,14 +1363,15 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	if (!dn) {
 		try_async = false;
 	} else {
-		path = ceph_mdsc_build_path(mdsc, dn, &pathlen, &pathbase, 0);
+		struct ceph_path_info path_info;
+		path = ceph_mdsc_build_path(mdsc, dn, &path_info, 0);
 		if (IS_ERR(path)) {
 			try_async = false;
 			err = 0;
 		} else {
 			err = ceph_mds_check_access(mdsc, path, MAY_WRITE);
 		}
-		ceph_mdsc_free_path(path, pathlen);
+		ceph_mdsc_free_path_info(&path_info);
 		dput(dn);
 
 		/* For none EACCES cases will let the MDS do the mds auth check */
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c92ef1fc5b8a..d222dd192fec 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -368,8 +368,6 @@ int ceph_open(struct inode *inode, struct file *file)
 	int flags, fmode, wanted;
 	struct dentry *dentry;
 	char *path;
-	int pathlen;
-	u64 pathbase;
 	bool do_sync = false;
 	int mask = MAY_READ;
 
@@ -399,14 +397,15 @@ int ceph_open(struct inode *inode, struct file *file)
 	if (!dentry) {
 		do_sync = true;
 	} else {
-		path = ceph_mdsc_build_path(mdsc, dentry, &pathlen, &pathbase, 0);
+		struct ceph_path_info path_info;
+		path = ceph_mdsc_build_path(mdsc, dentry, &path_info, 0);
 		if (IS_ERR(path)) {
 			do_sync = true;
 			err = 0;
 		} else {
 			err = ceph_mds_check_access(mdsc, path, mask);
 		}
-		ceph_mdsc_free_path(path, pathlen);
+		ceph_mdsc_free_path_info(&path_info);
 		dput(dentry);
 
 		/* For none EACCES cases will let the MDS do the mds auth check */
@@ -613,15 +612,13 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
 	mapping_set_error(req->r_parent->i_mapping, result);
 
 	if (result) {
-		int pathlen = 0;
-		u64 base = 0;
-		char *path = ceph_mdsc_build_path(mdsc, req->r_dentry, &pathlen,
-						  &base, 0);
+		struct ceph_path_info path_info = {0};
+		char *path = ceph_mdsc_build_path(mdsc, req->r_dentry, &path_info, 0);
 
 		pr_warn_client(cl,
 			"async create failure path=(%llx)%s result=%d!\n",
-			base, IS_ERR(path) ? "<<bad>>" : path, result);
-		ceph_mdsc_free_path(path, pathlen);
+			path_info.vino.ino, IS_ERR(path) ? "<<bad>>" : path, result);
+		ceph_mdsc_free_path_info(&path_info);
 
 		ceph_dir_clear_complete(req->r_parent);
 		if (!d_unhashed(dentry))
@@ -789,8 +786,6 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	int mask;
 	int err;
 	char *path;
-	int pathlen;
-	u64 pathbase;
 
 	doutc(cl, "%p %llx.%llx dentry %p '%pd' %s flags %d mode 0%o\n",
 	      dir, ceph_vinop(dir), dentry, dentry,
@@ -812,7 +807,8 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (!dn) {
 		try_async = false;
 	} else {
-		path = ceph_mdsc_build_path(mdsc, dn, &pathlen, &pathbase, 0);
+		struct ceph_path_info path_info;
+		path = ceph_mdsc_build_path(mdsc, dn, &path_info, 0);
 		if (IS_ERR(path)) {
 			try_async = false;
 			err = 0;
@@ -824,7 +820,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 				mask |= MAY_WRITE;
 			err = ceph_mds_check_access(mdsc, path, mask);
 		}
-		ceph_mdsc_free_path(path, pathlen);
+		ceph_mdsc_free_path_info(&path_info);
 		dput(dn);
 
 		/* For none EACCES cases will let the MDS do the mds auth check */
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 4365d17ce6d7..36981950a368 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2502,22 +2502,21 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	int truncate_retry = 20; /* The RMW will take around 50ms */
 	struct dentry *dentry;
 	char *path;
-	int pathlen;
-	u64 pathbase;
 	bool do_sync = false;
 
 	dentry = d_find_alias(inode);
 	if (!dentry) {
 		do_sync = true;
 	} else {
-		path = ceph_mdsc_build_path(mdsc, dentry, &pathlen, &pathbase, 0);
+		struct ceph_path_info path_info;
+		path = ceph_mdsc_build_path(mdsc, dentry, &path_info, 0);
 		if (IS_ERR(path)) {
 			do_sync = true;
 			err = 0;
 		} else {
 			err = ceph_mds_check_access(mdsc, path, MAY_WRITE);
 		}
-		ceph_mdsc_free_path(path, pathlen);
+		ceph_mdsc_free_path_info(&path_info);
 		dput(dentry);
 
 		/* For none EACCES cases will let the MDS do the mds auth check */
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9eed6d73a508..f31278859119 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2729,7 +2729,7 @@ static u8 *get_fscrypt_altname(const struct ceph_mds_request *req, u32 *plen)
  *   foo/.snap/bar -> foo//bar
  */
 char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
-			   int *plen, u64 *pbase, int for_wire)
+			   struct ceph_path_info *path_info, int for_wire)
 {
 	struct ceph_client *cl = mdsc->fsc->client;
 	struct dentry *cur;
@@ -2839,16 +2839,30 @@ char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 
-	*pbase = base;
-	*plen = PATH_MAX - 1 - pos;
+	/* Initialize the output structure */
+	memset(path_info, 0, sizeof(*path_info));
+
+	path_info->vino.ino = base;
+	path_info->pathlen = PATH_MAX - 1 - pos;
+	path_info->path = path + pos;
+	path_info->freepath = true;
+
+	/* Set snap from dentry if available */
+	if (d_inode(dentry))
+		path_info->vino.snap = ceph_snap(d_inode(dentry));
+	else
+		path_info->vino.snap = CEPH_NOSNAP;
+
 	doutc(cl, "on %p %d built %llx '%.*s'\n", dentry, d_count(dentry),
-	      base, *plen, path + pos);
+	      base, PATH_MAX - 1 - pos, path + pos);
 	return path + pos;
 }
 
+
+
 static int build_dentry_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
-			     struct inode *dir, const char **ppath, int *ppathlen,
-			     u64 *pino, bool *pfreepath, bool parent_locked)
+			     struct inode *dir, struct ceph_path_info *path_info,
+			     bool parent_locked)
 {
 	char *path;
 
@@ -2857,41 +2871,47 @@ static int build_dentry_path(struct ceph_mds_client *mdsc, struct dentry *dentry
 		dir = d_inode_rcu(dentry->d_parent);
 	if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP &&
 	    !IS_ENCRYPTED(dir)) {
-		*pino = ceph_ino(dir);
+		path_info->vino.ino = ceph_ino(dir);
+		path_info->vino.snap = ceph_snap(dir);
 		rcu_read_unlock();
-		*ppath = dentry->d_name.name;
-		*ppathlen = dentry->d_name.len;
+		path_info->path = dentry->d_name.name;
+		path_info->pathlen = dentry->d_name.len;
+		path_info->freepath = false;
 		return 0;
 	}
 	rcu_read_unlock();
-	path = ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
+	path = ceph_mdsc_build_path(mdsc, dentry, path_info, 1);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
-	*ppath = path;
-	*pfreepath = true;
+	/*
+	 * ceph_mdsc_build_path already fills path_info, including snap handling.
+	 */
 	return 0;
 }
 
-static int build_inode_path(struct inode *inode,
-			    const char **ppath, int *ppathlen, u64 *pino,
-			    bool *pfreepath)
+static int build_inode_path(struct inode *inode, struct ceph_path_info *path_info)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	struct dentry *dentry;
 	char *path;
 
 	if (ceph_snap(inode) == CEPH_NOSNAP) {
-		*pino = ceph_ino(inode);
-		*ppathlen = 0;
+		path_info->vino.ino = ceph_ino(inode);
+		path_info->vino.snap = ceph_snap(inode);
+		path_info->pathlen = 0;
+		path_info->freepath = false;
 		return 0;
 	}
 	dentry = d_find_alias(inode);
-	path = ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
+	path = ceph_mdsc_build_path(mdsc, dentry, path_info, 1);
 	dput(dentry);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
-	*ppath = path;
-	*pfreepath = true;
+	/*
+	 * ceph_mdsc_build_path already fills path_info, including snap from dentry.
+	 * Override with inode's snap since that's what this function is for.
+	 */
+	path_info->vino.snap = ceph_snap(inode);
 	return 0;
 }
 
@@ -2901,26 +2921,31 @@ static int build_inode_path(struct inode *inode,
  */
 static int set_request_path_attr(struct ceph_mds_client *mdsc, struct inode *rinode,
 				 struct dentry *rdentry, struct inode *rdiri,
-				 const char *rpath, u64 rino, const char **ppath,
-				 int *pathlen, u64 *ino, bool *freepath,
+				 const char *rpath, u64 rino, struct ceph_path_info *path_info,
 				 bool parent_locked)
 {
 	struct ceph_client *cl = mdsc->fsc->client;
 	int r = 0;
 
+	/* Initialize the output structure */
+	memset(path_info, 0, sizeof(*path_info));
+
 	if (rinode) {
-		r = build_inode_path(rinode, ppath, pathlen, ino, freepath);
+		r = build_inode_path(rinode, path_info);
 		doutc(cl, " inode %p %llx.%llx\n", rinode, ceph_ino(rinode),
 		      ceph_snap(rinode));
 	} else if (rdentry) {
-		r = build_dentry_path(mdsc, rdentry, rdiri, ppath, pathlen, ino,
-					freepath, parent_locked);
-		doutc(cl, " dentry %p %llx/%.*s\n", rdentry, *ino, *pathlen, *ppath);
+		r = build_dentry_path(mdsc, rdentry, rdiri, path_info, parent_locked);
+		doutc(cl, " dentry %p %llx/%.*s\n", rdentry, path_info->vino.ino,
+		      path_info->pathlen, path_info->path);
 	} else if (rpath || rino) {
-		*ino = rino;
-		*ppath = rpath;
-		*pathlen = rpath ? strlen(rpath) : 0;
-		doutc(cl, " path %.*s\n", *pathlen, rpath);
+		path_info->vino.ino = rino;
+		path_info->vino.snap = CEPH_NOSNAP;
+		path_info->path = rpath;
+		path_info->pathlen = rpath ? strlen(rpath) : 0;
+		path_info->freepath = false;
+
+		doutc(cl, " path %.*s\n", path_info->pathlen, rpath);
 	}
 
 	return r;
@@ -2997,11 +3022,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	struct ceph_client *cl = mdsc->fsc->client;
 	struct ceph_msg *msg;
 	struct ceph_mds_request_head_legacy *lhead;
-	const char *path1 = NULL;
-	const char *path2 = NULL;
-	u64 ino1 = 0, ino2 = 0;
-	int pathlen1 = 0, pathlen2 = 0;
-	bool freepath1 = false, freepath2 = false;
+	struct ceph_path_info path_info1 = {0};
+	struct ceph_path_info path_info2 = {0};
 	struct dentry *old_dentry = NULL;
 	int len;
 	u16 releases;
@@ -3011,25 +3033,42 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	u16 request_head_version = mds_supported_head_version(session);
 	kuid_t caller_fsuid = req->r_cred->fsuid;
 	kgid_t caller_fsgid = req->r_cred->fsgid;
+	bool parent_locked = test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 
-	ret = set_request_path_attr(mdsc, req->r_inode, req->r_dentry,
-			      req->r_parent, req->r_path1, req->r_ino1.ino,
-			      &path1, &pathlen1, &ino1, &freepath1,
-			      test_bit(CEPH_MDS_R_PARENT_LOCKED,
-					&req->r_req_flags));
+		ret = set_request_path_attr(mdsc, req->r_inode, req->r_dentry,
+		      req->r_parent, req->r_path1, req->r_ino1.ino,
+		      &path_info1, parent_locked);
 	if (ret < 0) {
 		msg = ERR_PTR(ret);
 		goto out;
 	}
 
+	/*
+	 * When the parent directory's i_rwsem is *not* locked, req->r_parent may
+	 * have become stale (e.g. after a concurrent rename) between the time the
+	 * dentry was looked up and now.  If we detect that the stored r_parent
+	 * does not match the inode number we just encoded for the request, switch
+	 * to the correct inode so that the MDS receives a valid parent reference.
+	 */
+	if (!parent_locked &&
+	    	req->r_parent && path_info1.vino.ino && ceph_ino(req->r_parent) != path_info1.vino.ino) {
+		struct inode *correct_dir = ceph_get_inode(mdsc->fsc->sb, path_info1.vino, NULL);
+		if (!IS_ERR(correct_dir)) {
+				WARN_ONCE(1, "ceph: r_parent mismatch (had %llx wanted %llx) - updating\n",
+				  ceph_ino(req->r_parent), path_info1.vino.ino);
+			iput(req->r_parent);
+			req->r_parent = correct_dir;
+		}
+	}
+
 	/* If r_old_dentry is set, then assume that its parent is locked */
 	if (req->r_old_dentry &&
 	    !(req->r_old_dentry->d_flags & DCACHE_DISCONNECTED))
 		old_dentry = req->r_old_dentry;
 	ret = set_request_path_attr(mdsc, NULL, old_dentry,
-			      req->r_old_dentry_dir,
-			      req->r_path2, req->r_ino2.ino,
-			      &path2, &pathlen2, &ino2, &freepath2, true);
+		      req->r_old_dentry_dir,
+		      req->r_path2, req->r_ino2.ino,
+		      &path_info2, true);
 	if (ret < 0) {
 		msg = ERR_PTR(ret);
 		goto out_free1;
@@ -3060,7 +3099,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 
 	/* filepaths */
 	len += 2 * (1 + sizeof(u32) + sizeof(u64));
-	len += pathlen1 + pathlen2;
+	len += path_info1.pathlen + path_info2.pathlen;
 
 	/* cap releases */
 	len += sizeof(struct ceph_mds_request_release) *
@@ -3068,9 +3107,9 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 		 !!req->r_old_inode_drop + !!req->r_old_dentry_drop);
 
 	if (req->r_dentry_drop)
-		len += pathlen1;
+		len += path_info1.pathlen;
 	if (req->r_old_dentry_drop)
-		len += pathlen2;
+		len += path_info2.pathlen;
 
 	/* MClientRequest tail */
 
@@ -3183,8 +3222,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	lhead->ino = cpu_to_le64(req->r_deleg_ino);
 	lhead->args = req->r_args;
 
-	ceph_encode_filepath(&p, end, ino1, path1);
-	ceph_encode_filepath(&p, end, ino2, path2);
+	ceph_encode_filepath(&p, end, path_info1.vino.ino, path_info1.path);
+	ceph_encode_filepath(&p, end, path_info2.vino.ino, path_info2.path);
 
 	/* make note of release offset, in case we need to replay */
 	req->r_request_release_offset = p - msg->front.iov_base;
@@ -3247,11 +3286,9 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	msg->hdr.data_off = cpu_to_le16(0);
 
 out_free2:
-	if (freepath2)
-		ceph_mdsc_free_path((char *)path2, pathlen2);
+	ceph_mdsc_free_path_info(&path_info2);
 out_free1:
-	if (freepath1)
-		ceph_mdsc_free_path((char *)path1, pathlen1);
+	ceph_mdsc_free_path_info(&path_info1);
 out:
 	return msg;
 out_err:
@@ -4608,24 +4645,20 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 	struct ceph_pagelist *pagelist = recon_state->pagelist;
 	struct dentry *dentry;
 	struct ceph_cap *cap;
-	char *path;
-	int pathlen = 0, err;
-	u64 pathbase;
+	struct ceph_path_info path_info = {0};
+	int err;
 	u64 snap_follows;
 
 	dentry = d_find_primary(inode);
 	if (dentry) {
 		/* set pathbase to parent dir when msg_version >= 2 */
-		path = ceph_mdsc_build_path(mdsc, dentry, &pathlen, &pathbase,
+		char *path = ceph_mdsc_build_path(mdsc, dentry, &path_info,
 					    recon_state->msg_version >= 2);
 		dput(dentry);
 		if (IS_ERR(path)) {
 			err = PTR_ERR(path);
 			goto out_err;
 		}
-	} else {
-		path = NULL;
-		pathbase = 0;
 	}
 
 	spin_lock(&ci->i_ceph_lock);
@@ -4658,7 +4691,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 		rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
 		rec.v2.issued = cpu_to_le32(cap->issued);
 		rec.v2.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
-		rec.v2.pathbase = cpu_to_le64(pathbase);
+		rec.v2.pathbase = cpu_to_le64(path_info.vino.ino);
 		rec.v2.flock_len = (__force __le32)
 			((ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) ? 0 : 1);
 	} else {
@@ -4673,7 +4706,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 		ts = inode_get_atime(inode);
 		ceph_encode_timespec64(&rec.v1.atime, &ts);
 		rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
-		rec.v1.pathbase = cpu_to_le64(pathbase);
+		rec.v1.pathbase = cpu_to_le64(path_info.vino.ino);
 	}
 
 	if (list_empty(&ci->i_cap_snaps)) {
@@ -4735,7 +4768,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 			    sizeof(struct ceph_filelock);
 		rec.v2.flock_len = cpu_to_le32(struct_len);
 
-		struct_len += sizeof(u32) + pathlen + sizeof(rec.v2);
+		struct_len += sizeof(u32) + path_info.pathlen + sizeof(rec.v2);
 
 		if (struct_v >= 2)
 			struct_len += sizeof(u64); /* snap_follows */
@@ -4759,7 +4792,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 			ceph_pagelist_encode_8(pagelist, 1);
 			ceph_pagelist_encode_32(pagelist, struct_len);
 		}
-		ceph_pagelist_encode_string(pagelist, path, pathlen);
+		ceph_pagelist_encode_string(pagelist, (char *)path_info.path, path_info.pathlen);
 		ceph_pagelist_append(pagelist, &rec, sizeof(rec.v2));
 		ceph_locks_to_pagelist(flocks, pagelist,
 				       num_fcntl_locks, num_flock_locks);
@@ -4770,17 +4803,17 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 	} else {
 		err = ceph_pagelist_reserve(pagelist,
 					    sizeof(u64) + sizeof(u32) +
-					    pathlen + sizeof(rec.v1));
+					    path_info.pathlen + sizeof(rec.v1));
 		if (err)
 			goto out_err;
 
 		ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
-		ceph_pagelist_encode_string(pagelist, path, pathlen);
+		ceph_pagelist_encode_string(pagelist, (char *)path_info.path, path_info.pathlen);
 		ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
 	}
 
 out_err:
-	ceph_mdsc_free_path(path, pathlen);
+	ceph_mdsc_free_path_info(&path_info);
 	if (!err)
 		recon_state->nr_caps++;
 	return err;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 3e2a6fa7c19a..0428a5eaf28c 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -617,14 +617,24 @@ extern int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath,
 
 extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
 
-static inline void ceph_mdsc_free_path(char *path, int len)
+/*
+ * Structure to group path-related output parameters for build_*_path functions
+ */
+struct ceph_path_info {
+	const char *path;
+	int pathlen;
+	struct ceph_vino vino;
+	bool freepath;
+};
+
+static inline void ceph_mdsc_free_path_info(const struct ceph_path_info *path_info)
 {
-	if (!IS_ERR_OR_NULL(path))
-		__putname(path - (PATH_MAX - 1 - len));
+	if (path_info && path_info->freepath && !IS_ERR_OR_NULL(path_info->path))
+		__putname((char *)path_info->path - (PATH_MAX - 1 - path_info->pathlen));
 }
 
 extern char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc,
-				  struct dentry *dentry, int *plen, u64 *base,
+				  struct dentry *dentry, struct ceph_path_info *path_info,
 				  int for_wire);
 
 extern void __ceph_mdsc_drop_dentry_lease(struct dentry *dentry);
-- 
2.34.1


