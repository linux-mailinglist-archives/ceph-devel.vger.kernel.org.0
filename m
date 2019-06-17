Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E857648774
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfFQPiG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbfFQPiE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:38:04 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC02C2182B;
        Mon, 17 Jun 2019 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785884;
        bh=OexlBFxEoQpuBU+72BiOhih4Ko3zCjEMZb8upr3lqDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hug93pBSsnItGMJ7XdnrPY9icroCX7qPZGjd0LLlmHuhpvJR6VmuY+rvQ6PiYrxOb
         s8xA3j6GyLxREzwt0KnDE6sjDwlEGioJKKvEBVisly8GQs0h+Tl9ikz6zFgeXQH1QE
         KdutxS/7T3GtGjXya0KVXHhWlUj3/rv/DzSYjhIk=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 11/18] ceph: add btime field to ceph_inode_info
Date:   Mon, 17 Jun 2019 11:37:46 -0400
Message-Id: <20190617153753.3611-12-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
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
index 19c62cf7d5b8..5602e7ba5307 100644
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

