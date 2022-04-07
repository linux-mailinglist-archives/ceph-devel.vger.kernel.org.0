Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C64F81FF
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 16:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344187AbiDGOng (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 10:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiDGOng (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 10:43:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0463054BEF
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 07:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649342495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SDugp1WBSMptX4svFmhmWUwSo8QzNCtx0JtBllquiA=;
        b=Sso3OPnrhTsm/rSnLZLejBk8yBuENfiojVceMhUEueq7q8UshxDEUcoJtXO1rSgjInoEhb
        GYy/KC2sTjD358t6M8DIMegiibnqK2vTO/6FH3Ir/7pVBkX+OcsPExxebJkdjbvHnYYTVc
        b7op+Ciwf4kEG/FM99bJFnMNB/amPLo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-CyhjVEWBNtqYeXrGs8xCTQ-1; Thu, 07 Apr 2022 10:41:33 -0400
X-MC-Unique: CyhjVEWBNtqYeXrGs8xCTQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44CF53811F32;
        Thu,  7 Apr 2022 14:41:33 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2EE5403153;
        Thu,  7 Apr 2022 14:41:30 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: flush small range instead of the whole map for truncate
Date:   Thu,  7 Apr 2022 22:41:11 +0800
Message-Id: <20220407144112.8455-2-xiubli@redhat.com>
In-Reply-To: <20220407144112.8455-1-xiubli@redhat.com>
References: <20220407144112.8455-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 45ca4e598ef0..f4059d73edd5 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2275,8 +2275,12 @@ static int fill_fscrypt_truncate(struct inode *inode,
 	     ceph_cap_string(issued));
 
 	/* Try to writeback the dirty pagecaches */
-	if (issued & (CEPH_CAP_FILE_BUFFER))
-		filemap_write_and_wait(inode->i_mapping);
+	if (issued & (CEPH_CAP_FILE_BUFFER)) {
+		ret = filemap_write_and_wait_range(inode->i_mapping,
+						   orig_pos, LLONG_MAX);
+		if (ret < 0)
+			goto out;
+	}
 
 	page = __page_cache_alloc(GFP_KERNEL);
 	if (page == NULL) {
-- 
2.27.0

