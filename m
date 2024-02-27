Return-Path: <ceph-devel+bounces-917-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3658689EC
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 08:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B37E91C22035
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 07:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3757B55E65;
	Tue, 27 Feb 2024 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LgV7HVl+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4363454FAB
	for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 07:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709019308; cv=none; b=Dfp7I7YJkCfcx9JegR4hMjRce4vIMf1wGhQbPC+GdJ/jOhs/5HaBZz8+d/ScvDAP5GY8hDcrRQ/Q5DtmAKEC9FBY/bepRZZ8TreCcwkPN570DZBVAhR+hHi9VWVueJjCGEJwiWypmcId3L2g5tikT8BvpFsWNiqhjI8px7lpPd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709019308; c=relaxed/simple;
	bh=LQf/fXvyIMPCmUBsrwBqE65vjx8ATvvxXYL0Yj8ybRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPuTZOW9h2hF3HEmz2Jax5PwFnyzjCjUJR/XX8MwdOU6g92npUWyUoqZL5ZHDwYi+DaoYSJRBKAIJaZX8N/vbJCdD0V+v/V1LpTH35+Oc4AsdIxpaRT/wi3eim8xW338B1CbiKEFpiOvcPDCYs0KZWDK36KwgZUheRpARIwn7No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LgV7HVl+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709019306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vGkv5rWtqYBystXXt8q9klp/8vFOQn94fFlhZ+kyrHI=;
	b=LgV7HVl+caNygmOQNSzWcOd7u97JajEYfZZUfcKkKMfKj/6Pvf/UFhK1qY8jNSGCe1iPcX
	eaUqv2m3z92L+Wmi5nTlxOYhPKSgknkwCjlMPtPWiRGzcV7xnTJwfC7On9bmFGgkBn5tu9
	ZRp5mbX/HkILroz5//bPRDU76VHCdaw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-Jgxt9XT6Ox2-N8NHzo2TkA-1; Tue, 27 Feb 2024 02:35:02 -0500
X-MC-Unique: Jgxt9XT6Ox2-N8NHzo2TkA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7097B862DC0;
	Tue, 27 Feb 2024 07:35:02 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.214])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 780562166B5D;
	Tue, 27 Feb 2024 07:34:59 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 3/6] ceph: check the cephx mds auth access for setattr
Date: Tue, 27 Feb 2024 15:27:02 +0800
Message-ID: <20240227072705.593676-4-xiubli@redhat.com>
In-Reply-To: <20240227072705.593676-1-xiubli@redhat.com>
References: <20240227072705.593676-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

If we hit any failre just try to force it to do the sync setattr.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 3030136b0a61..486ad9d917d0 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2492,6 +2492,34 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
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
@@ -2538,7 +2566,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		/* It should never be re-set once set */
 		WARN_ON_ONCE(ci->fscrypt_auth);
 
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 			kfree(ci->fscrypt_auth);
 			ci->fscrypt_auth = (u8 *)cia->fscrypt_auth;
@@ -2567,7 +2595,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      ceph_vinop(inode),
 		      from_kuid(&init_user_ns, inode->i_uid),
 		      from_kuid(&init_user_ns, attr->ia_uid));
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_uid = fsuid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
@@ -2585,7 +2613,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      ceph_vinop(inode),
 		      from_kgid(&init_user_ns, inode->i_gid),
 		      from_kgid(&init_user_ns, attr->ia_gid));
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_gid = fsgid;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
@@ -2599,7 +2627,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 	if (ia_valid & ATTR_MODE) {
 		doutc(cl, "%p %llx.%llx mode 0%o -> 0%o\n", inode,
 		      ceph_vinop(inode), inode->i_mode, attr->ia_mode);
-		if (issued & CEPH_CAP_AUTH_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_AUTH_EXCL)) {
 			inode->i_mode = attr->ia_mode;
 			dirtied |= CEPH_CAP_AUTH_EXCL;
 		} else if ((issued & CEPH_CAP_AUTH_SHARED) == 0 ||
@@ -2618,11 +2646,11 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      inode, ceph_vinop(inode),
 		      atime.tv_sec, atime.tv_nsec,
 		      attr->ia_atime.tv_sec, attr->ia_atime.tv_nsec);
-		if (issued & CEPH_CAP_FILE_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_FILE_EXCL)) {
 			ci->i_time_warp_seq++;
 			inode_set_atime_to_ts(inode, attr->ia_atime);
 			dirtied |= CEPH_CAP_FILE_EXCL;
-		} else if ((issued & CEPH_CAP_FILE_WR) &&
+		} else if (!do_sync && (issued & CEPH_CAP_FILE_WR) &&
 			   timespec64_compare(&atime,
 					      &attr->ia_atime) < 0) {
 			inode_set_atime_to_ts(inode, attr->ia_atime);
@@ -2658,7 +2686,7 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 						     CEPH_FSCRYPT_BLOCK_SIZE));
 			req->r_fscrypt_file = attr->ia_size;
 			fill_fscrypt = true;
-		} else if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
+		} else if (!do_sync && (issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
 			if (attr->ia_size > isize) {
 				i_size_write(inode, attr->ia_size);
 				inode->i_blocks = calc_inode_blocks(attr->ia_size);
@@ -2695,11 +2723,11 @@ int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
 		      inode, ceph_vinop(inode),
 		      mtime.tv_sec, mtime.tv_nsec,
 		      attr->ia_mtime.tv_sec, attr->ia_mtime.tv_nsec);
-		if (issued & CEPH_CAP_FILE_EXCL) {
+		if (!do_sync && (issued & CEPH_CAP_FILE_EXCL)) {
 			ci->i_time_warp_seq++;
 			inode_set_mtime_to_ts(inode, attr->ia_mtime);
 			dirtied |= CEPH_CAP_FILE_EXCL;
-		} else if ((issued & CEPH_CAP_FILE_WR) &&
+		} else if (!do_sync && (issued & CEPH_CAP_FILE_WR) &&
 			   timespec64_compare(&mtime, &attr->ia_mtime) < 0) {
 			inode_set_mtime_to_ts(inode, attr->ia_mtime);
 			dirtied |= CEPH_CAP_FILE_WR;
-- 
2.43.0


