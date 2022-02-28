Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB254C63B1
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Feb 2022 08:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiB1HPo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Feb 2022 02:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiB1HPm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Feb 2022 02:15:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36B775676B
        for <ceph-devel@vger.kernel.org>; Sun, 27 Feb 2022 23:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646032503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=n2uPNYj5gE9UF5IlaDvdrM4/uT57/koM/ZPis/z+0ag=;
        b=gO6uyv5V6QLgu2y18SaHIIdWa4jW/2BDLjSpv5Mj+PMO8nbVEGVKN5tfOPyHnkT7q4Eikz
        uhFltyKyQ5r//MuB4e+ssGEdhPoAtabgibHt9fm8vySAuBk4llarPwxmWVF8n5cphy4ymv
        8YYJGk4oFD7fz51A/rbfZlCfr+i56CA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-sS7-prRVNPGewKYy4L10lA-1; Mon, 28 Feb 2022 02:14:59 -0500
X-MC-Unique: sS7-prRVNPGewKYy4L10lA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EC811006AA5;
        Mon, 28 Feb 2022 07:14:58 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F1615DBB9;
        Mon, 28 Feb 2022 07:14:56 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: increase the offset when fail to decode dentry names
Date:   Mon, 28 Feb 2022 15:14:42 +0800
Message-Id: <20220228071442.48733-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

------------[ cut here ]------------
kernel BUG at fs/ceph/dir.c:537!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 16 PID: 21641 Comm: ls Tainted: G            E     5.17.0-rc2+ #92
Hardware name: Red Hat RHEV Hypervisor, BIOS 1.11.0-2.el7 04/01/2014

The corresponding code in ceph_readdir() is:

	BUG_ON(rde->offset < ctx->pos);

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c   | 13 +++++++------
 fs/ceph/inode.c |  3 ++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index a449f4a07c07..f28eb568e0e2 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -534,6 +534,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 					    .ctext_len	= rde->altname_len };
 		u32 olen = oname.len;
 
+		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
+		if (err) {
+			pr_warn("Unable to decode %.*s. Skipping it.\n", rde->name_len, rde->name);
+			ctx->pos++;
+			continue;
+		}
+
 		BUG_ON(rde->offset < ctx->pos);
 		BUG_ON(!rde->inode.in);
 
@@ -542,12 +549,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		     i, rinfo->dir_nr, ctx->pos,
 		     rde->name_len, rde->name, &rde->inode.in);
 
-		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
-		if (err) {
-			dout("Unable to decode %.*s. Skipping it.\n", rde->name_len, rde->name);
-			continue;
-		}
-
 		if (!dir_emit(ctx, oname.name, oname.len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 8b0832271fdf..b1552e6a6f0e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1898,7 +1898,8 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 
 		err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
 		if (err) {
-			dout("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
+			fpos_offset++;
+			pr_warn("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
 			continue;
 		}
 
-- 
2.27.0

