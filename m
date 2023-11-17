Return-Path: <ceph-devel+bounces-112-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3867EEBFE
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 06:38:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1D1E1F22DAA
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 05:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59CCD8F68;
	Fri, 17 Nov 2023 05:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZXLvKlNz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CD0130
	for <ceph-devel@vger.kernel.org>; Thu, 16 Nov 2023 21:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700199517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AMJ0kqyguFn4LYPHquB1ZgldvplX6OlcO30wfmR94T8=;
	b=ZXLvKlNzeGb+cfDjsVSNymiCAx5V9yhA35FlLYmjuPzjpxYblmAuJLLbNFhs7vxS8iNENz
	akxM8QhmnpdpfTxa9XAlyhLmGNpP8Cocb9JnkXxZxbTGbvZUsxVOGtNVTj51q25iEzEPhU
	854f3OPq/ny/0jX0nWBKRWfhJGvevpQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-jxrJMeTKPU6EirXralCgRA-1; Fri,
 17 Nov 2023 00:38:35 -0500
X-MC-Unique: jxrJMeTKPU6EirXralCgRA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BD15380671C;
	Fri, 17 Nov 2023 05:38:35 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.63])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3672740C6EB9;
	Fri, 17 Nov 2023 05:38:31 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2] ceph: fix deadlock or deadcode of misusing dget()
Date: Fri, 17 Nov 2023 13:36:27 +0800
Message-ID: <20231117053627.716877-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Xiubo Li <xiubli@redhat.com>

The lock order is incorrect between denty and its parent, we should
always make sure that the parent get the lock first.

But since this deadcode is never used and the parent dir will always
be set from the callers, let's just remove it.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
URL: https://www.spinics.net/lists/ceph-devel/msg58622.html
Cc: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---


V2:
- Just remove the deadcode. Actually this just removed the deadcode,
  not fixing any deadlock issue and I also just removed ccing the
  stable list.


 fs/ceph/caps.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 284424659329..a9e19f1f26e0 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4916,13 +4916,15 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 			       struct inode *dir,
 			       int mds, int drop, int unless)
 {
-	struct dentry *parent = NULL;
 	struct ceph_mds_request_release *rel = *p;
 	struct ceph_dentry_info *di = ceph_dentry(dentry);
 	struct ceph_client *cl;
 	int force = 0;
 	int ret;
 
+	/* This shouldn't happen */
+	BUG_ON(!dir);
+
 	/*
 	 * force an record for the directory caps if we have a dentry lease.
 	 * this is racy (can't take i_ceph_lock and d_lock together), but it
@@ -4932,14 +4934,9 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
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
-- 
2.39.1


