Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18B55122A3
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiD0T2R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiD0TTL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E8614096
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4C93B8291D
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180F5C385A7;
        Wed, 27 Apr 2022 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086797;
        bh=KPIMaUrv3ahVDlTZhvKlbu0p7ZyDL3VrkfH0rCRjpXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVAJyy0Z88ptUfS0adUubqFg6aKiLKkNcTcAa/2DgX51BdUlghR9v7jpbbLG22MTB
         oHJQEfPVrldResTjo2SAU0pSFSISeWHb/z5e4Lx9XngZqfUy9IiynTwGU3yCQ7PS+n
         pq0HFYqUxjdOdATqLXNk+S5XqR7hUzCZki1oiOi6EKkeGE95TFpscw2auVqRgIffYf
         TnFn05TP1MX2nxECNR4UKdQEDVIIdn1D6pVDvVvauI9n9k4Gtcb5iqMPHm3dgKep7J
         E9q2obQzdbFPYc9eWCfRo3gSR1opPb1AnFqbvtPeKKpyIbnHXwZkctCtVw4bH5wBgB
         e/mMFn8QyayLw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 01/64] libceph: add spinlock around osd->o_requests
Date:   Wed, 27 Apr 2022 15:12:11 -0400
Message-Id: <20220427191314.222867-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In a later patch, we're going to need to search for a request in
the rbtree, but taking the o_mutex is inconvenient as we already
hold the con mutex at the point where we need it.

Add a new spinlock that we take when inserting and erasing entries from
the o_requests tree. Search of the rbtree can be done with either the
mutex or the spinlock, but insertion and removal requires both.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h | 8 +++++++-
 net/ceph/osd_client.c           | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 3431011f364d..3122c1a3205f 100644
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
index 83eb97c94e83..17c792b32343 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1198,6 +1198,7 @@ static void osd_init(struct ceph_osd *osd)
 {
 	refcount_set(&osd->o_ref, 1);
 	RB_CLEAR_NODE(&osd->o_node);
+	spin_lock_init(&osd->o_requests_lock);
 	osd->o_requests = RB_ROOT;
 	osd->o_linger_requests = RB_ROOT;
 	osd->o_backoff_mappings = RB_ROOT;
@@ -1427,7 +1428,9 @@ static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
 		atomic_inc(&osd->o_osdc->num_homeless);
 
 	get_osd(osd);
+	spin_lock(&osd->o_requests_lock);
 	insert_request(&osd->o_requests, req);
+	spin_unlock(&osd->o_requests_lock);
 	req->r_osd = osd;
 }
 
@@ -1439,7 +1442,9 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
 	     req, req->r_tid);
 
 	req->r_osd = NULL;
+	spin_lock(&osd->o_requests_lock);
 	erase_request(&osd->o_requests, req);
+	spin_unlock(&osd->o_requests_lock);
 	put_osd(osd);
 
 	if (!osd_homeless(osd))
-- 
2.35.1

