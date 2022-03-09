Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7962C4D30AD
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 15:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiCIOA1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 09:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiCIOA0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 09:00:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 777F25C67F
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 05:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646834366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x2lVNInJAoKIPwUlNOc1cFHqq6VszF4jJDHuiYGuHIo=;
        b=EE9l0NFsIVFFLuPgvhLJmUfTPe3e8BE1WexRbDCFPhIVNUGXtECEW8qJcUz+ukHT/fRaxD
        47qROGZti6y+VrCMpMqqpRwAO7vXerYE1SfevoAkH41btQKc5CtDfjJarMO/HTDa6qzMd/
        nUJZZ34Tx4OJhVb7aXbXE2OklkHUlVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-mLcbyAojNzeIvnuFxQpSDA-1; Wed, 09 Mar 2022 08:59:23 -0500
X-MC-Unique: mLcbyAojNzeIvnuFxQpSDA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8770CFC82;
        Wed,  9 Mar 2022 13:59:22 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3F3C7B619;
        Wed,  9 Mar 2022 13:59:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH V7] ceph: do not dencrypt the dentry name twice for readdir
Date:   Wed,  9 Mar 2022 21:59:14 +0800
Message-Id: <20220309135914.95804-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the readdir request the dentries will be pasred and dencrypted
in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
get the dentry name from the dentry cache instead of parsing and
dencrypting them again. This could improve performance.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V7:
- Fix the xfstest generic/006 crash bug about the rde->dentry == NULL.

V6:
- Remove CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro and use the NAME_MAX
  instead, since we are limiting the max length of snapshot name to
  240, which is NAME_MAX - 2 * sizeof('_') - sizeof(<inode#>).

V5:
- fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
- release the rde->dentry in destroy_reply_info



 fs/ceph/dir.c        | 56 ++++++++++++++++++++------------------------
 fs/ceph/inode.c      |  7 ++++++
 fs/ceph/mds_client.c |  1 +
 fs/ceph/mds_client.h |  1 +
 4 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 6df2a91af236..2397c34e9173 100644
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
@@ -369,14 +368,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
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
@@ -528,31 +519,36 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			}
 		}
 	}
+
+	dentry_name = kmalloc(NAME_MAX, GFP_KERNEL);
+	if (!dentry_name) {
+		err = -ENOMEM;
+		ceph_mdsc_put_request(dfi->last_readdir);
+		dfi->last_readdir = NULL;
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
+		if (!dir_emit(ctx, dentry_name, name_len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
 			/*
@@ -566,8 +562,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			goto out;
 		}
 
-		/* Reset the lengths to their original allocated vals */
-		oname.len = olen;
 		ctx->pos++;
 	}
 
@@ -625,8 +619,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
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
index b573a0f33450..19e5275eae1c 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1909,6 +1909,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			goto out;
 		}
 
+		rde->dentry = NULL;
 		dname.name = oname.name;
 		dname.len = oname.len;
 		dname.hash = full_name_hash(parent, dname.name, dname.len);
@@ -1969,6 +1970,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
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
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8d704ddd7291..9e0a51ef1dfa 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -733,6 +733,7 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
 
 		kfree(rde->inode.fscrypt_auth);
 		kfree(rde->inode.fscrypt_file);
+		dput(rde->dentry);
 	}
 	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
 }
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

