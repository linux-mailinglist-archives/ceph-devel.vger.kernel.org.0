Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF43702118
	for <lists+ceph-devel@lfdr.de>; Mon, 15 May 2023 03:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbjEOBWV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 May 2023 21:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238046AbjEOBWU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 14 May 2023 21:22:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72E31707
        for <ceph-devel@vger.kernel.org>; Sun, 14 May 2023 18:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684113690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OmB3wXr05ZF4mv5+5tdgNLyO+5Jy1xAtgK7GM+TTU58=;
        b=G19TJWQ+g4CanY+Ht/C/6uHmwKVWzW94HUzp23cdoYJyApP8FjwwVTspAsaafMxxubEwRH
        vsqlgnvzUcb2RbqrqYJahRC0aFoEDWTDGZ/8caIygnDUeGYT3qIUQXUhaDnD9828TxcSYQ
        7FeluE6vufq5V/zYRTFrkgVNEuQRf/c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-JM9T5lI2P46YW92KpEk3OQ-1; Sun, 14 May 2023 21:21:27 -0400
X-MC-Unique: JM9T5lI2P46YW92KpEk3OQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DF71101A551;
        Mon, 15 May 2023 01:21:27 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-56.pek2.redhat.com [10.72.12.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C73A63F5F;
        Mon, 15 May 2023 01:21:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v6 2/2] ceph: fix blindly expanding the readahead windows
Date:   Mon, 15 May 2023 09:20:44 +0800
Message-Id: <20230515012044.98096-3-xiubli@redhat.com>
In-Reply-To: <20230515012044.98096-1-xiubli@redhat.com>
References: <20230515012044.98096-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

Blindly expanding the readahead windows will cause unneccessary
pagecache thrashing and also will introdue the network workload.
We should disable expanding the windows if the readahead is disabled
and also shouldn't expand the windows too much.

Expanding forward firstly instead of expanding backward for possible
sequential reads.

Bound `rreq->len` to the actual file size to restore the previous page
cache usage.

The posix_fadvise may change the maximum size of a file readahead.

Cc: stable@vger.kernel.org
Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
URL: https://www.spinics.net/lists/ceph-users/msg76183.html
Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 93fff1a7373f..4b29777c01d7 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -188,16 +188,42 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
 	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_layout *lo = &ci->i_layout;
+	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
+	loff_t end = rreq->start + rreq->len, new_end;
+	struct ceph_netfs_request_data *priv = rreq->netfs_priv;
+	unsigned long max_len;
 	u32 blockoff;
-	u64 blockno;
 
-	/* Expand the start downward */
-	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
-	rreq->start = blockno * lo->stripe_unit;
-	rreq->len += blockoff;
+	if (priv) {
+		/* Readahead is disabled by posix_fadvise POSIX_FADV_RANDOM */
+		if (priv->file_ra_disabled)
+			max_pages = 0;
+		else
+			max_pages = priv->file_ra_pages;
+
+	}
+
+	/* Readahead is disabled */
+	if (!max_pages)
+		return;
 
-	/* Now, round up the length to the next block */
-	rreq->len = roundup(rreq->len, lo->stripe_unit);
+	max_len = max_pages << PAGE_SHIFT;
+
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
2.40.1

