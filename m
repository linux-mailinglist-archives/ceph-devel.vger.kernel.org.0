Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9974D181F
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 13:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238615AbiCHMnn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 07:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240492AbiCHMnl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 07:43:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 908AA1FA7C
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 04:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646743363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r5zWP/uPpqwhYHaqMbF3TyI7Imw51wJg0i6kZ1qbLOA=;
        b=XpbMlqZs7kVbrxQORyG02ETSjak/qc7XpAQ2U7NUzRoqCaniouZd7rF26/wgRIi1htUBaT
        DdYgF6v5UJcQjhNUI4pProLFDFRZxZWnx65bwP0GcmsPn7bYLGMiJXzqmcDV4DV/QzOwLo
        N8jf2vHjPtd+yv6vcp/22LZd8tmIBms=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-u9wOAiesOmqRbY9xBSqhrA-1; Tue, 08 Mar 2022 07:42:41 -0500
X-MC-Unique: u9wOAiesOmqRbY9xBSqhrA-1
Received: by mail-pl1-f198.google.com with SMTP id q8-20020a170902f78800b00151cc484688so2187798pln.20
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 04:42:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r5zWP/uPpqwhYHaqMbF3TyI7Imw51wJg0i6kZ1qbLOA=;
        b=FroNfcHRwI8zi3/F7oDbqIKCHWdbWLy2DD3DiYJ7vhiAfUC/fqnBegP3vEfpEMS1t/
         2c6ZGztJJIbVnm4O74/pV3Oqql3O3jsp0IDDtGtL4LMOUf4ZNNEEiKk9T8o8T5p4jdkC
         ZzKfzZ/V3TN6CusQ3WVF2ntqo77WV/9QohY8BdBd0uywaRt+Vckwdn83odBBrW42IYcw
         8a+3SBU4pZ5xhLAEYciO0D1kyszhCGZrFWFETH0FNWbloH7d2dCGy6MOzHcpoVbm6FD/
         HMYeKvtHWVbQeT7AFkGhVzLDw3fDAMRbowHoABZCViAfaXvXMAKCOh8FyJDeV2yCQwWq
         KIpQ==
X-Gm-Message-State: AOAM532iNu55wXde9RHoOCbJdjUFZZ9s+mTPICxaH6+u7EnYlwBoOCuf
        rSVHMrXsZXSufVr+kMAGv+Ej5fgJ+r6gNmVTBxkYlG6RKb/Colnms/0V9aINnXXGn5jDB69+08f
        stfQjR/1Wf9rE4tNHL9ENlg==
X-Received: by 2002:a63:e817:0:b0:373:8abb:2c51 with SMTP id s23-20020a63e817000000b003738abb2c51mr13999325pgh.185.1646743360817;
        Tue, 08 Mar 2022 04:42:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTrLZXoGzmOApsAfWrntD+niQNM5ynrN2IhGCqKrh/NPkxBMy7kPyx+PXL0Xr17eP5KN5oyA==
X-Received: by 2002:a63:e817:0:b0:373:8abb:2c51 with SMTP id s23-20020a63e817000000b003738abb2c51mr13999313pgh.185.1646743360577;
        Tue, 08 Mar 2022 04:42:40 -0800 (PST)
Received: from localhost.localdomain ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id o185-20020a6341c2000000b0036fb987b25fsm15344959pga.38.2022.03.08.04.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 04:42:39 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 3/4] ceph: include average/stdev r/w/m latency in mds metrics
Date:   Tue,  8 Mar 2022 07:42:18 -0500
Message-Id: <20220308124219.771527-4-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308124219.771527-1-vshankar@redhat.com>
References: <20220308124219.771527-1-vshankar@redhat.com>
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

stdev is computed in `cephfs-top` tool - clients forward
square of sums and IO count required to calculate stdev.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 15 +++++++++++---
 fs/ceph/metric.h | 51 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 14b6af48b611..c47347d2e84e 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -64,31 +64,40 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	/* encode the read latency metric */
 	read = (struct ceph_metric_read_latency *)(cap + 1);
 	read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
-	read->header.ver = 1;
+	read->header.ver = 2;
 	read->header.compat = 1;
 	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
 	sum = m->metric[METRIC_READ].latency_sum;
 	ktime_to_ceph_timespec(&read->lat, sum);
+	ktime_to_ceph_timespec(&read->avg, m->metric[METRIC_READ].latency_avg);
+	read->sq_sum = cpu_to_le64(m->metric[METRIC_READ].latency_sq_sum);
+	read->count = cpu_to_le64(m->metric[METRIC_READ].total);
 	items++;
 
 	/* encode the write latency metric */
 	write = (struct ceph_metric_write_latency *)(read + 1);
 	write->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
-	write->header.ver = 1;
+	write->header.ver = 2;
 	write->header.compat = 1;
 	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
 	sum = m->metric[METRIC_WRITE].latency_sum;
 	ktime_to_ceph_timespec(&write->lat, sum);
+	ktime_to_ceph_timespec(&write->avg, m->metric[METRIC_WRITE].latency_avg);
+	write->sq_sum = cpu_to_le64(m->metric[METRIC_WRITE].latency_sq_sum);
+	write->count = cpu_to_le64(m->metric[METRIC_WRITE].total);
 	items++;
 
 	/* encode the metadata latency metric */
 	meta = (struct ceph_metric_metadata_latency *)(write + 1);
 	meta->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
-	meta->header.ver = 1;
+	meta->header.ver = 2;
 	meta->header.compat = 1;
 	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
 	sum = m->metric[METRIC_METADATA].latency_sum;
 	ktime_to_ceph_timespec(&meta->lat, sum);
+	ktime_to_ceph_timespec(&meta->avg, m->metric[METRIC_METADATA].latency_avg);
+	meta->sq_sum = cpu_to_le64(m->metric[METRIC_METADATA].latency_sq_sum);
+	meta->count = cpu_to_le64(m->metric[METRIC_METADATA].total);
 	items++;
 
 	/* encode the dentry lease metric */
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index c47ba0074e49..0d0c44bd3332 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -19,27 +19,39 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_OPENED_INODES,
 	CLIENT_METRIC_TYPE_READ_IO_SIZES,
 	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,
-
-	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_WRITE_IO_SIZES,
+	CLIENT_METRIC_TYPE_AVG_READ_LATENCY,
+	CLIENT_METRIC_TYPE_STDEV_READ_LATENCY,
+	CLIENT_METRIC_TYPE_AVG_WRITE_LATENCY,
+	CLIENT_METRIC_TYPE_STDEV_WRITE_LATENCY,
+	CLIENT_METRIC_TYPE_AVG_METADATA_LATENCY,
+	CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY,
+
+	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY,
 };
 
 /*
  * This will always have the highest metric bit value
  * as the last element of the array.
  */
-#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	\
-	CLIENT_METRIC_TYPE_CAP_INFO,		\
-	CLIENT_METRIC_TYPE_READ_LATENCY,	\
-	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
-	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
-	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
-	CLIENT_METRIC_TYPE_OPENED_FILES,	\
-	CLIENT_METRIC_TYPE_PINNED_ICAPS,	\
-	CLIENT_METRIC_TYPE_OPENED_INODES,	\
-	CLIENT_METRIC_TYPE_READ_IO_SIZES,	\
-	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,	\
-						\
-	CLIENT_METRIC_TYPE_MAX,			\
+#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	   \
+	CLIENT_METRIC_TYPE_CAP_INFO,		   \
+	CLIENT_METRIC_TYPE_READ_LATENCY,	   \
+	CLIENT_METRIC_TYPE_WRITE_LATENCY,	   \
+	CLIENT_METRIC_TYPE_METADATA_LATENCY,	   \
+	CLIENT_METRIC_TYPE_DENTRY_LEASE,	   \
+	CLIENT_METRIC_TYPE_OPENED_FILES,	   \
+	CLIENT_METRIC_TYPE_PINNED_ICAPS,	   \
+	CLIENT_METRIC_TYPE_OPENED_INODES,	   \
+	CLIENT_METRIC_TYPE_READ_IO_SIZES,	   \
+	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,	   \
+	CLIENT_METRIC_TYPE_AVG_READ_LATENCY,	   \
+	CLIENT_METRIC_TYPE_STDEV_READ_LATENCY,	   \
+	CLIENT_METRIC_TYPE_AVG_WRITE_LATENCY,	   \
+	CLIENT_METRIC_TYPE_STDEV_WRITE_LATENCY,	   \
+	CLIENT_METRIC_TYPE_AVG_METADATA_LATENCY,   \
+	CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY, \
+						   \
+	CLIENT_METRIC_TYPE_MAX,			   \
 }
 
 struct ceph_metric_header {
@@ -61,18 +73,27 @@ struct ceph_metric_cap {
 struct ceph_metric_read_latency {
 	struct ceph_metric_header header;
 	struct ceph_timespec lat;
+	struct ceph_timespec avg;
+	__le64 sq_sum;
+	__le64 count;
 } __packed;
 
 /* metric write latency header */
 struct ceph_metric_write_latency {
 	struct ceph_metric_header header;
 	struct ceph_timespec lat;
+	struct ceph_timespec avg;
+	__le64 sq_sum;
+	__le64 count;
 } __packed;
 
 /* metric metadata latency header */
 struct ceph_metric_metadata_latency {
 	struct ceph_metric_header header;
 	struct ceph_timespec lat;
+	struct ceph_timespec avg;
+	__le64 sq_sum;
+	__le64 count;
 } __packed;
 
 /* metric dentry lease header */
-- 
2.31.1

