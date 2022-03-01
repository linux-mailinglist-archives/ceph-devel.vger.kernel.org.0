Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2303F4C8ACB
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 12:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbiCALcL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 06:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiCALcI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 06:32:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC0A648884
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 03:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646134286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xj+bqKTTOOEgANLaC4Y+ImOrJ3xRHijIU6BIGXExg8g=;
        b=EV7UwTXTBdg6hTFZtkCH/YWaG3/T5jMzba8KqF75fGBDvOXigpCiwxguG4Wl6X7Hk612hp
        21kVr3sqOfbHlEt4cNKthG5BjIaZ2S8Uu7cN74VhIN4/vNjD0yET964KFx7AtOpZ/YJChM
        TxLyr4XpBMb+HYKHrjNf7lESubTNt8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-4RhqtFRzPyiam0j0Thx64w-1; Tue, 01 Mar 2022 06:31:22 -0500
X-MC-Unique: 4RhqtFRzPyiam0j0Thx64w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C746C1854E21;
        Tue,  1 Mar 2022 11:31:21 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A91A783195;
        Tue,  1 Mar 2022 11:31:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 5/7] ceph: use the parent inode of '.snap' to dencrypt the names for readdir
Date:   Tue,  1 Mar 2022 19:30:13 +0800
Message-Id: <20220301113015.498041-6-xiubli@redhat.com>
In-Reply-To: <20220301113015.498041-1-xiubli@redhat.com>
References: <20220301113015.498041-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The inode for '.snap' directory will always with no key setup, so
we can use the parent inode to do this.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 877e699fe43b..a6c4965e5363 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1817,7 +1817,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 	struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
 	struct qstr dname;
 	struct dentry *dn;
-	struct inode *in;
+	struct inode *in, *pinode;
 	int err = 0, skipped = 0, ret, i;
 	u32 frag = le32_to_cpu(req->r_args.readdir.frag);
 	u32 last_hash = 0;
@@ -1876,11 +1876,13 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 	cache_ctl.index = req->r_readdir_cache_idx;
 	fpos_offset = req->r_readdir_offset;
 
-	err = ceph_fname_alloc_buffer(inode, &tname);
+	pinode = ceph_get_snap_parent_inode(inode);
+
+	err = ceph_fname_alloc_buffer(pinode, &tname);
 	if (err < 0)
 		goto out;
 
-	err = ceph_fname_alloc_buffer(inode, &oname);
+	err = ceph_fname_alloc_buffer(pinode, &oname);
 	if (err < 0)
 		goto out;
 
@@ -1890,7 +1892,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
 		struct ceph_vino tvino;
 		u32 olen = oname.len;
-		struct ceph_fname fname = { .dir	= inode,
+		struct ceph_fname fname = { .dir	= pinode,
 					    .name	= rde->name,
 					    .name_len	= rde->name_len,
 					    .ctext	= rde->altname,
@@ -2045,8 +2047,9 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		req->r_readdir_cache_idx = cache_ctl.index;
 	}
 	ceph_readdir_cache_release(&cache_ctl);
-	ceph_fname_free_buffer(inode, &tname);
-	ceph_fname_free_buffer(inode, &oname);
+	ceph_fname_free_buffer(pinode, &tname);
+	ceph_fname_free_buffer(pinode, &oname);
+	iput(pinode);
 	dout("readdir_prepopulate done\n");
 	return err;
 }
-- 
2.27.0

