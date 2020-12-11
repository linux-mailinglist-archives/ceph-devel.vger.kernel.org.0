Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C032D71FC
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Dec 2020 09:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436986AbgLKIlC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Dec 2020 03:41:02 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9161 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436982AbgLKIkh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Dec 2020 03:40:37 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CskjP3bjzz15KDF;
        Fri, 11 Dec 2020 16:39:21 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Dec 2020 16:39:45 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jlayton@kernel.org>, <idryomov@gmail.com>
CC:     <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Zheng Yongjun" <zhengyongjun3@huawei.com>
Subject: [PATCH -next] fs/omfs: convert comma to semicolon
Date:   Fri, 11 Dec 2020 16:40:13 +0800
Message-ID: <20201211084013.1878-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 fs/omfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 2c7b70ee1388..fc6828f30f60 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -22,8 +22,8 @@ void omfs_make_empty_table(struct buffer_head *bh, int offset)
 	struct omfs_extent *oe = (struct omfs_extent *) &bh->b_data[offset];
 
 	oe->e_next = ~cpu_to_be64(0ULL);
-	oe->e_extent_count = cpu_to_be32(1),
-	oe->e_fill = cpu_to_be32(0x22),
+	oe->e_extent_count = cpu_to_be32(1);
+	oe->e_fill = cpu_to_be32(0x22);
 	oe->e_entry.e_cluster = ~cpu_to_be64(0ULL);
 	oe->e_entry.e_blocks = ~cpu_to_be64(0ULL);
 }
-- 
2.22.0

