Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8974D1820
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 13:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240569AbiCHMnp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 07:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241126AbiCHMno (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 07:43:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32DC11E3EE
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 04:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646743366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WotjeOfBoLZmaV1cNxMIZ0cNLzdyzUIuJOrPCewLsIw=;
        b=NuoyWWcvJ1AQQnfzAXGwWWS/QFEesAy2v73XSheiKrZoEetKqS7wNj+MM4HL/frSgmNz89
        FbqmOu4y5Kml0EJD0cjdfigv0Iv5sTy/QhHe/5+ivoJILFu4wLDd0fir//8OBPlSfJ/yZy
        jDIfkr5VMnuZlbhX+GwcPVHDo9gOUQA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-3LACKSI9OMOn9IhMMdxgSg-1; Tue, 08 Mar 2022 07:42:44 -0500
X-MC-Unique: 3LACKSI9OMOn9IhMMdxgSg-1
Received: by mail-pl1-f199.google.com with SMTP id e7-20020a170902ef4700b00151de30039bso3563916plx.17
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 04:42:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WotjeOfBoLZmaV1cNxMIZ0cNLzdyzUIuJOrPCewLsIw=;
        b=06X2XJOyXuSJYqWzeu4cfZ3jmPHoLR+C+2bEPFKnK9zi2lkIdQNydrplt6E6COV8SC
         KdhJ9n1HSLQ/BFWsiI9iU0UphsJSOZpisMbqCvJn5xRu9hd4vKd6MBzPLCNXfUfYC9mG
         ZipTE7RPFyVHuXaK1kmfyq7VTkRKZTR3VIFOHW27DEtrhboQTo+U3HKhKFiseMvIj2kZ
         VND2CUD0T7Kufa9RXZv1JD7f+HwKIfncF97MYQtTcRv4DvBus3W7ZIIzSYmEi4aItG+M
         p0HhoUx/p92EJgB1NkYPkyfnDW58Vr3GWUrA966qavFb71yTkyRr0hhQtwnF9Q09OaGZ
         y0XQ==
X-Gm-Message-State: AOAM533XAEbjfsd6lR2dWxvD9yMXD74yQg6zxIGW37rQx5QNXd0FuTy2
        /IUh75z3KM9pUu4fsguQJnHawNQD49UtqLwab/IQ1Uu9J/LSd0VUpnluS9vY/emZreOeJKVcvqz
        JIP344s+iD6tl3j4g6CeXxA==
X-Received: by 2002:a05:6a00:2166:b0:4f6:67fe:a336 with SMTP id r6-20020a056a00216600b004f667fea336mr18095908pff.17.1646743363379;
        Tue, 08 Mar 2022 04:42:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQLasYQ22pf7bcJBD2sIhD0nEWseu4HYIylhfXjoT83xjIAxbeHdkCnA1qYp6l8OH3HXwcgA==
X-Received: by 2002:a05:6a00:2166:b0:4f6:67fe:a336 with SMTP id r6-20020a056a00216600b004f667fea336mr18095892pff.17.1646743363146;
        Tue, 08 Mar 2022 04:42:43 -0800 (PST)
Received: from localhost.localdomain ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id o185-20020a6341c2000000b0036fb987b25fsm15344959pga.38.2022.03.08.04.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 04:42:42 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 4/4] ceph: use tracked average r/w/m latencies to display metrics in debugfs
Date:   Tue,  8 Mar 2022 07:42:19 -0500
Message-Id: <20220308124219.771527-5-vshankar@redhat.com>
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

[ jlayton: remove now-unused "sum" variable ]

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/debugfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 3cf7c9c1085b..bec3c4549c07 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -175,7 +175,7 @@ static int metrics_latency_show(struct seq_file *s, void *p)
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_client_metric *cm = &fsc->mdsc->metric;
 	struct ceph_metric *m;
-	s64 total, sum, avg, min, max, sq;
+	s64 total, avg, min, max, sq;
 	int i;
 
 	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
@@ -185,8 +185,7 @@ static int metrics_latency_show(struct seq_file *s, void *p)
 		m = &cm->metric[i];
 		spin_lock(&m->lock);
 		total = m->total;
-		sum = m->latency_sum;
-		avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+		avg = m->latency_avg;
 		min = m->latency_min;
 		max = m->latency_max;
 		sq = m->latency_sq_sum;
-- 
2.31.1

