Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B16E4133C4
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Sep 2021 15:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhIUNJn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Sep 2021 09:09:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232921AbhIUNJm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 09:09:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632229693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+p3P1OJI635czKUJqe6d5EEYbb5iEr7WLQFszSq5lQ=;
        b=XkthDUC7hTlFDOSN80XUffGedwduU6QfNO10pKlC0dugI7LzSD1wIBp0yARIzcrexn0+qP
        bSR0yjih9cvZM7ZGUTmnfJks+KZuPojUEKHe0la88eUtn7Ob4tUrgwNIGvcyxiH/shKTh1
        bPAOH74ThqGYNgSO4xELOLLclREP2C8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-SpRi9TU9Pwa_GWYl2LxWFw-1; Tue, 21 Sep 2021 09:08:12 -0400
X-MC-Unique: SpRi9TU9Pwa_GWYl2LxWFw-1
Received: by mail-pg1-f197.google.com with SMTP id u5-20020a63d3450000b029023a5f6e6f9bso18108867pgi.21
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 06:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9+p3P1OJI635czKUJqe6d5EEYbb5iEr7WLQFszSq5lQ=;
        b=GXitLBHSf4rAb+YXGwLNT49NJXfJWWuBFhLnze+fyEErY+u4U4YEXik7iS+w+/w8bu
         NmFT6csiuDQD8pV1pY+jtoM5ncMCLmrUxdRdh3FScar2h4oghJx8RkgpZEQ5yladsFWT
         9c+Q/cW2Bt+C21+erPFVBP21X/Nco6BSatbqCXYa2KPCYXA50jz8MrdEFSTvFz/QpqUI
         uNTVMS2iqVrvqcBbYL0WVUPUJrLvAz2AgQLDPx6h8pGoqaIYuaHh065nrW5g0cRwPj0C
         1lpxirOosgYPvNhl64z6KlkMNdi0ayGUXmBe0jgC0XP31zImEyppp079KkZBWdJjQ+Ui
         inww==
X-Gm-Message-State: AOAM533HrEFUwnSzPwcQAzJ/pIyTiCE1eLusOCsZ5FPN08mH9U99OqrV
        eGDmQZCm6Lp61LlYtSVMIMWTVfuSgSK4Cs5w3M0PVicR7V2JlMDhb4/SsNz/bWKVWvCWpufqENI
        ynLf5XLCJkz7Y5C8n70airA==
X-Received: by 2002:a63:4b4c:: with SMTP id k12mr27929660pgl.172.1632229691671;
        Tue, 21 Sep 2021 06:08:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzGVnnMp30wbAIL26xx5VXyXDL3P8I5NbX637VS3jUHjMYzUPUWs+fA5XMkohHEkLd3oEG9g==
X-Received: by 2002:a63:4b4c:: with SMTP id k12mr27929640pgl.172.1632229691479;
        Tue, 21 Sep 2021 06:08:11 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id w5sm18473890pgp.79.2021.09.21.06.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:08:10 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 4/4] ceph: use tracked average r/w/m latencies to display metrics in debugfs
Date:   Tue, 21 Sep 2021 18:37:50 +0530
Message-Id: <20210921130750.31820-5-vshankar@redhat.com>
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
 fs/ceph/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 38b78b45811f..f6972853dc48 100644
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
 	sq = m->read_latency_sq_sum;
@@ -182,7 +182,7 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_lock(&m->write_metric_lock);
 	total = m->total_writes;
 	sum = m->write_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = m->avg_write_latency;
 	min = m->write_latency_min;
 	max = m->write_latency_max;
 	sq = m->write_latency_sq_sum;
@@ -192,7 +192,7 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_lock(&m->metadata_metric_lock);
 	total = m->total_metadatas;
 	sum = m->metadata_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = m->avg_metadata_latency;
 	min = m->metadata_latency_min;
 	max = m->metadata_latency_max;
 	sq = m->metadata_latency_sq_sum;
-- 
2.31.1

