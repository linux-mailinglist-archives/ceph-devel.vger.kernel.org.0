Return-Path: <ceph-devel+bounces-899-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D615862539
	for <lists+ceph-devel@lfdr.de>; Sat, 24 Feb 2024 14:48:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE7231C20F50
	for <lists+ceph-devel@lfdr.de>; Sat, 24 Feb 2024 13:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0D641760;
	Sat, 24 Feb 2024 13:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e7nv61Ye"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45221481AD
	for <ceph-devel@vger.kernel.org>; Sat, 24 Feb 2024 13:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708782451; cv=none; b=WbLoj8yGjdUdfthLdbiljewxR8DlL4GXqsBfanweRE9xPy6IwcoAqHSrweVh1xzp+2m9pkhh5cbiCzehi7R7kpP1ow7Ixa+ZL+xeo2Y0XFRYRTUtk96ezqmW8yjRZxAp/I16xFmAzBmHxC6rLYe9fczYdQPV6UQ3gw9b0MM0uMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708782451; c=relaxed/simple;
	bh=rd7aE2Bs7zSZDXtE9k0rqYhIb0LEAOqGjjkepCRrSVw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UKQ8UkF+uISdiVuy8tuOworIEt6kHqKliU7eyS8Q8NDY6Jnk+nKlvQV74K92j/EjnheNHtuq6fLKdbbWdvpJGkT2/o1s6RBF46vCa6V+aChBDHpZzDfjLd9kbbq6vJN3svfm+msgPK0Umhl+UMzSoARdUP2wACK29Pv1EOX4zcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e7nv61Ye; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708782447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ho3UnjUX0G/0cAL94mP3MsaLfyC4THaAsSQamvgM/pw=;
	b=e7nv61Ye0jDbqkUz7jMCTV3eK0UvUuitiYM9KnDygUXl4MT4cjBnK90vNwbPfokCwyo60B
	fW0x+Dog4Xb9oK0TZgcU1Ko8x37ce+15tZ1YSVnA9GNPG6jxCaJg1s4Oyx98p+Sfa1qrSP
	YIUuVEuostxV4Rl4zTBfMEL8npqjMO0=
From: chengming.zhou@linux.dev
To: xiubli@redhat.com,
	idryomov@gmail.com,
	jlayton@kernel.org
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	vbabka@suse.cz,
	roman.gushchin@linux.dev,
	Xiongwei.Song@windriver.com,
	chengming.zhou@linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH] ceph: remove SLAB_MEM_SPREAD flag usage
Date: Sat, 24 Feb 2024 13:47:15 +0000
Message-Id: <20240224134715.829225-1-chengming.zhou@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Chengming Zhou <zhouchengming@bytedance.com>

The SLAB_MEM_SPREAD flag is already a no-op as of 6.8-rc1, remove
its usage so we can delete it from slab. No functional change.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 fs/ceph/super.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 5ec102f6b1ac..4dcbbaa297f6 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -928,36 +928,36 @@ static int __init init_caches(void)
 	ceph_inode_cachep = kmem_cache_create("ceph_inode_info",
 				      sizeof(struct ceph_inode_info),
 				      __alignof__(struct ceph_inode_info),
-				      SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
-				      SLAB_ACCOUNT, ceph_inode_init_once);
+				      SLAB_RECLAIM_ACCOUNT|SLAB_ACCOUNT,
+				      ceph_inode_init_once);
 	if (!ceph_inode_cachep)
 		return -ENOMEM;
 
-	ceph_cap_cachep = KMEM_CACHE(ceph_cap, SLAB_MEM_SPREAD);
+	ceph_cap_cachep = KMEM_CACHE(ceph_cap, 0);
 	if (!ceph_cap_cachep)
 		goto bad_cap;
-	ceph_cap_snap_cachep = KMEM_CACHE(ceph_cap_snap, SLAB_MEM_SPREAD);
+	ceph_cap_snap_cachep = KMEM_CACHE(ceph_cap_snap, 0);
 	if (!ceph_cap_snap_cachep)
 		goto bad_cap_snap;
 	ceph_cap_flush_cachep = KMEM_CACHE(ceph_cap_flush,
-					   SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+					   SLAB_RECLAIM_ACCOUNT);
 	if (!ceph_cap_flush_cachep)
 		goto bad_cap_flush;
 
 	ceph_dentry_cachep = KMEM_CACHE(ceph_dentry_info,
-					SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+					SLAB_RECLAIM_ACCOUNT);
 	if (!ceph_dentry_cachep)
 		goto bad_dentry;
 
-	ceph_file_cachep = KMEM_CACHE(ceph_file_info, SLAB_MEM_SPREAD);
+	ceph_file_cachep = KMEM_CACHE(ceph_file_info, 0);
 	if (!ceph_file_cachep)
 		goto bad_file;
 
-	ceph_dir_file_cachep = KMEM_CACHE(ceph_dir_file_info, SLAB_MEM_SPREAD);
+	ceph_dir_file_cachep = KMEM_CACHE(ceph_dir_file_info, 0);
 	if (!ceph_dir_file_cachep)
 		goto bad_dir_file;
 
-	ceph_mds_request_cachep = KMEM_CACHE(ceph_mds_request, SLAB_MEM_SPREAD);
+	ceph_mds_request_cachep = KMEM_CACHE(ceph_mds_request, 0);
 	if (!ceph_mds_request_cachep)
 		goto bad_mds_req;
 
-- 
2.40.1


