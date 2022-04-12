Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAA24FDF73
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Apr 2022 14:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351735AbiDLMLd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Apr 2022 08:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354712AbiDLMKU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 12 Apr 2022 08:10:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E1EE25293
        for <ceph-devel@vger.kernel.org>; Tue, 12 Apr 2022 04:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649761998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qEowqgXA0TiLT+G0SDLIpufFSOvW7t47bmKC0FRmTdY=;
        b=Say6VtpGNdbdiJ9XWUj2g6kqJKxPXNr/zCaQ4xytxKgCtSIiYdl5uqy63o61UzE1LiSs9u
        Z+nqqH5z8q64tKYfCo+acI2eJGI45Vc2jyLEiSme+mBmuAf7JNNPWisHbf8YnOHIwBPqqs
        3OSxDHQBrQz2OcisPW2I/FRzDHybWpc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-634xIYoZPRiJO5i6u0XxjQ-1; Tue, 12 Apr 2022 07:13:15 -0400
X-MC-Unique: 634xIYoZPRiJO5i6u0XxjQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B20F29AB3EB;
        Tue, 12 Apr 2022 11:13:15 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FCC39D47;
        Tue, 12 Apr 2022 11:13:09 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: flush the mdlog for filesystem sync
Date:   Tue, 12 Apr 2022 19:13:06 +0800
Message-Id: <20220412111306.23142-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

URL: https://tracker.ceph.com/issues/55284
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0da85c9ce73a..a1b75aaede98 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5098,6 +5098,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 {
 	struct ceph_mds_request *req = NULL, *nextreq;
+	struct ceph_mds_session *last_session = NULL;
 	struct rb_node *n;
 
 	mutex_lock(&mdsc->mutex);
@@ -5117,6 +5118,14 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 			ceph_mdsc_get_request(req);
 			if (nextreq)
 				ceph_mdsc_get_request(nextreq);
+
+			/* send flush mdlog request to MDS */
+			if (last_session != req->r_session) {
+				send_flush_mdlog(req->r_session);
+				ceph_put_mds_session(last_session);
+				last_session = ceph_get_mds_session(req->r_session);
+			}
+
 			mutex_unlock(&mdsc->mutex);
 			dout("wait_unsafe_requests  wait on %llu (want %llu)\n",
 			     req->r_tid, want_tid);
@@ -5135,6 +5144,7 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 		req = nextreq;
 	}
 	mutex_unlock(&mdsc->mutex);
+	ceph_put_mds_session(last_session);
 	dout("wait_unsafe_requests done\n");
 }
 
-- 
2.36.0.rc1

