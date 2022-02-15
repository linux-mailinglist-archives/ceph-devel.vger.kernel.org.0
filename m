Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA12D4B6748
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 10:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiBOJRT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 04:17:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbiBOJRT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 04:17:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0881AAE6F
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 01:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644916629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eiu+Fs9WTha6ja/10Sm+YNnaJJVJZmbeDmhwpLOfjS8=;
        b=aOuFsUtL1447G8AgfZJfSSv7F0Z6w0kgjBSVuZkDBig2UbCJc7kQGwgrhXRwPcrSREOhLd
        YJd4aDa02yDnjTOuOIzGXTC4lGl+RRzy2QNDVB+mnczgGV27tF4f0Fu04TNaujqpSZFr/L
        UKneUVaqSNr41VIhgQHvXO35gELlaBw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-fk6E_0HUMCmqcSJNx5zUuQ-1; Tue, 15 Feb 2022 04:17:08 -0500
X-MC-Unique: fk6E_0HUMCmqcSJNx5zUuQ-1
Received: by mail-pj1-f71.google.com with SMTP id q40-20020a17090a17ab00b001bafa89b70aso636060pja.2
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 01:17:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eiu+Fs9WTha6ja/10Sm+YNnaJJVJZmbeDmhwpLOfjS8=;
        b=R4wmpNHvPlv5GjbPN9e9sOtboo89spOzmZQcw1RpNt4pUyia1TAXHgycxfDsL9we8r
         l6wmfwUlWNI2Q9xexwu6MZCrhgxUVauOd6wGh7OlsRD3R41xZF54jVJ6CQC7O79Gqb27
         zTz5qjfuCmct9MemdvPr2pkgBlJDZl57X1w4Yx0qGmRYdu/aQ3JSyE+Fc++aHxDSvVfi
         eR4NdUl81H+OSVIKy3Dqazwh8V9XUjDXEreab3zpTd4AzcMK/a0YBanwdH1DwOPN8aYU
         6UqTMAcZyTkEd+LD9ovhDXw043YZauUlzCNL+R9VLT+ZNP5AASUYl47wyNS2Zx0kDB4A
         UfMA==
X-Gm-Message-State: AOAM530wZIDdgubquVhZPLOWTDPo3DcZcOVVKHGmIB3Im2Fso1zJNwOi
        iOIqZlqd39Re8B+0A3UEXu8R+9VjeTo1LeSUddfGrVY43xSVqD2RR0aVCV3vavSsPssaCj0hAO6
        OSu/jSyv3nanDWDqEBNh+Qg==
X-Received: by 2002:a17:902:c40b:: with SMTP id k11mr3230575plk.58.1644916626653;
        Tue, 15 Feb 2022 01:17:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzx29bGiHjkeGNXKvV+ch5hYkiSOUz7ifGwfDHdmyFhvbG/k/nAb0WuHowQlpAsB/GVADJTTA==
X-Received: by 2002:a17:902:c40b:: with SMTP id k11mr3230554plk.58.1644916626401;
        Tue, 15 Feb 2022 01:17:06 -0800 (PST)
Received: from h3ckers-pride.redhat.com ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id kk14sm16569550pjb.26.2022.02.15.01.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 01:17:05 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 1/3] ceph: track average r/w/m latency
Date:   Tue, 15 Feb 2022 14:46:55 +0530
Message-Id: <20220215091657.104079-2-vshankar@redhat.com>
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

Make the math a bit simpler to understand (should not
effect execution speeds).

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 29 +++++++++++++++--------------
 fs/ceph/metric.h |  1 +
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index a9cd23561a0d..73e98d45442a 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -250,6 +250,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
 		metric->size_max = 0;
 		metric->total = 0;
 		metric->latency_sum = 0;
+		metric->latency_avg = 0;
 		metric->latency_sq_sum = 0;
 		metric->latency_min = KTIME_MAX;
 		metric->latency_max = 0;
@@ -307,20 +308,19 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
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
@@ -339,6 +339,7 @@ void ceph_update_metrics(struct ceph_metric *m,
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
2.27.0

