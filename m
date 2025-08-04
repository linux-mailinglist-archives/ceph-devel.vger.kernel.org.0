Return-Path: <ceph-devel+bounces-3350-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52990B19F23
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Aug 2025 12:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBECE3A517A
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Aug 2025 10:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4DB246BC9;
	Mon,  4 Aug 2025 09:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQU784iC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D3E246760
	for <ceph-devel@vger.kernel.org>; Mon,  4 Aug 2025 09:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754301597; cv=none; b=YLc8WVUXfdwpk5iUvYD8kMRFZspqmLMP0u1tXn5ZNMtAlOX5N7SdnirWGCxaXAmaCeQDgyO/OtJIVu8aK0HYdKxxQCJxk8yz2X3RmAuqbww9LddtRlRFNR4oAprcsL3dS6mov/C2SRYjZq7sfr7Nhv/SQqqw8mQVPjGuBD28Hj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754301597; c=relaxed/simple;
	bh=LYwAMBk1rZ2XdUJwKwLMGDxLQGjoz2qmBaWryVlJle0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tIopIrOm8ApObM+LajWXtziZGoGt/Os0q359Jn/m5JthDQ5M0eG6Ts9D4M0ZKpfzeeCVHvP59sUugwXFSg0m868uefefU7jjkbsscPlNbQQgafTwPScTBBGNGT57BWeIhKW8lV38gwEiko8GGeOG8NVMTXG9kqKCb6Zv87ZVh7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQU784iC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754301594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ckkZeNmDDLh5+Aa/LXWOQsO5tBPmGT2tsRyUHeTJZxg=;
	b=hQU784iCDpkwNKJH3TMj/S+XeUxfUkAChtGeEbq4U9iHoDr9VdZdlrAiuWTwAKo5W6q5mo
	01QYJQFZCP7IOxgIIY62ehQdfjm2RGmfIs3wJjkLvdE5eYfreltejLqB2UgZOLXXGcXEux
	ZOV95TmA3elou7tlsEIQhwYM8fDNQgk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-1qQxhVGQMAaacLDP3DYj1w-1; Mon, 04 Aug 2025 05:59:53 -0400
X-MC-Unique: 1qQxhVGQMAaacLDP3DYj1w-1
X-Mimecast-MFC-AGG-ID: 1qQxhVGQMAaacLDP3DYj1w_1754301592
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-af911f05997so413805866b.3
        for <ceph-devel@vger.kernel.org>; Mon, 04 Aug 2025 02:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754301592; x=1754906392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ckkZeNmDDLh5+Aa/LXWOQsO5tBPmGT2tsRyUHeTJZxg=;
        b=FF3SrF+8ntWg7ZmetPJoIj2SLzcB/4tkn0k2m63WuwK289HKrAKpIAY+VUAgv9x7sv
         TQdAkEhhhUnedleIE13Xy35Ltw8NDt5IHzXYw18RKK0kBSjyK+JGuLa2m3e4YqSGRAYG
         xvHLc52QLT/9c9su3ryQ6Owp1PiAgzIve6MFvwSfikOlLLUvQw0DirMIR6l+6qLiYhZz
         hr8WjwZtYE2LELGgzU7muFU+lOsya5Q6w0lL8NrXYlNotpH8Xz2AHyS772z37uk4ol6Y
         cgP038nlAYHxxOpqM2fe4Su3sTvfCk3nGwHNYgvIcSoHGJZwSQbr7JfR/NvEOjYsI4tv
         M+ng==
X-Gm-Message-State: AOJu0YxyICKcNJLab+HAc37auFdPfUXKMxugpuHa/D2y4BNpXi3kk0q6
	PgegMe2SZtnaIx5CpWIaMvV3mMbkZrfzAq+jsAmMd94SGzSuoOWcXIYpR4xmr3NYn55IgT8xOiy
	ubL3gmTH8YCctQ8J+wYQqFtuMACMAHYVKFOTXg+oeMeLoIpt8z0SDsu1731UDwTDhGPAE3tYA4E
	3J5xSuU/+n6ArOebwE/7/U6xBW8mn61AocsIZcOQMhFHapjL66tA==
X-Gm-Gg: ASbGncsp4IllQxyL4yC7dIdLljufmSrN61BCYvXqS9pz5DAnSNJnqdsN5oNOUahP/5d
	ev5mCFtdb8j1Hyd0/Jy+oD3zp+UQWFaBa5ag2OBptZ4OLIeniaHsYRZvTcNSJuD5q7XPtjaFaqX
	G9S1Cj2tLHvJxc8J1P0hdyZT7szbtIYWeMu88WXAnbXZKZDT7SaESUSnrRhS2GANfYHwOKScZAI
	UDuI/Iyu2gUG4VMUWBk9Ip/Kfrp9EubZ1Gw9QM+dIbwwzpb2jnncwuTsImKwzgTbK/k6ngRa22H
	gbpWGSvMJ9bG/IXLBJcZDtdYHu9b8ovJWckRopqkh5jESOYP9RwEqjQCKVlVb/+3RIc0kcvJYw=
	=
X-Received: by 2002:a17:907:f818:b0:af1:8be4:768 with SMTP id a640c23a62f3a-af93ffb1c22mr997101666b.5.1754301591633;
        Mon, 04 Aug 2025 02:59:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfl9MCuoFgrlJ8eVT6c4DN4MPSxZK3sSE9DiF3oiQ790R2rjI6chEPahZQnmqKhQ9dtANEfg==
X-Received: by 2002:a17:907:f818:b0:af1:8be4:768 with SMTP id a640c23a62f3a-af93ffb1c22mr997097966b.5.1754301591102;
        Mon, 04 Aug 2025 02:59:51 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a078bcbsm715458766b.13.2025.08.04.02.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 02:59:50 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH v2 1/2] ceph: fix client race condition validating r_parent before applying state
Date: Mon,  4 Aug 2025 09:59:41 +0000
Message-Id: <20250804095942.2167541-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250804095942.2167541-1-amarkuze@redhat.com>
References: <20250804095942.2167541-1-amarkuze@redhat.com>
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
---
 fs/ceph/debugfs.c    |   6 +-
 fs/ceph/mds_client.c | 152 +++++++++++++++++++++++++++----------------
 fs/ceph/mds_client.h |  12 +++-
 3 files changed, 110 insertions(+), 60 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 2ffb29108176..35e621f41039 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -88,8 +88,8 @@ static int mdsc_show(struct seq_file *s, void *p)
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
@@ -98,7 +98,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 				   req->r_dentry,
 				   path ? path : "");
 			spin_unlock(&req->r_dentry->d_lock);
-			ceph_mdsc_free_path(path, pathlen);
+			ceph_mdsc_free_path(path, path_info.pathlen);
 		} else if (req->r_path1) {
 			seq_printf(s, " #%llx/%s", req->r_ino1.ino,
 				   req->r_path1);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8d9fc5e18b17..d2ae862c3dda 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2732,7 +2732,7 @@ static u8 *get_fscrypt_altname(const struct ceph_mds_request *req, u32 *plen)
  *   foo/.snap/bar -> foo//bar
  */
 char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
-			   int *plen, u64 *pbase, int for_wire)
+			   struct ceph_path_info *path_info, int for_wire)
 {
 	struct ceph_client *cl = mdsc->fsc->client;
 	struct dentry *cur;
@@ -2843,17 +2843,31 @@ char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 
-	*pbase = base;
-	*plen = PATH_MAX - 1 - pos;
-	CEPH_SAN_STRNCPY(result_str, sizeof(result_str), path + pos, *plen);
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
+	CEPH_SAN_STRNCPY(result_str, sizeof(result_str), path_info->path, path_info->pathlen);
 	boutc(cl, "on %p %d built %llx '%s'\n", dentry, d_count(dentry),
-	      base, result_str);
+	      path_info->vino.ino, result_str);
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
 
@@ -2862,41 +2876,47 @@ static int build_dentry_path(struct ceph_mds_client *mdsc, struct dentry *dentry
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
 
@@ -2906,28 +2926,31 @@ static int build_inode_path(struct inode *inode,
  */
 static int set_request_path_attr(struct ceph_mds_client *mdsc, struct inode *rinode,
 				 struct dentry *rdentry, struct inode *rdiri,
-				 const char *rpath, u64 rino, const char **ppath,
-				 int *pathlen, u64 *ino, bool *freepath,
+				 const char *rpath, u64 rino, struct ceph_path_info *path_info,
 				 bool parent_locked)
 {
 	struct ceph_client *cl = mdsc->fsc->client;
 	char result_str[128];
 	int r = 0;
 
+	/* Initialize the output structure */
+	memset(path_info, 0, sizeof(*path_info));
+
 	if (rinode) {
-		r = build_inode_path(rinode, ppath, pathlen, ino, freepath);
+		r = build_inode_path(rinode, path_info);
 		boutc(cl, " inode %p %llx.%llx\n", rinode, ceph_ino(rinode),
-		      ceph_snap(rinode));
+		ceph_snap(rinode));
 	} else if (rdentry) {
-		r = build_dentry_path(mdsc, rdentry, rdiri, ppath, pathlen, ino,
-					freepath, parent_locked);
-		CEPH_SAN_STRNCPY(result_str, sizeof(result_str), *ppath, *pathlen);
-		boutc(cl, " dentry %p %llx/%s\n", rdentry, *ino, result_str);
+		r = build_dentry_path(mdsc, rdentry, rdiri, path_info, parent_locked);
+		CEPH_SAN_STRNCPY(result_str, sizeof(result_str), path_info->path, path_info->pathlen);
+		boutc(cl, " dentry %p %llx/%s\n", rdentry, path_info->vino.ino, result_str);
 	} else if (rpath || rino) {
-		*ino = rino;
-		*ppath = rpath;
-		*pathlen = rpath ? strlen(rpath) : 0;
-		CEPH_SAN_STRNCPY(result_str, sizeof(result_str), rpath, *pathlen);
+		path_info->vino.ino = rino;
+		path_info->vino.snap = CEPH_NOSNAP;
+		path_info->path = rpath;
+		path_info->pathlen = rpath ? strlen(rpath) : 0;
+		path_info->freepath = false;
+		CEPH_SAN_STRNCPY(result_str, sizeof(result_str), rpath, path_info->pathlen);
 		boutc(cl," path %s\n", result_str);
 	}
 
@@ -3005,11 +3028,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
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
@@ -3019,25 +3039,42 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
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
+			WARN(1, "ceph: r_parent mismatch (had %llx wanted %llx) - updating\n",
+			     ceph_ino(req->r_parent), path_info1.vino.ino);
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
@@ -3068,7 +3105,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 
 	/* filepaths */
 	len += 2 * (1 + sizeof(u32) + sizeof(u64));
-	len += pathlen1 + pathlen2;
+	len += path_info1.pathlen + path_info2.pathlen;
 
 	/* cap releases */
 	len += sizeof(struct ceph_mds_request_release) *
@@ -3076,9 +3113,9 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 		 !!req->r_old_inode_drop + !!req->r_old_dentry_drop);
 
 	if (req->r_dentry_drop)
-		len += pathlen1;
+		len += path_info1.pathlen;
 	if (req->r_old_dentry_drop)
-		len += pathlen2;
+		len += path_info2.pathlen;
 
 	/* MClientRequest tail */
 
@@ -3191,8 +3228,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	lhead->ino = cpu_to_le64(req->r_deleg_ino);
 	lhead->args = req->r_args;
 
-	ceph_encode_filepath(&p, end, ino1, path1);
-	ceph_encode_filepath(&p, end, ino2, path2);
+	ceph_encode_filepath(&p, end, path_info1.vino.ino, path_info1.path);
+	ceph_encode_filepath(&p, end, path_info2.vino.ino, path_info2.path);
 
 	/* make note of release offset, in case we need to replay */
 	req->r_request_release_offset = p - msg->front.iov_base;
@@ -3255,11 +3292,11 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	msg->hdr.data_off = cpu_to_le16(0);
 
 out_free2:
-	if (freepath2)
-		ceph_mdsc_free_path((char *)path2, pathlen2);
+	if (path_info2.freepath)
+		ceph_mdsc_free_path((char *)path_info2.path, path_info2.pathlen);
 out_free1:
-	if (freepath1)
-		ceph_mdsc_free_path((char *)path1, pathlen1);
+	if (path_info1.freepath)
+		ceph_mdsc_free_path((char *)path_info1.path, path_info1.pathlen);
 out:
 	return msg;
 out_err:
@@ -4623,14 +4660,17 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 
 	dentry = d_find_primary(inode);
 	if (dentry) {
+		struct ceph_path_info path_info;
 		/* set pathbase to parent dir when msg_version >= 2 */
-		path = ceph_mdsc_build_path(mdsc, dentry, &pathlen, &pathbase,
+		path = ceph_mdsc_build_path(mdsc, dentry, &path_info,
 					    recon_state->msg_version >= 2);
 		dput(dentry);
 		if (IS_ERR(path)) {
 			err = PTR_ERR(path);
 			goto out_err;
 		}
+		pathlen = path_info.pathlen;
+		pathbase = path_info.vino.ino;
 	} else {
 		path = NULL;
 		pathbase = 0;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 3e2a6fa7c19a..c4c1ea8d5f5e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -623,8 +623,18 @@ static inline void ceph_mdsc_free_path(char *path, int len)
 		__putname(path - (PATH_MAX - 1 - len));
 }
 
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
 extern char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc,
-				  struct dentry *dentry, int *plen, u64 *base,
+				  struct dentry *dentry, struct ceph_path_info *path_info,
 				  int for_wire);
 
 extern void __ceph_mdsc_drop_dentry_lease(struct dentry *dentry);
-- 
2.34.1


