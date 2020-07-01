Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6AF210FD4
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 17:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732257AbgGAPyv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 11:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732242AbgGAPyt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 11:54:49 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7015520809;
        Wed,  1 Jul 2020 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593618888;
        bh=6SUZB+ZpSqDaogUqwn6a+ZSM0NiIayXEdhiYSP9EssI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkvWPvnswLnRIQZrLrdvS/bcXli5yDOsuJE3ZSSBfggDiTor2PgEvriQcTvGgdw4r
         lZ4AD79PvapnJ6fJPXnMV9ONui2WQmi3PENhx9sz3VoS8DRrSTPen1x5g2J5dtjuBT
         +gJZbkqEu3a1FZf0MsTbzHr/WwgYQjV5sgVK5ku0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH 2/4] libceph: refactor osdc request initialization
Date:   Wed,  1 Jul 2020 11:54:44 -0400
Message-Id: <20200701155446.41141-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701155446.41141-1-jlayton@kernel.org>
References: <20200701155446.41141-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Turn the request_init helper into a more full-featured initialization
routine that we can use to initialize an already-allocated request.
Make it a public and exported function so we can use it from ceph.ko.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h |  4 ++++
 net/ceph/osd_client.c           | 28 +++++++++++++++-------------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 8d63dc22cb36..40a08c4e5d8d 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -495,6 +495,10 @@ extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
 
 extern void ceph_osdc_get_request(struct ceph_osd_request *req);
 extern void ceph_osdc_put_request(struct ceph_osd_request *req);
+void ceph_osdc_init_request(struct ceph_osd_request *req,
+			    struct ceph_osd_client *osdc,
+			    struct ceph_snap_context *snapc,
+			    unsigned int num_ops);
 
 extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 				   struct ceph_osd_request *req,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 3cff29d38b9f..4ddf23120b1a 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -523,7 +523,10 @@ void ceph_osdc_put_request(struct ceph_osd_request *req)
 }
 EXPORT_SYMBOL(ceph_osdc_put_request);
 
-static void request_init(struct ceph_osd_request *req)
+void ceph_osdc_init_request(struct ceph_osd_request *req,
+			    struct ceph_osd_client *osdc,
+			    struct ceph_snap_context *snapc,
+			    unsigned int num_ops)
 {
 	/* req only, each op is zeroed in osd_req_op_init() */
 	memset(req, 0, sizeof(*req));
@@ -535,7 +538,13 @@ static void request_init(struct ceph_osd_request *req)
 	INIT_LIST_HEAD(&req->r_private_item);
 
 	target_init(&req->r_t);
+
+	req->r_osdc = osdc;
+	req->r_num_ops = num_ops;
+	req->r_snapid = CEPH_NOSNAP;
+	req->r_snapc = ceph_get_snap_context(snapc);
 }
+EXPORT_SYMBOL(ceph_osdc_init_request);
 
 /*
  * This is ugly, but it allows us to reuse linger registration and ping
@@ -563,12 +572,9 @@ static void request_reinit(struct ceph_osd_request *req)
 	WARN_ON(kref_read(&reply_msg->kref) != 1);
 	target_destroy(&req->r_t);
 
-	request_init(req);
-	req->r_osdc = osdc;
+	ceph_osdc_init_request(req, osdc, snapc, num_ops);
 	req->r_mempool = mempool;
-	req->r_num_ops = num_ops;
 	req->r_snapid = snapid;
-	req->r_snapc = snapc;
 	req->r_linger = linger;
 	req->r_request = request_msg;
 	req->r_reply = reply_msg;
@@ -591,15 +597,11 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 		BUG_ON(num_ops > CEPH_OSD_MAX_OPS);
 		req = kmalloc(struct_size(req, r_ops, num_ops), gfp_flags);
 	}
-	if (unlikely(!req))
-		return NULL;
 
-	request_init(req);
-	req->r_osdc = osdc;
-	req->r_mempool = use_mempool;
-	req->r_num_ops = num_ops;
-	req->r_snapid = CEPH_NOSNAP;
-	req->r_snapc = ceph_get_snap_context(snapc);
+	if (likely(req)) {
+		req->r_mempool = use_mempool;
+		ceph_osdc_init_request(req, osdc, snapc, num_ops);
+	}
 
 	dout("%s req %p\n", __func__, req);
 	return req;
-- 
2.26.2

