Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E72296AD
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 12:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgGVKzP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 06:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVKzP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 06:55:15 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CDAD207DD;
        Wed, 22 Jul 2020 10:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595415314;
        bh=i39jCRslmtaHtS8qWHs57FWuJ+JtRYV/uegGrpO3XG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSqzPv/5L7PlBvAm777gev0Y1eDTW0BTlDoRn4+3G5AsLyscEGrt53/F9wo+qFseC
         Dm48tJLR7gpgG++KvV5W7ZBwZy0QJTUOtbl717Rg9Hl1oQRa+15ZgXhOlC0o7uSmHP
         EPywPwV9uIiUbLtxtIaI3Qy91zOuCUD6myJw8UCo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     dhowells@redhat.com, dwysocha@redhat.com, smfrench@gmail.com
Subject: [RFC PATCH 02/11] ceph: don't call ceph_update_writeable_page from page_mkwrite
Date:   Wed, 22 Jul 2020 06:55:02 -0400
Message-Id: <20200722105511.11187-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722105511.11187-1-jlayton@kernel.org>
References: <20200722105511.11187-1-jlayton@kernel.org>
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
index 4057725e1864..4f017d552196 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1693,6 +1693,8 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	inode_inc_iversion_raw(inode);
 
 	do {
+		struct ceph_snap_context *snapc;
+
 		lock_page(page);
 
 		if (page_mkwrite_check_truncate(page, inode) < 0) {
@@ -1701,13 +1703,26 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
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

