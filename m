Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4784B6747
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 10:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbiBOJRZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 04:17:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbiBOJRY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 04:17:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F300DAE54
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 01:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644916634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7tx8Dzct8q7hKQEHq3Uz7bCH+72mRHOiuvjImObc5Q=;
        b=GFJ5JZ/Gle7soXJoSW/lxVKV6+14MM3/sJYsQrPfvQfjmQnogkNbyKAfgKl28DceJ2xG/8
        1p/t63Dtbz5zsAuJLW5OlO0USEbfLVpOukcf9ZbPJJ6cTG0vInSmbhm0LQ0n62+3ZBNriQ
        feym/pTESgm8jKRzTslFHE6/yaB3ppI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-4HYAV0nUNHWDrTaSda2lgg-1; Tue, 15 Feb 2022 04:17:13 -0500
X-MC-Unique: 4HYAV0nUNHWDrTaSda2lgg-1
Received: by mail-pj1-f71.google.com with SMTP id f2-20020a17090a4a8200b001b7dac53bd6so12721462pjh.4
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 01:17:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C7tx8Dzct8q7hKQEHq3Uz7bCH+72mRHOiuvjImObc5Q=;
        b=Gzoq9H+zwloAEcOi1JkK/1fSoQZTuOoeDgp1lo4GEw8IPehCxv4UXg33jolll91oAA
         RelJkQyg8G5N9zLElt71G70sI1xWbLhBfAij9G0UY/koAZnnHsVzDlxv72cg1ECJ0LXX
         emSdVvUXrO+gVHO5Hq90MdLe7RIURDQX2AwBnnG53FnpyV7+sn+Lj+HN6UFOHdPO7VY2
         VX5pS2VmFqFftimCXMzjBKyY1hKnuCCjXobRsOJ3NuFs/oI50JHPgut0czzL/wjVFtiV
         GxwWq795+GVg7e40ZlaiOeP9c85yPSBTU/8e94PikBwzgJL/m+Bzla5RGP1UrgMerCjE
         mZlw==
X-Gm-Message-State: AOAM5303W+N8TsrFvUyg0af7DobJM5MHYuoivtxJH4yGWizIVcaYQTNl
        DOJWCLYPlH1+nqaxZ3mUJx8B01V0pMVMHAvpTvC8zjLsmpukTjRmnnw2B+2IZLi+NaGmgWpzvlB
        eY0ySnbTZ3GhHFPj6Sq3THA==
X-Received: by 2002:a17:90a:5890:: with SMTP id j16mr3278531pji.185.1644916631970;
        Tue, 15 Feb 2022 01:17:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJymWAX17iUlBl/LBTj9s0RbkCLzSIk8PVLzM4O+J41VMU1bjrb0z3K4QJnuTJ/XWKp7BA0i4w==
X-Received: by 2002:a17:90a:5890:: with SMTP id j16mr3278518pji.185.1644916631771;
        Tue, 15 Feb 2022 01:17:11 -0800 (PST)
Received: from h3ckers-pride.redhat.com ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id kk14sm16569550pjb.26.2022.02.15.01.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 01:17:11 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 2/3] ceph: include average/stdev r/w/m latency in mds metrics
Date:   Tue, 15 Feb 2022 14:46:56 +0530
Message-Id: <20220215091657.104079-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215091657.104079-1-vshankar@redhat.com>
References: <20220215091657.104079-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 73e98d45442a..5842da86c2bf 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -65,31 +65,40 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	/* encode the read latency metric */
 	read = (struct ceph_metric_read_latency *)(cap + 1);
 	read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
-	read->header.ver = 1;
+	read->header.ver = 2;
 	read->header.compat = 1;
 	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
 	sum = m->metric[METRIC_READ].latency_sum;
 	to_ceph_timespec(&read->lat, sum);
+	to_ceph_timespec(&read->avg, m->metric[METRIC_READ].latency_avg);
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
 	to_ceph_timespec(&write->lat, sum);
+	to_ceph_timespec(&write->avg, m->metric[METRIC_WRITE].latency_avg);
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
 	to_ceph_timespec(&meta->lat, sum);
+	to_ceph_timespec(&meta->avg, m->metric[METRIC_METADATA].latency_avg);
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
2.27.0

