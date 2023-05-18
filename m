Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDE8707794
	for <lists+ceph-devel@lfdr.de>; Thu, 18 May 2023 03:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjERBsu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 21:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjERBsq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 21:48:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11BC2D76
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 18:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684374480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PqsWIf6K4TW/GQ1yMBTqaw73BkuEKsboj7/HFri0j+U=;
        b=SB9dYQeJ3tuo3SJVUUkWtbmp3FprSZwUa39XZmvVCXhot8CVTOuRd7DcZ4662gjRAT7E2h
        DvHaPvNenYdDkY0i830DWYQGGFcFLi034nPNho4AMWI6DQMS8Z0/QhZBha9MjQ2vcI9RvM
        +HLigChwrGCvKst7Nfx4Fc8yp7C67O0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-VHXJpoPvPESeIvBgiaHs7g-1; Wed, 17 May 2023 21:47:59 -0400
X-MC-Unique: VHXJpoPvPESeIvBgiaHs7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F41AD80067D;
        Thu, 18 May 2023 01:47:58 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-110.pek2.redhat.com [10.72.12.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 181242166B31;
        Thu, 18 May 2023 01:47:53 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
Subject: [PATCH v2] ceph: force updating the msg pointer in non-split case
Date:   Thu, 18 May 2023 09:47:23 +0800
Message-Id: <20230518014723.148327-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
request may still contain a list of 'split_realms', and we need
to skip it anyway. Or it will be parsed as a corrupt snaptrace.

Cc: stable@vger.kernel.org
Cc: Frank Schilder <frans@dtu.dk>
Reported-by: Frank Schilder <frans@dtu.dk>
URL: https://tracker.ceph.com/issues/61200
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Add a detail comment for the code.


 fs/ceph/snap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 0e59e95a96d9..0f00f977c0f0 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -1114,6 +1114,19 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 				continue;
 			adjust_snap_realm_parent(mdsc, child, realm->ino);
 		}
+	} else {
+		/*
+		 * In non-SPLIT op case both the 'num_split_inos' and
+		 * 'num_split_realms' should always be 0 and this will
+		 * do nothing. But the MDS has one bug that in one of
+		 * the UPDATE op cases it will pass a 'split_realms'
+		 * list by mistake, and then will corrupted the snap
+		 * trace in ceph_update_snap_trace().
+		 *
+		 * So we should skip them anyway here.
+		 */
+		p += sizeof(u64) * num_split_inos;
+		p += sizeof(u64) * num_split_realms;
 	}
 
 	/*
-- 
2.40.1

