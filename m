Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D5252BE01
	for <lists+ceph-devel@lfdr.de>; Wed, 18 May 2022 17:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbiEROln (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 May 2022 10:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbiEROll (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 18 May 2022 10:41:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48E261B176D
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 07:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652884899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SZmJjklmkwrAQkgHdauRRZkWUjWUEeruBkT69uT8b6s=;
        b=TWdCx6UkkQ0fZ19TetdzGjV+fOv8vtp4mYshNCzwc6LnTWtvLGHNKoJiZDvC0kuaMdPhij
        GHNxegXVmZIZoO460vrAZfyADXI8W+XOxoCMxh39wXIUgwSyFu6bl3SGzypi6PxnHtb8QL
        I/QvQ3vSI9qLLQJM/cfFymuaql8z+QM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-nJ2DqiR1NWOA3EMeDpVKEQ-1; Wed, 18 May 2022 10:41:37 -0400
X-MC-Unique: nJ2DqiR1NWOA3EMeDpVKEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4436318E004B;
        Wed, 18 May 2022 14:41:26 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99FA640C1421;
        Wed, 18 May 2022 14:41:25 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] ceph: switch TASK_INTERRUPTIBLE to TASK_KILLABLE
Date:   Wed, 18 May 2022 22:41:22 +0800
Message-Id: <20220518144122.231243-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If the task is placed in the TASK_INTERRUPTIBLE state it will sleep
until either something explicitly wakes it up, or a non-masked signal
is received. Switch to TASK_KILLABLE to avoid the noises.

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index d1ae679c52c3..f72f40b3e26b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -579,7 +579,7 @@ static inline int ceph_wait_on_async_create(struct inode *inode)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
 	return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
-			   TASK_INTERRUPTIBLE);
+			   TASK_KILLABLE);
 }
 
 extern int ceph_wait_on_conflict_unlink(struct dentry *dentry);
-- 
2.36.0.rc1

