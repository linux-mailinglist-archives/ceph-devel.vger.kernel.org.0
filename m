Return-Path: <ceph-devel+bounces-72-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDC17E6545
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 09:26:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C41061C20C2B
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 08:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BABE610944;
	Thu,  9 Nov 2023 08:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5rZ43ri"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED37163B2
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:26:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD282D50
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 00:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699518406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/uFsFoj5WgrsQrmZ26rZrk/q8DLO3tKy2Wiy8oFYUY=;
	b=g5rZ43riNldmvU0QWkfTTNDEAE6UXePNo++Rhp6drfSTvgeYcDRepQPylg7fkyfWv+phrr
	pYvH5ki70Cj59trGYIneLDIl9QevfXmsaZm2vVf+vcLX5lkqLcHgRUqBNUkeiC86ehNEIy
	ltdhu7ebTNZFRZzlp1lqSvRcxNNnjho=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-ZRyLg_7GPsegsR7Pv6rHnw-1; Thu, 09 Nov 2023 03:26:43 -0500
X-MC-Unique: ZRyLg_7GPsegsR7Pv6rHnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3BDB803307;
	Thu,  9 Nov 2023 08:26:42 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B71032027019;
	Thu,  9 Nov 2023 08:26:36 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 4/5] ceph: check the cephx mds auth access for open
Date: Thu,  9 Nov 2023 16:24:08 +0800
Message-ID: <20231109082409.417726-5-xiubli@redhat.com>
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

Before opening the file locally we need to check the cephx access.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 227fc226227b..8e9178446fdd 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -365,6 +365,12 @@ int ceph_open(struct inode *inode, struct file *file)
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
@@ -386,6 +392,30 @@ int ceph_open(struct inode *inode, struct file *file)
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
@@ -401,7 +431,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	 * asynchronously.
 	 */
 	spin_lock(&ci->i_ceph_lock);
-	if (__ceph_is_any_real_caps(ci) &&
+	if (!do_sync && __ceph_is_any_real_caps(ci) &&
 	    (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap)) {
 		int mds_wanted = __ceph_caps_mds_wanted(ci, true);
 		int issued = __ceph_caps_issued(ci, NULL);
@@ -419,7 +449,7 @@ int ceph_open(struct inode *inode, struct file *file)
 			ceph_check_caps(ci, 0);
 
 		return ceph_init_file(inode, file, fmode);
-	} else if (ceph_snap(inode) != CEPH_NOSNAP &&
+	} else if (!do_sync && ceph_snap(inode) != CEPH_NOSNAP &&
 		   (ci->i_snap_caps & wanted) == wanted) {
 		__ceph_touch_fmode(ci, mdsc, fmode);
 		spin_unlock(&ci->i_ceph_lock);
-- 
2.41.0


