Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFBA210FD5
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgGAPyv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 11:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732244AbgGAPyt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 11:54:49 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7C352080D;
        Wed,  1 Jul 2020 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593618889;
        bh=/3+GVsjn7vhyVn9Cm/royUfnOHGEjNmn+/w0sYtEAJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htjeT401Xxz//zyRisnGSVUgbf4OqT5cxUg4oEPg5aGbjagH/iXJEI8lrr8tdU023
         pzOIFo8ehO3ccKZvD0bGq9niyxo7ghlQVLlfCEt9yU6xe+7n1p8zFOMG88R8KpcrIk
         qUB4we50X2UsqPG0mqcOUHfWXkIqRVAuEPr6HuNs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH 3/4] libceph: rename __ceph_osdc_alloc_messages to ceph_osdc_alloc_num_messages
Date:   Wed,  1 Jul 2020 11:54:45 -0400
Message-Id: <20200701155446.41141-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701155446.41141-1-jlayton@kernel.org>
References: <20200701155446.41141-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...and make it public and export it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h |  3 +++
 net/ceph/osd_client.c           | 13 +++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 40a08c4e5d8d..71b7610c3a3c 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -481,6 +481,9 @@ extern struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *
 					       unsigned int num_ops,
 					       bool use_mempool,
 					       gfp_t gfp_flags);
+int ceph_osdc_alloc_num_messages(struct ceph_osd_request *req, gfp_t gfp,
+				 int num_request_data_items,
+				 int num_reply_data_items);
 int ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp);
 
 extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 4ddf23120b1a..7be78fa6e2c3 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -613,9 +613,9 @@ static int ceph_oloc_encoding_size(const struct ceph_object_locator *oloc)
 	return 8 + 4 + 4 + 4 + (oloc->pool_ns ? oloc->pool_ns->len : 0);
 }
 
-static int __ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp,
-				      int num_request_data_items,
-				      int num_reply_data_items)
+int ceph_osdc_alloc_num_messages(struct ceph_osd_request *req, gfp_t gfp,
+				 int num_request_data_items,
+				 int num_reply_data_items)
 {
 	struct ceph_osd_client *osdc = req->r_osdc;
 	struct ceph_msg *msg;
@@ -672,6 +672,7 @@ static int __ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp,
 
 	return 0;
 }
+EXPORT_SYMBOL(ceph_osdc_alloc_num_messages);
 
 static bool osd_req_opcode_valid(u16 opcode)
 {
@@ -738,8 +739,8 @@ int ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp)
 	int num_request_data_items, num_reply_data_items;
 
 	get_num_data_items(req, &num_request_data_items, &num_reply_data_items);
-	return __ceph_osdc_alloc_messages(req, gfp, num_request_data_items,
-					  num_reply_data_items);
+	return ceph_osdc_alloc_num_messages(req, gfp, num_request_data_items,
+						  num_reply_data_items);
 }
 EXPORT_SYMBOL(ceph_osdc_alloc_messages);
 
@@ -1129,7 +1130,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 		 * also covers ceph_uninline_data().  If more multi-op request
 		 * use cases emerge, we will need a separate helper.
 		 */
-		r = __ceph_osdc_alloc_messages(req, GFP_NOFS, num_ops, 0);
+		r = ceph_osdc_alloc_num_messages(req, GFP_NOFS, num_ops, 0);
 	else
 		r = ceph_osdc_alloc_messages(req, GFP_NOFS);
 	if (r)
-- 
2.26.2

