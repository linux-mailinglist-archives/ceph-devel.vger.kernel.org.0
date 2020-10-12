Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28A828BBA5
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Oct 2020 17:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389778AbgJLPQt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Oct 2020 11:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389580AbgJLPQt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 11:16:49 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0065520878
        for <ceph-devel@vger.kernel.org>; Mon, 12 Oct 2020 15:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602515808;
        bh=VRzsmcSA4KOknbE3WYJYcw0zHkJCJjzdMLaQmQv+AUA=;
        h=From:To:Subject:Date:From;
        b=z44TAG8ufZeVL4XanPWFLkqnv7UoINOkCYq5tdeyOzsbUYx6TpxZKGHneHwLScuBU
         EtBQ8+yb2R77kl/FBosErKemZFSarJE5kwgzMdflGZDHrVkG41mpQSkGkVip+QhPV/
         ADwZD3uhwi6dFE0C9ikt73+D/sqbf+jw/AZ5Lxx8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: add a queue_inode_work helper
Date:   Mon, 12 Oct 2020 11:16:46 -0400
Message-Id: <20201012151646.310836-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, this is open-coded everywhere. Add a wrapper around
queue_work that takes an inode pointer.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 02b11a4a4d39..7c22bc2ea076 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1801,6 +1801,13 @@ bool ceph_inode_set_size(struct inode *inode, loff_t size)
 	return ret;
 }
 
+static bool queue_inode_work(struct inode *inode)
+{
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+
+	return queue_work(fsc->inode_wq, &ceph_inode(inode)->i_work);
+}
+
 /*
  * Put reference to inode, but avoid calling iput_final() in current thread.
  * iput_final() may wait for reahahead pages. The wait can cause deadlock in
@@ -1813,8 +1820,7 @@ void ceph_async_iput(struct inode *inode)
 	for (;;) {
 		if (atomic_add_unless(&inode->i_count, -1, 1))
 			break;
-		if (queue_work(ceph_inode_to_client(inode)->inode_wq,
-			       &ceph_inode(inode)->i_work))
+		if (queue_inode_work(inode))
 			break;
 		/* queue work failed, i_count must be at least 2 */
 	}
@@ -1830,8 +1836,7 @@ void ceph_queue_writeback(struct inode *inode)
 	set_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask);
 
 	ihold(inode);
-	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
-		       &ci->i_work)) {
+	if (queue_inode_work(inode)) {
 		dout("ceph_queue_writeback %p\n", inode);
 	} else {
 		dout("ceph_queue_writeback %p already queued, mask=%lx\n",
@@ -1849,8 +1854,7 @@ void ceph_queue_invalidate(struct inode *inode)
 	set_bit(CEPH_I_WORK_INVALIDATE_PAGES, &ci->i_work_mask);
 
 	ihold(inode);
-	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
-		       &ceph_inode(inode)->i_work)) {
+	if (queue_inode_work(inode)) {
 		dout("ceph_queue_invalidate %p\n", inode);
 	} else {
 		dout("ceph_queue_invalidate %p already queued, mask=%lx\n",
@@ -1869,8 +1873,7 @@ void ceph_queue_vmtruncate(struct inode *inode)
 	set_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask);
 
 	ihold(inode);
-	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
-		       &ci->i_work)) {
+	if (queue_inode_work(inode)) {
 		dout("ceph_queue_vmtruncate %p\n", inode);
 	} else {
 		dout("ceph_queue_vmtruncate %p already queued, mask=%lx\n",
-- 
2.26.2

