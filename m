Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654B338F46
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbfFGPig (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbfFGPib (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:31 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24C0221473;
        Fri,  7 Jun 2019 15:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921910;
        bh=k7oL6V30hr/kbKu1Tt/wm+RcxVEvkhAf7+MuDvIdyOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq689zFPIDAg6i/ZbRVniNRlKCaV1bmLAXeYO2NHGhOMU0Af88pmZTenafakzM8X7
         Wu4HEgUm+4bdtun272xKh4BJqzA9eexiD+RBin//EqRNj309SYlG3IekoFuCTbkkpf
         rWm3AV5sCr8e5nHP/vAR7kn937hj15flsoB+sC2g=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 14/16] ceph: add change_attr field to ceph_inode_info
Date:   Fri,  7 Jun 2019 11:38:14 -0400
Message-Id: <20190607153816.12918-15-jlayton@kernel.org>
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
 fs/ceph/inode.c      | 5 +++++
 fs/ceph/mds_client.c | 4 ++--
 fs/ceph/mds_client.h | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d06c492a2947..fb32db134509 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -13,6 +13,7 @@
 #include <linux/posix_acl.h>
 #include <linux/random.h>
 #include <linux/sort.h>
+#include <linux/iversion.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -42,6 +43,7 @@ static int ceph_set_ino_cb(struct inode *inode, void *data)
 {
 	ceph_inode(inode)->i_vino = *(struct ceph_vino *)data;
 	inode->i_ino = ceph_vino_to_ino(*(struct ceph_vino *)data);
+	inode_set_iversion_raw(inode, 0);
 	return 0;
 }
 
@@ -805,6 +807,9 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 	     le64_to_cpu(info->version) > (ci->i_version & ~1)))
 		new_version = true;
 
+	/* Update change_attribute */
+	inode_set_max_iversion_raw(inode, iinfo->change_attr);
+
 	__ceph_caps_issued(ci, &issued);
 	issued |= __ceph_caps_dirty(ci);
 	new_issued = ~issued & info_caps;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7bc0a6f4bb2e..93b3a1e3ba9c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -156,7 +156,7 @@ static int parse_reply_info_in(void **p, void *end,
 		ceph_decode_copy(p, &info->btime, sizeof(info->btime));
 
 		/* change attribute */
-		ceph_decode_skip_64(p, end, bad);
+		ceph_decode_64_safe(p, end, info->change_attr, bad);
 
 		/* dir pin */
 		if (struct_v >= 2) {
@@ -208,7 +208,7 @@ static int parse_reply_info_in(void **p, void *end,
 		if (features & CEPH_FEATURE_FS_BTIME) {
 			ceph_decode_need(p, end, sizeof(info->btime), bad);
 			ceph_decode_copy(p, &info->btime, sizeof(info->btime));
-			ceph_decode_skip_64(p, end, bad);
+			ceph_decode_64_safe(p, end, info->change_attr, bad);
 		}
 
 		info->dir_pin = -ENODATA;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index da2f53646217..f7c8603484fe 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -71,6 +71,7 @@ struct ceph_mds_reply_info_in {
 	s32 dir_pin;
 	struct ceph_timespec btime;
 	struct ceph_timespec snap_btime;
+	u64 change_attr;
 };
 
 struct ceph_mds_reply_dir_entry {
-- 
2.21.0

