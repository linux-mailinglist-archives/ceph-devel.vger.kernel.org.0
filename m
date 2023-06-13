Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE67572D911
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbjFMF1k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238899AbjFMF1g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:27:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42CEE7A
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i5oSfBHs0iViwygpNW9THpmUpebmYJx7MntOSD4u+dE=;
        b=FjoqJqQE1Nyk/zNbUzFsT7spG0OtWsaW4kP5vTz/Lpsai4h5wrgz/GyjCvcFQTZDBKSttP
        uucpLmt7D22Wv72opBuNiO/OVi+N9ZCdJyUmI1WkuCEsl4Q9h+T1v4IWYvj+jsWvkty1kY
        23GweriqgpCsXMmygn5TI+ec6PaEuZ8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-udZp68JHNq-kLX-wUvPkyw-1; Tue, 13 Jun 2023 01:26:43 -0400
X-MC-Unique: udZp68JHNq-kLX-wUvPkyw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D6EE1C068E9;
        Tue, 13 Jun 2023 05:26:43 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A2A51121315;
        Tue, 13 Jun 2023 05:26:39 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 01/71] libceph: add spinlock around osd->o_requests
Date:   Tue, 13 Jun 2023 13:23:14 +0800
Message-Id: <20230613052424.254540-2-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
2.40.1

