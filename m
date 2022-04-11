Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EE54FB0EF
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Apr 2022 02:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbiDKAQz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 10 Apr 2022 20:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbiDKAQx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 10 Apr 2022 20:16:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C464B870
        for <ceph-devel@vger.kernel.org>; Sun, 10 Apr 2022 17:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649636080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qkYabtAr+hEGlqMbPVL/sJ+SdoOsmaFH51Q0unqrDT0=;
        b=SHBbFUeL3+rjjgYBUyyY4+Em+lncGGQCRvgIPbMEvLtOeuvEjiODxT+iIZmcg/kUQLoEDn
        gJdKCxK69tLI36L2Py4kOOENRGb64H6XeS/gzFN359/E+qnBtHXf9iYilaFJkjWXoGkhqe
        0lHBHfZWyEsgfXG1W17gC+rai+Nte8s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-TlCqkAMgPCKVvitkIyJbkg-1; Sun, 10 Apr 2022 20:14:37 -0400
X-MC-Unique: TlCqkAMgPCKVvitkIyJbkg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8045185A7A4;
        Mon, 11 Apr 2022 00:14:36 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BB0F145B96F;
        Mon, 11 Apr 2022 00:14:34 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] ceph: fix caps reference leakage for fscrypt size truncating
Date:   Mon, 11 Apr 2022 08:14:26 +0800
Message-Id: <20220411001426.251679-3-xiubli@redhat.com>
In-Reply-To: <20220411001426.251679-1-xiubli@redhat.com>
References: <20220411001426.251679-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index a2ff964e332b..6788a1f88eb6 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2301,7 +2301,6 @@ static int fill_fscrypt_truncate(struct inode *inode,
 
 	pos = orig_pos;
 	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &objver);
-	ceph_put_cap_refs(ci, got);
 	if (ret < 0)
 		goto out;
 
@@ -2365,6 +2364,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 out:
 	dout("%s %p size dropping cap refs on %s\n", __func__,
 	     inode, ceph_cap_string(got));
+	ceph_put_cap_refs(ci, got);
 	kunmap_local(iov.iov_base);
 	if (page)
 		__free_pages(page, 0);
-- 
2.27.0

