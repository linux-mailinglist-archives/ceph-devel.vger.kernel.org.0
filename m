Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A584CE4BF
	for <lists+ceph-devel@lfdr.de>; Sat,  5 Mar 2022 13:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiCEM0h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 5 Mar 2022 07:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiCEM0g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 5 Mar 2022 07:26:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0223523B4F5
        for <ceph-devel@vger.kernel.org>; Sat,  5 Mar 2022 04:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646483146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CsCrIII+cgrrAi119v6vu82R1OxqvmFng+Fh8Gh3mRo=;
        b=HHND1rPNN0RygDWx5BEmJLmZu3HGWwa7vHXRK1tt6//PwiDoBI8rPqFLoXREqxR9tieKGw
        HebADkiBgAId9kMqiUJ+XHgbs9NX9ceK3dO5vbzWJFPOR7NA3FXrc0XXQZWCIRw03Jbvvv
        0BEB39icI1sZdMZTZ1NNuxCaembnB6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-2ch2srBVMCycJzlzJG5gMA-1; Sat, 05 Mar 2022 07:25:43 -0500
X-MC-Unique: 2ch2srBVMCycJzlzJG5gMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3B131006AA5;
        Sat,  5 Mar 2022 12:25:41 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D10284962;
        Sat,  5 Mar 2022 12:25:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5] ceph: do not dencrypt the dentry name twice for readdir
Date:   Sat,  5 Mar 2022 20:25:27 +0800
Message-Id: <20220305122527.1102109-1-xiubli@redhat.com>
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

For the readdir request the dentries will be pasred and dencrypted
in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
get the dentry name from the dentry cache instead of parsing and
dencrypting them again. This could improve performance.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V5:
- fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
- release the rde->dentry in destroy_reply_info


 fs/ceph/crypto.h     |  8 ++++++
 fs/ceph/dir.c        | 59 +++++++++++++++++++++-----------------------
 fs/ceph/inode.c      |  7 ++++++
 fs/ceph/mds_client.c |  2 ++
 fs/ceph/mds_client.h |  1 +
 5 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 1e08f8a64ad6..c85cb8c8bd79 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
  */
 #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
 
+/*
+ * The encrypted long snap name will be in format of
+ * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max longth
+ * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) + extra 7
+ * bytes to align the total size to 8 bytes.
+ */
+#define CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
+
 void ceph_fscrypt_set_ops(struct super_block *sb);
 
 void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 6df2a91af236..b30429e2d079 100644
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
@@ -528,31 +519,39 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			}
 		}
 	}
+
+	dentry_name = kmalloc(CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX, GFP_KERNEL);
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
+		dput(dn);
+		rde->dentry = NULL;
+
+		if (!dir_emit(ctx, dentry_name, name_len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
 			/*
@@ -566,8 +565,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			goto out;
 		}
 
-		/* Reset the lengths to their original allocated vals */
-		oname.len = olen;
 		ctx->pos++;
 	}
 
@@ -625,8 +622,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
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
index e5a9838981ba..dfb7b4461857 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1902,6 +1902,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			goto out;
 		}
 
+		rde->dentry = NULL;
 		dname.name = oname.name;
 		dname.len = oname.len;
 		dname.hash = full_name_hash(parent, dname.name, dname.len);
@@ -1962,6 +1963,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
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
index f0d2442187a3..9de749dd715c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -733,6 +733,8 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
 
 		kfree(rde->inode.fscrypt_auth);
 		kfree(rde->inode.fscrypt_file);
+		dput(rde->dentry);
+		rde->dentry = NULL;
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

