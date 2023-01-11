Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4C6665105
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Jan 2023 02:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjAKBPD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Jan 2023 20:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjAKBPC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Jan 2023 20:15:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F64B44
        for <ceph-devel@vger.kernel.org>; Tue, 10 Jan 2023 17:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673399654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Bm6z2zC9lySkNyHdckFKlOcrYP615AE0wxLOBzp+HZY=;
        b=Nzb4GKsHYPfwbX6AYf/dVscZmqamgyAEM0s8RAJOK4G5wH3GxFyGFu5ZYS99a4HGM0H4n2
        /19GXJVxPy0XoWsKEZo0BjLYejlzARSI8exHoN0rIXifcxrAKlK/ARnugnk2dUS2luK1f8
        ZZGnYRh4AWOE3az2xVX6PbRWEPDhyY0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-bs3E7cPMPJqtMZXGfi_AFw-1; Tue, 10 Jan 2023 20:14:11 -0500
X-MC-Unique: bs3E7cPMPJqtMZXGfi_AFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 024B1299E74C;
        Wed, 11 Jan 2023 01:14:11 +0000 (UTC)
Received: from f37.redhat.com (ovpn-14-8.pek2.redhat.com [10.72.14.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 364F3140EBF4;
        Wed, 11 Jan 2023 01:14:06 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix double free for req when failing to allocate sparse ext map
Date:   Wed, 11 Jan 2023 09:14:03 +0800
Message-Id: <20230111011403.570964-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Introduced by commit d1f436736924 ("ceph: add new mount option to enable
sparse reads") and will fold this into the above commit since it's
still in the testing branch.

Reported-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 17758cb607ec..3561c95d7e23 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -351,10 +351,8 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 
 	if (sparse) {
 		err = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
-		if (err) {
-			ceph_osdc_put_request(req);
+		if (err)
 			goto out;
-		}
 	}
 
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
-- 
2.39.0

