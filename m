Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989474B674B
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 10:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiBOJR2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 04:17:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235756AbiBOJR1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 04:17:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A625AE6F
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 01:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644916637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l2r1jag2B8h4t60u9CLI6iIx/Tf0zjMI4sQzIQznIOc=;
        b=Psh51opM3HYZO84qGTUkCLYooewneQBIcWewPlxSxAqfXpZZYaG6BimCaKcJtLve50b5TD
        nuisbX9mzZYd3Qt8vj3UIQ98K6flOG8koIcnYFh1VmdhHT7c4FdO69UvhpMZLJHQlQcpCE
        8SIDT6Z1afce9UcPlxbJd7O6rhIrOTo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-OgJk7zinOyqvGvdxxyKaQQ-1; Tue, 15 Feb 2022 04:17:16 -0500
X-MC-Unique: OgJk7zinOyqvGvdxxyKaQQ-1
Received: by mail-pj1-f71.google.com with SMTP id 62-20020a17090a09c400b001b80b0742b0so12714017pjo.8
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 01:17:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2r1jag2B8h4t60u9CLI6iIx/Tf0zjMI4sQzIQznIOc=;
        b=OZnhrI+1B11lYKlLk5E7tTZqHUhsMHDDq2hSWRj1attlAg2prMM4ZDZ2X+Svqp1n3m
         YR20gU8RmdxLAV6K704gHZ59mkrtDhs+KmP/0aLE6/NJ6sYclMoQcdKJMkrM3GblKOX9
         0GkacidxAdydciXc7KXlUsuRtIOWd3i9fUmbwjgmNOP0CT8/TIK0FWJSpGAUPi7taLwM
         h37rtEzBvLS1SEMtwwIRqCpDwnVFoFaAAFabApq+m5wUcP0BaGlgwzjVbdAWgQSq5xCY
         qXd6bT5weIJm9U/MiHLrmnPoeagTKibkfEwVulKwnGFzMEkO6Y8xEjMnrqNV3i5y0CIC
         ou5A==
X-Gm-Message-State: AOAM533B5dzmDpVcNEDZ8uWBwbqsH5CNZERv9l7EjoV2XpvtssCLP/kq
        IHHLmEyFi0713SCsZx8fCMXGwRrruTRwPTEZ0x1C5n8Tc6QsMU3GKx99WS09HMqci9gqx7sw1g2
        zuafUlR3m7Cy4PIAGsO//dg==
X-Received: by 2002:a17:90b:4d86:b0:1b9:c571:53a0 with SMTP id oj6-20020a17090b4d8600b001b9c57153a0mr3344822pjb.242.1644916634757;
        Tue, 15 Feb 2022 01:17:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJsKDdglWW3zCEKG7G41eYJIjaFmWe3oVFO470/l9BWIiHaqUpmvOLyKYAQNtiAy6qu9MFjg==
X-Received: by 2002:a17:90b:4d86:b0:1b9:c571:53a0 with SMTP id oj6-20020a17090b4d8600b001b9c57153a0mr3344810pjb.242.1644916634511;
        Tue, 15 Feb 2022 01:17:14 -0800 (PST)
Received: from h3ckers-pride.redhat.com ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id kk14sm16569550pjb.26.2022.02.15.01.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 01:17:13 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 3/3] ceph: use tracked average r/w/m latencies to display metrics in debugfs
Date:   Tue, 15 Feb 2022 14:46:57 +0530
Message-Id: <20220215091657.104079-4-vshankar@redhat.com>
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

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 3cf7c9c1085b..acc5cb3ad0ef 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -186,7 +186,7 @@ static int metrics_latency_show(struct seq_file *s, void *p)
 		spin_lock(&m->lock);
 		total = m->total;
 		sum = m->latency_sum;
-		avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+		avg = m->latency_avg;
 		min = m->latency_min;
 		max = m->latency_max;
 		sq = m->latency_sq_sum;
-- 
2.27.0

