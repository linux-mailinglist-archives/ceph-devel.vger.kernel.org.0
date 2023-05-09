Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893716FBC3A
	for <lists+ceph-devel@lfdr.de>; Tue,  9 May 2023 02:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjEIA6f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 May 2023 20:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjEIA6e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 May 2023 20:58:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2132690
        for <ceph-devel@vger.kernel.org>; Mon,  8 May 2023 17:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683593868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MYzrEaqMocWIGekoCZTFoSfznSdeSHEJlOcxQuKW2QY=;
        b=bacl1+ujNYsIqiiuhPBNqRhwTCWlJry2B6IYR4UU0wPddUIzr3T2p9JqTyZ4P3R43Pbnie
        72W0CKLUQhGFJ8XvlwBdRj+rTDGhb7CUp4dxNTv5Yvhk8A7PZB93Bh3kdd9+lbtotgK8Jk
        qRaUqYq8Jp/iHpHaUn9ZNwe63COVycU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-xMa1z0IpPHiu8ZfMQrpmNw-1; Mon, 08 May 2023 20:57:43 -0400
X-MC-Unique: xMa1z0IpPHiu8ZfMQrpmNw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB91E3C0F422;
        Tue,  9 May 2023 00:57:42 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-156.pek2.redhat.com [10.72.12.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72E39C15BA0;
        Tue,  9 May 2023 00:57:37 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH v4] ceph: fix blindly expanding the readahead windows
Date:   Tue,  9 May 2023 08:57:03 +0800
Message-Id: <20230509005703.155321-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
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

Bound `rreq->len` to the actual file size to restore the previous page
cache usage.

Cc: stable@vger.kernel.org
Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
URL: https://www.spinics.net/lists/ceph-users/msg76183.html
Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V4:
- two small cleanup from Ilya's comments. Thanks


 fs/ceph/addr.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ca4dc6450887..683ba9fbd590 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -188,16 +188,30 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
 	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_layout *lo = &ci->i_layout;
+	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
+	unsigned long max_len = max_pages << PAGE_SHIFT;
+	loff_t end = rreq->start + rreq->len, new_end;
 	u32 blockoff;
-	u64 blockno;
 
-	/* Expand the start downward */
-	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
-	rreq->start = blockno * lo->stripe_unit;
-	rreq->len += blockoff;
+	/* Readahead is disabled */
+	if (!max_pages)
+		return;
 
-	/* Now, round up the length to the next block */
-	rreq->len = roundup(rreq->len, lo->stripe_unit);
+	/*
+	 * Try to expand the length forward by rounding  up it to the next
+	 * block, but do not exceed the file size, unless the original
+	 * request already exceeds it.
+	 */
+	new_end = min(round_up(end, lo->stripe_unit), rreq->i_size);
+	if (new_end > end && new_end <= rreq->start + max_len)
+		rreq->len = new_end - rreq->start;
+
+	/* Try to expand the start downward */
+	div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
+	if (rreq->len + blockoff <= max_len) {
+		rreq->start -= blockoff;
+		rreq->len += blockoff;
+	}
 }
 
 static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
-- 
2.40.0

