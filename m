Return-Path: <ceph-devel+bounces-1889-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 940A1991BB4
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 03:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCBF71C20DCD
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 01:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DEBEEA6;
	Sun,  6 Oct 2024 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="EsAMmP2k"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE14C8F0;
	Sun,  6 Oct 2024 01:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728177603; cv=none; b=mwLgEWBaIK6lylOBC2wGkdrEXIWXbu5GRKVQR95pIXeRP52oYw8p6WuYlFcK3y5FUz1Sv6pyPyIGj1ki1hx/0Wm5a6BeZPgB8qRGwuMyV/2AbYGj9dMTZLYdwZacS7gWrblXTy2ewDMaSauDbnweFELbPdWnNyLeTIpGqAEkD4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728177603; c=relaxed/simple;
	bh=RA2MmJUyp2GKIXW/5gN301QTenv/laiJqdSQKhEsMxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bx6QhAxGNczC2lwrEBc9KKWPzEWezrbd2q/510uVdu1YMgccf1tv1oorqKIjtEV1iwSsCZFkSwwdpR8dWFqbsN2r8ryyIzIFJxQu6ZvR5D5AyZfdUJA1SkPslJhxTZl4ya6/PfgCIYRgTBeZMtg54e+OPC7ATbN8zNjYjnhdxbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=EsAMmP2k; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=0ipru9QdHkE8npmswXi0jMUY0FyIseud22YPF1wL9+Q=; b=EsAMmP2ksiuTCVa5
	vuYk06A24uxkyOR8glOnGEyTMX37IolYo+F06q4+fCPrHL/e9TOFlc2HfKEXllIghy1wBKkQxjFhu
	T2CI3baRwdkM5oyaAGLygnYF1xwYnS37hyQ523iVsnURo5jFzuCkAsKJqKbw6HoGugNSDsVgSgN9f
	FDKATbVCTgrtRv+COCokbrPTMkqjHlbgFZ4exIrAhmHDwEPx1i0p538ofngILKHWvS5pLdqMGYMEf
	sd6aMD1w/YKAY21/Wo+vVYiX/E1lnsgzdSCY+JlxdB8akPfEXwAaP9LtRbeZMUDrj9NIshlu1KzcB
	1BDO+2znaD95g2g5Kw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sxFwE-009DsK-2V;
	Sun, 06 Oct 2024 01:19:58 +0000
From: linux@treblig.org
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 2/5] libceph: Remove unused pagevec functions
Date: Sun,  6 Oct 2024 02:19:53 +0100
Message-ID: <20241006011956.373622-3-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241006011956.373622-1-linux@treblig.org>
References: <20241006011956.373622-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

ceph_copy_user_to_page_vector() has been unused since 2013's commit
e8344e668915 ("ceph: Implement writev/pwritev for sync operation.")

ceph_copy_to_page_vector() has been unused since 2012's commit
913d2fdcf605 ("rbd: always pass ops array to rbd_req_sync_op()")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 include/linux/ceph/libceph.h |  6 -----
 net/ceph/pagevec.c           | 52 ------------------------------------
 2 files changed, 58 deletions(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 15fb566d3f46..733e7f93db66 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -317,12 +317,6 @@ extern void ceph_release_page_vector(struct page **pages, int num_pages);
 extern void ceph_put_page_vector(struct page **pages, int num_pages,
 				 bool dirty);
 extern struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags);
-extern int ceph_copy_user_to_page_vector(struct page **pages,
-					 const void __user *data,
-					 loff_t off, size_t len);
-extern void ceph_copy_to_page_vector(struct page **pages,
-				    const void *data,
-				    loff_t off, size_t len);
 extern void ceph_copy_from_page_vector(struct page **pages,
 				    void *data,
 				    loff_t off, size_t len);
diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
index 64305e7056a1..4509757d8b3b 100644
--- a/net/ceph/pagevec.c
+++ b/net/ceph/pagevec.c
@@ -55,58 +55,6 @@ struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags)
 }
 EXPORT_SYMBOL(ceph_alloc_page_vector);
 
-/*
- * copy user data into a page vector
- */
-int ceph_copy_user_to_page_vector(struct page **pages,
-					 const void __user *data,
-					 loff_t off, size_t len)
-{
-	int i = 0;
-	int po = off & ~PAGE_MASK;
-	int left = len;
-	int l, bad;
-
-	while (left > 0) {
-		l = min_t(int, PAGE_SIZE-po, left);
-		bad = copy_from_user(page_address(pages[i]) + po, data, l);
-		if (bad == l)
-			return -EFAULT;
-		data += l - bad;
-		left -= l - bad;
-		po += l - bad;
-		if (po == PAGE_SIZE) {
-			po = 0;
-			i++;
-		}
-	}
-	return len;
-}
-EXPORT_SYMBOL(ceph_copy_user_to_page_vector);
-
-void ceph_copy_to_page_vector(struct page **pages,
-				    const void *data,
-				    loff_t off, size_t len)
-{
-	int i = 0;
-	size_t po = off & ~PAGE_MASK;
-	size_t left = len;
-
-	while (left > 0) {
-		size_t l = min_t(size_t, PAGE_SIZE-po, left);
-
-		memcpy(page_address(pages[i]) + po, data, l);
-		data += l;
-		left -= l;
-		po += l;
-		if (po == PAGE_SIZE) {
-			po = 0;
-			i++;
-		}
-	}
-}
-EXPORT_SYMBOL(ceph_copy_to_page_vector);
-
 void ceph_copy_from_page_vector(struct page **pages,
 				    void *data,
 				    loff_t off, size_t len)
-- 
2.46.2


