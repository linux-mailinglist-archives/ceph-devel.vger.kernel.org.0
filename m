Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7ED50D0D7
	for <lists+ceph-devel@lfdr.de>; Sun, 24 Apr 2022 11:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbiDXJnC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 24 Apr 2022 05:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbiDXJmk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 24 Apr 2022 05:42:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF5A025C62
        for <ceph-devel@vger.kernel.org>; Sun, 24 Apr 2022 02:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650793179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t5jG9BUkSt9yM+i43EaxQ9dfSHOmx/YuDzmH80vHjC0=;
        b=W0hZLrRebamA+bIkK2hJybeKAD1+HZcogFtDWeB/+Adrdrk26BLFTfXyJHbhflDP7csoDw
        I86n1NQfECiz0CqcOt9gwNPQ6flN/iFBJeCeObec5PEfDePfz35kvZoAIIf/MML+4krBwh
        ysr9NXNmqvymCtuTxXtv011nhS3EJWc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-GRk9bGSmPCCpZJhSw--f7w-1; Sun, 24 Apr 2022 05:39:38 -0400
X-MC-Unique: GRk9bGSmPCCpZJhSw--f7w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0435980159B;
        Sun, 24 Apr 2022 09:39:38 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AF7440D017E;
        Sun, 24 Apr 2022 09:39:37 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: redirty the page for wirtepage if fails
Date:   Sun, 24 Apr 2022 17:39:24 +0800
Message-Id: <20220424093924.32691-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When run out of memories we should redirty the page before failing
the writepage. Or we will hit BUG_ON(folio_get_private(folio)) in
ceph_dirty_folio().

URL: https://tracker.ceph.com/issues/55421
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 261bc8bb2ab8..656bc0ca7a78 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -606,8 +606,10 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
 				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
 				    true);
-	if (IS_ERR(req))
+	if (IS_ERR(req)) {
+		redirty_page_for_writepage(wbc, page);
 		return PTR_ERR(req);
+	}
 
 	set_page_writeback(page);
 	if (caching)
-- 
2.36.0.rc1

