Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68254842FE
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiADOEy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49760 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiADOEy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E89FB6144A
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D57C36AED;
        Tue,  4 Jan 2022 14:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305093;
        bh=b5/QRRHZ1RLWN0Qqgr/u0tltLjdxnA4v9Er0MFRU8w0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPBD1e0gkd8X1HNVYKFBL0Ksvbzw4xbfGGBQ+P+rtAvI3LcUfI0Zeh8gTaazZiBmP
         FDvYxO95Xilq9N9Tdj4VkvNxYiW9hy99ow+S7ki7lK5b+UatcPWEP6DxXYX8/eU+VX
         OPbe8E5wcnCREhr9/pqKUQmkOiSTJ3KJymb+puTzcuIY1xSNmTFoiiDMHUyQWMQdKJ
         CwjgalUEdv2lU0S+MuHy9PaG+ZuaITH6KPcwMWASIRAavS5swF4VvhwNC0nOvlx0WY
         WfHC7mGOFhAkvJlX1DlTyCoSJOUs11nz1I/b5msQ1attkgNkoLvEwvjC7prgD7GInm
         3Tf0djMbVk5Uw==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 10/12] ceph/acl: allow idmapped set_acl inode op
Date:   Tue,  4 Jan 2022 15:04:12 +0100
Message-Id: <20220104140414.155198-11-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=847; h=from:subject; bh=52mlsmJPfUdAvKrVsONCSZHmOUFLsm3gBjPvELkE9FE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd58wtvnJX9OyCxPnY/SyUtXLP8ufPnsl4TXbq/03hf+ lEzf1VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRvWKMDEf4T5veeZ+/SuHZm+P79w teWuCSGfTwobrTlPNHz5zbt8WU4Z+B2ptLx154Wcb7O708uZ6htNDmzm3OuFiD5q/JTYuz2HkB
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_set_acl() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index f4fc8e0b847c..7957d44bb27c 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -104,7 +104,7 @@ int ceph_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
 	case ACL_TYPE_ACCESS:
 		name = XATTR_NAME_POSIX_ACL_ACCESS;
 		if (acl) {
-			ret = posix_acl_update_mode(&init_user_ns, inode,
+			ret = posix_acl_update_mode(mnt_userns, inode,
 						    &new_mode, &acl);
 			if (ret)
 				goto out;
-- 
2.32.0

