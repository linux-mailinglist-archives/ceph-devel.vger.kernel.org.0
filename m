Return-Path: <ceph-devel+bounces-3867-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA2FC0537F
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 11:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF7214235BE
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 08:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B206307AC6;
	Fri, 24 Oct 2025 08:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0chSIlc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05B730649D
	for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 08:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761295403; cv=none; b=n860rh1tsd5Z4WQqta+ugKbXrhMCBfYRQlegX5v0YC/9mjJUAjrQ010s/H+vjOCRokppJUG1IHQhT8jV2yenviTC+c8gxjvMjYhniFN1L+1xd5Ay7hRFWPbVNnPHEcHdekWR5W7I6q2kpMnZishVvIbUyOyQO/qbF5an0qTe2os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761295403; c=relaxed/simple;
	bh=y9LND0hzWRB14wYS7B1g+hi9YYh9DojE2Gi5ceRFyRk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iAium9hhUPCXCgN/mwO7nmB72C9gdHobXOHbTp/duJ+Q+OK6lIj5qvoqEwwnRPYFHQSBD2waEEjc9NSzi4MUPJKQwlwQKUDbSx25a/dTKPBx9qdN1pQp6XyWspswJV0eOZYD6BIiyRI4HO80OFShQ10PiGx4fF5iy6C2IIGYoC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C0chSIlc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761295400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EM/fQ7icQaeiFLlvGb7ckJc4gbojH3PiXz9mgf+NyPo=;
	b=C0chSIlcEpQk1bo2bB0N0oSvir9nACckfStd21aN755hhj1M/+xu7niAqrUD1+uYzg7SdI
	Bg7xaYMF8sV0VwSWuV/9SpcAa6nWnxWw/ycDlcq/DAHjx7qhlkEa603HE0007IxkQO/5U5
	Bh4ugihhcqu+slTcUk/9p5JDgl1xS4g=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-B7ZpLuEFPg67G_qZJqSICw-1; Fri, 24 Oct 2025 04:43:18 -0400
X-MC-Unique: B7ZpLuEFPg67G_qZJqSICw-1
X-Mimecast-MFC-AGG-ID: B7ZpLuEFPg67G_qZJqSICw_1761295397
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b4813c6cbeeso226679466b.3
        for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 01:43:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761295397; x=1761900197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EM/fQ7icQaeiFLlvGb7ckJc4gbojH3PiXz9mgf+NyPo=;
        b=mYg+3d9U8uSERCnL4oQcvVchS7legMKNp3FeRdqaqOqm8W036Blz5idBg9Wl1AcvRA
         Q1efRNKNRRHTc778O9JKejP0IngAjBSSdlpAzINEPz3gOc2HbG6Xw5b9fqRpKnzcULvz
         stnQw1YDz1jWsghXBfYTELc68D4ulp1srUtWJoCxvnN0QNnnzS13+oZlhV1Cru6yYoUK
         CWxSUroraA1889OusyOr74Tm5DM8FE3FCGqhUAAgLvNF1HFysMMBNpd5vyRSPWttep3a
         GcX9eadh/QuwqS0BzpyBjyk7N2UwIAgl+NwkUfWcfIhFjwTm+jjYB17G7RJRn4iODckb
         SY8g==
X-Gm-Message-State: AOJu0YzKLPuBONSxd8/7Tl89/U2A0oh5Oq+eG2K1lISOkyrWoLTfHwVm
	ZRWfNiyo5OQ1nvDt60KOvfZRoYxfo6ElzYOrUfNuRVhwmqyipLA1DfsGMJg1ShfSLVDdqbfOyjb
	toHzYWk1YCgcRHFLR1YmFwyHZeWprnlMRX1X8nClVLFqHOK9oiBG+IZu5HAF6K2f71xPM4NNQtf
	/g2wLNoR+TUG1vJ4edzKuxTqzxRZgB9L6yeZaujvBe/cqC92BHXHvULW8=
X-Gm-Gg: ASbGncv1AFOl1u2aDPJAFRboGmpZph1+fq3OCVnV+Sgk/2s2Omz9C3yv4osfdzVJ280
	aGwa7HsiYr1r76pxw5bJhiqB7yCuqRViegPflwAMjzuAvsuqMzJM9gw8SGp3X5uxD9e3Oh+blCD
	aZ59eyyu/WaeTOX3qZI1RVX61O3RTyHik96RHZSJsGIpxCnURrp7aVvH3uPDO91ZxHxyhGsAoYD
	EV9JQFwvuDm8qw9jwnhUAPdVcpgGPrkl58YsIVI3a6nNul7ObFC1yAv+if+bJ5A7k4qBxCuhKgY
	mQm+bPx1Xjb8S0Ikj3o36JxqZyfmqgLPh71qpFmD9gA5kRY3cQEFgHRP9ldbctY9xawXz+jyRbq
	NpjhqP0N9qsmzSvvPjC9+5WNEXUSPjGwW
X-Received: by 2002:a17:907:9483:b0:b6d:3fc9:e60a with SMTP id a640c23a62f3a-b6d3fc9e8a3mr891834766b.19.1761295397031;
        Fri, 24 Oct 2025 01:43:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcTnVj9nWbOwAbV6zlbH31DU9/PeYosrmE9n0krBhv7kGFZ4f/K+hEp8Y2jQzw59pd3AeUbQ==
X-Received: by 2002:a17:907:9483:b0:b6d:3fc9:e60a with SMTP id a640c23a62f3a-b6d3fc9e8a3mr891829566b.19.1761295396434;
        Fri, 24 Oct 2025 01:43:16 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d010asm469226866b.11.2025.10.24.01.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 01:43:16 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com,
	amarkuze@redhat.com,
	akpm@linux-foundation.org,
	bsegall@google.com,
	david@redhat.com,
	dietmar.eggemann@arm.com,
	idryomov@gmail.com,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	kees@kernel.org,
	lorenzo.stoakes@oracle.com,
	mgorman@suse.de,
	mhocko@suse.com,
	rppt@kernel.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	surenb@google.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	vbabka@suse.cz,
	xiubli@redhat.com,
	Slava.Dubeyko@ibm.com
Subject: [RFC PATCH 4/5] ceph: Add BLOG debugfs support
Date: Fri, 24 Oct 2025 08:42:58 +0000
Message-Id: <20251024084259.2359693-5-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce blog_debugfs.c to export BLOG binary logs through the Ceph debugfs
hierarchy, enabling userspace tools to read and deserialize per-task logging
buffers for debugging, tracing, and performance analysis.

**Key Components:**

**blog_debugfs.c - Binary log export interface:**
- blog_entries_show(): Seq file iterator over all active BLOG contexts
- Lock-safe context enumeration with proper synchronization
- Per-context buffer snapshot mechanism to prevent data corruption
- Deserialization and formatted output of binary log entries
- Integration with Ceph debugfs directory structure

**Locking strategy (critical correctness fix):**
The implementation employs a splice-snapshot-splice pattern to avoid
deadlocks and ensure consistent reads:

1. **Context enumeration:** Splice logger->contexts list to temporary list
   under logger->lock, then drop the lock. This allows new contexts to be
   created and logging to continue unhindered during potentially slow
   debugfs reads (e.g., cat of large log files).

2. **Buffer snapshot:** For each context, acquire pf->lock, snapshot the
   buffer (head pointer and capacity), copy data to temporary buffer, then
   drop pf->lock. This prevents concurrent writers from corrupting the read
   while minimizing lock hold time.

3. **Context restoration:** After iteration completes, splice the temporary
   list back onto logger->contexts under the lock.

This design prevents the deadlock scenario where holding logger->lock during
debugfs read would block all new context allocations, while holding pf->lock
during deserialization would block all logging on that context.

**debugfs.c modifications:**
- Call ceph_blog_debugfs_init() during Ceph debugfs setup when CONFIG_BLOG
  is enabled, registering BLOG-specific entries alongside existing debug
  files (e.g., mds_sessions, caps, etc.)
- Call ceph_blog_debugfs_cleanup() during teardown to remove entries

**Output format:**
Each log entry is displayed as a single line with timestamp and deserialized
message, making it easy to parse and correlate with kernel events. Format
strings are resolved via the BLOG source ID registry.

No actual logging is performed yet; dout/doutc macros remain unchanged in
Ceph code. This commit only establishes the drain path for binary log
consumption. Subsequent commits will activate BLOG by converting logging
call sites to bout/boutc.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/blog_debugfs.c | 361 +++++++++++++++++++++++++++++++++++++++++
 fs/ceph/debugfs.c      |  33 +++-
 2 files changed, 388 insertions(+), 6 deletions(-)
 create mode 100644 fs/ceph/blog_debugfs.c

diff --git a/fs/ceph/blog_debugfs.c b/fs/ceph/blog_debugfs.c
new file mode 100644
index 000000000000..b34b6829b444
--- /dev/null
+++ b/fs/ceph/blog_debugfs.c
@@ -0,0 +1,361 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Ceph BLOG debugfs interface
+ *
+ * Provides debugfs entries to view and manage BLOG entries for Ceph
+ */
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/jiffies.h>
+#include <linux/timekeeping.h>
+#include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/ceph_blog.h>
+#include <linux/blog/blog.h>
+#include <linux/blog/blog_des.h>
+
+static struct dentry *ceph_blog_debugfs_dir;
+
+static int jiffies_to_formatted_time(u64 jiffies_value, char *buffer,
+	size_t buffer_len);
+
+/**
+ * blog_entries_show - Show all BLOG entries for Ceph
+ *
+ * Iterates through all contexts and their pagefrags, deserializing entries
+ * using BLOG's deserialization with Ceph's client callback
+ */
+static int blog_entries_show(struct seq_file *s, void *p)
+{
+	LIST_HEAD(snapshot);
+	struct blog_tls_ctx *ctx;
+	struct blog_log_iter iter;
+	struct blog_log_entry *entry;
+	char output_buf[1024];
+	int ret;
+	int entry_count = 0;
+	int ctx_count = 0;
+
+	if (!ceph_blog_ctx || !ceph_blog_ctx->logger) {
+		seq_puts(s, "Ceph BLOG context not initialized\n");
+		return 0;
+	}
+
+	/* Detach the current context list so producers can continue unhindered */
+	spin_lock(&ceph_blog_ctx->logger->lock);
+	list_splice_init(&ceph_blog_ctx->logger->contexts, &snapshot);
+	spin_unlock(&ceph_blog_ctx->logger->lock);
+
+	list_for_each_entry(ctx, &snapshot, list) {
+		struct blog_pagefrag *pf = blog_ctx_pf(ctx);
+		u64 head;
+
+		ctx_count++;
+
+		/* Lock to prevent buffer reset/recycling during iteration */
+		spin_lock(&pf->lock);
+		head = pf->head;
+
+		if (!head) {
+			spin_unlock(&pf->lock);
+			continue;
+		}
+
+		/* Initialize iterator with head snapshot, iterate in-place */
+		blog_log_iter_init(&iter, pf, head);
+
+		while ((entry = blog_log_iter_next(&iter)) != NULL) {
+			entry_count++;
+			memset(output_buf, 0, sizeof(output_buf));
+			ret = blog_des_entry(ceph_blog_ctx->logger, entry, output_buf,
+				     sizeof(output_buf), ceph_blog_client_des_callback);
+			if (ret < 0) {
+				seq_printf(s, "[Error deserializing entry %d: %d]\n",
+					   entry_count, ret);
+			} else {
+				char time_buf[64];
+				u64 entry_jiffies = ctx->base_jiffies + entry->ts_delta;
+				if (jiffies_to_formatted_time(entry_jiffies, time_buf,
+					sizeof(time_buf)) < 0)
+					strscpy(time_buf, "(invalid)", sizeof(time_buf));
+				seq_printf(s, "%s %s\n", time_buf, output_buf);
+			}
+		}
+
+		spin_unlock(&pf->lock);
+	}
+
+	/* Merge snapshot back into main list, preserving any new contexts */
+	spin_lock(&ceph_blog_ctx->logger->lock);
+	list_splice_tail_init(&snapshot, &ceph_blog_ctx->logger->contexts);
+	spin_unlock(&ceph_blog_ctx->logger->lock);
+
+	return 0;
+}
+
+static int blog_entries_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, blog_entries_show, inode->i_private);
+}
+
+static const struct file_operations blog_entries_fops = {
+	.open = blog_entries_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/**
+ * blog_stats_show - Show BLOG statistics
+ */
+static int blog_stats_show(struct seq_file *s, void *p)
+{
+	seq_puts(s, "Ceph BLOG Statistics\n");
+	seq_puts(s, "====================\n\n");
+
+	if (!ceph_blog_ctx || !ceph_blog_ctx->logger) {
+		seq_puts(s, "Ceph BLOG context not initialized\n");
+		return 0;
+	}
+
+	seq_puts(s, "Ceph Module Logger State:\n");
+	seq_printf(s, "  Total contexts allocated: %lu\n",
+		   ceph_blog_ctx->logger->total_contexts_allocated);
+	seq_printf(s, "  Next context ID: %llu\n", ceph_blog_ctx->logger->next_ctx_id);
+	seq_printf(s, "  Next source ID: %u\n",
+		   atomic_read(&ceph_blog_ctx->logger->next_source_id));
+
+	seq_puts(s, "\nAllocation Batch:\n");
+	seq_printf(s, "  Full magazines: %u\n", ceph_blog_ctx->logger->alloc_batch.nr_full);
+	seq_printf(s, "  Empty magazines: %u\n", ceph_blog_ctx->logger->alloc_batch.nr_empty);
+
+	seq_puts(s, "\nLog Batch:\n");
+	seq_printf(s, "  Full magazines: %u\n", ceph_blog_ctx->logger->log_batch.nr_full);
+	seq_printf(s, "  Empty magazines: %u\n", ceph_blog_ctx->logger->log_batch.nr_empty);
+
+	return 0;
+}
+
+static int blog_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, blog_stats_show, inode->i_private);
+}
+
+static const struct file_operations blog_stats_fops = {
+	.open = blog_stats_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/**
+ * blog_sources_show - Show all registered source locations
+ */
+static int blog_sources_show(struct seq_file *s, void *p)
+{
+	struct blog_source_info *source;
+	u32 id;
+	int count = 0;
+
+	seq_puts(s, "Ceph BLOG Source Locations\n");
+	seq_puts(s, "===========================\n\n");
+
+	if (!ceph_blog_ctx || !ceph_blog_ctx->logger) {
+		seq_puts(s, "Ceph BLOG context not initialized\n");
+		return 0;
+	}
+
+	for (id = 1; id < BLOG_MAX_SOURCE_IDS; id++) {
+		source = blog_get_source_info(ceph_blog_ctx->logger, id);
+		if (!source || !source->file)
+			continue;
+
+		count++;
+		seq_printf(s, "ID %u: %s:%s:%u\n", id,
+			  source->file, source->func, source->line);
+		seq_printf(s, "  Format: %s\n", source->fmt ? source->fmt : "(null)");
+		seq_printf(s, "  Warnings: %d\n", source->warn_count);
+
+#if BLOG_TRACK_USAGE
+		seq_printf(s, "  NAPI usage: %d calls, %d bytes\n",
+			  atomic_read(&source->napi_usage),
+			  atomic_read(&source->napi_bytes));
+		seq_printf(s, "  Task usage: %d calls, %d bytes\n",
+			  atomic_read(&source->task_usage),
+			  atomic_read(&source->task_bytes));
+#endif
+		seq_puts(s, "\n");
+	}
+
+	seq_printf(s, "Total registered sources: %d\n", count);
+
+	return 0;
+}
+
+static int blog_sources_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, blog_sources_show, inode->i_private);
+}
+
+static const struct file_operations blog_sources_fops = {
+	.open = blog_sources_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/**
+ * blog_clients_show - Show all registered Ceph clients
+ */
+static int blog_clients_show(struct seq_file *s, void *p)
+{
+	u32 id;
+	int count = 0;
+	const struct ceph_blog_client_info *info;
+
+	seq_puts(s, "Ceph BLOG Registered Clients\n");
+	seq_puts(s, "=============================\n\n");
+
+	for (id = 1; id < CEPH_BLOG_MAX_CLIENTS; id++) {
+		info = ceph_blog_get_client_info(id);
+		if (!info || info->global_id == 0)
+			continue;
+
+		count++;
+
+		seq_printf(s, "Client ID %u:\n", id);
+		seq_printf(s, "  FSID: %pU\n", info->fsid);
+		seq_printf(s, "  Global ID: %llu\n", info->global_id);
+		seq_puts(s, "\n");
+	}
+
+	seq_printf(s, "Total registered clients: %d\n", count);
+
+	return 0;
+}
+
+static int blog_clients_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, blog_clients_show, inode->i_private);
+}
+
+static const struct file_operations blog_clients_fops = {
+	.open = blog_clients_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/**
+ * blog_clear_write - Clear all BLOG entries (write-only)
+ */
+static ssize_t blog_clear_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	char cmd[16];
+
+	if (count >= sizeof(cmd))
+		return -EINVAL;
+
+	if (copy_from_user(cmd, buf, count))
+		return -EFAULT;
+
+	cmd[count] = '\0';
+
+	/* Only accept "clear" command */
+	if (strncmp(cmd, "clear", 5) != 0)
+		return -EINVAL;
+
+	/* Reset all contexts */
+	if (ceph_blog_ctx && ceph_blog_ctx->logger) {
+		struct blog_tls_ctx *tls_ctx;
+
+		spin_lock(&ceph_blog_ctx->logger->lock);
+		list_for_each_entry(tls_ctx, &ceph_blog_ctx->logger->contexts, list) {
+			blog_pagefrag_reset(blog_ctx_pf(tls_ctx));
+		}
+		spin_unlock(&ceph_blog_ctx->logger->lock);
+		pr_info("ceph: BLOG entries cleared via debugfs\n");
+	}
+
+	return count;
+}
+
+static const struct file_operations blog_clear_fops = {
+	.write = blog_clear_write,
+};
+
+/**
+ * ceph_blog_debugfs_init - Initialize Ceph BLOG debugfs entries
+ * @parent: Parent debugfs directory (usually ceph root)
+ *
+ * Return: 0 on success, negative error code on failure
+ */
+int ceph_blog_debugfs_init(struct dentry *parent)
+{
+	if (!parent)
+		return -EINVAL;
+
+	/* Create blog subdirectory */
+	ceph_blog_debugfs_dir = debugfs_create_dir("blog", parent);
+	if (!ceph_blog_debugfs_dir)
+		return -ENOMEM;
+
+	/* Create debugfs entries */
+	debugfs_create_file("entries", 0444, ceph_blog_debugfs_dir, NULL,
+			   &blog_entries_fops);
+
+	debugfs_create_file("stats", 0444, ceph_blog_debugfs_dir, NULL,
+			   &blog_stats_fops);
+
+	debugfs_create_file("sources", 0444, ceph_blog_debugfs_dir, NULL,
+			   &blog_sources_fops);
+
+	debugfs_create_file("clients", 0444, ceph_blog_debugfs_dir, NULL,
+			   &blog_clients_fops);
+
+	debugfs_create_file("clear", 0200, ceph_blog_debugfs_dir, NULL,
+			   &blog_clear_fops);
+
+	pr_info("ceph: BLOG debugfs initialized\n");
+	return 0;
+}
+EXPORT_SYMBOL(ceph_blog_debugfs_init);
+
+/**
+ * ceph_blog_debugfs_cleanup - Clean up Ceph BLOG debugfs entries
+ */
+void ceph_blog_debugfs_cleanup(void)
+{
+	debugfs_remove_recursive(ceph_blog_debugfs_dir);
+	ceph_blog_debugfs_dir = NULL;
+	pr_info("ceph: BLOG debugfs cleaned up\n");
+}
+EXPORT_SYMBOL(ceph_blog_debugfs_cleanup);
+
+static int jiffies_to_formatted_time(u64 jiffies_value, char *buffer,
+	size_t buffer_len)
+{
+	u64 now_ns = ktime_get_real_ns();
+	u64 now_jiffies = get_jiffies_64();
+	u64 delta_jiffies = (now_jiffies > jiffies_value) ?
+		now_jiffies - jiffies_value : 0;
+	u64 delta_ns = jiffies64_to_nsecs(delta_jiffies);
+	u64 event_ns = (delta_ns > now_ns) ? 0 : now_ns - delta_ns;
+	struct timespec64 event_ts = ns_to_timespec64(event_ns);
+	struct tm tm_time;
+
+	if (!buffer || !buffer_len)
+		return -EINVAL;
+
+	time64_to_tm(event_ts.tv_sec, 0, &tm_time);
+
+	return scnprintf(buffer, buffer_len,
+			"%04ld-%02d-%02d %02d:%02d:%02d.%03lu",
+			tm_time.tm_year + 1900, tm_time.tm_mon + 1, tm_time.tm_mday,
+			tm_time.tm_hour, tm_time.tm_min, tm_time.tm_sec,
+			(unsigned long)(event_ts.tv_nsec / NSEC_PER_MSEC));
+}
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index f3fe786b4143..9b9c89b88fca 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -9,11 +9,18 @@
 #include <linux/seq_file.h>
 #include <linux/math64.h>
 #include <linux/ktime.h>
+#include <linux/jiffies.h>
+#include <linux/timekeeping.h>
+#include <linux/rtc.h>
+#include <linux/printk.h>
+#include <linux/time.h>
+#include <linux/time_types.h>
 
 #include <linux/ceph/libceph.h>
 #include <linux/ceph/mon_client.h>
 #include <linux/ceph/auth.h>
 #include <linux/ceph/debugfs.h>
+#include <linux/ceph/ceph_blog.h>
 
 #include "super.h"
 
@@ -360,6 +367,7 @@ static int status_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+
 DEFINE_SHOW_ATTRIBUTE(mdsmap);
 DEFINE_SHOW_ATTRIBUTE(mdsc);
 DEFINE_SHOW_ATTRIBUTE(caps);
@@ -396,7 +404,7 @@ DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
 
 void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 {
-	doutc(fsc->client, "begin\n");
+	boutc(fsc->client, "begin\n");
 	debugfs_remove(fsc->debugfs_bdi);
 	debugfs_remove(fsc->debugfs_congestion_kb);
 	debugfs_remove(fsc->debugfs_mdsmap);
@@ -405,14 +413,20 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 	debugfs_remove(fsc->debugfs_status);
 	debugfs_remove(fsc->debugfs_mdsc);
 	debugfs_remove_recursive(fsc->debugfs_metrics_dir);
-	doutc(fsc->client, "done\n");
+
+#ifdef CONFIG_BLOG
+	/* Clean up BLOG debugfs entries */
+	ceph_blog_debugfs_cleanup();
+#endif
+
+	boutc(fsc->client, "done\n");
 }
 
 void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 {
 	char name[NAME_MAX];
 
-	doutc(fsc->client, "begin\n");
+	boutc(fsc->client, "begin\n");
 	fsc->debugfs_congestion_kb =
 		debugfs_create_file("writeback_congestion_kb",
 				    0600,
@@ -457,6 +471,8 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 						  fsc,
 						  &status_fops);
 
+
+
 	fsc->debugfs_metrics_dir = debugfs_create_dir("metrics",
 						      fsc->client->debugfs_dir);
 
@@ -468,9 +484,14 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 			    &metrics_size_fops);
 	debugfs_create_file("caps", 0400, fsc->debugfs_metrics_dir, fsc,
 			    &metrics_caps_fops);
-	doutc(fsc->client, "done\n");
-}
 
+#ifdef CONFIG_BLOG
+	/* Initialize BLOG debugfs entries */
+	ceph_blog_debugfs_init(fsc->client->debugfs_dir);
+#endif
+
+	boutc(fsc->client, "done\n");
+}
 
 #else  /* CONFIG_DEBUG_FS */
 
@@ -482,4 +503,4 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 {
 }
 
-#endif  /* CONFIG_DEBUG_FS */
+#endif	/* CONFIG_DEBUG_FS */
-- 
2.34.1


