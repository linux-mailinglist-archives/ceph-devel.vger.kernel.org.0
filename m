Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B156DF2E5
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjDLLQK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjDLLQH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:16:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED638687
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGDY0llPdUOZbR/c5nKwopu+Fff+ftLZmhhEzsb7sSM=;
        b=CXoy0u/YgP/8MkHT4svntqfWQBjUtgB29SPjzn8Zgmqg2oQuUw2c5LN5a3COMsYo00WQIK
        bCozQpMuDr/YygAevi/sqyJc/1sJeFZjnuS6SQbaIgoRWK1wizm+yO2vRg2G09tUpexQCz
        8Jq7FeVKEZNKYej1TF2bKnL5wHT8HSI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-DpQ-R25iMRSRfbwsfrfxUw-1; Wed, 12 Apr 2023 07:13:51 -0400
X-MC-Unique: DpQ-R25iMRSRfbwsfrfxUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3059828237C4;
        Wed, 12 Apr 2023 11:13:51 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EF4CC15BB8;
        Wed, 12 Apr 2023 11:13:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 50/71] libceph: allow ceph_osdc_new_request to accept a multi-op read
Date:   Wed, 12 Apr 2023 19:09:09 +0800
Message-Id: <20230412110930.176835-51-xiubli@redhat.com>
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

From: Jeff Layton <jlayton@kernel.org>

Currently we have some special-casing for multi-op writes, but in the
case of a read, we can't really handle it. All of the current multi-op
callers call it with CEPH_OSD_FLAG_WRITE set.

Have ceph_osdc_new_request check for CEPH_OSD_FLAG_READ and if it's set,
allocate multiple reply ops instead of multiple request ops. If neither
flag is set, return -EINVAL.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/osd_client.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 2dcb1140ed21..78b622178a3d 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1136,15 +1136,30 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	if (flags & CEPH_OSD_FLAG_WRITE)
 		req->r_data_offset = off;
 
-	if (num_ops > 1)
+	if (num_ops > 1) {
+		int num_req_ops, num_rep_ops;
+
 		/*
-		 * This is a special case for ceph_writepages_start(), but it
-		 * also covers ceph_uninline_data().  If more multi-op request
-		 * use cases emerge, we will need a separate helper.
+		 * If this is a multi-op write request, assume that we'll need
+		 * request ops. If it's a multi-op read then assume we'll need
+		 * reply ops. Anything else and call it -EINVAL.
 		 */
-		r = __ceph_osdc_alloc_messages(req, GFP_NOFS, num_ops, 0);
-	else
+		if (flags & CEPH_OSD_FLAG_WRITE) {
+			num_req_ops = num_ops;
+			num_rep_ops = 0;
+		} else if (flags & CEPH_OSD_FLAG_READ) {
+			num_req_ops = 0;
+			num_rep_ops = num_ops;
+		} else {
+			r = -EINVAL;
+			goto fail;
+		}
+
+		r = __ceph_osdc_alloc_messages(req, GFP_NOFS, num_req_ops,
+					       num_rep_ops);
+	} else {
 		r = ceph_osdc_alloc_messages(req, GFP_NOFS);
+	}
 	if (r)
 		goto fail;
 
-- 
2.39.2

