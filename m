Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0A9505790
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 15:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbiDRNy4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 09:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245344AbiDRNx0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 09:53:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87B69632C
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 06:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650286958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1A/3foG/3Vu4oHg4QOZEJrzpZDEUW4nKG+JqNFP2qs=;
        b=U3/OF6U2x32Mmf6aK3qLjjsbMYXm3IF+8K/JL7h6E5SUMTEjalAeE5jwQrXXiU/oGZ+lDI
        h4c2icD1Cwy3DJVb0Uo6qC6e+P5vk+lQDMl5e4vRP+sq/57JtTsdhFmfpVyhA3rr6bLzHI
        3nZ0flIIAndLRBuP7VjG6rH8nRQtUxA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-VE5nT618MzO43tdKQGMprg-1; Mon, 18 Apr 2022 09:02:37 -0400
X-MC-Unique: VE5nT618MzO43tdKQGMprg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBF94899EC1;
        Mon, 18 Apr 2022 13:02:36 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DE4740FF407;
        Mon, 18 Apr 2022 13:02:35 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/2] ceph: flush the mdlog for filesystem sync
Date:   Mon, 18 Apr 2022 21:02:18 +0800
Message-Id: <20220418130218.738980-3-xiubli@redhat.com>
In-Reply-To: <20220418130218.738980-1-xiubli@redhat.com>
References: <20220418130218.738980-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Before waiting for a request's safe reply, we will send the mdlog
flush request to the relevant MDS. And this will also flush the
mdlog for all the other unsafe requests in the same session, so
we can record the last session and no need to flush mdlog again
in the next loop. But there still have cases that it may send the
mdlog flush requst twice or more, but that should be not often.

Rename wait_unsafe_requests() to flush_mdlog_and_wait_inode_unsafe_requests()
to make it more descriptive.

URL: https://tracker.ceph.com/issues/55284
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0da85c9ce73a..94bd4dd956fd 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5093,15 +5093,17 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 }
 
 /*
- * wait for all write mds requests to flush.
+ * flush the mdlog and wait for all write mds requests to flush.
  */
-static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
+static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *mdsc,
+						 u64 want_tid)
 {
 	struct ceph_mds_request *req = NULL, *nextreq;
+	struct ceph_mds_session *last_session = NULL, *s;
 	struct rb_node *n;
 
 	mutex_lock(&mdsc->mutex);
-	dout("wait_unsafe_requests want %lld\n", want_tid);
+	dout("%s want %lld\n", __func__, want_tid);
 restart:
 	req = __get_oldest_req(mdsc);
 	while (req && req->r_tid <= want_tid) {
@@ -5117,8 +5119,20 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 			ceph_mdsc_get_request(req);
 			if (nextreq)
 				ceph_mdsc_get_request(nextreq);
+
+			s = req->r_session;
+			if (!s) {
+				req = nextreq;
+				continue;
+			}
+			/* send flush mdlog request to MDS */
+			if (last_session != s) {
+				send_flush_mdlog(s);
+				ceph_put_mds_session(last_session);
+				last_session = ceph_get_mds_session(s);
+			}
 			mutex_unlock(&mdsc->mutex);
-			dout("wait_unsafe_requests  wait on %llu (want %llu)\n",
+			dout("%s wait on %llu (want %llu)\n", __func__,
 			     req->r_tid, want_tid);
 			wait_for_completion(&req->r_safe_completion);
 			mutex_lock(&mdsc->mutex);
@@ -5135,7 +5149,8 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 		req = nextreq;
 	}
 	mutex_unlock(&mdsc->mutex);
-	dout("wait_unsafe_requests done\n");
+	ceph_put_mds_session(last_session);
+	dout("%s done\n", __func__);
 }
 
 void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
@@ -5164,7 +5179,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
 	dout("sync want tid %lld flush_seq %lld\n",
 	     want_tid, want_flush);
 
-	wait_unsafe_requests(mdsc, want_tid);
+	flush_mdlog_and_wait_mdsc_unsafe_requests(mdsc, want_tid);
 	wait_caps_flush(mdsc, want_flush);
 }
 
-- 
2.36.0.rc1

