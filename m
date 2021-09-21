Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C3C4133C2
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Sep 2021 15:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhIUNJi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Sep 2021 09:09:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232828AbhIUNJh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 09:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632229689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94bxeY6gumFwJyEdsBeiulsS76oOAFB07V0I+tckFa8=;
        b=RTcn/5S7OGSUgfc2auqxIr3sTjVkcUi2n4kQNjOXFjSmT2qVF9tR0e43UMlLmTyUTQ/0/6
        VVmrakv6sL76pd4F/nS5jNYFup0Yc33yF1R06XTfZkfUe4GocgfTMqm6MUXZjtDUABjrm1
        s4gfyzKzIicCmm2xRbDdFdKUpZUKxQ0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-Cyt7gjyDNRqKvHN_cinwfg-1; Tue, 21 Sep 2021 09:08:08 -0400
X-MC-Unique: Cyt7gjyDNRqKvHN_cinwfg-1
Received: by mail-pg1-f200.google.com with SMTP id u7-20020a632347000000b0026722cd9defso18137078pgm.7
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 06:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=94bxeY6gumFwJyEdsBeiulsS76oOAFB07V0I+tckFa8=;
        b=dyXQlm14X9Yoq4DmX1gCdsuyxtjh280q6pnvolltd8WOVxg2luZFLtVn4TeT+h4wyh
         XKvIjIzP/ouE2k/8LntW+uZNhu+zobtC1WH2l18ZLT6TOU+Go/S2n0Q5vgXoqbX0ccg4
         BLpkuBXYlpoWdd8F7HjAS5sjqOUFPmRXaWLQKvbuJfhqI6xT5Na8IOQmrvZLRSwdctn6
         iqwykcAeXjPYt2Wg61+zvziwYHHIem0I2K3eVy6EeYJW/t49QGfcM9rg63IPWxa+qYqX
         fN21fk6LgNO0ziuT+1EyZhSr21F9O+S3YoD7FOCiUoVc9r4txzhI1tNc8xL5GCwJX0BB
         lksQ==
X-Gm-Message-State: AOAM530B+qtO5SGNnalLg1OQrap2oZev+hQEEdJk50NIVaeTscHZBLgJ
        8LAnmFz6Nrtaxl9GUooQsczit6eAIcdGWVtIlbqxQm+n3mSA5dmXeCrxmLN/jqTaHx2x39e36Tj
        BCcVC8kX8KbnyGPgW/f6hfQ==
X-Received: by 2002:a17:90b:1809:: with SMTP id lw9mr2463113pjb.217.1632229682844;
        Tue, 21 Sep 2021 06:08:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQ0/ewjH1nBLv6y7j4Ip0I13CQ7R9Wh5Q2OqOwmowCgbXrUef23vm1ZdcySnGLjwoHcNbDmQ==
X-Received: by 2002:a17:90b:1809:: with SMTP id lw9mr2462767pjb.217.1632229679152;
        Tue, 21 Sep 2021 06:07:59 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id w5sm18473890pgp.79.2021.09.21.06.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:07:58 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 1/4] ceph: use "struct ceph_timespec" for r/w/m latencies
Date:   Tue, 21 Sep 2021 18:37:47 +0530
Message-Id: <20210921130750.31820-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210921130750.31820-1-vshankar@redhat.com>
References: <20210921130750.31820-1-vshankar@redhat.com>
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

