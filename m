Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE095A1253
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242759AbiHYNcS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242764AbiHYNb6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045D8B5A4A
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1138061D15
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C13C433D6;
        Thu, 25 Aug 2022 13:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434309;
        bh=O33yqgE1Zbe4RGlECoI8dWZtce63ykTnlUnxZYaQ2cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcwyofJOxKk2RodtXkgjrnY+e+i531Kg/C6sFbTQkX3/yY+jQn7BozSm7/g92NWEd
         ClMChuwBX2h+O4dXO8315JMSClGVgRZv/M4l0KI6jR9aUcsNm4w7W0A3xLJjeIrS/r
         Rujr4IR6SVMmtxrOnlnO/tnHkXG45alb6G8GhhsmNkhotFcG8KYWH7MHyGdvhKg4BU
         wMFIwLU56vRlF1lXjt2vjRB62BGamA5nWA2H2zrGmuSacDitTnM6vWWkSbfBubV7kq
         fA69D0QeWSCAdKz3L1dxq8a6gVJYsw4jcOAZpzreHBIAjcNBCzb31y4jCrXGTpmfU/
         m1qnni7Gin0fQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 21/29] ceph: set i_blkbits to crypto block size for encrypted inodes
Date:   Thu, 25 Aug 2022 09:31:24 -0400
Message-Id: <20220825133132.153657-22-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Some of the underlying infrastructure for fscrypt relies on i_blkbits
being aligned to the crypto blocksize.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 5782e6e2b024..6cb791bc8701 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -988,13 +988,6 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 	issued |= __ceph_caps_dirty(ci);
 	new_issued = ~issued & info_caps;
 
-	/* directories have fl_stripe_unit set to zero */
-	if (le32_to_cpu(info->layout.fl_stripe_unit))
-		inode->i_blkbits =
-			fls(le32_to_cpu(info->layout.fl_stripe_unit)) - 1;
-	else
-		inode->i_blkbits = CEPH_BLOCK_SHIFT;
-
 	__ceph_update_quota(ci, iinfo->max_bytes, iinfo->max_files);
 
 #ifdef CONFIG_FS_ENCRYPTION
@@ -1020,6 +1013,15 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		ceph_decode_timespec64(&ci->i_snap_btime, &iinfo->snap_btime);
 	}
 
+	/* directories have fl_stripe_unit set to zero */
+	if (IS_ENCRYPTED(inode))
+		inode->i_blkbits = CEPH_FSCRYPT_BLOCK_SHIFT;
+	else if (le32_to_cpu(info->layout.fl_stripe_unit))
+		inode->i_blkbits =
+			fls(le32_to_cpu(info->layout.fl_stripe_unit)) - 1;
+	else
+		inode->i_blkbits = CEPH_BLOCK_SHIFT;
+
 	if ((new_version || (new_issued & CEPH_CAP_LINK_SHARED)) &&
 	    (issued & CEPH_CAP_LINK_EXCL) == 0)
 		set_nlink(inode, le32_to_cpu(info->nlink));
-- 
2.37.2

