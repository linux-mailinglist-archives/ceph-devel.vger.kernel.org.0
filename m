Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF830484301
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbiADOFA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:05:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49796 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiADOE6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB5D661462
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B97C36AE9;
        Tue,  4 Jan 2022 14:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305097;
        bh=qNglKwXd6EyPWHSqBbs3+BiKQnPKuqE/UETgHh2mvF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krEQYDnHbmKZ0wb62vGlfZ9JO/cnAe7O8UVVxRZdxnv9Z+LmxuPUjbwWzvxZdQclJ
         d08caaWW9VlnVpY11AxOtzow1JV0zlgWK7Krh8hsMLZsds5Kg5XcRuML6U04KXX+e/
         drqLY8LsqDhqShZoMW0AWqHHThM+tm49HWcB2GN0WPncvzjmQhz18i8T+eUSvA1mnw
         WzLyX7LbwmthoabvXC2mltx/O9muElCqoy2f9/GivnQrqMSrB10l5Dkpj7dpPolFQ/
         ZkbZPlfKdzst7uUWqqABQB/tHNRyL62wLpsXy4LpC2kq7r/qmZWc8eptkpzg734zK9
         TI9EsCGAYKBjQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 12/12] ceph: allow idmapped mounts
Date:   Tue,  4 Jan 2022 15:04:14 +0100
Message-Id: <20220104140414.155198-13-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=846; h=from:subject; bh=QoWBNhUA5hkB9uz6Fpuu0zEJNpP1SgEB8WEFGaB2D4c=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd6c/eSEnamx5H6uqeYvpbgF3sSudznO/rSpcn30nbh/ fznfdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyk5xMjw9zSFz5r6+9cnai4We94dv 7NA0FHPbPPyHlydQktfbkqI5Thr5xL6uW8a7VtotahWS/rw7Z9f7T/9KljVUINj26s3cttxAwA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Now that we converted cephfs internally to account for idmapped mounts
allow the creation of idmapped mounts on by setting the FS_ALLOW_IDMAP
flag.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index bab61232dc5a..eda4a26fcb0c 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1242,7 +1242,7 @@ static struct file_system_type ceph_fs_type = {
 	.name		= "ceph",
 	.init_fs_context = ceph_init_fs_context,
 	.kill_sb	= ceph_kill_sb,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE,
+	.fs_flags	= FS_RENAME_DOES_D_MOVE | FS_ALLOW_IDMAP,
 };
 MODULE_ALIAS_FS("ceph");
 
-- 
2.32.0

