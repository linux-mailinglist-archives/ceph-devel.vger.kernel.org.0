Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4505A125B
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242220AbiHYNcY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242756AbiHYNcA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:32:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88B2B56CE
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF1C61D17
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5390C433B5;
        Thu, 25 Aug 2022 13:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434310;
        bh=Jf3pHJ3XnKj1z84m30qKgZSCuF+lnIEfrZj7Ekh7zFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzKA+VuJ9MT9M3pL/iT/F1tBfbFzq276pmlnnJIX+4m4LoLHlcKpSLmkWOIAczKZP
         LeaJzjV0zE72iFxltXyGCcn8LEw6cDO218dcEvxEinla05VsnJi0a4gymaH8vPY1V4
         9nqS1WSgkhXp8EpRSFIioWZE72ZAk8WIX7bw3GA5WWSHqJ7RxaLGSBitqlU9UHBH0f
         3JgLTQAJrAWysfFK5sRlYyOLZ+fJy3FbF9cO3OCwOHy8oZywphICwyK8n/z0J+/fwR
         z7TR8KKieeiBwHzgeRpcAornwFfsihQ4Iu8l36ZRfDrRpR20zStqfxt8OlsWlAN9zh
         PARc2xGR4zQNA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 22/29] ceph: add encryption support to writepage
Date:   Thu, 25 Aug 2022 09:31:25 -0400
Message-Id: <20220825133132.153657-23-jlayton@kernel.org>
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

Allow writepage to issue encrypted writes. Extend out the requested size
and offset to cover complete blocks, and then encrypt and write them to
the OSDs.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8de6b647658d..f76586984d80 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -598,10 +598,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	loff_t page_off = page_offset(page);
 	int err;
 	loff_t len = thp_size(page);
+	loff_t wlen;
 	struct ceph_writeback_ctl ceph_wbc;
 	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	struct ceph_osd_request *req;
 	bool caching = ceph_is_cache_enabled(inode);
+	struct page *bounce_page = NULL;
 
 	dout("writepage %p idx %lu\n", page, page->index);
 
@@ -634,31 +636,50 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	if (ceph_wbc.i_size < page_off + len)
 		len = ceph_wbc.i_size - page_off;
 
+	wlen = IS_ENCRYPTED(inode) ? round_up(len, CEPH_FSCRYPT_BLOCK_SIZE) : len;
 	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
-	     inode, page, page->index, page_off, len, snapc, snapc->seq);
+	     inode, page, page->index, page_off, wlen, snapc, snapc->seq);
 
 	if (atomic_long_inc_return(&fsc->writeback_count) >
 	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
 		fsc->write_congested = true;
 
-	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), page_off, &len, 0, 1,
-				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
-				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
-				    true);
+	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode),
+				    page_off, &wlen, 0, 1, CEPH_OSD_OP_WRITE,
+				    CEPH_OSD_FLAG_WRITE, snapc,
+				    ceph_wbc.truncate_seq,
+				    ceph_wbc.truncate_size, true);
 	if (IS_ERR(req)) {
 		redirty_page_for_writepage(wbc, page);
 		return PTR_ERR(req);
 	}
 
+	if (wlen < len)
+		len = wlen;
+
 	set_page_writeback(page);
 	if (caching)
 		ceph_set_page_fscache(page);
 	ceph_fscache_write_to_cache(inode, page_off, len, caching);
 
+	if (IS_ENCRYPTED(inode)) {
+		bounce_page = fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_BLOCK_SIZE,
+								0, GFP_NOFS);
+		if (IS_ERR(bounce_page)) {
+			redirty_page_for_writepage(wbc, page);
+			end_page_writeback(page);
+			ceph_osdc_put_request(req);
+			return PTR_ERR(bounce_page);
+		}
+	}
+
 	/* it may be a short write due to an object boundary */
 	WARN_ON_ONCE(len > thp_size(page));
-	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
-	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
+	osd_req_op_extent_osd_data_pages(req, 0,
+			bounce_page ? &bounce_page : &page, wlen, 0,
+			false, false);
+	dout("writepage %llu~%llu (%llu bytes, %sencrypted)\n",
+	     page_off, len, wlen, IS_ENCRYPTED(inode) ? "" : "not ");
 
 	req->r_mtime = inode->i_mtime;
 	ceph_osdc_start_request(osdc, req);
@@ -666,7 +687,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 
 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, len, err);
-
+	fscrypt_free_bounce_page(bounce_page);
 	ceph_osdc_put_request(req);
 	if (err == 0)
 		err = len;
-- 
2.37.2

