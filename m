Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A0D6F6996
	for <lists+ceph-devel@lfdr.de>; Thu,  4 May 2023 13:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjEDLMM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 May 2023 07:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjEDLMK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 May 2023 07:12:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D0A2D6D
        for <ceph-devel@vger.kernel.org>; Thu,  4 May 2023 04:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683198681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wdHFA57yzENpymQswawfh55EajUPP5OSMqkDLP/EWuA=;
        b=gkx1ZboW5ghmhV6gyLtVzsYwqNHkjZuJUr+xwGq20nw4vf8LMCjYdY3oY7pcsPc9O9w1JB
        eVju3g/Q4GkvL2K6Ce4Cla1MRxUWebDiyImGDSw2U7zWtQrjw3z0+hM5TsC+UxZDWdHGcl
        BiFpw7eXeQKVM1ESTenWqBJ5oNZYLpk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675--x8ZztfTM1CyMPA6On59CA-1; Thu, 04 May 2023 07:11:18 -0400
X-MC-Unique: -x8ZztfTM1CyMPA6On59CA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C969C889078;
        Thu,  4 May 2023 11:11:14 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-151.pek2.redhat.com [10.72.12.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9758D40C2064;
        Thu,  4 May 2023 11:11:08 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org, Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH v3] ceph: fix blindly expanding the readahead windows
Date:   Thu,  4 May 2023 19:11:00 +0800
Message-Id: <20230504111100.417305-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

Bound `rreq->len` to the actual file size to restore the previous page
cache usage.

Cc: stable@vger.kernel.org
Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
URL: https://www.spinics.net/lists/ceph-users/msg76183.html
Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- Folded Hu Weiwen's fix and bound `rreq->len` to the actual file size.



 fs/ceph/addr.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ca4dc6450887..357d9d28f202 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -188,16 +188,32 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
 	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_layout *lo = &ci->i_layout;
+	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
+	unsigned long max_len = max_pages << PAGE_SHIFT;
+	loff_t end = rreq->start + rreq->len, new_end;
 	u32 blockoff;
 	u64 blockno;
 
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
+	new_end = round_up(end, lo->stripe_unit);
+	new_end = min(new_end, rreq->i_size);
+	if (new_end > end && new_end <= rreq->start + max_len)
+		rreq->len = new_end - rreq->start;
+
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

