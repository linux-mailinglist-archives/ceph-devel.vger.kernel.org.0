Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E137A40A999
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 10:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhINIur (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 04:50:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230392AbhINIuq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 04:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631609369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tVgMM/hZ0scN3mplgCXHpaheDp8zXpeuYksMAyv4xQI=;
        b=JZ4+TWfMFaMdb5tBGuJCHzBuIVXyknfPxDN/89eN8DJ97fI7McMH44el2NVkSUIoOfojFV
        o41KuVvDYBvpIKX8U0kn8pSY58Um4z1r3atQtnWrp9ZYZccZyPwDTba42MUdscNTPFmAdR
        kgfoYzA9dXDAdsSLwuX8XCR1g3s5dog=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-oju4UtarMXq9mBc4PtMy2g-1; Tue, 14 Sep 2021 04:49:28 -0400
X-MC-Unique: oju4UtarMXq9mBc4PtMy2g-1
Received: by mail-pj1-f69.google.com with SMTP id h1-20020a17090adb8100b001997671e011so2751551pjv.4
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 01:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tVgMM/hZ0scN3mplgCXHpaheDp8zXpeuYksMAyv4xQI=;
        b=p1RfJV6xWfhr+Im+S9+uT510HrKltUYuesjZNhPqqKE7QnoMjofRorMleKPgUgVKJQ
         YHDRAa3o4KpHMSEhXN+nedv+pQU4jkrj60pLhLKpYoNcxDtnaVMfJInHtzHRyHBmbku3
         9d4uY+QTk5tNEGmF7yMh3fDVCQhAPtMO0Wd/KdhKXsemBYaE7ouzuF0QhFoKzbUIWd1z
         Ygx8SvgGlCSz5fgMvIfo4ISbdPk9qD57pTXZj5IkxiBJEY5hgJQ35dypeR8RxUlFUF75
         cKKk0P9HJ6x8vB2GhxuKFvVuD2aexN03kknSdOdhwXWMxpLhzuk1tH+rOYtGzK9X6IPz
         a43w==
X-Gm-Message-State: AOAM532G7IHmlsB/yMhKQWNe4WM6G+eBtr6ENr5oXgId8aF/y05DIVa7
        9davBnjkaXOcuN8aj49dJwwJJxD2h0Hwl4T8My21swy8e8yLP1bzb1JETLvtILRFcPK3nOzl48S
        tFxmTfqBLo5jBtgPlr2OXTw==
X-Received: by 2002:a17:90a:62c7:: with SMTP id k7mr826101pjs.185.1631609366628;
        Tue, 14 Sep 2021 01:49:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkISyHVRCQZjO9G0Hm4058iswU3VGL03B4tMdbhn3+OV8Po3VumZmHLnXwNB3+4X4QlSIeGw==
X-Received: by 2002:a17:90a:62c7:: with SMTP id k7mr826080pjs.185.1631609366451;
        Tue, 14 Sep 2021 01:49:26 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id b12sm10006219pff.63.2021.09.14.01.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 01:49:26 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 4/4] ceph: use tracked average r/w/m latencies to display metrics in debugfs
Date:   Tue, 14 Sep 2021 14:19:02 +0530
Message-Id: <20210914084902.1618064-5-vshankar@redhat.com>
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
 fs/ceph/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 3abfa7ae8220..970aa04fb04d 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -172,7 +172,7 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_lock(&m->read_metric_lock);
 	total = m->total_reads;
 	sum = m->read_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = m->avg_read_latency;
 	min = m->read_latency_min;
 	max = m->read_latency_max;
 	stdev = m->read_latency_stdev;
@@ -182,7 +182,7 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_lock(&m->write_metric_lock);
 	total = m->total_writes;
 	sum = m->write_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = m->avg_write_latency;
 	min = m->write_latency_min;
 	max = m->write_latency_max;
 	stdev = m->write_latency_stdev;
@@ -192,7 +192,7 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_lock(&m->metadata_metric_lock);
 	total = m->total_metadatas;
 	sum = m->metadata_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = m->avg_metadata_latency;
 	min = m->metadata_latency_min;
 	max = m->metadata_latency_max;
 	stdev = m->metadata_latency_stdev;
-- 
2.31.1

