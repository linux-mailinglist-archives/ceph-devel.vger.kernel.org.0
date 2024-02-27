Return-Path: <ceph-devel+bounces-918-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 68B588689ED
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 08:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECF51B22D4F
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 07:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56AA854F84;
	Tue, 27 Feb 2024 07:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tt9+cQ3u"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405CE54BF1
	for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 07:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709019311; cv=none; b=i1cL6mAwlIp+9s1ooveana/WF8OV8HH4Zhr1YhZJYJsA1B8CPYPfCgCLghbb1DZWDef8giIo78LfZgTjUKcngT1jxpQOjq7kTV+84OVeuPryQT95I53g3HewSB1UnTjSiNFNQrG9KYXgK4/p9SgR0WX8a2ivdzbDGxOwypnTXj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709019311; c=relaxed/simple;
	bh=B7NdAODinXzEP0VcdjEv6rNI/zI4ecbk4YMPmgJ+jrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8Ld2oQIQUxJeX1ZLafOs0D50O5Esw4WFmEDpwa/lFRHMRhxZBwwndkZlE/0DJHtQfGMRgVgjM8vstDPdTUr1AnvxRBqqC/wt4V/XgKtUZF/I05OOeRAtHIfjA/srx6CBOgpjsu1J/5b8dPUemV3tXPGK7MPETExCeyq47pnyTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tt9+cQ3u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709019308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9vHRXYX468pWW9K9qLX1z9CmqZr1ELAxTQ9SPzOXZwg=;
	b=Tt9+cQ3uyBTvzinu+Hn085TlLJP1Su2BCTFPtxtkre0tWlTFD6QxKSWowybMUmT5rYbrx9
	2XGt+8ZxpaKF4nsqTdMxfykW24Ljn2GnWyzchApA4J/G54z4Ec7XBsAVArKparPFfBGEPA
	/cEQsrxyHDt4VXikm4VpsJFwvzjcJUc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-HPga6qcWPUyNRui6uNTgTA-1; Tue, 27 Feb 2024 02:35:06 -0500
X-MC-Unique: HPga6qcWPUyNRui6uNTgTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DBB210B0702;
	Tue, 27 Feb 2024 07:35:06 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.214])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DAD22166B33;
	Tue, 27 Feb 2024 07:35:02 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 4/6] ceph: check the cephx mds auth access for open
Date: Tue, 27 Feb 2024 15:27:03 +0800
Message-ID: <20240227072705.593676-5-xiubli@redhat.com>
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

Before opening the file locally we need to check the cephx access.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index abe8028d95bf..08cd36679fcc 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -366,6 +366,12 @@ int ceph_open(struct inode *inode, struct file *file)
 	struct ceph_file_info *fi = file->private_data;
 	int err;
 	int flags, fmode, wanted;
+	struct dentry *dentry;
+	char *path;
+	int pathlen;
+	u64 pathbase;
+	bool do_sync = false;
+	int mask = MAY_READ;
 
 	if (fi) {
 		doutc(cl, "file %p is already opened\n", file);
@@ -387,6 +393,31 @@ int ceph_open(struct inode *inode, struct file *file)
 	fmode = ceph_flags_to_mode(flags);
 	wanted = ceph_caps_for_mode(fmode);
 
+	if (fmode & CEPH_FILE_MODE_WR)
+		mask |= MAY_WRITE;
+	dentry = d_find_alias(inode);
+	if (!dentry) {
+		do_sync = true;
+	} else {
+		path = ceph_mdsc_build_path(mdsc, dentry, &pathlen, &pathbase, 0);
+		if (IS_ERR(path)) {
+			do_sync = true;
+			err = 0;
+		} else {
+			err = ceph_mds_check_access(mdsc, path, mask);
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
+
 	/* snapped files are read-only */
 	if (ceph_snap(inode) != CEPH_NOSNAP && (file->f_mode & FMODE_WRITE))
 		return -EROFS;
@@ -402,7 +433,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	 * asynchronously.
 	 */
 	spin_lock(&ci->i_ceph_lock);
-	if (__ceph_is_any_real_caps(ci) &&
+	if (!do_sync && __ceph_is_any_real_caps(ci) &&
 	    (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap)) {
 		int mds_wanted = __ceph_caps_mds_wanted(ci, true);
 		int issued = __ceph_caps_issued(ci, NULL);
@@ -420,7 +451,7 @@ int ceph_open(struct inode *inode, struct file *file)
 			ceph_check_caps(ci, 0);
 
 		return ceph_init_file(inode, file, fmode);
-	} else if (ceph_snap(inode) != CEPH_NOSNAP &&
+	} else if (!do_sync && ceph_snap(inode) != CEPH_NOSNAP &&
 		   (ci->i_snap_caps & wanted) == wanted) {
 		__ceph_touch_fmode(ci, mdsc, fmode);
 		spin_unlock(&ci->i_ceph_lock);
-- 
2.43.0


