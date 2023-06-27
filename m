Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB9973F509
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jun 2023 09:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjF0HEL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 03:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF0HEJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 03:04:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22551991
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 00:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687849406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Dlc0tYFL5ZQGydInBuFh6Eizem9RdCPyRpawQp++pwo=;
        b=PUZ6qDPczJFj1lPTwOVBuIDrrX+5s0+nVhStcfCwqNc+mDc/dDU6vK+S0sI7R3rdUfi0IQ
        ZjbqSKh3u2i9J6P4fW11SeVU4Q2X40l0Mm8cJhaeURJ8xTXiI87zMcbksKZgTs7Lp2rf7Z
        332LxFURrKG8eWzZoQG1Tvzy+YPgu9w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-V0B6n0zOPGe9Ettow6Id6w-1; Tue, 27 Jun 2023 03:03:24 -0400
X-MC-Unique: V0B6n0zOPGe9Ettow6Id6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A2508C80F6;
        Tue, 27 Jun 2023 07:03:23 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-13-91.pek2.redhat.com [10.72.13.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E7494087C6A;
        Tue, 27 Jun 2023 07:03:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH] ceph: don't let check_caps skip sending responses for revoke msgs
Date:   Tue, 27 Jun 2023 15:01:01 +0800
Message-Id: <20230627070101.170876-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If just before the revoke request, which will increase the 'seq', is
sent out the clients released the corresponding caps and sent out
the cap update request to MDS with old 'seq', the mds will miss
checking the seqs and calculating the caps.

We should always send an ack for revoke requests.

Cc: stable@vger.kernel.org
Cc: Patrick Donnelly <pdonnell@redhat.com>
URL: https://tracker.ceph.com/issues/61782
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 1052885025b3..eee2fbca3430 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3737,6 +3737,15 @@ static void handle_cap_grant(struct inode *inode,
 	}
 	BUG_ON(cap->issued & ~cap->implemented);
 
+	/* don't let check_caps skip sending a response to MDS for revoke msgs */
+	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
+		cap->mds_wanted = 0;
+		if (cap == ci->i_auth_cap)
+			check_caps = 1; /* check auth cap only */
+		else
+			check_caps = 2; /* check all caps */
+	}
+
 	if (extra_info->inline_version > 0 &&
 	    extra_info->inline_version >= ci->i_inline_version) {
 		ci->i_inline_version = extra_info->inline_version;
-- 
2.40.1

