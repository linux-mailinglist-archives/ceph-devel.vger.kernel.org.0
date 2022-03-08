Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7ACE4D181D
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 13:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239367AbiCHMnd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 07:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiCHMnb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 07:43:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8036610FEF
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 04:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646743353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IOQlc/yPzXYf7B6+it55mF2WuN4GBRT97ljjsOSVJj4=;
        b=HQI84KgmcgT7pDHW9GMX0fkpM4Qb1/dJsZkVOpqwwjOGc2NkipA6MoNm/DbiNfZgUxSMhb
        zB69xk9ImEMxYhlrcx7j6I0B68XQ+STfwgKTTamOlL/UzM5wZTCdizDFofwjU6kcAKvX9d
        LGhcxjEmzSNBLa79i5hNZ2aDjBdtYyA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-I4OBplF1MKaRkpksYQYjYg-1; Tue, 08 Mar 2022 07:42:32 -0500
X-MC-Unique: I4OBplF1MKaRkpksYQYjYg-1
Received: by mail-pj1-f70.google.com with SMTP id t12-20020a17090a448c00b001b9cbac9c43so1434778pjg.2
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 04:42:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IOQlc/yPzXYf7B6+it55mF2WuN4GBRT97ljjsOSVJj4=;
        b=ph/kHD6RrI2zTVI5w7PeDLJX5DyTQCo2kGOxmj/dnrbo7FKK+T+XjCCgiCI3l15Cpb
         sVL7Dy4YKTBdzqEmvFXpCH70GjbvP6NegNFzxCALR6hO4WDiKuyZO1iCwPvEmYiYGaPv
         BE1/qSHoFqkBD/bve3uDr5rDx0hWXn+DdnV+kQd8/lyZyg2mITI0EU1DAqnTWCqDmSEc
         Sj/c/TjZVJnCXHhAN3CAmkHxfvi/bjRPuVaGw/W8YOkFZ5Jg8D/XZPZsq4qL/jE++Bjq
         c+KV/fVAartjqD1jGFQff6Y8oxAaYycTaqb1ONdztMT2VI+adDYxyDhBaicg5ZugDjKg
         XUOw==
X-Gm-Message-State: AOAM533aKxBX0GgIUnwDaBypwAPx7AaT6hbyjn4XpWjhVZZVOW2zEesd
        feUKgCz6kbz1Td2J53SfW2oIKVRoMaOyOvyAgPVWAMGl5kNH3qSHTOItfhuJqqGd0uY2iSUOEv1
        TI5/POy8xDbQ/LVj/hg35mg==
X-Received: by 2002:a05:6a00:1705:b0:4f6:e1e4:447e with SMTP id h5-20020a056a00170500b004f6e1e4447emr15367808pfc.16.1646743350987;
        Tue, 08 Mar 2022 04:42:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznr2mO3RwSKcIWYvuJy4Hpzo2o5MW3cZR5y06XcaqXiGrd6z4rIJIAy7jplT9DOuNxnbWMnQ==
X-Received: by 2002:a05:6a00:1705:b0:4f6:e1e4:447e with SMTP id h5-20020a056a00170500b004f6e1e4447emr15367782pfc.16.1646743350692;
        Tue, 08 Mar 2022 04:42:30 -0800 (PST)
Received: from localhost.localdomain ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id o185-20020a6341c2000000b0036fb987b25fsm15344959pga.38.2022.03.08.04.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 04:42:29 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 1/4] ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
Date:   Tue,  8 Mar 2022 07:42:16 -0500
Message-Id: <20220308124219.771527-2-vshankar@redhat.com>
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

Latencies are of type ktime_t, coverting from jiffies is incorrect.
Also, switch to "struct ceph_timespec" for r/w/m latencies.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
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
2.31.1

