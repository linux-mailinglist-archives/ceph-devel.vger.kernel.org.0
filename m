Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FA148092D
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Dec 2021 13:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhL1MoW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Dec 2021 07:44:22 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:50238 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231316AbhL1MoV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Dec 2021 07:44:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V06qPtI_1640695459;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0V06qPtI_1640695459)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 20:44:20 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     jlayton@kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        dhowells@redhat.com, linux-cachefs@redhat.com
Subject: [PATCH] netfs: make ops->init_rreq() optional
Date:   Tue, 28 Dec 2021 20:44:19 +0800
Message-Id: <20211228124419.103020-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, recently I'm developing erofs over fscache for implementing
on-demand read, and erofs also implements an empty .init_rreq()
callback[1].

[1] https://lkml.org/lkml/2021/12/27/224

If folks don't like this cleanup and prefer empty callback in upper fs,
I'm also fine with that.
---
There's already upper fs implementing empty .init_rreq() callback, and
thus make it optional.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/ceph/addr.c         | 5 -----
 fs/netfs/read_helper.c | 3 ++-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e53c8541f5b2..c3537dfd8c04 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -291,10 +291,6 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 	dout("%s: result %d\n", __func__, err);
 }
 
-static void ceph_init_rreq(struct netfs_read_request *rreq, struct file *file)
-{
-}
-
 static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
 {
 	struct inode *inode = mapping->host;
@@ -306,7 +302,6 @@ static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
 }
 
 static const struct netfs_read_request_ops ceph_netfs_read_ops = {
-	.init_rreq		= ceph_init_rreq,
 	.is_cache_enabled	= ceph_is_cache_enabled,
 	.begin_cache_operation	= ceph_begin_cache_operation,
 	.issue_op		= ceph_netfs_issue_op,
diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
index 75c76cbb27cc..0befb0747c59 100644
--- a/fs/netfs/read_helper.c
+++ b/fs/netfs/read_helper.c
@@ -55,7 +55,8 @@ static struct netfs_read_request *netfs_alloc_read_request(
 		INIT_WORK(&rreq->work, netfs_rreq_work);
 		refcount_set(&rreq->usage, 1);
 		__set_bit(NETFS_RREQ_IN_PROGRESS, &rreq->flags);
-		ops->init_rreq(rreq, file);
+		if (ops->init_rreq)
+			ops->init_rreq(rreq, file);
 		netfs_stat(&netfs_n_rh_rreq);
 	}
 
-- 
2.27.0

