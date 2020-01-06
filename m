Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F32F1314E7
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jan 2020 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgAFPf1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jan 2020 10:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgAFPfZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:35:25 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB3FB21744;
        Mon,  6 Jan 2020 15:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578324925;
        bh=WJMpoy9SNYIFfSbGHrNAuRMdKmj0v2MioKGSP4yhOzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PA54sBbd2jlG0edBqCQNvO7KtcHMD21q4uY3abmvRfajgfI4VvvzbzvfmnS4B3Zxp
         UM24qesH3wwA6A180dCS+SMsXpMULQbT+TlICUxh+r3mlbOjJ2LdCHmLg+G+awtUwp
         QYfUtcnvrDY2curpu32XMb0zKVUYnSTL8kM/SDJg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 4/6] ceph: add refcounting for Fx caps
Date:   Mon,  6 Jan 2020 10:35:18 -0500
Message-Id: <20200106153520.307523-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106153520.307523-1-jlayton@kernel.org>
References: <20200106153520.307523-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In future patches we'll be taking and relying on Fx caps. Add proper
refcounting for them.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 7 +++++++
 fs/ceph/inode.c | 1 +
 fs/ceph/super.h | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 28ae0c134700..1a17f19fd8ad 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -965,6 +965,8 @@ int __ceph_caps_used(struct ceph_inode_info *ci)
 		used |= CEPH_CAP_FILE_WR;
 	if (ci->i_wb_ref || ci->i_wrbuffer_ref)
 		used |= CEPH_CAP_FILE_BUFFER;
+	if (ci->i_fx_ref)
+		used |= CEPH_CAP_FILE_EXCL;
 	return used;
 }
 
@@ -2500,6 +2502,8 @@ static void __take_cap_refs(struct ceph_inode_info *ci, int got,
 		ci->i_rd_ref++;
 	if (got & CEPH_CAP_FILE_CACHE)
 		ci->i_rdcache_ref++;
+	if (got & CEPH_CAP_FILE_EXCL)
+		ci->i_fx_ref++;
 	if (got & CEPH_CAP_FILE_WR) {
 		if (ci->i_wr_ref == 0 && !ci->i_head_snapc) {
 			BUG_ON(!snap_rwsem_locked);
@@ -2911,6 +2915,9 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 	if (had & CEPH_CAP_FILE_CACHE)
 		if (--ci->i_rdcache_ref == 0)
 			last++;
+	if (had & CEPH_CAP_FILE_EXCL)
+		if (--ci->i_fx_ref == 0)
+			last++;
 	if (had & CEPH_CAP_FILE_BUFFER) {
 		if (--ci->i_wb_ref == 0) {
 			last++;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 64634c5af403..ef9e8281d485 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -496,6 +496,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	ci->i_rdcache_ref = 0;
 	ci->i_wr_ref = 0;
 	ci->i_wb_ref = 0;
+	ci->i_fx_ref = 0;
 	ci->i_wrbuffer_ref = 0;
 	ci->i_wrbuffer_ref_head = 0;
 	atomic_set(&ci->i_filelock_ref, 0);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 3bf1a01cd536..5934261f37e4 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -373,7 +373,7 @@ struct ceph_inode_info {
 
 	/* held references to caps */
 	int i_pin_ref;
-	int i_rd_ref, i_rdcache_ref, i_wr_ref, i_wb_ref;
+	int i_rd_ref, i_rdcache_ref, i_wr_ref, i_wb_ref, i_fx_ref;
 	int i_wrbuffer_ref, i_wrbuffer_ref_head;
 	atomic_t i_filelock_ref;
 	atomic_t i_shared_gen;       /* increment each time we get FILE_SHARED */
-- 
2.24.1

