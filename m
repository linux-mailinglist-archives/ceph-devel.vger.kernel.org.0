Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E5240A996
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 10:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhINIud (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 04:50:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229975AbhINIuc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 04:50:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631609355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94bxeY6gumFwJyEdsBeiulsS76oOAFB07V0I+tckFa8=;
        b=K9Zx4mydwVXSeCLmXwUZq6XnL5Cria044MbeLy8fmGVd2TwXuLRA3D4rsyPvkXGJRBhHTV
        VsE9vs6fw1Em+ihaJEaMgCWoSTpwBxnyCDhz60Dl62zfoBD4ERr8jLaZBKORHlDAyyamvw
        mQU0VYzKuzgZnB6yj3vjpV4qCtT2GiA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-pco8rt_GM2CMEiqUiVhzlQ-1; Tue, 14 Sep 2021 04:49:14 -0400
X-MC-Unique: pco8rt_GM2CMEiqUiVhzlQ-1
Received: by mail-pf1-f197.google.com with SMTP id 127-20020a621685000000b0043376b0ce1dso7856379pfw.22
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 01:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=94bxeY6gumFwJyEdsBeiulsS76oOAFB07V0I+tckFa8=;
        b=oAJ3iNdgwtKML/TMMzhNit/DccZHIcXeL2/fKcMIUT1yLIj4Mq2/TmND8znl1lW8oP
         K26StT3za/ycYUrC+jIwN1XE+OnDaZe6kHnB3maAO3MpbmxUXxouQm1c2lJ30lfnhZrh
         LB/ViqrII3KbibaQyXXv3PRrr743Q85gaoEmJ6w3Gser2enEFbENZBUIBIOjZGKONibb
         flTTktA+cTwm1b8QGEJoshepBefLKvObeGxMXjiC4iWhjlUhLq2MyPzHZwFm7DlP8zxO
         kU0bQj8jKMJkKzV3P2RuDR/j+o+9yc4DNhj8c0g02DdqWz0PojL6oqmW9l8Oem943p8j
         dG4g==
X-Gm-Message-State: AOAM532KVFtKNQ7DKoj3SRPl6TuJD3y1cY8EQHdoQb3rQ65YmgOukBiG
        FZ19qh1bZEDBnC0wuFGv0FVzk4JNhSMxM9O3xSpdEQSckvtWrBeFZh/WyUNyDEzK5AJHrjB0D9g
        FCNjh9w27hQt3RtcFmwX7bw==
X-Received: by 2002:a05:6a00:2787:b0:43d:e275:7e1a with SMTP id bd7-20020a056a00278700b0043de2757e1amr3723275pfb.49.1631609352826;
        Tue, 14 Sep 2021 01:49:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/NE5IUH0wCyef+D3IblaUWGIODaQQnLe++ASPO8tdI5Fxs3RCtPwL4uGjoPVptzH8C0uspA==
X-Received: by 2002:a05:6a00:2787:b0:43d:e275:7e1a with SMTP id bd7-20020a056a00278700b0043de2757e1amr3723257pfb.49.1631609352592;
        Tue, 14 Sep 2021 01:49:12 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id b12sm10006219pff.63.2021.09.14.01.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 01:49:12 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 1/4] ceph: use "struct ceph_timespec" for r/w/m latencies
Date:   Tue, 14 Sep 2021 14:18:59 +0530
Message-Id: <20210914084902.1618064-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914084902.1618064-1-vshankar@redhat.com>
References: <20210914084902.1618064-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 12 ++++++------
 fs/ceph/metric.h | 11 ++++-------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 04d5df29bbbf..226dc38e2909 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -64,8 +64,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
 	sum = m->read_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
-	read->sec = cpu_to_le32(ts.tv_sec);
-	read->nsec = cpu_to_le32(ts.tv_nsec);
+	read->lat.tv_sec = cpu_to_le32(ts.tv_sec);
+	read->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
 	items++;
 
 	/* encode the write latency metric */
@@ -76,8 +76,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
 	sum = m->write_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
-	write->sec = cpu_to_le32(ts.tv_sec);
-	write->nsec = cpu_to_le32(ts.tv_nsec);
+	write->lat.tv_sec = cpu_to_le32(ts.tv_sec);
+	write->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
 	items++;
 
 	/* encode the metadata latency metric */
@@ -88,8 +88,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
 	sum = m->metadata_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
-	meta->sec = cpu_to_le32(ts.tv_sec);
-	meta->nsec = cpu_to_le32(ts.tv_nsec);
+	meta->lat.tv_sec = cpu_to_le32(ts.tv_sec);
+	meta->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
 	items++;
 
 	/* encode the dentry lease metric */
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 0133955a3c6a..103ed736f9d2 100644
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

