Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CA64C8AC9
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 12:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiCALcI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 06:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbiCALcG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 06:32:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B81195F8E9
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 03:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646134280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aLTIHIi0HP06Qa2fyBPhTC5jp/VPy3itHyu9y+jwyYc=;
        b=iHP4yvkPKn/DCnTzMQdXkMe8MT3Hav3lr90vdSNTEQo8HBqv6z1lSMfyh7LMeMbL6RyTXY
        UWLLwb7IpDQIKktJNBCLOea2X2vRJB/crjEm3OjGz9L1fKmT2RDGJCJG5KcmhR14NUyw4S
        VbJoE9cErQHRuHDclv3ZJNSAQ2nUX30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-fCE_oASyP_aQLzvNB4O_kg-1; Tue, 01 Mar 2022 06:31:17 -0500
X-MC-Unique: fCE_oASyP_aQLzvNB4O_kg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AED2D1091DA1;
        Tue,  1 Mar 2022 11:31:16 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 581B183195;
        Tue,  1 Mar 2022 11:31:06 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 3/7] ceph: do not dencrypt the dentry name twice for readdir
Date:   Tue,  1 Mar 2022 19:30:11 +0800
Message-Id: <20220301113015.498041-4-xiubli@redhat.com>
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

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c        | 66 +++++++++++++++++++++-----------------------
 fs/ceph/inode.c      | 15 ++++++++++
 fs/ceph/mds_client.h |  1 +
 3 files changed, 47 insertions(+), 35 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 6be0c1f793c2..e3917b4426e8 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 	int err;
 	unsigned frag = -1;
 	struct ceph_mds_reply_info_parsed *rinfo;
-	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
-	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
+	char *dentry_name = NULL;
 
 	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
 	if (dfi->file_info.flags & CEPH_F_ATEND)
@@ -345,10 +344,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		ctx->pos = 2;
 	}
 
-	err = fscrypt_prepare_readdir(inode);
-	if (err)
-		goto out;
-
 	spin_lock(&ci->i_ceph_lock);
 	/* request Fx cap. if have Fx, we don't need to release Fs cap
 	 * for later create/unlink. */
@@ -369,14 +364,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		spin_unlock(&ci->i_ceph_lock);
 	}
 
-	err = ceph_fname_alloc_buffer(inode, &tname);
-	if (err < 0)
-		goto out;
-
-	err = ceph_fname_alloc_buffer(inode, &oname);
-	if (err < 0)
-		goto out;
-
 	/* proceed with a normal readdir */
 more:
 	/* do we have the correct frag content buffered? */
@@ -525,40 +512,49 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			}
 		}
 	}
+
+	dentry_name = kmalloc(280, GFP_KERNEL);
+	if (!dentry_name) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	for (; i < rinfo->dir_nr; i++) {
 		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
-		struct ceph_fname fname = { .dir	= inode,
-					    .name	= rde->name,
-					    .name_len	= rde->name_len,
-					    .ctext	= rde->altname,
-					    .ctext_len	= rde->altname_len };
-		u32 olen = oname.len;
-
-		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
-		if (err) {
-			pr_err("%s unable to decode %.*s, got %d\n", __func__,
-			       rde->name_len, rde->name, err);
-			goto out;
-		}
+		struct dentry *dn = rde->dentry;
+		int name_len;
 
 		BUG_ON(rde->offset < ctx->pos);
 		BUG_ON(!rde->inode.in);
+		BUG_ON(!rde->dentry);
 
 		ctx->pos = rde->offset;
-		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
-		     i, rinfo->dir_nr, ctx->pos,
-		     rde->name_len, rde->name, &rde->inode.in);
 
-		if (!dir_emit(ctx, oname.name, oname.len,
+		spin_lock(&dn->d_lock);
+		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
+		name_len = dn->d_name.len;
+		spin_unlock(&dn->d_lock);
+
+		dentry_name[name_len] = '\0';
+		dout("readdir (%d/%d) -> %llx '%s' %p\n",
+		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
+
+		dput(dn);
+		rde->dentry = NULL;
+
+		if (!dir_emit(ctx, dentry_name, name_len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
 			dout("filldir stopping us...\n");
 			err = 0;
+			for (; i < rinfo->dir_nr; i++) {
+				rde = rinfo->dir_entries + i;
+				dput(rde->dentry);
+				rde->dentry = NULL;
+			}
 			goto out;
 		}
 
-		/* Reset the lengths to their original allocated vals */
-		oname.len = olen;
 		ctx->pos++;
 	}
 
@@ -616,8 +612,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 	err = 0;
 	dout("readdir %p file %p done.\n", inode, file);
 out:
-	ceph_fname_free_buffer(inode, &tname);
-	ceph_fname_free_buffer(inode, &oname);
+	if (dentry_name)
+		kfree(dentry_name);
 	return err;
 }
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2bc2f02b84e8..877e699fe43b 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1903,6 +1903,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			goto out;
 		}
 
+		rde->dentry = NULL;
 		dname.name = oname.name;
 		dname.len = oname.len;
 		dname.hash = full_name_hash(parent, dname.name, dname.len);
@@ -1963,6 +1964,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			goto retry_lookup;
 		}
 
+		/*
+		 * ceph_readdir will use the dentry to get the name
+		 * to avoid doing the dencrypt again there.
+		 */
+		rde->dentry = dget(dn);
+
 		/* inode */
 		if (d_really_is_positive(dn)) {
 			in = d_inode(dn);
@@ -2025,6 +2032,14 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		dput(dn);
 	}
 out:
+	if (err) {
+		for (; i >= 0; i--) {
+			struct ceph_mds_reply_dir_entry *rde;
+
+			rde = rinfo->dir_entries + i;
+			dput(rde->dentry);
+		}
+	}
 	if (err == 0 && skipped == 0) {
 		set_bit(CEPH_MDS_R_DID_PREPOPULATE, &req->r_req_flags);
 		req->r_readdir_cache_idx = cache_ctl.index;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 0dfe24f94567..663d7754d57d 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
 };
 
 struct ceph_mds_reply_dir_entry {
+	struct dentry		      *dentry;
 	char                          *name;
 	u8			      *altname;
 	u32                           name_len;
-- 
2.27.0

