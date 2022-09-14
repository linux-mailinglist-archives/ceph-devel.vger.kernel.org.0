Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE5E5B7F33
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Sep 2022 05:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiINDJ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Sep 2022 23:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiINDJ4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Sep 2022 23:09:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA0CBCBA
        for <ceph-devel@vger.kernel.org>; Tue, 13 Sep 2022 20:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663124989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jlkrrDo/ZNpO+d3hkCF+Z+vI7kye+PRnDQz9Ou3QCFk=;
        b=awElBPV2BhgmPiffSCf4KAU6uwjHDvmHG2INgmnlKSmqh7kDzmHfDybRzFhfWw0JFB4aVh
        vx00w5HX1r2yKmzs1NrKa0/mhgJ/dmhwVP0aYV29XjmBiVLKWoC+IHmq7mHowNpVLAN/YN
        kTCiPNR1NIHCR6imfMsRPDdPRvi59A4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-eAu-TKhQNbuZmXZAOjhghQ-1; Tue, 13 Sep 2022 23:09:46 -0400
X-MC-Unique: eAu-TKhQNbuZmXZAOjhghQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B59B804191;
        Wed, 14 Sep 2022 03:09:46 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60F591121314;
        Wed, 14 Sep 2022 03:09:43 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: fix incorrectly showing the .snap size for stat
Date:   Wed, 14 Sep 2022 11:09:40 +0800
Message-Id: <20220914030940.61357-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

We should set the 'stat->size' to the real number of snapshots for
snapdirs.

URL: https://tracker.ceph.com/issues/57342
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- reuse ceph_lookup_inode(), Thanks Luis' comment about this.

 fs/ceph/inode.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 4db4394912e7..84ea0e18089a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2713,6 +2713,7 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		 struct kstat *stat, u32 request_mask, unsigned int flags)
 {
 	struct inode *inode = d_inode(path->dentry);
+	struct super_block *sb = inode->i_sb;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u32 valid_mask = STATX_BASIC_STATS;
 	int err = 0;
@@ -2742,16 +2743,34 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 	}
 
 	if (ceph_snap(inode) == CEPH_NOSNAP)
-		stat->dev = inode->i_sb->s_dev;
+		stat->dev = sb->s_dev;
 	else
 		stat->dev = ci->i_snapid_map ? ci->i_snapid_map->dev : 0;
 
 	if (S_ISDIR(inode->i_mode)) {
-		if (ceph_test_mount_opt(ceph_sb_to_client(inode->i_sb),
-					RBYTES))
+		if (ceph_test_mount_opt(ceph_sb_to_client(sb), RBYTES)) {
 			stat->size = ci->i_rbytes;
-		else
+		} else if (ceph_snap(inode) == CEPH_SNAPDIR) {
+			struct ceph_inode_info *pci;
+			struct ceph_snap_realm *realm;
+			struct inode *parent;
+
+			parent = ceph_lookup_inode(sb, ceph_ino(inode));
+			if (!parent)
+				return PTR_ERR(parent);
+
+			pci = ceph_inode(parent);
+			spin_lock(&pci->i_ceph_lock);
+			realm = pci->i_snap_realm;
+			if (realm)
+				stat->size = realm->num_snaps;
+			else
+				stat->size = 0;
+			spin_unlock(&pci->i_ceph_lock);
+			iput(parent);
+		} else {
 			stat->size = ci->i_files + ci->i_subdirs;
+		}
 		stat->blocks = 0;
 		stat->blksize = 65536;
 		/*
-- 
2.31.1

