Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E62C38F3F
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfFGPi3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730004AbfFGPi1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:27 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2213214D8;
        Fri,  7 Jun 2019 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921906;
        bh=ukvZOFBme/qIHovi9X3Jl7zerR/PlDcu/MDvhuNEnhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYhXe0noRAYlQsSHZ9DG3blGCKQNkM8B7zYyrrlDqQB0gubJl191gjM0diblb2lqF
         JdpxDQ83LJJkkMv6yMctXKppKIh29P5Rb0UVzNfwICLSe4Y4BUc3lb9X4L2JOU3tXr
         m4UcMDjk+MRy9EtCo071GuICRsFqFM7I302Vjs/k=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 09/16] ceph: add btime field to ceph_inode_info
Date:   Fri,  7 Jun 2019 11:38:09 -0400
Message-Id: <20190607153816.12918-10-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153816.12918-1-jlayton@kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c      |  2 ++
 fs/ceph/mds_client.c | 21 +++++++++++++--------
 fs/ceph/mds_client.h |  1 +
 fs/ceph/super.h      |  1 +
 4 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 6003187dd39e..211947e3c737 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -509,6 +509,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	INIT_WORK(&ci->i_work, ceph_inode_work);
 	ci->i_work_mask = 0;
+	memset(&ci->i_btime, '\0', sizeof(ci->i_btime));
 
 	ceph_fscache_inode_init(ci);
 
@@ -822,6 +823,7 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 		dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
 		     from_kuid(&init_user_ns, inode->i_uid),
 		     from_kgid(&init_user_ns, inode->i_gid));
+		ceph_decode_timespec64(&ci->i_btime, &iinfo->btime);
 		ceph_decode_timespec64(&ci->i_snap_btime, &iinfo->snap_btime);
 	}
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f5c3499fdec6..7bc0a6f4bb2e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -150,14 +150,13 @@ static int parse_reply_info_in(void **p, void *end,
 			info->pool_ns_data = *p;
 			*p += info->pool_ns_len;
 		}
-		/* btime, change_attr */
-		{
-			struct ceph_timespec btime;
-			u64 change_attr;
-			ceph_decode_need(p, end, sizeof(btime), bad);
-			ceph_decode_copy(p, &btime, sizeof(btime));
-			ceph_decode_64_safe(p, end, change_attr, bad);
-		}
+
+		/* btime */
+		ceph_decode_need(p, end, sizeof(info->btime), bad);
+		ceph_decode_copy(p, &info->btime, sizeof(info->btime));
+
+		/* change attribute */
+		ceph_decode_skip_64(p, end, bad);
 
 		/* dir pin */
 		if (struct_v >= 2) {
@@ -206,6 +205,12 @@ static int parse_reply_info_in(void **p, void *end,
 			}
 		}
 
+		if (features & CEPH_FEATURE_FS_BTIME) {
+			ceph_decode_need(p, end, sizeof(info->btime), bad);
+			ceph_decode_copy(p, &info->btime, sizeof(info->btime));
+			ceph_decode_skip_64(p, end, bad);
+		}
+
 		info->dir_pin = -ENODATA;
 		/* info->snap_btime remains zero */
 	}
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 330769ecb601..da2f53646217 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -69,6 +69,7 @@ struct ceph_mds_reply_info_in {
 	u64 max_bytes;
 	u64 max_files;
 	s32 dir_pin;
+	struct ceph_timespec btime;
 	struct ceph_timespec snap_btime;
 };
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 98d2bafc2ee2..3dd9d467bb80 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -384,6 +384,7 @@ struct ceph_inode_info {
 	int i_snap_realm_counter; /* snap realm (if caps) */
 	struct list_head i_snap_realm_item;
 	struct list_head i_snap_flush_item;
+	struct timespec64 i_btime;
 	struct timespec64 i_snap_btime;
 
 	struct work_struct i_work;
-- 
2.21.0

