Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874CB4842FC
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiADOEu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiADOEt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF08C061761
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 06:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E1FD6145F
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A106C36AED;
        Tue,  4 Jan 2022 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305088;
        bh=lkRedyQpPjGRo7G2CA0++lgrDx9Eme/DSgAOV4dla7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7VxteTdGjgNNlh8K0sNHzBDlfY1XZFFsaYP8zXO6f6f6fmyqODbVJtetOWhy+QWE
         0q/4v8WcgB4TbhappgM5G0hATUeXFbm2DqJcPAmEcJhBmNbGhUdW6IBPKrMvFmyboX
         CCaBz1w+OvQHsN5mae0GkYjbd1/VHlSA+z640RxmZFaK0kDiJnhj6nBhkAFoQRwFMT
         u/gToa7blVBNzMD7UhETIpHjfv8vQ0LJuEj9wPILhQAwKvvHepzMwTGe5yYFWvFOH3
         tAmpkfHh/IdRolOIu5dLCKCVGOXyAitUEMzwPmFYpw0VKojSiMItum2tI+7veTsFP6
         nR9nMcAF7DhVg==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 08/12] ceph: allow idmapped permission inode op
Date:   Tue,  4 Jan 2022 15:04:10 +0100
Message-Id: <20220104140414.155198-9-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=831; h=from:subject; bh=e//HmyVQbC20ht0ysyOxU2Zp9Z2u26WTn1+u2bxBHV0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd6UezP4lplCbkDgubV36mb92MoS//TksvTjt54u7fGZ 8O1aXUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBElu1l+J+3LKv+0fKTmju7vkl7rW qWt3/lItXGWurwOC+d4afj6ZWMDC39bix7NhtLBpatTZni18z37FF+jNi6JxyzdCxDGzUSGAE=
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_permission() to handle idmapped mounts. This is just a
matter of passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index f648aecc5827..d5cecc3519fa 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2307,7 +2307,7 @@ int ceph_permission(struct user_namespace *mnt_userns, struct inode *inode,
 	err = ceph_do_getattr(inode, CEPH_CAP_AUTH_SHARED, false);
 
 	if (!err)
-		err = generic_permission(&init_user_ns, inode, mask);
+		err = generic_permission(mnt_userns, inode, mask);
 	return err;
 }
 
-- 
2.32.0

