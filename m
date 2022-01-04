Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAA84842F9
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiADOEn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbiADOEn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C4FC061761
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 06:04:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4699F6145F
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C2EC36AED;
        Tue,  4 Jan 2022 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305081;
        bh=kdapNRIiHRvmAkuAkJkPUSrnzX8VwpOawS4krFB8eoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0R4DLQXB8sw2xZCkBGKqlgnB+8sDeAAkIq9n8hlafB0zqumFFEKfvXuDn/ByO+4P
         UfuE538WoWisYQM/1JI/oCNmT338GQgpgfJVfEanCurohWvYicVJ66ADLbMCrujBnu
         hAHFSikJEls9SC2Zw/KKLQWdfkgqTw4Cs139XjVm+1xYZoVqkLuk4q/0iVOi+kvcLU
         Uqj1olyw5zOIT0Do4UjmBNoZ7bTKtDNEA+YgjUzBv8Uce7ku1tNAo75cRn7Wn5HFeJ
         uAd+aVhk4469rP9mOHk2OUjt1kdjk05A45j2yrUweWrwho7c6N9knRr/sa9pMqjN4/
         5OsB3+KMp586A==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 05/12] ceph: allow idmapped mkdir inode op
Date:   Tue,  4 Jan 2022 15:04:07 +0100
Message-Id: <20220104140414.155198-6-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=878; h=from:subject; bh=lK/JAkFEaquLxUpARZctsQdyX/6TrkzXiRgfniaafaI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd5YuLrjl85rqaKfUbcvhF8vUlQSU9/k0bxa5d8Htd0c sUcsOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyu5yRYQbDZ/6bdmU1PwyuWCnMcp CxjFowOy34gW9gvlfcdjlORYa/MlECfEeZly77KsJ2fWe9oe4fTt43TjuLXiu8Nd32gNuVDQA=
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_mkdir() to handle idmapped mounts. This is just a matter of
passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 67ce448a9ff5..210257afb346 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1002,6 +1002,7 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_args.mkdir.mode = cpu_to_le32(mode);
+	req->mnt_userns = mnt_userns;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 	if (as_ctx.pagelist) {
-- 
2.32.0

