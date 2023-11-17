Return-Path: <ceph-devel+bounces-109-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D430D7EEB63
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 04:22:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F934281154
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 03:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0315683;
	Fri, 17 Nov 2023 03:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H3c+wAVc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1DFB9
	for <ceph-devel@vger.kernel.org>; Thu, 16 Nov 2023 19:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700191333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OZkIo3gmOmARkH9D6G/diT0yhlLPEb/bpyU7MwfHSdo=;
	b=H3c+wAVc4M9HbQhr2TOH/Zx7OEI81FWNDlwKqDlRz5cC+CWUJGrYrG6fXDMhySreJbOem/
	w6owFGmDsr/4AnPcNeGpGgyggQF4zFzepSfJYjoUJj7xabiGmaqhqph0Pia2BlB66FckX6
	FvjQnUmE74VQnLqsFj1PUsgmktnSzqY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-7y-W_D6aNAqEyR9gY0rPQA-1; Thu,
 16 Nov 2023 22:22:09 -0500
X-MC-Unique: 7y-W_D6aNAqEyR9gY0rPQA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 132F61C060E4;
	Fri, 17 Nov 2023 03:22:09 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.63])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A60421C060AE;
	Fri, 17 Nov 2023 03:22:05 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	stable@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] ceph: fix deadlock or deadcode of misusing dget()
Date: Fri, 17 Nov 2023 11:19:51 +0800
Message-ID: <20231117031951.710177-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Xiubo Li <xiubli@redhat.com>

The lock order is incorrect between denty and its parent, we should
always make sure that the parent get the lock first.

Switch to use the 'dget_parent()' to get the parent dentry and also
keep holding the parent until the corresponding inode is not being
refereenced.

Cc: stable@vger.kernel.org
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
URL: https://www.spinics.net/lists/ceph-devel/msg58622.html
Fixes: adf0d68701c7 ("ceph: fix unsafe dcache access in ceph_encode_dentry_release")
Cc: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 284424659329..6f7a56a800c2 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4923,6 +4923,11 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	int force = 0;
 	int ret;
 
+	if (!dir) {
+		parent = dget_parent(dentry);
+		dir = d_inode(parent);
+	}
+
 	/*
 	 * force an record for the directory caps if we have a dentry lease.
 	 * this is racy (can't take i_ceph_lock and d_lock together), but it
@@ -4932,14 +4937,9 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	spin_lock(&dentry->d_lock);
 	if (di->lease_session && di->lease_session->s_mds == mds)
 		force = 1;
-	if (!dir) {
-		parent = dget(dentry->d_parent);
-		dir = d_inode(parent);
-	}
 	spin_unlock(&dentry->d_lock);
 
 	ret = ceph_encode_inode_release(p, dir, mds, drop, unless, force);
-	dput(parent);
 
 	cl = ceph_inode_to_client(dir);
 	spin_lock(&dentry->d_lock);
@@ -4952,8 +4952,10 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 		if (IS_ENCRYPTED(dir) && fscrypt_has_encryption_key(dir)) {
 			int ret2 = ceph_encode_encrypted_fname(dir, dentry, *p);
 
-			if (ret2 < 0)
+			if (ret2 < 0) {
+				dput(parent);
 				return ret2;
+			}
 
 			rel->dname_len = cpu_to_le32(ret2);
 			*p += ret2;
@@ -4965,6 +4967,8 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	} else {
 		spin_unlock(&dentry->d_lock);
 	}
+
+	dput(parent);
 	return ret;
 }
 
-- 
2.39.1


