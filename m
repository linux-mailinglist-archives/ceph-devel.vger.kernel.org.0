Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB285A1254
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiHYNcV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242740AbiHYNb7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6D5B14F0
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24B26B829C4
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA9DC433D7;
        Thu, 25 Aug 2022 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434310;
        bh=XXf8h/YM09DfjuKDYCA0ZVKsdSkqTGHdHgIPYZu1QQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoYGBiNKZ9Qk4aOjjIGucDv68hljhD0mbiQfvcvkIN3pLtcTnhJYPIW3MwzNJe2nS
         pATpt2wUCasHVjl+EjGMtxGrHM3iBC+YZ2lQ6JDhSRcPlwvlvWNsrRN9yuiQUSiMEa
         GLVCfQASVhSmiKgek+BLdeM3ZNUPL1GLR9eBSazHJ/TlmhqtcHpy6goA8ZSSYyDu1e
         NKSbmEFLHAlkwrj9d5UZz3HgMGxj4ixUdFEMe6r3R7EXtrHvro6H3zB4fVksyn9Trf
         qhmm+yX40uQUNBNeMq6nG9ER8KNeLmGSrQHKtUncrpetUvKbqsPL9fbrMd/MGKEqi9
         XNFTyv/s8VaGg==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 23/29] ceph: fscrypt support for writepages
Date:   Thu, 25 Aug 2022 09:31:26 -0400
Message-Id: <20220825133132.153657-24-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add the appropriate machinery to write back dirty data with encryption.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c   | 63 +++++++++++++++++++++++++++++++++++++++---------
 fs/ceph/crypto.h | 18 +++++++++++++-
 2 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f76586984d80..22dd77122aa1 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -559,10 +559,12 @@ static u64 get_writepages_data_length(struct inode *inode,
 				      struct page *page, u64 start)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_snap_context *snapc = page_snap_context(page);
+	struct ceph_snap_context *snapc;
 	struct ceph_cap_snap *capsnap = NULL;
 	u64 end = i_size_read(inode);
+	u64 ret;
 
+	snapc = page_snap_context(ceph_fscrypt_pagecache_page(page));
 	if (snapc != ci->i_head_snapc) {
 		bool found = false;
 		spin_lock(&ci->i_ceph_lock);
@@ -577,9 +579,12 @@ static u64 get_writepages_data_length(struct inode *inode,
 		spin_unlock(&ci->i_ceph_lock);
 		WARN_ON(!found);
 	}
-	if (end > page_offset(page) + thp_size(page))
-		end = page_offset(page) + thp_size(page);
-	return end > start ? end - start : 0;
+	if (end > ceph_fscrypt_page_offset(page) + thp_size(page))
+		end = ceph_fscrypt_page_offset(page) + thp_size(page);
+	ret = end > start ? end - start : 0;
+	if (ret && fscrypt_is_bounce_page(page))
+		ret = round_up(ret, CEPH_FSCRYPT_BLOCK_SIZE);
+	return ret;
 }
 
 /*
@@ -806,6 +811,11 @@ static void writepages_finish(struct ceph_osd_request *req)
 		total_pages += num_pages;
 		for (j = 0; j < num_pages; j++) {
 			page = osd_data->pages[j];
+			if (fscrypt_is_bounce_page(page)) {
+				page = fscrypt_pagecache_page(page);
+				fscrypt_free_bounce_page(osd_data->pages[j]);
+				osd_data->pages[j] = page;
+			}
 			BUG_ON(!page);
 			WARN_ON(!PageUptodate(page));
 
@@ -1067,9 +1077,28 @@ static int ceph_writepages_start(struct address_space *mapping,
 				    fsc->mount_options->congestion_kb))
 				fsc->write_congested = true;
 
-			pages[locked_pages++] = page;
-			pvec.pages[i] = NULL;
+			if (IS_ENCRYPTED(inode)) {
+				pages[locked_pages] =
+					fscrypt_encrypt_pagecache_blocks(page,
+						PAGE_SIZE, 0,
+						locked_pages ? GFP_NOWAIT : GFP_NOFS);
+				if (IS_ERR(pages[locked_pages])) {
+					if (PTR_ERR(pages[locked_pages]) == -EINVAL)
+						pr_err("%s: inode->i_blkbits=%hhu\n",
+							__func__, inode->i_blkbits);
+					/* better not fail on first page! */
+					BUG_ON(locked_pages == 0);
+					pages[locked_pages] = NULL;
+					redirty_page_for_writepage(wbc, page);
+					unlock_page(page);
+					break;
+				}
+				++locked_pages;
+			} else {
+				pages[locked_pages++] = page;
+			}
 
+			pvec.pages[i] = NULL;
 			len += thp_size(page);
 		}
 
@@ -1097,7 +1126,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 		}
 
 new_request:
-		offset = page_offset(pages[0]);
+		offset = ceph_fscrypt_page_offset(pages[0]);
 		len = wsize;
 
 		req = ceph_osdc_new_request(&fsc->client->osdc,
@@ -1118,8 +1147,8 @@ static int ceph_writepages_start(struct address_space *mapping,
 						ceph_wbc.truncate_size, true);
 			BUG_ON(IS_ERR(req));
 		}
-		BUG_ON(len < page_offset(pages[locked_pages - 1]) +
-			     thp_size(page) - offset);
+		BUG_ON(len < ceph_fscrypt_page_offset(pages[locked_pages - 1]) +
+			     thp_size(pages[locked_pages - 1]) - offset);
 
 		req->r_callback = writepages_finish;
 		req->r_inode = inode;
@@ -1129,7 +1158,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 		data_pages = pages;
 		op_idx = 0;
 		for (i = 0; i < locked_pages; i++) {
-			u64 cur_offset = page_offset(pages[i]);
+			struct page *page = ceph_fscrypt_pagecache_page(pages[i]);
+
+			u64 cur_offset = page_offset(page);
 			/*
 			 * Discontinuity in page range? Ceph can handle that by just passing
 			 * multiple extents in the write op.
@@ -1158,9 +1189,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 				op_idx++;
 			}
 
-			set_page_writeback(pages[i]);
+			set_page_writeback(page);
 			if (caching)
-				ceph_set_page_fscache(pages[i]);
+				ceph_set_page_fscache(page);
 			len += thp_size(page);
 		}
 		ceph_fscache_write_to_cache(inode, offset, len, caching);
@@ -1176,8 +1207,16 @@ static int ceph_writepages_start(struct address_space *mapping,
 							 offset);
 			len = max(len, min_len);
 		}
+		if (IS_ENCRYPTED(inode))
+			len = round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
+
 		dout("writepages got pages at %llu~%llu\n", offset, len);
 
+		if (IS_ENCRYPTED(inode) &&
+		    ((offset | len) & ~CEPH_FSCRYPT_BLOCK_MASK))
+			pr_warn("%s: bad encrypted write offset=%lld len=%llu\n",
+				__func__, offset, len);
+
 		osd_req_op_extent_osd_data_pages(req, op_idx, data_pages, len,
 						 0, from_pool, false);
 		osd_req_op_extent_update(req, op_idx, len);
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index bfda2220cb78..d1726307bdb8 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -154,6 +154,12 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page, u64 of
 				 struct ceph_sparse_extent *map, u32 ext_cnt);
 int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
 				int len, gfp_t gfp);
+
+static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
+{
+	return fscrypt_is_bounce_page(page) ?  fscrypt_pagecache_page(page) : page;
+}
+
 #else /* CONFIG_FS_ENCRYPTION */
 
 static inline void ceph_fscrypt_set_ops(struct super_block *sb)
@@ -243,6 +249,16 @@ static inline int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **
 {
 	return 0;
 }
+
+static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
+{
+	return page;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
-#endif
+static inline loff_t ceph_fscrypt_page_offset(struct page *page)
+{
+	return page_offset(ceph_fscrypt_pagecache_page(page));
+}
+
+#endif /* _CEPH_CRYPTO_H */
-- 
2.37.2

