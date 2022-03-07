Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317144CFF2D
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Mar 2022 13:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbiCGMxp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Mar 2022 07:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiCGMxn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Mar 2022 07:53:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 282FA50B24
        for <ceph-devel@vger.kernel.org>; Mon,  7 Mar 2022 04:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646657567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=daTPEIlp+i9lBEJE6OWpnPrEb9HBm2mrWXcnEKerzBw=;
        b=jQkpt8+vXiSkT/XSosG0lnNyFJYJQTfLLiRoo/ttqZnjMN+0qPDymnqCNDyc5PB/TI8Jzo
        9CaD7mo1pP8t2RoLgB78W70j69Vu/+D3DU7YbSyXAvsKc7JWIaJgyDXYdkuzKernuyC6V2
        SMk8GyQR7wz6XM8r0vTimqwTBsw5Zy4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-1-Doy8X0O_OZ0v7Q5SPytg-1; Mon, 07 Mar 2022 07:52:46 -0500
X-MC-Unique: 1-Doy8X0O_OZ0v7Q5SPytg-1
Received: by mail-pj1-f70.google.com with SMTP id p8-20020a17090a74c800b001bf257861efso6641521pjl.6
        for <ceph-devel@vger.kernel.org>; Mon, 07 Mar 2022 04:52:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=daTPEIlp+i9lBEJE6OWpnPrEb9HBm2mrWXcnEKerzBw=;
        b=XKh80s94qnNYv77wV9TuaCPTGoBYYc2W7hGY0VTZ2+M9u4dgzjJmgb0/7SDXewGBVh
         R/06XajKpGqpYiwEw8ja90AIQA2vzcIy8lkbC/KjylMoj1Yyq9uEWMZocjeUNH0i0+lm
         XI/g+I2KZ+7off6NmG78wjlusnq5OeryzFdRat0gIovsxGBxJFCbAubN4NB5xzY+1CgD
         pvHcynKGAkSF3U/691bFs6Jy5cAK3v/NCyDC6WAwk4crjmrV95a+696kozq5YsRdSPU1
         EqbZLKcYDbXny65wcY9VehvvsEabe8Oxqiqe758A8ImgGFtJVcwag2fMBAUoFEE9DgRL
         D11g==
X-Gm-Message-State: AOAM531BG6tuB16oKBRLWrHy5jL3I62tYNDoQQD9w1X1n+Q3UVXc692f
        f9KWWMHYOTOsmiZoRGRZNpNg4NmpHzPeaJtAsM7x76zxlxR/AJYZokJZ3C2l/HyDvsmQ+Cs4fdb
        J5ppB4y/+38P4J9TodJrnWw==
X-Received: by 2002:a62:4e48:0:b0:4f6:cc16:8116 with SMTP id c69-20020a624e48000000b004f6cc168116mr12535934pfb.54.1646657565016;
        Mon, 07 Mar 2022 04:52:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw40vj1MKT6ldC/wMN9/EGCtHYG/ikODdwLB2xJuM4AdiYyKm2sEalPTEIab44+r+ljQhoIcA==
X-Received: by 2002:a62:4e48:0:b0:4f6:cc16:8116 with SMTP id c69-20020a624e48000000b004f6cc168116mr12535915pfb.54.1646657564685;
        Mon, 07 Mar 2022 04:52:44 -0800 (PST)
Received: from localhost.localdomain ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id s14-20020a056a0008ce00b004f66dcd4f1csm16525828pfu.32.2022.03.07.04.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 04:52:43 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, xiubli@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2] ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
Date:   Mon,  7 Mar 2022 07:52:35 -0500
Message-Id: <20220307125235.440185-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latencies are of type ktime_t, coverting from jiffies is incorrect.
Also, switch to "struct ceph_timespec" for r/w/m latencies.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---

v2:
  - rename to_ceph_timespec() to ktime_to_ceph_timespec()
  - use ceph_encode_timespec64() helper

 fs/ceph/metric.c | 19 +++++++++----------
 fs/ceph/metric.h | 11 ++++-------
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 0fcba68f9a99..454d2c93208e 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -8,6 +8,12 @@
 #include "metric.h"
 #include "mds_client.h"
 
+static void ktime_to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
+{
+	struct timespec64 t = ktime_to_timespec64(val);
+	ceph_encode_timespec64(ts, &t);
+}
+
 static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 				   struct ceph_mds_session *s)
 {
@@ -26,7 +32,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	u32 header_len = sizeof(struct ceph_metric_header);
 	struct ceph_msg *msg;
-	struct timespec64 ts;
 	s64 sum;
 	s32 items = 0;
 	s32 len;
@@ -63,9 +68,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	read->header.compat = 1;
 	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
 	sum = m->metric[METRIC_READ].latency_sum;
-	jiffies_to_timespec64(sum, &ts);
-	read->sec = cpu_to_le32(ts.tv_sec);
-	read->nsec = cpu_to_le32(ts.tv_nsec);
+	ktime_to_ceph_timespec(&read->lat, sum);
 	items++;
 
 	/* encode the write latency metric */
@@ -75,9 +78,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	write->header.compat = 1;
 	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
 	sum = m->metric[METRIC_WRITE].latency_sum;
-	jiffies_to_timespec64(sum, &ts);
-	write->sec = cpu_to_le32(ts.tv_sec);
-	write->nsec = cpu_to_le32(ts.tv_nsec);
+	ktime_to_ceph_timespec(&write->lat, sum);
 	items++;
 
 	/* encode the metadata latency metric */
@@ -87,9 +88,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	meta->header.compat = 1;
 	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
 	sum = m->metric[METRIC_METADATA].latency_sum;
-	jiffies_to_timespec64(sum, &ts);
-	meta->sec = cpu_to_le32(ts.tv_sec);
-	meta->nsec = cpu_to_le32(ts.tv_nsec);
+	ktime_to_ceph_timespec(&meta->lat, sum);
 	items++;
 
 	/* encode the dentry lease metric */
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index bb45608181e7..5b2bb2897056 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -2,7 +2,7 @@
 #ifndef _FS_CEPH_MDS_METRIC_H
 #define _FS_CEPH_MDS_METRIC_H
 
-#include <linux/types.h>
+#include <linux/ceph/types.h>
 #include <linux/percpu_counter.h>
 #include <linux/ktime.h>
 
@@ -60,22 +60,19 @@ struct ceph_metric_cap {
 /* metric read latency header */
 struct ceph_metric_read_latency {
 	struct ceph_metric_header header;
-	__le32 sec;
-	__le32 nsec;
+	struct ceph_timespec lat;
 } __packed;
 
 /* metric write latency header */
 struct ceph_metric_write_latency {
 	struct ceph_metric_header header;
-	__le32 sec;
-	__le32 nsec;
+	struct ceph_timespec lat;
 } __packed;
 
 /* metric metadata latency header */
 struct ceph_metric_metadata_latency {
 	struct ceph_metric_header header;
-	__le32 sec;
-	__le32 nsec;
+	struct ceph_timespec lat;
 } __packed;
 
 /* metric dentry lease header */
-- 
2.27.0

