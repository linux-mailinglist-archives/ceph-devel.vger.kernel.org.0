Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E014F751B
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 07:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239942AbiDGFPE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 01:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240845AbiDGFPC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 01:15:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E0A195A25
        for <ceph-devel@vger.kernel.org>; Wed,  6 Apr 2022 22:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649308381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LXmWY885dYkz278JWotsje9TwgU+zCjsDDes5IUL+aM=;
        b=Esp9wz4sze4sFe+RoRKjv7hwlzGgWm4hNdrhi1T2xPB1i7p64O5J5vi6ujyT7+AS1gztJn
        bQiTRyH3H57YSWYhWMSSjaWt+HPHCbZzuPuTycwEt2k2aDhQG/NxOZJwewwB5Kgu6zDdSp
        E/CsFPM63dx4WESBA55oiS1aoumCfF8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-5E3r0g_iOYy6XRFQmeJsnw-1; Thu, 07 Apr 2022 01:12:55 -0400
X-MC-Unique: 5E3r0g_iOYy6XRFQmeJsnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDD9F8038E3;
        Thu,  7 Apr 2022 05:12:54 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09779145B971;
        Thu,  7 Apr 2022 05:12:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] ceph: no need to invalidate the fscache twice
Date:   Thu,  7 Apr 2022 13:12:42 +0800
Message-Id: <20220407051242.692846-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Introduced by commit 400e1286c0ec3: "ceph: conversion to new fscache API" ]

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Jeff, is there any reason we need to invalidate the fscache twice in
ceph_do_invalidate_pages() ?


 fs/ceph/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index cc1829ab497d..b721d86fb582 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2084,7 +2084,6 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
-	ceph_fscache_invalidate(inode, false);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_inode_pages2 %llx.%llx failed\n",
 		       ceph_vinop(inode));
-- 
2.27.0

