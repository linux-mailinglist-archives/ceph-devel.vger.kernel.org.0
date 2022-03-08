Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DA74D181E
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 13:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240353AbiCHMnm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 07:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238005AbiCHMnl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 07:43:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E3171EC43
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 04:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646743360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JmRgxHI8dk3jXbaAznquSLBTy6hZLdGcKiB3fZRikQo=;
        b=A/xbeFZzcyuy2bk9nP8t3wPOJrDlJD5CEBwRms8JVqRCxjHdfMHQjjO4inrZXezLXvk1oO
        mZkAjg6/EG3KbvMGbmarbGnxCmtYCm0WtF5YgZZb502cBvsYfKqS1DPd1zLqmaQqgf8A7o
        kS4DcDQCmallQ/AOwTvHW8dJroCN3v4=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-1rUmHKscOlitLtaJWW_wqg-1; Tue, 08 Mar 2022 07:42:39 -0500
X-MC-Unique: 1rUmHKscOlitLtaJWW_wqg-1
Received: by mail-pg1-f198.google.com with SMTP id v4-20020a63f844000000b003745fd0919aso10251758pgj.20
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 04:42:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JmRgxHI8dk3jXbaAznquSLBTy6hZLdGcKiB3fZRikQo=;
        b=4aq3AEpGP1x/dtTbwUKfoihqQcZw1Hr1kp2S32046+9yPljQwY6Pe668xobZWgvQJC
         yp2YYzE+YzPl/EMvO4C3kBVr/Wic4ncvlI8B2CWl5KQ9nok/gw6MqCI6zJQeh5Xn38oR
         nC+41JPGHOIxdfJ6GmLJy8+INcn4f6la1zp2Z9qW2AGuLNgpVp3RQ9au5xF/wa9afnZ+
         YyfuhJb3ULySpuTgeh8kGCG+t47zaer92ToM2HpatAVw1CCPQVb9Wpb6v+5mgzCX9lGV
         EqRqZhPwUaBYEs6BxyY+OqtvA6OUyMtKOyxJ5c2XCojtr3gu54bA8x+ovISgAiOkE5Ty
         PMMg==
X-Gm-Message-State: AOAM531HfBAkdecxV5gm1Nbvbjz33eB3NKBWYUWSbtSYW9O/P0TmeTts
        7ed/bcPNio+qwpyBVcvPr0Bv9KdY/WOEN6+epabvtAW0MF0d2HiXwTsknS2gEBBpbjrMZMhl3te
        TrjRdTcpF3Q7y2nPXvUftJQ==
X-Received: by 2002:a17:90a:a892:b0:1be:f420:bd1e with SMTP id h18-20020a17090aa89200b001bef420bd1emr4476246pjq.58.1646743358010;
        Tue, 08 Mar 2022 04:42:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx67qn1voSPjVrWvwqo42VJoJIA1qvUnTEagZdrEEfNzr4hMawrZbgijxs7loKLypAlz9FbCg==
X-Received: by 2002:a17:90a:a892:b0:1be:f420:bd1e with SMTP id h18-20020a17090aa89200b001bef420bd1emr4476223pjq.58.1646743357707;
        Tue, 08 Mar 2022 04:42:37 -0800 (PST)
Received: from localhost.localdomain ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id o185-20020a6341c2000000b0036fb987b25fsm15344959pga.38.2022.03.08.04.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 04:42:37 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 2/4] ceph: track average r/w/m latency
Date:   Tue,  8 Mar 2022 07:42:17 -0500
Message-Id: <20220308124219.771527-3-vshankar@redhat.com>
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

Make the math a bit simpler to understand (should not
effect execution speeds).

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 29 +++++++++++++++--------------
 fs/ceph/metric.h |  1 +
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 454d2c93208e..14b6af48b611 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -249,6 +249,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
 		metric->size_max = 0;
 		metric->total = 0;
 		metric->latency_sum = 0;
+		metric->latency_avg = 0;
 		metric->latency_sq_sum = 0;
 		metric->latency_min = KTIME_MAX;
 		metric->latency_max = 0;
@@ -306,20 +307,19 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 		max = new;			\
 }
 
-static inline void __update_stdev(ktime_t total, ktime_t lsum,
-				  ktime_t *sq_sump, ktime_t lat)
+static inline void __update_mean_and_stdev(ktime_t total, ktime_t *lavg,
+					   ktime_t *sq_sump, ktime_t lat)
 {
-	ktime_t avg, sq;
-
-	if (unlikely(total == 1))
-		return;
-
-	/* the sq is (lat - old_avg) * (lat - new_avg) */
-	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
-	sq = lat - avg;
-	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
-	sq = sq * (lat - avg);
-	*sq_sump += sq;
+	ktime_t avg;
+
+	if (unlikely(total == 1)) {
+		*lavg = lat;
+	} else {
+		/* the sq is (lat - old_avg) * (lat - new_avg) */
+		avg = *lavg + div64_s64(lat - *lavg, total);
+		*sq_sump += (lat - *lavg)*(lat - avg);
+		*lavg = avg;
+	}
 }
 
 void ceph_update_metrics(struct ceph_metric *m,
@@ -338,6 +338,7 @@ void ceph_update_metrics(struct ceph_metric *m,
 	METRIC_UPDATE_MIN_MAX(m->size_min, m->size_max, size);
 	m->latency_sum += lat;
 	METRIC_UPDATE_MIN_MAX(m->latency_min, m->latency_max, lat);
-	__update_stdev(total, m->latency_sum, &m->latency_sq_sum, lat);
+	__update_mean_and_stdev(total, &m->latency_avg,	&m->latency_sq_sum,
+				lat);
 	spin_unlock(&m->lock);
 }
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 5b2bb2897056..c47ba0074e49 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -137,6 +137,7 @@ struct ceph_metric {
 	u64 size_min;
 	u64 size_max;
 	ktime_t latency_sum;
+	ktime_t latency_avg;
 	ktime_t latency_sq_sum;
 	ktime_t latency_min;
 	ktime_t latency_max;
-- 
2.31.1

