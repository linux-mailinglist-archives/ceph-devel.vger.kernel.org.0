Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3893626C639
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Sep 2020 19:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgIPRkI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Sep 2020 13:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbgIPRi6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:38:58 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AAE920738;
        Wed, 16 Sep 2020 17:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600277938;
        bh=mCPIaWO4Vn8ZYNreZNFnuzE++GAUWvdp8VCShJCibPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ic8tQC6vkzKLh2T8BPWWSSUMH2nDE3e2yRr5jpSSelLK4bXMCqFMSr6ddolbHaYF+
         DD5s3Bm4gI3S/G0wBXcu8mzaWv2wYW305zjlzbq0vGuC59bKUfhd+xvdLIG5IiJQ1Z
         NfNPQSJaZfI3GB0QR4XHb9DrPKAGcilyPYIYM4TE=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com
Subject: [PATCH 2/5] ceph: don't call ceph_update_writeable_page from page_mkwrite
Date:   Wed, 16 Sep 2020 13:38:51 -0400
Message-Id: <20200916173854.330265-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916173854.330265-1-jlayton@kernel.org>
References: <20200916173854.330265-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

page_mkwrite should only be called with Uptodate pages, so we should
only need to flush incompatible snap contexts.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c8e98fee8164..02e286c30d44 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1691,6 +1691,8 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	inode_inc_iversion_raw(inode);
 
 	do {
+		struct ceph_snap_context *snapc;
+
 		lock_page(page);
 
 		if (page_mkwrite_check_truncate(page, inode) < 0) {
@@ -1699,13 +1701,26 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 			break;
 		}
 
-		err = ceph_update_writeable_page(vma->vm_file, off, len, page);
-		if (err >= 0) {
+		snapc = ceph_find_incompatible(inode, page);
+		if (!snapc) {
 			/* success.  we'll keep the page locked. */
 			set_page_dirty(page);
 			ret = VM_FAULT_LOCKED;
+			break;
 		}
-	} while (err == -EAGAIN);
+
+		unlock_page(page);
+
+		if (IS_ERR(snapc)) {
+			ret = VM_FAULT_SIGBUS;
+			break;
+		}
+
+		ceph_queue_writeback(inode);
+		err = wait_event_killable(ci->i_cap_wq,
+				context_is_writeable_or_written(inode, snapc));
+		ceph_put_snap_context(snapc);
+	} while (err == 0);
 
 	if (ret == VM_FAULT_LOCKED ||
 	    ci->i_inline_version != CEPH_INLINE_NONE) {
-- 
2.26.2

