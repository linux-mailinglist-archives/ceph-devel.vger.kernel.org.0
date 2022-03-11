Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874494D6009
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 11:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344523AbiCKKrU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 05:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244704AbiCKKrS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 05:47:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C90531C2F4F
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 02:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646995573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oCbueOYqnnydY78l2JV+3i7uHJGdEFMQnS/ebmsYvl0=;
        b=A9jcMHDbcYJsl1NocTco7Cg+aXuEFG1QXhMSTt8qoiXxnFT2EgwU5/BHK9g5yzoqsVZsFP
        t+Pt+Y6Rj0f4fNEyLOk5UNUgHifYUCZ7dryiFLNqAsDe2XhmWdIVBLzyZ9latGIO++0oAJ
        9ICgoVt6UCYjQVZ/q5nNtQuGxWw5/40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-7S3Oty3rOeWmtmEt-WjD6w-1; Fri, 11 Mar 2022 05:46:12 -0500
X-MC-Unique: 7S3Oty3rOeWmtmEt-WjD6w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 239D81091DA1;
        Fri, 11 Mar 2022 10:46:11 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 214B0105706A;
        Fri, 11 Mar 2022 10:46:08 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/4] ceph: dencrypt the dentry names early and once for readdir
Date:   Fri, 11 Mar 2022 18:45:57 +0800
Message-Id: <20220311104558.157283-4-xiubli@redhat.com>
In-Reply-To: <20220311104558.157283-1-xiubli@redhat.com>
References: <20220311104558.157283-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will dencrypt the dentry names when parsing readdir data.
And will always store the dencyrpted dentry names in the struct
ceph_mds_reply_dir_entry. The cryptext(altname) makes no sense
any more after this if it has and it will be overwrited by the
dencrypted dentry name.

Then in both ceph_readdir_prepopulate() and ceph_readdir() we
will use the dencrypted name directly.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/crypto.c     |  5 ++-
 fs/ceph/crypto.h     |  1 +
 fs/ceph/dir.c        | 41 +++++++----------------
 fs/ceph/inode.c      | 37 +++------------------
 fs/ceph/mds_client.c | 79 ++++++++++++++++++++++++++++++++++++++++----
 fs/ceph/mds_client.h |  4 +--
 6 files changed, 96 insertions(+), 71 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 21bb0924bd2a..b5afeb881d9a 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -222,7 +222,10 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	 * generating a nokey name via fscrypt.
 	 */
 	if (!fscrypt_has_encryption_key(fname->dir)) {
-		memcpy(oname->name, fname->name, fname->name_len);
+		if (fname->no_copy)
+			oname->name = fname->name;
+		else
+			memcpy(oname->name, fname->name, fname->name_len);
 		oname->len = fname->name_len;
 		if (is_nokey)
 			*is_nokey = true;
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index f462b96e119b..ee593b8ad07c 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -23,6 +23,7 @@ struct ceph_fname {
 	unsigned char	*ctext;		// binary crypttext (if any)
 	u32		name_len;	// length of name buffer
 	u32		ctext_len;	// length of crypttext
+	bool		no_copy;
 };
 
 /*
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 6df2a91af236..d006ad675c49 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -316,8 +316,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 	int err;
 	unsigned frag = -1;
 	struct ceph_mds_reply_info_parsed *rinfo;
-	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
-	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
 
 	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
 	if (dfi->file_info.flags & CEPH_F_ATEND)
@@ -347,7 +345,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 
 	err = fscrypt_prepare_readdir(inode);
 	if (err)
-		goto out;
+		return err;
 
 	spin_lock(&ci->i_ceph_lock);
 	/* request Fx cap. if have Fx, we don't need to release Fs cap
@@ -369,14 +367,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
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
@@ -421,12 +411,21 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 			req->r_inode_drop = CEPH_CAP_FILE_EXCL;
 		}
 		if (dfi->last_name) {
-			req->r_path2 = kstrdup(dfi->last_name, GFP_KERNEL);
+			struct qstr d_name = { .name = dfi->last_name,
+					       .len = strlen(dfi->last_name) };
+
+			req->r_path2 = kzalloc(NAME_MAX, GFP_KERNEL);
 			if (!req->r_path2) {
 				ceph_mdsc_put_request(req);
 				err = -ENOMEM;
 				goto out;
 			}
+
+			err = ceph_encode_encrypted_dname(inode, &d_name, req->r_path2);
+			if (err < 0) {
+				ceph_mdsc_put_request(req);
+				goto out;
+			}
 		} else if (is_hash_order(ctx->pos)) {
 			req->r_args.readdir.offset_hash =
 				cpu_to_le32(fpos_hash(ctx->pos));
@@ -530,19 +529,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 	}
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
 
 		BUG_ON(rde->offset < ctx->pos);
 		BUG_ON(!rde->inode.in);
@@ -552,7 +538,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		     i, rinfo->dir_nr, ctx->pos,
 		     rde->name_len, rde->name, &rde->inode.in);
 
-		if (!dir_emit(ctx, oname.name, oname.len,
+		if (!dir_emit(ctx, rde->name, rde->name_len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
 			/*
@@ -567,7 +553,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		/* Reset the lengths to their original allocated vals */
-		oname.len = olen;
 		ctx->pos++;
 	}
 
@@ -625,8 +610,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 	err = 0;
 	dout("readdir %p file %p done.\n", inode, file);
 out:
-	ceph_fname_free_buffer(inode, &tname);
-	ceph_fname_free_buffer(inode, &oname);
 	return err;
 }
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b573a0f33450..7b670e2405c1 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1829,8 +1829,6 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 	u32 last_hash = 0;
 	u32 fpos_offset;
 	struct ceph_readdir_cache_control cache_ctl = {};
-	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
-	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
 
 	if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags))
 		return readdir_prepopulate_inodes_only(req, session);
@@ -1882,45 +1880,20 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 	cache_ctl.index = req->r_readdir_cache_idx;
 	fpos_offset = req->r_readdir_offset;
 
-	err = ceph_fname_alloc_buffer(inode, &tname);
-	if (err < 0)
-		goto out;
-
-	err = ceph_fname_alloc_buffer(inode, &oname);
-	if (err < 0)
-		goto out;
-
 	/* FIXME: release caps/leases if error occurs */
 	for (i = 0; i < rinfo->dir_nr; i++) {
-		bool is_nokey = false;
 		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
 		struct ceph_vino tvino;
-		u32 olen = oname.len;
-		struct ceph_fname fname = { .dir	= inode,
-					    .name	= rde->name,
-					    .name_len	= rde->name_len,
-					    .ctext	= rde->altname,
-					    .ctext_len	= rde->altname_len };
-
-		err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
-		if (err) {
-			pr_err("%s unable to decode %.*s, got %d\n", __func__,
-			       rde->name_len, rde->name, err);
-			goto out;
-		}
 
-		dname.name = oname.name;
-		dname.len = oname.len;
+		dname.name = rde->name;
+		dname.len = rde->name_len;
 		dname.hash = full_name_hash(parent, dname.name, dname.len);
-		oname.len = olen;
 
 		tvino.ino = le64_to_cpu(rde->inode.in->ino);
 		tvino.snap = le64_to_cpu(rde->inode.in->snapid);
 
 		if (rinfo->hash_order) {
-			u32 hash = ceph_str_hash(ci->i_dir_layout.dl_dir_hash,
-						 rde->name, rde->name_len);
-			hash = ceph_frag_value(hash);
+			u32 hash = ceph_frag_value(rde->raw_hash);
 			if (hash != last_hash)
 				fpos_offset = 2;
 			last_hash = hash;
@@ -1943,7 +1916,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 				err = -ENOMEM;
 				goto out;
 			}
-			if (is_nokey) {
+			if (rde->is_nokey) {
 				spin_lock(&dn->d_lock);
 				dn->d_flags |= DCACHE_NOKEY_NAME;
 				spin_unlock(&dn->d_lock);
@@ -2036,8 +2009,6 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		req->r_readdir_cache_idx = cache_ctl.index;
 	}
 	ceph_readdir_cache_release(&cache_ctl);
-	ceph_fname_free_buffer(inode, &tname);
-	ceph_fname_free_buffer(inode, &oname);
 	dout("readdir_prepopulate done\n");
 	return err;
 }
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c7113ce655a6..c51b07ec72cf 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -439,20 +439,87 @@ static int parse_reply_info_readdir(void **p, void *end,
 
 	info->dir_nr = num;
 	while (num) {
+		struct inode *inode = d_inode(req->r_dentry);
+		struct ceph_inode_info *ci = ceph_inode(inode);
 		struct ceph_mds_reply_dir_entry *rde = info->dir_entries + i;
+		struct fscrypt_str tname = FSTR_INIT(NULL, 0);
+		struct fscrypt_str oname = FSTR_INIT(NULL, 0);
+		struct ceph_fname fname;
+		u32 altname_len, _name_len;
+		u8 *altname, *_name;
+
 		/* dentry */
-		ceph_decode_32_safe(p, end, rde->name_len, bad);
-		ceph_decode_need(p, end, rde->name_len, bad);
-		rde->name = *p;
-		*p += rde->name_len;
-		dout("parsed dir dname '%.*s'\n", rde->name_len, rde->name);
+		ceph_decode_32_safe(p, end, _name_len, bad);
+		ceph_decode_need(p, end, _name_len, bad);
+		_name = *p;
+		*p += _name_len;
+		dout("parsed dir dname '%.*s'\n", _name_len, _name);
+
+		if (info->hash_order)
+			rde->raw_hash = ceph_str_hash(ci->i_dir_layout.dl_dir_hash,
+						      _name, _name_len);
 
 		/* dentry lease */
 		err = parse_reply_info_lease(p, end, &rde->lease, features,
-					     &rde->altname_len, &rde->altname);
+					     &altname_len, &altname);
 		if (err)
 			goto out_bad;
 
+		/*
+		 * Try to dencrypt the dentry names and update them
+		 * in the ceph_mds_reply_dir_entry struct.
+		 */
+		fname.dir = inode;
+		fname.name = _name;
+		fname.name_len = _name_len;
+		fname.ctext = altname;
+		fname.ctext_len = altname_len;
+		/*
+		 * The _name_len maybe larger than altname_len, such as
+		 * when the human readable name length is in range of
+		 * (CEPH_NOHASH_NAME_MAX, CEPH_NOHASH_NAME_MAX + SHA256_DIGEST_SIZE),
+		 * then the copy in ceph_fname_to_usr will corrupt the
+		 * data if there has no encryption key.
+		 *
+		 * Just set the no_copy flag and then if there has no
+		 * encryption key the oname.name will be assigned to
+		 * _name always.
+		 */
+		fname.no_copy = true;
+		if (altname_len == 0) {
+			/*
+			 * Set tname to _name, and this will be used
+			 * to do the base64_decode in-place. It's
+			 * safe because the decoded string should
+			 * always be shorter, which is 3/4 of origin
+			 * string.
+			 */
+			tname.name = _name;
+
+			/*
+			 * Set oname to _name too, and this will be
+			 * used to do the dencryption in-place.
+			 */
+			oname.name = _name;
+			oname.len = _name_len;
+		} else {
+			/*
+			 * This will do the decryption only in-place
+			 * from altname cryptext directly.
+			 */
+			oname.name = altname;
+			oname.len = altname_len;
+		}
+		rde->is_nokey = false;
+		err = ceph_fname_to_usr(&fname, &tname, &oname, &rde->is_nokey);
+		if (err) {
+			pr_err("%s unable to decode %.*s, got %d\n", __func__,
+			       _name_len, _name, err);
+			goto out_bad;
+		}
+		rde->name = oname.name;
+		rde->name_len = oname.len;
+
 		/* inode */
 		err = parse_reply_info_in(p, end, &rde->inode, features);
 		if (err < 0)
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 0dfe24f94567..e297bf98c39f 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -96,10 +96,10 @@ struct ceph_mds_reply_info_in {
 };
 
 struct ceph_mds_reply_dir_entry {
+	bool			      is_nokey;
 	char                          *name;
-	u8			      *altname;
 	u32                           name_len;
-	u32			      altname_len;
+	u32			      raw_hash;
 	struct ceph_mds_reply_lease   *lease;
 	struct ceph_mds_reply_info_in inode;
 	loff_t			      offset;
-- 
2.27.0

