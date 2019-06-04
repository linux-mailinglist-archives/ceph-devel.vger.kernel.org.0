Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35636349A8
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 16:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfFDOAx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 10:00:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45669 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfFDOAx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 10:00:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id w34so10398059pga.12
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 07:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aW5oaSrHkmlmk4p8rB+S4+U70XEv//OD4JXazUtbh6M=;
        b=mItkNEF7vwYDQirGD5Ov9Js/owWE1N2pK2gjik7+T28fjUbKGztsFcKA05ZcNdbdCg
         aYFGrvmgX6MBAQIgX3j4S5UZjo1PQgDUmDF4GnwGHXI2x8vfWhnCQ5O/SGMSXuhVLFBj
         7BJDlXKB8B4yre7e72xYtCCgnxFdopOcOG4naAB0OYst/Ew0CoWfql0OtMlpHM0E4Dr3
         79fndmPGdR+N3NzT3S3op2isjz9esYzvX3CEB1O5IOkerrxTgNAaCHo7B5prs9rowTY4
         Avii/48J3oekso+q8RIITh3879AWrcFPt5XopZ2kM+cus+vVfrIh8xVlIOUvpGmkrc4z
         9O4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aW5oaSrHkmlmk4p8rB+S4+U70XEv//OD4JXazUtbh6M=;
        b=TX165KqKr0llWCcmHNkz+/usbHmO+mSFGtvGGFaE0KpLwjf8MmvAxnap8dgsCT5V44
         tACyB3KfliE/h103WU2UyM5JQPZ8ho0ll1ul/XDW/09TeQY5Xyob2LdhcftRcGMTq5Um
         CPk5rf9OY0eKS70kfdhdkLYpLvAySkyQp0zHIi9sk6o3Zc/Mtw/gIi1EEwYsaITT7xMP
         NO5CAxCySKDK7mzE1G47lg0bdnOauoFfv03IkVNZwGDXgqgXQAx1c5ZpNgKMKKbld1GC
         4MGYGZl/ivfI1SybWDdeDvDgxetP816O7uEz/I+ZDanjj01JUf5j8DjQOhIbRAv2NOke
         gxRA==
X-Gm-Message-State: APjAAAXwyYRdr3ONzuRvDduNiyy/Vmsp872RQmSlmsmFo6/5WuMUp+xL
        gm1k2TXlFsmfOmEqXVgeeDQ=
X-Google-Smtp-Source: APXvYqwg+mf03crMS2S7h5DdLjp/SuKWb7X+soFyoGk7zzt9mzfdt8tRKt6powgOy3HDakjsjO289A==
X-Received: by 2002:a65:42ca:: with SMTP id l10mr35006320pgp.181.1559656851959;
        Tue, 04 Jun 2019 07:00:51 -0700 (PDT)
Received: from localhost.localdomain ([104.192.108.10])
        by smtp.gmail.com with ESMTPSA id v23sm19746154pff.185.2019.06.04.07.00.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 07:00:51 -0700 (PDT)
From:   xxhdx1985126@gmail.com
To:     idryomov@gmail.com, ukernel@gmail.com, ceph-devel@vger.kernel.org
Cc:     Xuehan Xu <xuxuehan@360.cn>
Subject: [PATCH 1/2] ceph: add a new blkcg policy for cephfs
Date:   Tue,  4 Jun 2019 21:51:17 +0800
Message-Id: <20190604135119.8109-2-xxhdx1985126@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190604135119.8109-1-xxhdx1985126@gmail.com>
References: <20190604135119.8109-1-xxhdx1985126@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xuehan Xu <xuxuehan@360.cn>

this policy is supposed to facilitate limiting
the metadata ops or data ops issued to the underlying
cluster.

Signed-off-by: Xuehan Xu <xuxuehan@360.cn>
---
 fs/ceph/Kconfig                     |   8 +
 fs/ceph/Makefile                    |   1 +
 fs/ceph/ceph_io_policy.c            | 445 ++++++++++++++++++++++++++++
 include/linux/ceph/ceph_io_policy.h |  74 +++++
 include/linux/ceph/osd_client.h     |   7 +
 net/ceph/ceph_common.c              |  13 +
 6 files changed, 548 insertions(+)
 create mode 100644 fs/ceph/ceph_io_policy.c
 create mode 100644 include/linux/ceph/ceph_io_policy.h

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 7f7d92d6b024..0bbd39a66e11 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -36,3 +36,11 @@ config CEPH_FS_POSIX_ACL
 	  groups beyond the owner/group/world scheme.
 
 	  If you don't know what Access Control Lists are, say N
+
+config CEPH_LIB_IO_POLICY
+	bool "Use the ceph-specific blkcg policy to limit io reqs"
+	depends on CEPH_LIB
+	default n
+	help
+	  If you say Y here, the blkcg policy will be inited when
+	  libceph module is loaded
diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index a699e320393f..bb5d468abc9e 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -12,3 +12,4 @@ ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
 
 ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
 ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
+ceph-$(CONFIG_CEPH_LIB_IO_POLICY) += ceph_io_policy.o
diff --git a/fs/ceph/ceph_io_policy.c b/fs/ceph/ceph_io_policy.c
new file mode 100644
index 000000000000..e7edc07de11a
--- /dev/null
+++ b/fs/ceph/ceph_io_policy.c
@@ -0,0 +1,445 @@
+#include <linux/ceph/ceph_io_policy.h>
+#include <linux/slab.h>
+
+enum {
+	CEPH_MDS_META_OPS,
+	CEPH_MDS_META_OPS_IOPS,
+	CEPH_OSD_DATA_OPS,
+	CEPH_OSD_DATA_OPS_IOPS,
+	CEPH_OSD_DATA_OPS_BANDWIDTH,
+};
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
+        list_del_init(&req->token_bucket_throttle_item);
+        list_add_tail(&req->token_bucket_throttle_item, &reqs_to_go);
+        pr_debug("%s: tokens got for req: %p\n", __func__, req);
+    }
+    mutex_unlock(&ptbt->bucket_lock);
+
+    list_for_each_entry_safe(req, tmp, &reqs_to_go, token_bucket_throttle_item) {
+        pr_debug("%s: notifying req: %p, list head: %p\n", __func__, req, &reqs_to_go);
+        complete_all(&req->throttled);
+        list_del_init(&req->token_bucket_throttle_item);
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
+        else {
+		if (!timeleft)
+			ret = -EIO; /* timed out */
+		else {
+			/* killed */
+			pr_debug("%s: killed, req: %p\n", __func__, req);
+			ret = timeleft;
+		}
+		mutex_lock(&ptbt->bucket_lock);
+		if (!list_empty(&req->token_bucket_throttle_item))
+			list_del_init(&req->token_bucket_throttle_item);
+		mutex_unlock(&ptbt->bucket_lock);
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
+void queue_item_free(struct queue_item* qitem)
+{
+	kfree(qitem->tokens_requested);
+}
+EXPORT_SYMBOL(queue_item_free);
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
+static ssize_t ceph_set_throttle_params(struct kernfs_open_file *of,
+        char *buf, size_t nbytes, loff_t off)
+{
+	int ret = 0;
+	struct blkcg* blkcg = css_to_blkcg(of_css(of));
+	struct ceph_group_data* cephgd_p = blkcg_to_cephgd(blkcg);
+	int index = of_cft(of)->private;
+
+	switch (index) {
+	case CEPH_MDS_META_OPS:
+		ret = set_throttle_params(&cephgd_p->meta_ops_throttle, buf);
+		break;
+	case CEPH_OSD_DATA_OPS:
+		ret = set_throttle_params(&cephgd_p->data_ops_throttle, buf);
+		break;
+	case CEPH_MDS_META_OPS_IOPS:
+		ret = set_tb_params(&cephgd_p->meta_ops_throttle,
+				    META_OPS_IOPS_IDX, buf);
+		break;
+	case CEPH_OSD_DATA_OPS_IOPS:
+		ret = set_tb_params(&cephgd_p->data_ops_throttle,
+				    DATA_OPS_IOPS_IDX, buf);
+		break;
+	case CEPH_OSD_DATA_OPS_BANDWIDTH:
+		ret = set_tb_params(&cephgd_p->data_ops_throttle,
+				    DATA_OPS_BAND_IDX, buf);
+		break;
+	default:
+		BUG();
+	}
+
+	return ret ?: nbytes;
+}
+
+static int ceph_throttle_params_read(struct seq_file *sf, void *v)
+{
+	struct blkcg* blkcg = css_to_blkcg(seq_css(sf));
+	struct ceph_group_data* cephgd_p = blkcg_to_cephgd(blkcg);
+	int index = seq_cft(sf)->private;
+
+	switch (index) {
+	case CEPH_MDS_META_OPS:
+		seq_printf(sf, "%llu,%lu\n",
+			   cephgd_p->meta_ops_throttle.tick_interval,
+			   cephgd_p->meta_ops_throttle.tbt_timeout);
+		break;
+	case CEPH_OSD_DATA_OPS:
+		seq_printf(sf, "%llu,%lu\n",
+			   cephgd_p->data_ops_throttle.tick_interval,
+			   cephgd_p->data_ops_throttle.tbt_timeout);
+		break;
+	case CEPH_MDS_META_OPS_IOPS:
+		seq_printf(sf, "%llu,%llu\n",
+			   cephgd_p->meta_ops_throttle.tb[META_OPS_IOPS_IDX].target_throughput,
+			   cephgd_p->meta_ops_throttle.tb[META_OPS_IOPS_IDX].max);
+		break;
+	case CEPH_OSD_DATA_OPS_IOPS:
+		seq_printf(sf, "%llu,%llu\n",
+			   cephgd_p->data_ops_throttle.tb[DATA_OPS_IOPS_IDX].target_throughput,
+			   cephgd_p->data_ops_throttle.tb[DATA_OPS_IOPS_IDX].max);
+		break;
+	case CEPH_OSD_DATA_OPS_BANDWIDTH:
+		seq_printf(sf, "%llu,%llu\n",
+			   cephgd_p->data_ops_throttle.tb[DATA_OPS_BAND_IDX].target_throughput,
+			   cephgd_p->data_ops_throttle.tb[DATA_OPS_BAND_IDX].max);
+		break;
+	default:
+		BUG();
+	}
+
+	return 0;
+}
+
+static struct cftype cephgd_files[] = {
+    {
+        .name = "cephfs_meta_ops.iops",
+        .write = ceph_set_throttle_params,
+        .seq_show = ceph_throttle_params_read,
+	.private = CEPH_MDS_META_OPS_IOPS,
+    },
+    {
+        .name = "cephfs_meta_ops",
+        .write = ceph_set_throttle_params,
+        .seq_show = ceph_throttle_params_read,
+	.private = CEPH_MDS_META_OPS,
+    },
+    {
+        .name = "cephfs_data_ops.iops",
+        .write = ceph_set_throttle_params,
+        .seq_show = ceph_throttle_params_read,
+	.private = CEPH_OSD_DATA_OPS_IOPS,
+    },
+    {
+        .name = "cephfs_data_ops.bandwidth",
+        .write = ceph_set_throttle_params,
+        .seq_show = ceph_throttle_params_read,
+	.private = CEPH_OSD_DATA_OPS_BANDWIDTH,
+    },
+    {
+        .name = "cephfs_data_ops",
+        .write = ceph_set_throttle_params,
+        .seq_show = ceph_throttle_params_read,
+	.private = CEPH_OSD_DATA_OPS,
+    },
+    { }
+};
+
+static struct blkcg_policy_data * ceph_cpd_alloc(gfp_t gfp) {
+
+    struct ceph_group_data* cephgd_p = NULL;
+    struct blkcg_policy_data *ret = NULL;
+    int r = 0;
+
+    cephgd_p = kzalloc(sizeof(*cephgd_p), gfp);
+    if (!cephgd_p) {
+	    ret = ERR_PTR(-ENOMEM);
+	    goto err;
+    }
+
+    r = token_bucket_throttle_init(&cephgd_p->meta_ops_throttle,
+				   META_OPS_TB_NUM);
+    if (r) {
+        ret = ERR_PTR(r);
+        goto err;
+    }
+
+    r = token_bucket_throttle_init(&cephgd_p->data_ops_throttle,
+				   DATA_OPS_TB_NUM);
+    if (r) {
+        ret = ERR_PTR(r);
+        goto err;
+    }
+
+    return &cephgd_p->cpd;
+err:
+    return ret;
+}
+
+static void ceph_cpd_init(struct blkcg_policy_data *cpd) {
+}
+
+static void ceph_cpd_free(struct blkcg_policy_data *cpd) {
+    struct ceph_group_data* cephgd_p = cpd_to_cephgd(cpd);
+
+    cancel_delayed_work_sync(&cephgd_p->meta_ops_throttle.tick_work);
+    cancel_delayed_work_sync(&cephgd_p->data_ops_throttle.tick_work);
+
+    kfree(cephgd_p->meta_ops_throttle.tb);
+    kfree(cephgd_p->data_ops_throttle.tb);
+
+    kfree(cephgd_p);
+}
+
+struct blkcg_policy io_policy_ceph = {
+	.dfl_cftypes = cephgd_files,
+
+	.cpd_alloc_fn = ceph_cpd_alloc,
+	.cpd_init_fn = ceph_cpd_init,
+	.cpd_free_fn = ceph_cpd_free,
+};
+EXPORT_SYMBOL_GPL(io_policy_ceph);
+
+int ceph_io_policy_init()
+{
+	return blkcg_policy_register(&io_policy_ceph);
+};
+EXPORT_SYMBOL(ceph_io_policy_init);
+
+void ceph_io_policy_release()
+{
+	blkcg_policy_unregister(&io_policy_ceph);
+};
+EXPORT_SYMBOL(ceph_io_policy_release);
diff --git a/include/linux/ceph/ceph_io_policy.h b/include/linux/ceph/ceph_io_policy.h
new file mode 100644
index 000000000000..32b452ec358f
--- /dev/null
+++ b/include/linux/ceph/ceph_io_policy.h
@@ -0,0 +1,74 @@
+#ifndef _CEPHFS_CGROUP_H
+#define _CEPHFS_CGROUP_H
+
+#include <linux/blk-cgroup.h>
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
+	u64 remain;
+	u64 max;
+	u64 target_throughput;
+};
+
+struct token_bucket_throttle {
+	struct token_bucket* tb;
+	u64 tick_interval;
+	int tb_num;
+	struct list_head reqs_blocked;
+	struct mutex bucket_lock;
+	struct delayed_work tick_work;
+	unsigned long tbt_timeout;
+};
+
+struct queue_item {
+	struct list_head token_bucket_throttle_item;
+	u64* tokens_requested;
+	int tb_item_num;
+	struct completion throttled;
+	unsigned long tbt_timeout;
+};
+
+struct ceph_group_data {
+	struct blkcg_policy_data cpd;
+
+	struct token_bucket_throttle meta_ops_throttle;
+	struct token_bucket_throttle data_ops_throttle;
+};
+
+extern struct blkcg_policy io_policy_ceph;
+
+static inline struct ceph_group_data *cpd_to_cephgd(struct blkcg_policy_data *cpd)
+{
+	return cpd ? container_of(cpd, struct ceph_group_data, cpd) : NULL;
+}
+
+static inline struct ceph_group_data* blkcg_to_cephgd(struct blkcg* blkcg)
+{
+	return cpd_to_cephgd(blkcg_to_cpd(blkcg, &io_policy_ceph));
+}
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
+extern int ceph_io_policy_init(void);
+
+extern void ceph_io_policy_release(void);
+
+extern void queue_item_free(struct queue_item* qitem);
+
+#endif /*_CEPHFS_CGROUP_H*/
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 2294f963dab7..c80c96368679 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -15,6 +15,9 @@
 #include <linux/ceph/msgpool.h>
 #include <linux/ceph/auth.h>
 #include <linux/ceph/pagelist.h>
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+#include <linux/ceph/ceph_io_policy.h>
+#endif
 
 struct ceph_msg;
 struct ceph_snap_context;
@@ -193,6 +196,10 @@ struct ceph_osd_request {
 
 	int               r_result;
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	/* token bucket throttle item*/
+	struct queue_item qitem;
+#endif
 	struct ceph_osd_client *r_osdc;
 	struct kref       r_kref;
 	bool              r_mempool;
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 1c811c74bfc0..05c6e7b89c42 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -26,6 +26,9 @@
 #include <linux/ceph/decode.h>
 #include <linux/ceph/mon_client.h>
 #include <linux/ceph/auth.h>
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+#include <linux/ceph/ceph_io_policy.h>
+#endif
 #include "crypto.h"
 
 
@@ -776,6 +779,12 @@ static int __init init_ceph_lib(void)
 {
 	int ret = 0;
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	ret = ceph_io_policy_init();
+	if (ret < 0)
+		goto out;
+#endif
+
 	ret = ceph_debugfs_init();
 	if (ret < 0)
 		goto out;
@@ -812,6 +821,10 @@ static void __exit exit_ceph_lib(void)
 	dout("exit_ceph_lib\n");
 	WARN_ON(!ceph_strings_empty());
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	ceph_io_policy_release();
+#endif
+
 	ceph_osdc_cleanup();
 	ceph_msgr_exit();
 	ceph_crypto_shutdown();
-- 
2.21.0

