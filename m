Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6584EB7C6
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 03:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241625AbiC3B1U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Mar 2022 21:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241538AbiC3B1S (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Mar 2022 21:27:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFF5F71ECE
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 18:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648603532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2rR77i4EPthrHIKD4LFHuKzlX7UeXFY2isOOEiAcIdk=;
        b=H4/Tj4/NsxAnZ5E5oaTEJQDxfx/F8qKXECfnaxNOsXqIzbZ9zGBVJLuugc+EEebHPrg+to
        oJiSZRbbNvB/tEQakE9XVzU5Z7XNIJDAW8uW13+EVacPTlAExjdT64Rdo3sQeNDbY9kX4n
        GgdEh9z+cXIxb3qBIdEVpm0P0NwndLs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-dJIbU9YHPImrYq1e6KRBuw-1; Tue, 29 Mar 2022 21:25:29 -0400
X-MC-Unique: dJIbU9YHPImrYq1e6KRBuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9A018001EA;
        Wed, 30 Mar 2022 01:25:28 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C473140EBD5;
        Wed, 30 Mar 2022 01:25:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, gfarnum@redhat.com,
        lhenriques@suse.de, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: stop forwarding the request when exceeding 256 times
Date:   Wed, 30 Mar 2022 09:25:21 +0800
Message-Id: <20220330012521.170962-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The type of 'num_fwd' in ceph 'MClientRequestForward' is 'int32_t',
while in 'ceph_mds_request_head' the type is '__u8'. So in case
the request bounces between MDSes exceeding 256 times, the client
will get stuck.

In this case it's ususally a bug in MDS and continue bouncing the
request makes no sense.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- avoid usig the hardcode of 256

V2:
- s/EIO/EMULTIHOP/
- Fixed dereferencing NULL seq bug
- Removed the out lable


 fs/ceph/mds_client.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a89ee866ebbb..e11d31401f12 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3293,6 +3293,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
 	int err = -EINVAL;
 	void *p = msg->front.iov_base;
 	void *end = p + msg->front.iov_len;
+	bool aborted = false;
 
 	ceph_decode_need(&p, end, 2*sizeof(u32), bad);
 	next_mds = ceph_decode_32(&p);
@@ -3301,16 +3302,41 @@ static void handle_forward(struct ceph_mds_client *mdsc,
 	mutex_lock(&mdsc->mutex);
 	req = lookup_get_request(mdsc, tid);
 	if (!req) {
+		mutex_unlock(&mdsc->mutex);
 		dout("forward tid %llu to mds%d - req dne\n", tid, next_mds);
-		goto out;  /* dup reply? */
+		return;  /* dup reply? */
 	}
 
 	if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
 		dout("forward tid %llu aborted, unregistering\n", tid);
 		__unregister_request(mdsc, req);
 	} else if (fwd_seq <= req->r_num_fwd) {
-		dout("forward tid %llu to mds%d - old seq %d <= %d\n",
-		     tid, next_mds, req->r_num_fwd, fwd_seq);
+		/*
+		 * The type of 'num_fwd' in ceph 'MClientRequestForward'
+		 * is 'int32_t', while in 'ceph_mds_request_head' the
+		 * type is '__u8'. So in case the request bounces between
+		 * MDSes exceeding 256 times, the client will get stuck.
+		 *
+		 * In this case it's ususally a bug in MDS and continue
+		 * bouncing the request makes no sense.
+		 *
+		 * In future this could be fixed in ceph code, so avoid
+		 * using the hardcode here.
+		 */
+		int max = sizeof_field(struct ceph_mds_request_head, num_fwd);
+		max = 1 << (max * BITS_PER_BYTE);
+		if (req->r_num_fwd >= max) {
+			mutex_lock(&req->r_fill_mutex);
+			req->r_err = -EMULTIHOP;
+			set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
+			mutex_unlock(&req->r_fill_mutex);
+			aborted = true;
+			pr_warn_ratelimited("forward tid %llu seq overflow\n",
+					    tid);
+		} else {
+			dout("forward tid %llu to mds%d - old seq %d <= %d\n",
+			     tid, next_mds, req->r_num_fwd, fwd_seq);
+		}
 	} else {
 		/* resend. forward race not possible; mds would drop */
 		dout("forward tid %llu to mds%d (we resend)\n", tid, next_mds);
@@ -3322,9 +3348,12 @@ static void handle_forward(struct ceph_mds_client *mdsc,
 		put_request_session(req);
 		__do_request(mdsc, req);
 	}
-	ceph_mdsc_put_request(req);
-out:
 	mutex_unlock(&mdsc->mutex);
+
+	/* kick calling process */
+	if (aborted)
+		complete_request(mdsc, req);
+	ceph_mdsc_put_request(req);
 	return;
 
 bad:
-- 
2.27.0

