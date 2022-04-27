Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB62B5122A5
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiD0T2L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiD0TTL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA306B0AB
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A6B0619E1
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFBFC385A7;
        Wed, 27 Apr 2022 19:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086802;
        bh=4v09Oqa2g9UpmLsr2sXMMcvUdFtRLMV47gUMXIJz13I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufVjJNo4hxGfU29R+HntouHR1Io8VEbRYX9Bvh/sDuFL3MRYw22EIxhzg/aWkOlSJ
         PCWvMcD1O+jxRS/CWoYJETv13ILuNQVolkTS7YNWp00Sx0Y0hdeEe60YndzfY1o+te
         iM1i4BZC6hhzjez6hao6D0QoXc9a2WT0xsDO/oVysyt/mh2wrRdmWPIxXgnFBEInqp
         BfMwiGsxUtXt7u/FWiXHh6lhvD9sEcuLYWSH/c8HmoHejKuE9atPF463w/bsmCUGaN
         Lo817+Jbbin4S9uU3Aa942BAFgPOL6q22z6NbAYJecTeg215TZH56u27TgRswjNLzI
         3uNK3dprOgAsw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v14 08/64] fs: change test in inode_insert5 for adding to the sb list
Date:   Wed, 27 Apr 2022 15:12:18 -0400
Message-Id: <20220427191314.222867-9-jlayton@kernel.org>
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

The inode_insert5 currently looks at I_CREATING to decide whether to
insert the inode into the sb list. This test is a bit ambiguous though
as I_CREATING state is not directly related to that list.

This test is also problematic for some upcoming ceph changes to add
fscrypt support. We need to be able to allocate an inode using new_inode
and insert it into the hash later if we end up using it, and doing that
now means that we double add it and corrupt the list.

What we really want to know in this test is whether the inode is already
in its superblock list, and then add it if it isn't. Have it test for
list_empty instead and ensure that we always initialize the list by
doing it in inode_init_once. It's only ever removed from the list with
list_del_init, so that should be sufficient.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9d9b422504d1..743420a55e5f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -422,6 +422,7 @@ void inode_init_once(struct inode *inode)
 	INIT_LIST_HEAD(&inode->i_io_list);
 	INIT_LIST_HEAD(&inode->i_wb_list);
 	INIT_LIST_HEAD(&inode->i_lru);
+	INIT_LIST_HEAD(&inode->i_sb_list);
 	__address_space_init_once(&inode->i_data);
 	i_size_ordered_init(inode);
 }
@@ -1021,7 +1022,6 @@ struct inode *new_inode_pseudo(struct super_block *sb)
 		spin_lock(&inode->i_lock);
 		inode->i_state = 0;
 		spin_unlock(&inode->i_lock);
-		INIT_LIST_HEAD(&inode->i_sb_list);
 	}
 	return inode;
 }
@@ -1165,7 +1165,6 @@ struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 	struct inode *old;
-	bool creating = inode->i_state & I_CREATING;
 
 again:
 	spin_lock(&inode_hash_lock);
@@ -1199,7 +1198,13 @@ struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
 	inode->i_state |= I_NEW;
 	hlist_add_head_rcu(&inode->i_hash, head);
 	spin_unlock(&inode->i_lock);
-	if (!creating)
+
+	/*
+	 * Add it to the list if it wasn't already in,
+	 * e.g. new_inode. We hold I_NEW at this point, so
+	 * we should be safe to test i_sb_list locklessly.
+	 */
+	if (list_empty(&inode->i_sb_list))
 		inode_sb_list_add(inode);
 unlock:
 	spin_unlock(&inode_hash_lock);
-- 
2.35.1

