Return-Path: <ceph-devel+bounces-71-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8127E6544
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 09:26:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3719C1C2097D
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 08:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F109010944;
	Thu,  9 Nov 2023 08:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="THuNNSs/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98D21095B
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:26:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6E52D54
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 00:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699518399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Njz4/b5bo15ySMP/bF0+MYzhoLeL9P4ryQvqfLfCFXQ=;
	b=THuNNSs//ENwFS1+2TW05LlMloca5Org88OQqCyT9XOPL1Ar9S9j7oT2esLHAcGlBSqNCF
	kRVvfAfT5BHrMqyXAwrCks+SKyLyHhsgcPJ8DAiBf3cRTZgNA63SJMO7YRUyPYZUJK+cPY
	Umofg2LJgJaxpfhRRaW7EFDI0oqlPyE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-2tnPhKtHODmVPmiTZDV0PQ-1; Thu, 09 Nov 2023 03:26:36 -0500
X-MC-Unique: 2tnPhKtHODmVPmiTZDV0PQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 063ED837225;
	Thu,  9 Nov 2023 08:26:36 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CA68A2026D68;
	Thu,  9 Nov 2023 08:26:32 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/5] ceph: check the cephx mds auth access for setattr
Date: Thu,  9 Nov 2023 16:24:07 +0800
Message-ID: <20231109082409.417726-4-xiubli@redhat.com>
In-Reply-To: <20231109082409.417726-1-xiubli@redhat.com>
References: <20231109082409.417726-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Xiubo Li <xiubli@redhat.com>

If we hit any failre just try to force it to do the sync setattr.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b01728aaed4b..f984babbb68c 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2487,6 +2487,33 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	bool lock_snap_rwsem = false;
 	bool fill_fscrypt;
 	int truncate_retry = 20; /* The RMW will take around 50ms */
+	struct dentry *dentry;
+	char *path;
+	int pathlen;
+	u64 pathbase;
+	bool do_sync = false;
+
+	dentry = d_find_alias(inode);
+	if (!dentry) {
+		do_sync = true;
+	} else {
+		path = ceph_mdsc_build_path(mdsc, dentry, &pathlen, &pathbase, 0);
+		if (IS_ERR(path)) {
+			do_sync = true;
+			err = 0;
+		} else {
+			err = ceph_mds_check_access(mdsc, path, MAY_WRITE);
+		}
+		dput(dentry);
+
+		/* For none EACCES cases will let the MDS do the mds auth check */
+		if (err == -EACCES) {
+			return err;
+		} else if (err < 0) {
+			do_sync = true;
+			err = 0;
+		}
+	}
 
 retry:
 	prealloc_cf = ceph_alloc_cap_flush();
@@ -2533,7 +2560,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		/* It should never be re-set once set */
 		WARN_ON_ONCE(ci->fscrypt_auth);
 
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 			kfree(ci->fscrypt_auth);
 			ci->fscrypt_auth = (u8 *)cia->fscrypt_auth;
@@ -2562,7 +2589,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      ceph_vinop(inode),
 		      from_kuid(&init_user_ns, inode->i_uid),
 		      from_kuid(&init_user_ns, attr->ia_uid));
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_uid = fsuid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
@@ -2580,7 +2607,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      ceph_vinop(inode),
 		      from_kgid(&init_user_ns, inode->i_gid),
 		      from_kgid(&init_user_ns, attr->ia_gid));
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_gid = fsgid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
@@ -2594,7 +2621,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	if (ia_valid & ATTR_MODE) {
 		doutc(cl, "%p %llx.%llx mode 0%o -> 0%o\n", inode,
 		      ceph_vinop(inode), inode->i_mode, attr->ia_mode);
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_mode = attr->ia_mode;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
@@ -2611,11 +2638,11 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      inode, ceph_vinop(inode), inode->i_atime.tv_sec,
 		      inode->i_atime.tv_nsec, attr->ia_atime.tv_sec,
 		      attr->ia_atime.tv_nsec);
-		if (issued & CEPH_CAP_FILE_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_FILE_EXCL)) {
 			ci->i_time_warp_seq++;
 			inode->i_atime = attr->ia_atime;
 			dirtied |= CEPH_CAP_FILE_EXCL;
-		} else if ((issued & CEPH_CAP_FILE_WR) &&
+		} else if (!do_sync && (issued & CEPH_CAP_FILE_WR) &&
 			   timespec64_compare(&inode->i_atime,
 					    &attr->ia_atime) < 0) {
 			inode->i_atime = attr->ia_atime;
@@ -2651,7 +2678,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 						     CEPH_FSCRYPT_BLOCK_SIZE));
 			req->r_fscrypt_file = attr->ia_size;
 			fill_fscrypt = true;
-		} else if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
+		} else if (!do_sync && (issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
 			if (attr->ia_size > isize) {
 				i_size_write(inode, attr->ia_size);
 				inode->i_blocks = calc_inode_blocks(attr->ia_size);
@@ -2686,11 +2713,11 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      inode, ceph_vinop(inode), inode->i_mtime.tv_sec,
 		      inode->i_mtime.tv_nsec, attr->ia_mtime.tv_sec,
 		      attr->ia_mtime.tv_nsec);
-		if (issued & CEPH_CAP_FILE_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_FILE_EXCL)) {
 			ci->i_time_warp_seq++;
 			inode->i_mtime = attr->ia_mtime;
 			dirtied |= CEPH_CAP_FILE_EXCL;
-		} else if ((issued & CEPH_CAP_FILE_WR) &&
+		} else if (!do_sync && (issued & CEPH_CAP_FILE_WR) &&
 			   timespec64_compare(&inode->i_mtime,
 					    &attr->ia_mtime) < 0) {
 			inode->i_mtime = attr->ia_mtime;
-- 
2.41.0


