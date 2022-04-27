Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7A4512274
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiD0TV0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiD0TTi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA2C562F0
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49336619FC
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F01FC385AA;
        Wed, 27 Apr 2022 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086837;
        bh=kZh1Ni0AOS2h4sFtDN+KvlvqUtKHcdnUYyHdBQL9+V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bchcqs1CWsLPFqfN5D+sxBVoX5g8vL34srXPrxWXOLgIKTgrf/Gbevr8bU5e2wMQW
         B0NWtSWZRHpiqn/YKMQdrZvXKoaW8omfmtzrgrbTHltOwypBfSCIcClIo/N+3YkPOf
         V+DmCgLpY22ZUPrFlvXptZlSwPsTdOKCAf6kMm0Agcqa9Vivzd1Vw8Wl0cEZikdNrk
         59IFGSLkkg24FnzIYgTeG7b7C4vc1oytF3U2rprgyoIS8ogVzmaJsn0rulOSaVO6uT
         rgpS2r7hLMl2TnG/ZsyKwdaxafmEVT9qIBR0aWTBGfouGcdNIAYuk9ARjZDmSWbrWc
         r+FagQbx9a0cg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 58/64] ceph: add encryption support to writepage
Date:   Wed, 27 Apr 2022 15:13:08 -0400
Message-Id: <20220427191314.222867-59-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Allow writepage to issue encrypted writes. Extend out the requested size
and offset to cover complete blocks, and then encrypt and write them to
the OSDs.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index d65d431ec933..f54940fc96ee 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -586,10 +586,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
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
 
@@ -621,6 +623,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 
 	if (ceph_wbc.i_size < page_off + len)
 		len = ceph_wbc.i_size - page_off;
+	if (IS_ENCRYPTED(inode))
+		wlen = round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
 
 	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
 	     inode, page, page->index, page_off, len, snapc, snapc->seq);
@@ -629,24 +633,39 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
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
+			err = PTR_ERR(bounce_page);
+			goto out;
+		}
+	}
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
 	err = ceph_osdc_start_request(osdc, req, true);
@@ -655,7 +674,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 
 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, len, err);
-
+	fscrypt_free_bounce_page(bounce_page);
+out:
 	ceph_osdc_put_request(req);
 	if (err == 0)
 		err = len;
-- 
2.35.1

