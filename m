Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6BC55B50F
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jun 2022 04:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiF0CCq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Jun 2022 22:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiF0CCq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Jun 2022 22:02:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B128EB5
        for <ceph-devel@vger.kernel.org>; Sun, 26 Jun 2022 19:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656295364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=687a5XYalXuBNaeVvBtY2sMjG+XnjyBgV+xBEybGQ+M=;
        b=G5sief+5dH34Ra9XhKY9WY6B1gY/4AltINeNJBcNWIJugCmGlmU/4JqNrTxSTvXMChdYlz
        AeIwO+6WoV3vWGNlA2qG/jNBEt3uatTG1HzzWLwdbILgVMrhz3dKj8vZNXB0x82/W0uPPk
        iRn6Q8jP+VZBm0Pw8FrozPXk3XP0FB0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-78VsdImTO0arm0WIoimjHw-1; Sun, 26 Jun 2022 22:02:41 -0400
X-MC-Unique: 78VsdImTO0arm0WIoimjHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 933DB101AA45;
        Mon, 27 Jun 2022 02:02:40 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDD37C28115;
        Mon, 27 Jun 2022 02:02:37 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, pdonnell@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/3] ceph: make f_bsize always equal to f_frsize
Date:   Mon, 27 Jun 2022 10:02:01 +0800
Message-Id: <20220627020203.173293-2-xiubli@redhat.com>
In-Reply-To: <20220627020203.173293-1-xiubli@redhat.com>
References: <20220627020203.173293-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

