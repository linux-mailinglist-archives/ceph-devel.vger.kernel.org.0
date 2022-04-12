Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E2B4FD6E3
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Apr 2022 12:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351663AbiDLJwk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Apr 2022 05:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351230AbiDLH2A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 12 Apr 2022 03:28:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 797C94EF5F
        for <ceph-devel@vger.kernel.org>; Tue, 12 Apr 2022 00:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649747279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IRF6LVwJSHJOWFm7I1F+YrA+lOMpLLhwycut1OVWExo=;
        b=eAFR3iuBPcRl+TmQ/4lSNwjhh/25VexeKDNpe3teqaTeboqHIDZ4ZqnsQ4VQ5AqJSjwOzo
        0IgyHTBYJQZD0ohSV6gu7emg6bahGRZXzkHNKJBmwCP5RNy77Utn3gHzGB2/Dw6U+HIUph
        Re4/l1Da0Tq9/d4kYoKwH9BeSpEIQX4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-ZDLDB1h0PJa-m8ZfoBguNg-1; Tue, 12 Apr 2022 03:07:55 -0400
X-MC-Unique: ZDLDB1h0PJa-m8ZfoBguNg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45451185A7B2;
        Tue, 12 Apr 2022 07:07:55 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FDE140CF91A;
        Tue, 12 Apr 2022 07:07:54 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 1/3] ceph: flush small range instead of the whole map for truncate
Date:   Tue, 12 Apr 2022 15:07:43 +0800
Message-Id: <20220412070745.22795-2-xiubli@redhat.com>
In-Reply-To: <20220412070745.22795-1-xiubli@redhat.com>
References: <20220412070745.22795-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index fa0d3018d981..a5145a2b7228 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2274,8 +2274,13 @@ static int fill_fscrypt_truncate(struct inode *inode,
 	     ceph_cap_string(issued));
 
 	/* Try to writeback the dirty pagecaches */
-	if (issued & (CEPH_CAP_FILE_BUFFER))
-		filemap_write_and_wait(inode->i_mapping);
+	if (issued & (CEPH_CAP_FILE_BUFFER)) {
+		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;
+		ret = filemap_write_and_wait_range(inode->i_mapping,
+						   orig_pos, lend);
+		if (ret < 0)
+			goto out;
+	}
 
 	page = __page_cache_alloc(GFP_KERNEL);
 	if (page == NULL) {
-- 
2.36.0.rc1

