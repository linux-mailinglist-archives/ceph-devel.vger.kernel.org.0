Return-Path: <ceph-devel+bounces-1517-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7419692E058
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 08:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 107D71F21C57
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 06:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C94A12DD9B;
	Thu, 11 Jul 2024 06:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="EAbEAnJY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179A984E1E
	for <ceph-devel@vger.kernel.org>; Thu, 11 Jul 2024 06:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720680911; cv=none; b=DVZena/OG0gt1LV4cVmIoT/tQR2lopZHmhsVPc64SgPEVQOnjao39ztoE/w6ttm22Us/duCP5R58aZqoKfu+2O6B+y//ydzwOOfBUfFCEJbU54OgtjBabqVwsY4zPgNUtZO1/gIa+RHYh+3AEpfiNyBnYnqIwT1xBxfJFPpqMVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720680911; c=relaxed/simple;
	bh=t38FMgqBXhFFhdswdoxPVFKYY/yhCvbYJetUzNO/WUc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lQL59Lrb5UhQ0dmIBb0us2+eO0MZDMmEw45gBIeSLWe9W88n4mJB/zonGo+h3of+jTGnuGjVice1QZdhqCw4V9qFyl2lwVtz8TZ9xR/FXRaJNE6lNwyytQH5tvWKBtIpuyZKdWzz7rH4GIuvhKTzGsNHj0O/1wve6vAUoAlIEpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=EAbEAnJY; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
From: ethanwu <ethanwu@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1720680477; bh=t38FMgqBXhFFhdswdoxPVFKYY/yhCvbYJetUzNO/WUc=;
	h=From:To:Cc:Subject:Date;
	b=EAbEAnJYsxsIdYACrQyPA+a/bo8NCYbnNWfGci4z6XW8ajRvTdm6qmnvIX12jVUjG
	 W0Z6pw9hYpZ/rPaK+Mo4AO1BeMnEI9WNtOZUbkg4Q2+qEG3EylYTTzmnFC82eEa4NE
	 OjyzwfVVJ3Br04sTW3b7XO2IXSwKnpC1xJD+qkzs=
To: ceph-devel@vger.kernel.org
Cc: ethanwu <ethanwu@synology.com>
Subject: [PATCH] ceph: fix incorrect kmalloc size of pagevec mempool
Date: Thu, 11 Jul 2024 14:47:56 +0800
Message-Id: <20240711064756.334775-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no

The kmalloc size of pagevec mempool is incorrectly calculated.
It misses the size of page pointer and only accounts the number for the array.

Fixes: a0102bda5bc0 ("ceph: move sb->wb_pagevec_pool to be a global mempool")
Signed-off-by: ethanwu <ethanwu@synology.com>
---
 fs/ceph/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 885cb5d4e771..46f640514561 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -961,7 +961,8 @@ static int __init init_caches(void)
 	if (!ceph_mds_request_cachep)
 		goto bad_mds_req;
 
-	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10, CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT);
+	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10,
+				(CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT) * sizeof(struct page *));
 	if (!ceph_wb_pagevec_pool)
 		goto bad_pagevec_pool;
 
-- 
2.25.1


