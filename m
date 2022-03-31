Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B2D4ED434
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Mar 2022 08:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiCaGyz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 02:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiCaGyy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 02:54:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADE551EDA10
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 23:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648709585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IflWPHfZlmFxAU5dbRO0MveU/vTe8XnxG0GuKRS8YPc=;
        b=VbqP7QF2/BcRmQHTcf5KZlnT2xaOVVUw+8FWp4+fshtNYWhLkcWZboJRtHx6Y52CcKNGrm
        YdzoOfpBWKtbI/kLWyKoRFjg6+HmQX77HlZf9ximemcgDe3lUE73ONN7pnUMl4oeL+MdPf
        4DzChUESEpROq97Qs46w1sRNHH6+TVE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-kxeXYJqLP7uzDegCbsrDqQ-1; Thu, 31 Mar 2022 02:53:02 -0400
X-MC-Unique: kxeXYJqLP7uzDegCbsrDqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 051DC3C01D89;
        Thu, 31 Mar 2022 06:53:02 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3360C7ADD;
        Thu, 31 Mar 2022 06:52:56 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/3] ceph: add force_ignore_metric_bits module parameter support
Date:   Thu, 31 Mar 2022 14:52:41 +0800
Message-Id: <20220331065241.27370-4-xiubli@redhat.com>
In-Reply-To: <20220331065241.27370-1-xiubli@redhat.com>
References: <20220331065241.27370-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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

This parameter will force ignoring the metric bits from the MDS,
and will force sending all the metrics kernel supports. It's
dangerous for some old ceph clusters which will crash the MDSes
when receive unknown metrics.

URL: https://tracker.ceph.com/issues/54411
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/metric.c | 1 +
 fs/ceph/metric.h | 1 +
 fs/ceph/super.c  | 6 +++++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index f01c1f4e6b89..bfb5e255e3d2 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -51,6 +51,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	head = msg->front.iov_base;
 
+	force = force || force_ignore_metric_bits;
 	/* encode the cap metric */
 	if (force || test_bit(CLIENT_METRIC_TYPE_CAP_INFO, &s->s_metrics)) {
 		cap = (struct ceph_metric_cap *)(head + 1);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 0d0c44bd3332..b0018887b078 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -7,6 +7,7 @@
 #include <linux/ktime.h>
 
 extern bool disable_send_metrics;
+extern bool force_ignore_metric_bits;
 
 enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_CAP_INFO,
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index a859921bbe96..292222b7b733 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1485,7 +1485,11 @@ static const struct kernel_param_ops param_ops_metrics = {
 
 bool disable_send_metrics = false;
 module_param_cb(disable_send_metrics, &param_ops_metrics, &disable_send_metrics, 0644);
-MODULE_PARM_DESC(disable_send_metrics, "Enable sending perf metrics to ceph cluster (default: on)");
+MODULE_PARM_DESC(disable_send_metrics, "Disable sending perf metrics to ceph cluster (default: off)");
+
+bool force_ignore_metric_bits = false;
+module_param_cb(force_ignore_metric_bits, &param_ops_bool, &force_ignore_metric_bits, 0644);
+MODULE_PARM_DESC(disable_send_metrics, "Force ignoring session's metric bits from MDS (default: off)");
 
 /* for both v1 and v2 syntax */
 static bool mount_support = true;
-- 
2.27.0

