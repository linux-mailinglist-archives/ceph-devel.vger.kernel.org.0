Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99DA595367
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Aug 2022 09:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiHPHHt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Aug 2022 03:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiHPHHd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Aug 2022 03:07:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F408E7823E
        for <ceph-devel@vger.kernel.org>; Mon, 15 Aug 2022 19:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660617712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C0n8KqKRGPqFKWUmof24Qzu9UY56N1ir+KjizVp3VBE=;
        b=CnJ3B2lfCh4XvL70OmHcmr2vuhyC7ZKW545xqvVr0AERq4sskO6dk2mm849yZKuUq2Cveu
        TmttyIAbT2BBA7OtL+UYIw+saIbG6AdDf6grmzgI8am8D6N/NZAe1E5tz98Nj0PcI6y0lH
        rURMoubxReP0bcBCXxmMAoXCT6NzHwk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-zCyKHqw0PHiSvQKPeez8VQ-1; Mon, 15 Aug 2022 22:41:48 -0400
X-MC-Unique: zCyKHqw0PHiSvQKPeez8VQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69CF718E0047;
        Tue, 16 Aug 2022 02:41:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86DA340CFD0A;
        Tue, 16 Aug 2022 02:41:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] libceph: advancing variants of iov_iter_get_pages()
Date:   Tue, 16 Aug 2022 10:41:43 +0800
Message-Id: <20220816024143.519027-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/messenger.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 945f6d1a9efa..020474cf137c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -985,25 +985,12 @@ static struct page *ceph_msg_data_iter_next(struct ceph_msg_data_cursor *cursor,
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
-	/*
-	 * FIXME: The assumption is that the pages represented by the iov_iter
-	 * 	  are pinned, with the references held by the upper-level
-	 * 	  callers, or by virtue of being under writeback. Eventually,
-	 * 	  we'll get an iov_iter_get_pages variant that doesn't take page
-	 * 	  refs. Until then, just put the page ref.
-	 */
 	VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
 	put_page(page);
 
-- 
2.36.0.rc1

