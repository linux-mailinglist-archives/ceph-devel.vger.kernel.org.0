Return-Path: <ceph-devel+bounces-3868-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53132C051EB
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 10:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAE801AE6052
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 08:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E49305E1B;
	Fri, 24 Oct 2025 08:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUmY1oXO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39791307489
	for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 08:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761295407; cv=none; b=O5VwUw2bvLADQ93UoANLUbWiAz7/Bx4RnhrMDYt+iOG4sfRBMA8htBElvduCdOX+70b7y/r7aYqj7g+Wg/lzGCS35dxLaYT7b9wcRzloUtFkSPMWtxr0TjPirI1aqxwW1rglA9x6YCXOb8TkNR/Vqu1VVxaHDQPUF+d2d6tvT7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761295407; c=relaxed/simple;
	bh=k2J2gMjArZ/yw47/ynIXqNlUk3WGhaGemBq0Cs1pdAY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jCimlO6TzwIVJz8LhHwedvKAiz8nt/Te9SspMWV2i0Iq0DPP57676WFoPNWMsqWE3R6VgbiOeM6WMO8lFRPm/MSz3hIFkvtk/6UEkhC8nuUmFrCuvow1hGIbI9ybqqppkL8/P7rhMk6zZAqGtyv8Bn9QRffg249mMxE6jZj2OsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DUmY1oXO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761295400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGIZsxEAApMtTJhdrZZDPTKkHXun+ldVXeO/oMOj7zQ=;
	b=DUmY1oXObada/fnEKadLJy9pM9YS2oHMKvidzt/IX8gmlj41tJT2APEUUE235H221beOFZ
	9T/hAwInY/gulik/v6n4sloRa6gwn2XiFQ04bBvaEtbmXlVb7e+WX5tz28t3KBaTuRrwcb
	Aur5KeyJi0+snpBsOqFUbpgJ+QgdID4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-zOI65EQzP4GmtgLssvpifg-1; Fri, 24 Oct 2025 04:43:17 -0400
X-MC-Unique: zOI65EQzP4GmtgLssvpifg-1
X-Mimecast-MFC-AGG-ID: zOI65EQzP4GmtgLssvpifg_1761295397
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b6d7ad47b58so1245766b.1
        for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 01:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761295396; x=1761900196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGIZsxEAApMtTJhdrZZDPTKkHXun+ldVXeO/oMOj7zQ=;
        b=YCCUqSxKsgRfQjBTuvPaTZ/qijBWqntzEZ1I9kaBtAHJbiL53ubUiTJtMJupEtxrEt
         qDDp8JnTOEXlFCxJ6y36OwW8bqmtXWJ6cqPkD4oadQHKyg07uXhPPLM8+C//kLNz6m6Q
         XTsi5+DYo0xZbu/tEMoEtke8Qni9/JJHlPCDBwfKY4f9nOQPAYB5FUz4JmjrIjdPB+KJ
         ktF4k4BkFsI9eUuNhF/lUEhOcpw2oY+bjf6VGy7VIMzjqCGMQcQP99V8SRjKCedK/DZo
         zjsAV7CLLlIuAQBHkj6yNFdwMv12dgcH6OX0llZiLuc8hlRDYA6AKPN6nM4VQhBHq4qQ
         dc0Q==
X-Gm-Message-State: AOJu0YxxddExKOtrlmMRGVfjE+UBSWOxWNc4g2vIZA2/pkC29a5ypQ+q
	2z6Y23bK3KSlgltAGtDYSPeSEjYMNNrbys9VDp1JJ+fbCW7sy61+WFODqUwGdetE3gMk43Y/z2k
	VvIrdG7gWhi0vNg+hhVhvVwDfWt31Q6uoSIU7vpWgvoMdpXpRLyH2uIfo0B6vseaFjrmgk8Nlh0
	JYkBc7tCeF6bZ73wooZtnPUnMY4CvsVs7IlG7w/FktZxUFZ1F7qhHxZXw=
X-Gm-Gg: ASbGncuikXSjOTOonOuq3h1NPyyvXwIa3ssi7yubWAsDbhTMK93LzKorm3KRkX2PXxd
	BQCk9kbQQLXjiUIRgL2KHEZiECQpcxcRs5LFgQtqcMiTBpJAJNXOSyZB+Zcbbhvk5au6R6lGSea
	kKcCjIIHaypNuqlftDzRFZOZ0I3nUQNuKs9Wv+9p6izry3mIDTikOVHuJg/ww825IJ4Xb6SaPA0
	k1cAp0hjBo+i2nB9HLvP5kdYDWMNiHrKEGa123xdTu5qGJxHLnyQ21h6e64M5pgR/cTHx5121/d
	aHjgCyvYvY/bjY5JnJZCa5XxiNgUMGk2MKXwRzBUSs6VhZw2+VTGs4S0qhF/JLU8HeQAOD7gLuO
	AiYMhb3kQQOyyTL/tTPf8IJWmMU0cmxOf
X-Received: by 2002:a17:907:60c9:b0:b6d:5a98:d33d with SMTP id a640c23a62f3a-b6d5a98db29mr524806966b.31.1761295394978;
        Fri, 24 Oct 2025 01:43:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/aWW9I9e5tPH30rBFMk9ZMjSpfL7MC8eLahNaiClRcvILzwhesDeZRKLaKv/eA9FQo/tV/Q==
X-Received: by 2002:a17:907:60c9:b0:b6d:5a98:d33d with SMTP id a640c23a62f3a-b6d5a98db29mr524798866b.31.1761295393387;
        Fri, 24 Oct 2025 01:43:13 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d010asm469226866b.11.2025.10.24.01.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 01:43:12 -0700 (PDT)
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
Subject: [RFC PATCH 2/5] lib: Introduce BLOG (Binary LOGging) subsystem
Date: Fri, 24 Oct 2025 08:42:56 +0000
Message-Id: <20251024084259.2359693-3-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This commit introduces the BLOG (Binary LOGging) library, a high-throughput
structured logging framework designed for efficient binary log capture in
kernel space with minimal performance impact on hot paths.

BLOG provides a complete logging solution with the following key components:

**Core Infrastructure (blog_core.c, blog.h):**
- Logger registration and lifecycle management
- Per-module logger instances with isolated namespaces
- Source ID tracking for format string registration
- Reference-counted logger cleanup

**Memory Management (blog_batch.c, blog_pagefrag.c):**
- Magazine-based allocator for TLS context pooling
- Lock-free context acquisition/release on hot paths
- Pagefrag-based circular buffer management
- Efficient buffer recycling and capacity tracking

**Serialization Framework (blog_ser.h):**
- Compile-time type-safe serialization macros
- Efficient binary encoding with minimal overhead
- Support for all primitive types, strings, and binary blobs
- Automatic size calculation and alignment handling

**Deserialization Support (blog_des.c, blog_des.h):**
- Iterator-based deserialization for userspace consumption
- Format string resolution and parameter extraction
- Entry validation and boundary checking
- Designed for debugfs export and analysis tools

**Module Integration (blog_module.c, blog_module.h):**
- Per-task TLS context management
- Module-specific logger registration
- Context list tracking for debugfs enumeration
- Automatic context initialization and cleanup

**Configuration (lib/blog/Kconfig):**
- CONFIG_BLOG: Master switch for BLOG subsystem
- Default buffer size and capacity tuning options
- Integration with kernel build system

The implementation includes all correctness fixes for the serialization path:
- Proper handling of parameter-less log messages
- Correct reserve/publish size rounding to prevent buffer overlap
- Accurate entry length tracking for deserialization
- Proper locking for context snapshots to prevent deadlocks

After this commit, BLOG builds cleanly when CONFIG_BLOG is enabled but
remains unused by the kernel. No logging is performed until subsystems
explicitly register loggers and wire in the TLS context hooks. Subsequent
commits will integrate BLOG into the Ceph filesystem as a reference
implementation.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 include/linux/blog/blog.h          | 515 +++++++++++++++++++
 include/linux/blog/blog_batch.h    |  54 ++
 include/linux/blog/blog_des.h      |  46 ++
 include/linux/blog/blog_module.h   | 329 ++++++++++++
 include/linux/blog/blog_pagefrag.h |  33 ++
 include/linux/blog/blog_ser.h      | 275 ++++++++++
 lib/Kconfig                        |   2 +
 lib/Makefile                       |   2 +
 lib/blog/Kconfig                   |  56 +++
 lib/blog/Makefile                  |  15 +
 lib/blog/blog_batch.c              | 311 ++++++++++++
 lib/blog/blog_core.c               | 772 ++++++++++++++++++++++++++++
 lib/blog/blog_des.c                | 385 ++++++++++++++
 lib/blog/blog_module.c             | 781 +++++++++++++++++++++++++++++
 lib/blog/blog_pagefrag.c           | 124 +++++
 15 files changed, 3700 insertions(+)
 create mode 100644 include/linux/blog/blog.h
 create mode 100644 include/linux/blog/blog_batch.h
 create mode 100644 include/linux/blog/blog_des.h
 create mode 100644 include/linux/blog/blog_module.h
 create mode 100644 include/linux/blog/blog_pagefrag.h
 create mode 100644 include/linux/blog/blog_ser.h
 create mode 100644 lib/blog/Kconfig
 create mode 100644 lib/blog/Makefile
 create mode 100644 lib/blog/blog_batch.c
 create mode 100644 lib/blog/blog_core.c
 create mode 100644 lib/blog/blog_des.c
 create mode 100644 lib/blog/blog_module.c
 create mode 100644 lib/blog/blog_pagefrag.c

diff --git a/include/linux/blog/blog.h b/include/linux/blog/blog.h
new file mode 100644
index 000000000000..6d93ff31732e
--- /dev/null
+++ b/include/linux/blog/blog.h
@@ -0,0 +1,515 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Binary Logging Infrastructure (BLOG)
+ *
+ * Generic binary logging infrastructure for kernel subsystems.
+ * Modules maintain their own client mappings and debugfs interfaces.
+ */
+#ifndef _LINUX_BLOG_H
+#define _LINUX_BLOG_H
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/blog/blog_batch.h>
+#include <linux/blog/blog_pagefrag.h>
+#include <linux/blog/blog_ser.h>
+#include <linux/blog/blog_des.h>
+
+struct blog_module_context;
+
+/* Debug configuration */
+#ifdef CONFIG_BLOG_DEBUG
+#define BLOG_DEBUG_POISON 1
+#else
+#define BLOG_DEBUG_POISON 0
+#endif
+
+#ifdef CONFIG_BLOG_TRACK_USAGE
+#define BLOG_TRACK_USAGE 1
+#else
+#define BLOG_TRACK_USAGE 0
+#endif
+
+/* Debug poison values */
+#if BLOG_DEBUG_POISON
+#define BLOG_LOG_ENTRY_POISON 0xD1E7C0DE
+#define BLOG_CTX_POISON 0xCAFEBABE
+#endif
+
+/* No global logger - all logging must use per-module contexts */
+
+/* Maximum values */
+#define BLOG_MAX_PAYLOAD 255
+#ifdef CONFIG_BLOG_MAX_SOURCES
+#define BLOG_MAX_SOURCE_IDS CONFIG_BLOG_MAX_SOURCES
+#else
+#define BLOG_MAX_SOURCE_IDS 4096
+#endif
+#ifdef CONFIG_BLOG_MAX_CLIENTS
+#define BLOG_MAX_CLIENT_IDS CONFIG_BLOG_MAX_CLIENTS
+#else
+#define BLOG_MAX_CLIENT_IDS 256
+#endif
+
+/**
+ * struct blog_source_info - Source location metadata for log entries
+ * @file: Source file name (from __FILE__)
+ * @func: Function name (from __func__)
+ * @line: Line number (from __LINE__)
+ * @fmt: Printf-style format string for this log site
+ * @warn_count: Number of warnings issued from this site
+ * @napi_usage: Number of times logged from NAPI context (if BLOG_TRACK_USAGE)
+ * @task_usage: Number of times logged from task context (if BLOG_TRACK_USAGE)
+ * @napi_bytes: Total bytes logged from NAPI (if BLOG_TRACK_USAGE)
+ * @task_bytes: Total bytes logged from task (if BLOG_TRACK_USAGE)
+ *
+ * Maps source IDs to their original source locations. One entry per unique
+ * file:func:line location. The format string is stored here for use during
+ * deserialization to reconstruct the original log message.
+ */
+struct blog_source_info {
+	const char *file;
+	const char *func;
+	unsigned int line;
+	const char *fmt;
+	int warn_count;
+#if BLOG_TRACK_USAGE
+	atomic_t napi_usage;
+	atomic_t task_usage;
+	atomic_t napi_bytes;
+	atomic_t task_bytes;
+#endif
+};
+
+/**
+ * struct blog_log_entry - Binary log entry header and payload
+ * @debug_poison: Magic value for corruption detection (if BLOG_DEBUG_POISON)
+ * @ts_delta: Timestamp delta from context's base_jiffies
+ * @source_id: Source location ID (index into source_map)
+ * @len: Length of serialized data in buffer (max 255)
+ * @client_id: Module-specific client identifier
+ * @flags: Reserved for future use
+ * @buffer: Variable-length serialized argument data
+ *
+ * Wire format for a single log entry. Entries are stored sequentially in
+ * the pagefrag buffer. The buffer contains binary-serialized arguments
+ * that match the format string stored in source_map[source_id].
+ */
+struct blog_log_entry {
+#if BLOG_DEBUG_POISON
+	u64 debug_poison;
+#endif
+	u32 ts_delta;
+	u16 source_id;
+	u8 len;
+	u8 client_id;
+	u8 flags;
+	char buffer[];
+};
+
+/**
+ * struct blog_tls_ctx - Per-task (or NAPI) logging context
+ * @list: Linkage in logger's contexts list
+ * @release: Cleanup function called on context destruction
+ * @refcount: Reference count (0=in batch, 1=active)
+ * @task: Associated task (NULL for NAPI contexts)
+ * @pid: Process ID of associated task
+ * @comm: Command name of associated task
+ * @id: Unique context ID (for debugging)
+ * @debug_poison: Magic value for corruption detection (if BLOG_DEBUG_POISON)
+ * @base_jiffies: Base timestamp for delta calculation
+ * @logger: Parent logger instance
+ *
+ * Each task (or CPU for NAPI) has its own logging context. The context
+ * is embedded in a blog_tls_pagefrag composite which contains the inline
+ * 512KB buffer. Use blog_ctx_pf() to access the pagefrag allocator.
+ * Contexts are recycled through magazine batching system.
+ *
+ * NOTE: struct blog_pagefrag pf has been REMOVED from this structure.
+ * It now lives in the composite (blog_tls_pagefrag). Use blog_ctx_pf(ctx)
+ * to access it. This ensures the pagefrag points to the inline buffer.
+ */
+struct blog_tls_ctx {
+	struct list_head list;
+	void (*release)(void *data);
+	atomic_t refcount;
+	struct task_struct *task;
+	pid_t pid;
+	char comm[TASK_COMM_LEN];
+	u64 id;
+	u64 debug_poison;
+	unsigned long base_jiffies;
+	struct blog_logger *logger;
+	int pending_offset;	/* Offset of reserved but not yet published entry */
+	size_t pending_size;	/* Size of reserved entry */
+};
+
+/**
+ * struct blog_tls_pagefrag - Composite allocation unit for TLS contexts
+ * @ctx: TLS context metadata (refcount, release hook, task info)
+ * @pf: Embedded pagefrag allocator (counters + lock)
+ * @buf: Flexible array for log entries
+ *
+ * This composite structure combines the TLS context header with its
+ * logging buffer into a single allocation unit. Total allocation is
+ * exactly BLOG_PAGEFRAG_SIZE (512KB), with the buffer occupying the
+ * remainder after the header: BLOG_PAGEFRAG_SIZE - sizeof(struct blog_tls_pagefrag).
+ *
+ * The composites flow through the batching system:
+ * alloc_batch (empty) → in-use (filling) → log_batch (full, readable)
+ * → drain → reset → back to alloc_batch.
+ *
+ * The buffer ensures no separate alloc_pages() calls are needed
+ * on the hot path. The pagefrag's buffer pointer is initialized to point
+ * at buf[], and serialization starts at offset 0 within buf[] (which is
+ * already positioned after the metadata).
+ */
+struct blog_tls_pagefrag {
+	struct blog_tls_ctx ctx;
+	struct blog_pagefrag pf;
+	unsigned char buf[];
+};
+
+/* Total allocation is exactly 512KB - buffer size is the remainder after header */
+#define BLOG_TLS_PAGEFRAG_ALLOC_SIZE BLOG_PAGEFRAG_SIZE
+#define BLOG_TLS_PAGEFRAG_BUFFER_SIZE \
+	(BLOG_PAGEFRAG_SIZE - sizeof(struct blog_tls_pagefrag))
+
+/**
+ * struct blog_logger - Per-module logger instance
+ * @contexts: List of all TLS contexts for this logger
+ * @lock: Protects contexts list
+ * @alloc_batch: Magazine batch for context allocation
+ * @log_batch: Magazine batch for completed log contexts
+ * @source_map: Array mapping source IDs to source info (max 4096)
+ * @next_source_id: Next source ID to assign
+ * @source_lock: Protects source map operations
+ * @total_contexts_allocated: Total number of contexts created
+ * @next_ctx_id: Next context ID to assign
+ * @ctx_id_lock: Protects context ID counter
+ * @napi_ctxs: Per-CPU NAPI context pointers
+ *
+ * Each module has its own logger instance with isolated source ID space,
+ * context list, and batching system. Composites are allocated via alloc_pages()
+ * since they're 512KB each - too large for slab allocator.
+ */
+struct blog_logger {
+	struct list_head contexts;
+	spinlock_t lock;		/* protects contexts list */
+	struct blog_batch alloc_batch;
+	struct blog_batch log_batch;
+	struct kmem_cache *magazine_cache; /* Shared cache for magazine structs */
+	struct blog_source_info
+		source_map[BLOG_MAX_SOURCE_IDS];
+	atomic_t next_source_id;
+	spinlock_t source_lock;	/* protects source_ids table */
+	unsigned long total_contexts_allocated;
+	u64 next_ctx_id;
+	spinlock_t ctx_id_lock;	/* protects next_ctx_id */
+	struct blog_tls_ctx *__percpu
+		*napi_ctxs;
+	u8 slot_id;
+	bool has_slot;
+	struct blog_module_context *owner_ctx;
+};
+
+/**
+ * struct blog_log_iter - Iterator for reading log entries from a pagefrag
+ * @pf: Pagefrag being iterated
+ * @current_offset: Current read position in pagefrag
+ * @end_offset: End position (pf->head at iteration start)
+ * @prev_offset: Previous offset (for debugging)
+ * @steps: Number of entries iterated so far
+ *
+ * Used to walk through all log entries in a pagefrag sequentially.
+ * Initialize with blog_log_iter_init(), then call blog_log_iter_next()
+ * repeatedly until it returns NULL.
+ */
+struct blog_log_iter {
+	struct blog_pagefrag *pf;
+	u64 current_offset;
+	u64 end_offset;
+	u64 prev_offset;
+	u64 steps;
+};
+
+/* Client deserialization callback type */
+typedef int (*blog_client_des_fn)(char *buf, size_t size, u8 client_id);
+
+/* Core API functions - all require valid logger parameter */
+
+/**
+ * blog_get_source_id - Get or allocate a unique source ID for a log location
+ * @logger: Logger instance to use
+ * @file: Source file name (typically kbasename(__FILE__))
+ * @func: Function name (typically __func__)
+ * @line: Line number (typically __LINE__)
+ * @fmt: Printf-style format string for this log site
+ *
+ * Assigns a unique source ID to a specific file:func:line location. The ID
+ * is typically cached in a static variable at the call site for fast lookup.
+ * The format string is stored in the logger's source map for later
+ * deserialization.
+ *
+ * Context: Can be called from any context (process, softirq, hardirq)
+ * Return: Source ID (1 to BLOG_MAX_SOURCE_IDS-1), or 0 on error
+ */
+u32 blog_get_source_id(struct blog_logger *logger, const char *file,
+		       const char *func, unsigned int line, const char *fmt);
+
+/**
+ * blog_get_source_info - Retrieve source information for a given source ID
+ * @logger: Logger instance to query
+ * @id: Source ID to look up
+ *
+ * Retrieves the file, function, line, and format string associated with
+ * a source ID. Used during deserialization to reconstruct log messages.
+ *
+ * Context: Any context
+ * Return: Pointer to source_info structure, or NULL if ID is invalid
+ */
+struct blog_source_info *blog_get_source_info(struct blog_logger *logger,
+					      u32 id);
+
+/**
+ * blog_log - Reserve buffer for a binary log message
+ * @logger: Logger instance to use
+ * @source_id: Source ID for this log location (from blog_get_source_id)
+ * @client_id: Module-specific client identifier (0 if not used)
+ * @needed_size: Size in bytes needed for serialized arguments
+ *
+ * Reserves space in the current context's pagefrag for a log entry and
+ * returns a buffer pointer for the caller to serialize arguments into.
+ * The log entry header (timestamp, source_id, etc.) is filled automatically.
+ *
+ * The reserved space is NOT visible to readers until blog_log_commit() is
+ * called after serialization completes. This prevents readers from seeing
+ * partially-written entries.
+ *
+ * If allocation fails, the pagefrag is reset and retried up to 3 times.
+ * Payload must not exceed BLOG_MAX_PAYLOAD (255 bytes).
+ *
+ * Context: Process or softirq (automatically selects appropriate context)
+ * Return: Buffer pointer to write serialized data, or NULL on failure
+ */
+void *blog_log(struct blog_logger *logger, u32 source_id, u8 client_id,
+	       size_t needed_size);
+
+/**
+ * blog_log_commit - Publish a reserved log entry
+ * @logger: Logger instance
+ * @actual_size: Actual bytes written during serialization
+ *
+ * Publishes the log entry that was reserved by the last blog_log() call,
+ * making it visible to readers. Must be called after serialization is complete.
+ *
+ * The actual_size should be the number of bytes actually written, which may be
+ * less than the worst-case size reserved (e.g., strings may be shorter than 255).
+ *
+ * Uses memory barrier to ensure all writes are visible before making entry
+ * visible to readers.
+ *
+ * Context: Same context as the preceding blog_log() call
+ * Return: 0 on success, negative error code on failure
+ */
+int blog_log_commit(struct blog_logger *logger, size_t actual_size);
+
+/**
+ * blog_get_tls_ctx - Get or create per-task logging context
+ * @logger: Logger instance to use
+ *
+ * Returns the BLOG context for the current task, creating it if needed.
+ * Each task has a 512KB pagefrag buffer for logging. This function should
+ * not be called directly - use blog_get_ctx() instead.
+ *
+ * Context: Process context only (uses current task)
+ * Return: TLS context pointer, or NULL on allocation failure
+ */
+struct blog_tls_ctx *blog_get_tls_ctx(struct blog_logger *logger);
+
+/**
+ * blog_get_napi_ctx - Get NAPI logging context for current CPU
+ * @logger: Logger instance to use
+ *
+ * Returns the NAPI (softirq) context for the current CPU. NAPI contexts
+ * must be explicitly set via blog_set_napi_ctx() before use.
+ *
+ * Context: Softirq context
+ * Return: NAPI context pointer, or NULL if not set
+ */
+struct blog_tls_ctx *blog_get_napi_ctx(struct blog_logger *logger);
+
+/**
+ * blog_set_napi_ctx - Set NAPI logging context for current CPU
+ * @logger: Logger instance
+ * @ctx: Context to associate with this CPU's NAPI processing
+ *
+ * Associates a logging context with the current CPU for use during
+ * softirq (NAPI) processing. This allows network drivers and other
+ * softirq handlers to log without accessing per-task contexts.
+ *
+ * Context: Any context (typically called during initialization)
+ * Return: void
+ */
+void blog_set_napi_ctx(struct blog_logger *logger, struct blog_tls_ctx *ctx);
+
+/**
+ * blog_get_ctx - Get appropriate logging context based on execution context
+ * @logger: Logger instance to use
+ *
+ * Automatically selects the correct context:
+ * - Softirq context: Returns NAPI context (or falls back to TLS)
+ * - Process context: Returns per-task TLS context
+ *
+ * This is the recommended function for getting contexts.
+ *
+ * Context: Any context
+ * Return: Logging context pointer, or NULL on failure
+ */
+struct blog_tls_ctx *blog_get_ctx(struct blog_logger *logger);
+
+/**
+ * blog_log_iter_init - Initialize iterator for reading log entries
+ * @iter: Iterator structure to initialize
+ * @pf: Pagefrag containing log entries to iterate over
+ * @head_snapshot: Snapshot of pf->head at lock acquisition time
+ *
+ * Prepares an iterator to walk through all log entries in a pagefrag.
+ * The head_snapshot parameter defines the boundary - only entries up to
+ * this offset will be iterated. Caller must hold pf->lock throughout
+ * iteration to prevent buffer reset/recycling.
+ *
+ * Context: Any context
+ * Return: void
+ */
+void blog_log_iter_init(struct blog_log_iter *iter, struct blog_pagefrag *pf,
+			u64 head_snapshot);
+
+/**
+ * blog_log_iter_next - Get next log entry from iterator
+ * @iter: Iterator previously initialized with blog_log_iter_init()
+ *
+ * Advances the iterator to the next log entry in the pagefrag.
+ * Entries are returned in chronological order (order they were logged).
+ *
+ * IMPORTANT: Caller must hold pf->lock for the entire duration of iteration
+ * (from blog_log_iter_init() through all blog_log_iter_next() calls until
+ * iteration completes). This prevents blog_pagefrag_reset() from clearing
+ * the buffer mid-iteration. Writers remain lockless and never take pf->lock.
+ *
+ * Context: Any context, with pf->lock held
+ * Return: Pointer to next log entry, or NULL when no more entries
+ */
+struct blog_log_entry *blog_log_iter_next(struct blog_log_iter *iter);
+
+/**
+ * blog_des_entry - Deserialize a log entry into human-readable format
+ * @logger: Logger instance (for source map lookup)
+ * @entry: Log entry to deserialize
+ * @output: Buffer to write formatted string to
+ * @out_size: Size of output buffer in bytes
+ * @client_cb: Optional callback to handle module-specific client_id formatting
+ *
+ * Reconstructs a formatted log message from binary log entry. Uses the
+ * source_id to look up the format string, then deserializes the entry's
+ * buffer according to the format specifiers.
+ *
+ * If client_cb is provided, it's called to format the client_id prefix.
+ * Otherwise, client_id is ignored.
+ *
+ * Context: Any context
+ * Return: Number of bytes written to output buffer, or negative error code
+ */
+int blog_des_entry(struct blog_logger *logger, struct blog_log_entry *entry,
+		   char *output, size_t out_size,
+		   blog_client_des_fn client_cb);
+
+/**
+ * blog_logger_print_stats - Print logger statistics to kernel log
+ * @logger: Logger instance to print stats for
+ *
+ * Debug helper that prints current state of logger's batching system
+ * and context counts. Output goes to kernel log at debug level.
+ *
+ * Context: Any context
+ * Return: void
+ */
+static inline void blog_logger_print_stats(struct blog_logger *logger)
+{
+	pr_debug(
+		"blog: total_contexts=%lu, alloc_batch={empty=%d, full=%d}, log_batch={empty=%d, full=%d}\n",
+		logger->total_contexts_allocated, logger->alloc_batch.nr_empty,
+		logger->alloc_batch.nr_full, logger->log_batch.nr_empty,
+		logger->log_batch.nr_full);
+}
+
+/**
+ * blog_is_valid_kernel_addr - Check if address is in valid kernel range
+ * @addr: Address to validate
+ *
+ * Verifies that an address points to valid kernel memory using
+ * virt_addr_valid(). Used internally for sanity checking.
+ *
+ * Context: Any context
+ * Return: true if address is valid, false otherwise
+ */
+bool blog_is_valid_kernel_addr(const void *addr);
+
+/**
+ * blog_ctx_container - Get composite container from TLS context pointer
+ * @ctx: TLS context pointer
+ *
+ * Returns the containing blog_tls_pagefrag composite that holds this context.
+ * Used internally to access the inline buffer and pagefrag fields.
+ *
+ * Context: Any context
+ * Return: Pointer to containing blog_tls_pagefrag composite
+ */
+static inline struct blog_tls_pagefrag *blog_ctx_container(struct blog_tls_ctx *ctx)
+{
+	return container_of(ctx, struct blog_tls_pagefrag, ctx);
+}
+
+/**
+ * blog_ctx_buffer - Get inline buffer pointer from TLS context
+ * @ctx: TLS context pointer
+ *
+ * Returns pointer to the 512KB inline buffer within the composite.
+ * This buffer is where log entries are stored.
+ *
+ * Context: Any context
+ * Return: Pointer to inline buffer
+ */
+static inline void *blog_ctx_buffer(struct blog_tls_ctx *ctx)
+{
+	return blog_ctx_container(ctx)->buf;
+}
+
+/**
+ * blog_ctx_pf - Get pagefrag structure from TLS context
+ * @ctx: TLS context pointer
+ *
+ * Returns pointer to the embedded pagefrag allocator within the composite.
+ * The pagefrag's buffer pointer is initialized to point at the inline buffer.
+ *
+ * Context: Any context
+ * Return: Pointer to embedded pagefrag structure
+ */
+static inline struct blog_pagefrag *blog_ctx_pf(struct blog_tls_ctx *ctx)
+{
+	return &blog_ctx_container(ctx)->pf;
+}
+
+/*
+ * No global logging macros - all logging must use per-module contexts
+ * Use BLOG_LOG_CTX() and BLOG_LOG_CLIENT_CTX() from blog_module.h instead
+ */
+
+/*
+ * These low-level logger macros are deprecated.
+ * Use BLOG_LOG_CTX() and BLOG_LOG_CLIENT_CTX() from blog_module.h instead.
+ */
+
+#endif /* _LINUX_BLOG_H */
diff --git a/include/linux/blog/blog_batch.h b/include/linux/blog/blog_batch.h
new file mode 100644
index 000000000000..9752272a66fe
--- /dev/null
+++ b/include/linux/blog/blog_batch.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Binary Logging Batch Management
+ */
+#ifndef _LINUX_BLOG_BATCH_H
+#define _LINUX_BLOG_BATCH_H
+
+#include <linux/types.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+/* Size of each magazine (number of elements it can hold) */
+#define BLOG_MAGAZINE_SIZE 16
+
+/* Structure representing a single magazine */
+struct blog_magazine {
+	struct list_head list;      /* For linking in global pools */
+	unsigned int count;         /* Number of elements currently in magazine */
+	void *elements[BLOG_MAGAZINE_SIZE];
+};
+
+/* Per-CPU magazine state */
+struct blog_cpu_magazine {
+	struct blog_magazine *mag;  /* Current magazine for this CPU */
+};
+
+/* Global magazine pools */
+struct blog_batch {
+	struct list_head full_magazines;   /* List of full magazines */
+	struct list_head empty_magazines;  /* List of empty magazines */
+	spinlock_t full_lock;              /* Protects full magazine list and count */
+	spinlock_t empty_lock;             /* Protects empty magazine list and count */
+	unsigned int nr_full;              /* Protected by full_lock */
+	unsigned int nr_empty;             /* Protected by empty_lock */
+	struct blog_cpu_magazine __percpu *cpu_magazines; /* Per-CPU magazines */
+	struct kmem_cache *magazine_cache; /* Cache for magazine structures themselves */
+	bool external_cache;               /* True when magazine_cache owned by caller */
+};
+
+/* Initialize the batching system */
+int blog_batch_init(struct blog_batch *batch, struct kmem_cache *mag_cache,
+		    bool prepopulate);
+
+/* Clean up the batching system */
+void blog_batch_cleanup(struct blog_batch *batch);
+
+/* Get an element from the batch */
+void *blog_batch_get(struct blog_batch *batch);
+
+/* Put an element back into the batch */
+void blog_batch_put(struct blog_batch *batch, void *element);
+
+#endif /* _LINUX_BLOG_BATCH_H */
diff --git a/include/linux/blog/blog_des.h b/include/linux/blog/blog_des.h
new file mode 100644
index 000000000000..a9076e89917c
--- /dev/null
+++ b/include/linux/blog/blog_des.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Binary Logging Deserialization
+ */
+#ifndef _LINUX_BLOG_DES_H
+#define _LINUX_BLOG_DES_H
+
+#include <linux/types.h> /* For size_t */
+
+/* Forward declarations */
+struct blog_log_entry;
+struct blog_logger;
+
+/**
+ * blog_des_reconstruct - Reconstructs a formatted string from serialized values
+ * @fmt: Format string containing % specifiers
+ * @buffer: Buffer containing serialized values
+ * @nr_args: Number of arguments to process
+ * @size: Size of the buffer in bytes
+ * @out: Buffer to store the reconstructed string
+ * @out_size: Size of the output buffer
+ *
+ * The function uses the format string to determine the types and number of values
+ * to extract from the buffer.
+ *
+ * Return: Number of bytes written to out buffer, or negative error code on failure
+ */
+int blog_des_reconstruct(const char *fmt, const void *buffer, size_t nr_args,
+			  size_t size, char *out, size_t out_size);
+
+/**
+ * blog_log_reconstruct - Reconstructs a formatted string from a log entry
+ * @entry: Log entry containing serialized data
+ * @output: Buffer to write the formatted string to
+ * @output_size: Size of the output buffer
+ *
+ * This is a wrapper around blog_des_reconstruct that handles log entry parsing.
+ * Note: This does NOT handle client_id - the caller should handle that separately
+ * using their module-specific callback.
+ *
+ * Return: Length of formatted string, or negative error code on failure
+ */
+int blog_log_reconstruct(struct blog_logger *logger, const struct blog_log_entry *entry,
+			char *output, size_t output_size);
+
+#endif /* _LINUX_BLOG_DES_H */
diff --git a/include/linux/blog/blog_module.h b/include/linux/blog/blog_module.h
new file mode 100644
index 000000000000..06397204027b
--- /dev/null
+++ b/include/linux/blog/blog_module.h
@@ -0,0 +1,329 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Binary Logging Infrastructure (BLOG) - Per-Module Support
+ *
+ * This header defines the per-module context support for BLOG.
+ * Each kernel module can have its own isolated logging context.
+ */
+#ifndef _LINUX_BLOG_MODULE_H
+#define _LINUX_BLOG_MODULE_H
+
+#include <linux/blog/blog.h>
+
+/**
+ * struct blog_module_context - Per-module BLOG state
+ * @name: Module name (max 31 chars + null terminator)
+ * @slot_id: Assigned slot ID (0-7) in task->blog_contexts array
+ * @logger: Logger instance for this module (isolated from other modules)
+ * @module_private: Opaque pointer for module-specific data
+ * @list: Linkage in global list of all module contexts
+ * @refcount: Reference count for module context lifecycle
+ * @allocated_contexts: Number of contexts currently allocated (includes freed but not yet recycled)
+ * @initialized: True after blog_module_init() succeeds
+ *
+ * Represents a registered BLOG module with its own isolated logger instance,
+ * slot ID for O(1) per-task context access, and independent source ID namespace.
+ * Created via blog_module_init() and destroyed via blog_module_cleanup().
+ */
+struct blog_module_context {
+	char name[32];
+	u8 slot_id;
+	struct blog_logger *logger;
+	void *module_private;
+	struct list_head list;
+	atomic_t refcount;
+	atomic_t allocated_contexts;
+	bool initialized;
+};
+
+/**
+ * struct blog_module_registry - Global registry of all BLOG modules
+ * @modules: Array of registered module contexts (max 8)
+ * @allocated_bitmap: Bitmap of allocated slot IDs (8 bits)
+ * @lock: Protects registration/unregistration operations
+ * @module_count: Number of currently registered modules
+ *
+ * Global singleton that tracks all registered BLOG modules and assigns
+ * slot IDs. Protected by spinlock for thread-safe registration.
+ */
+struct blog_module_registry {
+	struct blog_module_context *modules[BLOG_MAX_MODULES];
+	u8 allocated_bitmap;
+	spinlock_t lock;		/* protects module state */
+	atomic_t module_count;
+};
+
+/* Module registration API */
+
+/**
+ * blog_module_register - Register a module and allocate a slot
+ * @module_name: Name of the module (max 31 chars)
+ *
+ * Registers a module in the global BLOG registry and assigns it a unique
+ * slot ID (0-7). The slot ID is used to index into each task's
+ * blog_contexts array for O(1) per-task context access.
+ *
+ * Only 8 modules can be registered simultaneously (BLOG_MAX_MODULES).
+ *
+ * Context: Process context (uses GFP_KERNEL allocation)
+ * Return: Module context on success, NULL if no slots available or invalid name
+ */
+struct blog_module_context *blog_module_register(const char *module_name);
+
+/**
+ * blog_module_unregister - Unregister a module and free its slot
+ * @ctx: Module context to unregister
+ *
+ * Removes the module from the global registry and frees its slot for reuse.
+ * Must be called after blog_module_cleanup() to ensure all contexts are freed.
+ *
+ * Context: Process context
+ * Return: void
+ */
+void blog_module_unregister(struct blog_module_context *ctx);
+
+/* Module context management API */
+
+/**
+ * blog_module_init - Initialize a per-module BLOG context
+ * @module_name: Name of the module (max 31 chars)
+ *
+ * Creates a complete isolated logging context for a kernel module, including:
+ * - Module registration and slot allocation
+ * - Logger instance with batching system
+ * - Source ID mapping (4096 sources)
+ * - Per-CPU NAPI context support
+ *
+ * This is the main entry point for modules that want to use BLOG.
+ *
+ * Context: Process context (uses GFP_KERNEL allocations)
+ * Return: Module context on success, NULL on failure
+ */
+struct blog_module_context *blog_module_init(const char *module_name);
+
+/**
+ * blog_module_cleanup - Clean up a module's BLOG context
+ * @ctx: Module context to clean up
+ *
+ * Iterates through all tasks that have contexts for this module and
+ * detaches/frees them. Also cleans up batching system and per-CPU
+ * NAPI contexts. Should be called during module unload.
+ *
+ * Warning: This acquires task_lock for every task with a context, which
+ * can be slow if many tasks are using the module.
+ *
+ * Context: Process context
+ * Return: void
+ */
+void blog_module_cleanup(struct blog_module_context *ctx);
+
+/**
+ * blog_module_get - Increment module context reference count
+ * @ctx: Module context
+ *
+ * Takes a reference on the module context to prevent it from being freed.
+ * Must be paired with blog_module_put().
+ *
+ * Context: Any context
+ * Return: void
+ */
+void blog_module_get(struct blog_module_context *ctx);
+
+/**
+ * blog_module_put - Decrement module context reference count
+ * @ctx: Module context
+ *
+ * Releases a reference on the module context. When the last reference
+ * is dropped, the context is automatically cleaned up.
+ *
+ * Context: Any context
+ * Return: void
+ */
+void blog_module_put(struct blog_module_context *ctx);
+
+/* Per-module API functions */
+
+/**
+ * blog_get_source_id_ctx - Get source ID for a module's log location
+ * @ctx: Module context
+ * @file: Source file name (typically kbasename(__FILE__))
+ * @func: Function name (typically __func__)
+ * @line: Line number (typically __LINE__)
+ * @fmt: Printf-style format string
+ *
+ * Per-module wrapper around blog_get_source_id(). Source IDs are
+ * module-local (different modules can have same source_id values).
+ *
+ * Context: Any context
+ * Return: Source ID for this module's logger, or 0 on error
+ */
+u32 blog_get_source_id_ctx(struct blog_module_context *ctx, const char *file,
+			   const char *func, unsigned int line, const char *fmt);
+
+/**
+ * blog_get_source_info_ctx - Get source info for a module-local source ID
+ * @ctx: Module context
+ * @id: Source ID to look up
+ *
+ * Per-module wrapper around blog_get_source_info().
+ *
+ * Context: Any context
+ * Return: Source info pointer, or NULL if invalid
+ */
+struct blog_source_info *blog_get_source_info_ctx(struct blog_module_context *ctx, u32 id);
+
+/**
+ * blog_log_ctx - Log a message using module context
+ * @ctx: Module context
+ * @source_id: Source ID (from blog_get_source_id_ctx)
+ * @client_id: Module-specific client identifier
+ * @needed_size: Size in bytes for serialized arguments
+ *
+ * Per-module wrapper around blog_log(). Uses the module's slot ID to
+ * access the per-task context from task->blog_contexts[slot_id].
+ *
+ * Context: Process or softirq
+ * Return: Buffer pointer for serialization, or NULL on failure
+ */
+void *blog_log_ctx(struct blog_module_context *ctx, u32 source_id,
+			u8 client_id, size_t needed_size);
+
+/**
+ * blog_get_tls_ctx_ctx - Get or create per-task context for this module
+ * @ctx: Module context
+ *
+ * Gets the logging context for current task and this specific module.
+ * Uses slot-based access: task->blog_contexts[ctx->slot_id].
+ * Creates the context on first use (lazy allocation).
+ *
+ * Context: Process context only
+ * Return: TLS context pointer, or NULL on allocation failure
+ */
+struct blog_tls_ctx *blog_get_tls_ctx_ctx(struct blog_module_context *ctx);
+
+/**
+ * blog_get_napi_ctx_ctx - Get NAPI context for this module
+ * @ctx: Module context
+ *
+ * Returns the NAPI (softirq) context for current CPU and this module.
+ *
+ * Context: Softirq context
+ * Return: NAPI context pointer, or NULL if not set
+ */
+struct blog_tls_ctx *blog_get_napi_ctx_ctx(struct blog_module_context *ctx);
+
+/**
+ * blog_set_napi_ctx_ctx - Set NAPI context for this module
+ * @ctx: Module context
+ * @tls_ctx: Context to use for NAPI on current CPU
+ *
+ * Associates a context with current CPU for softirq logging.
+ *
+ * Context: Any context
+ * Return: void
+ */
+void blog_set_napi_ctx_ctx(struct blog_module_context *ctx, struct blog_tls_ctx *tls_ctx);
+
+/**
+ * blog_get_ctx_ctx - Get appropriate context for this module
+ * @ctx: Module context
+ *
+ * Automatically selects NAPI or TLS context based on execution context.
+ * This is the recommended function for per-module context access.
+ *
+ * Context: Any context
+ * Return: Context pointer, or NULL on failure
+ */
+struct blog_tls_ctx *blog_get_ctx_ctx(struct blog_module_context *ctx);
+
+/**
+ * blog_log_commit_ctx - Publish a reserved log entry
+ * @ctx: Module context
+ * @actual_size: Actual bytes written during serialization
+ *
+ * Publishes the log entry that was reserved by the last blog_log_ctx() call,
+ * making it visible to readers. Must be called after serialization is complete.
+ *
+ * The actual_size should be the number of bytes actually written, which may be
+ * less than the worst-case size reserved (e.g., strings may be shorter than 255).
+ *
+ * Context: Same context as the preceding blog_log_ctx() call
+ * Return: 0 on success, negative error code on failure
+ */
+int blog_log_commit_ctx(struct blog_module_context *ctx, size_t actual_size);
+
+/*
+ * Per-module logging macros
+ *
+ * These macros provide the primary logging interface for modules using BLOG.
+ * They handle source ID caching, size calculation, serialization, and trimming
+ * automatically.
+ */
+
+/**
+ * BLOG_LOG_CTX - Log a message using module context (no client ID)
+ * @ctx: Module context from blog_module_init()
+ * @fmt: Printf-style format string
+ * @...: Arguments matching format string
+ *
+ * Primary logging macro for per-module BLOG usage. Automatically handles:
+ * - Source ID allocation and caching (static variable per call site)
+ * - Size calculation at compile time
+ * - Context acquisition (task or NAPI)
+ * - Serialization of arguments
+ * - Trimming of unused space
+ *
+ * Example:
+ *   BLOG_LOG_CTX(my_module_ctx, "Processing inode %llu size %zu\n",
+ *                inode_num, size);
+ *
+ * Context: Any context (automatically selects task or NAPI context)
+ */
+#define BLOG_LOG_CTX(ctx, fmt, ...) \
+	__BLOG_LOG_CTX(ctx, 0, 0, fmt, ##__VA_ARGS__)
+
+/**
+ * BLOG_LOG_CLIENT_CTX - Log a message with client identifier
+ * @ctx: Module context from blog_module_init()
+ * @client_id: Module-specific client identifier (e.g., connection ID)
+ * @fmt: Printf-style format string
+ * @...: Arguments matching format string
+ *
+ * Like BLOG_LOG_CTX but includes a client_id in the log entry. The client_id
+ * is module-specific and can be used to associate logs with specific clients,
+ * connections, or sessions.
+ *
+ * Example:
+ *   BLOG_LOG_CLIENT_CTX(ceph_ctx, ceph_client_id,
+ *                       "Cap update for inode %llu\n", inode);
+ *
+ * During deserialization, the module's client callback is invoked to
+ * format the client_id (e.g., "[fsid global_id]" prefix).
+ *
+ * Context: Any context (automatically selects task or NAPI context)
+ */
+#define BLOG_LOG_CLIENT_CTX(ctx, client_id, fmt, ...) \
+	__BLOG_LOG_CTX(ctx, 0, client_id, fmt, ##__VA_ARGS__)
+
+/* Internal implementation - do not use directly */
+#define __BLOG_LOG_CTX(__ctx, dbg, __client_id, fmt, ...) \
+	do { \
+		static u32 __source_id; \
+		static size_t __size; \
+		void *___buffer = NULL; \
+		(void)(dbg); /* Reserved for future debug functionality */ \
+		if (unlikely(__source_id == 0)) { \
+			__source_id = blog_get_source_id_ctx(__ctx, \
+				kbasename(__FILE__), __func__, __LINE__, fmt); \
+			__size = blog_cnt(__VA_ARGS__); \
+		} \
+		___buffer = blog_log_ctx(__ctx, __source_id, __client_id, __size); \
+		if (likely(___buffer)) {	\
+			void *___tmp = ___buffer; \
+			if (__size > 0) \
+				blog_ser(___buffer, ##__VA_ARGS__);\
+			blog_log_commit_ctx(__ctx, ___buffer - ___tmp); \
+		} \
+	} while (0)
+
+#endif /* _LINUX_BLOG_MODULE_H */
diff --git a/include/linux/blog/blog_pagefrag.h b/include/linux/blog/blog_pagefrag.h
new file mode 100644
index 000000000000..f48c0264f13b
--- /dev/null
+++ b/include/linux/blog/blog_pagefrag.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Binary Logging Page Fragment Management
+ */
+#ifndef _LINUX_BLOG_PAGEFRAG_H
+#define _LINUX_BLOG_PAGEFRAG_H
+
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+
+#define BLOG_PAGEFRAG_SIZE  (1<<19)  /* 512KB */
+#define BLOG_PAGEFRAG_MASK (BLOG_PAGEFRAG_SIZE - 1)
+
+/* Pagefrag allocator structure */
+struct blog_pagefrag {
+	struct page *pages;
+	void *buffer;
+	size_t capacity;        /* Buffer capacity for bounds checking */
+	spinlock_t lock;        /* protects head */
+	unsigned int head;
+	unsigned int alloc_count;
+	int active_elements;
+	void *last_entry;       /* Pointer to the last allocated entry */
+};
+
+int blog_pagefrag_init_with_buffer(struct blog_pagefrag *pf, void *buffer, size_t size);
+int blog_pagefrag_reserve(struct blog_pagefrag *pf, unsigned int n);
+void blog_pagefrag_publish(struct blog_pagefrag *pf, u64 publish_head);
+void blog_pagefrag_reset(struct blog_pagefrag *pf);
+void *blog_pagefrag_get_ptr(struct blog_pagefrag *pf, u64 val);
+
+#endif /* _LINUX_BLOG_PAGEFRAG_H */
diff --git a/include/linux/blog/blog_ser.h b/include/linux/blog/blog_ser.h
new file mode 100644
index 000000000000..a492a1a08b53
--- /dev/null
+++ b/include/linux/blog/blog_ser.h
@@ -0,0 +1,275 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Binary Logging Serialization
+ */
+#ifndef _LINUX_BLOG_SER_H
+#define _LINUX_BLOG_SER_H
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+
+#define IS_CONST_STR_PTR(t) \
+	__builtin_types_compatible_p(typeof(t), const char *)
+
+#define IS_STR_PTR(t) \
+	__builtin_types_compatible_p(typeof(t), char *)
+
+#define IS_STR(t) \
+	(__builtin_types_compatible_p(typeof(t), const char *) || \
+	__builtin_types_compatible_p(typeof(t), char *))
+
+#define __suppress_cast_warning(type, value) \
+({ \
+	_Pragma("GCC diagnostic push") \
+	_Pragma("GCC diagnostic ignored \"-Wint-to-pointer-cast\"") \
+	_Pragma("GCC diagnostic ignored \"-Wpointer-to-int-cast\"") \
+	type __scw_result; \
+	__scw_result = ((type)(value)); \
+	_Pragma("GCC diagnostic pop") \
+	__scw_result; \
+})
+
+#define ___blog_concat(__a, __b) __a ## __b
+#define ___blog_apply(__fn, __n) ___blog_concat(__fn, __n)
+
+#define ___blog_nth(_, __1, __2, __3, __4, __5, __6, __7, __8, __9, \
+	__10, __11, __12, __13, __14, __15, __16, __17, __18, __19, __20, \
+	__21, __22, __23, __24, __25, __26, __27, __28, __29, __30, __31, \
+	__32, __N, ...) __N
+#define ___blog_narg(...) ___blog_nth(_, ##__VA_ARGS__, \
+	32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, \
+	16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+#define blog_narg(...) ___blog_narg(__VA_ARGS__)
+
+#define STR_MAX_SIZE 255
+#define __sizeof(x) \
+	(IS_STR(x) ? STR_MAX_SIZE : \
+	 (sizeof(x) < 4) ? 4 : sizeof(x))
+
+/* Size calculation macros */
+#define ___blog_cnt0()		(0)
+#define ___blog_cnt1(__t)		(__sizeof(__t))
+#define ___blog_cnt2(__t, __args...)	(___blog_cnt1(__args) + __sizeof(__t))
+#define ___blog_cnt3(__t, __args...)	(___blog_cnt2(__args) + __sizeof(__t))
+#define ___blog_cnt4(__t, __args...)	(___blog_cnt3(__args) + __sizeof(__t))
+#define ___blog_cnt5(__t, __args...)	(___blog_cnt4(__args) + __sizeof(__t))
+#define ___blog_cnt6(__t, __args...)	(___blog_cnt5(__args) + __sizeof(__t))
+#define ___blog_cnt7(__t, __args...)	(___blog_cnt6(__args) + __sizeof(__t))
+#define ___blog_cnt8(__t, __args...)	(___blog_cnt7(__args) + __sizeof(__t))
+#define ___blog_cnt9(__t, __args...)	(___blog_cnt8(__args) + __sizeof(__t))
+#define ___blog_cnt10(__t, __args...)	(___blog_cnt9(__args) + __sizeof(__t))
+#define ___blog_cnt11(__t, __args...)	(___blog_cnt10(__args) + __sizeof(__t))
+#define ___blog_cnt12(__t, __args...)	(___blog_cnt11(__args) + __sizeof(__t))
+#define ___blog_cnt13(__t, __args...)	(___blog_cnt12(__args) + __sizeof(__t))
+#define ___blog_cnt14(__t, __args...)	(___blog_cnt13(__args) + __sizeof(__t))
+#define ___blog_cnt15(__t, __args...)	(___blog_cnt14(__args) + __sizeof(__t))
+#define ___blog_cnt16(__t, __args...)	(___blog_cnt15(__args) + __sizeof(__t))
+#define ___blog_cnt17(__t, __args...)	(___blog_cnt16(__args) + __sizeof(__t))
+#define ___blog_cnt18(__t, __args...)	(___blog_cnt17(__args) + __sizeof(__t))
+#define ___blog_cnt19(__t, __args...)	(___blog_cnt18(__args) + __sizeof(__t))
+#define ___blog_cnt20(__t, __args...)	(___blog_cnt19(__args) + __sizeof(__t))
+#define ___blog_cnt21(__t, __args...)	(___blog_cnt20(__args) + __sizeof(__t))
+#define ___blog_cnt22(__t, __args...)	(___blog_cnt21(__args) + __sizeof(__t))
+#define ___blog_cnt23(__t, __args...)	(___blog_cnt22(__args) + __sizeof(__t))
+#define ___blog_cnt24(__t, __args...)	(___blog_cnt23(__args) + __sizeof(__t))
+#define ___blog_cnt25(__t, __args...)	(___blog_cnt24(__args) + __sizeof(__t))
+#define ___blog_cnt26(__t, __args...)	(___blog_cnt25(__args) + __sizeof(__t))
+#define ___blog_cnt27(__t, __args...)	(___blog_cnt26(__args) + __sizeof(__t))
+#define ___blog_cnt28(__t, __args...)	(___blog_cnt27(__args) + __sizeof(__t))
+#define ___blog_cnt29(__t, __args...)	(___blog_cnt28(__args) + __sizeof(__t))
+#define ___blog_cnt30(__t, __args...)	(___blog_cnt29(__args) + __sizeof(__t))
+#define ___blog_cnt31(__t, __args...)	(___blog_cnt30(__args) + __sizeof(__t))
+#define ___blog_cnt32(__t, __args...)	(___blog_cnt31(__args) + __sizeof(__t))
+#define blog_cnt(...)	 ___blog_apply(___blog_cnt, blog_narg(__VA_ARGS__))(__VA_ARGS__)
+
+#define IS_STR_ARRAY(t) \
+	__builtin_types_compatible_p(typeof(t), char [])
+
+#define IS_DYNAMIC_CHAR_PTR(t) \
+	(__builtin_classify_type((t)) == 14 && \
+	 __builtin_types_compatible_p(typeof(t), char *) && \
+	 !__builtin_constant_p((t)))
+
+#define IS_STATIC_CHAR_ARRAY(t) \
+	(__builtin_classify_type((t)) == 5 && \
+	 __builtin_types_compatible_p(typeof(t), char[]) && \
+	 __builtin_constant_p((t)))
+
+#define IS_DYNAMIC_CHAR_ARRAY(t) \
+	(__builtin_classify_type((t)) == 5 && \
+	 __builtin_types_compatible_p(typeof(t), char[]) && \
+	 !__builtin_constant_p((t)))
+
+#define char_ptr(str) __suppress_cast_warning(char *, (str))
+
+#ifndef _CEPH_BLOG_SER_HELPERS_DEFINED
+#define _CEPH_BLOG_SER_HELPERS_DEFINED
+
+union null_str_u {
+	char str[8];
+	unsigned long force_align;
+};
+
+static const union null_str_u null_str = {
+	.str = "(NULL) \0"
+};
+
+static inline size_t write_null_str(char *dst)
+{
+	*(union null_str_u *)dst = null_str;
+	static_assert(sizeof(null_str.str) == sizeof(unsigned long),
+		     "null_str.str size must match unsigned long for proper alignment");
+	return __builtin_strlen(null_str.str);
+}
+
+static inline size_t strscpy_n(char *dst, const char *src)
+{
+	size_t count = 0;
+
+	while (count < STR_MAX_SIZE - 1) {
+		dst[count] = src[count];
+		if (src[count] == '\0')
+			goto out;
+		count++;
+	}
+
+	dst[count] = '\0';
+	pr_warn("blog_ser: string truncated, exceeded max size %d\n", STR_MAX_SIZE);
+out:
+	return count + 1;
+}
+
+static inline ssize_t __strscpy(char *dst, const char *src)
+{
+	if (src != NULL)
+		return strscpy_n(dst, src);
+	return write_null_str(dst);
+}
+
+static inline void *strscpy_n_update(char *dst, const char *src, const char *file, int line)
+{
+	ssize_t ret = __strscpy(dst, src);
+
+	if (unlikely(ret <= 0 || ret >= STR_MAX_SIZE)) {
+		pr_err("blog_ser: string handling error ret=%zd at %s:%d :: dst='%s' src='%s'\n",
+		       ret, file, line, dst, src ? src : "(null)");
+		/* Return safely instead of panicking - truncate and continue */
+		if (ret >= STR_MAX_SIZE) {
+			dst[STR_MAX_SIZE - 1] = '\0';
+			ret = STR_MAX_SIZE;
+		} else {
+			/* Handle null or empty string case */
+			dst[0] = '\0';
+			ret = 1;
+		}
+	}
+	return dst + round_up(ret, 4);
+}
+
+#endif /* _CEPH_BLOG_SER_HELPERS_DEFINED */
+
+/* Serialization type macro */
+#define __blog_ser_type(__buffer, __t)                          \
+	(__builtin_choose_expr(IS_STATIC_CHAR_ARRAY((__t)),               \
+		/* For static arrays (like __func__), copy inline */         \
+		((__buffer) = (void *)strscpy_n_update((__buffer),            \
+						char_ptr(__t),                             \
+						kbasename(__FILE__),                      \
+						__LINE__)),                               \
+	__builtin_choose_expr(IS_STR((__t)),               \
+		((__buffer) = (void *)strscpy_n_update((__buffer),            \
+						char_ptr(__t),                             \
+						kbasename(__FILE__),                      \
+						__LINE__)),                               \
+	__builtin_choose_expr(IS_STR_ARRAY((__t)),               \
+		/* For dynamic arrays, save NULL and string bytes */         \
+		 ((__buffer) = (void *)strscpy_n_update((__buffer),        \
+						char_ptr(__t),                       \
+						kbasename(__FILE__),                \
+						__LINE__)),                          \
+	__builtin_choose_expr(sizeof((__t)) == 1,                         \
+		(*(uint32_t *)(__buffer) = __suppress_cast_warning(uint32_t, (__t)), \
+		 (__buffer) = (void *)((char *)(__buffer) + 4)),            \
+	__builtin_choose_expr(sizeof((__t)) == 2,                         \
+		(*(uint32_t *)(__buffer) = __suppress_cast_warning(uint32_t, (__t)), \
+		 (__buffer) = (void *)((char *)(__buffer) + 4)),            \
+	__builtin_choose_expr(sizeof((__t)) == 4,                         \
+		(*(uint32_t *)(__buffer) = __suppress_cast_warning(uint32_t, (__t)), \
+		 (__buffer) = (void *)((char *)(__buffer) + 4)),            \
+	__builtin_choose_expr(sizeof((__t)) == 8,                         \
+		(*(uint64_t *)(__buffer) = __suppress_cast_warning(uint64_t, (__t)), \
+		 (__buffer) = (void *)((char *)(__buffer) + 8)),            \
+		(pr_err("UNSUPPORTED_TYPE: %s:%d: unsupported type size %zu\n",       \
+			kbasename(__FILE__), __LINE__, sizeof(__t)))              \
+	))))))))
+
+/* Serialization macros */
+#define ___blog_ser0(__buffer)
+#define ___blog_ser1(__buffer, __t)           (__blog_ser_type(__buffer, __t))
+#define ___blog_ser2(__buffer, __t, __args...)    \
+	(__blog_ser_type(__buffer, __t), ___blog_ser1(__buffer, __args))
+#define ___blog_ser3(__buffer, __t, __args...)    \
+	(__blog_ser_type(__buffer, __t), ___blog_ser2(__buffer, __args))
+#define ___blog_ser4(__buffer, __t, __args...)    \
+	(__blog_ser_type(__buffer, __t), ___blog_ser3(__buffer, __args))
+#define ___blog_ser5(__buffer, __t, __args...)    \
+	(__blog_ser_type(__buffer, __t), ___blog_ser4(__buffer, __args))
+#define ___blog_ser6(__buffer, __t, __args...)    \
+	(__blog_ser_type(__buffer, __t), ___blog_ser5(__buffer, __args))
+#define ___blog_ser7(__buffer, __t, __args...)    \
+	(__blog_ser_type(__buffer, __t), ___blog_ser6(__buffer, __args))
+#define ___blog_ser8(__buffer, __t, __args...)    \
+	(__blog_ser_type(__buffer, __t), ___blog_ser7(__buffer, __args))
+#define ___blog_ser9(__buffer, __t, __args...)    \
+	(__blog_ser_type(__buffer, __t), ___blog_ser8(__buffer, __args))
+#define ___blog_ser10(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser9(__buffer, __args))
+#define ___blog_ser11(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser10(__buffer, __args))
+#define ___blog_ser12(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser11(__buffer, __args))
+#define ___blog_ser13(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser12(__buffer, __args))
+#define ___blog_ser14(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser13(__buffer, __args))
+#define ___blog_ser15(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser14(__buffer, __args))
+#define ___blog_ser16(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser15(__buffer, __args))
+#define ___blog_ser17(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser16(__buffer, __args))
+#define ___blog_ser18(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser17(__buffer, __args))
+#define ___blog_ser19(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser18(__buffer, __args))
+#define ___blog_ser20(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser19(__buffer, __args))
+#define ___blog_ser21(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser20(__buffer, __args))
+#define ___blog_ser22(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser21(__buffer, __args))
+#define ___blog_ser23(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser22(__buffer, __args))
+#define ___blog_ser24(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser23(__buffer, __args))
+#define ___blog_ser25(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser24(__buffer, __args))
+#define ___blog_ser26(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser25(__buffer, __args))
+#define ___blog_ser27(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser26(__buffer, __args))
+#define ___blog_ser28(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser27(__buffer, __args))
+#define ___blog_ser29(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser28(__buffer, __args))
+#define ___blog_ser30(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser29(__buffer, __args))
+#define ___blog_ser31(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser30(__buffer, __args))
+#define ___blog_ser32(__buffer, __t, __args...)   \
+	(__blog_ser_type(__buffer, __t), ___blog_ser31(__buffer, __args))
+#define ___blog_ser(__buffer, ...)   \
+	___blog_apply(___blog_ser, blog_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
+#define blog_ser(...)  ___blog_ser(__VA_ARGS__)
+
+#endif /* _LINUX_BLOG_SER_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index e629449dd2a3..27262af07453 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -512,6 +512,8 @@ source "lib/vdso/Kconfig"
 
 source "lib/fonts/Kconfig"
 
+source "lib/blog/Kconfig"
+
 config SG_SPLIT
 	def_bool n
 	help
diff --git a/lib/Makefile b/lib/Makefile
index 1ab2c4be3b66..913c5790cdd3 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -283,6 +283,8 @@ obj-$(CONFIG_ASN1_ENCODER) += asn1_encoder.o
 
 obj-$(CONFIG_FONT_SUPPORT) += fonts/
 
+obj-$(CONFIG_BLOG) += blog/
+
 #
 # Build a fast OID lookip registry from include/linux/oid_registry.h
 #
diff --git a/lib/blog/Kconfig b/lib/blog/Kconfig
new file mode 100644
index 000000000000..3207934f51b8
--- /dev/null
+++ b/lib/blog/Kconfig
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Binary Logging Infrastructure (BLOG)
+#
+
+config BLOG
+	tristate "Binary Logging Infrastructure"
+	help
+	  Generic binary logging infrastructure for kernel subsystems.
+	  Provides efficient batched logging with binary serialization
+	  and deserialization support. Modules using BLOG maintain their
+	  own client mappings and debugfs interfaces.
+
+	  If unsure, say N.
+
+config BLOG_DEBUG
+	bool "Binary Logging Debug Support"
+	depends on BLOG
+	default n
+	help
+	  Enable debug features for the binary logging infrastructure,
+	  including memory poisoning, validation checks, and usage tracking.
+	  This adds overhead and should only be enabled for debugging.
+
+	  If unsure, say N.
+
+config BLOG_MAX_CLIENTS
+	int "Maximum number of logging clients"
+	depends on BLOG
+	range 16 1024
+	default 256
+	help
+	  Maximum number of client IDs that can be used by modules.
+	  Each module using BLOG can register multiple clients up to
+	  this limit. The client ID is stored as u8, so maximum is 256.
+
+config BLOG_MAX_SOURCES
+	int "Maximum number of source locations"
+	depends on BLOG
+	range 256 16384
+	default 4096
+	help
+	  Maximum number of unique source code locations (file/function/line)
+	  that can be tracked. Each unique logging call site gets a source ID.
+
+config BLOG_TRACK_USAGE
+	bool "Track usage statistics"
+	depends on BLOG_DEBUG
+	default n
+	help
+	  Track usage statistics for logging operations, including counts
+	  and bytes used in different contexts (task vs NAPI). This helps
+	  identify performance bottlenecks and usage patterns in the logging
+	  system but adds overhead to each logging operation.
+
+	  If unsure, say N.
diff --git a/lib/blog/Makefile b/lib/blog/Makefile
new file mode 100644
index 000000000000..8c33a2a6e9d5
--- /dev/null
+++ b/lib/blog/Makefile
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for Binary Logging Infrastructure (BLOG)
+#
+
+obj-$(CONFIG_BLOG) += blog.o
+
+blog-y := blog_core.o blog_batch.o blog_pagefrag.o blog_des.o blog_module.o
+
+# Debug support
+# blog-$(CONFIG_BLOG_DEBUG) += blog_debug.o
+
+# Compiler flags
+ccflags-$(CONFIG_BLOG_DEBUG) += -DBLOG_DEBUG=1
+ccflags-$(CONFIG_BLOG_TRACK_USAGE) += -DBLOG_TRACK_USAGE=1
diff --git a/lib/blog/blog_batch.c b/lib/blog/blog_batch.c
new file mode 100644
index 000000000000..beb512836bbe
--- /dev/null
+++ b/lib/blog/blog_batch.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Binary Logging Batch Management
+ *
+ * Migrated from ceph_san_batch.c with all algorithms preserved
+ * Implements per-CPU magazine-based batching for efficient object recycling
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/preempt.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/blog/blog_batch.h>
+#include <linux/blog/blog.h>
+
+/* Number of magazines to preallocate during initialization */
+#define BLOG_INIT_MAGAZINES 4
+
+static struct blog_magazine *alloc_magazine(struct blog_batch *batch)
+{
+	struct blog_magazine *mag;
+
+	/* Allocate magazine structure from cache */
+	mag = kmem_cache_zalloc(batch->magazine_cache, GFP_KERNEL);
+	if (!mag)
+		return NULL;
+
+	INIT_LIST_HEAD(&mag->list);
+	mag->count = 0;
+	return mag;
+}
+
+static void free_magazine(struct blog_batch *batch, struct blog_magazine *mag)
+{
+	int i;
+	struct blog_tls_pagefrag *composite;
+
+	/* Free all composites in this magazine before freeing magazine itself */
+	for (i = 0; i < mag->count; i++) {
+		composite = mag->elements[i];
+		if (composite) {
+			/* Composites are allocated with alloc_pages(), free with __free_pages() */
+			__free_pages(virt_to_page(composite),
+				     get_order(BLOG_TLS_PAGEFRAG_ALLOC_SIZE));
+		}
+	}
+
+	/* Free the magazine structure itself */
+	kmem_cache_free(batch->magazine_cache, mag);
+}
+
+/**
+ * blog_batch_init - Initialize the batching system
+ * @batch: Batch structure to initialize
+ * @prepopulate: If true, pre-populate magazines with composites
+ *
+ * Allocates and initializes the per-CPU magazines and global pools.
+ * Magazine structures are allocated from a slab cache.
+ * Composites (512KB each) are allocated via alloc_pages().
+ *
+ * If prepopulate is true (typically for alloc_batch), pre-allocates
+ * magazines filled with composites. log_batch should start empty.
+ *
+ * Return: 0 on success, negative error code on failure
+ */
+int blog_batch_init(struct blog_batch *batch, struct kmem_cache *mag_cache,
+		    bool prepopulate)
+{
+	int cpu, i, j;
+	struct blog_cpu_magazine *cpu_mag;
+	struct blog_magazine *mag;
+	struct blog_tls_pagefrag *composite;
+	struct page *pages;
+
+	/* Initialize counters */
+	batch->nr_full = 0;
+	batch->nr_empty = 0;
+
+	/* Use caller-provided cache or create one */
+	if (mag_cache) {
+		batch->magazine_cache = mag_cache;
+		batch->external_cache = true;
+	} else {
+		batch->magazine_cache = kmem_cache_create("blog_magazine",
+						       sizeof(struct blog_magazine),
+						       0, SLAB_HWCACHE_ALIGN, NULL);
+		if (!batch->magazine_cache)
+			return -ENOMEM;
+		batch->external_cache = false;
+	}
+
+	/* Initialize global magazine lists */
+	INIT_LIST_HEAD(&batch->full_magazines);
+	INIT_LIST_HEAD(&batch->empty_magazines);
+	spin_lock_init(&batch->full_lock);
+	spin_lock_init(&batch->empty_lock);
+
+	/* Allocate per-CPU magazines */
+	batch->cpu_magazines = alloc_percpu(struct blog_cpu_magazine);
+	if (!batch->cpu_magazines)
+		goto cleanup_cache;
+
+	/* Initialize per-CPU magazines to NULL (magazines allocated on-demand) */
+	for_each_possible_cpu(cpu) {
+		cpu_mag = per_cpu_ptr(batch->cpu_magazines, cpu);
+		cpu_mag->mag = NULL;
+	}
+
+	/* Pre-populate magazines if requested (typically for alloc_batch) */
+	if (prepopulate) {
+		for (i = 0; i < BLOG_INIT_MAGAZINES; i++) {
+			mag = alloc_magazine(batch);
+			if (!mag)
+				goto cleanup;
+
+			/* Populate magazine with composites allocated via alloc_pages() */
+			for (j = 0; j < BLOG_MAGAZINE_SIZE; j++) {
+				/* Allocate 512KB composite via page allocator */
+				pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+						    get_order(BLOG_TLS_PAGEFRAG_ALLOC_SIZE));
+				if (!pages) {
+					/* Free partially filled magazine */
+					free_magazine(batch, mag);
+					goto cleanup;
+				}
+				composite = page_address(pages);
+				/* Composite is zeroed - ctx->id == 0, will be initialized on first use */
+				mag->elements[j] = composite;
+				mag->count++;
+			}
+
+			/* Add full magazine to the full pool */
+			spin_lock(&batch->full_lock);
+			list_add(&mag->list, &batch->full_magazines);
+			batch->nr_full++;
+			spin_unlock(&batch->full_lock);
+		}
+	}
+
+	return 0;
+
+cleanup:
+	blog_batch_cleanup(batch);
+	return -ENOMEM;
+
+cleanup_cache:
+	if (!batch->external_cache && batch->magazine_cache)
+		kmem_cache_destroy(batch->magazine_cache);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(blog_batch_init);
+
+/**
+ * blog_batch_cleanup - Clean up the batching system
+ * @batch: Batch structure to clean up
+ *
+ * Frees all magazines and composites, and destroys the magazine cache.
+ */
+void blog_batch_cleanup(struct blog_batch *batch)
+{
+	int cpu;
+	struct blog_magazine *mag, *tmp;
+	struct blog_cpu_magazine *cpu_mag;
+
+	/* Free per-CPU magazines */
+	if (batch->cpu_magazines) {
+		for_each_possible_cpu(cpu) {
+			cpu_mag = per_cpu_ptr(batch->cpu_magazines, cpu);
+			if (cpu_mag->mag)
+				free_magazine(batch, cpu_mag->mag);
+		}
+		free_percpu(batch->cpu_magazines);
+	}
+
+	/* Free magazines in the full pool */
+	spin_lock(&batch->full_lock);
+	list_for_each_entry_safe(mag, tmp, &batch->full_magazines, list) {
+		list_del(&mag->list);
+		batch->nr_full--;
+		free_magazine(batch, mag);
+	}
+	spin_unlock(&batch->full_lock);
+
+	/* Free magazines in the empty pool */
+	spin_lock(&batch->empty_lock);
+	list_for_each_entry_safe(mag, tmp, &batch->empty_magazines, list) {
+		list_del(&mag->list);
+		batch->nr_empty--;
+		free_magazine(batch, mag);
+	}
+	spin_unlock(&batch->empty_lock);
+
+	/* Destroy magazine cache */
+	if (!batch->external_cache && batch->magazine_cache)
+		kmem_cache_destroy(batch->magazine_cache);
+
+	batch->magazine_cache = NULL;
+	batch->external_cache = false;
+}
+EXPORT_SYMBOL(blog_batch_cleanup);
+
+/**
+ * blog_batch_get - Get an element from the batch
+ * @batch: Batch to get element from
+ *
+ * Return: Element from the magazine, or NULL if none available
+ */
+void *blog_batch_get(struct blog_batch *batch)
+{
+	struct blog_cpu_magazine *cpu_mag;
+	struct blog_magazine *old_mag, *new_mag;
+	void *element = NULL;
+
+	preempt_disable();
+	cpu_mag = this_cpu_ptr(batch->cpu_magazines);
+
+	/* If we have a magazine and it has elements, use it */
+	if (cpu_mag->mag && cpu_mag->mag->count > 0) {
+		element = cpu_mag->mag->elements[--cpu_mag->mag->count];
+		goto out;
+	}
+
+	/* Current magazine is empty, try to get a full one */
+	old_mag = cpu_mag->mag;
+
+	/* Return old magazine to empty pool if we have one */
+	if (old_mag) {
+		spin_lock(&batch->empty_lock);
+		list_add(&old_mag->list, &batch->empty_magazines);
+		batch->nr_empty++;
+		spin_unlock(&batch->empty_lock);
+		cpu_mag->mag = NULL;
+	}
+
+	if (batch->nr_full > 0) {
+		/* Try to get a full magazine */
+		spin_lock(&batch->full_lock);
+		if (!list_empty(&batch->full_magazines)) {
+			new_mag = list_first_entry(&batch->full_magazines,
+						   struct blog_magazine, list);
+			list_del(&new_mag->list);
+			batch->nr_full--;
+			spin_unlock(&batch->full_lock);
+
+			cpu_mag->mag = new_mag;
+			if (new_mag->count > 0)
+				element = new_mag->elements[--new_mag->count];
+		} else {
+			spin_unlock(&batch->full_lock);
+		}
+	}
+out:
+	preempt_enable();
+	return element;
+}
+EXPORT_SYMBOL(blog_batch_get);
+
+/**
+ * blog_batch_put - Put an element back into the batch
+ * @batch: Batch to put element into
+ * @element: Element to put back
+ */
+void blog_batch_put(struct blog_batch *batch, void *element)
+{
+	struct blog_cpu_magazine *cpu_mag;
+	struct blog_magazine *mag;
+
+	preempt_disable();
+	cpu_mag = this_cpu_ptr(batch->cpu_magazines);
+
+	/* Optimistically try to add to current magazine */
+	if (likely(cpu_mag->mag && cpu_mag->mag->count < BLOG_MAGAZINE_SIZE)) {
+		cpu_mag->mag->elements[cpu_mag->mag->count++] = element;
+		goto out;
+	}
+
+	/* If current magazine is full, move it to full pool */
+	if (likely(cpu_mag->mag && cpu_mag->mag->count >= BLOG_MAGAZINE_SIZE)) {
+		spin_lock(&batch->full_lock);
+		list_add_tail(&cpu_mag->mag->list, &batch->full_magazines);
+		batch->nr_full++;
+		spin_unlock(&batch->full_lock);
+		cpu_mag->mag = NULL;
+	}
+
+	/* Get new magazine if needed */
+	if (likely(!cpu_mag->mag)) {
+		/* Try to get from empty pool first */
+		spin_lock(&batch->empty_lock);
+		if (!list_empty(&batch->empty_magazines)) {
+			mag = list_first_entry(&batch->empty_magazines,
+					       struct blog_magazine, list);
+			list_del(&mag->list);
+			batch->nr_empty--;
+			spin_unlock(&batch->empty_lock);
+			cpu_mag->mag = mag;
+		} else {
+			spin_unlock(&batch->empty_lock);
+			cpu_mag->mag = alloc_magazine(batch);
+		}
+
+		if (unlikely(!cpu_mag->mag))
+			goto out;
+	}
+	/* Add element to magazine */
+	cpu_mag->mag->elements[cpu_mag->mag->count++] = element;
+out:
+	preempt_enable();
+}
diff --git a/lib/blog/blog_core.c b/lib/blog/blog_core.c
new file mode 100644
index 000000000000..ede382f0ce5e
--- /dev/null
+++ b/lib/blog/blog_core.c
@@ -0,0 +1,772 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Binary Logging Infrastructure - Core Implementation
+ *
+ * Migrated from ceph_san_logger.c with algorithms preserved
+ * Client ID management removed - modules handle their own mappings
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/printk.h>
+#include <linux/time.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/sched.h>
+#include <linux/sched/task.h>
+#include <linux/seq_file.h>
+#include <linux/atomic.h>
+
+#include <linux/blog/blog.h>
+#include <linux/blog/blog_batch.h>
+#include <linux/blog/blog_pagefrag.h>
+#include <linux/blog/blog_ser.h>
+#include <linux/blog/blog_des.h>
+#include <linux/blog/blog_module.h>
+
+static void blog_tls_release_verbose(void *ptr);
+#define NULL_STR "(NULL)"
+#define BLOG_LOG_BATCH_MAX_FULL 16
+
+/* Core BLOG functions - all require a valid logger parameter */
+
+/**
+ * blog_is_valid_kernel_addr - Check if address is in valid kernel address range
+ * @addr: Address to check
+ *
+ * Returns true if address is in valid kernel address range
+ */
+bool blog_is_valid_kernel_addr(const void *addr)
+{
+	if (virt_addr_valid(addr))
+		return true;
+	return false;
+}
+EXPORT_SYMBOL(blog_is_valid_kernel_addr);
+
+/**
+ * get_context_id - Get a unique context ID
+ * @logger: Logger instance to use
+ *
+ * Acquires a unique ID for a TLS context using the logger's counter
+ *
+ * Returns a unique context ID
+ */
+static u64 get_context_id(struct blog_logger *logger)
+{
+	u64 id;
+
+	spin_lock(&logger->ctx_id_lock);
+	id = logger->next_ctx_id++;
+	spin_unlock(&logger->ctx_id_lock);
+	return id;
+}
+
+/**
+ * validate_tls_ctx - Validate a TLS context
+ * @ctx: Context to validate
+ *
+ * Returns true if context is valid, false otherwise
+ */
+static inline bool validate_tls_ctx(struct blog_tls_ctx *ctx)
+{
+	if (!ctx)
+		return false;
+
+#if BLOG_DEBUG_POISON
+	if (ctx->debug_poison != BLOG_CTX_POISON) {
+		pr_err("BUG: TLS context id=%llu (%llx) has invalid debug_poison value 0x%llx\n",
+		       ctx->id, (unsigned long long)ctx,
+		       (unsigned long long)ctx->debug_poison);
+		return false;
+	}
+#endif
+
+	if (atomic_read(&ctx->refcount) != 1) {
+		pr_err("BUG: TLS context id=%llu (%llx) refcount %d, expected 1\n",
+		       ctx->id, (unsigned long long)ctx,
+		       atomic_read(&ctx->refcount));
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * add_context_to_global_list - Add a context to the global list
+ * @ctx: The context to add to the global list
+ *
+ * Adds the context to the global list of contexts and updates stats
+ */
+static void add_context_to_logger_list(struct blog_logger *logger, struct blog_tls_ctx *ctx)
+{
+	if (!logger)
+		return;
+
+	spin_lock(&logger->lock);
+	list_add(&ctx->list, &logger->contexts);
+	logger->total_contexts_allocated++;
+	spin_unlock(&logger->lock);
+}
+
+static void remove_context_from_logger_list(struct blog_logger *logger,
+					      struct blog_tls_ctx *ctx)
+{
+	if (!logger)
+		return;
+
+	spin_lock(&logger->lock);
+	if (!list_empty(&ctx->list)) {
+		list_del_init(&ctx->list);
+		if (logger->total_contexts_allocated)
+			logger->total_contexts_allocated--;
+	}
+	spin_unlock(&logger->lock);
+}
+
+static void blog_tls_clear_task(struct blog_tls_ctx *ctx)
+{
+	struct task_struct *task;
+
+	if (!ctx)
+		return;
+
+	task = READ_ONCE(ctx->task);
+	if (task) {
+		WRITE_ONCE(ctx->task, NULL);
+		put_task_struct(task);
+	}
+}
+
+static inline struct blog_tls_ctx *get_new_ctx(struct blog_logger *logger)
+{
+	struct blog_tls_pagefrag *composite;
+	struct blog_tls_ctx *ctx;
+	struct blog_pagefrag *pf;
+	bool is_new = false;
+
+	if (!logger)
+		return NULL;
+
+	/* Pop a composite from the alloc_batch */
+	composite = blog_batch_get(&logger->alloc_batch);
+	if (!composite) {
+		/* If batch is empty, allocate a new composite via page allocator (512KB) */
+		struct page *pages;
+
+		pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				    get_order(BLOG_TLS_PAGEFRAG_ALLOC_SIZE));
+		if (!pages) {
+			pr_err("%s: Failed to allocate composite via alloc_pages\n", __func__);
+			return NULL;
+		}
+		composite = page_address(pages);
+		is_new = true;
+	}
+
+	ctx = &composite->ctx;
+
+	/* Check if this composite needs initialization (new or first use from batch) */
+	if (is_new || ctx->id == 0) {
+		/* Initialize context fields for new composite or uninitialized one */
+		INIT_LIST_HEAD(&ctx->list);
+		atomic_set(&ctx->refcount, 0);
+		ctx->id = get_context_id(logger);
+
+#if BLOG_DEBUG_POISON
+		ctx->debug_poison = BLOG_CTX_POISON;
+#endif
+
+		pr_debug("[%d]blog: initialized new composite id=%llu (%llx)\n",
+			 smp_processor_id(), ctx->id, (unsigned long long)ctx);
+	}
+
+	/* Always refresh these fields on reuse */
+	ctx->logger = logger;
+	ctx->release = blog_tls_release_verbose;
+
+#if BLOG_DEBUG_POISON
+	/* Verify debug poison */
+	if (ctx->debug_poison != BLOG_CTX_POISON) {
+		pr_err("%s: Context id=%llu has invalid debug_poison value 0x%llx\n",
+		       __func__, ctx->id, (unsigned long long)ctx->debug_poison);
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+#endif
+
+	/* Initialize the embedded pagefrag to point to inline buffer */
+	pf = &composite->pf;
+	pf->pages = NULL;  /* No separate pages, using inline buffer */
+	pf->buffer = composite->buf;  /* Point to inline buffer */
+	pf->capacity = BLOG_TLS_PAGEFRAG_BUFFER_SIZE;  /* Inline buffer size (512KB - header) */
+	spin_lock_init(&pf->lock);
+	pf->head = 0;
+	pf->alloc_count = 0;
+	pf->active_elements = 0;
+	pf->last_entry = NULL;
+
+	/* Debug: Write buffer offset markers */
+	{
+		size_t expected_offset = sizeof(struct blog_tls_ctx) + sizeof(struct blog_pagefrag);
+		size_t actual_offset = (char *)composite->buf - (char *)composite;
+		*(u64 *)composite->buf = expected_offset;
+		pr_err("blog: composite=%p, ctx=%p, pf=%p, buf=%p, expected_offset=%zu, actual_offset=%zu\n",
+			composite, &composite->ctx, &composite->pf, composite->buf,
+			expected_offset, actual_offset);
+	}
+
+	/* Add to logger's context list */
+	add_context_to_logger_list(logger, ctx);
+
+	/* Set base timestamp */
+	ctx->base_jiffies = jiffies;
+
+	blog_logger_print_stats(logger);
+	return ctx; /* Context returned with refcount = 0 */
+}
+
+/**
+ * is_valid_active_ctx - Validate an active TLS context
+ * @ctx: Context to validate
+ * @context_description: String describing the context for error messages
+ *
+ * Returns true if context is valid (poison OK, refcount == 1), false otherwise
+ */
+static inline bool is_valid_active_ctx(struct blog_tls_ctx *ctx,
+				       const char *context_description)
+{
+	if (!ctx) {
+		pr_err("BUG: %s context is NULL.\n", context_description);
+		return false;
+	}
+
+#if BLOG_DEBUG_POISON
+	if (ctx->debug_poison != BLOG_CTX_POISON) {
+		pr_err("BUG: %s context id=%llu (%llx) has invalid debug_poison value 0x%llx\n",
+		       context_description, ctx->id, (unsigned long long)ctx,
+		       (unsigned long long)ctx->debug_poison);
+		return false;
+	}
+#endif
+
+	if (atomic_read(&ctx->refcount) != 1) {
+		pr_err("BUG: %s context id=%llu (%llx) refcount %d, expected 1\n",
+		       context_description, ctx->id, (unsigned long long)ctx,
+		       atomic_read(&ctx->refcount));
+		return false;
+	}
+	return true;
+}
+
+/* Release function for TLS storage */
+static void blog_tls_release(void *ptr)
+{
+	struct blog_tls_ctx *ctx = ptr;
+	struct blog_tls_pagefrag *composite;
+
+	if (!ctx)
+		return;
+
+	if (atomic_dec_return(&ctx->refcount) != 0) {
+		pr_err("BUG: TLS context id=%llu refcount %d after release\n",
+		       ctx->id, atomic_read(&ctx->refcount));
+		panic("blog: TLS context id=%llu refcount %d after release\n",
+		      ctx->id, atomic_read(&ctx->refcount));
+	}
+	pr_debug("blog: decremented refcount=0 for context id=%llu\n", ctx->id);
+
+	/* Clear task association */
+	blog_tls_clear_task(ctx);
+	pr_debug("blog: releasing TLS context for pid %d [%s]\n", ctx->pid,
+		 ctx->comm);
+
+	if (ctx->logger) {
+		/* Remove from logger's context list */
+		remove_context_from_logger_list(ctx->logger, ctx);
+
+		/* Recycle composite to log_batch - logs remain readable!
+		 * Composite will flow: log_batch → drain → reset → alloc_batch */
+		composite = blog_ctx_container(ctx);
+		blog_batch_put(&ctx->logger->log_batch, composite);
+
+		/* If log_batch has too many full magazines, move one to alloc_batch */
+		if (ctx->logger->log_batch.nr_full > BLOG_LOG_BATCH_MAX_FULL) {
+			struct blog_magazine *mag;
+
+			spin_lock(&ctx->logger->log_batch.full_lock);
+			if (!list_empty(&ctx->logger->log_batch.full_magazines)) {
+				mag = list_first_entry(
+					&ctx->logger->log_batch.full_magazines,
+					struct blog_magazine, list);
+				list_del(&mag->list);
+				ctx->logger->log_batch.nr_full--;
+				spin_unlock(&ctx->logger->log_batch.full_lock);
+
+				spin_lock(&ctx->logger->alloc_batch.full_lock);
+				list_add(&mag->list,
+					 &ctx->logger->alloc_batch.full_magazines);
+				ctx->logger->alloc_batch.nr_full++;
+				spin_unlock(&ctx->logger->alloc_batch.full_lock);
+			} else {
+				spin_unlock(&ctx->logger->log_batch.full_lock);
+			}
+		}
+	} else {
+		pr_err("BUG: TLS context id=%llu has no logger for batch release\n",
+		       ctx->id);
+	}
+}
+
+static void blog_tls_release_verbose(void *ptr)
+{
+	struct blog_tls_ctx *ctx = (struct blog_tls_ctx *)ptr;
+
+	if (!ctx) {
+		pr_err("blog -- Callback : invalid TLS context pointer %d\n",
+		       current->pid);
+		return;
+	}
+#if BLOG_DEBUG_POISON
+	if (ctx->debug_poison != BLOG_CTX_POISON) {
+		pr_err("%s: invalid TLS context id=%llu has invalid debug_poison value 0x%llx\n",
+		       __func__, ctx->id, (unsigned long long)ctx->debug_poison);
+		WARN_ON_ONCE(1);
+		return;
+	}
+#endif
+	if (atomic_read(&ctx->refcount) != 1) {
+		pr_err("%s: invalid TLS context refcount %d for pid %d [%s]\n",
+		       __func__, atomic_read(&ctx->refcount), ctx->pid, ctx->comm);
+		WARN_ON_ONCE(1);
+		return;
+	}
+	blog_tls_release(ctx);
+}
+
+static struct blog_tls_ctx *lookup_active_ctx(struct blog_logger *logger)
+{
+	struct blog_tls_ctx *ctx;
+
+	if (!logger)
+		return NULL;
+
+	if (logger->has_slot) {
+		u8 slot = logger->slot_id;
+		struct blog_tls_ctx *slot_ctx;
+
+		if (slot < BLOG_MAX_MODULES) {
+			slot_ctx = READ_ONCE(current->blog_contexts[slot]);
+			if (slot_ctx)
+				return slot_ctx;
+		}
+	}
+
+	spin_lock(&logger->lock);
+	list_for_each_entry(ctx, &logger->contexts, list) {
+		if (ctx->task == current) {
+			spin_unlock(&logger->lock);
+			return ctx;
+		}
+	}
+	spin_unlock(&logger->lock);
+	return NULL;
+}
+
+/**
+ * blog_get_tls_ctx - Get or create TLS context for current task
+ * @logger: Logger instance to use
+ *
+ * Returns pointer to TLS context or NULL on error
+ */
+struct blog_tls_ctx *blog_get_tls_ctx(struct blog_logger *logger)
+{
+	struct blog_tls_ctx *ctx = lookup_active_ctx(logger);
+
+	/* Context already exists - handled by slot-based system */
+	if (ctx)
+		return ctx;
+
+	if (logger && logger->has_slot && logger->owner_ctx)
+		return blog_get_tls_ctx_ctx(logger->owner_ctx);
+
+	/* Create new context */
+	pr_debug("blog: creating new TLS context for pid %d [%s]\n",
+		 current->pid, current->comm);
+
+	ctx = get_new_ctx(logger);
+	if (!ctx)
+		return NULL;
+
+	blog_tls_clear_task(ctx);
+	get_task_struct(current);
+
+	/* Set up TLS specific parts */
+	/* Note: slot-based storage is handled by blog_module layer */
+	ctx->task = current;
+	ctx->pid = current->pid;
+	strscpy(ctx->comm, current->comm, TASK_COMM_LEN);
+
+	/* Increment refcount from 0 to 1 */
+	if (atomic_inc_return(&ctx->refcount) != 1) {
+		pr_err("%s: Failed to set refcount=1 for new TLS context id=%llu (was %d before inc)\n",
+		       __func__, ctx->id, atomic_read(&ctx->refcount) - 1);
+		WARN_ON_ONCE(1);
+	}
+
+	pr_debug(
+		"blog: successfully created new TLS context id=%llu for pid %d [%s]\n",
+		ctx->id, ctx->pid, ctx->comm);
+	return ctx;
+}
+EXPORT_SYMBOL(blog_get_tls_ctx);
+
+/**
+ * blog_get_source_id - Get or create a source ID for the given location
+ * @logger: Logger instance to use (NULL for global)
+ * @file: Source file name
+ * @func: Function name
+ * @line: Line number
+ * @fmt: Format string
+ *
+ * Returns a unique ID for this source location
+ */
+u32 blog_get_source_id(struct blog_logger *logger, const char *file,
+		       const char *func, unsigned int line, const char *fmt)
+{
+	u32 id;
+
+	if (!logger)
+		return 0;
+
+	id = atomic_inc_return(&logger->next_source_id);
+
+	if (id >= BLOG_MAX_SOURCE_IDS) {
+		/* If we run out of IDs, just use the first one */
+		pr_warn("blog: source ID overflow, reusing ID 1\n");
+		id = 1;
+	}
+
+	/* Store the source information in the logger's map */
+	logger->source_map[id].file = file;
+	logger->source_map[id].func = func;
+	logger->source_map[id].line = line;
+	logger->source_map[id].fmt = fmt;
+	logger->source_map[id].warn_count = 0;
+
+	pr_err("blog_get_source_id: id=%u, file=%s, func=%s, line=%u, fmt=%p (%s)\n",
+		id, file, func, line, fmt, fmt ? fmt : "NULL");
+
+	return id;
+}
+EXPORT_SYMBOL(blog_get_source_id);
+
+/**
+ * blog_get_source_info - Get source info for a given ID
+ * @id: Source ID
+ *
+ * Returns the source information for this ID
+ */
+struct blog_source_info *blog_get_source_info(struct blog_logger *logger, u32 id)
+{
+	if (!logger || unlikely(id == 0 || id >= BLOG_MAX_SOURCE_IDS))
+		return NULL;
+	return &logger->source_map[id];
+}
+EXPORT_SYMBOL(blog_get_source_info);
+
+/**
+ * blog_log - Log a message
+ * @source_id: Source ID for this location
+ * @client_id: Client ID for this message (module-specific)
+ * @needed_size: Size needed for the message
+ *
+ * Returns a buffer to write the message into
+ */
+void *blog_log(struct blog_logger *logger, u32 source_id, u8 client_id, size_t needed_size)
+{
+	struct blog_tls_ctx *ctx;
+	struct blog_log_entry *entry = NULL;
+	int alloc;
+	int retry_count = 0;
+
+#if BLOG_TRACK_USAGE
+	struct blog_source_info *source;
+#endif
+	/* Preserve payload length; compute rounded total allocation separately */
+	size_t payload_len = needed_size;
+
+	if (payload_len > BLOG_MAX_PAYLOAD) {
+		pr_warn_once("%s: payload %zu exceeds max %u\n",
+				__func__, payload_len, BLOG_MAX_PAYLOAD);
+		return NULL;
+	}
+
+	needed_size = round_up(payload_len + sizeof(struct blog_log_entry), 8);
+#if BLOG_TRACK_USAGE
+	/* Get source info to update stats */
+	source = blog_get_source_info(logger, source_id);
+	if (unlikely(source)) {
+		if (in_serving_softirq()) {
+			atomic_inc(&source->napi_usage);
+			atomic_add(needed_size, &source->napi_bytes);
+		} else {
+			atomic_inc(&source->task_usage);
+			atomic_add(needed_size, &source->task_bytes);
+		}
+	}
+#endif
+
+	while (entry == NULL) {
+		struct blog_pagefrag *pf;
+
+		ctx = blog_get_ctx(logger);
+		if (!ctx) {
+			pr_err("Failed to get TLS context\n");
+			return NULL;
+		}
+		if (!blog_is_valid_kernel_addr(ctx)) {
+			pr_err("%s: invalid TLS context address: %pK\n",
+			       __func__, ctx);
+			return NULL;
+		}
+		if (unlikely(retry_count)) {
+			pr_debug(
+				"[%d]Retrying allocation with ctx %llu (%s, pid %d) (retry %d, needed_size=%zu @ %d)\n",
+				smp_processor_id(), ctx->id, ctx->comm,
+				ctx->pid, retry_count, needed_size, source_id);
+		}
+
+		pf = blog_ctx_pf(ctx);
+		alloc = blog_pagefrag_reserve(pf, needed_size);
+		if (alloc == -ENOMEM) {
+			pr_debug("%s: allocation failed (needed %zu), resetting context\n",
+				 __func__, needed_size);
+			blog_pagefrag_reset(pf);
+			retry_count++;
+			if (retry_count > 3) {
+				pr_err("%s: failed to allocate after 3 retries\n", __func__);
+				return NULL;
+			}
+			continue;
+		}
+
+		entry = blog_pagefrag_get_ptr(pf, alloc);
+		if (!entry) {
+			pr_err("%s: failed to get pointer from pagefrag\n", __func__);
+			return NULL;
+		}
+		pf->last_entry = entry;
+
+		/* Store pending publish info for blog_log_commit() */
+		ctx->pending_offset = alloc;
+		ctx->pending_size = needed_size;
+	}
+
+#if BLOG_DEBUG_POISON
+	entry->debug_poison = BLOG_LOG_ENTRY_POISON;
+#endif
+	entry->ts_delta = (u32)(jiffies - ctx->base_jiffies);
+	entry->source_id = (u16)source_id;
+	entry->len = (u8)payload_len;
+	entry->client_id = client_id;
+	entry->flags = 0;
+
+	pr_err("blog_log: source_id=%u, payload_len=%zu, needed_size=%zu, offset=%d\n",
+		source_id, payload_len, needed_size, ctx->pending_offset);
+
+	/* Debug: Show entry location relative to composite */
+	{
+		struct blog_tls_pagefrag *composite = blog_ctx_container(ctx);
+		size_t entry_offset_from_composite = (char *)entry - (char *)composite;
+		size_t buffer_offset_from_composite = (char *)composite->buf - (char *)composite;
+		pr_err("blog_log: composite=%p, entry=%p, entry_offset=%zu, buffer_start_offset=%zu\n",
+			composite, entry, entry_offset_from_composite, buffer_offset_from_composite);
+	}
+
+	return entry->buffer;
+}
+EXPORT_SYMBOL(blog_log);
+
+/**
+ * blog_log_commit - Publish a reserved log entry
+ * @logger: Logger instance
+ * @actual_size: Actual bytes written during serialization
+ *
+ * Publishes the log entry that was reserved by the last blog_log() call.
+ * Must be called after serialization is complete to make the entry visible
+ * to readers.
+ *
+ * Context: Same context as the preceding blog_log() call
+ * Return: 0 on success, negative error code on failure
+ */
+int blog_log_commit(struct blog_logger *logger, size_t actual_size)
+{
+	struct blog_tls_ctx *ctx = blog_get_ctx(logger);
+	struct blog_pagefrag *pf;
+	struct blog_log_entry *entry;
+	size_t total_size;
+
+	if (!ctx)
+		return -EINVAL;
+
+	pf = blog_ctx_pf(ctx);
+
+	/* Get the entry we're committing and update its length to actual size */
+	entry = blog_pagefrag_get_ptr(pf, ctx->pending_offset);
+	if (entry)
+		entry->len = (u8)actual_size;
+
+	/* actual_size is payload only, need to add header + alignment */
+	total_size = round_up(sizeof(struct blog_log_entry) + actual_size, 8);
+
+	pr_err("blog_log_commit: pending_offset=%d, actual_size=%zu, total_size=%zu, pending_size=%zu\n",
+		ctx->pending_offset, actual_size, total_size, ctx->pending_size);
+
+	blog_pagefrag_publish(pf, ctx->pending_offset + total_size);
+
+	return 0;
+}
+EXPORT_SYMBOL(blog_log_commit);
+
+/**
+ * blog_get_napi_ctx - Get NAPI context for current CPU
+ */
+struct blog_tls_ctx *blog_get_napi_ctx(struct blog_logger *logger)
+{
+	struct blog_tls_ctx **napi_ctx_ptr;
+
+	if (!logger || !logger->napi_ctxs)
+		return NULL;
+
+	napi_ctx_ptr = per_cpu_ptr(logger->napi_ctxs, smp_processor_id());
+	return napi_ctx_ptr ? *napi_ctx_ptr : NULL;
+}
+EXPORT_SYMBOL(blog_get_napi_ctx);
+
+/**
+ * blog_set_napi_ctx - Set NAPI context for current CPU
+ */
+void blog_set_napi_ctx(struct blog_logger *logger, struct blog_tls_ctx *ctx)
+{
+	struct blog_tls_ctx **napi_ctx_ptr;
+
+	if (!logger || !logger->napi_ctxs)
+		return;
+
+	napi_ctx_ptr = per_cpu_ptr(logger->napi_ctxs, smp_processor_id());
+	if (napi_ctx_ptr)
+		*napi_ctx_ptr = ctx;
+}
+EXPORT_SYMBOL(blog_set_napi_ctx);
+
+/**
+ * blog_get_ctx - Get appropriate context based on context type
+ */
+struct blog_tls_ctx *blog_get_ctx(struct blog_logger *logger)
+{
+	if (in_serving_softirq()) {
+		struct blog_tls_ctx *n = blog_get_napi_ctx(logger);
+
+		if (n)
+			return n;
+		/* Fallback to TLS context if no NAPI context set */
+	}
+	return blog_get_tls_ctx(logger);
+}
+EXPORT_SYMBOL(blog_get_ctx);
+
+/**
+ * blog_log_iter_init - Initialize the iterator for a specific pagefrag
+ */
+void blog_log_iter_init(struct blog_log_iter *iter, struct blog_pagefrag *pf,
+			u64 head_snapshot)
+{
+	if (!iter || !pf)
+		return;
+
+	iter->pf = pf;
+	iter->current_offset = 0;
+	iter->end_offset = head_snapshot;
+	iter->prev_offset = 0;
+	iter->steps = 0;
+}
+EXPORT_SYMBOL(blog_log_iter_init);
+
+/**
+ * blog_log_iter_next - Get next log entry
+ */
+struct blog_log_entry *blog_log_iter_next(struct blog_log_iter *iter)
+{
+	struct blog_log_entry *entry;
+
+	if (!iter || iter->current_offset >= iter->end_offset)
+		return NULL;
+
+	entry = blog_pagefrag_get_ptr(iter->pf, iter->current_offset);
+	if (!entry)
+		return NULL;
+
+	iter->prev_offset = iter->current_offset;
+	iter->current_offset +=
+		round_up(sizeof(struct blog_log_entry) + entry->len, 8);
+	iter->steps++;
+
+	return entry;
+}
+EXPORT_SYMBOL(blog_log_iter_next);
+
+/**
+ * blog_des_entry - Deserialize entry with callback
+ */
+int blog_des_entry(struct blog_logger *logger, struct blog_log_entry *entry,
+		   char *output, size_t out_size, blog_client_des_fn client_cb)
+{
+	int len = 0;
+	struct blog_source_info *source;
+
+	if (!entry || !output)
+		return -EINVAL;
+
+	/* Let module handle client_id if callback provided */
+	if (client_cb) {
+		len = client_cb(output, out_size, entry->client_id);
+		if (len < 0)
+			return len;
+	}
+
+	/* Get source info */
+	source = blog_get_source_info(logger, entry->source_id);
+	if (!source) {
+		len += snprintf(output + len, out_size - len,
+				"[unknown source %u]", entry->source_id);
+		return len;
+	}
+
+	pr_err("blog_des_entry: source_id=%u, source=%p, fmt=%p (%s), entry->len=%u\n",
+		entry->source_id, source, source->fmt, source->fmt ? source->fmt : "NULL", entry->len);
+
+	/* Debug: Show entry pointer and payload pointer */
+	pr_err("blog_des_entry: entry=%p, entry->buffer=%p, buffer_offset=%ld\n",
+		entry, entry->buffer, (char *)entry->buffer - (char *)entry);
+
+	/* Add source location */
+	len += snprintf(output + len, out_size - len, "[%s:%s:%u] ",
+			source->file, source->func, source->line);
+
+	/* Deserialize the buffer content */
+	len += blog_des_reconstruct(source->fmt, entry->buffer, 0, entry->len,
+				    output + len, out_size - len);
+
+	return len;
+}
+EXPORT_SYMBOL(blog_des_entry);
+
+/* No global init/exit: consumers initialize per‑module contexts explicitly */
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Binary Logging Infrastructure (BLOG)");
diff --git a/lib/blog/blog_des.c b/lib/blog/blog_des.c
new file mode 100644
index 000000000000..661d5b7c2f10
--- /dev/null
+++ b/lib/blog/blog_des.c
@@ -0,0 +1,385 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Binary Logging Deserialization
+ *
+ * Migrated from ceph_san_des.c with all algorithms preserved
+ */
+
+#include <linux/blog/blog_des.h>
+#include <linux/blog/blog.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/align.h>
+#include <linux/unaligned.h>
+
+/**
+ * blog_des_reconstruct - Reconstructs a formatted string from serialized values
+ * @fmt: Format string containing % specifiers
+ * @buffer: Buffer containing serialized values
+ * @nr_args: Number of arguments to process (not used yet, for future)
+ * @size: Size of the buffer in bytes
+ * @out: Buffer to store the reconstructed string
+ * @out_size: Size of the output buffer
+ *
+ * Return: Number of bytes written to out buffer, or negative error code on failure
+ */
+int blog_des_reconstruct(const char *fmt, const void *buffer, size_t nr_args,
+			  size_t size, char *out, size_t out_size)
+{
+	const char *buf_start = (const char *)buffer;
+	const char *buf_ptr = buf_start;
+	const char *buf_end = buf_start + size;
+	const char *fmt_ptr = fmt;
+	char *out_ptr = out;
+	size_t remaining = out_size - 1; /* Reserve space for null terminator */
+	size_t arg_count = 0;
+	int ret;
+
+	if (!fmt || !buffer || !out || !out_size) {
+		pr_err("blog_des_reconstruct: invalid params fmt=%p buffer=%p out=%p out_size=%zu\n",
+			fmt, buffer, out, out_size);
+		return -EINVAL;
+	}
+
+	*out_ptr = '\0';
+
+	/* Process the format string */
+	while (*fmt_ptr && remaining > 0) {
+		int is_long;
+		int is_long_long;
+
+		if (*fmt_ptr != '%') {
+			/* Copy literal character */
+			*out_ptr++ = *fmt_ptr++;
+			remaining--;
+			continue;
+		}
+
+		/* Skip the '%' */
+		fmt_ptr++;
+
+		/* Handle %% */
+		if (*fmt_ptr == '%') {
+			*out_ptr++ = '%';
+			fmt_ptr++;
+			remaining--;
+			continue;
+		}
+
+		/* Skip flags (-+#0 space) */
+		while (*fmt_ptr && (*fmt_ptr == '-' || *fmt_ptr == '+' || *fmt_ptr == '#' ||
+				   *fmt_ptr == '0' || *fmt_ptr == ' ')) {
+			fmt_ptr++;
+		}
+
+		/* Skip field width (digits or *) */
+		while (*fmt_ptr && (*fmt_ptr >= '0' && *fmt_ptr <= '9'))
+			fmt_ptr++;
+		if (*fmt_ptr == '*')
+			fmt_ptr++;
+
+		/* Skip precision (.digits or .*) */
+		if (*fmt_ptr == '.') {
+			fmt_ptr++;
+			while (*fmt_ptr && (*fmt_ptr >= '0' && *fmt_ptr <= '9'))
+				fmt_ptr++;
+			if (*fmt_ptr == '*')
+				fmt_ptr++;
+		}
+
+		/* Parse length modifiers (l, ll, h, hh, z) */
+		is_long = 0;
+		is_long_long = 0;
+
+		if (*fmt_ptr == 'l') {
+			fmt_ptr++;
+			is_long = 1;
+			if (*fmt_ptr == 'l') {
+				fmt_ptr++;
+				is_long_long = 1;
+				is_long = 0;
+			}
+		} else if (*fmt_ptr == 'h') {
+			fmt_ptr++;
+			if (*fmt_ptr == 'h')
+				fmt_ptr++;
+		} else if (*fmt_ptr == 'z') {
+			fmt_ptr++;
+		}
+
+		/* Parse and handle format specifier */
+		switch (*fmt_ptr) {
+		case 's': { /* String (inline) */
+			const char *str;
+			size_t str_len;
+			size_t max_scan_len;
+
+			if (buf_ptr >= buf_end) {
+				pr_err("blog_des_reconstruct: string arg %zu overruns buffer (no space)\n",
+					arg_count);
+				return -EFAULT;
+			}
+
+			/* String is stored inline in buffer */
+			str = buf_ptr;
+
+			/* Calculate maximum safe length to scan for null terminator */
+			max_scan_len = buf_end - buf_ptr;
+
+			/* Find string length with bounds checking */
+			str_len = strnlen(str, max_scan_len);
+			if (str_len == max_scan_len && str[str_len - 1] != '\0') {
+				pr_err("blog_des_reconstruct: unterminated string at arg %zu (fmt=%s)\n",
+					arg_count, fmt);
+				return -EFAULT;
+			}
+
+			/* Advance buffer pointer with proper alignment */
+			buf_ptr += round_up(str_len + 1, 4);
+
+			if (buf_ptr > buf_end) {
+				pr_err("blog_des_reconstruct: string arg %zu overruns buffer after copy (fmt=%s)\n",
+					arg_count, fmt);
+				return -EFAULT;
+			}
+
+			/* Copy string to output with bounds checking */
+			if (str_len > remaining)
+				str_len = remaining;
+			memcpy(out_ptr, str, str_len);
+			out_ptr += str_len;
+			remaining -= str_len;
+			break;
+		}
+
+	case 'd': case 'i': { /* Integer */
+		if (is_long_long) {
+			long long val;
+
+			if (buf_ptr + sizeof(long long) > buf_end) {
+				pr_err("blog_des_reconstruct: long long arg %zu overruns buffer\n",
+					arg_count);
+				return -EFAULT;
+			}
+			val = get_unaligned((long long *)buf_ptr);
+			buf_ptr += sizeof(long long);
+			ret = snprintf(out_ptr, remaining, "%lld", val);
+		} else if (is_long) {
+			long val;
+
+			if (buf_ptr + sizeof(long) > buf_end) {
+				pr_err("blog_des_reconstruct: long arg %zu overruns buffer\n",
+					arg_count);
+				return -EFAULT;
+			}
+			val = get_unaligned((long *)buf_ptr);
+			buf_ptr += sizeof(long);
+			ret = snprintf(out_ptr, remaining, "%ld", val);
+		} else {
+			int val;
+
+			if (buf_ptr + sizeof(int) > buf_end) {
+				pr_err("blog_des_reconstruct: int arg %zu overruns buffer\n",
+					arg_count);
+				return -EFAULT;
+			}
+			val = get_unaligned((int *)buf_ptr);
+			buf_ptr += sizeof(int);
+			ret = snprintf(out_ptr, remaining, "%d", val);
+		}
+
+			if (ret > 0) {
+				if (ret > remaining)
+					ret = remaining;
+				out_ptr += ret;
+				remaining -= ret;
+			}
+			break;
+		}
+
+	case 'u': { /* Unsigned integer */
+		if (is_long_long) {
+			unsigned long long val;
+
+			if (buf_ptr + sizeof(unsigned long long) > buf_end) {
+				pr_err("blog_des_reconstruct: unsigned long long arg %zu overruns buffer\n",
+					arg_count);
+				return -EFAULT;
+			}
+			val = get_unaligned((unsigned long long *)buf_ptr);
+			buf_ptr += sizeof(unsigned long long);
+			ret = snprintf(out_ptr, remaining, "%llu", val);
+		} else if (is_long) {
+			unsigned long val;
+
+			if (buf_ptr + sizeof(unsigned long) > buf_end) {
+				pr_err("blog_des_reconstruct: unsigned long arg %zu overruns buffer\n",
+					arg_count);
+				return -EFAULT;
+			}
+			val = get_unaligned((unsigned long *)buf_ptr);
+			buf_ptr += sizeof(unsigned long);
+			ret = snprintf(out_ptr, remaining, "%lu", val);
+		} else {
+			unsigned int val;
+
+			if (buf_ptr + sizeof(unsigned int) > buf_end) {
+				pr_err("blog_des_reconstruct: unsigned int arg %zu overruns buffer\n",
+					arg_count);
+				return -EFAULT;
+			}
+			val = get_unaligned((unsigned int *)buf_ptr);
+			buf_ptr += sizeof(unsigned int);
+			ret = snprintf(out_ptr, remaining, "%u", val);
+		}
+
+			if (ret > 0) {
+				if (ret > remaining)
+					ret = remaining;
+				out_ptr += ret;
+				remaining -= ret;
+			}
+			break;
+		}
+
+	case 'x': case 'X': { /* Hex integer */
+		const char *hex_fmt;
+
+		if (*fmt_ptr == 'x')
+			hex_fmt = is_long_long ? "%llx" : is_long ? "%lx" : "%x";
+		else
+			hex_fmt = is_long_long ? "%llX" : is_long ? "%lX" : "%X";
+
+		if (is_long_long) {
+			unsigned long long val;
+
+			if (buf_ptr + sizeof(unsigned long long) > buf_end) {
+				pr_err("blog_des_reconstruct: hex unsigned long long arg %zu overruns buffer\n",
+					arg_count);
+				return -EFAULT;
+			}
+			val = get_unaligned((unsigned long long *)buf_ptr);
+			buf_ptr += sizeof(unsigned long long);
+			ret = snprintf(out_ptr, remaining, hex_fmt, val);
+		} else if (is_long) {
+			unsigned long val;
+
+			if (buf_ptr + sizeof(unsigned long) > buf_end) {
+				pr_err("blog_des_reconstruct: hex unsigned long arg %zu overruns buffer\n",
+					arg_count);
+				return -EFAULT;
+			}
+			val = get_unaligned((unsigned long *)buf_ptr);
+			buf_ptr += sizeof(unsigned long);
+			ret = snprintf(out_ptr, remaining, hex_fmt, val);
+		} else {
+			unsigned int val;
+
+			if (buf_ptr + sizeof(unsigned int) > buf_end) {
+				pr_err("blog_des_reconstruct: hex unsigned int arg %zu overruns buffer\n",
+					arg_count);
+				return -EFAULT;
+			}
+			val = get_unaligned((unsigned int *)buf_ptr);
+			buf_ptr += sizeof(unsigned int);
+			ret = snprintf(out_ptr, remaining, hex_fmt, val);
+		}
+
+			if (ret > 0) {
+				if (ret > remaining)
+					ret = remaining;
+				out_ptr += ret;
+				remaining -= ret;
+			}
+			break;
+		}
+
+	case 'p': { /* Pointer */
+		void *ptr;
+
+		if (buf_ptr + sizeof(void *) > buf_end) {
+			pr_err("blog_des_reconstruct: pointer arg %zu overruns buffer\n",
+				arg_count);
+			return -EFAULT;
+		}
+
+		ptr = (void *)(unsigned long)get_unaligned((unsigned long *)buf_ptr);
+		buf_ptr += sizeof(void *);
+
+		ret = snprintf(out_ptr, remaining, "%p", ptr);
+		if (ret > 0) {
+			if (ret > remaining)
+				ret = remaining;
+			out_ptr += ret;
+			remaining -= ret;
+		}
+		break;
+	}
+
+	case 'c': { /* Character */
+		char val;
+
+		if (buf_ptr + sizeof(int) > buf_end) { /* chars are promoted to int */
+			pr_err("blog_des_reconstruct: char arg %zu overruns buffer\n",
+				arg_count);
+			return -EFAULT;
+		}
+
+		val = (char)get_unaligned((int *)buf_ptr);
+		buf_ptr += sizeof(int);
+
+		if (remaining > 0) {
+			*out_ptr++ = val;
+			remaining--;
+		}
+		break;
+	}
+
+		default:
+			pr_err("%s: unsupported format specifier '%%%c' at argument %zu\n",
+		       __func__, *fmt_ptr, arg_count);
+			return -EINVAL;
+		}
+
+		fmt_ptr++;
+		arg_count++;
+	}
+
+	/* Null-terminate the output */
+	*out_ptr = '\0';
+
+	return out_ptr - out;
+}
+EXPORT_SYMBOL(blog_des_reconstruct);
+
+/**
+ * blog_log_reconstruct - Reconstructs a formatted string from a log entry
+ * @entry: Log entry containing serialized data
+ * @output: Buffer to write the formatted string to
+ * @output_size: Size of the output buffer
+ *
+ * This reconstructs the log message but does NOT handle client_id.
+ * The caller should handle client_id separately using their module-specific callback.
+ *
+ * Return: Length of formatted string, or negative error code on failure
+ */
+int blog_log_reconstruct(struct blog_logger *logger, const struct blog_log_entry *entry,
+			char *output, size_t output_size)
+{
+	struct blog_source_info *source;
+
+	if (!entry || !output || !logger)
+		return -EINVAL;
+
+	/* Get source info */
+	source = blog_get_source_info(logger, entry->source_id);
+	if (!source)
+		return snprintf(output, output_size, "[unknown source %u]", entry->source_id);
+
+	/* Reconstruct using the format string from source */
+	return blog_des_reconstruct(source->fmt, entry->buffer, 0, entry->len,
+				   output, output_size);
+}
diff --git a/lib/blog/blog_module.c b/lib/blog/blog_module.c
new file mode 100644
index 000000000000..946393659036
--- /dev/null
+++ b/lib/blog/blog_module.c
@@ -0,0 +1,781 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Binary Logging Infrastructure (BLOG) - Per-Module Support
+ *
+ * Implements per-module context management for isolated logging.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/atomic.h>
+#include <linux/sched.h>
+#include <linux/sched/signal.h>
+#include <linux/sched/task.h>
+#include <linux/bitops.h>
+#include <linux/blog/blog.h>
+#include <linux/blog/blog_module.h>
+
+/* Global list of all module contexts */
+static LIST_HEAD(blog_module_contexts);
+static DEFINE_SPINLOCK(blog_modules_lock);
+
+/* Keep in sync with blog_core.c */
+#define BLOG_LOG_BATCH_MAX_FULL 16
+
+/* Global module registry */
+static struct blog_module_registry blog_registry = {
+	.modules = { NULL },
+	.allocated_bitmap = 0,
+	.lock = __SPIN_LOCK_UNLOCKED(blog_registry.lock),
+	.module_count = ATOMIC_INIT(0),
+};
+
+/**
+ * blog_module_register - Register a module and allocate a slot
+ * @module_name: Name of the module
+ *
+ * Registers a module in the global registry and assigns it a slot ID (0-7).
+ * The slot ID is used to index into each task's blog_contexts array.
+ *
+ * Return: Module context on success, NULL if no slots available
+ */
+struct blog_module_context *blog_module_register(const char *module_name)
+{
+	struct blog_module_context *ctx;
+	unsigned long flags;
+	int slot;
+	size_t name_len;
+
+	if (!module_name) {
+		pr_err("blog: module name is NULL\n");
+		return NULL;
+	}
+
+	name_len = strlen(module_name);
+	if (name_len == 0) {
+		pr_err("blog: module name is empty\n");
+		return NULL;
+	}
+
+	if (name_len >= 32) {  /* sizeof(blog_module_context.name) */
+		pr_err("blog: module name too long: '%s' (max 31 chars)\n",
+		       module_name);
+		return NULL;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	spin_lock_irqsave(&blog_registry.lock, flags);
+
+	/* Find first free slot */
+	slot = find_first_zero_bit((unsigned long *)&blog_registry.allocated_bitmap,
+				    BLOG_MAX_MODULES);
+	if (slot >= BLOG_MAX_MODULES) {
+		spin_unlock_irqrestore(&blog_registry.lock, flags);
+		kfree(ctx);
+		pr_err("blog: no free slots available (max %d modules)\n",
+		       BLOG_MAX_MODULES);
+		return NULL;
+	}
+
+	/* Claim the slot */
+	set_bit(slot, (unsigned long *)&blog_registry.allocated_bitmap);
+	blog_registry.modules[slot] = ctx;
+	atomic_inc(&blog_registry.module_count);
+
+	spin_unlock_irqrestore(&blog_registry.lock, flags);
+
+	/* Initialize the context */
+	strscpy(ctx->name, module_name, sizeof(ctx->name));
+	ctx->slot_id = slot;
+	atomic_set(&ctx->refcount, 1);
+	atomic_set(&ctx->allocated_contexts, 0);
+	INIT_LIST_HEAD(&ctx->list);
+
+	pr_info("blog: module '%s' registered with slot %d\n", module_name, slot);
+
+	return ctx;
+}
+EXPORT_SYMBOL(blog_module_register);
+
+/**
+ * blog_module_unregister - Unregister a module and free its slot
+ * @ctx: Module context to unregister
+ *
+ * Removes the module from the global registry and frees its slot.
+ * Also cleans up any active task contexts for this module.
+ */
+void blog_module_unregister(struct blog_module_context *ctx)
+{
+	unsigned long flags;
+	int slot;
+
+	if (!ctx)
+		return;
+
+	slot = ctx->slot_id;
+	if (slot >= BLOG_MAX_MODULES)
+		goto out_free;
+
+	spin_lock_irqsave(&blog_registry.lock, flags);
+	if (test_bit(slot, (unsigned long *)&blog_registry.allocated_bitmap)) {
+		clear_bit(slot, (unsigned long *)&blog_registry.allocated_bitmap);
+		blog_registry.modules[slot] = NULL;
+		atomic_dec(&blog_registry.module_count);
+	}
+	spin_unlock_irqrestore(&blog_registry.lock, flags);
+
+	pr_info("blog: module '%s' unregistered from slot %d\n", ctx->name, slot);
+
+out_free:
+	kfree(ctx);
+}
+EXPORT_SYMBOL(blog_module_unregister);
+
+/* Release hook for per-module TLS contexts */
+static void blog_module_clear_task(struct blog_tls_ctx *ctx)
+{
+	struct task_struct *task;
+
+	if (!ctx)
+		return;
+
+	task = READ_ONCE(ctx->task);
+	if (task) {
+		WRITE_ONCE(ctx->task, NULL);
+		put_task_struct(task);
+	}
+}
+
+static void blog_module_rebalance_log_batch(struct blog_logger *logger)
+{
+	struct blog_magazine *mag;
+
+	if (!logger)
+		return;
+
+	if (logger->log_batch.nr_full <= BLOG_LOG_BATCH_MAX_FULL)
+		return;
+
+	spin_lock(&logger->log_batch.full_lock);
+	if (list_empty(&logger->log_batch.full_magazines)) {
+		spin_unlock(&logger->log_batch.full_lock);
+		return;
+	}
+
+	mag = list_first_entry(&logger->log_batch.full_magazines,
+			      struct blog_magazine, list);
+	list_del(&mag->list);
+	logger->log_batch.nr_full--;
+	spin_unlock(&logger->log_batch.full_lock);
+
+	spin_lock(&logger->alloc_batch.full_lock);
+	list_add(&mag->list, &logger->alloc_batch.full_magazines);
+	logger->alloc_batch.nr_full++;
+	spin_unlock(&logger->alloc_batch.full_lock);
+}
+
+static void blog_module_queue_to_alloc_batch(struct blog_logger *logger,
+						 struct blog_tls_ctx *ctx)
+{
+	struct blog_tls_pagefrag *composite;
+
+	if (!logger || !ctx)
+		return;
+
+	composite = blog_ctx_container(ctx);
+	atomic_set(&ctx->refcount, 0);
+	blog_batch_put(&logger->alloc_batch, composite);
+}
+
+static void blog_module_queue_to_log_batch(struct blog_logger *logger,
+					       struct blog_tls_ctx *ctx)
+{
+	struct blog_tls_pagefrag *composite;
+
+	if (!logger || !ctx)
+		return;
+
+	composite = blog_ctx_container(ctx);
+	atomic_set(&ctx->refcount, 0);
+	blog_batch_put(&logger->log_batch, composite);
+	blog_module_rebalance_log_batch(logger);
+}
+
+static void blog_module_tls_release(void *ptr)
+{
+	struct blog_tls_ctx *ctx = ptr;
+	struct blog_logger *logger;
+
+	if (!ctx)
+		return;
+
+	logger = ctx->logger;
+	if (!logger) {
+		pr_err("BUG: TLS context id=%llu has no logger for release\n",
+		       ctx->id);
+		return;
+	}
+
+	/* Clear task association */
+	blog_module_clear_task(ctx);
+
+	/* Recycle composite to log_batch - no freeing!
+	 * The composite will be recycled back to alloc_batch and reused. */
+	blog_module_queue_to_log_batch(logger, ctx);
+}
+
+/**
+ * blog_module_init - Initialize a per-module BLOG context
+ * @module_name: Name of the module
+ *
+ * Creates an isolated logging context for a specific module.
+ *
+ * Return: Module context on success, NULL on failure
+ */
+struct blog_module_context *blog_module_init(const char *module_name)
+{
+	struct blog_module_context *ctx;
+	struct blog_logger *logger;
+	int i;
+	int ret;
+
+	ctx = blog_module_register(module_name);
+	if (!ctx)
+		return NULL;
+
+	logger = kzalloc(sizeof(*logger), GFP_KERNEL);
+	if (!logger)
+		goto err_unregister;
+
+	logger->magazine_cache = kmem_cache_create("blog_magazine",
+					      sizeof(struct blog_magazine),
+					      0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!logger->magazine_cache)
+		goto err_logger;
+
+	/* Initialize module context */
+	strscpy(ctx->name, module_name, sizeof(ctx->name));
+	ctx->logger = logger;
+	atomic_set(&ctx->refcount, 1);
+	INIT_LIST_HEAD(&ctx->list);
+
+	/* Initialize logger instance */
+	INIT_LIST_HEAD(&logger->contexts);
+	spin_lock_init(&logger->lock);
+	spin_lock_init(&logger->source_lock);
+	spin_lock_init(&logger->ctx_id_lock);
+	atomic_set(&logger->next_source_id, 1);
+	logger->next_ctx_id = 1;
+	logger->total_contexts_allocated = 0;
+	logger->slot_id = ctx->slot_id;
+	logger->has_slot = true;
+	logger->owner_ctx = ctx;
+
+	/* Initialize alloc_batch with preallocation (ready-to-use composites) */
+	ret = blog_batch_init(&logger->alloc_batch, logger->magazine_cache, true);
+	if (ret)
+		goto err_cache;
+
+	/* Initialize log_batch empty (no preallocation - receives used composites) */
+	ret = blog_batch_init(&logger->log_batch, logger->magazine_cache, false);
+	if (ret)
+		goto err_batch_alloc;
+
+	/* Initialize source map */
+	for (i = 0; i < BLOG_MAX_SOURCE_IDS; i++)
+		memset(&logger->source_map[i], 0, sizeof(logger->source_map[i]));
+
+	/* Allocate per-CPU NAPI context pointers */
+	logger->napi_ctxs = alloc_percpu(struct blog_tls_ctx *);
+	if (!logger->napi_ctxs)
+		goto err_batches;
+
+	/* Add to global list */
+	spin_lock(&blog_modules_lock);
+	list_add(&ctx->list, &blog_module_contexts);
+	spin_unlock(&blog_modules_lock);
+
+	pr_info("BLOG: Module context initialized for %s\n", module_name);
+	ctx->initialized = true;
+	return ctx;
+
+err_batches:
+	blog_batch_cleanup(&logger->log_batch);
+err_batch_alloc:
+	blog_batch_cleanup(&logger->alloc_batch);
+err_cache:
+	if (logger->magazine_cache) {
+		kmem_cache_destroy(logger->magazine_cache);
+		logger->magazine_cache = NULL;
+	}
+err_logger:
+	kfree(logger);
+err_unregister:
+	blog_module_unregister(ctx);
+	return NULL;
+}
+EXPORT_SYMBOL(blog_module_init);
+
+/**
+ * blog_module_cleanup - Clean up a module's BLOG context
+ * @ctx: Module context to clean up
+ */
+void blog_module_cleanup(struct blog_module_context *ctx)
+{
+	struct blog_logger *logger;
+	struct blog_tls_ctx *tls_ctx, *tmp;
+	LIST_HEAD(pending);
+	int slot;
+
+	if (!ctx || !ctx->initialized)
+		return;
+
+	logger = ctx->logger;
+	if (!logger)
+		return;
+
+	slot = ctx->slot_id;
+
+	/* Remove from global list */
+	spin_lock(&blog_modules_lock);
+	list_del(&ctx->list);
+	spin_unlock(&blog_modules_lock);
+
+	/* Detach contexts under lock, release outside */
+	spin_lock(&logger->lock);
+	list_for_each_entry_safe(tls_ctx, tmp, &logger->contexts, list)
+		list_move(&tls_ctx->list, &pending);
+	spin_unlock(&logger->lock);
+
+	list_for_each_entry_safe(tls_ctx, tmp, &pending, list) {
+		struct task_struct *task = tls_ctx->task;
+
+		list_del_init(&tls_ctx->list);
+		if (task && slot < BLOG_MAX_MODULES) {
+			task_lock(task);
+			if (READ_ONCE(task->blog_contexts[slot]) == tls_ctx)
+				WRITE_ONCE(task->blog_contexts[slot], NULL);
+			task_unlock(task);
+		}
+		if (atomic_dec_if_positive(&ctx->allocated_contexts) < 0)
+			atomic_set(&ctx->allocated_contexts, 0);
+
+		/* Clear task association */
+		blog_module_clear_task(tls_ctx);
+
+		/* Recycle composite to log_batch instead of freeing */
+		if (tls_ctx->release) {
+			tls_ctx->release(tls_ctx);
+		} else if (logger) {
+			blog_module_queue_to_log_batch(logger, tls_ctx);
+		}
+	}
+
+	/* Clean up batches (each has its own magazine_cache, will be destroyed) */
+	blog_batch_cleanup(&logger->alloc_batch);
+	blog_batch_cleanup(&logger->log_batch);
+
+	/* Destroy shared magazine cache */
+	if (logger->magazine_cache) {
+		kmem_cache_destroy(logger->magazine_cache);
+		logger->magazine_cache = NULL;
+	}
+
+	/* Free per-CPU NAPI contexts */
+	if (logger->napi_ctxs)
+		free_percpu(logger->napi_ctxs);
+
+	pr_info("BLOG: Module context cleaned up for %s\n", ctx->name);
+
+	kfree(logger);
+	ctx->logger = NULL;
+	ctx->initialized = false;
+	ctx->slot_id = 0;
+
+	/* Unregister to free the slot */
+	blog_module_unregister(ctx);
+}
+EXPORT_SYMBOL(blog_module_cleanup);
+
+/**
+ * blog_module_get - Increment module context reference count
+ * @ctx: Module context
+ */
+void blog_module_get(struct blog_module_context *ctx)
+{
+	if (ctx)
+		atomic_inc(&ctx->refcount);
+}
+EXPORT_SYMBOL(blog_module_get);
+
+/**
+ * blog_module_put - Decrement module context reference count
+ * @ctx: Module context
+ */
+void blog_module_put(struct blog_module_context *ctx)
+{
+	if (ctx && atomic_dec_and_test(&ctx->refcount))
+		blog_module_cleanup(ctx);
+}
+EXPORT_SYMBOL(blog_module_put);
+
+/* Per-module API implementations */
+
+/**
+ * blog_get_source_id_ctx - Get or allocate source ID for a module context
+ * @ctx: Module context
+ * @file: Source file name
+ * @func: Function name
+ * @line: Line number
+ * @fmt: Format string
+ *
+ * Return: Source ID
+ */
+u32 blog_get_source_id_ctx(struct blog_module_context *ctx, const char *file,
+			   const char *func, unsigned int line, const char *fmt)
+{
+	struct blog_logger *logger;
+	struct blog_source_info *info;
+	u32 id;
+
+	if (!ctx || !ctx->logger)
+		return 0;
+
+	logger = ctx->logger;
+
+	/* Get next ID */
+	id = atomic_fetch_inc(&logger->next_source_id);
+	if (id >= BLOG_MAX_SOURCE_IDS) {
+		pr_warn("BLOG: Source ID overflow in module %s\n", ctx->name);
+		return 0;
+	}
+
+	/* Fill in source info */
+	spin_lock(&logger->source_lock);
+	info = &logger->source_map[id];
+	info->file = file;
+	info->func = func;
+	info->line = line;
+	info->fmt = fmt;
+	info->warn_count = 0;
+#if BLOG_TRACK_USAGE
+	atomic_set(&info->napi_usage, 0);
+	atomic_set(&info->task_usage, 0);
+	atomic_set(&info->napi_bytes, 0);
+	atomic_set(&info->task_bytes, 0);
+#endif
+	spin_unlock(&logger->source_lock);
+
+	return id;
+}
+EXPORT_SYMBOL(blog_get_source_id_ctx);
+
+/**
+ * blog_get_source_info_ctx - Get source info for an ID in a module context
+ * @ctx: Module context
+ * @id: Source ID
+ *
+ * Return: Source info or NULL
+ */
+struct blog_source_info *blog_get_source_info_ctx(struct blog_module_context *ctx, u32 id)
+{
+	struct blog_logger *logger;
+
+	if (!ctx || !ctx->logger || id >= BLOG_MAX_SOURCE_IDS)
+		return NULL;
+
+	logger = ctx->logger;
+	return &logger->source_map[id];
+}
+EXPORT_SYMBOL(blog_get_source_info_ctx);
+
+/**
+ * blog_get_tls_ctx_ctx - Get or create TLS context for a module
+ * @ctx: Module context
+ *
+ * Uses slot-based access into task_struct's blog_contexts array.
+ * Allocates composites from the magazine batch system.
+ *
+ * Return: TLS context or NULL
+ */
+struct blog_tls_ctx *blog_get_tls_ctx_ctx(struct blog_module_context *ctx)
+{
+	struct blog_logger *logger;
+	struct blog_tls_ctx *tls_ctx;
+	struct blog_tls_pagefrag *composite;
+	struct blog_pagefrag *pf;
+	struct task_struct *task = current;
+	u8 slot_id;
+
+	if (!ctx || !ctx->logger)
+		return NULL;
+
+	logger = ctx->logger;
+	slot_id = ctx->slot_id;
+
+	if (slot_id >= BLOG_MAX_MODULES) {
+		pr_err("blog: invalid slot_id %d for module %s\n", slot_id, ctx->name);
+		return NULL;
+	}
+
+	/* Fast path: check if context already exists */
+	tls_ctx = READ_ONCE(task->blog_contexts[slot_id]);
+	if (tls_ctx)
+		return tls_ctx;
+
+	/* Slow path: get composite from batch or allocate new one */
+	composite = blog_batch_get(&logger->alloc_batch);
+	if (!composite) {
+		/* Allocate new composite via page allocator (512KB) */
+		struct page *pages;
+
+		pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				    get_order(BLOG_TLS_PAGEFRAG_ALLOC_SIZE));
+		if (!pages)
+			return NULL;
+		composite = page_address(pages);
+	}
+
+	tls_ctx = &composite->ctx;
+
+	/* Initialize if this is a new or uninitialized composite */
+	if (tls_ctx->id == 0) {
+		INIT_LIST_HEAD(&tls_ctx->list);
+
+		/* Get unique context ID */
+		spin_lock(&logger->ctx_id_lock);
+		tls_ctx->id = logger->next_ctx_id++;
+		spin_unlock(&logger->ctx_id_lock);
+
+#if BLOG_DEBUG_POISON
+		tls_ctx->debug_poison = BLOG_CTX_POISON;
+#endif
+	}
+
+	/* Initialize TLS context fields */
+	atomic_set(&tls_ctx->refcount, 1);
+	get_task_struct(task);
+	tls_ctx->task = task;
+	tls_ctx->pid = task->pid;
+	get_task_comm(tls_ctx->comm, task);
+	tls_ctx->base_jiffies = jiffies;
+	tls_ctx->release = blog_module_tls_release;
+	tls_ctx->logger = logger;
+
+	/* Initialize embedded pagefrag to point to inline buffer */
+	pf = &composite->pf;
+	pf->pages = NULL;  /* No separate pages, using inline buffer */
+	pf->buffer = composite->buf;  /* Point to inline buffer */
+	pf->capacity = BLOG_TLS_PAGEFRAG_BUFFER_SIZE;  /* Inline buffer size (512KB - header) */
+	spin_lock_init(&pf->lock);
+	pf->head = 0;
+	pf->alloc_count = 0;
+	pf->active_elements = 0;
+	pf->last_entry = NULL;
+
+	/* Ensure context is linked into logger list exactly once */
+	spin_lock(&logger->lock);
+	if (list_empty(&tls_ctx->list)) {
+		list_add(&tls_ctx->list, &logger->contexts);
+		logger->total_contexts_allocated++;
+	}
+	spin_unlock(&logger->lock);
+
+	/* Install in task's context array - use cmpxchg for atomicity */
+	if (cmpxchg(&task->blog_contexts[slot_id], NULL, tls_ctx) != NULL) {
+		/* Another thread beat us to it - recycle our composite */
+		blog_module_clear_task(tls_ctx);
+		blog_module_queue_to_alloc_batch(logger, tls_ctx);
+		return task->blog_contexts[slot_id];
+	}
+
+	/* Context successfully installed */
+	atomic_inc(&ctx->allocated_contexts);
+
+	pr_debug("blog: created TLS context for module %s (slot %d), task %d [%s]\n",
+		 ctx->name, slot_id, task->pid, task->comm);
+
+	return tls_ctx;
+}
+EXPORT_SYMBOL(blog_get_tls_ctx_ctx);
+
+/**
+ * blog_log_ctx - Log a message with module context
+ * @ctx: Module context
+ * @source_id: Source ID
+ * @client_id: Client ID
+ * @needed_size: Size needed for the log entry
+ *
+ * Return: Buffer to write log data to, or NULL on failure
+ */
+void *blog_log_ctx(struct blog_module_context *ctx, u32 source_id,
+		   u8 client_id, size_t needed_size)
+{
+	struct blog_tls_ctx *tls_ctx;
+	struct blog_pagefrag *pf;
+	struct blog_log_entry *entry;
+	int alloc;
+	size_t total_size;
+
+	if (!ctx || !ctx->logger)
+		return NULL;
+
+	/* Get TLS context */
+	tls_ctx = blog_get_tls_ctx_ctx(ctx);
+	if (!tls_ctx)
+		return NULL;
+
+	/* Validate payload size */
+	if (needed_size > BLOG_MAX_PAYLOAD) {
+		pr_warn_once("BLOG: payload too large (%zu > %u) in module %s\n",
+			     needed_size, BLOG_MAX_PAYLOAD, ctx->name);
+		return NULL;
+	}
+
+	/* Calculate total size needed (with alignment) */
+	total_size = round_up(sizeof(*entry) + needed_size, 8);
+
+	/* Get pagefrag from composite */
+	pf = blog_ctx_pf(tls_ctx);
+
+	/* Reserve space from pagefrag */
+	alloc = blog_pagefrag_reserve(pf, total_size);
+	if (alloc == -ENOMEM) {
+		pr_debug("%s: allocation failed for module %s\n",
+		       __func__, ctx->name);
+		blog_pagefrag_reset(pf);
+		return NULL;
+	}
+
+	/* Get pointer from allocation */
+	entry = blog_pagefrag_get_ptr(pf, alloc);
+	if (!entry) {
+		pr_err("%s: failed to get pointer from pagefrag\n", __func__);
+		return NULL;
+	}
+
+	/* Store pending publish info for blog_log_commit_ctx() */
+	tls_ctx->pending_offset = alloc;
+	tls_ctx->pending_size = total_size;
+
+	/* Fill in entry header */
+#if BLOG_DEBUG_POISON
+	entry->debug_poison = BLOG_LOG_ENTRY_POISON;
+#endif
+	entry->ts_delta = jiffies - tls_ctx->base_jiffies;
+	entry->source_id = source_id;
+	entry->len = (u8)needed_size;
+	entry->client_id = client_id;
+	entry->flags = 0;
+
+	/* Return pointer to buffer area */
+	return entry->buffer;
+}
+EXPORT_SYMBOL(blog_log_ctx);
+
+/**
+ * blog_log_commit_ctx - Publish a reserved log entry
+ * @ctx: Module context
+ * @actual_size: Actual bytes written during serialization
+ *
+ * Publishes the log entry that was reserved by the last blog_log_ctx() call,
+ * making it visible to readers. Must be called after serialization is complete.
+ *
+ * Context: Same context as the preceding blog_log_ctx() call
+ * Return: 0 on success, negative error code on failure
+ */
+int blog_log_commit_ctx(struct blog_module_context *ctx, size_t actual_size)
+{
+	struct blog_tls_ctx *tls_ctx;
+	struct blog_pagefrag *pf;
+	struct blog_log_entry *entry;
+	size_t total_size;
+
+	if (!ctx || !ctx->logger)
+		return -EINVAL;
+
+	tls_ctx = blog_get_ctx_ctx(ctx);
+	if (!tls_ctx)
+		return -EINVAL;
+
+	pf = blog_ctx_pf(tls_ctx);
+
+	/* Get the entry we're committing and update its length to actual size */
+	entry = blog_pagefrag_get_ptr(pf, tls_ctx->pending_offset);
+	if (entry)
+		entry->len = (u8)actual_size;
+
+	/* actual_size is payload only, need to add header + alignment */
+	total_size = round_up(sizeof(struct blog_log_entry) + actual_size, 8);
+
+	pr_err("blog_log_commit_ctx: pending_offset=%d, actual_size=%zu, total_size=%zu, pending_size=%zu\n",
+		tls_ctx->pending_offset, actual_size, total_size, tls_ctx->pending_size);
+
+	blog_pagefrag_publish(pf, tls_ctx->pending_offset + total_size);
+
+	return 0;
+}
+EXPORT_SYMBOL(blog_log_commit_ctx);
+
+/**
+ * blog_get_ctx_ctx - Get appropriate context based on execution context
+ * @ctx: Module context
+ *
+ * Return: TLS context or NAPI context depending on execution context
+ */
+struct blog_tls_ctx *blog_get_ctx_ctx(struct blog_module_context *ctx)
+{
+	if (in_serving_softirq())
+		return blog_get_napi_ctx_ctx(ctx);
+	return blog_get_tls_ctx_ctx(ctx);
+}
+EXPORT_SYMBOL(blog_get_ctx_ctx);
+
+/**
+ * blog_get_napi_ctx_ctx - Get NAPI context for current CPU
+ * @ctx: Module context
+ *
+ * Return: NAPI context or NULL
+ */
+struct blog_tls_ctx *blog_get_napi_ctx_ctx(struct blog_module_context *ctx)
+{
+	struct blog_logger *logger;
+	struct blog_tls_ctx **napi_ctx_ptr;
+
+	if (!ctx || !ctx->logger)
+		return NULL;
+
+	logger = ctx->logger;
+	if (!logger->napi_ctxs)
+		return NULL;
+
+	/* Get pointer to the percpu pointer */
+	napi_ctx_ptr = per_cpu_ptr(logger->napi_ctxs, smp_processor_id());
+	return *napi_ctx_ptr;
+}
+EXPORT_SYMBOL(blog_get_napi_ctx_ctx);
+
+/**
+ * blog_set_napi_ctx_ctx - Set NAPI context for current CPU
+ * @ctx: Module context
+ * @tls_ctx: TLS context to set
+ */
+void blog_set_napi_ctx_ctx(struct blog_module_context *ctx, struct blog_tls_ctx *tls_ctx)
+{
+	struct blog_logger *logger;
+	struct blog_tls_ctx **napi_ctx_ptr;
+
+	if (!ctx || !ctx->logger || !ctx->logger->napi_ctxs)
+		return;
+
+	logger = ctx->logger;
+	/* Get pointer to the percpu pointer and set it */
+	napi_ctx_ptr = per_cpu_ptr(logger->napi_ctxs, smp_processor_id());
+	*napi_ctx_ptr = tls_ctx;
+}
+EXPORT_SYMBOL(blog_set_napi_ctx_ctx);
diff --git a/lib/blog/blog_pagefrag.c b/lib/blog/blog_pagefrag.c
new file mode 100644
index 000000000000..598de9145601
--- /dev/null
+++ b/lib/blog/blog_pagefrag.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Binary Logging Page Fragment Management
+ *
+ * Migrated from ceph_san_pagefrag.c with all algorithms preserved
+ */
+
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/blog/blog_pagefrag.h>
+
+/**
+ * blog_pagefrag_init_with_buffer - Initialize pagefrag with an existing buffer
+ * @pf: pagefrag allocator to initialize
+ * @buffer: pre-allocated buffer to use
+ * @size: size of the buffer
+ *
+ * Return: 0 on success
+ */
+int blog_pagefrag_init_with_buffer(struct blog_pagefrag *pf, void *buffer, size_t size)
+{
+	spin_lock_init(&pf->lock);
+	pf->pages = NULL; /* No pages allocated, using provided buffer */
+	pf->buffer = buffer;
+	pf->capacity = size;  /* Store size for bounds checking */
+	pf->head = 0;
+	pf->active_elements = 0;
+	pf->alloc_count = 0;
+	pf->last_entry = NULL;
+	return 0;
+}
+EXPORT_SYMBOL(blog_pagefrag_init_with_buffer);
+
+/**
+ * blog_pagefrag_reserve - Reserve space in the pagefrag buffer
+ * @pf: pagefrag allocator
+ * @n: number of bytes to reserve
+ *
+ * Checks if there is sufficient space and returns the current head offset
+ * WITHOUT advancing the head pointer. This allows the caller to write data
+ * before making it visible via blog_pagefrag_publish().
+ *
+ * This is lockless - only one writer per pagefrag (per-task context).
+ *
+ * Return: offset to reserved memory, or negative error if not enough space
+ */
+int blog_pagefrag_reserve(struct blog_pagefrag *pf, unsigned int n)
+{
+	if (pf->head + n > pf->capacity)
+		return -ENOMEM; /* No space left */
+	return pf->head;  /* Return offset without advancing */
+}
+EXPORT_SYMBOL(blog_pagefrag_reserve);
+
+/**
+ * blog_pagefrag_publish - Publish reserved space by advancing head pointer
+ * @pf: pagefrag allocator
+ * @publish_head: new head value (offset + bytes_written)
+ *
+ * Atomically advances the head pointer to make previously written data visible
+ * to readers. Must be called after blog_pagefrag_reserve() and writing data.
+ *
+ * Uses memory barrier to ensure all writes are visible before head is updated.
+ * This prevents readers from seeing partially-written entries.
+ *
+ * This is lockless - only one writer per pagefrag (per-task context).
+ */
+void blog_pagefrag_publish(struct blog_pagefrag *pf, u64 publish_head)
+{
+	/* Ensure all prior writes are visible before updating head */
+	smp_wmb();
+
+	/* Atomically update head to make data visible to readers */
+	pf->head = publish_head;
+	pf->alloc_count++;
+	pf->active_elements++;
+}
+EXPORT_SYMBOL(blog_pagefrag_publish);
+
+/**
+ * blog_pagefrag_get_ptr - Get buffer pointer from pagefrag reserve result
+ * @pf: pagefrag allocator
+ * @val: return value from blog_pagefrag_reserve
+ *
+ * Return: pointer to reserved buffer region
+ */
+void *blog_pagefrag_get_ptr(struct blog_pagefrag *pf, u64 val)
+{
+	void *rc = (void *)(pf->buffer + val);
+
+	if (unlikely(pf->pages && pf->buffer != page_address(pf->pages))) {
+		pr_err("%s: invalid buffer pointer %llx @ %s\n", __func__,
+		       (unsigned long long)pf->buffer, current->comm);
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+	if (unlikely((rc) < pf->buffer || (rc) >= (pf->buffer + pf->capacity))) {
+		pr_err("%s: invalid pointer %llx\n", __func__,
+		       (unsigned long long)rc);
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+	return rc;
+}
+EXPORT_SYMBOL(blog_pagefrag_get_ptr);
+
+/**
+ * blog_pagefrag_reset - Reset the pagefrag allocator.
+ *
+ * Resets the head and tail pointers to the beginning of the buffer.
+ */
+void blog_pagefrag_reset(struct blog_pagefrag *pf)
+{
+	spin_lock(&pf->lock);
+	pf->head = 0;
+	pf->active_elements = 0;
+	pf->alloc_count = 0;
+	pf->last_entry = NULL;
+	spin_unlock(&pf->lock);
+}
+EXPORT_SYMBOL(blog_pagefrag_reset);
+
-- 
2.34.1


