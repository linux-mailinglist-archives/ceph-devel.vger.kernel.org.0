Return-Path: <ceph-devel+bounces-3516-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30284B43864
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 12:18:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B73117AB6F
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 10:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE4C2FAC1E;
	Thu,  4 Sep 2025 10:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BfR4sS3o"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798CA2F998A
	for <ceph-devel@vger.kernel.org>; Thu,  4 Sep 2025 10:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756980764; cv=none; b=cfoYXVbCbp0jp5wtRbmSgyR7z/kp4GC/IVctby2Le0/BQgEGMkMflYqJalO1GIU+VXWL/8iZ7UBkuA6Tf5O5MSwxVRYIAvDm86nBGeYrdhyudLmpXAzFYDEL7vSGydOJzNEk5lsyWRJE4v3Doim+k2AQ8IIqoH2caj69PzEdBEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756980764; c=relaxed/simple;
	bh=+uMYP2uW1nW7hKYFC4QWMKbYzHHQg2YgG9k4JO4Cwac=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HNqPLbABsbf8ag4TuLa1XJMlT8UIQj+xVBs6ItMKxgV1Fy5JiNAnPxKXXexiGWF/TMgT8X02qlo11rR5PTMoru1xgBXR/BZUGGoeX1ronem8w6Qwm7vbtcuN8WZvOdfRB9AMmAjjNRQj1QmyIWQTsvatXILHDKxExWIiCd6Gx10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BfR4sS3o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756980761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UFmPjeed1+G8MbqZG8Hbk52yIxOOxNCzUZSme1htoZc=;
	b=BfR4sS3oneBZylDy8vyEPOJY2ALsKAtqmw7zqUgzc3tNsohjeuCT5IQJ4RJ1EkZh5ilV8e
	MHTz+8cGQWtOY6xTWPso4SzM0LUS1O8vw1l1CL7OIW1/FKYUZnp1RWa0jCF9S4W4OzIFXE
	GqMMrSPCyddHRz/O2yJG4UmvUleW66E=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-tZMZKga6M5ucFwLDjxCjhQ-1; Thu, 04 Sep 2025 06:12:40 -0400
X-MC-Unique: tZMZKga6M5ucFwLDjxCjhQ-1
X-Mimecast-MFC-AGG-ID: tZMZKga6M5ucFwLDjxCjhQ_1756980760
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7ea01ed5d7cso92011385a.3
        for <ceph-devel@vger.kernel.org>; Thu, 04 Sep 2025 03:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756980760; x=1757585560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UFmPjeed1+G8MbqZG8Hbk52yIxOOxNCzUZSme1htoZc=;
        b=bpjn6cxSpcoIPFQhzQgUm7BWRPIAe33LFSTueLQHPEpPQI9c+3Bm8vjOP7OLGPaqLE
         mjleJXeTxf14y/BQDhWYAPDUreAM1RSvHXRvxtHT0EAL0C49VQ16ktkkayDlG1Y4qqVU
         LrtkteLNyYO9QAUAZma14lGouB1inAX0MfjgI98IVlu6b/hHYpoy9Xfeol7AL1R9X0j6
         +hUQ5zkTBCKw0yaPXk9O7wknnfBNLaSvbKdPwBFsds6YIUbFOoX6JhLD4c5OEN/lAonZ
         z0ZU9CsiICWxp0HTv+F932NPlfi594Ed+3B/zCJFs148oHGOasd2qB/bwk3WZ0LUPmHl
         O4oQ==
X-Gm-Message-State: AOJu0YyTQqcUyiYU6NsZBG8yPliHr3REW/SmxxxqN5MbOt+hueJaLYoW
	yomF9KOzScZa1+gs5oUo8Llbl5OcDfrzzsyLDTy+i6/ZjyaHD8H/CByciGqRcrsDPCKmx9l1x8G
	Qbtl/D2x79iHjlOq9m5NSdTI2YSXzrLqmRHIbez68oY7y+2Bqswcx3zk+8HF6T9ReYEGBc4/h9x
	7m9WniV9hnQKK52oUPYdDJsoknMulMo7tFxsKNZr9MKBggdZzesg==
X-Gm-Gg: ASbGnct6axZp+DLF2beRywnuG87exIONayfIbO7GL1SXUjtVoFyWu5634VfuGpv3dWL
	dgWqWnWSaHeQoRdHLoWFpr84V0TxLgBLxUEmXFTkMALGn9udXtn1EarYvdif/h5SFz6AQUN5Y1m
	oll8DLMR5IAgH5uIlkHrKIWdza3DZ0rw3DNsZwWyquX32wXy29I+/FvIGBz8LI04akXL6sW/gs6
	Fh2GQ+tzu7MocPupb67RHrNwHOhjjKQLicdfZ+Lh6RGMK3iAqVm9gZrDnW6zwuIh4qekqoJx11c
	yD0P/xH1AWJqBkWrK6bmFwz0IuwLi9SZ18d10uzqG5BOueaFJ9S9hOIdQkE4arNge9X/BhzLuQ=
	=
X-Received: by 2002:a05:620a:4546:b0:800:a501:a352 with SMTP id af79cd13be357-800a501a36dmr2440072285a.22.1756980759831;
        Thu, 04 Sep 2025 03:12:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFL1gCgjDR/UJSPyS0pDCnJsbNgq3Th9S3r7HPQW0fM0NwOvfg+53mJUbtTccsFXLpcIYIZXg==
X-Received: by 2002:a05:620a:4546:b0:800:a501:a352 with SMTP id af79cd13be357-800a501a36dmr2440067485a.22.1756980759198;
        Thu, 04 Sep 2025 03:12:39 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-80b105e1ce6sm231267385a.67.2025.09.04.03.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 03:12:38 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH v2 2/2] ceph/inode: drop extra reference from ceph_get_reply_dir() in ceph_fill_trace()
Date: Thu,  4 Sep 2025 10:12:34 +0000
Message-Id: <20250904101234.1258643-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ceph_get_reply_dir() may return a different, referenced inode when r_parent is stale and the parent directory lock is not held.
ceph_fill_trace() used that inode but failed to drop the reference when it differed from req->r_parent, leaking an inode reference.

Keep the directory inode in a local and iput() it at function end if it does not match req->r_parent.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/inode.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 470ee595ecf2..cffa2cd7b530 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1584,6 +1584,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 	struct ceph_vino tvino, dvino;
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
 	struct ceph_client *cl = fsc->client;
+	struct inode *parent_dir = NULL;
 	int err = 0;
 
 	doutc(cl, "%p is_dentry %d is_target %d\n", req,
@@ -1601,9 +1602,13 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		 * r_parent may be stale, in cases when R_PARENT_LOCKED is not set,
 		 * so we need to get the correct inode
 		 */
-		struct inode *dir = ceph_get_reply_dir(sb, req->r_parent, rinfo);
-		if (dir) {
-			err = ceph_fill_inode(dir, NULL, &rinfo->diri,
+		parent_dir = ceph_get_reply_dir(sb, req->r_parent, rinfo);
+		if (unlikely(IS_ERR(parent_dir))) {
+			err = PTR_ERR(parent_dir);
+			goto done;
+		}
+		if (parent_dir) {
+			err = ceph_fill_inode(parent_dir, NULL, &rinfo->diri,
 					      rinfo->dirfrag, session, -1,
 					      &req->r_caps_reservation);
 			if (err < 0)
@@ -1612,14 +1617,14 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			WARN_ON_ONCE(1);
 		}
 
-		if (dir && req->r_op == CEPH_MDS_OP_LOOKUPNAME &&
+		if (parent_dir && req->r_op == CEPH_MDS_OP_LOOKUPNAME &&
 		    test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags) &&
 		    !test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
 			bool is_nokey = false;
 			struct qstr dname;
 			struct dentry *dn, *parent;
 			struct fscrypt_str oname = FSTR_INIT(NULL, 0);
-			struct ceph_fname fname = { .dir	= dir,
+			struct ceph_fname fname = { .dir	= parent_dir,
 						    .name	= rinfo->dname,
 						    .ctext	= rinfo->altname,
 						    .name_len	= rinfo->dname_len,
@@ -1628,10 +1633,10 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			BUG_ON(!rinfo->head->is_target);
 			BUG_ON(req->r_dentry);
 
-			parent = d_find_any_alias(dir);
+			parent = d_find_any_alias(parent_dir);
 			BUG_ON(!parent);
 
-			err = ceph_fname_alloc_buffer(dir, &oname);
+			err = ceph_fname_alloc_buffer(parent_dir, &oname);
 			if (err < 0) {
 				dput(parent);
 				goto done;
@@ -1640,7 +1645,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			err = ceph_fname_to_usr(&fname, NULL, &oname, &is_nokey);
 			if (err < 0) {
 				dput(parent);
-				ceph_fname_free_buffer(dir, &oname);
+				ceph_fname_free_buffer(parent_dir, &oname);
 				goto done;
 			}
 			dname.name = oname.name;
@@ -1659,7 +1664,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				      dname.len, dname.name, dn);
 				if (!dn) {
 					dput(parent);
-					ceph_fname_free_buffer(dir, &oname);
+					ceph_fname_free_buffer(parent_dir, &oname);
 					err = -ENOMEM;
 					goto done;
 				}
@@ -1674,12 +1679,12 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				    ceph_snap(d_inode(dn)) != tvino.snap)) {
 				doutc(cl, " dn %p points to wrong inode %p\n",
 				      dn, d_inode(dn));
-				ceph_dir_clear_ordered(dir);
+				ceph_dir_clear_ordered(parent_dir);
 				d_delete(dn);
 				dput(dn);
 				goto retry_lookup;
 			}
-			ceph_fname_free_buffer(dir, &oname);
+			ceph_fname_free_buffer(parent_dir, &oname);
 
 			req->r_dentry = dn;
 			dput(parent);
@@ -1869,6 +1874,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 					    &dvino, ptvino);
 	}
 done:
+	/* Drop extra ref from ceph_get_reply_dir() if it returned a new inode */
+	if (unlikely(!IS_ERR_OR_NULL(parent_dir) && parent_dir != req->r_parent))
+		iput(parent_dir);
 	doutc(cl, "done err=%d\n", err);
 	return err;
 }
-- 
2.34.1


