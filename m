Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDECF834
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2019 14:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfD3MG3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Apr 2019 08:06:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33701 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727618AbfD3MG2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Apr 2019 08:06:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id z28so1642200pfk.0
        for <ceph-devel@vger.kernel.org>; Tue, 30 Apr 2019 05:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zrSDURlss5SMobfyElySTw+0NiQq4J30x26jpg0Jj6w=;
        b=qgELX0kvrUcqMSlun7SMbqnkd79VkvLMHMrCvkeASpbN/fB+euFGIyJ8EawmitfnhZ
         oTgw/EjpKKQnp2lzX/pVs8h0akwy0DmMnGxBZ6QEhhR8WHh02gb812XNvIN+iDRcQW+T
         lIZdM8jyirzbfA4ZIU6Age+WpjCxZl5CUpTtN8wFzBFzFjeoNoWIm+Ox0BIxFYiZ2yTl
         MraAKRPBYV99u0Ijzr/oB5/hNpqTd2iHemH8GrGEoudANEkWNVYSgM84GciBeRmQe4yr
         SSER0GWmaT0aByjT+Odm+/aOMaD6n2K40D0ygt1X6/OcePrDdbo4R+YS6g5+lIW4MMDM
         Dx1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zrSDURlss5SMobfyElySTw+0NiQq4J30x26jpg0Jj6w=;
        b=CykVQQfV5vHy6FU7tgPvzJmDk8A/kTl4HLGE9R9JEEkVeyJGw5BVunHB8oqsL/3hRa
         9WUZK0/4OnQKXBRvd7fWNFHo/UOkrdypXBiuYhxAMecrKm3qOj9jX5PrIuaA1+EpaHGA
         pTxpulRWMgc3IriJLzAa9xgP3ht36DptgaiJ6lj3PDMnn1OP0iRNtsVT4nUNjQksxZfO
         kzR7EkIBR2M2Yb2UybSDZiS9aUiGiwu6MldbzVY18Zu+p1dlKSIQR3c3vMy5gRFKC9N+
         Qs/WP8azuUfxMsAgj0kW7RcOow08P6UPNwwg/RpqFfmxuZwf+otnj9aod4Ez+/OW7gkM
         K8ow==
X-Gm-Message-State: APjAAAWE3pBldSGfMBUQoWpa3QawHm+pJ2Wd+UcuxIOfJLYv8CHLu4N3
        sG1K4oywWPuZawL+nY9SQECjxf0P
X-Google-Smtp-Source: APXvYqzXdnMj2wIdQ2PpdypUIKZAd2UYvQee0jsJl4vqXiLJEbmhFTm8Av2RSNhcwA8cMk+T3Q92KA==
X-Received: by 2002:a65:430a:: with SMTP id j10mr14899280pgq.143.1556625986728;
        Tue, 30 Apr 2019 05:06:26 -0700 (PDT)
Received: from xxh01v.add.shbt.qihoo.net ([180.163.220.95])
        by smtp.gmail.com with ESMTPSA id n67sm4005786pfn.22.2019.04.30.05.06.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Apr 2019 05:06:25 -0700 (PDT)
From:   xxhdx1985126@gmail.com
To:     ceph-devel@vger.kernel.org, ukernel@gmail.com
Cc:     Xuehan Xu <xuxuehan@360.cn>
Subject: [PATCH 1/2] cgroup: add a new group controller for cephfs
Date:   Tue, 30 Apr 2019 12:05:33 +0000
Message-Id: <20190430120534.5231-1-xxhdx1985126@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xuehan Xu <xuxuehan@360.cn>

this controller is supposed to limit the metadata
ops or data ops issued to the underlying cluster.

Signed-off-by: Xuehan Xu <xuxuehan@360.cn>
---
 include/linux/cgroup_cephfs.h |  57 +++++
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |   5 +
 kernel/cgroup/Makefile        |   1 +
 kernel/cgroup/cephfs.c        | 398 ++++++++++++++++++++++++++++++++++
 5 files changed, 465 insertions(+)
 create mode 100644 include/linux/cgroup_cephfs.h
 create mode 100644 kernel/cgroup/cephfs.c

diff --git a/include/linux/cgroup_cephfs.h b/include/linux/cgroup_cephfs.h
new file mode 100644
index 000000000000..91809862b8f8
--- /dev/null
+++ b/include/linux/cgroup_cephfs.h
@@ -0,0 +1,57 @@
+#ifndef _CEPHFS_CGROUP_H
+#define _CEPHFS_CGROUP_H
+
+#include <linux/cgroup.h>
+
+#define META_OPS_IOPS_IDX 0
+#define DATA_OPS_IOPS_IDX 0
+#define DATA_OPS_BAND_IDX 1
+#define META_OPS_TB_NUM 1
+#define DATA_OPS_TB_NUM 2
+
+/*
+ * token bucket throttle
+ */
+struct token_bucket {
+    u64 remain;
+    u64 max;
+    u64 target_throughput;
+};
+
+struct token_bucket_throttle {
+    struct token_bucket* tb;
+    u64 tick_interval;
+    int tb_num;
+    struct list_head reqs_blocked;
+    struct mutex bucket_lock;
+    struct delayed_work tick_work;
+    unsigned long tbt_timeout;
+};
+
+struct queue_item {
+    struct list_head token_bucket_throttle_item;
+    u64* tokens_requested;
+    int tb_item_num;
+    struct completion throttled;
+    unsigned long tbt_timeout;
+};
+
+struct cephfscg {
+    struct cgroup_subsys_state  css;
+    spinlock_t          lock;
+
+    struct token_bucket_throttle meta_ops_throttle;
+    struct token_bucket_throttle data_ops_throttle;
+};
+
+extern void schedule_token_bucket_throttle_tick(struct token_bucket_throttle* ptbt, u64 tick_interval);
+
+extern void token_bucket_throttle_tick(struct work_struct* work);
+
+extern int get_token_bucket_throttle(struct token_bucket_throttle* ptbt, struct queue_item* req);
+
+extern int queue_item_init(struct queue_item* qitem, struct token_bucket_throttle* ptbt, int tb_item_num);
+
+extern int token_bucket_throttle_init(struct token_bucket_throttle* ptbt, int token_bucket_num);
+
+#endif /*_CEPHFS_CGROUP_H*/
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index acb77dcff3b4..577a276570a5 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -61,6 +61,10 @@ SUBSYS(pids)
 SUBSYS(rdma)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_CEPH_FS)
+SUBSYS(cephfs)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/init/Kconfig b/init/Kconfig
index 4592bf7997c0..e22f3aea9e23 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -867,6 +867,11 @@ config CGROUP_RDMA
 	  Attaching processes with active RDMA resources to the cgroup
 	  hierarchy is allowed even if can cross the hierarchy's limit.
 
+config CGROUP_CEPH_FS
+    bool "cephfs controller"
+    help
+        cephfs cgroup controller
+
 config CGROUP_FREEZER
 	bool "Freezer controller"
 	help
diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index bfcdae896122..aaf836181f1a 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_CGROUP_PIDS) += pids.o
 obj-$(CONFIG_CGROUP_RDMA) += rdma.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_DEBUG) += debug.o
+obj-$(CONFIG_CGROUP_CEPH_FS) += cephfs.o
diff --git a/kernel/cgroup/cephfs.c b/kernel/cgroup/cephfs.c
new file mode 100644
index 000000000000..65b9e9618a5d
--- /dev/null
+++ b/kernel/cgroup/cephfs.c
@@ -0,0 +1,398 @@
+#include <linux/cgroup_cephfs.h>
+#include <linux/slab.h>
+
+struct cephfscg cephfscg_root;
+
+static void put_token(struct token_bucket_throttle* ptbt, u64 tick_interval)
+{
+    struct token_bucket* ptb = NULL;
+    u64 tokens_to_put = 0;
+    int i = 0;
+
+    for (i = 0; i < ptbt->tb_num; i++) {
+        ptb = &ptbt->tb[i];
+        
+        if (!ptb->max)
+            continue;
+
+        tokens_to_put = ptb->target_throughput * tick_interval / HZ;
+
+        if (ptb->remain + tokens_to_put >= ptb->max)
+            ptb->remain = ptb->max;
+        else
+            ptb->remain += tokens_to_put;
+        pr_debug("%s: put_token: token bucket remain: %lld\n", __func__, ptb->remain);
+    }
+}
+
+static bool should_wait(struct token_bucket_throttle* ptbt, struct queue_item* qitem)
+{
+    struct token_bucket* ptb = NULL;
+    int i = 0;
+
+    BUG_ON(ptbt->tb_num != qitem->tb_item_num);
+    for (i = 0; i < ptbt->tb_num; i++) {
+        ptb = &ptbt->tb[i];
+
+        if (!ptb->max)
+            continue;
+
+        if (ptb->remain < qitem->tokens_requested[i])
+            return true;
+    }
+    return false;
+}
+
+static void get_token(struct token_bucket_throttle* ptbt, struct queue_item* qitem)
+{
+    struct token_bucket* ptb = NULL;
+    int i = 0;
+    BUG_ON(should_wait(ptbt, qitem));
+
+    for (i = 0; i < ptbt->tb_num; i++) {
+        ptb = &ptbt->tb[i];
+        if (!ptb->max)
+            continue;
+        ptb->remain -= qitem->tokens_requested[i];
+    }
+}
+
+void schedule_token_bucket_throttle_tick(struct token_bucket_throttle* ptbt, u64 tick_interval)
+{
+    if (tick_interval)
+        schedule_delayed_work(&ptbt->tick_work, tick_interval);
+}
+EXPORT_SYMBOL(schedule_token_bucket_throttle_tick);
+
+void token_bucket_throttle_tick(struct work_struct* work)
+{
+    struct token_bucket_throttle* ptbt = 
+        container_of(work, struct token_bucket_throttle, tick_work.work);
+    struct queue_item* req = NULL, *tmp = NULL;
+    LIST_HEAD(reqs_to_go);
+    u64 tick_interval = ptbt->tick_interval;
+
+    mutex_lock(&ptbt->bucket_lock);
+    put_token(ptbt, tick_interval);
+    if (!tick_interval)
+        pr_debug("%s: tick_interval set to 0, turning off the throttle, item: %p\n", __func__, req);
+
+    list_for_each_entry_safe(req, tmp, &ptbt->reqs_blocked, token_bucket_throttle_item) {
+        pr_debug("%s: waiting item: %p\n", __func__, req);
+        if (tick_interval) {
+            if (should_wait(ptbt, req))
+                break;
+            get_token(ptbt, req);
+        }
+        list_del(&req->token_bucket_throttle_item);
+        list_add_tail(&req->token_bucket_throttle_item, &reqs_to_go);
+        pr_debug("%s: tokens got for req: %p\n", __func__, req);
+    }
+    mutex_unlock(&ptbt->bucket_lock);
+
+    list_for_each_entry_safe(req, tmp, &reqs_to_go, token_bucket_throttle_item) {
+        pr_debug("%s: notifying req: %p, list head: %p\n", __func__, req, &reqs_to_go);
+        complete_all(&req->throttled);
+        list_del(&req->token_bucket_throttle_item);
+    }
+
+    if (tick_interval)
+        schedule_token_bucket_throttle_tick(ptbt, tick_interval);
+}
+EXPORT_SYMBOL(token_bucket_throttle_tick);
+
+int get_token_bucket_throttle(struct token_bucket_throttle* ptbt, struct queue_item* req)
+{
+    int ret = 0;
+    long timeleft = 0;
+
+    mutex_lock(&ptbt->bucket_lock);
+    if (should_wait(ptbt, req)) {
+        pr_debug("%s: wait for tokens, req: %p\n", __func__, req);
+        list_add_tail(&req->token_bucket_throttle_item, &ptbt->reqs_blocked);
+        mutex_unlock(&ptbt->bucket_lock);
+        timeleft = wait_for_completion_killable_timeout(&req->throttled, req->tbt_timeout ?: MAX_SCHEDULE_TIMEOUT);
+        if (timeleft > 0) 
+            ret = 0;
+        else if (!timeleft)
+            ret = -EIO; /* timed out */
+        else {
+            /* killed */
+            pr_debug("%s: killed, req: %p\n", __func__, req);
+            mutex_lock(&ptbt->bucket_lock);
+            list_del(&req->token_bucket_throttle_item);
+            mutex_unlock(&ptbt->bucket_lock);
+            ret = timeleft;
+        }
+    } else {
+        pr_debug("%s: no need to wait for tokens, going ahead, req: %p\n", __func__, req);
+        get_token(ptbt, req);                                                                
+        mutex_unlock(&ptbt->bucket_lock);
+    }
+    return ret;
+}
+EXPORT_SYMBOL(get_token_bucket_throttle);
+
+int queue_item_init(struct queue_item* qitem, struct token_bucket_throttle* ptbt, int tb_item_num)
+{
+    qitem->tokens_requested = kzalloc(sizeof(*qitem->tokens_requested) * tb_item_num, GFP_KERNEL);
+    if (!qitem->tokens_requested)
+        return -ENOMEM;
+
+    qitem->tb_item_num = tb_item_num;
+    INIT_LIST_HEAD(&qitem->token_bucket_throttle_item);
+    init_completion(&qitem->throttled);
+    qitem->tbt_timeout = ptbt->tbt_timeout;
+
+    return 0;
+}
+EXPORT_SYMBOL(queue_item_init);
+
+int token_bucket_throttle_init(struct token_bucket_throttle* ptbt,
+        int token_bucket_num)
+{
+    int i = 0;
+
+    INIT_LIST_HEAD(&ptbt->reqs_blocked);
+    mutex_init(&ptbt->bucket_lock);
+    ptbt->tb_num = token_bucket_num;
+    ptbt->tb = kzalloc(sizeof(*ptbt->tb) * ptbt->tb_num, GFP_KERNEL);
+    if (!ptbt->tb) {
+        return -ENOMEM;
+    }
+
+    for (i = 0; i < ptbt->tb_num; i++) {
+        ptbt->tb[i].target_throughput = 0;
+        ptbt->tb[i].max = 0;
+    }
+    ptbt->tick_interval = 0;
+    ptbt->tbt_timeout = 0;
+    INIT_DELAYED_WORK(&ptbt->tick_work, token_bucket_throttle_tick);
+
+    return 0;
+}
+EXPORT_SYMBOL(token_bucket_throttle_init);
+
+static int set_throttle_params(struct token_bucket_throttle* ptbt, char* param_list)
+{
+    char* options = strstrip(param_list);
+    char* val = NULL;
+    int res = 0;
+    unsigned long interval = 0, timeout = 0, last_interval = ptbt->tick_interval;
+
+    val = strsep(&options, ",");
+    if (!val)
+        return -EINVAL;
+
+    res = kstrtol(val, 0, &interval);
+    if (res)
+        return res;
+
+    val = strsep(&options, ",");
+    if (!val)
+        return -EINVAL;
+
+    res = kstrtol(val, 0, &timeout);
+    if (res)
+        return res;
+
+    if (last_interval && !interval) {
+        int i = 0;
+
+        for (i = 0; i<ptbt->tb_num; i++) {
+            if (ptbt->tb[i].max) {
+                /* all token bucket must be unset
+                 * before turning off the throttle */
+                return -EINVAL;
+            }
+        }
+    }
+    ptbt->tick_interval = msecs_to_jiffies(interval);
+    ptbt->tbt_timeout = timeout;
+
+    if (ptbt->tick_interval && !last_interval) {
+        schedule_token_bucket_throttle_tick(ptbt, ptbt->tick_interval);
+    }
+
+    return 0;
+}
+
+static int set_tb_params(struct token_bucket_throttle* ptbt, int tb_idx, char* param_list)
+{
+    char* options = strstrip(param_list);
+    char* val = NULL;
+    int res = 0;
+    unsigned long throughput = 0, burst = 0;
+
+    val = strsep(&options, ",");
+    if (!val)
+        return -EINVAL;
+
+    res = kstrtol(val, 0, &throughput);
+    if (res)
+        return res;
+
+    val = strsep(&options, ",");
+    if (!val)
+        return -EINVAL;
+
+    res = kstrtol(val, 0, &burst);
+    if (res)
+        return res;
+
+    if (!(throughput && burst) && (throughput || burst)) {
+        /* either both or none of throughput and burst are set*/
+        return -EINVAL;
+    }
+    if (throughput && !ptbt->tick_interval) {
+        /* all token bucket must be unset
+         * before turning off the throttle */
+        return -EINVAL;
+    }
+    ptbt->tb[tb_idx].target_throughput = throughput;
+    ptbt->tb[tb_idx].max = burst;
+
+    return 0;
+}
+
+static ssize_t cephfscg_set_throttle_params(struct kernfs_open_file *of,
+        char *buf, size_t nbytes, loff_t off)
+{
+    const char *throttle_name;
+    int ret = 0;
+    struct cephfscg* cephfscg_p =
+        container_of(seq_css(of->seq_file), struct cephfscg, css);
+
+    throttle_name = of->kn->name;
+    if (!strcmp(throttle_name, "cephfs.meta_ops")) {
+        ret = set_throttle_params(&cephfscg_p->meta_ops_throttle, buf);
+    } else if (!strcmp(throttle_name, "cephfs.data_ops")) {
+        ret = set_throttle_params(&cephfscg_p->data_ops_throttle, buf);
+    } else if (!strcmp(throttle_name, "cephfs.meta_ops.iops")) {
+        ret = set_tb_params(&cephfscg_p->meta_ops_throttle, META_OPS_IOPS_IDX, buf);
+    } else if (!strcmp(throttle_name, "cephfs.data_ops.iops")) {
+        ret = set_tb_params(&cephfscg_p->data_ops_throttle, DATA_OPS_IOPS_IDX, buf);
+    } else if (!strcmp(throttle_name, "cephfs.data_ops.band")) {
+        ret = set_tb_params(&cephfscg_p->data_ops_throttle, DATA_OPS_BAND_IDX, buf);
+    }
+
+    return ret ?: nbytes;
+}
+
+static int cephfscg_throttle_params_read(struct seq_file *sf, void *v)
+{
+    const char *throttle_name;
+    struct cephfscg* cephfscg_p =
+        container_of(seq_css(sf), struct cephfscg, css);
+   
+    throttle_name = ((struct kernfs_open_file*)sf->private)->kn->name;
+    if (!strcmp(throttle_name, "cephfs.meta_ops")) {
+        seq_printf(sf, "%llu,%lu\n",
+                cephfscg_p->meta_ops_throttle.tick_interval,
+                cephfscg_p->meta_ops_throttle.tbt_timeout);
+    } else if (!strcmp(throttle_name, "cephfs.data_ops")) {
+        seq_printf(sf, "%llu,%lu\n",
+                cephfscg_p->data_ops_throttle.tick_interval,
+                cephfscg_p->data_ops_throttle.tbt_timeout);
+    } else if (!strcmp(throttle_name, "cephfs.data_ops.iops")) {
+        seq_printf(sf, "%llu,%llu\n",
+                cephfscg_p->data_ops_throttle.tb[DATA_OPS_IOPS_IDX].target_throughput,
+                cephfscg_p->data_ops_throttle.tb[DATA_OPS_IOPS_IDX].max);
+    } else if (!strcmp(throttle_name, "cephfs.data_ops.band")) {
+        seq_printf(sf, "%llu,%llu\n",
+                cephfscg_p->data_ops_throttle.tb[DATA_OPS_BAND_IDX].target_throughput,
+                cephfscg_p->data_ops_throttle.tb[DATA_OPS_BAND_IDX].max);
+    } else if (!strcmp(throttle_name, "cephfs.meta_ops.iops")) {
+        seq_printf(sf, "%llu,%llu\n",
+                cephfscg_p->meta_ops_throttle.tb[META_OPS_IOPS_IDX].target_throughput,
+                cephfscg_p->meta_ops_throttle.tb[META_OPS_IOPS_IDX].max);
+    }
+    
+    return 0;
+}
+
+static struct cftype cephfscg_files[] = {
+    {
+        .name = "meta_ops.iops",
+        .write = cephfscg_set_throttle_params,
+        .seq_show = cephfscg_throttle_params_read,
+    },
+    {
+        .name = "meta_ops",
+        .write = cephfscg_set_throttle_params,
+        .seq_show = cephfscg_throttle_params_read,
+    },
+    {
+        .name = "data_ops.iops",
+        .write = cephfscg_set_throttle_params,
+        .seq_show = cephfscg_throttle_params_read,
+    },
+    {
+        .name = "data_ops.band",
+        .write = cephfscg_set_throttle_params,
+        .seq_show = cephfscg_throttle_params_read,
+    },
+    {
+        .name = "data_ops",
+        .write = cephfscg_set_throttle_params,
+        .seq_show = cephfscg_throttle_params_read,
+    },
+    { }
+};
+
+static struct cgroup_subsys_state *
+cephfscg_css_alloc(struct cgroup_subsys_state *parent_css) {
+
+    struct cephfscg* cephfscg_p = NULL;
+    struct cgroup_subsys_state *ret = NULL;
+    int r = 0;
+
+    if (!parent_css) {
+        cephfscg_p = &cephfscg_root;
+    } else {
+        cephfscg_p = kzalloc(sizeof(*cephfscg_p), GFP_KERNEL);
+        if (!cephfscg_p) {
+            ret = ERR_PTR(-ENOMEM);
+            goto err;
+        }
+    }
+
+    spin_lock_init(&cephfscg_p->lock);
+
+    r = token_bucket_throttle_init(&cephfscg_p->meta_ops_throttle, 1);
+    if (r) {
+        ret = ERR_PTR(r);
+        goto err;
+    }
+
+    r = token_bucket_throttle_init(&cephfscg_p->data_ops_throttle, 2);
+    if (r) {
+        ret = ERR_PTR(r);
+        goto err;
+    }
+
+    return &cephfscg_p->css;
+err:
+    return ret;
+}
+
+static void cephfscg_css_free(struct cgroup_subsys_state *css) {
+    struct cephfscg* cephfscg_p = 
+        css ? container_of(css, struct cephfscg, css) : NULL;
+
+    cancel_delayed_work_sync(&cephfscg_p->meta_ops_throttle.tick_work);
+    cancel_delayed_work_sync(&cephfscg_p->data_ops_throttle.tick_work);
+
+    kfree(cephfscg_p->meta_ops_throttle.tb);
+    kfree(cephfscg_p->data_ops_throttle.tb);
+
+    kfree(cephfscg_p);
+}
+
+struct cgroup_subsys cephfs_cgrp_subsys = {
+    .css_alloc = cephfscg_css_alloc,
+    .css_free = cephfscg_css_free,
+    .dfl_cftypes = cephfscg_files,
+    .legacy_cftypes = cephfscg_files,
+};
+EXPORT_SYMBOL_GPL(cephfs_cgrp_subsys);
-- 
2.20.1

