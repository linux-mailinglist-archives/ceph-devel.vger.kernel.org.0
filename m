Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A3664A88
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2019 18:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfGJQL7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Jul 2019 12:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbfGJQL6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 12:11:58 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C6652087F;
        Wed, 10 Jul 2019 16:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562775117;
        bh=jWfg5UUR1YlBMGUqJ0giZfmYXURJyddk2dMe2NGB7EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyz/NcsEkQuUa95GOiaHjdh6FR4dLBVmatVVBNNOoLyPZFahw/tc5Y03GDMVp3hUy
         zbEuuLubMBsnVwdQ5FC5NaUFQe/68iZSqdjE73939xt0jX2kG0Qb94qBbgYw2I+0lD
         iSS7AUhUamgbiRZoeZd/Hutv6VIRF2xzp5a8z5Lc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 2/3] ceph: pass unlocked page to ceph_uninline_data
Date:   Wed, 10 Jul 2019 12:11:53 -0400
Message-Id: <20190710161154.26125-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190710161154.26125-1-jlayton@kernel.org>
References: <20190710161154.26125-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The only caller locks the page and then has to unlock it again once it
returns, just have ceph_uninline_data do that itself. Also, in the case
where we are allocating a fresh page for this, lock it to help simplify
the code a bit.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 859d2cbfeccb..5f1e2b6577fb 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1542,14 +1542,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	ceph_block_sigs(&oldset);
 
 	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		struct page *locked_page = NULL;
-		if (off == 0) {
-			lock_page(page);
-			locked_page = page;
-		}
-		err = ceph_uninline_data(inode, locked_page);
-		if (locked_page)
-			unlock_page(locked_page);
+		err = ceph_uninline_data(inode, off == 0 ? page : NULL);
 		if (err < 0)
 			goto out_free;
 	}
@@ -1663,12 +1656,11 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 	}
 }
 
-int ceph_uninline_data(struct inode *inode, struct page *locked_page)
+int ceph_uninline_data(struct inode *inode, struct page *page)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req;
-	struct page *page = NULL;
 	u64 len, inline_version;
 	int err = 0;
 	bool from_pagecache = false;
@@ -1684,8 +1676,8 @@ int ceph_uninline_data(struct inode *inode, struct page *locked_page)
 	    inline_version == CEPH_INLINE_NONE)
 		goto out;
 
-	if (locked_page) {
-		page = locked_page;
+	if (page) {
+		lock_page(page);
 		WARN_ON(!PageUptodate(page));
 	} else if (ceph_caps_issued(ci) &
 		   (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) {
@@ -1711,6 +1703,7 @@ int ceph_uninline_data(struct inode *inode, struct page *locked_page)
 			err = -ENOMEM;
 			goto out;
 		}
+		lock_page(page);
 		err = __ceph_do_getattr(inode, page,
 					CEPH_STAT_CAP_INLINE_DATA, true);
 		if (err < 0) {
@@ -1782,11 +1775,11 @@ int ceph_uninline_data(struct inode *inode, struct page *locked_page)
 	if (err == -ECANCELED)
 		err = 0;
 out:
-	if (page && page != locked_page) {
-		if (from_pagecache) {
-			unlock_page(page);
+	if (page) {
+		unlock_page(page);
+		if (from_pagecache)
 			put_page(page);
-		} else
+		else
 			__free_pages(page, 0);
 	}
 
-- 
2.21.0

