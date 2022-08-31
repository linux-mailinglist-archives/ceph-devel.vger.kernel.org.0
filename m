Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924955A7533
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Aug 2022 06:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiHaEiQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 Aug 2022 00:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiHaEiP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 Aug 2022 00:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AFFAA3EE
        for <ceph-devel@vger.kernel.org>; Tue, 30 Aug 2022 21:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661920693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ca8KqrJFpVZ2n80COFlDr2/C0pj8A4qnAMUAYSpoaPM=;
        b=c5/1w2YSfPj3RWeb9eYbPMtfHgmCQnIKMrOq3QQbgZWiZK4l9/Dl4+pr/SMTtDtnZ3EMP4
        JIZCGPwHVnd8rAjDG6zsL2aQQe+g+F+OYoz2esHVdb0MmvN6oroGXUjSpDU71jZ2sjP4AW
        H3kmuRsnejEnuOVoRNvVfo4d9ftyZoE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-UPFJ3a6_PWOCC2Rc5idoOg-1; Wed, 31 Aug 2022 00:38:10 -0400
X-MC-Unique: UPFJ3a6_PWOCC2Rc5idoOg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EB1B3C10682;
        Wed, 31 Aug 2022 04:38:10 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B8DA1415133;
        Wed, 31 Aug 2022 04:38:07 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix incorrectly showing the .snap size for stat
Date:   Wed, 31 Aug 2022 12:37:59 +0800
Message-Id: <20220831043759.94724-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
 fs/ceph/inode.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 4db4394912e7..fafdeb169b22 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2705,6 +2705,52 @@ static int statx_to_caps(u32 want, umode_t mode)
 	return mask;
 }
 
+static struct inode *ceph_get_snap_parent(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
+	struct ceph_mds_request *req;
+	struct ceph_vino vino = {
+		.ino = ceph_ino(inode),
+		.snap = CEPH_NOSNAP,
+	};
+	struct inode *parent;
+	int mask;
+	int err;
+
+	if (ceph_vino_is_reserved(vino))
+		return ERR_PTR(-ESTALE);
+
+	parent = ceph_find_inode(sb, vino);
+	if (likely(parent)) {
+		if (ceph_inode_is_shutdown(parent)) {
+			iput(parent);
+			return ERR_PTR(-ESTALE);
+		}
+		return parent;
+	}
+
+	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
+				       USE_ANY_MDS);
+	if (IS_ERR(req))
+		return ERR_CAST(req);
+
+	mask = CEPH_STAT_CAP_INODE;
+	if (ceph_security_xattr_wanted(d_inode(sb->s_root)))
+		mask |= CEPH_CAP_XATTR_SHARED;
+	req->r_args.lookupino.mask = cpu_to_le32(mask);
+	req->r_ino1 = vino;
+	req->r_num_caps = 1;
+	err = ceph_mdsc_do_request(mdsc, NULL, req);
+	if (err < 0)
+		return ERR_PTR(err);
+	parent = req->r_target_inode;
+	if (!parent)
+		return ERR_PTR(-ESTALE);
+	ihold(parent);
+	return parent;
+}
+
 /*
  * Get all the attributes. If we have sufficient caps for the requested attrs,
  * then we can avoid talking to the MDS at all.
@@ -2748,10 +2794,17 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 
 	if (S_ISDIR(inode->i_mode)) {
 		if (ceph_test_mount_opt(ceph_sb_to_client(inode->i_sb),
-					RBYTES))
+					RBYTES)) {
 			stat->size = ci->i_rbytes;
-		else
+		} else if (ceph_snap(inode) == CEPH_SNAPDIR) {
+			struct inode *parent = ceph_get_snap_parent(inode);
+			struct ceph_inode_info *pci = ceph_inode(parent);
+
+			stat->size = pci->i_rsnaps;
+			iput(parent);
+		} else {
 			stat->size = ci->i_files + ci->i_subdirs;
+		}
 		stat->blocks = 0;
 		stat->blksize = 65536;
 		/*
-- 
2.36.0.rc1

