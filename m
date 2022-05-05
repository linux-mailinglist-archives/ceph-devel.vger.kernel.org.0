Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AE851BD96
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 12:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354143AbiEELCc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 07:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356675AbiEELC0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 07:02:26 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D507753E30
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 03:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651748294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2QMeaMadtxdpTabBv6o+MmhAcf3p7JFcSce4Eq0rD/c=;
        b=UsWdFz1bmY7fBF966qX4HtsWlPA/OlyP7Xj2bXFhwn1u0BU0lT3qp2ig4Ms7fv+GDwXizA
        Tlz/NDfdXStMaZIijkhvR7Zh3gE5H7sQAMdFgFly2m5dJhtwqqQlyHqU/5iCdvzdN//X6q
        qQrXcm/xLg/53JlNKSI6CwDikKbKr6o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-y4RyI7-wMFyZfcgu3oysOw-1; Thu, 05 May 2022 06:58:11 -0400
X-MC-Unique: y4RyI7-wMFyZfcgu3oysOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8881829ABA32;
        Thu,  5 May 2022 10:58:11 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCF35111DCF2;
        Thu,  5 May 2022 10:58:10 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: redirty the folio/page when offset and size are not aligned
Date:   Thu,  5 May 2022 18:58:08 +0800
Message-Id: <20220505105808.35214-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

At the same time fix another buggy code because in writepages_finish
if the opcode doesn't equal to CEPH_OSD_OP_WRITE the request memory
must have been corrupted.

URL: https://tracker.ceph.com/issues/55421
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e52b62407b10..ae224135440b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -146,6 +146,8 @@ static void ceph_invalidate_folio(struct folio *folio, size_t offset,
 	if (offset != 0 || length != folio_size(folio)) {
 		dout("%p invalidate_folio idx %lu partial dirty page %zu~%zu\n",
 		     inode, folio->index, offset, length);
+		filemap_dirty_folio(folio->mapping, folio);
+		folio_account_redirty(folio);
 		return;
 	}
 
@@ -733,8 +735,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 
 	/* clean all pages */
 	for (i = 0; i < req->r_num_ops; i++) {
-		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE)
-			break;
+		BUG_ON(req->r_ops[i].op != CEPH_OSD_OP_WRITE);
 
 		osd_data = osd_req_op_extent_osd_data(req, i);
 		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
-- 
2.36.0.rc1

