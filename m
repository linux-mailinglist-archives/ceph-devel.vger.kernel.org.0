Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD6D408C34
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 15:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbhIMNPB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 09:15:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230042AbhIMNOx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 09:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631538817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/w2YwygMjuD8v3YdAaT+84vzymftMz0naG1pDb7N/Ik=;
        b=DmxDpjJ/ePm+NSsFbu/saNtqBxRxwfJt5FtK3aX3yrT/3lguiN0tefLChlqJWN+rOnlRq4
        PKfQXJMrLGtLwq5srThaGETmO5p8wdx8oYUBH55JVoENCYV/0/Etx8JDeHGvBOpWn+zMug
        2gC3iUnJfEMAg1g34ZGM4h5JNsWq+zk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-540BM-u4MfaFORVHsT3JaA-1; Mon, 13 Sep 2021 09:13:36 -0400
X-MC-Unique: 540BM-u4MfaFORVHsT3JaA-1
Received: by mail-pl1-f198.google.com with SMTP id c4-20020a170902848400b0013a24e27075so3207112plo.16
        for <ceph-devel@vger.kernel.org>; Mon, 13 Sep 2021 06:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/w2YwygMjuD8v3YdAaT+84vzymftMz0naG1pDb7N/Ik=;
        b=RY6fN29KLp65d1KM61lBOrVI+RYJJWgPtLDWPs2TEE2+uc88uso8oXUv4E8Jml2URq
         qAsTFgWwtTm6u3o5f09HJDogbWDVwvoxuXq1FthZBziqpOazkyaySjhdbuxntZ+nNqVn
         BiVw5yVna4khJ/CS2kN5rWHb5bwzGQfd+qLV92guhOXYD9OigrNR1y5ph7otttBCSUOp
         o3KJrPsUBTW7yr4I1rLAtrDHbqxuSlC9ThRyBy941Xb1PaU+5eXYI2f6C4qNU3X/DxDv
         MPe6CdWZiwix6HeYPZwWQS15YjEppdZ4BQS0M6U5owIfeSoY0fPe7m+bO2c7U8C1/h9R
         jNJQ==
X-Gm-Message-State: AOAM531bZuAvGozz+4b3Ht+1zIfbWjTZnLDARG5Z8o9rTgyWnLtIWh3G
        lZGhRNrwUG+2R82kyvPGC/8JDhVXyFKiEg0A+yMFe8kQEXXzLQ9sqg4RndxPLer/BE5BRMvftmm
        oGNbe66jW2z7Uu/WSO27b1Q==
X-Received: by 2002:a62:82c6:0:b0:410:afa1:6028 with SMTP id w189-20020a6282c6000000b00410afa16028mr11399238pfd.35.1631538815033;
        Mon, 13 Sep 2021 06:13:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDTFyJsJTLTl/eBDbRMZrFxtxIWt7vM3/3IbrHSPfDh1+TedB7lNfaXP7jQVINrmYJ4NHWIA==
X-Received: by 2002:a62:82c6:0:b0:410:afa1:6028 with SMTP id w189-20020a6282c6000000b00410afa16028mr11399223pfd.35.1631538814834;
        Mon, 13 Sep 2021 06:13:34 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id i10sm7362010pfk.151.2021.09.13.06.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:13:34 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v1 4/4] ceph: use tracked average r/w/m latencies to display metrics in debugfs
Date:   Mon, 13 Sep 2021 18:43:11 +0530
Message-Id: <20210913131311.1347903-5-vshankar@redhat.com>
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
 fs/ceph/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 9153bc233e08..e3fccf7c6fb5 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -173,7 +173,7 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_lock(&m->read_latency_lock);
 	total = m->total_reads;
 	sum = m->read_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = m->avg_read_latency;
 	min = m->read_latency_min;
 	max = m->read_latency_max;
 	sq = m->read_latency_stdev;
@@ -183,7 +183,7 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_lock(&m->write_latency_lock);
 	total = m->total_writes;
 	sum = m->write_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = m->avg_write_latency;
 	min = m->write_latency_min;
 	max = m->write_latency_max;
 	sq = m->write_latency_stdev;
@@ -193,7 +193,7 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_lock(&m->metadata_latency_lock);
 	total = m->total_metadatas;
 	sum = m->metadata_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = m->avg_metadata_latency;
 	min = m->metadata_latency_min;
 	max = m->metadata_latency_max;
 	sq = m->metadata_latency_stdev;
-- 
2.27.0

