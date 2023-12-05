Return-Path: <ceph-devel+bounces-193-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D00C28043E2
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 02:17:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C16128151A
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 01:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD9B17C9;
	Tue,  5 Dec 2023 01:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HXRqREwu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E574D5
	for <ceph-devel@vger.kernel.org>; Mon,  4 Dec 2023 17:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701739033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CnjjP2jHMWJOap8iVnmQsWv+e47JGFZknsi85tRk/Mw=;
	b=HXRqREwuzWat/Q8nnKfVILZEIKPeH3T1o35C07B18AJhGI0E7YGfEsYF1eBRyhXZMThgeU
	T7Zz14yG2fv5d3Kj1irCIvQdZMXwrP/6kJpo0YQHCvNVuO0xik7mD2uSGzNfkpEhboOkC6
	dBpYq2M+VbE6B4wrFnYGdRV7jdTouOE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-ch8g-fgzMx2KzHU8fArIhQ-1; Mon, 04 Dec 2023 20:17:12 -0500
X-MC-Unique: ch8g-fgzMx2KzHU8fArIhQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 069A385A59D;
	Tue,  5 Dec 2023 01:17:12 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.113.153])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45EC7492BE0;
	Tue,  5 Dec 2023 01:17:08 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 4/6] ceph: check the cephx mds auth access for open
Date: Tue,  5 Dec 2023 09:14:37 +0800
Message-ID: <20231205011439.84238-5-xiubli@redhat.com>
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

Before opening the file locally we need to check the cephx access.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 227fc226227b..47511df2e666 100644
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
@@ -386,6 +392,31 @@ int ceph_open(struct inode *inode, struct file *file)
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
@@ -401,7 +432,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	 * asynchronously.
 	 */
 	spin_lock(&ci->i_ceph_lock);
-	if (__ceph_is_any_real_caps(ci) &&
+	if (!do_sync && __ceph_is_any_real_caps(ci) &&
 	    (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap)) {
 		int mds_wanted = __ceph_caps_mds_wanted(ci, true);
 		int issued = __ceph_caps_issued(ci, NULL);
@@ -419,7 +450,7 @@ int ceph_open(struct inode *inode, struct file *file)
 			ceph_check_caps(ci, 0);
 
 		return ceph_init_file(inode, file, fmode);
-	} else if (ceph_snap(inode) != CEPH_NOSNAP &&
+	} else if (!do_sync && ceph_snap(inode) != CEPH_NOSNAP &&
 		   (ci->i_snap_caps & wanted) == wanted) {
 		__ceph_touch_fmode(ci, mdsc, fmode);
 		spin_unlock(&ci->i_ceph_lock);
-- 
2.41.0


