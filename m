Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8776DF301
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjDLLR5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjDLLRn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:17:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B101D83DF
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0r4D0w6NbEVMRfKMMhOJF5L7Krevq/+fITp8vNTu41Y=;
        b=FTiJtOSk4DTfDYT0ivsbRc4GzeKS9RnhTKC8qiWQEnRHg0PBr+dUrD4/Mb9Bgiae677JGS
        c6S/tdjPzM6wVvr3371Vw7Klb310N93f9P6YE5AHR2JX5JsVRgAmHlNok/G6cPj1i4ErCz
        rstKiGrSw1HM29m2jridgAslMaHUXnY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-xtpYGZOzMTe7jf7yPzz8iw-1; Wed, 12 Apr 2023 07:14:35 -0400
X-MC-Unique: xtpYGZOzMTe7jf7yPzz8iw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90BA1185A78B;
        Wed, 12 Apr 2023 11:14:35 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B95DC15BB8;
        Wed, 12 Apr 2023 11:14:30 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 59/71] ceph: add encryption support to writepage
Date:   Wed, 12 Apr 2023 19:09:18 +0800
Message-Id: <20230412110930.176835-60-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-1-xiubli@redhat.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

Allow writepage to issue encrypted writes. Extend out the requested size
and offset to cover complete blocks, and then encrypt and write them to
the OSDs.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f8d94ff4f19d..b47de8891efc 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -601,10 +601,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
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
 
@@ -640,31 +642,50 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
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
@@ -672,7 +693,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 
 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, len, err);
-
+	fscrypt_free_bounce_page(bounce_page);
 	ceph_osdc_put_request(req);
 	if (err == 0)
 		err = len;
-- 
2.39.2

