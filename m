Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A16B6DF31B
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjDLLXF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjDLLXD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:23:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F0C6A6F
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zzbLqrgA8EipnrKVPc8Z/iS71yh1xrU5wAVY9TB5X5A=;
        b=II3NtSOC/DmGdC7ZHnCvGaXFnbY5MJNcdjraapjy+fz/sBXlK3bvL2s8zOkAeeg9BuOVeY
        hhjDYrrs+RNmbLpkL88hfC/ttX8Al89RsbwFa87b/ZrqVjfLacbbnGUMs5JSc/BXS0LU7E
        mUM315FZwrLbZbytMtHy9fA/4b5aqW0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-_E4nBnuLPsCG0jrQqVrSow-1; Wed, 12 Apr 2023 07:14:44 -0400
X-MC-Unique: _E4nBnuLPsCG0jrQqVrSow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D67028237C4;
        Wed, 12 Apr 2023 11:14:44 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0D8CC15BB8;
        Wed, 12 Apr 2023 11:14:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 61/71] ceph: invalidate pages when doing direct/sync writes
Date:   Wed, 12 Apr 2023 19:09:20 +0800
Message-Id: <20230412110930.176835-62-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-1-xiubli@redhat.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

When doing a direct/sync write, we need to invalidate the page cache in
the range being written to. If we don't do this, the cache will include
invalid data as we just did a write that avoided the page cache.

In the event that invalidation fails, just ignore the error. That likely
just means that we raced with another task doing a buffered write, in
which case we want to leave the page intact anyway.

[ jlayton: minor comment update ]

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0adaa89d0604..317087ea017e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1632,11 +1632,6 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		return ret;
 
 	ceph_fscache_invalidate(inode, false);
-	ret = invalidate_inode_pages2_range(inode->i_mapping,
-					    pos >> PAGE_SHIFT,
-					    (pos + count - 1) >> PAGE_SHIFT);
-	if (ret < 0)
-		dout("invalidate_inode_pages2_range returned %d\n", ret);
 
 	while ((len = iov_iter_count(from)) > 0) {
 		size_t left;
@@ -1962,6 +1957,20 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		}
 
 		ceph_clear_error_write(ci);
+
+		/*
+		 * We successfully wrote to a range of the file. Declare
+		 * that region of the pagecache invalid.
+		 */
+		ret = invalidate_inode_pages2_range(
+				inode->i_mapping,
+				pos >> PAGE_SHIFT,
+				(pos + len - 1) >> PAGE_SHIFT);
+		if (ret < 0) {
+			dout("invalidate_inode_pages2_range returned %d\n",
+			     ret);
+			ret = 0;
+		}
 		pos += len;
 		written += len;
 		dout("sync_write written %d\n", written);
-- 
2.39.2

