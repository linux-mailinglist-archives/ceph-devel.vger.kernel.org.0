Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5824FD603
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Apr 2022 12:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiDLJvu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Apr 2022 05:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351968AbiDLH2O (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 12 Apr 2022 03:28:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C00E4F444
        for <ceph-devel@vger.kernel.org>; Tue, 12 Apr 2022 00:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649747284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0fP0oHi8cKZCOC9vXmnlFkANQVwtuXoa0AwfAmlD6o=;
        b=eQibg9SDzRJ0HpInQRVjnt6qatZg9Yd0pfmkTSzWQrMg6t6KAKGOpZqc9lbINQhnx9rzNC
        Y61UmpGgWaVjOMOEQjwJkb69RvP1m10wxXUT1M9l05wnD9SWKRx2rsyiLphxCxzJWDBf4U
        CCKKsoz/zNFs40+mpPRlaVDygnCkZco=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-TucoJEAgMtyv7PQxfpF_gw-1; Tue, 12 Apr 2022 03:07:58 -0400
X-MC-Unique: TucoJEAgMtyv7PQxfpF_gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6251380346E;
        Tue, 12 Apr 2022 07:07:58 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D49540F4940;
        Tue, 12 Apr 2022 07:07:56 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/3] ceph: fix caps reference leakage for fscrypt size truncating
Date:   Tue, 12 Apr 2022 15:07:44 +0800
Message-Id: <20220412070745.22795-3-xiubli@redhat.com>
In-Reply-To: <20220412070745.22795-1-xiubli@redhat.com>
References: <20220412070745.22795-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index a5145a2b7228..1c775a365b5e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2300,7 +2300,6 @@ static int fill_fscrypt_truncate(struct inode *inode,
 
 	pos = orig_pos;
 	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &objver);
-	ceph_put_cap_refs(ci, got);
 	if (ret < 0)
 		goto out;
 
@@ -2364,6 +2363,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 out:
 	dout("%s %p size dropping cap refs on %s\n", __func__,
 	     inode, ceph_cap_string(got));
+	ceph_put_cap_refs(ci, got);
 	kunmap_local(iov.iov_base);
 	if (page)
 		__free_pages(page, 0);
-- 
2.36.0.rc1

