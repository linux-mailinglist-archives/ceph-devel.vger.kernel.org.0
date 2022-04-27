Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C52251226B
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbiD0TUs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiD0TTi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4EA562E8
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F9AFB8291B
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A9EC385AE;
        Wed, 27 Apr 2022 19:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086837;
        bh=3VdNwxJLoqYh6Iuifg1aP3SUY75NSApb6Lub/uJdb8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6ujfrLUcLWDmYUAg+C6Ge094H9RN9Co2GeIDj1VgHPMnmu6o8OXqC21WBRQ97bVD
         A06fq0amc//L+rdTY4Wh7DQeGqA1UpznwlAYJXdatwRnAJxMjBnXV7x/PTZxZ6aKoM
         54vq5yPy+kqy6gX4WpbHiDKnRHA091+k4uxRFlodABr75a8maKS/64vrEHyC0/VtKE
         7i5yCByT/knF5ab7dkXfwQHx6eKPN/dqrzOcUM8Ghj7HYUoYHwnIp8JC39Pv5/jQ84
         B7DQO0QvkiSSKQVwcLryMCCjr+UVAOnCfi85KWFnu65joo8Iy1QtiA6Ve8Yx9rOzD2
         lNWJ3qzPRif2Q==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 57/64] ceph: set i_blkbits to crypto block size for encrypted inodes
Date:   Wed, 27 Apr 2022 15:13:07 -0400
Message-Id: <20220427191314.222867-58-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Some of the underlying infrastructure for fscrypt relies on i_blkbits
being aligned to the crypto blocksize.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9936d82193b5..021638fb85f9 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -976,13 +976,6 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
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
@@ -1008,6 +1001,15 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
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
2.35.1

