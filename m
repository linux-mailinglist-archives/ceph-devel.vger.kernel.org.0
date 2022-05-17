Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F3B529E83
	for <lists+ceph-devel@lfdr.de>; Tue, 17 May 2022 11:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243949AbiEQJyG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 May 2022 05:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240150AbiEQJyF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 May 2022 05:54:05 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046223524B
        for <ceph-devel@vger.kernel.org>; Tue, 17 May 2022 02:54:04 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i40so6669217eda.7
        for <ceph-devel@vger.kernel.org>; Tue, 17 May 2022 02:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V4a0YSmulxpZGfrQ/2LkJtnUz7af8PZBnUxMo/V98Dk=;
        b=dQ5FkufSu1HPW9s0ppiP3KRXfDTsk3eyapA6ZP9hzmRX51DYVqbDxycrekzhvwQ3n4
         kmUiyPUbIrW3ZeQecOMJjluMkYgjLVntyem3SDatr8RVqFGipbTznNOG9RT3iGQYdQi3
         JVwMJq9kdQVGrTnJ5X8IaxKAIh3lHLHUrKpXo/ixWHd0g3yIyjIZOQQKgdiTF16hUlt0
         zr6J+WWCjhKoM4/3E6gbDqX1FlbAxwRahPKjm6ZJ5/Cdk6/RpMoBqNxN4C2nj/Ndc3Vg
         Yj1KkNLRchrnDQ90R6tsvvTIUrcGQZbyKZfacqO0vKDYgQG/QdmXHbGnC4wy9/c/1ep4
         AN7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V4a0YSmulxpZGfrQ/2LkJtnUz7af8PZBnUxMo/V98Dk=;
        b=xQdheSCLDFSxhxzahCjdwgvePqzSDTCJUjdbSP4BwI9O4uDRdRhFfoh3JUU0/yvrfU
         1mGbrQRjPabdzILtSSqYV0nINcfitqQDBJaqPtT1zhf+AnTHHuttWO421qW6ElM/Jo1L
         2a+3yjangnM4xE3vSLJIg+y3aMKXprYr/l/70LC9XWNGvG4oIDYEXLMLD1krH4u6h5EC
         7YY5l0sxJsntQEWCxO0/CBqHkKrPPbK3JySGoLenXmqmNzfWjiXidmLRb/5YnQ2XEuYp
         y8eJkPOutGBZuz4cPLQrQZXKqLaXMYwIoTt1At47k9tyympfEms1IjJylQzczIr++Td6
         JA/w==
X-Gm-Message-State: AOAM533dc1QCsDUuLHiV4Bpsfd+/UTYYEO+paZ8Tt9dUkqAPQhN+2qRv
        XoD9c0t2NRyY0PXyipSK+8GpX5gWTmhsoQ==
X-Google-Smtp-Source: ABdhPJyMwLPFDDOJKubib2QI+nBMsur26VViXSXdTQ5/Eo0+j5GNj8hhl8acaywOLPKtcdu4XI8ugg==
X-Received: by 2002:aa7:cb1a:0:b0:41c:dd9c:2eaa with SMTP id s26-20020aa7cb1a000000b0041cdd9c2eaamr17619297edt.119.1652781242455;
        Tue, 17 May 2022 02:54:02 -0700 (PDT)
Received: from kwango.local (ip-89-102-68-162.net.upcbroadband.cz. [89.102.68.162])
        by smtp.gmail.com with ESMTPSA id n16-20020aa7db50000000b0042ad0358c8bsm16740edt.38.2022.05.17.02.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 02:54:02 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] libceph: fix potential use-after-free on linger ping and resends
Date:   Tue, 17 May 2022 11:53:46 +0200
Message-Id: <20220517095346.14984-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

request_reinit() is not only ugly as the comment rightfully suggests,
but also unsafe.  Even though it is called with osdc->lock held for
write in all cases, resetting the OSD request refcount can still race
with handle_reply() and result in use-after-free.  Taking linger ping
as an example:

    handle_timeout thread                     handle_reply thread

                                              down_read(&osdc->lock)
                                              req = lookup_request(...)
                                              ...
                                              finish_request(req)  # unregisters
                                              up_read(&osdc->lock)
                                              __complete_request(req)
                                                linger_ping_cb(req)

      # req->r_kref == 2 because handle_reply still holds its ref

    down_write(&osdc->lock)
    send_linger_ping(lreq)
      req = lreq->ping_req  # same req
      # cancel_linger_request is NOT
      # called - handle_reply already
      # unregistered
      request_reinit(req)
        WARN_ON(req->r_kref != 1)  # fires
        request_init(req)
          kref_init(req->r_kref)

                   # req->r_kref == 1 after kref_init

                                              ceph_osdc_put_request(req)
                                                kref_put(req->r_kref)

            # req->r_kref == 0 after kref_put, req is freed

        <further req initialization/use> !!!

This happens because send_linger_ping() always (re)uses the same OSD
request for watch ping requests, relying on cancel_linger_request() to
unregister it from the OSD client and rip its messages out from the
messenger.  seng_linger() does the same for watch/notify registration
and watch reconnect requests.  Unfortunately cancel_request() doesn't
guarantee that after it returns the OSD client would be completely done
with the OSD request -- a ref could still be held and the callback (if
specified) could still be invoked too.

The original motivation for request_reinit() was inability to deal with
allocation failures in send_linger() and send_linger_ping().  Switching
to using osdc->req_mempool (currently only used by CephFS) respects that
and allows us to get rid of request_reinit().

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/osd_client.h |   3 +
 net/ceph/osd_client.c           | 302 +++++++++++++-------------------
 2 files changed, 122 insertions(+), 183 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 3431011f364d..cba8a6ffc329 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -287,6 +287,9 @@ struct ceph_osd_linger_request {
 	rados_watcherrcb_t errcb;
 	void *data;
 
+	struct ceph_pagelist *request_pl;
+	struct page **notify_id_pages;
+
 	struct page ***preply_pages;
 	size_t *preply_len;
 };
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 83eb97c94e83..4b88f2a4a6e2 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -537,43 +537,6 @@ static void request_init(struct ceph_osd_request *req)
 	target_init(&req->r_t);
 }
 
-/*
- * This is ugly, but it allows us to reuse linger registration and ping
- * requests, keeping the structure of the code around send_linger{_ping}()
- * reasonable.  Setting up a min_nr=2 mempool for each linger request
- * and dealing with copying ops (this blasts req only, watch op remains
- * intact) isn't any better.
- */
-static void request_reinit(struct ceph_osd_request *req)
-{
-	struct ceph_osd_client *osdc = req->r_osdc;
-	bool mempool = req->r_mempool;
-	unsigned int num_ops = req->r_num_ops;
-	u64 snapid = req->r_snapid;
-	struct ceph_snap_context *snapc = req->r_snapc;
-	bool linger = req->r_linger;
-	struct ceph_msg *request_msg = req->r_request;
-	struct ceph_msg *reply_msg = req->r_reply;
-
-	dout("%s req %p\n", __func__, req);
-	WARN_ON(kref_read(&req->r_kref) != 1);
-	request_release_checks(req);
-
-	WARN_ON(kref_read(&request_msg->kref) != 1);
-	WARN_ON(kref_read(&reply_msg->kref) != 1);
-	target_destroy(&req->r_t);
-
-	request_init(req);
-	req->r_osdc = osdc;
-	req->r_mempool = mempool;
-	req->r_num_ops = num_ops;
-	req->r_snapid = snapid;
-	req->r_snapc = snapc;
-	req->r_linger = linger;
-	req->r_request = request_msg;
-	req->r_reply = reply_msg;
-}
-
 struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 					       struct ceph_snap_context *snapc,
 					       unsigned int num_ops,
@@ -918,14 +881,30 @@ EXPORT_SYMBOL(osd_req_op_xattr_init);
  * @watch_opcode: CEPH_OSD_WATCH_OP_*
  */
 static void osd_req_op_watch_init(struct ceph_osd_request *req, int which,
-				  u64 cookie, u8 watch_opcode)
+				  u8 watch_opcode, u64 cookie, u32 gen)
 {
 	struct ceph_osd_req_op *op;
 
 	op = osd_req_op_init(req, which, CEPH_OSD_OP_WATCH, 0);
 	op->watch.cookie = cookie;
 	op->watch.op = watch_opcode;
-	op->watch.gen = 0;
+	op->watch.gen = gen;
+}
+
+/*
+ * prot_ver, timeout and notify payload (may be empty) should already be
+ * encoded in @request_pl
+ */
+static void osd_req_op_notify_init(struct ceph_osd_request *req, int which,
+				   u64 cookie, struct ceph_pagelist *request_pl)
+{
+	struct ceph_osd_req_op *op;
+
+	op = osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
+	op->notify.cookie = cookie;
+
+	ceph_osd_data_pagelist_init(&op->notify.request_data, request_pl);
+	op->indata_len = request_pl->length;
 }
 
 /*
@@ -2731,10 +2710,13 @@ static void linger_release(struct kref *kref)
 	WARN_ON(!list_empty(&lreq->pending_lworks));
 	WARN_ON(lreq->osd);
 
-	if (lreq->reg_req)
-		ceph_osdc_put_request(lreq->reg_req);
-	if (lreq->ping_req)
-		ceph_osdc_put_request(lreq->ping_req);
+	if (lreq->request_pl)
+		ceph_pagelist_release(lreq->request_pl);
+	if (lreq->notify_id_pages)
+		ceph_release_page_vector(lreq->notify_id_pages, 1);
+
+	ceph_osdc_put_request(lreq->reg_req);
+	ceph_osdc_put_request(lreq->ping_req);
 	target_destroy(&lreq->t);
 	kfree(lreq);
 }
@@ -3003,6 +2985,12 @@ static void linger_commit_cb(struct ceph_osd_request *req)
 	struct ceph_osd_linger_request *lreq = req->r_priv;
 
 	mutex_lock(&lreq->lock);
+	if (req != lreq->reg_req) {
+		dout("%s lreq %p linger_id %llu unknown req (%p != %p)\n",
+		     __func__, lreq, lreq->linger_id, req, lreq->reg_req);
+		goto out;
+	}
+
 	dout("%s lreq %p linger_id %llu result %d\n", __func__, lreq,
 	     lreq->linger_id, req->r_result);
 	linger_reg_commit_complete(lreq, req->r_result);
@@ -3026,6 +3014,7 @@ static void linger_commit_cb(struct ceph_osd_request *req)
 		}
 	}
 
+out:
 	mutex_unlock(&lreq->lock);
 	linger_put(lreq);
 }
@@ -3048,6 +3037,12 @@ static void linger_reconnect_cb(struct ceph_osd_request *req)
 	struct ceph_osd_linger_request *lreq = req->r_priv;
 
 	mutex_lock(&lreq->lock);
+	if (req != lreq->reg_req) {
+		dout("%s lreq %p linger_id %llu unknown req (%p != %p)\n",
+		     __func__, lreq, lreq->linger_id, req, lreq->reg_req);
+		goto out;
+	}
+
 	dout("%s lreq %p linger_id %llu result %d last_error %d\n", __func__,
 	     lreq, lreq->linger_id, req->r_result, lreq->last_error);
 	if (req->r_result < 0) {
@@ -3057,46 +3052,64 @@ static void linger_reconnect_cb(struct ceph_osd_request *req)
 		}
 	}
 
+out:
 	mutex_unlock(&lreq->lock);
 	linger_put(lreq);
 }
 
 static void send_linger(struct ceph_osd_linger_request *lreq)
 {
-	struct ceph_osd_request *req = lreq->reg_req;
-	struct ceph_osd_req_op *op = &req->r_ops[0];
+	struct ceph_osd_client *osdc = lreq->osdc;
+	struct ceph_osd_request *req;
+	int ret;
 
-	verify_osdc_wrlocked(req->r_osdc);
+	verify_osdc_wrlocked(osdc);
+	mutex_lock(&lreq->lock);
 	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
 
-	if (req->r_osd)
-		cancel_linger_request(req);
+	if (lreq->reg_req) {
+		if (lreq->reg_req->r_osd)
+			cancel_linger_request(lreq->reg_req);
+		ceph_osdc_put_request(lreq->reg_req);
+	}
+
+	req = ceph_osdc_alloc_request(osdc, NULL, 1, true, GFP_NOIO);
+	BUG_ON(!req);
 
-	request_reinit(req);
 	target_copy(&req->r_t, &lreq->t);
 	req->r_mtime = lreq->mtime;
 
-	mutex_lock(&lreq->lock);
 	if (lreq->is_watch && lreq->committed) {
-		WARN_ON(op->op != CEPH_OSD_OP_WATCH ||
-			op->watch.cookie != lreq->linger_id);
-		op->watch.op = CEPH_OSD_WATCH_OP_RECONNECT;
-		op->watch.gen = ++lreq->register_gen;
+		osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_RECONNECT,
+				      lreq->linger_id, ++lreq->register_gen);
 		dout("lreq %p reconnect register_gen %u\n", lreq,
-		     op->watch.gen);
+		     req->r_ops[0].watch.gen);
 		req->r_callback = linger_reconnect_cb;
 	} else {
-		if (!lreq->is_watch)
+		if (lreq->is_watch) {
+			osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_WATCH,
+					      lreq->linger_id, 0);
+		} else {
 			lreq->notify_id = 0;
-		else
-			WARN_ON(op->watch.op != CEPH_OSD_WATCH_OP_WATCH);
+
+			refcount_inc(&lreq->request_pl->refcnt);
+			osd_req_op_notify_init(req, 0, lreq->linger_id,
+					       lreq->request_pl);
+			ceph_osd_data_pages_init(
+			    osd_req_op_data(req, 0, notify, response_data),
+			    lreq->notify_id_pages, PAGE_SIZE, 0, false, false);
+		}
 		dout("lreq %p register\n", lreq);
 		req->r_callback = linger_commit_cb;
 	}
-	mutex_unlock(&lreq->lock);
+
+	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
+	BUG_ON(ret);
 
 	req->r_priv = linger_get(lreq);
 	req->r_linger = true;
+	lreq->reg_req = req;
+	mutex_unlock(&lreq->lock);
 
 	submit_request(req, true);
 }
@@ -3106,6 +3119,12 @@ static void linger_ping_cb(struct ceph_osd_request *req)
 	struct ceph_osd_linger_request *lreq = req->r_priv;
 
 	mutex_lock(&lreq->lock);
+	if (req != lreq->ping_req) {
+		dout("%s lreq %p linger_id %llu unknown req (%p != %p)\n",
+		     __func__, lreq, lreq->linger_id, req, lreq->ping_req);
+		goto out;
+	}
+
 	dout("%s lreq %p linger_id %llu result %d ping_sent %lu last_error %d\n",
 	     __func__, lreq, lreq->linger_id, req->r_result, lreq->ping_sent,
 	     lreq->last_error);
@@ -3121,6 +3140,7 @@ static void linger_ping_cb(struct ceph_osd_request *req)
 		     lreq->register_gen, req->r_ops[0].watch.gen);
 	}
 
+out:
 	mutex_unlock(&lreq->lock);
 	linger_put(lreq);
 }
@@ -3128,8 +3148,8 @@ static void linger_ping_cb(struct ceph_osd_request *req)
 static void send_linger_ping(struct ceph_osd_linger_request *lreq)
 {
 	struct ceph_osd_client *osdc = lreq->osdc;
-	struct ceph_osd_request *req = lreq->ping_req;
-	struct ceph_osd_req_op *op = &req->r_ops[0];
+	struct ceph_osd_request *req;
+	int ret;
 
 	if (ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD)) {
 		dout("%s PAUSERD\n", __func__);
@@ -3141,19 +3161,26 @@ static void send_linger_ping(struct ceph_osd_linger_request *lreq)
 	     __func__, lreq, lreq->linger_id, lreq->ping_sent,
 	     lreq->register_gen);
 
-	if (req->r_osd)
-		cancel_linger_request(req);
+	if (lreq->ping_req) {
+		if (lreq->ping_req->r_osd)
+			cancel_linger_request(lreq->ping_req);
+		ceph_osdc_put_request(lreq->ping_req);
+	}
 
-	request_reinit(req);
-	target_copy(&req->r_t, &lreq->t);
+	req = ceph_osdc_alloc_request(osdc, NULL, 1, true, GFP_NOIO);
+	BUG_ON(!req);
 
-	WARN_ON(op->op != CEPH_OSD_OP_WATCH ||
-		op->watch.cookie != lreq->linger_id ||
-		op->watch.op != CEPH_OSD_WATCH_OP_PING);
-	op->watch.gen = lreq->register_gen;
+	target_copy(&req->r_t, &lreq->t);
+	osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_PING, lreq->linger_id,
+			      lreq->register_gen);
 	req->r_callback = linger_ping_cb;
+
+	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
+	BUG_ON(ret);
+
 	req->r_priv = linger_get(lreq);
 	req->r_linger = true;
+	lreq->ping_req = req;
 
 	ceph_osdc_get_request(req);
 	account_request(req);
@@ -3169,12 +3196,6 @@ static void linger_submit(struct ceph_osd_linger_request *lreq)
 
 	down_write(&osdc->lock);
 	linger_register(lreq);
-	if (lreq->is_watch) {
-		lreq->reg_req->r_ops[0].watch.cookie = lreq->linger_id;
-		lreq->ping_req->r_ops[0].watch.cookie = lreq->linger_id;
-	} else {
-		lreq->reg_req->r_ops[0].notify.cookie = lreq->linger_id;
-	}
 
 	calc_target(osdc, &lreq->t, false);
 	osd = lookup_create_osd(osdc, lreq->t.osd, true);
@@ -3206,9 +3227,9 @@ static void cancel_linger_map_check(struct ceph_osd_linger_request *lreq)
  */
 static void __linger_cancel(struct ceph_osd_linger_request *lreq)
 {
-	if (lreq->is_watch && lreq->ping_req->r_osd)
+	if (lreq->ping_req && lreq->ping_req->r_osd)
 		cancel_linger_request(lreq->ping_req);
-	if (lreq->reg_req->r_osd)
+	if (lreq->reg_req && lreq->reg_req->r_osd)
 		cancel_linger_request(lreq->reg_req);
 	cancel_linger_map_check(lreq);
 	unlink_linger(lreq->osd, lreq);
@@ -4657,43 +4678,6 @@ void ceph_osdc_sync(struct ceph_osd_client *osdc)
 }
 EXPORT_SYMBOL(ceph_osdc_sync);
 
-static struct ceph_osd_request *
-alloc_linger_request(struct ceph_osd_linger_request *lreq)
-{
-	struct ceph_osd_request *req;
-
-	req = ceph_osdc_alloc_request(lreq->osdc, NULL, 1, false, GFP_NOIO);
-	if (!req)
-		return NULL;
-
-	ceph_oid_copy(&req->r_base_oid, &lreq->t.base_oid);
-	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
-	return req;
-}
-
-static struct ceph_osd_request *
-alloc_watch_request(struct ceph_osd_linger_request *lreq, u8 watch_opcode)
-{
-	struct ceph_osd_request *req;
-
-	req = alloc_linger_request(lreq);
-	if (!req)
-		return NULL;
-
-	/*
-	 * Pass 0 for cookie because we don't know it yet, it will be
-	 * filled in by linger_submit().
-	 */
-	osd_req_op_watch_init(req, 0, 0, watch_opcode);
-
-	if (ceph_osdc_alloc_messages(req, GFP_NOIO)) {
-		ceph_osdc_put_request(req);
-		return NULL;
-	}
-
-	return req;
-}
-
 /*
  * Returns a handle, caller owns a ref.
  */
@@ -4723,18 +4707,6 @@ ceph_osdc_watch(struct ceph_osd_client *osdc,
 	lreq->t.flags = CEPH_OSD_FLAG_WRITE;
 	ktime_get_real_ts64(&lreq->mtime);
 
-	lreq->reg_req = alloc_watch_request(lreq, CEPH_OSD_WATCH_OP_WATCH);
-	if (!lreq->reg_req) {
-		ret = -ENOMEM;
-		goto err_put_lreq;
-	}
-
-	lreq->ping_req = alloc_watch_request(lreq, CEPH_OSD_WATCH_OP_PING);
-	if (!lreq->ping_req) {
-		ret = -ENOMEM;
-		goto err_put_lreq;
-	}
-
 	linger_submit(lreq);
 	ret = linger_reg_commit_wait(lreq);
 	if (ret) {
@@ -4772,8 +4744,8 @@ int ceph_osdc_unwatch(struct ceph_osd_client *osdc,
 	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
 	req->r_flags = CEPH_OSD_FLAG_WRITE;
 	ktime_get_real_ts64(&req->r_mtime);
-	osd_req_op_watch_init(req, 0, lreq->linger_id,
-			      CEPH_OSD_WATCH_OP_UNWATCH);
+	osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_UNWATCH,
+			      lreq->linger_id, 0);
 
 	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
 	if (ret)
@@ -4859,35 +4831,6 @@ int ceph_osdc_notify_ack(struct ceph_osd_client *osdc,
 }
 EXPORT_SYMBOL(ceph_osdc_notify_ack);
 
-static int osd_req_op_notify_init(struct ceph_osd_request *req, int which,
-				  u64 cookie, u32 prot_ver, u32 timeout,
-				  void *payload, u32 payload_len)
-{
-	struct ceph_osd_req_op *op;
-	struct ceph_pagelist *pl;
-	int ret;
-
-	op = osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
-	op->notify.cookie = cookie;
-
-	pl = ceph_pagelist_alloc(GFP_NOIO);
-	if (!pl)
-		return -ENOMEM;
-
-	ret = ceph_pagelist_encode_32(pl, 1); /* prot_ver */
-	ret |= ceph_pagelist_encode_32(pl, timeout);
-	ret |= ceph_pagelist_encode_32(pl, payload_len);
-	ret |= ceph_pagelist_append(pl, payload, payload_len);
-	if (ret) {
-		ceph_pagelist_release(pl);
-		return -ENOMEM;
-	}
-
-	ceph_osd_data_pagelist_init(&op->notify.request_data, pl);
-	op->indata_len = pl->length;
-	return 0;
-}
-
 /*
  * @timeout: in seconds
  *
@@ -4906,7 +4849,6 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 		     size_t *preply_len)
 {
 	struct ceph_osd_linger_request *lreq;
-	struct page **pages;
 	int ret;
 
 	WARN_ON(!timeout);
@@ -4919,41 +4861,35 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 	if (!lreq)
 		return -ENOMEM;
 
-	lreq->preply_pages = preply_pages;
-	lreq->preply_len = preply_len;
-
-	ceph_oid_copy(&lreq->t.base_oid, oid);
-	ceph_oloc_copy(&lreq->t.base_oloc, oloc);
-	lreq->t.flags = CEPH_OSD_FLAG_READ;
-
-	lreq->reg_req = alloc_linger_request(lreq);
-	if (!lreq->reg_req) {
+	lreq->request_pl = ceph_pagelist_alloc(GFP_NOIO);
+	if (!lreq->request_pl) {
 		ret = -ENOMEM;
 		goto out_put_lreq;
 	}
 
-	/*
-	 * Pass 0 for cookie because we don't know it yet, it will be
-	 * filled in by linger_submit().
-	 */
-	ret = osd_req_op_notify_init(lreq->reg_req, 0, 0, 1, timeout,
-				     payload, payload_len);
-	if (ret)
+	ret = ceph_pagelist_encode_32(lreq->request_pl, 1); /* prot_ver */
+	ret |= ceph_pagelist_encode_32(lreq->request_pl, timeout);
+	ret |= ceph_pagelist_encode_32(lreq->request_pl, payload_len);
+	ret |= ceph_pagelist_append(lreq->request_pl, payload, payload_len);
+	if (ret) {
+		ret = -ENOMEM;
 		goto out_put_lreq;
+	}
 
 	/* for notify_id */
-	pages = ceph_alloc_page_vector(1, GFP_NOIO);
-	if (IS_ERR(pages)) {
-		ret = PTR_ERR(pages);
+	lreq->notify_id_pages = ceph_alloc_page_vector(1, GFP_NOIO);
+	if (IS_ERR(lreq->notify_id_pages)) {
+		ret = PTR_ERR(lreq->notify_id_pages);
+		lreq->notify_id_pages = NULL;
 		goto out_put_lreq;
 	}
-	ceph_osd_data_pages_init(osd_req_op_data(lreq->reg_req, 0, notify,
-						 response_data),
-				 pages, PAGE_SIZE, 0, false, true);
 
-	ret = ceph_osdc_alloc_messages(lreq->reg_req, GFP_NOIO);
-	if (ret)
-		goto out_put_lreq;
+	lreq->preply_pages = preply_pages;
+	lreq->preply_len = preply_len;
+
+	ceph_oid_copy(&lreq->t.base_oid, oid);
+	ceph_oloc_copy(&lreq->t.base_oloc, oloc);
+	lreq->t.flags = CEPH_OSD_FLAG_READ;
 
 	linger_submit(lreq);
 	ret = linger_reg_commit_wait(lreq);
-- 
2.19.2

