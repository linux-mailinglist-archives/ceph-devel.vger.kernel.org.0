Return-Path: <ceph-devel+bounces-4162-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E54CAA273
	for <lists+ceph-devel@lfdr.de>; Sat, 06 Dec 2025 08:30:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 56BA0300BEEB
	for <lists+ceph-devel@lfdr.de>; Sat,  6 Dec 2025 07:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F7D2E11B9;
	Sat,  6 Dec 2025 07:29:59 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F266B2C190;
	Sat,  6 Dec 2025 07:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765006199; cv=none; b=ZmWGeaCKpMZhB/XJka/QpMUezhlpqjDNV04t7nvW1UXqpfSAP8OuThm0ZRb1OJ1ou067koXzr2H4CxHi1BrRyAJGigGwjyz5whvXuPBzuVDDkk6jcvKzVsEH5dOHk/T8MJu0EARWaEy0Th/ysANVSFVa/nNc4rjvosTC6eJv5Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765006199; c=relaxed/simple;
	bh=iEsOxqZZ0vylBc7fZxR78Apotq4Ly36rUrnGH0bctCU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=riYY9cp1Myx9+l/hCXzYmAxoNJw1yOK+30uYd2Oc8wOZX8dja2aP1HyGo+HTLEB9ekiNmEnMVwvji8pM4Miz7RAOs9BTMTIMQVu7d04TftxJWQ2dCCnMAJ/6TvZ1tegK+nnOcetqqWzcqeaCEN3ka60o1sfPJoRRS1IXjxI6sy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn; spf=pass smtp.mailfrom=isrc.iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isrc.iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.223])
	by APP-01 (Coremail) with SMTP id qwCowABH2chu2zNppmtBAw--.5833S2;
	Sat, 06 Dec 2025 15:29:50 +0800 (CST)
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	zyan@redhat.com
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] ceph: Drop the string reference in __ceph_pool_perm_get()
Date: Sat,  6 Dec 2025 15:29:48 +0800
Message-Id: <20251206072948.194501-1-lihaoxiang@isrc.iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABH2chu2zNppmtBAw--.5833S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ur48JrWfuFW8urWDJr1kZrb_yoW8Kr1fpF
	yj939rXr48uF97Wr4IqF1q9asrC3W8urWj9ry8JF1rur1Fqr9aqF1a934Y9F1IyFyxWa95
	tF1UAw4DZF1jgFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWUJVWUGwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
	6r4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
	4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 5olkt0x0ld0ww6lv2u4olvutnvoduhdfq/1tbiBwsIE2kzkMN3qAAAsB

After calling ceph_get_string(), ceph_put_string() is required
to drop the reference in error paths.

Fixes: 779fe0fb8e18 ("ceph: rados pool namespace support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
---
 fs/ceph/addr.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 322ed268f14a..690a54b4c316 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2440,13 +2440,13 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 
 	err = ceph_osdc_alloc_messages(rd_req, GFP_NOFS);
 	if (err)
-		goto out_unlock;
+		goto put_string;
 
 	wr_req = ceph_osdc_alloc_request(&fsc->client->osdc, NULL,
 					 1, false, GFP_NOFS);
 	if (!wr_req) {
 		err = -ENOMEM;
-		goto out_unlock;
+		goto put_string;
 	}
 
 	wr_req->r_flags = CEPH_OSD_FLAG_WRITE;
@@ -2456,13 +2456,13 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 
 	err = ceph_osdc_alloc_messages(wr_req, GFP_NOFS);
 	if (err)
-		goto out_unlock;
+		goto put_string;
 
 	/* one page should be large enough for STAT data */
 	pages = ceph_alloc_page_vector(1, GFP_KERNEL);
 	if (IS_ERR(pages)) {
 		err = PTR_ERR(pages);
-		goto out_unlock;
+		goto put_string;
 	}
 
 	osd_req_op_raw_data_in_pages(rd_req, 0, pages, PAGE_SIZE,
@@ -2480,7 +2480,7 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 	else if (err != -EPERM) {
 		if (err == -EBLOCKLISTED)
 			fsc->blocklisted = true;
-		goto out_unlock;
+		goto put_string;
 	}
 
 	if (err2 == 0 || err2 == -EEXIST)
@@ -2489,14 +2489,14 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 		if (err2 == -EBLOCKLISTED)
 			fsc->blocklisted = true;
 		err = err2;
-		goto out_unlock;
+		goto put_string;
 	}
 
 	pool_ns_len = pool_ns ? pool_ns->len : 0;
 	perm = kmalloc(struct_size(perm, pool_ns, pool_ns_len + 1), GFP_NOFS);
 	if (!perm) {
 		err = -ENOMEM;
-		goto out_unlock;
+		goto put_string;
 	}
 
 	perm->pool = pool;
@@ -2509,6 +2509,8 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 	rb_link_node(&perm->node, parent, p);
 	rb_insert_color(&perm->node, &mdsc->pool_perm_tree);
 	err = 0;
+put_string:
+	ceph_put_string(rd_req->r_base_oloc.pool_ns);
 out_unlock:
 	up_write(&mdsc->pool_perm_rwsem);
 
-- 
2.25.1


