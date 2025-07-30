Return-Path: <ceph-devel+bounces-3335-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BECB16380
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 17:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E3467A8E5E
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 15:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF58C1A5B92;
	Wed, 30 Jul 2025 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhucYuyu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9862DBF7C
	for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753888762; cv=none; b=cnhD+4ngkDimvvRrTYA9gaQOF0cbI/G/15q1sotPc8rCZ6lPzMGsr7gi8zJEXewihXg66/03RKZNFz7oOdwWV9o41XKljGBQEdnjpb17HiQvJOEGtBu+MO3Apy6hIxq8DV4Psi2uQTF5NdlcCmwdSq/zyDjhDdvwQNvhMe7164Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753888762; c=relaxed/simple;
	bh=0n103pgoDpv8mKy8DTA/ArLWwYcpqqGdnKsRntCaLSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KE98u2uUKk2exSTwJ12uuVCYwh1ge7ID/n10vch4TwtL85Xp4netdBZlnWpXwOtPkpEIboxmts8PZwyugi88zNo5OEHXtJuZfxziM/dDvJyPDWB4vr8EMBfl7fAh6lq7PY4azCkPT8wIKerLWRiSQgmc+gJiTqFQz0a9/Nq9Xfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QhucYuyu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753888759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BcpCNhl3uRwHB4Xkvq7ATZcj8L15UCaAfH+eehjk83w=;
	b=QhucYuyuYITV6sIrny8ZhranybkjExmkM2iMnTwr4wclGD9rsggJ7uVoXCMNYoZEVytBST
	aIWFTqTZnsTl7ggk+zFsBhuFpVVWhlyPQk1QoDyDsleypoGodHT3WPB8QiiqVpASiNpZ+R
	t+8lt2hki6zpLTzrnFyUfZ8zkwUgi/Y=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-2n7BZHxVP2ygHsKezZvZHw-1; Wed, 30 Jul 2025 11:19:17 -0400
X-MC-Unique: 2n7BZHxVP2ygHsKezZvZHw-1
X-Mimecast-MFC-AGG-ID: 2n7BZHxVP2ygHsKezZvZHw_1753888756
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6fab979413fso132905646d6.2
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 08:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753888756; x=1754493556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BcpCNhl3uRwHB4Xkvq7ATZcj8L15UCaAfH+eehjk83w=;
        b=a1vJJBztP0XisxAL7JiA+QtfdoDsMLrlIi+GYXcBo3GR1h1Iuz9IamvbKG1gn7ZdQG
         AkHw09wkKKpuN0gEMFHBbFCbh1Sdqc+7GJdEbm2QodRKddRrJcLlXiFyRBkNXUHzvM8n
         +HK/oLAEo8JtDqaE70Pw1XC1ObxzwOxXPJoGAeujeDo6lHusUpUTjOyx8n1Z6NyvGcyQ
         LSB7ino2kH4/TFYP1pf8lN2YOvnquBdmLiIy/IaI6Jc4d6AIhtW382zYGVYxT49+1vf+
         2EqtU5YfirSBK4ULOdvW18Y8ACymdSrVnzOPsTwLEOgBSyBIlDqRCsQBs3TXfSayP1sO
         NgYw==
X-Gm-Message-State: AOJu0YxRyY4ZDUfJFpY5m62mNmt2gGpfQnqCZE/ZiuHOH6/l7uLjTNYj
	YHYHZrEQ1hZGzLP2qieXnb1Lmo3yyw+4NjDCqTs7c/I/6UWtfVLzGyBn5pWf1Arwh99+AE5r3ZJ
	S3u/cunFwDUJcillFnHY3d6s2haGhTktuSN6A8O5AnQvTIPo60r/pQONvwPPNVJNQ52wEah3ko1
	dgM7BlXTF9n8cVT9e7MIFBGl/8GzogUPBqtNayaThMGRoRX2pt1TC0
X-Gm-Gg: ASbGncu+1gCQWCw+V5L78kfSZWVyLihzS3rIWlRe8rzQC/N4VZ/g425nguX1X4XDzYu
	VKo0MdkV3/MpZZo2R6x+TvXDmmYWkXg9ZXZj4BQbcpGNCPaao+j8SbX7DPAdsXRkDY7nRiarT34
	65cPD4KTWSoABjg2E/I7ImL51Cy33TBNBnCPsuuEOuwAIqNreJvDyOoiNEyJ/SerTGm0ZWLXPdw
	RIork7ergHkf/QFAGXzxofaSX+rEYrigeFvqo8hCahRlinXPwmesIv7kDg1aJtmgyAakNqltydx
	wKC/6QyGwlcLVYiIvGjDUhpdJwDBH5gJPvtA9PmyVGFzZUokuumqsjadRrEJlcHJeem4X9X0bw=
	=
X-Received: by 2002:a05:6214:2529:b0:707:5221:3071 with SMTP id 6a1803df08f44-707672d2b41mr53817256d6.47.1753888756261;
        Wed, 30 Jul 2025 08:19:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGO2yhzSwdx3Xj6/lK8GwIv/Dud1VUWjNjuIwOTadv7RQDWA+tATtnabRROZ7VbHsOiABjTmg==
X-Received: by 2002:a05:6214:2529:b0:707:5221:3071 with SMTP id 6a1803df08f44-707672d2b41mr53816716d6.47.1753888755613;
        Wed, 30 Jul 2025 08:19:15 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7076ba8834asm11322986d6.25.2025.07.30.08.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 08:19:15 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 1/2] ceph: fix client race condition validating r_parent before applying state
Date: Wed, 30 Jul 2025 15:18:59 +0000
Message-Id: <20250730151900.1591177-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730151900.1591177-1-amarkuze@redhat.com>
References: <20250730151900.1591177-1-amarkuze@redhat.com>
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
 fs/ceph/mds_client.c | 67 +++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8d9fc5e18b17..a164783fc1e1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2853,7 +2853,7 @@ char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 
 static int build_dentry_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 			     struct inode *dir, const char **ppath, int *ppathlen,
-			     u64 *pino, bool *pfreepath, bool parent_locked)
+			     struct ceph_vino *pvino, bool *pfreepath, bool parent_locked)
 {
 	char *path;
 
@@ -2862,23 +2862,29 @@ static int build_dentry_path(struct ceph_mds_client *mdsc, struct dentry *dentry
 		dir = d_inode_rcu(dentry->d_parent);
 	if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP &&
 	    !IS_ENCRYPTED(dir)) {
-		*pino = ceph_ino(dir);
+		pvino->ino = ceph_ino(dir);
+		pvino->snap = ceph_snap(dir);
 		rcu_read_unlock();
 		*ppath = dentry->d_name.name;
 		*ppathlen = dentry->d_name.len;
 		return 0;
 	}
 	rcu_read_unlock();
-	path = ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
+	path = ceph_mdsc_build_path(mdsc, dentry, ppathlen, &pvino->ino, 1);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	*ppath = path;
 	*pfreepath = true;
+	/* For paths built by ceph_mdsc_build_path, we need to get snap from dentry */
+	if (dentry && d_inode(dentry))
+		pvino->snap = ceph_snap(d_inode(dentry));
+	else
+		pvino->snap = CEPH_NOSNAP;
 	return 0;
 }
 
 static int build_inode_path(struct inode *inode,
-			    const char **ppath, int *ppathlen, u64 *pino,
+			    const char **ppath, int *ppathlen, struct ceph_vino *pvino,
 			    bool *pfreepath)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
@@ -2886,17 +2892,19 @@ static int build_inode_path(struct inode *inode,
 	char *path;
 
 	if (ceph_snap(inode) == CEPH_NOSNAP) {
-		*pino = ceph_ino(inode);
+		pvino->ino = ceph_ino(inode);
+		pvino->snap = ceph_snap(inode);
 		*ppathlen = 0;
 		return 0;
 	}
 	dentry = d_find_alias(inode);
-	path = ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
+	path = ceph_mdsc_build_path(mdsc, dentry, ppathlen, &pvino->ino, 1);
 	dput(dentry);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	*ppath = path;
 	*pfreepath = true;
+	pvino->snap = ceph_snap(inode);
 	return 0;
 }
 
@@ -2907,7 +2915,7 @@ static int build_inode_path(struct inode *inode,
 static int set_request_path_attr(struct ceph_mds_client *mdsc, struct inode *rinode,
 				 struct dentry *rdentry, struct inode *rdiri,
 				 const char *rpath, u64 rino, const char **ppath,
-				 int *pathlen, u64 *ino, bool *freepath,
+				 int *pathlen, struct ceph_vino *p_vino, bool *freepath,
 				 bool parent_locked)
 {
 	struct ceph_client *cl = mdsc->fsc->client;
@@ -2915,16 +2923,17 @@ static int set_request_path_attr(struct ceph_mds_client *mdsc, struct inode *rin
 	int r = 0;
 
 	if (rinode) {
-		r = build_inode_path(rinode, ppath, pathlen, ino, freepath);
+		r = build_inode_path(rinode, ppath, pathlen, p_vino, freepath);
 		boutc(cl, " inode %p %llx.%llx\n", rinode, ceph_ino(rinode),
-		      ceph_snap(rinode));
+		ceph_snap(rinode));
 	} else if (rdentry) {
-		r = build_dentry_path(mdsc, rdentry, rdiri, ppath, pathlen, ino,
-					freepath, parent_locked);
+		r = build_dentry_path(mdsc, rdentry, rdiri, ppath, pathlen, p_vino,
+				       freepath, parent_locked);
 		CEPH_SAN_STRNCPY(result_str, sizeof(result_str), *ppath, *pathlen);
-		boutc(cl, " dentry %p %llx/%s\n", rdentry, *ino, result_str);
+		boutc(cl, " dentry %p %llx/%s\n", rdentry, p_vino->ino, result_str);
 	} else if (rpath || rino) {
-		*ino = rino;
+		p_vino->ino = rino;
+		p_vino->snap = CEPH_NOSNAP;
 		*ppath = rpath;
 		*pathlen = rpath ? strlen(rpath) : 0;
 		CEPH_SAN_STRNCPY(result_str, sizeof(result_str), rpath, *pathlen);
@@ -3007,7 +3016,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	struct ceph_mds_request_head_legacy *lhead;
 	const char *path1 = NULL;
 	const char *path2 = NULL;
-	u64 ino1 = 0, ino2 = 0;
+	struct ceph_vino vino1 = {0}, vino2 = {0};
 	int pathlen1 = 0, pathlen2 = 0;
 	bool freepath1 = false, freepath2 = false;
 	struct dentry *old_dentry = NULL;
@@ -3019,17 +3028,35 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	u16 request_head_version = mds_supported_head_version(session);
 	kuid_t caller_fsuid = req->r_cred->fsuid;
 	kgid_t caller_fsgid = req->r_cred->fsgid;
+	bool parent_locked = test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 
 	ret = set_request_path_attr(mdsc, req->r_inode, req->r_dentry,
 			      req->r_parent, req->r_path1, req->r_ino1.ino,
-			      &path1, &pathlen1, &ino1, &freepath1,
-			      test_bit(CEPH_MDS_R_PARENT_LOCKED,
-					&req->r_req_flags));
+			      &path1, &pathlen1, &vino1, &freepath1,
+			      parent_locked);
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
+	    req->r_parent && vino1.ino && ceph_ino(req->r_parent) != vino1.ino) {
+		struct inode *correct_dir = ceph_get_inode(mdsc->fsc->sb, vino1, NULL);
+		if (!IS_ERR(correct_dir)) {
+			WARN(1, "ceph: r_parent mismatch (had %llx wanted %llx) - updating\n",
+			     ceph_ino(req->r_parent), vino1.ino);
+			iput(req->r_parent);
+			req->r_parent = correct_dir;
+		}
+	}
+
 	/* If r_old_dentry is set, then assume that its parent is locked */
 	if (req->r_old_dentry &&
 	    !(req->r_old_dentry->d_flags & DCACHE_DISCONNECTED))
@@ -3037,7 +3064,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	ret = set_request_path_attr(mdsc, NULL, old_dentry,
 			      req->r_old_dentry_dir,
 			      req->r_path2, req->r_ino2.ino,
-			      &path2, &pathlen2, &ino2, &freepath2, true);
+			      &path2, &pathlen2, &vino2, &freepath2, true);
 	if (ret < 0) {
 		msg = ERR_PTR(ret);
 		goto out_free1;
@@ -3191,8 +3218,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	lhead->ino = cpu_to_le64(req->r_deleg_ino);
 	lhead->args = req->r_args;
 
-	ceph_encode_filepath(&p, end, ino1, path1);
-	ceph_encode_filepath(&p, end, ino2, path2);
+	ceph_encode_filepath(&p, end, vino1.ino, path1);
+	ceph_encode_filepath(&p, end, vino2.ino, path2);
 
 	/* make note of release offset, in case we need to replay */
 	req->r_request_release_offset = p - msg->front.iov_base;
-- 
2.34.1


