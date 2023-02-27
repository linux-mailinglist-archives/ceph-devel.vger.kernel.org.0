Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508996A39AD
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjB0Dcm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjB0Dck (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:32:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849051B319
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wRgQ26xf61VPoRziREj1uh+DnrCWoGLpO2Og4KMMydA=;
        b=MLK7HuGe+++SZM8kRDZPBGjTEbMWpgpphuMS0+fl52kNfKUBljoRTpc1+DuUzy+PnT5aun
        E3V5lBR87FgFrnDEXauOucomk57DAQRZaKnux9t3jVQxUzr9dgUrM8Gh3TncKUtB8kUpUA
        WXRd/qUOoUEpm0Nb/bU2jjrmhOGEYQA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-hMIOhL-mN6CS-Tq4qujFUA-1; Sun, 26 Feb 2023 22:31:07 -0500
X-MC-Unique: hMIOhL-mN6CS-Tq4qujFUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28A5E101AA63;
        Mon, 27 Feb 2023 03:31:07 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 590191731B;
        Mon, 27 Feb 2023 03:31:04 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 48/68] ceph: add infrastructure for file encryption and decryption
Date:   Mon, 27 Feb 2023 11:27:53 +0800
Message-Id: <20230227032813.337906-49-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

...and allow test_dummy_encryption to bypass content encryption
if mounted with test_dummy_encryption=clear.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 177 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/crypto.h |  71 +++++++++++++++++++
 fs/ceph/super.c  |   6 ++
 fs/ceph/super.h  |   1 +
 4 files changed, 255 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index fe47fbdaead9..35e292045e9d 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -9,6 +9,7 @@
 #include <linux/ceph/ceph_debug.h>
 #include <linux/xattr.h>
 #include <linux/fscrypt.h>
+#include <linux/ceph/striper.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -354,3 +355,179 @@ int ceph_fscrypt_prepare_readdir(struct inode *dir)
 	}
 	return 0;
 }
+
+int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
+				  struct page *page, unsigned int len,
+				  unsigned int offs, u64 lblk_num)
+{
+	struct ceph_mount_options *opt = ceph_inode_to_client(inode)->mount_options;
+
+	if (opt->flags & CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR)
+		return 0;
+
+	dout("%s: len %u offs %u blk %llu\n", __func__, len, offs, lblk_num);
+	return fscrypt_decrypt_block_inplace(inode, page, len, offs, lblk_num);
+}
+
+int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
+				  struct page *page, unsigned int len,
+				  unsigned int offs, u64 lblk_num, gfp_t gfp_flags)
+{
+	struct ceph_mount_options *opt = ceph_inode_to_client(inode)->mount_options;
+
+	if (opt->flags & CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR)
+		return 0;
+
+	dout("%s: len %u offs %u blk %llu\n", __func__, len, offs, lblk_num);
+	return fscrypt_encrypt_block_inplace(inode, page, len, offs, lblk_num, gfp_flags);
+}
+
+/**
+ * ceph_fscrypt_decrypt_pages - decrypt an array of pages
+ * @inode: pointer to inode associated with these pages
+ * @page: pointer to page array
+ * @off: offset into the file that the read data starts
+ * @len: max length to decrypt
+ *
+ * Decrypt an array of fscrypt'ed pages and return the amount of
+ * data decrypted. Any data in the page prior to the start of the
+ * first complete block in the read is ignored. Any incomplete
+ * crypto blocks at the end of the array are ignored (and should
+ * probably be zeroed by the caller).
+ *
+ * Returns the length of the decrypted data or a negative errno.
+ */
+int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page, u64 off, int len)
+{
+	int i, num_blocks;
+	u64 baseblk = off >> CEPH_FSCRYPT_BLOCK_SHIFT;
+	int ret = 0;
+
+	/*
+	 * We can't deal with partial blocks on an encrypted file, so mask off
+	 * the last bit.
+	 */
+	num_blocks = ceph_fscrypt_blocks(off, len & CEPH_FSCRYPT_BLOCK_MASK);
+
+	/* Decrypt each block */
+	for (i = 0; i < num_blocks; ++i) {
+		int blkoff = i << CEPH_FSCRYPT_BLOCK_SHIFT;
+		int pgidx = blkoff >> PAGE_SHIFT;
+		unsigned int pgoffs = offset_in_page(blkoff);
+		int fret;
+
+		fret = ceph_fscrypt_decrypt_block_inplace(inode, page[pgidx],
+				CEPH_FSCRYPT_BLOCK_SIZE, pgoffs,
+				baseblk + i);
+		if (fret < 0) {
+			if (ret == 0)
+				ret = fret;
+			break;
+		}
+		ret += CEPH_FSCRYPT_BLOCK_SIZE;
+	}
+	return ret;
+}
+
+/**
+ * ceph_fscrypt_decrypt_extents: decrypt received extents in given buffer
+ * @inode: inode associated with pages being decrypted
+ * @page: pointer to page array
+ * @off: offset into the file that the data in page[0] starts
+ * @map: pointer to extent array
+ * @ext_cnt: length of extent array
+ *
+ * Given an extent map and a page array, decrypt the received data in-place,
+ * skipping holes. Returns the offset into buffer of end of last decrypted
+ * block.
+ */
+int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page, u64 off,
+				 struct ceph_sparse_extent *map, u32 ext_cnt)
+{
+	int i, ret = 0;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	u64 objno, objoff;
+	u32 xlen;
+
+	/* Nothing to do for empty array */
+	if (ext_cnt == 0) {
+		dout("%s: empty array, ret 0\n", __func__);
+		return 0;
+	}
+
+	ceph_calc_file_object_mapping(&ci->i_layout, off, map[0].len,
+				      &objno, &objoff, &xlen);
+
+	for (i = 0; i < ext_cnt; ++i) {
+		struct ceph_sparse_extent *ext = &map[i];
+		int pgsoff = ext->off - objoff;
+		int pgidx = pgsoff >> PAGE_SHIFT;
+		int fret;
+
+		if ((ext->off | ext->len) & ~CEPH_FSCRYPT_BLOCK_MASK) {
+			pr_warn("%s: bad encrypted sparse extent idx %d off %llx len %llx\n",
+				__func__, i, ext->off, ext->len);
+			return -EIO;
+		}
+		fret = ceph_fscrypt_decrypt_pages(inode, &page[pgidx],
+						 off + pgsoff, ext->len);
+		dout("%s: [%d] 0x%llx~0x%llx fret %d\n", __func__, i,
+				ext->off, ext->len, fret);
+		if (fret < 0) {
+			if (ret == 0)
+				ret = fret;
+			break;
+		}
+		ret = pgsoff + fret;
+	}
+	dout("%s: ret %d\n", __func__, ret);
+	return ret;
+}
+
+/**
+ * ceph_fscrypt_encrypt_pages - encrypt an array of pages
+ * @inode: pointer to inode associated with these pages
+ * @page: pointer to page array
+ * @off: offset into the file that the data starts
+ * @len: max length to encrypt
+ * @gfp: gfp flags to use for allocation
+ *
+ * Decrypt an array of cleartext pages and return the amount of
+ * data encrypted. Any data in the page prior to the start of the
+ * first complete block in the read is ignored. Any incomplete
+ * crypto blocks at the end of the array are ignored.
+ *
+ * Returns the length of the encrypted data or a negative errno.
+ */
+int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
+				int len, gfp_t gfp)
+{
+	int i, num_blocks;
+	u64 baseblk = off >> CEPH_FSCRYPT_BLOCK_SHIFT;
+	int ret = 0;
+
+	/*
+	 * We can't deal with partial blocks on an encrypted file, so mask off
+	 * the last bit.
+	 */
+	num_blocks = ceph_fscrypt_blocks(off, len & CEPH_FSCRYPT_BLOCK_MASK);
+
+	/* Encrypt each block */
+	for (i = 0; i < num_blocks; ++i) {
+		int blkoff = i << CEPH_FSCRYPT_BLOCK_SHIFT;
+		int pgidx = blkoff >> PAGE_SHIFT;
+		unsigned int pgoffs = offset_in_page(blkoff);
+		int fret;
+
+		fret = ceph_fscrypt_encrypt_block_inplace(inode, page[pgidx],
+				CEPH_FSCRYPT_BLOCK_SIZE, pgoffs,
+				baseblk + i, gfp);
+		if (fret < 0) {
+			if (ret == 0)
+				ret = fret;
+			break;
+		}
+		ret += CEPH_FSCRYPT_BLOCK_SIZE;
+	}
+	return ret;
+}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 80acb23d0bb4..887f191cc423 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -100,6 +100,40 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 			struct fscrypt_str *oname, bool *is_nokey);
 int ceph_fscrypt_prepare_readdir(struct inode *dir);
 
+static inline unsigned int ceph_fscrypt_blocks(u64 off, u64 len)
+{
+	/* crypto blocks cannot span more than one page */
+	BUILD_BUG_ON(CEPH_FSCRYPT_BLOCK_SHIFT > PAGE_SHIFT);
+
+	return ((off+len+CEPH_FSCRYPT_BLOCK_SIZE-1) >> CEPH_FSCRYPT_BLOCK_SHIFT) -
+		(off >> CEPH_FSCRYPT_BLOCK_SHIFT);
+}
+
+/*
+ * If we have an encrypted inode then we must adjust the offset and
+ * range of the on-the-wire read to cover an entire encryption block.
+ * The copy will be done using the original offset and length, after
+ * we've decrypted the result.
+ */
+static inline void ceph_fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64 *len)
+{
+	if (IS_ENCRYPTED(inode)) {
+		*len = ceph_fscrypt_blocks(*off, *len) * CEPH_FSCRYPT_BLOCK_SIZE;
+		*off &= CEPH_FSCRYPT_BLOCK_MASK;
+	}
+}
+
+int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
+				  struct page *page, unsigned int len,
+				  unsigned int offs, u64 lblk_num);
+int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
+				  struct page *page, unsigned int len,
+				  unsigned int offs, u64 lblk_num, gfp_t gfp_flags);
+int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page, u64 off, int len);
+int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page, u64 off,
+				 struct ceph_sparse_extent *map, u32 ext_cnt);
+int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
+				int len, gfp_t gfp);
 #else /* CONFIG_FS_ENCRYPTION */
 
 static inline void ceph_fscrypt_set_ops(struct super_block *sb)
@@ -157,6 +191,43 @@ static inline int ceph_fscrypt_prepare_readdir(struct inode *dir)
 {
 	return 0;
 }
+
+static inline void ceph_fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64 *len)
+{
+}
+
+static inline int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
+					  struct page *page, unsigned int len,
+					  unsigned int offs, u64 lblk_num)
+{
+	return 0;
+}
+
+static inline int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
+				  struct page *page, unsigned int len,
+				  unsigned int offs, u64 lblk_num, gfp_t gfp_flags)
+{
+	return 0;
+}
+
+static inline int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page,
+					     u64 off, int len)
+{
+	return 0;
+}
+
+static inline int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
+					u64 off, struct ceph_sparse_extent *map,
+					u32 ext_cnt)
+{
+	return 0;
+}
+
+static inline int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page,
+					     u64 off, int len, gfp_t gfp)
+{
+	return 0;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 #endif
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 3db6f95768a3..f10a076f47e5 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -591,6 +591,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		break;
 	case Opt_test_dummy_encryption:
 #ifdef CONFIG_FS_ENCRYPTION
+		/* HACK: allow for cleartext "encryption" in files for testing */
+		if (param->string && !strcmp(param->string, "clear")) {
+			fsopt->flags |= CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR;
+			kfree(param->string);
+			param->string = NULL;
+		}
 		fscrypt_free_dummy_policy(&fsopt->dummy_enc_policy);
 		ret = fscrypt_parse_test_dummy_encryption(param,
 						&fsopt->dummy_enc_policy);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 38f99eaf083e..300e93bd3972 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -44,6 +44,7 @@
 #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
 #define CEPH_MOUNT_OPT_NOPAGECACHE     (1<<16) /* bypass pagecache altogether */
 #define CEPH_MOUNT_OPT_SPARSEREAD      (1<<17) /* always do sparse reads */
+#define CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR (1<<18) /* don't actually encrypt content */
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-- 
2.31.1

