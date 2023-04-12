Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BD16DF32F
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjDLLZU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjDLLZJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:25:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1F21FE0
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pln8x1pSf1F/UGh2SztM6dmsayn0LV29yUk+OwBN0Z4=;
        b=K3vcvBWkPHu5VCN9giKZo8d13ekwEOQhDCacdYsZzSOz5N2WpmwU9MEgiADJ95eLLXXTFm
        YEL1hNJixM48OpwnCggH2zm0EDsLHCb42iaAmkLm9jgK6HKAvPCjovZhBh/mLt9s9B/WYT
        66uE5lkqWI4NAc2lXmwASOXNVu1tcfo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-0gfWU1LwP2qdLJd-Y-ykng-1; Wed, 12 Apr 2023 07:09:52 -0400
X-MC-Unique: 0gfWU1LwP2qdLJd-Y-ykng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C43B5858289;
        Wed, 12 Apr 2023 11:09:51 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC3DFC15BB8;
        Wed, 12 Apr 2023 11:09:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 01/71] libceph: add spinlock around osd->o_requests
Date:   Wed, 12 Apr 2023 19:08:20 +0800
Message-Id: <20230412110930.176835-2-xiubli@redhat.com>
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

In a later patch, we're going to need to search for a request in
the rbtree, but taking the o_mutex is inconvenient as we already
hold the con mutex at the point where we need it.

Add a new spinlock that we take when inserting and erasing entries from
the o_requests tree. Search of the rbtree can be done with either the
mutex or the spinlock, but insertion and removal requires both.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h | 8 +++++++-
 net/ceph/osd_client.c           | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index fb6be72104df..92addef18738 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -29,7 +29,12 @@ typedef void (*ceph_osdc_callback_t)(struct ceph_osd_request *);
 
 #define CEPH_HOMELESS_OSD	-1
 
-/* a given osd we're communicating with */
+/*
+ * A given osd we're communicating with.
+ *
+ * Note that the o_requests tree can be searched while holding the "lock" mutex
+ * or the "o_requests_lock" spinlock. Insertion or removal requires both!
+ */
 struct ceph_osd {
 	refcount_t o_ref;
 	struct ceph_osd_client *o_osdc;
@@ -37,6 +42,7 @@ struct ceph_osd {
 	int o_incarnation;
 	struct rb_node o_node;
 	struct ceph_connection o_con;
+	spinlock_t o_requests_lock;
 	struct rb_root o_requests;
 	struct rb_root o_linger_requests;
 	struct rb_root o_backoff_mappings;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 11c04e7d928e..a827995faba7 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1177,6 +1177,7 @@ static void osd_init(struct ceph_osd *osd)
 {
 	refcount_set(&osd->o_ref, 1);
 	RB_CLEAR_NODE(&osd->o_node);
+	spin_lock_init(&osd->o_requests_lock);
 	osd->o_requests = RB_ROOT;
 	osd->o_linger_requests = RB_ROOT;
 	osd->o_backoff_mappings = RB_ROOT;
@@ -1406,7 +1407,9 @@ static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
 		atomic_inc(&osd->o_osdc->num_homeless);
 
 	get_osd(osd);
+	spin_lock(&osd->o_requests_lock);
 	insert_request(&osd->o_requests, req);
+	spin_unlock(&osd->o_requests_lock);
 	req->r_osd = osd;
 }
 
@@ -1418,7 +1421,9 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
 	     req, req->r_tid);
 
 	req->r_osd = NULL;
+	spin_lock(&osd->o_requests_lock);
 	erase_request(&osd->o_requests, req);
+	spin_unlock(&osd->o_requests_lock);
 	put_osd(osd);
 
 	if (!osd_homeless(osd))
-- 
2.39.2

