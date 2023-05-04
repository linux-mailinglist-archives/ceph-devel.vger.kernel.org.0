Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE896F6457
	for <lists+ceph-devel@lfdr.de>; Thu,  4 May 2023 07:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjEDFYM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 May 2023 01:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEDFYK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 May 2023 01:24:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0B31BEB
        for <ceph-devel@vger.kernel.org>; Wed,  3 May 2023 22:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683177801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QldF+jFVOD1VYNR3EsfYJNqYDCDLwUOiWf7e9d9hSw0=;
        b=GI/9pnBoZ26msFzctgVYO5ZABzMDNGwfcJVDOLHSMz3KzS+ad5UtwKylBcg18sJbo6cTxe
        REAlnkRsxMpcKBxY95NX/BuZTJ2azFHUMMEOks01c5IqSlcwzu9BWF6IFh82V2GwTeo/Hi
        DDJ5x37N52+47rgmrrWKt5DTZJKnKLw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-xtU4d-BLMGuMiqTuBHPsXw-1; Thu, 04 May 2023 01:23:20 -0400
X-MC-Unique: xtU4d-BLMGuMiqTuBHPsXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBD373C0C885;
        Thu,  4 May 2023 05:23:19 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-151.pek2.redhat.com [10.72.12.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5D271410F2A;
        Thu,  4 May 2023 05:23:14 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: fix blindly expanding the readahead windows
Date:   Thu,  4 May 2023 13:23:06 +0800
Message-Id: <20230504052306.405208-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Blindly expanding the readahead windows will cause unneccessary
pagecache thrashing and also will introdue the network workload.
We should disable expanding the windows if the readahead is disabled
and also shouldn't expand the windows too much.

Expanding forward firstly instead of expanding backward for possible
sequential reads.

URL: https://www.spinics.net/lists/ceph-users/msg76183.html
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- fix possible cross-block issue pointed out by Ilya.


 fs/ceph/addr.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ca4dc6450887..03a326da8fd8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -188,16 +188,28 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
 	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_layout *lo = &ci->i_layout;
+	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
+	unsigned long max_len = max_pages << PAGE_SHIFT;
+	unsigned long len;
 	u32 blockoff;
 	u64 blockno;
 
-	/* Expand the start downward */
-	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
-	rreq->start = blockno * lo->stripe_unit;
-	rreq->len += blockoff;
+	/* Readahead is disabled */
+	if (!max_pages)
+		return;
+
+	/* Try to expand the length forward by rounding up it to the next block */
+	div_u64_rem(rreq->start + rreq->len, lo->stripe_unit, &blockoff);
+	len = lo->stripe_unit - blockoff;
+	if (rreq->len + len <= max_len)
+		rreq->len += len;
 
-	/* Now, round up the length to the next block */
-	rreq->len = roundup(rreq->len, lo->stripe_unit);
+	/* Try to expand the start downward */
+	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
+	if (rreq->len + blockoff <= max_len) {
+		rreq->start = blockno * lo->stripe_unit;
+		rreq->len += blockoff;
+	}
 }
 
 static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
-- 
2.40.0

