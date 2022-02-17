Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3CB4B9AB9
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 09:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237351AbiBQIQI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Feb 2022 03:16:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiBQIQH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Feb 2022 03:16:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B70A284207
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 00:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645085753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kajlKJZcEkMmcO+olV5o9exYhUAK7CjFQ6bWAFqfuLA=;
        b=DPjH0qbz89ziMn4hOy/ubntpxeY3OOLRJm2P6mcLDghW6/v5QNiGquYeAOE5w368s/wgqE
        0Ed07+mruSkoMLzaRxf1VQooqbJpjoLvNlT5GvyMuXMZGS7QvkLChMZzi4ls5mR32MZPmL
        PVzH++MZcxtQ/IPAQ78ILSqJoXB5fZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-0ytWs_3CO2W4H6hnOGfLzQ-1; Thu, 17 Feb 2022 03:15:50 -0500
X-MC-Unique: 0ytWs_3CO2W4H6hnOGfLzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E57C5180FCB0;
        Thu, 17 Feb 2022 08:15:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2821F7AB52;
        Thu, 17 Feb 2022 08:15:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: zero the dir_entries memory when allocating it
Date:   Thu, 17 Feb 2022 16:15:42 +0800
Message-Id: <20220217081542.21182-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This potentially will cause bug in future if using the old ceph
version and some members may skipped initialized in handle_reply.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 93e5e3c4ba64..c3b1e73c5fbf 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2286,7 +2286,8 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 	order = get_order(size * num_entries);
 	while (order >= 0) {
 		rinfo->dir_entries = (void*)__get_free_pages(GFP_KERNEL |
-							     __GFP_NOWARN,
+							     __GFP_NOWARN |
+							     __GFP_ZERO,
 							     order);
 		if (rinfo->dir_entries)
 			break;
-- 
2.27.0

