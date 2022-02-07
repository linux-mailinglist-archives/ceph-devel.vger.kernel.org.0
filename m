Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7FA4AB4A6
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 07:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbiBGGSV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 01:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiBGFFE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 00:05:04 -0500
X-Greylist: delayed 70 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 21:05:01 PST
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00C76C043181
        for <ceph-devel@vger.kernel.org>; Sun,  6 Feb 2022 21:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644210301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AQdCXQgpHVnJMZGzsRAYte0JG9oSvPUJ8063qIbf0k4=;
        b=J0zQlsMgAOmWMK9IbUoIP3uCq+OVv1372tXWfa0dcp4wXqVIJfhuIKJPIMwyhHk1MLGNCv
        0Se5bntCIma6pdgWxg6OlwSDH1dKeLRFQaXzUwKm61vR72mXf6LylfRLY9s8rJZPtmf67N
        mfqXTILtbtaakHYHVV3agqyEbmiwXck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-t4lme_X5NDeFr5k22-10eg-1; Mon, 07 Feb 2022 00:03:47 -0500
X-MC-Unique: t4lme_X5NDeFr5k22-10eg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08AD0814243;
        Mon,  7 Feb 2022 05:03:46 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37A80101E7E1;
        Mon,  7 Feb 2022 05:03:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fail the request directly if handle_reply gets an ESTALE
Date:   Mon,  7 Feb 2022 13:03:40 +0800
Message-Id: <20220207050340.872893-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If MDS return ESTALE, that means the MDS has already iterated all
the possible active MDSes including the auth MDS or the inode is
under purging. No need to retry in auth MDS and will just return
ESTALE directly.

Or it will cause definite loop for retrying it.

URL: https://tracker.ceph.com/issues/53504
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 93e5e3c4ba64..c918d2ac8272 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3368,35 +3368,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 
 	result = le32_to_cpu(head->result);
 
-	/*
-	 * Handle an ESTALE
-	 * if we're not talking to the authority, send to them
-	 * if the authority has changed while we weren't looking,
-	 * send to new authority
-	 * Otherwise we just have to return an ESTALE
-	 */
-	if (result == -ESTALE) {
-		dout("got ESTALE on request %llu\n", req->r_tid);
-		req->r_resend_mds = -1;
-		if (req->r_direct_mode != USE_AUTH_MDS) {
-			dout("not using auth, setting for that now\n");
-			req->r_direct_mode = USE_AUTH_MDS;
-			__do_request(mdsc, req);
-			mutex_unlock(&mdsc->mutex);
-			goto out;
-		} else  {
-			int mds = __choose_mds(mdsc, req, NULL);
-			if (mds >= 0 && mds != req->r_session->s_mds) {
-				dout("but auth changed, so resending\n");
-				__do_request(mdsc, req);
-				mutex_unlock(&mdsc->mutex);
-				goto out;
-			}
-		}
-		dout("have to return ESTALE on request %llu\n", req->r_tid);
-	}
-
-
 	if (head->safe) {
 		set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
 		__unregister_request(mdsc, req);
-- 
2.27.0

