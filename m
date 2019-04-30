Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0CEF839
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2019 14:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfD3MGi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Apr 2019 08:06:38 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:39001 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfD3MGh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Apr 2019 08:06:37 -0400
Received: by mail-pg1-f179.google.com with SMTP id l18so6731956pgj.6
        for <ceph-devel@vger.kernel.org>; Tue, 30 Apr 2019 05:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q6YU1mFCah3apJv071Qu7A9B1KsJE3a/Kqgk8KlAuAE=;
        b=DbHe2voQGNzO8tywrnAazPqxWLbOSvgMku1l8HWqf0A65mbxR4XDekX7W9/oYbu9ww
         qrUCd37dzLzLa8Drs7rOGQhQg+i5AMAwSww49A1R3UeWIpJES4ab2BDOJUfRz6mfpTjP
         MWa6ZOd5TAp+RPCPOZNTI3FsjkiowVBV7sTzGX7V95nFxESt9rgLV+uy1P8HTnjte5NQ
         1fyvGcYiKDEXNT/PgZ/ZRbNWLEUxAYue3ljFhqVI8v0oM4k3PAJ+9SLT65W0lq0y5fvC
         RwfUgr6ku/qqXl+VQ6iIKRt5tpGVT//iV/rxvep8P/nwI03lAfzc6qtNbzygCKtA9tti
         uR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q6YU1mFCah3apJv071Qu7A9B1KsJE3a/Kqgk8KlAuAE=;
        b=Z1Poe+zCExueghN6wzQpo7XE02amBprorVK4RDR+UboGztlhU0iqhOlGSQ4Y1f0kh7
         pae+8mw/gvw9Bb3/cQk6gvyqNdA8DaDABEiYVepsTqvExrjtsmzyUh3OV3Mz0S1qfWCq
         3ynpkAoJYujawfrmJKrW7rHstBASVLol4y+L0dUSjv17XVVJhFCRD33PJGktkeXh8gNn
         HyQOEPPQ8DjC993ffNNex17dNhjluWINQpEVcrWaSdiZd9QCXbQ8NCWK5WbY5y7+HsM5
         LuPuA9RhUcpPLNl5leibpHlvkG4VoNJr4pfHgHg92G0pujttnuQzEhNnGyn54wIr8AeA
         cKpQ==
X-Gm-Message-State: APjAAAUHwm0bh3PQU9RB+PKjVUuDYvm+TvgPTU9+asa3yLQSBtFY0EU+
        Q5lvg13k0cCXcTNFzXSdJzgzB1y8
X-Google-Smtp-Source: APXvYqz3WL1ChYuvu/OWdjDxvfbUOYPjlopGmw/mguV9iaeqH51/WfnqyG9dVcclrt5WG/7VIPT10g==
X-Received: by 2002:aa7:8ac8:: with SMTP id b8mr26125281pfd.234.1556625996653;
        Tue, 30 Apr 2019 05:06:36 -0700 (PDT)
Received: from xxh01v.add.shbt.qihoo.net ([180.163.220.95])
        by smtp.gmail.com with ESMTPSA id n67sm4005786pfn.22.2019.04.30.05.06.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Apr 2019 05:06:35 -0700 (PDT)
From:   xxhdx1985126@gmail.com
To:     ceph-devel@vger.kernel.org, ukernel@gmail.com
Cc:     Xuehan Xu <xuxuehan@360.cn>
Subject: [PATCH 2/2] ceph: use cephfs cgroup contoller to limit client ops
Date:   Tue, 30 Apr 2019 12:05:34 +0000
Message-Id: <20190430120534.5231-2-xxhdx1985126@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430120534.5231-1-xxhdx1985126@gmail.com>
References: <20190430120534.5231-1-xxhdx1985126@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xuehan Xu <xuxuehan@360.cn>

Signed-off-by: Xuehan Xu <xuxuehan@360.cn>
---
 fs/ceph/mds_client.c            | 34 +++++++++++++++++++++++++-
 fs/ceph/mds_client.h            |  9 +++++++
 fs/ceph/super.c                 |  5 +++-
 include/linux/ceph/osd_client.h | 11 ++++++++-
 include/linux/ceph/types.h      |  1 -
 net/ceph/ceph_common.c          |  2 +-
 net/ceph/ceph_fs.c              |  1 -
 net/ceph/osd_client.c           | 42 +++++++++++++++++++++++++++++++++
 8 files changed, 99 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9049c2a3e972..4ba6b4de0f64 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -20,6 +20,10 @@
 #include <linux/ceph/auth.h>
 #include <linux/ceph/debugfs.h>
 
+#ifdef CONFIG_CGROUP_CEPH_FS
+#include <linux/cgroup_cephfs.h>
+#endif
+
 #define RECONNECT_MAX_SIZE (INT_MAX - PAGE_SIZE)
 
 /*
@@ -689,6 +693,9 @@ void ceph_mdsc_release_request(struct kref *kref)
 	struct ceph_mds_request *req = container_of(kref,
 						    struct ceph_mds_request,
 						    r_kref);
+#ifdef CONFIG_CGROUP_CEPH_FS
+    kfree(req->qitem.tokens_requested);
+#endif
 	destroy_reply_info(&req->r_reply_info);
 	if (req->r_request)
 		ceph_msg_put(req->r_request);
@@ -2035,6 +2042,12 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
 {
 	struct ceph_mds_request *req = kzalloc(sizeof(*req), GFP_NOFS);
 	struct timespec64 ts;
+#ifdef CONFIG_CGROUP_CEPH_FS
+    struct task_struct* tsk = current;
+    struct cgroup_subsys_state* css = tsk->cgroups->subsys[cephfs_cgrp_subsys.id];
+    struct cephfscg* cephfscg_p =
+        container_of(css, struct cephfscg, css);
+#endif
 
 	if (!req)
 		return ERR_PTR(-ENOMEM);
@@ -2058,6 +2071,10 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
 
 	req->r_op = op;
 	req->r_direct_mode = mode;
+
+#ifdef CONFIG_CGROUP_CEPH_FS
+    queue_item_init(&req->qitem, &cephfscg_p->meta_ops_throttle, META_OPS_TB_NUM);
+#endif
 	return req;
 }
 
@@ -2689,9 +2706,22 @@ int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
 			 struct ceph_mds_request *req)
 {
 	int err;
+#ifdef CONFIG_CGROUP_CEPH_FS
+    struct task_struct* ts = current;
+    struct cgroup_subsys_state* css = ts->cgroups->subsys[cephfs_cgrp_subsys.id];
+    struct cephfscg* cephfscg_p =
+        container_of(css, struct cephfscg, css);
+#endif
 
 	dout("do_request on %p\n", req);
 
+#ifdef CONFIG_CGROUP_CEPH_FS
+    req->qitem.tokens_requested[META_OPS_IOPS_IDX] = 1;
+    err = get_token_bucket_throttle(&cephfscg_p->meta_ops_throttle, &req->qitem);
+    if (err)
+        goto nolock_err;
+#endif
+
 	/* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
 	if (req->r_inode)
 		ceph_get_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
@@ -2755,6 +2785,7 @@ int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
 
 out:
 	mutex_unlock(&mdsc->mutex);
+nolock_err:
 	dout("do_request %p done, result %d\n", req, err);
 	return err;
 }
@@ -4166,7 +4197,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 
 	strscpy(mdsc->nodename, utsname()->nodename,
 		sizeof(mdsc->nodename));
-	return 0;
+
+    return 0;
 }
 
 /*
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 50385a481fdb..814f0ecca523 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -16,6 +16,10 @@
 #include <linux/ceph/mdsmap.h>
 #include <linux/ceph/auth.h>
 
+#ifdef CONFIG_CGROUP_CEPH_FS
+#include <linux/cgroup_cephfs.h>
+#endif
+
 /* The first 8 bits are reserved for old ceph releases */
 #define CEPHFS_FEATURE_MIMIC		8
 #define CEPHFS_FEATURE_REPLY_ENCODING	9
@@ -284,6 +288,11 @@ struct ceph_mds_request {
 	/* unsafe requests that modify the target inode */
 	struct list_head r_unsafe_target_item;
 
+#ifdef CONFIG_CGROUP_CEPH_FS
+    /* requests that blocked by the token bucket throttle*/
+    struct queue_item qitem;
+#endif
+
 	struct ceph_mds_session *r_session;
 
 	int               r_attempts;   /* resend attempts */
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 6d5bb2f74612..19d035dfe414 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1161,7 +1161,10 @@ MODULE_ALIAS_FS("ceph");
 
 static int __init init_ceph(void)
 {
-	int ret = init_caches();
+	int ret = 0;
+    pr_info("init_ceph\n");
+
+    ret = init_caches();
 	if (ret)
 		goto out;
 
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 2294f963dab7..31011a1e9573 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -16,6 +16,10 @@
 #include <linux/ceph/auth.h>
 #include <linux/ceph/pagelist.h>
 
+#ifdef CONFIG_CGROUP_CEPH_FS
+#include <linux/cgroup_cephfs.h>
+#endif
+
 struct ceph_msg;
 struct ceph_snap_context;
 struct ceph_osd_request;
@@ -193,7 +197,12 @@ struct ceph_osd_request {
 
 	int               r_result;
 
-	struct ceph_osd_client *r_osdc;
+#ifdef CONFIG_CGROUP_CEPH_FS
+    /* token bucket throttle item*/
+    struct queue_item qitem;
+#endif
+
+    struct ceph_osd_client *r_osdc;
 	struct kref       r_kref;
 	bool              r_mempool;
 	struct completion r_completion;       /* private to osd_client.c */
diff --git a/include/linux/ceph/types.h b/include/linux/ceph/types.h
index bd3d532902d7..3b404bdbb28f 100644
--- a/include/linux/ceph/types.h
+++ b/include/linux/ceph/types.h
@@ -27,5 +27,4 @@ struct ceph_cap_reservation {
 	int used;
 };
 
-
 #endif
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 79eac465ec65..a0087532516b 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -503,7 +503,7 @@ ceph_parse_options(char *options, const char *dev_name,
 			opt->osd_request_timeout = msecs_to_jiffies(intval * 1000);
 			break;
 
-		case Opt_share:
+        case Opt_share:
 			opt->flags &= ~CEPH_OPT_NOSHARE;
 			break;
 		case Opt_noshare:
diff --git a/net/ceph/ceph_fs.c b/net/ceph/ceph_fs.c
index 756a2dc10d27..744a6e5c0cba 100644
--- a/net/ceph/ceph_fs.c
+++ b/net/ceph/ceph_fs.c
@@ -4,7 +4,6 @@
  */
 #include <linux/module.h>
 #include <linux/ceph/types.h>
-
 /*
  * return true if @layout appears to be valid
  */
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index fa9530dd876e..27d9fdf88af6 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -22,6 +22,10 @@
 #include <linux/ceph/pagelist.h>
 #include <linux/ceph/striper.h>
 
+#ifdef CONFIG_CGROUP_CEPH_FS
+#include <linux/cgroup_cephfs.h>
+#endif
+
 #define OSD_OPREPLY_FRONT_LEN	512
 
 static struct kmem_cache	*ceph_osd_request_cache;
@@ -492,6 +496,10 @@ static void ceph_osdc_release_request(struct kref *kref)
 	     req->r_request, req->r_reply);
 	request_release_checks(req);
 
+#ifdef CONFIG_CGROUP_CEPH_FS
+    kfree(req->qitem.tokens_requested);
+#endif
+
 	if (req->r_request)
 		ceph_msg_put(req->r_request);
 	if (req->r_reply)
@@ -587,6 +595,13 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 					       gfp_t gfp_flags)
 {
 	struct ceph_osd_request *req;
+#ifdef CONFIG_CGROUP_CEPH_FS
+    struct task_struct* ts = current;
+    struct cgroup_subsys_state* css = ts->cgroups->subsys[cephfs_cgrp_subsys.id];
+    struct cephfscg* cephfscg_p =
+        container_of(css, struct cephfscg, css);
+    int r = 0;
+#endif
 
 	if (use_mempool) {
 		BUG_ON(num_ops > CEPH_OSD_SLAB_OPS);
@@ -606,6 +621,11 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 	req->r_num_ops = num_ops;
 	req->r_snapid = CEPH_NOSNAP;
 	req->r_snapc = ceph_get_snap_context(snapc);
+#ifdef CONFIG_CGROUP_CEPH_FS
+    r = queue_item_init(&req->qitem, &cephfscg_p->data_ops_throttle, DATA_OPS_TB_NUM);
+    if (unlikely(r))
+        return NULL;
+#endif
 
 	dout("%s req %p\n", __func__, req);
 	return req;
@@ -4463,6 +4483,28 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 			    struct ceph_osd_request *req,
 			    bool nofail)
 {
+#ifdef CONFIG_CGROUP_CEPH_FS
+    struct task_struct* ts = current;
+    struct cgroup_subsys_state* css = ts->cgroups->subsys[cephfs_cgrp_subsys.id];
+    struct cephfscg* cephfscg_p =
+        container_of(css, struct cephfscg, css);
+    int err = 0;
+    int i = 0;
+    u64 len = 0;
+
+    dout("%s: req: %p, tid: %llu, tokens_requested: %p, tb_item_num: %d\n", __func__, req, req->r_tid, req->qitem.tokens_requested, req->qitem.tb_item_num);
+    req->qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
+    for (i = 0; i < req->r_num_ops; i++) {
+        if (req->r_ops[i].op == CEPH_OSD_OP_READ
+                || req->r_ops[i].op == CEPH_OSD_OP_WRITE)
+            len += req->r_ops[i].extent.length;
+    }
+    dout("%s: req: %llu, ops: %d, len: %llu\n", __func__, req->r_tid, req->r_num_ops, len);
+    req->qitem.tokens_requested[DATA_OPS_BAND_IDX] = len;
+    err = get_token_bucket_throttle(&cephfscg_p->data_ops_throttle, &req->qitem);
+    if (err)
+        return err;
+#endif
 	down_read(&osdc->lock);
 	submit_request(req, false);
 	up_read(&osdc->lock);
-- 
2.20.1

