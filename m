Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F821408C31
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 15:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238400AbhIMNOy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 09:14:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240466AbhIMNOl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 09:14:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631538805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8T+3wLr4Q6eT/3BEGDvDJvh9VRXgD3Yl/eQxQ5rSuZo=;
        b=PUav+PH9p6+fERpufzj/MfQz+XZFCmdcmip/MuYID8BrKcMFVitWU9ik7chxeOqK20HZiz
        4j2NTdfcomk8LQ80ZSGiTQSEkwQCiHECas5Csude9o7CVidvDstuLNnMIhpW8PYQrVB+jP
        BlnCNdJ1wbAle8sO33t5Tyzy5+8tKwU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571--5c-srjBMjCYe41KZ_rPzQ-1; Mon, 13 Sep 2021 09:13:24 -0400
X-MC-Unique: -5c-srjBMjCYe41KZ_rPzQ-1
Received: by mail-pl1-f197.google.com with SMTP id f9-20020a1709028609b0290128bcba6be7so3200165plo.18
        for <ceph-devel@vger.kernel.org>; Mon, 13 Sep 2021 06:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8T+3wLr4Q6eT/3BEGDvDJvh9VRXgD3Yl/eQxQ5rSuZo=;
        b=bT/PxgJUPnBeFq1BxIhcu00aO8ijU8WH6AS71SjDX4o9CDMBesghDJIcq5G6otKpvq
         +7Ba7/0VZ0N1sxlzetjQYZjiEIwZEWs/GyS0up5Nil0iR10XNnnu9t0Cs4vZZuPFDzZh
         0drvlrsl0D6Ac+qWZiZxlnV8nOZprEG3O9uzd6zFngJ+TO3u3qAOQ3qSZbbCCHMBQLOM
         a5umOhB28+zDgBUK6qAG7cLQf4w3Nxq/c15p3WiLIXfk6oTclM2q0SOXL825DlITQtv9
         2WaDdhHj8fNeRVItQAKrFrDbLj7d6UzmRdbAfEA7BZHYmgFRC3a1HL6rbzOUxr1uX0mA
         6wwg==
X-Gm-Message-State: AOAM531uGqFkETqYXp7S9Uj7Yria82fqJ9rrVG7Xs9vigPmNUECDLXLn
        PRGfxPWN4UapInAMG3UcPaZcVbhRPs0WUVSdQxAcXh7q3VKzdWaJEQo+c+XL9XpvXHEBB48sgYS
        lvGhuKi7qMHYzKyFTpd3atg==
X-Received: by 2002:a63:33cb:: with SMTP id z194mr11182443pgz.380.1631538803536;
        Mon, 13 Sep 2021 06:13:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVB9xLDbuf8mwD02dpnbpTGt3WWgoBQrqpcw3ZSYlGGyBn/dtVZ9cqC4s0/vp6klqWDEyohg==
X-Received: by 2002:a63:33cb:: with SMTP id z194mr11182421pgz.380.1631538803300;
        Mon, 13 Sep 2021 06:13:23 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id i10sm7362010pfk.151.2021.09.13.06.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:13:22 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v1 1/4] ceph: use "struct ceph_timespec" for r/w/m latencies
Date:   Mon, 13 Sep 2021 18:43:08 +0530
Message-Id: <20210913131311.1347903-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913131311.1347903-1-vshankar@redhat.com>
References: <20210913131311.1347903-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 12 ++++++------
 fs/ceph/metric.h | 17 +++++++----------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 5ec94bd4c1de..19bca20cf7e1 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -56,8 +56,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	read->data_len = cpu_to_le32(sizeof(*read) - 10);
 	sum = m->read_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
-	read->sec = cpu_to_le32(ts.tv_sec);
-	read->nsec = cpu_to_le32(ts.tv_nsec);
+	read->lat.tv_sec = cpu_to_le32(ts.tv_sec);
+	read->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
 	items++;
 
 	/* encode the write latency metric */
@@ -68,8 +68,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	write->data_len = cpu_to_le32(sizeof(*write) - 10);
 	sum = m->write_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
-	write->sec = cpu_to_le32(ts.tv_sec);
-	write->nsec = cpu_to_le32(ts.tv_nsec);
+	write->lat.tv_sec = cpu_to_le32(ts.tv_sec);
+	write->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
 	items++;
 
 	/* encode the metadata latency metric */
@@ -80,8 +80,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
 	sum = m->metadata_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
-	meta->sec = cpu_to_le32(ts.tv_sec);
-	meta->nsec = cpu_to_le32(ts.tv_nsec);
+	meta->lat.tv_sec = cpu_to_le32(ts.tv_sec);
+	meta->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
 	items++;
 
 	/* encode the dentry lease metric */
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index af6038ff39d4..1151d64dbcbc 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -2,7 +2,7 @@
 #ifndef _FS_CEPH_MDS_METRIC_H
 #define _FS_CEPH_MDS_METRIC_H
 
-#include <linux/types.h>
+#include <linux/ceph/types.h>
 #include <linux/percpu_counter.h>
 #include <linux/ktime.h>
 
@@ -52,9 +52,8 @@ struct ceph_metric_read_latency {
 	__u8  ver;
 	__u8  compat;
 
-	__le32 data_len; /* length of sizeof(sec + nsec) */
-	__le32 sec;
-	__le32 nsec;
+	__le32 data_len; /* length of sizeof(lat) */
+	struct ceph_timespec lat;
 } __packed;
 
 /* metric write latency header */
@@ -64,9 +63,8 @@ struct ceph_metric_write_latency {
 	__u8  ver;
 	__u8  compat;
 
-	__le32 data_len; /* length of sizeof(sec + nsec) */
-	__le32 sec;
-	__le32 nsec;
+	__le32 data_len; /* length of sizeof(lat) */
+	struct ceph_timespec lat;
 } __packed;
 
 /* metric metadata latency header */
@@ -76,9 +74,8 @@ struct ceph_metric_metadata_latency {
 	__u8  ver;
 	__u8  compat;
 
-	__le32 data_len; /* length of sizeof(sec + nsec) */
-	__le32 sec;
-	__le32 nsec;
+	__le32 data_len; /* length of sizeof(lat) */
+	struct ceph_timespec lat;
 } __packed;
 
 /* metric dentry lease header */
-- 
2.27.0

