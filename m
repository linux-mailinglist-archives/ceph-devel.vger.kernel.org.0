Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38895596D2
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jun 2022 11:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiFXJhu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Jun 2022 05:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiFXJhp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 Jun 2022 05:37:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0049E79454
        for <ceph-devel@vger.kernel.org>; Fri, 24 Jun 2022 02:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656063463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=687a5XYalXuBNaeVvBtY2sMjG+XnjyBgV+xBEybGQ+M=;
        b=YGDOhhvw4UZ+fnfsor/HyVRkdGPKB2snRyWOauoc9BkiRC2ipEP4J3pA2FXQHdDhMN63He
        ZxtXRvwKdpA7zrNFFCRozekpu2bPuKjUP45u7ZDII97av3EyNM+rPm/ZDwt3f2Gtaxgi7s
        uxwHtsTG2Th3q+3o3XXJNQezWQ7HBsU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-t8nVZEDXOIeBQHJ39fTPpg-1; Fri, 24 Jun 2022 05:37:40 -0400
X-MC-Unique: t8nVZEDXOIeBQHJ39fTPpg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 875C81044562;
        Fri, 24 Jun 2022 09:37:40 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D66D1121315;
        Fri, 24 Jun 2022 09:37:37 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, pdonnell@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: make f_bsize always equal to f_frsize
Date:   Fri, 24 Jun 2022 17:37:29 +0800
Message-Id: <20220624093730.8564-2-xiubli@redhat.com>
In-Reply-To: <20220624093730.8564-1-xiubli@redhat.com>
References: <20220624093730.8564-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The f_frsize maybe changed in the quota size is less than the defualt
4MB.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 74f9cc5f37e9..88d7e67130b8 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -70,17 +70,6 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	/* fill in kstatfs */
 	buf->f_type = CEPH_SUPER_MAGIC;  /* ?? */
-
-	/*
-	 * express utilization in terms of large blocks to avoid
-	 * overflow on 32-bit machines.
-	 *
-	 * NOTE: for the time being, we make bsize == frsize to humor
-	 * not-yet-ancient versions of glibc that are broken.
-	 * Someday, we will probably want to report a real block
-	 * size...  whatever that may mean for a network file system!
-	 */
-	buf->f_bsize = 1 << CEPH_BLOCK_SHIFT;
 	buf->f_frsize = 1 << CEPH_BLOCK_SHIFT;
 
 	/*
@@ -95,6 +84,17 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 		buf->f_bavail = le64_to_cpu(st.kb_avail) >> (CEPH_BLOCK_SHIFT-10);
 	}
 
+	/*
+	 * express utilization in terms of large blocks to avoid
+	 * overflow on 32-bit machines.
+	 *
+	 * NOTE: for the time being, we make bsize == frsize to humor
+	 * not-yet-ancient versions of glibc that are broken.
+	 * Someday, we will probably want to report a real block
+	 * size...  whatever that may mean for a network file system!
+	 */
+	buf->f_bsize = buf->f_frsize;
+
 	buf->f_files = le64_to_cpu(st.num_objects);
 	buf->f_ffree = -1;
 	buf->f_namelen = NAME_MAX;
-- 
2.36.0.rc1

