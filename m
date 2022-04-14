Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7005005A7
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Apr 2022 07:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbiDNFsC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Apr 2022 01:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbiDNFrn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Apr 2022 01:47:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 836544BBAA
        for <ceph-devel@vger.kernel.org>; Wed, 13 Apr 2022 22:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649915118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7DoeHEYa8sI7M8hiGeiEV9eh2+pjEJ8yej8Ju/AWbfM=;
        b=JVYqeefDx1O+i7x2xn8WDlzElhJAm19jRlF/23rMc3Fbv0hLYKisdJ7zkR2vw+sFYutRgK
        4yh/x2xsEw3NbI5PWaVTaEEAkGEGBlBCRD0Zf7PszAn+N1mx8SsnwNts4cgnvw75c72jMO
        aNdNEAV8Lp/ic/7gPhMenmD3NKwiPkA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-R1P8SOXoOGy7UB2mkKsSzA-1; Thu, 14 Apr 2022 01:45:17 -0400
X-MC-Unique: R1P8SOXoOGy7UB2mkKsSzA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7B7C3800E81;
        Thu, 14 Apr 2022 05:45:16 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CDCF2166B4F;
        Thu, 14 Apr 2022 05:45:15 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: flush the mdlog for filesystem sync
Date:   Thu, 14 Apr 2022 13:45:12 +0800
Message-Id: <20220414054512.386293-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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

V2:
- Fixed possible NULL pointer dereference for the req->r_session


 fs/ceph/mds_client.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0da85c9ce73a..4aaa7b14136e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5098,6 +5098,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 {
 	struct ceph_mds_request *req = NULL, *nextreq;
+	struct ceph_mds_session *last_session = NULL, *s;
 	struct rb_node *n;
 
 	mutex_lock(&mdsc->mutex);
@@ -5117,6 +5118,15 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 			ceph_mdsc_get_request(req);
 			if (nextreq)
 				ceph_mdsc_get_request(nextreq);
+
+			/* send flush mdlog request to MDS */
+			s = req->r_session;
+			if (s && last_session != s) {
+				send_flush_mdlog(s);
+				ceph_put_mds_session(last_session);
+				last_session = ceph_get_mds_session(s);
+			}
+
 			mutex_unlock(&mdsc->mutex);
 			dout("wait_unsafe_requests  wait on %llu (want %llu)\n",
 			     req->r_tid, want_tid);
@@ -5135,6 +5145,7 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 		req = nextreq;
 	}
 	mutex_unlock(&mdsc->mutex);
+	ceph_put_mds_session(last_session);
 	dout("wait_unsafe_requests done\n");
 }
 
-- 
2.36.0.rc1

