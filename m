Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779634B1CF7
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Feb 2022 04:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbiBKDd3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Feb 2022 22:33:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiBKDd2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Feb 2022 22:33:28 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D5D55AF
        for <ceph-devel@vger.kernel.org>; Thu, 10 Feb 2022 19:33:27 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=hongnan.li@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V46vPkn_1644550405;
Received: from localhost(mailfrom:hongnan.li@linux.alibaba.com fp:SMTPD_---0V46vPkn_1644550405)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Feb 2022 11:33:25 +0800
From:   Hongnan Li <hongnan.li@linux.alibaba.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com
Subject: [PATCH] fs/ceph: fix comments mentioning i_mutex
Date:   Fri, 11 Feb 2022 11:33:25 +0800
Message-Id: <20220211033325.126209-1-hongnan.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: hongnanli <hongnan.li@linux.alibaba.com>

inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
comments still mentioning i_mutex.

Signed-off-by: hongnanli <hongnan.li@linux.alibaba.com>
---
 fs/ceph/dir.c   | 6 +++---
 fs/ceph/inode.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 133dbd9338e7..0cf6afe283e9 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -145,7 +145,7 @@ __dcache_find_get_entry(struct dentry *parent, u64 idx,
 			return ERR_PTR(-EAGAIN);
 		}
 		/* reading/filling the cache are serialized by
-		   i_mutex, no need to use page lock */
+		   i_rwsem, no need to use page lock */
 		unlock_page(cache_ctl->page);
 		cache_ctl->dentries = kmap(cache_ctl->page);
 	}
@@ -155,7 +155,7 @@ __dcache_find_get_entry(struct dentry *parent, u64 idx,
 	rcu_read_lock();
 	spin_lock(&parent->d_lock);
 	/* check i_size again here, because empty directory can be
-	 * marked as complete while not holding the i_mutex. */
+	 * marked as complete while not holding the i_rwsem. */
 	if (ceph_dir_is_complete_ordered(dir) && ptr_pos < i_size_read(dir))
 		dentry = cache_ctl->dentries[cache_ctl->index];
 	else
@@ -671,7 +671,7 @@ struct dentry *ceph_handle_snapdir(struct ceph_mds_request *req,
 				   struct dentry *dentry)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
-	struct inode *parent = d_inode(dentry->d_parent); /* we hold i_mutex */
+	struct inode *parent = d_inode(dentry->d_parent); /* we hold i_rwsem */
 
 	/* .snap dir? */
 	if (ceph_snap(parent) == CEPH_NOSNAP &&
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index ef4a980a7bf3..22adddb3d051 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1201,7 +1201,7 @@ static void update_dentry_lease_careful(struct dentry *dentry,
 
 /*
  * splice a dentry to an inode.
- * caller must hold directory i_mutex for this to be safe.
+ * caller must hold directory i_rwsem for this to be safe.
  */
 static int splice_dentry(struct dentry **pdn, struct inode *in)
 {
@@ -1598,7 +1598,7 @@ static int fill_readdir_cache(struct inode *dir, struct dentry *dn,
 			return idx == 0 ? -ENOMEM : 0;
 		}
 		/* reading/filling the cache are serialized by
-		 * i_mutex, no need to use page lock */
+		 * i_rwsem, no need to use page lock */
 		unlock_page(ctl->page);
 		ctl->dentries = kmap(ctl->page);
 		if (idx == 0)
-- 
2.19.1.6.gb485710b

