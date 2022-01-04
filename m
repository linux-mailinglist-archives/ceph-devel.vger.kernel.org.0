Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0234842F8
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbiADOEm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60198 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbiADOEl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B620B81125
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C64BC36AF2;
        Tue,  4 Jan 2022 14:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305079;
        bh=6nkPMhNjieNZ6m4ePI1Riszj8h8K846d0G0gWvovSwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H97d8CA03POUlXlgc7Lxj/UX8j2qOoKvItdnuTDZSaqD0vc/nqtNY0kMY6h3HGKE4
         owFgG/GdTJKEDMeaMGqGkVmQGFIdXuT6nrdwlOwx62xkMcvNQ8+48e/pH220oRm5xX
         bQj1wNFzzyZM+ZPEMpjBUkBqTz1TX8a82HeOk5E0xpU+CSfK4pnDni0hPwWLUe/Mbp
         OoDjIKhT4pNW0Ip7bM6kUK3VfZBzZEltNio90MsxExVsQkJiqQMxK7MYf1QmsOelJr
         fdgoWPMCyXLVpuBE/cjQ/r89D6qLOeyhrZS6DdmDu8hU+b/6RmchBD4/qiA+9T+S2k
         RGU+l8wx2cz0A==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 04/12] ceph: allow idmapped symlink inode op
Date:   Tue,  4 Jan 2022 15:04:06 +0100
Message-Id: <20220104140414.155198-5-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=852; h=from:subject; bh=lW3f+u4vQ+fYlwMHWHIapFP13msWwROsGLxaq1Nvh1Y=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd4Yu+rF6S+zDosck5d2jZq54NC5/cl/WyPWO2Qn2Cze OpNNpaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiq5wYGZpSZJIOn9g/YXPyqw+6Nf O3fAr6lcS8TPrBuZT8LstV75YyMrRe8P59df/ifl/XIxMu25V0ffS4+Xgjl0rUqty96y8k3GAEAA==
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_symlink() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 7278863fbd4a..67ce448a9ff5 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -939,6 +939,7 @@ static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	req->r_num_caps = 2;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
+	req->mnt_userns = mnt_userns;
 	if (as_ctx.pagelist) {
 		req->r_pagelist = as_ctx.pagelist;
 		as_ctx.pagelist = NULL;
-- 
2.32.0

