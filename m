Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B3575A4D1
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jul 2023 05:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjGTDkH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Jul 2023 23:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjGTDkF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Jul 2023 23:40:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23713F0
        for <ceph-devel@vger.kernel.org>; Wed, 19 Jul 2023 20:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689824362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QjgK16fbYrG++Mc/Bw8sGRPVXWqbu/k0n06yN1fOyrs=;
        b=VnhQ8AaHQH5cdzVMvUXWeF+5KR2FrZ6Kts6cGxlz1TaeOoDJHCGGKPOSKH0UlNnFrFm6zs
        BjNtqWUd+eIkx8RZ/mRz+3YRWW6kl96F1CNNvnCvr4KMEZErY9hZTuNqurd4Np+0xl1Ymn
        ExjAKaZILtnQpWDg9FDiJMyXnEoVsFI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-3rW1bbwsMO608rpmOYPrkQ-1; Wed, 19 Jul 2023 23:39:18 -0400
X-MC-Unique: 3rW1bbwsMO608rpmOYPrkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 415C0101A528;
        Thu, 20 Jul 2023 03:39:18 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-173.pek2.redhat.com [10.72.12.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FBCD40D2839;
        Thu, 20 Jul 2023 03:39:11 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ceph: disable sending metrics thoroughly when it's disabled
Date:   Thu, 20 Jul 2023 11:38:00 +0800
Message-Id: <20230720033800.110717-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Even the 'disable_send_metrics' is true so when the session is
being opened it will always trigger to send the metric for the
first time.

Cc: stable@vger.kernel.org
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/metric.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index cce78d769f55..6d3584f16f9a 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -216,7 +216,7 @@ static void metric_delayed_work(struct work_struct *work)
 	struct ceph_mds_client *mdsc =
 		container_of(m, struct ceph_mds_client, metric);
 
-	if (mdsc->stopping)
+	if (mdsc->stopping || disable_send_metrics)
 		return;
 
 	if (!m->session || !check_session_state(m->session)) {
-- 
2.40.1

