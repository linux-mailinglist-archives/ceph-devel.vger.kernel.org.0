Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4ED793C7B
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Sep 2023 14:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjIFMUm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Sep 2023 08:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjIFMUm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Sep 2023 08:20:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FFF10F7
        for <ceph-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694002796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uZKt9lI2eKMSpsKvogAyk1sc6dUffx4XcKcIj6uI1IU=;
        b=B+0+ax5vhpoRNqJinmCR7gm173cNyj+G0dWz5fkNKrgh5bWtETtoapxQ/8Vp7/LwgqDsRd
        uveDMq4z16HCweWkCjZZv/C7q2rL3QHi+vkc0BLRkY/cjYzi3gUw9mCJivFvj7LoBEc+dL
        zHF6ERW2QjlqGHuwUZMfSCYa8hm3Ks4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-XCpOrwpZPFmzHbIxIzHNPA-1; Wed, 06 Sep 2023 08:19:55 -0400
X-MC-Unique: XCpOrwpZPFmzHbIxIzHNPA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04C68800969;
        Wed,  6 Sep 2023 12:19:55 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEEA3404119;
        Wed,  6 Sep 2023 12:19:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ceph: remove the incorrect caps check in _file_size()
Date:   Wed,  6 Sep 2023 20:17:47 +0800
Message-ID: <20230906121747.618289-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When truncating the inode the MDS will acquire the xlock for the
ifile Locker, which will revoke the 'Frwsxl' caps from the clients.
But when the client just releases and flushes the 'Fw' caps to MDS,
for exmaple, and once the MDS receives the caps flushing msg it
just thought the revocation has finished. Then the MDS will continue
truncating the inode and then issued the truncate notification to
all the clients. While just before the clients receives the cap
flushing ack they receive the truncation notification, the clients
will detecte that the 'issued | dirty' is still holding the 'Fw'
caps.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/56693
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index ea6f966dacd5..8017b9e5864f 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -769,9 +769,7 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 			ci->i_truncate_seq = truncate_seq;
 
 			/* the MDS should have revoked these caps */
-			WARN_ON_ONCE(issued & (CEPH_CAP_FILE_EXCL |
-					       CEPH_CAP_FILE_RD |
-					       CEPH_CAP_FILE_WR |
+			WARN_ON_ONCE(issued & (CEPH_CAP_FILE_RD |
 					       CEPH_CAP_FILE_LAZYIO));
 			/*
 			 * If we hold relevant caps, or in the case where we're
-- 
2.41.0

