Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A87E64A85
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2019 18:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfGJQL6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Jul 2019 12:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbfGJQL5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 12:11:57 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51450208C4;
        Wed, 10 Jul 2019 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562775116;
        bh=NxMorCKMI66h7O/EGG7WFx8a5m3Y0Mm0Xgtel/Mxxto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nx6jdNkDfO6sCInGQy5C3EAIJEdIGm9qoAkMXq5tOKyyy+07uJfXH2UtYMvGq94+V
         n9o7cqdhnUbJ8dPR9HaLLyq3BRlIsefoGiSlAjqhpOyD0PYmHJe5YTSKssQzsaIAEY
         De9I626MJDdzU+PRdHO+9o0ST5L6xJGhKbw1wXZo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 1/3] ceph: make ceph_uninline_data take inode pointer
Date:   Wed, 10 Jul 2019 12:11:52 -0400
Message-Id: <20190710161154.26125-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190710161154.26125-1-jlayton@kernel.org>
References: <20190710161154.26125-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It only uses the filp to get to the inode, and most of the callers
have a pointer to the inode already.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c  | 5 ++---
 fs/ceph/file.c  | 4 ++--
 fs/ceph/super.h | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e078cc55b989..859d2cbfeccb 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1547,7 +1547,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 			lock_page(page);
 			locked_page = page;
 		}
-		err = ceph_uninline_data(vma->vm_file, locked_page);
+		err = ceph_uninline_data(inode, locked_page);
 		if (locked_page)
 			unlock_page(locked_page);
 		if (err < 0)
@@ -1663,9 +1663,8 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 	}
 }
 
-int ceph_uninline_data(struct file *filp, struct page *locked_page)
+int ceph_uninline_data(struct inode *inode, struct page *locked_page)
 {
-	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 82af4a3c714d..7bb090fa99d3 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1439,7 +1439,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	inode_inc_iversion_raw(inode);
 
 	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		err = ceph_uninline_data(file, NULL);
+		err = ceph_uninline_data(inode, NULL);
 		if (err < 0)
 			goto out;
 	}
@@ -1763,7 +1763,7 @@ static long ceph_fallocate(struct file *file, int mode,
 	}
 
 	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		ret = ceph_uninline_data(file, NULL);
+		ret = ceph_uninline_data(inode, NULL);
 		if (ret < 0)
 			goto unlock;
 	}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 4196f30e5bdc..dd2a242d5d22 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1070,7 +1070,7 @@ extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode);
 /* addr.c */
 extern const struct address_space_operations ceph_aops;
 extern int ceph_mmap(struct file *file, struct vm_area_struct *vma);
-extern int ceph_uninline_data(struct file *filp, struct page *locked_page);
+extern int ceph_uninline_data(struct inode *inode, struct page *locked_page);
 extern int ceph_pool_perm_check(struct ceph_inode_info *ci, int need);
 extern void ceph_pool_perm_destroy(struct ceph_mds_client* mdsc);
 
-- 
2.21.0

