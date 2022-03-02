Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777364C9FF4
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 09:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiCBIzL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 03:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240259AbiCBIzK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 03:55:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5343B5FF2D
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 00:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646211266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcjgSGGQqZabXZBVqDRGvtr5s3kqrhUmGA1CTEaqEoQ=;
        b=JcwDGSgo4VnzAI1oJD2ITn9k0FPe1N8F6hvmBD12EGDjUiT+NIFR6IpXxnS7pvUg80LcqZ
        RI/F044JNz9AQIC0iD4ZEoG4ZST62K5SVMidQcTozCsIHVhBxVfKcOmKOpwnko8vVwwJIU
        vwjdqa/Go5I/gKMSGbkMmIMLteW8pkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-RQpGkEytOr2w6OqxZlh_DA-1; Wed, 02 Mar 2022 03:54:23 -0500
X-MC-Unique: RQpGkEytOr2w6OqxZlh_DA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 325E51091DA1;
        Wed,  2 Mar 2022 08:54:22 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BD71646D0;
        Wed,  2 Mar 2022 08:54:20 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: fix a NULL pointer dereference in ceph_handle_caps()
Date:   Wed,  2 Mar 2022 16:54:02 +0800
Message-Id: <20220302085402.64740-3-xiubli@redhat.com>
In-Reply-To: <20220302085402.64740-1-xiubli@redhat.com>
References: <20220302085402.64740-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The ceph_find_inode() may will fail and return NULL.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 0b36020207fd..0762b55fdbcb 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4303,7 +4303,6 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 
 	/* lookup ino */
 	inode = ceph_find_inode(mdsc->fsc->sb, vino);
-	ci = ceph_inode(inode);
 	dout(" op %s ino %llx.%llx inode %p\n", ceph_cap_op_name(op), vino.ino,
 	     vino.snap, inode);
 
@@ -4333,6 +4332,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		}
 		goto flush_cap_releases;
 	}
+	ci = ceph_inode(inode);
 
 	/* these will work even if we don't have a cap yet */
 	switch (op) {
-- 
2.27.0

