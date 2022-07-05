Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA356614E
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Jul 2022 04:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbiGECke (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Jul 2022 22:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiGECkd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Jul 2022 22:40:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 372B11276D
        for <ceph-devel@vger.kernel.org>; Mon,  4 Jul 2022 19:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656988832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o170eWUKaZSNnPb0WrrWkpkp618VBFHIfPvFB64ZSJ0=;
        b=eVBZHXRiBE189x8uVI9djOvkEmoVpKoD/obfcyZ6os0NuiyEtc/DQ/IF+NV5nr7trXwm6t
        ZRCY+JMglYg+SHefVF/MSQewphdGi3MpDbwI/IG1V68+gj3LqZtjsFFWngagsfSIVXBqgD
        qj5bUP5sHIE0LXGl0ilE5+RQxsxiOlY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-klSVmI_CMdGkj-bZIL0iGg-1; Mon, 04 Jul 2022 22:40:29 -0400
X-MC-Unique: klSVmI_CMdGkj-bZIL0iGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8BFC811E75;
        Tue,  5 Jul 2022 02:40:28 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A731D18EA3;
        Tue,  5 Jul 2022 02:40:26 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com
Cc:     jlayton@kernel.org, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: remove unless check for the folio
Date:   Tue,  5 Jul 2022 10:40:23 +0800
Message-Id: <20220705024023.301574-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The netfs_write_begin() won't set the folio if the return value
is non-zero.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e44a3eefb344..8095fc47230e 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1318,16 +1318,13 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 	int r;
 
 	r = netfs_write_begin(&ci->netfs, file, inode->i_mapping, pos, len, &folio, NULL);
-	if (r == 0)
-		folio_wait_fscache(folio);
-	if (r < 0) {
-		if (folio)
-			folio_put(folio);
-	} else {
-		WARN_ON_ONCE(!folio_test_locked(folio));
-		*pagep = &folio->page;
-	}
-	return r;
+	if (r < 0)
+		return r;
+
+	folio_wait_fscache(folio);
+	WARN_ON_ONCE(!folio_test_locked(folio));
+	*pagep = &folio->page;
+	return 0;
 }
 
 /*
-- 
2.36.0.rc1

