Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0F04C621E
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Feb 2022 05:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiB1EVX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 27 Feb 2022 23:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiB1EVV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 27 Feb 2022 23:21:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F9B8403E6
        for <ceph-devel@vger.kernel.org>; Sun, 27 Feb 2022 20:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646022041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7uoyV3UDN+h6T1/T0ayIRoeu/53zPzpKcvLRThO7JGA=;
        b=VL8BtIzohQED24RLqpRXS5QylhllmsssN2Ll2uR7K8FkU9JDrODqCeEzToi079TZ1G8gRM
        LfsExs5azBCcsOLvIFwifaA9r7SrNQielfERnGPl50MfmGFn3EHsfVIDsMo8AjKibgmK4A
        Fyml5e8mMcecqAsxPxiZK73ObKEqI1U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-wlHSn4yAN5qUh_VVB-taTg-1; Sun, 27 Feb 2022 23:20:38 -0500
X-MC-Unique: wlHSn4yAN5qUh_VVB-taTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 319E01800D50;
        Mon, 28 Feb 2022 04:20:37 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1157E5E26D;
        Mon, 28 Feb 2022 04:20:34 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/3] ceph: add ceph_get_snap_parent_inode() support
Date:   Mon, 28 Feb 2022 12:20:23 +0800
Message-Id: <20220228042025.30806-2-xiubli@redhat.com>
In-Reply-To: <20220228042025.30806-1-xiubli@redhat.com>
References: <20220228042025.30806-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Get the parent inode for the snap directory ".snap", if the inode
is not a snap directory just return it with the reference increased.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/snap.c  | 24 ++++++++++++++++++++++++
 fs/ceph/super.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 66a1a92cf579..5e9656926dc7 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -1247,3 +1247,27 @@ void ceph_cleanup_snapid_map(struct ceph_mds_client *mdsc)
 		kfree(sm);
 	}
 }
+
+/*
+ * Get the parent inode for the snap directory ".snap",
+ * if the inode is not a snap directory just return it
+ * with the reference increased.
+ */
+struct inode *ceph_get_snap_parent_inode(struct inode *inode)
+{
+	struct inode *pinode;
+
+	if (ceph_snap(inode) == CEPH_SNAPDIR) {
+		struct ceph_vino vino = {
+			.ino = ceph_ino(inode),
+			.snap = CEPH_NOSNAP,
+		};
+		pinode = ceph_find_inode(inode->i_sb, vino);
+		BUG_ON(!pinode);
+	} else {
+		ihold(inode);
+		pinode = inode;
+	}
+
+	return pinode;
+}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d5a4d311f4c2..e7c69ca5e289 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -969,6 +969,7 @@ extern void ceph_put_snapid_map(struct ceph_mds_client* mdsc,
 				struct ceph_snapid_map *sm);
 extern void ceph_trim_snapid_map(struct ceph_mds_client *mdsc);
 extern void ceph_cleanup_snapid_map(struct ceph_mds_client *mdsc);
+extern struct inode *ceph_get_snap_parent_inode(struct inode *inode);
 void ceph_umount_begin(struct super_block *sb);
 
 
-- 
2.27.0

