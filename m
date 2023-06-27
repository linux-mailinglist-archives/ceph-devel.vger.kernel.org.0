Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA07740703
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Jun 2023 02:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjF1AAl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 20:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjF1AAj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 20:00:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE451211C
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 16:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687910379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xTbFdN6VZxBAhKZAT56KLZaXgS9mtPgHnVZ4Yz8gigE=;
        b=hYM+DRMy7LRv0rW7hMVLGM5CU9275tFzI69v9XV/+E/PuB6ymCkwTWdtBe7qHEUPrlvNlV
        yOJ0O2FhDSQo9wW5m2CUFKUGQJ0IZG27fzwe45tCzzB8KLEER6g8npVdnfJOnLBkXX31sw
        mHh0/QguFruJKG4eE4t0z2jT5nEWH8g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-4ApJbrdiPEa4UpGOetVWtA-1; Tue, 27 Jun 2023 19:59:35 -0400
X-MC-Unique: 4ApJbrdiPEa4UpGOetVWtA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DCB1380670A;
        Tue, 27 Jun 2023 23:59:35 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-13-91.pek2.redhat.com [10.72.13.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FB50400F54;
        Tue, 27 Jun 2023 23:59:31 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH v2] ceph: don't let check_caps skip sending responses for revoke msgs
Date:   Wed, 28 Jun 2023 07:57:09 +0800
Message-Id: <20230627235709.201132-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

If a client sends out a cap-update request with the old 'seq' just
before a pending cap revoke request, then the MDS might miscalculate
the 'seqs' and caps. It's therefore always a good idea to ack the
cap revoke request with the bumped up 'seq'.

Cc: stable@vger.kernel.org
Cc: Patrick Donnelly <pdonnell@redhat.com>
URL: https://tracker.ceph.com/issues/61782
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Rephrased the commit comment for better understanding from Milind


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

