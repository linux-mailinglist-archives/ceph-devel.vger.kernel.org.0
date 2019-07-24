Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAEAA72E60
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 14:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfGXMFo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 08:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfGXMFo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 08:05:44 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E602E229ED;
        Wed, 24 Jul 2019 12:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563969944;
        bh=ce4lVMMApXOGCsJ6+cFaIhtxdgLVBafviUU4GJ1LkYI=;
        h=From:To:Cc:Subject:Date:From;
        b=XYzTyyUk9SfAQj0ZGIwguRCGQnqrKwyxah9D9s8WqE2zLm0ZmxX0Bg/+FcpQhbQKC
         hpQkf0wbuQY89EfjSD1Xpll7qBCOKo4NbLJ0HcWCoYiDtlh60Ydjo47ROw8nzu98Sr
         2VZniAq6Xo3M75oLKS/0Kms5dnrTrg3kPsHuITTQ=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.com
Subject: [PATCH] ceph: have copy op fall back when src_inode == dst_inode
Date:   Wed, 24 Jul 2019 08:05:42 -0400
Message-Id: <20190724120542.26391-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently this just fails, but the fallback implementation can handle
this case. Change it to return -EOPNOTSUPP instead of -EINVAL when
copying data to a different spot in the same inode.

Cc: Luis Henriques <lhenriques@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

NB: with this patch, xfstest generic/075 now passes

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 82af4a3c714d..1b25df9d5853 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1915,8 +1915,6 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
 
 	if (src_inode->i_sb != dst_inode->i_sb)
 		return -EXDEV;
-	if (src_inode == dst_inode)
-		return -EINVAL;
 	if (ceph_snap(dst_inode) != CEPH_NOSNAP)
 		return -EROFS;
 
@@ -1928,6 +1926,10 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	 * efficient).
 	 */
 
+	/* Can't do OSD copy op to same object */
+	if (src_inode == dst_inode)
+		return -EOPNOTSUPP;
+
 	if (ceph_test_mount_opt(ceph_inode_to_client(src_inode), NOCOPYFROM))
 		return -EOPNOTSUPP;
 
-- 
2.21.0

