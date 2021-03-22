Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6ED3440F9
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Mar 2021 13:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhCVM3Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Mar 2021 08:29:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229930AbhCVM3I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 08:29:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616416147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fvKNr9qq395ZhEPbpjgzrSL7gjwowWPVSS7tSRI0dnk=;
        b=KzAyqVS3ORuI8TljgJqlNSLfAYRLMKtg9ykRxODYtl9x5z9QrE1X1lmxHkj/gUFai+4jC8
        Cc2Fwimqz6CkTzUgWdYNDP7y8ME99NuyTL/COugbhWZgQpJ/V6EHOHDU6NFRIu6nP2HsDb
        JKvGrmCYJ75prUnrD3O+dHzS5Pya+w4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-6MyCUn95NGS3TX2qxfZ9QA-1; Mon, 22 Mar 2021 08:29:05 -0400
X-MC-Unique: 6MyCUn95NGS3TX2qxfZ9QA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C137818C89C4;
        Mon, 22 Mar 2021 12:29:04 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE2945886A;
        Mon, 22 Mar 2021 12:29:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/4] ceph: avoid count the same request twice or more
Date:   Mon, 22 Mar 2021 20:28:51 +0800
Message-Id: <20210322122852.322927-4-xiubli@redhat.com>
In-Reply-To: <20210322122852.322927-1-xiubli@redhat.com>
References: <20210322122852.322927-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the request will retry, skip updating the latency metric.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index a27aabcb0e0b..31542eac7e59 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1037,16 +1037,6 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
 	     inode, rc, osd_data->bvec_pos.iter.bi_size);
 
-	/* r_start_latency == 0 means the request was not submitted */
-	if (req->r_start_latency) {
-		if (aio_req->write)
-			ceph_update_write_metrics(metric, req->r_start_latency,
-						  req->r_end_latency, rc);
-		else
-			ceph_update_read_metrics(metric, req->r_start_latency,
-						 req->r_end_latency, rc);
-	}
-
 	if (rc == -EOLDSNAPC) {
 		struct ceph_aio_work *aio_work;
 		BUG_ON(!aio_req->write);
@@ -1089,6 +1079,16 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 		}
 	}
 
+	/* r_start_latency == 0 means the request was not submitted */
+	if (req->r_start_latency) {
+		if (aio_req->write)
+			ceph_update_write_metrics(metric, req->r_start_latency,
+						  req->r_end_latency, rc);
+		else
+			ceph_update_read_metrics(metric, req->r_start_latency,
+						 req->r_end_latency, rc);
+	}
+
 	put_bvecs(osd_data->bvec_pos.bvecs, osd_data->num_bvecs,
 		  aio_req->should_dirty);
 	ceph_osdc_put_request(req);
-- 
2.27.0

