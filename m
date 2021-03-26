Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C04134ABA1
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Mar 2021 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCZPkr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Mar 2021 11:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhCZPkg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 11:40:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C26161A1E;
        Fri, 26 Mar 2021 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616773235;
        bh=5QHjsOuCeKmAcwCLCBPIamZAmQzcQhQ5LSmlww771UM=;
        h=From:To:Cc:Subject:Date:From;
        b=G+jzmFkDBl+LqfD6jWAehGh81aF5345grfOBofHH7GkAYFLoFlGZuaiS9DdkwGJ5w
         WUq6ntB9atJ+bPf1g9mDxC5K+iiTU/pyXzVDCsCLYzOI49GDIzXTjkexevFZNde+BH
         RwZzTf1z+jyFYNEGKKNyGsvnCQvLfA3lFPAO89mHPNUQFTXjqclUyjK8RuRIq6jkX5
         qX5JaulJlHacuyH58CwYFvBZcuzbEEqVQID67zpKdUYCMXzCEbeOuYRXG47DrQVil6
         DOZetSMLbA3sJZ7expQFcyTV/Wpyo/hAL+PZu0t1J1XRr528TtuwXa0ShwVHfKdt2c
         BiC1luyBH8MUg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Luis Henriques <lhenriques@suse.de>
Subject: [PATCH] ceph: fix inode leak on getattr error in __fh_to_dentry
Date:   Fri, 26 Mar 2021 11:40:32 -0400
Message-Id: <20210326154032.86410-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Cc: Luis Henriques <lhenriques@suse.de>
Fixes: 878dabb64117 (ceph: don't return -ESTALE if there's still an open file)
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/export.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index f22156ee7306..17d8c8f4ec89 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -178,8 +178,10 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 		return ERR_CAST(inode);
 	/* We need LINK caps to reliably check i_nlink */
 	err = ceph_do_getattr(inode, CEPH_CAP_LINK_SHARED, false);
-	if (err)
+	if (err) {
+		iput(inode);
 		return ERR_PTR(err);
+	}
 	/* -ESTALE if inode as been unlinked and no file is open */
 	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
 		iput(inode);
-- 
2.30.2

