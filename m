Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32C74842F7
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbiADOEj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60168 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbiADOEj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F54BB81125
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00587C36AEF;
        Tue,  4 Jan 2022 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305077;
        bh=V8wDUe1mE6v6Pe/YK1MY4TTQkx8oz9Huk1KCABhGIYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlImx59C4HY36LPUWgdzCcbNvdIT+7eD4D887X4RmBIfOrfHVTz4nh53rsjLx7r58
         j6gHVAEtmZSxvPWw7ovSIXvvO3SjSEdaLQY0S1pTYPTnefPfFKRSS8N87ds4AT/n8H
         fAq+rxyQHS6+izboCjtUrp9dKhtdyff7lESOaaJ5BWuwCsa82enHP+aD5Tx0GRN8Vw
         t48OJmaSfmTi5f8sUfKKKjTWwBkFkoXwrZ0wqbEaZWrMmRdc/uIW25kjOySE3Ky2oS
         M33gJFezwPwE9m5xogEP/DaPPYKWll5H6ZX65oBvuJ1aPChSf+4MU0BqNw9LNQeThQ
         UwkfsHziZUHDQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 03/12] ceph: allow idmapped mknod inode op
Date:   Tue,  4 Jan 2022 15:04:05 +0100
Message-Id: <20220104140414.155198-4-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=875; h=from:subject; bh=YLblXcGDq7nV80TG+RfbU2nhtFvggg7pRbf0kvvRh2k=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd5wQXPL1qtCh66VvtE+tHOL9iSZLvXD9+557tOKERO9 vP3j7Y5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJfLvL8L8kN1K65tJzjqerI7WnF9 /uuMB06wCnqV5311IHrw/fHzgxMuxYU+Vu5Jzo6xqqdDthdk/KG41FS47zPvxx2da0ve+7DisA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_mknod() to handle idmapped mounts. This is just a matter of
passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 133dbd9338e7..7278863fbd4a 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -871,6 +871,7 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->mnt_userns = mnt_userns;
 	req->r_args.mknod.mode = cpu_to_le32(mode);
 	req->r_args.mknod.rdev = cpu_to_le32(rdev);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
-- 
2.32.0

