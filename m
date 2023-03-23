Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0778B6C604C
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 08:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjCWHBX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 03:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCWHBH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 03:01:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFCF1E9C9
        for <ceph-devel@vger.kernel.org>; Thu, 23 Mar 2023 00:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BLzkLH5hNx/S71UGacF7OO0vmytYNsjIIh/GITMv7Ow=;
        b=aQPDV8EeV2r5o5FDY7UFhd+imuXLMEENfXEV1ez39S2OUnwBxu7BLmffWKiRrcagkc6PdR
        zAJ5xdD5gxNa916S8FIaS9zWiv8pCC5EBtLNuBFYkxjL2Zb6XDEv0wVfDruxVQvh28inPc
        wcywH2pz5YMv576ta1ZopTjV3gDa9oU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-GA8ghGR0MwuH_K7FcD1kNQ-1; Thu, 23 Mar 2023 02:59:06 -0400
X-MC-Unique: GA8ghGR0MwuH_K7FcD1kNQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B6DB3C0F1A6;
        Thu, 23 Mar 2023 06:59:06 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF706492B01;
        Thu, 23 Mar 2023 06:59:03 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 60/71] ceph: fscrypt support for writepages
Date:   Thu, 23 Mar 2023 14:55:14 +0800
Message-Id: <20230323065525.201322-61-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Add the appropriate machinery to write back dirty data with encryption.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c   | 63 +++++++++++++++++++++++++++++++++++++++---------
 fs/ceph/crypto.h | 18 +++++++++++++-
 2 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index b47de8891efc..24fac903bff3 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -562,10 +562,12 @@ static u64 get_writepages_data_length(struct inode *inode,
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
@@ -580,9 +582,12 @@ static u64 get_writepages_data_length(struct inode *inode,
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
@@ -812,6 +817,11 @@ static void writepages_finish(struct ceph_osd_request *req)
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
 
@@ -1073,9 +1083,28 @@ static int ceph_writepages_start(struct address_space *mapping,
 				    fsc->mount_options->congestion_kb))
 				fsc->write_congested = true;
 
-			pages[locked_pages++] = page;
-			fbatch.folios[i] = NULL;
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
 
+			fbatch.folios[i] = NULL;
 			len += thp_size(page);
 		}
 
@@ -1103,7 +1132,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 		}
 
 new_request:
-		offset = page_offset(pages[0]);
+		offset = ceph_fscrypt_page_offset(pages[0]);
 		len = wsize;
 
 		req = ceph_osdc_new_request(&fsc->client->osdc,
@@ -1124,8 +1153,8 @@ static int ceph_writepages_start(struct address_space *mapping,
 						ceph_wbc.truncate_size, true);
 			BUG_ON(IS_ERR(req));
 		}
-		BUG_ON(len < page_offset(pages[locked_pages - 1]) +
-			     thp_size(page) - offset);
+		BUG_ON(len < ceph_fscrypt_page_offset(pages[locked_pages - 1]) +
+			     thp_size(pages[locked_pages - 1]) - offset);
 
 		req->r_callback = writepages_finish;
 		req->r_inode = inode;
@@ -1135,7 +1164,9 @@ static int ceph_writepages_start(struct address_space *mapping,
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
@@ -1164,9 +1195,9 @@ static int ceph_writepages_start(struct address_space *mapping,
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
@@ -1182,8 +1213,16 @@ static int ceph_writepages_start(struct address_space *mapping,
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
index db6b399645ba..0d0343906d29 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -155,6 +155,12 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page, u64 of
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
@@ -249,6 +255,16 @@ static inline int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **
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
2.31.1

