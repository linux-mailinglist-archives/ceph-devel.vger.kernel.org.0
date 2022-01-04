Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB954842FA
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiADOEq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49700 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiADOEp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE59E6144A
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0A2C36AF2;
        Tue,  4 Jan 2022 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305084;
        bh=7xWSS+VpiP8dfSlEHjbHYvxxgbifdP+JryNLZ3+XfJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfhazTTCZUHTJvB5FYhTI+1f+G1p/gMMquDTRjkPlZU9KC8P6lf2LLPyzsqpi3wcQ
         IJQPwglChFTHTvKiI4gQHv8w3LzyLZpZQWcM7aTNxFWZfKqbYFLaKQACv/G0oiUWVK
         +oHVq86Ek304Rk+M0JSJut7weIzod4Idfw1OJkyTC0bO++SInc0Fhs0HXrIB2nX6yb
         xY+SFI/qsJoo2ocumz3NJApU2QWpwfXswK7w5f5WLWUyuMK2SagQ1fIDLLcjILnnV+
         I2+YJygvNl36yxkuZ4K+848FAnXaPSuulNW2jODxp6VnwY+oC2cgt7Z72Ma63wHdUG
         HG7BH8fZRYBeA==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 06/12] ceph: allow idmapped rename inode op
Date:   Tue,  4 Jan 2022 15:04:08 +0100
Message-Id: <20220104140414.155198-7-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=946; h=from:subject; bh=mbk8SDzhQb6ZEo6K3hHL8WO2mNfdbln+y3NHHYE09h0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd64ZNefsmN5ac8tX/XvTvh+9dKq/yfn1UV+bHvEo5ly sDUtoKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAix5MYGeaw8i4OOjV/dqPfyajQsJ 7Xd0+8aZm713CXn7yyU8OK7W2MDDcMp9wRfrJOqfDyuTkxfwwK8sutFv5ZKftM+hx/VGAlGy8A
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_rename() to handle idmapped mounts. This is just a matter of
passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 210257afb346..9463c960f03b 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1248,6 +1248,7 @@ static int ceph_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	req->r_old_dentry_unless = CEPH_CAP_FILE_EXCL;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
+	req->mnt_userns = mnt_userns;
 	/* release LINK_RDCACHE on source inode (mds will lock it) */
 	req->r_old_inode_drop = CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EXCL;
 	if (d_really_is_positive(new_dentry)) {
-- 
2.32.0

