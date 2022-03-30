Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADF44EBB25
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 08:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242583AbiC3GyC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 02:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241807AbiC3Gx5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 02:53:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA6EAB1AB1
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 23:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648623130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W8OjN7V6zHGzkSTKhC8h1PCpltbvW5VfKRM+E2vbm7U=;
        b=P1PiF4MrznNIbyDy6X2jAnYw0FJLq/O1ZliWn4NURl7FB7vaajev9B/e/5kIKnZXwg1tfi
        fqFuoETmj0qkn+MHlaZVX5xaIaPDosabCjbmPsPxE0RhrGfhEqC4MhucZtOFSmIdvmKtAL
        gvuwkkBp02bI3JvzwlXa51D6f4E9aao=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-TsSQ8qwWPpGMpPGSwzDVBg-1; Wed, 30 Mar 2022 02:52:09 -0400
X-MC-Unique: TsSQ8qwWPpGMpPGSwzDVBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D220191BD84;
        Wed, 30 Mar 2022 06:52:03 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D93D440D1B9B;
        Wed, 30 Mar 2022 06:51:57 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: stop retrying the request when exceeding 256 times
Date:   Wed, 30 Mar 2022 14:44:44 +0800
Message-Id: <20220330064444.330384-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The type of 'r_attempts' in kernel 'ceph_mds_request' is 'int',
while in 'ceph_mds_request_head' the type of 'num_retry' is '__u8'.
So in case the request retries exceeding 256 times, the MDS will
receive a incorrect retry seq.

In this case it's ususally a bug in MDS and continue retrying the
request makes no sense. For now let's limit it to 256. In future
this could be fixed in ceph code, so avoid using the hardcode here.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e11d31401f12..f476c65fb985 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2679,7 +2679,28 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 	struct ceph_mds_client *mdsc = session->s_mdsc;
 	struct ceph_mds_request_head_old *rhead;
 	struct ceph_msg *msg;
-	int flags = 0;
+	int flags = 0, max_retry;
+
+	/*
+	 * The type of 'r_attempts' in kernel 'ceph_mds_request'
+	 * is 'int', while in 'ceph_mds_request_head' the type of
+	 * 'num_retry' is '__u8'. So in case the request retries
+	 *  exceeding 256 times, the MDS will receive a incorrect
+	 *  retry seq.
+	 *
+	 * In this case it's ususally a bug in MDS and continue
+	 * retrying the request makes no sense.
+	 *
+	 * In future this could be fixed in ceph code, so avoid
+	 * using the hardcode here.
+	 */
+	max_retry = sizeof_field(struct ceph_mds_request_head, num_retry);
+	max_retry = 1 << (max_retry * BITS_PER_BYTE);
+	if (req->r_attempts >= max_retry) {
+		pr_warn_ratelimited("%s request tid %llu seq overflow\n",
+				    __func__, req->r_tid);
+		return -EMULTIHOP;
+	}
 
 	req->r_attempts++;
 	if (req->r_inode) {
@@ -2691,7 +2712,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 		else
 			req->r_sent_on_mseq = -1;
 	}
-	dout("prepare_send_request %p tid %lld %s (attempt %d)\n", req,
+	dout("%s %p tid %lld %s (attempt %d)\n", __func__, req,
 	     req->r_tid, ceph_mds_op_name(req->r_op), req->r_attempts);
 
 	if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
-- 
2.27.0

