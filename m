Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CB7596EE1
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Aug 2022 15:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiHQM7W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Aug 2022 08:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbiHQM7R (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 Aug 2022 08:59:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A56717042
        for <ceph-devel@vger.kernel.org>; Wed, 17 Aug 2022 05:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660741153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DB8TJ4GdFANsVW+6An+1pE7Iv7fAZgzMPioC8++eDDE=;
        b=cl6uE3kIiH8jqZc3fDnUBe/lkTHL5GqWXOzuF+cKSq+FYePAkMpYWE+8wDHfEjZrZENLDR
        bygouV1SJDumZv5mUnxNYNjM3fP+TcMuD9rEsBZoXccMoppov7aDZMx06/4aAlqvuHCaBg
        2zaffQdP1WTJuj1Vi2BufVXO647S31I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-i8VSpz4yOX2BnZxhQRzSTA-1; Wed, 17 Aug 2022 08:59:12 -0400
X-MC-Unique: i8VSpz4yOX2BnZxhQRzSTA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8DCF3C0ED56;
        Wed, 17 Aug 2022 12:59:11 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02CF7C15BB3;
        Wed, 17 Aug 2022 12:59:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] libceph: advancing variants of iov_iter_get_pages()
Date:   Wed, 17 Aug 2022 20:59:04 +0800
Message-Id: <20220817125904.101285-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The upper layer has changed it to iov_iter_get_pages2(). And this
should be folded into the previous commit.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/messenger.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 945f6d1a9efa..6caf8a2ff4ae 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -985,24 +985,18 @@ static struct page *ceph_msg_data_iter_next(struct ceph_msg_data_cursor *cursor,
 	if (cursor->lastlen)
 		iov_iter_revert(&cursor->iov_iter, cursor->lastlen);
 
-	len = iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
-				 1, page_offset);
+	len = iov_iter_get_pages2(&cursor->iov_iter, &page, PAGE_SIZE,
+				  1, page_offset);
 	BUG_ON(len < 0);
 
 	cursor->lastlen = len;
 
-	/*
-	 * FIXME: Al Viro says that he will soon change iov_iter_get_pages
-	 * to auto-advance the iterator. Emulate that here for now.
-	 */
-	iov_iter_advance(&cursor->iov_iter, len);
-
 	/*
 	 * FIXME: The assumption is that the pages represented by the iov_iter
-	 * 	  are pinned, with the references held by the upper-level
-	 * 	  callers, or by virtue of being under writeback. Eventually,
-	 * 	  we'll get an iov_iter_get_pages variant that doesn't take page
-	 * 	  refs. Until then, just put the page ref.
+	 *	  are pinned, with the references held by the upper-level
+	 *	  callers, or by virtue of being under writeback. Eventually,
+	 *	  we'll get an iov_iter_get_pages2 variant that doesn't take page
+	 *	  refs. Until then, just put the page ref.
 	 */
 	VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
 	put_page(page);
-- 
2.36.0.rc1

