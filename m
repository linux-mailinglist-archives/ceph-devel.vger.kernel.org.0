Return-Path: <ceph-devel+bounces-192-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1328043E1
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 02:17:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDCD21F21355
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 01:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 966901375;
	Tue,  5 Dec 2023 01:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aUvWbcB5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA9AC9
	for <ceph-devel@vger.kernel.org>; Mon,  4 Dec 2023 17:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701739032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpLyr/tpqshwtUpPs+VO3GjdFB4NBN5IkaEGICql5kU=;
	b=aUvWbcB5jIL85EsCXMcJkzcwZGOCJjttIflHMtLnhdgBh90tMnq+OemSOe3SIs1Tqx0Nv8
	QwmxJ+astonmyQZ1jyRC+GgQ/IYzv06CY3l+qJoOZZ0OJ2MXceM6/uNjj0QW5pyD6zpaqt
	tlXOS/GI8XqGO+SWAko8TNMLEFkBTW4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-LSgc6g22O9ihSzw9IOjAzg-1; Mon, 04 Dec 2023 20:17:08 -0500
X-MC-Unique: LSgc6g22O9ihSzw9IOjAzg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 982C08007B3;
	Tue,  5 Dec 2023 01:17:08 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.113.153])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D80B8492BE0;
	Tue,  5 Dec 2023 01:17:05 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 3/6] ceph: check the cephx mds auth access for setattr
Date: Tue,  5 Dec 2023 09:14:36 +0800
Message-ID: <20231205011439.84238-4-xiubli@redhat.com>
In-Reply-To: <20231205011439.84238-1-xiubli@redhat.com>
References: <20231205011439.84238-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Xiubo Li <xiubli@redhat.com>

If we hit any failre just try to force it to do the sync setattr.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index cf64ccb479a7..a07a425376bc 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2487,6 +2487,34 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
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
+		ceph_mdsc_free_path(path, pathlen);
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
@@ -2533,7 +2561,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		/* It should never be re-set once set */
 		WARN_ON_ONCE(ci->fscrypt_auth);
 
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 			kfree(ci->fscrypt_auth);
 			ci->fscrypt_auth = (u8 *)cia->fscrypt_auth;
@@ -2562,7 +2590,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      ceph_vinop(inode),
 		      from_kuid(&init_user_ns, inode->i_uid),
 		      from_kuid(&init_user_ns, attr->ia_uid));
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_uid = fsuid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
@@ -2580,7 +2608,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      ceph_vinop(inode),
 		      from_kgid(&init_user_ns, inode->i_gid),
 		      from_kgid(&init_user_ns, attr->ia_gid));
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_gid = fsgid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
@@ -2594,7 +2622,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	if (ia_valid & ATTR_MODE) {
 		doutc(cl, "%p %llx.%llx mode 0%o -> 0%o\n", inode,
 		      ceph_vinop(inode), inode->i_mode, attr->ia_mode);
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_mode = attr->ia_mode;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
@@ -2611,11 +2639,11 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
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
@@ -2651,7 +2679,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 						     CEPH_FSCRYPT_BLOCK_SIZE));
 			req->r_fscrypt_file = attr->ia_size;
 			fill_fscrypt = true;
-		} else if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
+		} else if (!do_sync && (issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
 			if (attr->ia_size > isize) {
 				i_size_write(inode, attr->ia_size);
 				inode->i_blocks = calc_inode_blocks(attr->ia_size);
@@ -2686,11 +2714,11 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
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


