Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA04FD9E8
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Apr 2022 12:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243366AbiDLJvi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Apr 2022 05:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351710AbiDLH2N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 12 Apr 2022 03:28:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54B6D4F442
        for <ceph-devel@vger.kernel.org>; Tue, 12 Apr 2022 00:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649747283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7nGVtq761THI2iJueCqXEBM16T97URAaXffhqMv7mA=;
        b=Q1PopZ3ZN6W2jpNtDeEeA4asiBH0TTksfHTNKXiJOj61CynbfwNEG23bc96sg3vx+RN5LU
        ZK/MrI7KZFdpO+hEF1B8qB6xh+REKwqBIth7nLaHtdyARJoyCsiOf91LHsaB8DgsF6ucW2
        24DVcL8ANQRBJ9oP9IvQ5MsUCD2Lzec=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-wuCTeVNJMf2_K9vsA-szow-1; Tue, 12 Apr 2022 03:08:01 -0400
X-MC-Unique: wuCTeVNJMf2_K9vsA-szow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3457238025E9;
        Tue, 12 Apr 2022 07:08:01 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D05D200B66F;
        Tue, 12 Apr 2022 07:08:00 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 3/3] ceph: fix possible kunmaping random vaddr
Date:   Tue, 12 Apr 2022 15:07:45 +0800
Message-Id: <20220412070745.22795-4-xiubli@redhat.com>
In-Reply-To: <20220412070745.22795-1-xiubli@redhat.com>
References: <20220412070745.22795-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 1c775a365b5e..83f18b058d8c 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2253,7 +2253,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 	loff_t pos, orig_pos = round_down(attr->ia_size, CEPH_FSCRYPT_BLOCK_SIZE);
 	u64 block = orig_pos >> CEPH_FSCRYPT_BLOCK_SHIFT;
 	struct ceph_pagelist *pagelist = NULL;
-	struct kvec iov;
+	struct kvec iov = {0};
 	struct iov_iter iter;
 	struct page *page = NULL;
 	struct ceph_fscrypt_truncate_size_header header;
@@ -2364,7 +2364,8 @@ static int fill_fscrypt_truncate(struct inode *inode,
 	dout("%s %p size dropping cap refs on %s\n", __func__,
 	     inode, ceph_cap_string(got));
 	ceph_put_cap_refs(ci, got);
-	kunmap_local(iov.iov_base);
+	if (iov.iov_base)
+		kunmap_local(iov.iov_base);
 	if (page)
 		__free_pages(page, 0);
 	if (ret && pagelist)
-- 
2.36.0.rc1

