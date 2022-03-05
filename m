Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAD74CE4AF
	for <lists+ceph-devel@lfdr.de>; Sat,  5 Mar 2022 13:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiCELyB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 5 Mar 2022 06:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiCELyB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 5 Mar 2022 06:54:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA6D62241EF
        for <ceph-devel@vger.kernel.org>; Sat,  5 Mar 2022 03:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646481189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yMAbji8aIHid6ODw5/PyJaxxUr116KmeRjsfZR+KOxI=;
        b=B75V35aT+8mFRzgSVzm48UfYB9hJeDE25vsn7068EABxo+p0BGj05PbK6ACNX5CnU6gdJV
        tzojDul2wmccKKoV+Vc9K8dOH8UWYX5tiT7jfOCUiQ2OyV/MildgxJI0kNgrbwo3W/Grwg
        0LD6d5Xuq3XoW7vh3d6mzHDf9R9iUSo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-OoC0noXjO8a_F_lzr565Dw-1; Sat, 05 Mar 2022 06:53:08 -0500
X-MC-Unique: OoC0noXjO8a_F_lzr565Dw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56CBF1006AA5;
        Sat,  5 Mar 2022 11:53:07 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DADAF5C629;
        Sat,  5 Mar 2022 11:53:01 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: fix memory leakage in ceph_readdir
Date:   Sat,  5 Mar 2022 19:52:59 +0800
Message-Id: <20220305115259.1076790-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Reset the last_readdir at the same time.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 6be0c1f793c2..6df2a91af236 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -498,8 +498,11 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 					2 : (fpos_off(rde->offset) + 1);
 			err = note_last_dentry(dfi, rde->name, rde->name_len,
 					       next_offset);
-			if (err)
+			if (err) {
+				ceph_mdsc_put_request(dfi->last_readdir);
+				dfi->last_readdir = NULL;
 				goto out;
+			}
 		} else if (req->r_reply_info.dir_end) {
 			dfi->next_offset = 2;
 			/* keep last name */
@@ -552,6 +555,12 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		if (!dir_emit(ctx, oname.name, oname.len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
+			/*
+			 * NOTE: Here no need to put the 'dfi->last_readdir',
+			 * because when dir_emit stops us it's most likely
+			 * doesn't have enough memory, etc. So for next readdir
+			 * it will continue.
+			 */
 			dout("filldir stopping us...\n");
 			err = 0;
 			goto out;
-- 
2.27.0

