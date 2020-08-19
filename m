Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EC124996B
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 11:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgHSJgz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 05:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgHSJgw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 05:36:52 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33565C061757
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 02:36:52 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id i19so11719790lfj.8
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 02:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sWzDw8qMcCvNboUM+cODyJm/rbNmZLXaR0giHK9fovI=;
        b=bT4DSGpF05WrWNx2WBN5hK+M2ZjxOOxrrGZzGt+e/V404/anek4iWeiTfU7xSKpSeQ
         ujGK/GGr1Rlpv+zNw5W9DGQPh3YpQkr585GJTYqbjzqkJbO3TlhHsao59UiF7H1uGVHP
         jeQkkFZK3/Nyvjc0vo/uUKwFyva1tByr+t4/LVIZnsWviPFF92I5YNK1dQZy1C9DTUJh
         x8pxiaK4n/F7TvpoJ5hyW9doXy0DEYvptRVeJCp3pZ+KqFfpcm9u4UiH6+vlbTASEBdg
         fEmfVEHZ96ThVmXf1sEw03WYGay+h1QuAiB/oE5cfC0zK7czwpIHGi01HlKpUiqWvDdy
         U8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sWzDw8qMcCvNboUM+cODyJm/rbNmZLXaR0giHK9fovI=;
        b=C65XtYgJ0S4Jg8Pqdp8TmzmG5Af3z6goJQiOSf3A3M3MlbJtBTPL1gYSUu0b8o7Z4Y
         dhEDO+YhzFsREJTLkpt0bXjqyBq0LbD473+5osVovFpjk44bBijqK4vIY7CvcZ7vuaJk
         WcGWCxnrwejdw6FI9PbcxbTgd/MYsj7W4LaXOQi/yjmvU8lsJVznbeJfU3ZZM/2bxqBq
         ycZO8fdc+fBDfyi8Q00u+/I+NwvSGdtjcB8qMD2vwmJFREJVH0HKAwmQ+4cbBJTAO1r8
         SH9b8N8yxwWGmhyBYygQKpq/NTdK/IkcQbl4wYv8Vh3aca37IMOcoHnvfMVxlpXQIQ1Z
         LOXg==
X-Gm-Message-State: AOAM532ioSoJBiqxbB3fxq0s1+vy/duz4vKSdEcICLFkqheH22sFqd0d
        OkV6pJJkOojXBeq0HWdunlgmNySiw8c=
X-Google-Smtp-Source: ABdhPJx30QRMHzk+S9Wyq1eq8KPNrzeF/w1iLPeL4Kyp6l6UoHCsamdYzPFFH+s8klmsJF190HRkuQ==
X-Received: by 2002:a17:906:a201:: with SMTP id r1mr23915440ejy.432.1597829809443;
        Wed, 19 Aug 2020 02:36:49 -0700 (PDT)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id x1sm18117035ejc.119.2020.08.19.02.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 02:36:48 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Robin Geuze <robing@nl.team.blue>
Subject: [PATCH] libceph: multiple workspaces for CRUSH computations
Date:   Wed, 19 Aug 2020 11:36:14 +0200
Message-Id: <20200819093614.22774-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Replace a global map->crush_workspace (protected by a global mutex)
with a list of workspaces, up to the number of CPUs + 1.

This is based on a patch from Robin Geuze <robing@nl.team.blue>.
Robin and his team have observed a 10-20% increase in IOPS on all
queue depths and lower CPU usage as well on a high-end all-NVMe
100GbE cluster.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/osdmap.h |  14 ++-
 include/linux/crush/crush.h |   3 +
 net/ceph/osdmap.c           | 166 ++++++++++++++++++++++++++++++++----
 3 files changed, 166 insertions(+), 17 deletions(-)

diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
index 3f4498fef6ad..cad9acfbc320 100644
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -137,6 +137,17 @@ int ceph_oid_aprintf(struct ceph_object_id *oid, gfp_t gfp,
 		     const char *fmt, ...);
 void ceph_oid_destroy(struct ceph_object_id *oid);
 
+struct workspace_manager {
+	struct list_head idle_ws;
+	spinlock_t ws_lock;
+	/* Number of free workspaces */
+	int free_ws;
+	/* Total number of allocated workspaces */
+	atomic_t total_ws;
+	/* Waiters for a free workspace */
+	wait_queue_head_t ws_wait;
+};
+
 struct ceph_pg_mapping {
 	struct rb_node node;
 	struct ceph_pg pgid;
@@ -184,8 +195,7 @@ struct ceph_osdmap {
 	 * the list of osds that store+replicate them. */
 	struct crush_map *crush;
 
-	struct mutex crush_workspace_mutex;
-	void *crush_workspace;
+	struct workspace_manager crush_wsm;
 };
 
 static inline bool ceph_osd_exists(struct ceph_osdmap *map, int osd)
diff --git a/include/linux/crush/crush.h b/include/linux/crush/crush.h
index 2f811baf78d2..30dba392b730 100644
--- a/include/linux/crush/crush.h
+++ b/include/linux/crush/crush.h
@@ -346,6 +346,9 @@ struct crush_work_bucket {
 
 struct crush_work {
 	struct crush_work_bucket **work; /* Per-bucket working store */
+#ifdef __KERNEL__
+	struct list_head item;
+#endif
 };
 
 #ifdef __KERNEL__
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 96c25f5e064a..fa08c15be0c0 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -964,6 +964,143 @@ static int decode_pool_names(void **p, void *end, struct ceph_osdmap *map)
 	return -EINVAL;
 }
 
+/*
+ * CRUSH workspaces
+ *
+ * workspace_manager framework borrowed from fs/btrfs/compression.c.
+ * Two simplifications: there is only one type of workspace and there
+ * is always at least one workspace.
+ */
+static struct crush_work *alloc_workspace(const struct crush_map *c)
+{
+	struct crush_work *work;
+	size_t work_size;
+
+	WARN_ON(!c->working_size);
+	work_size = crush_work_size(c, CEPH_PG_MAX_SIZE);
+	dout("%s work_size %zu bytes\n", __func__, work_size);
+
+	work = ceph_kvmalloc(work_size, GFP_NOIO);
+	if (!work)
+		return NULL;
+
+	INIT_LIST_HEAD(&work->item);
+	crush_init_workspace(c, work);
+	return work;
+}
+
+static void free_workspace(struct crush_work *work)
+{
+	WARN_ON(!list_empty(&work->item));
+	kvfree(work);
+}
+
+static void init_workspace_manager(struct workspace_manager *wsm)
+{
+	INIT_LIST_HEAD(&wsm->idle_ws);
+	spin_lock_init(&wsm->ws_lock);
+	atomic_set(&wsm->total_ws, 0);
+	wsm->free_ws = 0;
+	init_waitqueue_head(&wsm->ws_wait);
+}
+
+static void add_initial_workspace(struct workspace_manager *wsm,
+				  struct crush_work *work)
+{
+	WARN_ON(!list_empty(&wsm->idle_ws));
+
+	list_add(&work->item, &wsm->idle_ws);
+	atomic_set(&wsm->total_ws, 1);
+	wsm->free_ws = 1;
+}
+
+static void cleanup_workspace_manager(struct workspace_manager *wsm)
+{
+	struct crush_work *work;
+
+	while (!list_empty(&wsm->idle_ws)) {
+		work = list_first_entry(&wsm->idle_ws, struct crush_work,
+					item);
+		list_del_init(&work->item);
+		free_workspace(work);
+	}
+	atomic_set(&wsm->total_ws, 0);
+	wsm->free_ws = 0;
+}
+
+/*
+ * Finds an available workspace or allocates a new one.  If it's not
+ * possible to allocate a new one, waits until there is one.
+ */
+static struct crush_work *get_workspace(struct workspace_manager *wsm,
+					const struct crush_map *c)
+{
+	struct crush_work *work;
+	int cpus = num_online_cpus();
+
+again:
+	spin_lock(&wsm->ws_lock);
+	if (!list_empty(&wsm->idle_ws)) {
+		work = list_first_entry(&wsm->idle_ws, struct crush_work,
+					item);
+		list_del_init(&work->item);
+		wsm->free_ws--;
+		spin_unlock(&wsm->ws_lock);
+		return work;
+
+	}
+	if (atomic_read(&wsm->total_ws) > cpus) {
+		DEFINE_WAIT(wait);
+
+		spin_unlock(&wsm->ws_lock);
+		prepare_to_wait(&wsm->ws_wait, &wait, TASK_UNINTERRUPTIBLE);
+		if (atomic_read(&wsm->total_ws) > cpus && !wsm->free_ws)
+			schedule();
+		finish_wait(&wsm->ws_wait, &wait);
+		goto again;
+	}
+	atomic_inc(&wsm->total_ws);
+	spin_unlock(&wsm->ws_lock);
+
+	work = alloc_workspace(c);
+	if (!work) {
+		atomic_dec(&wsm->total_ws);
+		wake_up(&wsm->ws_wait);
+
+		/*
+		 * Do not return the error but go back to waiting.  We
+		 * have the inital workspace and the CRUSH computation
+		 * time is bounded so we will get it eventually.
+		 */
+		WARN_ON(atomic_read(&wsm->total_ws) < 1);
+		goto again;
+	}
+	return work;
+}
+
+/*
+ * Puts a workspace back on the list or frees it if we have enough
+ * idle ones sitting around.
+ */
+static void put_workspace(struct workspace_manager *wsm,
+			  struct crush_work *work)
+{
+	spin_lock(&wsm->ws_lock);
+	if (wsm->free_ws <= num_online_cpus()) {
+		list_add(&work->item, &wsm->idle_ws);
+		wsm->free_ws++;
+		spin_unlock(&wsm->ws_lock);
+		goto wake;
+	}
+	spin_unlock(&wsm->ws_lock);
+
+	free_workspace(work);
+	atomic_dec(&wsm->total_ws);
+wake:
+	if (wq_has_sleeper(&wsm->ws_wait))
+		wake_up(&wsm->ws_wait);
+}
+
 /*
  * osd map
  */
@@ -981,7 +1118,8 @@ struct ceph_osdmap *ceph_osdmap_alloc(void)
 	map->primary_temp = RB_ROOT;
 	map->pg_upmap = RB_ROOT;
 	map->pg_upmap_items = RB_ROOT;
-	mutex_init(&map->crush_workspace_mutex);
+
+	init_workspace_manager(&map->crush_wsm);
 
 	return map;
 }
@@ -989,8 +1127,11 @@ struct ceph_osdmap *ceph_osdmap_alloc(void)
 void ceph_osdmap_destroy(struct ceph_osdmap *map)
 {
 	dout("osdmap_destroy %p\n", map);
+
 	if (map->crush)
 		crush_destroy(map->crush);
+	cleanup_workspace_manager(&map->crush_wsm);
+
 	while (!RB_EMPTY_ROOT(&map->pg_temp)) {
 		struct ceph_pg_mapping *pg =
 			rb_entry(rb_first(&map->pg_temp),
@@ -1029,7 +1170,6 @@ void ceph_osdmap_destroy(struct ceph_osdmap *map)
 	kvfree(map->osd_weight);
 	kvfree(map->osd_addr);
 	kvfree(map->osd_primary_affinity);
-	kvfree(map->crush_workspace);
 	kfree(map);
 }
 
@@ -1104,26 +1244,22 @@ static int osdmap_set_max_osd(struct ceph_osdmap *map, u32 max)
 
 static int osdmap_set_crush(struct ceph_osdmap *map, struct crush_map *crush)
 {
-	void *workspace;
-	size_t work_size;
+	struct crush_work *work;
 
 	if (IS_ERR(crush))
 		return PTR_ERR(crush);
 
-	work_size = crush_work_size(crush, CEPH_PG_MAX_SIZE);
-	dout("%s work_size %zu bytes\n", __func__, work_size);
-	workspace = ceph_kvmalloc(work_size, GFP_NOIO);
-	if (!workspace) {
+	work = alloc_workspace(crush);
+	if (!work) {
 		crush_destroy(crush);
 		return -ENOMEM;
 	}
-	crush_init_workspace(crush, workspace);
 
 	if (map->crush)
 		crush_destroy(map->crush);
-	kvfree(map->crush_workspace);
+	cleanup_workspace_manager(&map->crush_wsm);
 	map->crush = crush;
-	map->crush_workspace = workspace;
+	add_initial_workspace(&map->crush_wsm, work);
 	return 0;
 }
 
@@ -2322,6 +2458,7 @@ static int do_crush(struct ceph_osdmap *map, int ruleno, int x,
 		    s64 choose_args_index)
 {
 	struct crush_choose_arg_map *arg_map;
+	struct crush_work *work;
 	int r;
 
 	BUG_ON(result_max > CEPH_PG_MAX_SIZE);
@@ -2332,12 +2469,11 @@ static int do_crush(struct ceph_osdmap *map, int ruleno, int x,
 		arg_map = lookup_choose_arg_map(&map->crush->choose_args,
 						CEPH_DEFAULT_CHOOSE_ARGS);
 
-	mutex_lock(&map->crush_workspace_mutex);
+	work = get_workspace(&map->crush_wsm, map->crush);
 	r = crush_do_rule(map->crush, ruleno, x, result, result_max,
-			  weight, weight_max, map->crush_workspace,
+			  weight, weight_max, work,
 			  arg_map ? arg_map->args : NULL);
-	mutex_unlock(&map->crush_workspace_mutex);
-
+	put_workspace(&map->crush_wsm, work);
 	return r;
 }
 
-- 
2.19.2

