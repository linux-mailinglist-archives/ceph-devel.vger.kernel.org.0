Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BC94AF582
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Feb 2022 16:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbiBIPi6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Feb 2022 10:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiBIPi5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Feb 2022 10:38:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72DCEC061355
        for <ceph-devel@vger.kernel.org>; Wed,  9 Feb 2022 07:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644421139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Pv33/DwoVXlct/SpwQbWme5TG+6JxNb5Ma4cBgzCAoQ=;
        b=NmFMNilKdvHmvwfexckGxgbkV72e0u/t3/E3hauoZ4OFNTfRtkjpSj0+jCQm1qLAIoQ5b6
        pZynwASZdfatqDeoRPddXj9S+lpdojzevVSQHLP6W67z4H9NeVw7wbEPhVk9psSvQEdV9U
        BOHDunwjvho8ek80kZLI4k76Ig/47fI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-7fxjTwHgOi2aOQmrrjaQeg-1; Wed, 09 Feb 2022 10:38:58 -0500
X-MC-Unique: 7fxjTwHgOi2aOQmrrjaQeg-1
Received: by mail-pf1-f200.google.com with SMTP id z29-20020a62d11d000000b004c8f0d5dec9so2141304pfg.4
        for <ceph-devel@vger.kernel.org>; Wed, 09 Feb 2022 07:38:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pv33/DwoVXlct/SpwQbWme5TG+6JxNb5Ma4cBgzCAoQ=;
        b=mXf1OfEvm5w4GnI7rizUw+9AXMqKLncU2gHUb40N4+5Lzq/8ETDhpSYImrFiwIJjEC
         lUc0F6lJZXcum2yDEVH6uhaTRR2c3CaUUxqUU8K+UwWRIL7COfX58fLN5sjTikj3VJ83
         XAhXgvUsP6N2d1i9RQHPs/YzdqKKQd+w4L9vGVXmyISxEabMuP6zU1mgNVHjzejbmhlQ
         qjDvxDd6tQ9J8uTW21GdKfH4cZsx1kq4b3wIEzmaYvaPJeu7rOwK+ylKJLX4+V8R+nXG
         ca861ZlpED0dyZmvEScw9SWX6cEUuJ7w2cSlO4SBGiE9vlKethyiw7SHEc3DWWKnh8Zl
         l7HA==
X-Gm-Message-State: AOAM530OLNsRcUbuTLlyvpk+P7ZhMdP6DV1w0nyExa9+SuA9TCiIrqcj
        D9jNoB+Y4ZlU5POHWOxGkgoBu+R9mVhp5BZdFDtry0sPXfVkWI3ZMtCZ5+OIm7qQD0Me1XOGddg
        P7kba38EqfGisXmG5O7DDuw==
X-Received: by 2002:a17:90b:314d:: with SMTP id ip13mr4006156pjb.42.1644421137191;
        Wed, 09 Feb 2022 07:38:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGXK+dYiTZeDSvtNC2YAZdWrefpHbJByrCaFaVQYSPSOF1HttjWsODCTV3pKuK+d2mZlPUjw==
X-Received: by 2002:a17:90b:314d:: with SMTP id ip13mr4006131pjb.42.1644421136878;
        Wed, 09 Feb 2022 07:38:56 -0800 (PST)
Received: from h3ckers-pride.redhat.com ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id y42sm20295926pfa.5.2022.02.09.07.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 07:38:56 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH] ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
Date:   Wed,  9 Feb 2022 21:08:49 +0530
Message-Id: <20220209153849.496639-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latencies are of type ktime_t, coverting from jiffies is incorrect.
Also, switch to "struct ceph_timespec" for r/w/m latencies.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 20 ++++++++++----------
 fs/ceph/metric.h | 11 ++++-------
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 0fcba68f9a99..a9cd23561a0d 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -8,6 +8,13 @@
 #include "metric.h"
 #include "mds_client.h"
 
+static void to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
+{
+	struct timespec64 t = ktime_to_timespec64(val);
+	ts->tv_sec = cpu_to_le32(t.tv_sec);
+	ts->tv_nsec = cpu_to_le32(t.tv_nsec);
+}
+
 static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 				   struct ceph_mds_session *s)
 {
@@ -26,7 +33,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	u32 header_len = sizeof(struct ceph_metric_header);
 	struct ceph_msg *msg;
-	struct timespec64 ts;
 	s64 sum;
 	s32 items = 0;
 	s32 len;
@@ -63,9 +69,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	read->header.compat = 1;
 	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
 	sum = m->metric[METRIC_READ].latency_sum;
-	jiffies_to_timespec64(sum, &ts);
-	read->sec = cpu_to_le32(ts.tv_sec);
-	read->nsec = cpu_to_le32(ts.tv_nsec);
+	to_ceph_timespec(&read->lat, sum);
 	items++;
 
 	/* encode the write latency metric */
@@ -75,9 +79,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	write->header.compat = 1;
 	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
 	sum = m->metric[METRIC_WRITE].latency_sum;
-	jiffies_to_timespec64(sum, &ts);
-	write->sec = cpu_to_le32(ts.tv_sec);
-	write->nsec = cpu_to_le32(ts.tv_nsec);
+	to_ceph_timespec(&write->lat, sum);
 	items++;
 
 	/* encode the metadata latency metric */
@@ -87,9 +89,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	meta->header.compat = 1;
 	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
 	sum = m->metric[METRIC_METADATA].latency_sum;
-	jiffies_to_timespec64(sum, &ts);
-	meta->sec = cpu_to_le32(ts.tv_sec);
-	meta->nsec = cpu_to_le32(ts.tv_nsec);
+	to_ceph_timespec(&meta->lat, sum);
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

