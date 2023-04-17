Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345276E3E3D
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjDQDfk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjDQDfL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:35:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FCB59C9
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czLXkzNUI8OcnJPxXQxXiLbhnNHLGRaz68BcpWvaB1k=;
        b=dFo4JU0KziFfdixqamqhfJTzuJaQPGxBvow3TmzwH9qISnmp9PazWBymB61cJVkQeDxhR+
        kfiNs6wXDYwGv9jpeE9UO6aE1FesHGdSdS1LH4PZiS9wdUIxt1c11aqg5StwIywsI3tgox
        5PUAFFzoK4sE5kYDezUD5m9d94nUB1Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-KR9al0NpO-avRYM8p6ATSg-1; Sun, 16 Apr 2023 23:32:21 -0400
X-MC-Unique: KR9al0NpO-avRYM8p6ATSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 157311C09501;
        Mon, 17 Apr 2023 03:32:21 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42E9A2027044;
        Mon, 17 Apr 2023 03:32:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 60/70] ceph: fscrypt support for writepages
Date:   Mon, 17 Apr 2023 11:26:44 +0800
Message-Id: <20230417032654.32352-61-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-1-xiubli@redhat.com>
References: <20230417032654.32352-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Add the appropriate machinery to write back dirty data with encryption.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
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
2.39.1

