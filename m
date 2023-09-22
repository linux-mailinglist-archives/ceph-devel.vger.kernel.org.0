Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5808A7AA900
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Sep 2023 08:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjIVG0c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Sep 2023 02:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjIVG0V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 Sep 2023 02:26:21 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C27194
        for <ceph-devel@vger.kernel.org>; Thu, 21 Sep 2023 23:26:12 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-530fa34ab80so6784833a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 21 Sep 2023 23:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1695363971; x=1695968771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YaYc93wNxc7ZPBHYCHRxs28Q0KfViuylEe4BwwlB5Eg=;
        b=GRR13ilbskS5+BhKvpk3FnXgyZrlJRbLSTasFdq/jqneRS0TJomdlDqCr2Plxf0HeK
         1dwCIH7eWAV6BNGO2nilsT18Qoy0w9imaAXENvhitw8yrosAONVqvJos1A6SGRVwwFer
         95x8fbt+T9XJtPGMhLUJwzixJcfqm2ukZsagG2azpJxclJH348ovC3+rHyjtC7P8cf81
         xO50LzMjoOpkoGquLjzLDveN39cvCc4VsJzK7ePi78DjRcmap6hhDU/8CnrkosuPh7js
         ZMpEPhzKhkpdBIKIu8UIymWhQfruqIJnNX7OHQ8lVgqBxtY28fftn4Y/7YTU4wotncnp
         13WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695363971; x=1695968771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YaYc93wNxc7ZPBHYCHRxs28Q0KfViuylEe4BwwlB5Eg=;
        b=BuELWrzuxyIdOGby/RALraF+EbsCYPWls+YQmAzQmy4XlPdMQSqrroNW75KPCLx3gl
         fN8HZtAM+kmQ+yDlOvUkyhs4HkkZSbo7bOyXNJCnIL6fko3AuJEeIAlHU/1XlphznpKp
         wKe+Xnque7IUXb6hqunLDNdLdSZn3QzLPUQKcNpm53pnt39JpMKcjLtnknwefa5My5re
         40LMNzoEXn/2kswMmaGlCGrcChiXcieH0YKCwNYXoeZhY/BGrvYoW1VkcIb08inLUU7m
         uU+LmnLksuF24K9Wjry6vB6ZdWNdkyNeGrlQ3e/DnCSzR7OlqYDmKVS/1sRYCV3eMpjI
         p/5w==
X-Gm-Message-State: AOJu0YzAFS3mFOfhqMgSq2jcSSs41kQ1o8XjjgjwoXcrqet567U7A2M9
        drfEkStiUi6W4jMhIEVcOVTatQ==
X-Google-Smtp-Source: AGHT+IH/ZRAtCX4gvnW+Ifx1FSie3lGsh+hZ6gwBPATtidaGzO/PZFYW02eV/1/BVLEp9VjCl0mSkQ==
X-Received: by 2002:a17:907:868f:b0:9a5:962c:cb6c with SMTP id qa15-20020a170907868f00b009a5962ccb6cmr2699610ejc.31.1695363971200;
        Thu, 21 Sep 2023 23:26:11 -0700 (PDT)
Received: from heron.intern.cm-ag (p200300dc6f209c00529a4cfffe3dd983.dip0.t-ipconnect.de. [2003:dc:6f20:9c00:529a:4cff:fe3d:d983])
        by smtp.gmail.com with ESMTPSA id gy6-20020a170906f24600b00992afee724bsm2195519ejb.76.2023.09.21.23.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 23:26:10 -0700 (PDT)
From:   Max Kellermann <max.kellermann@ionos.com>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     Max Kellermann <max.kellermann@ionos.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] fs/ceph/debugfs: expose raw metric counters
Date:   Fri, 22 Sep 2023 08:25:58 +0200
Message-Id: <20230922062558.1739642-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230922062558.1739642-1-max.kellermann@ionos.com>
References: <20230922062558.1739642-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

To enable userspace to calculate the current latency, not just the
average latency since the filesystem was mounted.

We have been running this patch for a while on our servers and our
Prometheus exporter collects these statistics:

 https://github.com/CM4all/Prometheus-Exporters/
 https://github.com/CM4all/Prometheus-Exporters/blob/master/src/KernelExporter.cxx

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/debugfs.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 2abee7e18144..d13a1ab8822a 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -170,6 +170,30 @@ static const char * const metric_str[] = {
 	"metadata",
 	"copyfrom"
 };
+
+static int metrics_counters_show(struct seq_file *s, void *p)
+{
+	struct ceph_fs_client *fsc = s->private;
+	struct ceph_client_metric *cm = &fsc->mdsc->metric;
+	u64 count, size_bytes, wait_ns;
+
+	seq_printf(s, "item count size_bytes wait_ns\n");
+
+	for (unsigned i = 0; i < METRIC_MAX; i++) {
+		struct ceph_metric *m = &cm->metric[i];
+		spin_lock(&m->lock);
+		count = m->total;
+		size_bytes = m->size_sum;
+		wait_ns = ktime_to_ns(m->latency_sum);
+		spin_unlock(&m->lock);
+
+		seq_printf(s, "%s %llu %llu %llu\n",
+			   metric_str[i], count, size_bytes, wait_ns);
+	}
+
+	return 0;
+}
+
 static int metrics_latency_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
@@ -368,6 +392,7 @@ DEFINE_SHOW_ATTRIBUTE(caps);
 DEFINE_SHOW_ATTRIBUTE(mds_sessions);
 DEFINE_SHOW_ATTRIBUTE(status);
 DEFINE_SHOW_ATTRIBUTE(metrics_file);
+DEFINE_SHOW_ATTRIBUTE(metrics_counters);
 DEFINE_SHOW_ATTRIBUTE(metrics_latency);
 DEFINE_SHOW_ATTRIBUTE(metrics_size);
 DEFINE_SHOW_ATTRIBUTE(metrics_caps);
@@ -463,6 +488,8 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 
 	debugfs_create_file("file", 0444, fsc->debugfs_metrics_dir, fsc,
 			    &metrics_file_fops);
+	debugfs_create_file("counters", 0444, fsc->debugfs_metrics_dir, fsc,
+			    &metrics_counters_fops);
 	debugfs_create_file("latency", 0444, fsc->debugfs_metrics_dir, fsc,
 			    &metrics_latency_fops);
 	debugfs_create_file("size", 0444, fsc->debugfs_metrics_dir, fsc,
-- 
2.39.2

