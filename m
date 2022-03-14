Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5B24D795D
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Mar 2022 03:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiCNCaK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Mar 2022 22:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiCNCaK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 13 Mar 2022 22:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7885D1ADBA
        for <ceph-devel@vger.kernel.org>; Sun, 13 Mar 2022 19:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647224940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mfNgsdI8RG6aj8pEWrC8bPJSDXWlAs0RZiHR5JW6XOY=;
        b=SIGhWA0XhbiN/hAFYtflTnM/sJDjCxJ+GfpR8GsTC6b/bmgqtVZPsUM+of9WZ8N+Vfa5gk
        mV/kPXWBISCTjQ+YKpCNJlp9ZjTF8AINpxr/qdYAHUce+yrTdphq9+fKG5lJWYWqv9qSc0
        3dfq9/A9RP6EPv8+H2Q0okv2WWETJtI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-hqx479O6MqG1_e2q8JcNIw-1; Sun, 13 Mar 2022 22:28:57 -0400
X-MC-Unique: hqx479O6MqG1_e2q8JcNIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1832E3806702;
        Mon, 14 Mar 2022 02:28:57 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96997145F971;
        Mon, 14 Mar 2022 02:28:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 4/4] ceph: clean up the ceph_readdir() code
Date:   Mon, 14 Mar 2022 10:28:37 +0800
Message-Id: <20220314022837.32303-5-xiubli@redhat.com>
In-Reply-To: <20220314022837.32303-1-xiubli@redhat.com>
References: <20220314022837.32303-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 6f9af69b11c7..5ae5cb778389 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -394,14 +394,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		dout("readdir fetching %llx.%llx frag %x offset '%s'\n",
 		     ceph_vinop(inode), frag, dfi->last_name);
 		req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
-		if (IS_ERR(req)) {
-			err = PTR_ERR(req);
-			goto out;
-		}
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+
 		err = ceph_alloc_readdir_reply_buffer(req, inode);
 		if (err) {
 			ceph_mdsc_put_request(req);
-			goto out;
+			return err;
 		}
 		/* hints to request -> mds selection code */
 		req->r_direct_mode = USE_AUTH_MDS;
@@ -417,14 +416,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			req->r_path2 = kzalloc(NAME_MAX + 1, GFP_KERNEL);
 			if (!req->r_path2) {
 				ceph_mdsc_put_request(req);
-				err = -ENOMEM;
-				goto out;
+				return -ENOMEM;
 			}
 
 			err = ceph_encode_encrypted_dname(inode, &d_name, req->r_path2);
 			if (err < 0) {
 				ceph_mdsc_put_request(req);
-				goto out;
+				return err;
 			}
 		} else if (is_hash_order(ctx->pos)) {
 			req->r_args.readdir.offset_hash =
@@ -445,7 +443,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		err = ceph_mdsc_do_request(mdsc, NULL, req);
 		if (err < 0) {
 			ceph_mdsc_put_request(req);
-			goto out;
+			return err;
 		}
 		dout("readdir got and parsed readdir result=%d on "
 		     "frag %x, end=%d, complete=%d, hash_order=%d\n",
@@ -500,7 +498,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			if (err) {
 				ceph_mdsc_put_request(dfi->last_readdir);
 				dfi->last_readdir = NULL;
-				goto out;
+				return err;
 			}
 		} else if (req->r_reply_info.dir_end) {
 			dfi->next_offset = 2;
@@ -548,8 +546,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			 * it will continue.
 			 */
 			dout("filldir stopping us...\n");
-			err = 0;
-			goto out;
+			return 0;
 		}
 
 		/* Reset the lengths to their original allocated vals */
@@ -607,10 +604,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 					dfi->dir_ordered_count);
 		spin_unlock(&ci->i_ceph_lock);
 	}
-	err = 0;
 	dout("readdir %p file %p done.\n", inode, file);
-out:
-	return err;
+	return 0;
 }
 
 static void reset_readdir(struct ceph_dir_file_info *dfi)
-- 
2.27.0

