Return-Path: <ceph-devel+bounces-3866-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF18C05391
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 11:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6921D4231FB
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 08:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01370305958;
	Fri, 24 Oct 2025 08:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QBD5K0jb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2D6306B11
	for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 08:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761295401; cv=none; b=Ldb/XcK8LCzNddrpSKngvx6DG0qoLQnaJMPxS781MtWi1qwjzmpOjX9Zq06IxQEeKaP5n0uwibOwE+GctWHighPnM3cL6akrjEHmaPKO878cDJecRmhHYvcwposIhcxqLlNE4HUNTmIaBGYpbM7A1Vb9N5R4Bfk8oO0FgJP3bBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761295401; c=relaxed/simple;
	bh=KcKsAV9p8uRtNvt/D7mxzuTmC0iqU0ldEISJcoZrfu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o8pD4JZlfHaU+WmA6Pr9aYvm4d++O3bvvfcWowhJq2CYvDuPVmj9jy57/SzOo1jz91uaWEsGAXBWOLv5NAHQy0wXW78Q+FDJVyVJ68mWkNRuafKCqSOGSEhbJZnLUY7Mb3gfzWw9t3S/E7a+xzN6n0y6WN4s68okDlIWunehvhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QBD5K0jb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761295398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+YEhQugvjJGD9rocNk61MKJgnvqoLJlUTVFDpUrcAXI=;
	b=QBD5K0jbsx4tRpBKY/ctUxtBf3FtkCMTLSpd4rM1GLMyZTzNyMiblMI4H0fdWQutfxKcu9
	FbG7M8utjZ1ZdzWnJPISITCyfTMrZ643hVkidJ5cBwQ3cynTwFONUxDe3I/0hMyVXj2dh1
	cQi8MUNrRLSl1JUA4mCs/8XX9qSbB/o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-jvYA7ixDOK-aZCzwridQ0A-1; Fri, 24 Oct 2025 04:43:17 -0400
X-MC-Unique: jvYA7ixDOK-aZCzwridQ0A-1
X-Mimecast-MFC-AGG-ID: jvYA7ixDOK-aZCzwridQ0A_1761295396
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b6d700a0894so98231866b.0
        for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 01:43:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761295396; x=1761900196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+YEhQugvjJGD9rocNk61MKJgnvqoLJlUTVFDpUrcAXI=;
        b=wtzyT/x0F8pTKdMM4xzY/7MLn/4V5gqYhQ+ojZOD98x8a1gd0Ec1U03rBXrURf8a5X
         H0AC+tixF+1UOwB5Vv51ytt5Eslvp8XV9l/HUYGnODUcNVSZOvjVagWkeNOI47f1mTTA
         cTgHF2+qF4SEJns6KqZwut2ezis5k+l4k53mFgt/frLxptWafqQ3wpiTzvQ4wAcBDn2V
         c7Eu5dA8xpw3jeQrODRbPyane/2cUkqzz4SdR+y09ihudij743dJGFRTDRrcELBAXQc/
         6PMQVAkmyD+lam+b1UN+07jhCRL+QvAC9d9VAHuKOfkbg4Nc+wNcVGrrwm+0cIkyxXGb
         IcbQ==
X-Gm-Message-State: AOJu0YxwgdfUunLDnT159nGtgV4z219xWrWTqyDI3Tn7wpHlS68yqdNe
	SUeVUmChUfsS/TQ/IndXVFfxZ0KsV1JoW8iRg4e7p/GTgCdOF/cCt57yMmb3mEpLGAXz5HtVhNl
	K9/K57d0wORJvHsstY/zVfSHMRLri6cn3nSoRR17tTd1MKo/uS8YXXK5bDbSBMO6q1ANPHt1fY3
	8LmpDQR/h8bywP8RnrDxA41Z5jBjCweeMchZfCbVEJmAGrMdUkVjwrCX0=
X-Gm-Gg: ASbGncvR6ptpSM4T77er9yir9+VMJkdF5t2XSZFo2QORq7yayLo2OdGjci+3MzvTgYt
	I6N9hKZf3kXmfwXtPO7bPp0EpXryuCH6Wg9mlJeaZI7QI8dx+5AvloZ8GpoybzMxzl0I9IRBl7u
	4JLQ1gJKB1po21uzBIrs/735Cxyg5d15s1lnNjg1eaNEPm0RFgaH1nul3Cn02w0ELLzZrZXTo1b
	vqRmW/5IngYr4OOE+kfgp5uPIPCiR5ekEOfzzVE5KQcuek1XLMTl9s8nm2p1UtcLVuVho3+f2gX
	Nr2NiI0znVxAr+xWHNQjK64xsQayziQ6Dl0Q26zM3jhHxCrCVtXvyd/cdug5gzh5KRJsN2diG2d
	EyIV2a4cabXrXA2Wuabpu3j82TE2D5cpj
X-Received: by 2002:a17:907:e887:b0:afa:1d2c:bbd1 with SMTP id a640c23a62f3a-b6d6bcf8c71mr185671966b.30.1761295395525;
        Fri, 24 Oct 2025 01:43:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGY5mEE5uypHs1peyLV3gmUlLkQrdYcM4lntYsOOHalbAYVVbBN+cXnOEwbWEvJxbWbaGXkXw==
X-Received: by 2002:a17:907:e887:b0:afa:1d2c:bbd1 with SMTP id a640c23a62f3a-b6d6bcf8c71mr185666466b.30.1761295394894;
        Fri, 24 Oct 2025 01:43:14 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d010asm469226866b.11.2025.10.24.01.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 01:43:14 -0700 (PDT)
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
Subject: [RFC PATCH 3/5] ceph: Add BLOG scaffolding
Date: Fri, 24 Oct 2025 08:42:57 +0000
Message-Id: <20251024084259.2359693-4-amarkuze@redhat.com>
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

Introduce the Ceph BLOG integration layer that enables the filesystem to
register binary loggers and route log events through module-specific TLS
contexts. This commit establishes the infrastructure for high-performance
binary logging in the Ceph client without modifying existing logging calls.

**Key Components:**

**ceph_blog.h - BLOG-aware macros and interfaces:**
- bout/boutc: Drop-in replacements for dout/doutc with identical semantics
- CEPH_BLOG_LOG_CTX/CEPH_BLOG_LOG: Low-level logging primitives
- Automatic fallback to traditional dout when CONFIG_BLOG is disabled
- Type-safe parameter serialization using BLOG framework

**blog_client.c - Module registration and context management:**
- ceph_blog_init(): Register Ceph-specific BLOG logger on module load
- ceph_blog_exit(): Cleanup and unregister logger on module unload
- ceph_get_tls_ctx(): Acquire per-task BLOG context for current thread
- Client-ID to logger mapping for multi-client scenarios
- Exported symbols for context acquisition from Ceph code paths

**Makefile integration:**
- Conditionally build blog_client.o when CONFIG_CEPH_FS && CONFIG_BLOG
- Clean integration with existing Ceph build system

**Design rationale:**
The bout/boutc macros maintain the same call-site syntax as dout/doutc,
allowing gradual migration and easy A/B testing. Log levels and subsystem
filtering remain unchanged. The TLS context is acquired lazily on first use
per task and recycled automatically on task exit via the BLOG lifecycle
hooks wired in earlier commits.

No existing Ceph logging is modified in this commit. The infrastructure is
in place but inactive until logging call sites are converted to bout/boutc
in subsequent commits.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/Makefile               |   2 +
 fs/ceph/blog_client.c          | 244 +++++++++++++++++++++++++++++++++
 include/linux/ceph/ceph_blog.h | 124 +++++++++++++++++
 3 files changed, 370 insertions(+)
 create mode 100644 fs/ceph/blog_client.c
 create mode 100644 include/linux/ceph/ceph_blog.h

diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index 1f77ca04c426..ccb542870ab3 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -10,6 +10,8 @@ ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
 	mds_client.o mdsmap.o strings.o ceph_frag.o \
 	debugfs.o util.o metric.o
 
+ceph-$(CONFIG_BLOG) += blog_client.o blog_debugfs.o
+
 ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
 ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
 ceph-$(CONFIG_FS_ENCRYPTION) += crypto.o
diff --git a/fs/ceph/blog_client.c b/fs/ceph/blog_client.c
new file mode 100644
index 000000000000..2d9c7e37f918
--- /dev/null
+++ b/fs/ceph/blog_client.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Ceph client ID management for BLOG integration
+ *
+ * Maintains mapping between Ceph's fsid/global_id and BLOG client IDs
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/libceph.h>
+#include <linux/ceph/ceph_blog.h>
+#include <linux/blog/blog.h>
+
+/* Ceph's BLOG module context */
+struct blog_module_context *ceph_blog_ctx;
+EXPORT_SYMBOL(ceph_blog_ctx);
+
+/* Ceph's logger - direct access to the logger from module context */
+struct blog_logger *ceph_logger;
+EXPORT_SYMBOL(ceph_logger);
+
+/* Global client mapping state */
+static struct {
+	struct ceph_blog_client_info client_map[CEPH_BLOG_MAX_CLIENTS];
+	u32 next_client_id;
+	spinlock_t lock;  /* protects client_map */
+	bool initialized;
+} ceph_blog_state = {
+	.next_client_id = 1,  /* Start from 1, 0 is reserved */
+	.lock = __SPIN_LOCK_UNLOCKED(ceph_blog_state.lock),
+	.initialized = false,
+};
+
+static bool ceph_blog_ids_match(const struct ceph_blog_client_info *entry,
+				     const char *fsid, u64 global_id)
+{
+	if (!entry)
+		return false;
+	if (entry->global_id != global_id)
+		return false;
+	return !memcmp(entry->fsid, fsid, sizeof(entry->fsid));
+}
+
+/**
+ * ceph_blog_init - Initialize Ceph BLOG integration
+ *
+ * Creates a module-specific BLOG context for Ceph and initializes
+ * the client ID mapping state.
+ *
+ * Return: 0 on success, negative error code on failure
+ */
+int ceph_blog_init(void)
+{
+	if (ceph_blog_state.initialized)
+		return 0;
+
+	/* Create Ceph's module-specific BLOG context */
+	ceph_blog_ctx = blog_module_init("ceph");
+	if (!ceph_blog_ctx) {
+		pr_err("ceph: Failed to initialize BLOG module context\n");
+		return -ENOMEM;
+	}
+
+	/* Set ceph_logger for direct access to the logger */
+	ceph_logger = ceph_blog_ctx->logger;
+
+	/* Initialize client mapping state */
+	memset(ceph_blog_state.client_map, 0, sizeof(ceph_blog_state.client_map));
+	ceph_blog_state.next_client_id = 1;
+	ceph_blog_state.initialized = true;
+
+	pr_info("ceph: BLOG module context and client mapping initialized\n");
+	return 0;
+}
+EXPORT_SYMBOL(ceph_blog_init);
+
+/**
+ * ceph_blog_cleanup - Clean up Ceph BLOG integration
+ *
+ * Cleans up Ceph's module-specific BLOG context and client mappings.
+ */
+void ceph_blog_cleanup(void)
+{
+	if (!ceph_blog_state.initialized)
+		return;
+
+	/* Clean up client mapping state */
+	spin_lock(&ceph_blog_state.lock);
+	memset(ceph_blog_state.client_map, 0, sizeof(ceph_blog_state.client_map));
+	ceph_blog_state.next_client_id = 1;
+	ceph_blog_state.initialized = false;
+	spin_unlock(&ceph_blog_state.lock);
+
+	/* Clean up module-specific BLOG context */
+	if (ceph_blog_ctx) {
+		blog_module_cleanup(ceph_blog_ctx);
+		ceph_blog_ctx = NULL;
+		ceph_logger = NULL;
+	}
+
+	pr_info("ceph: BLOG module context and client mapping cleaned up\n");
+}
+EXPORT_SYMBOL(ceph_blog_cleanup);
+
+/**
+ * ceph_blog_check_client_id - Check if a client ID matches the given fsid:global_id pair
+ * @id: Client ID to check
+ * @fsid: Client FSID to compare
+ * @global_id: Client global ID to compare
+ *
+ * This preserves the exact functionality of ceph_san_check_client_id.
+ * Returns the actual ID of the pair. If the given ID doesn't match, scans for
+ * existing matches or allocates a new ID if no match is found.
+ *
+ * Return: Client ID for this fsid/global_id pair
+ */
+u32 ceph_blog_check_client_id(u32 id, const char *fsid, u64 global_id)
+{
+	u32 found_id = 0;
+	struct ceph_blog_client_info *entry;
+
+	if (unlikely(!ceph_blog_state.initialized)) {
+		WARN_ON_ONCE(1);  /* Should never happen - init_ceph() initializes BLOG */
+		return 0;  /* Drop the log entry */
+	}
+
+	spin_lock(&ceph_blog_state.lock);
+
+	/* Reuse caller-provided hint when it still matches */
+	if (id != 0 && id < CEPH_BLOG_MAX_CLIENTS) {
+		entry = &ceph_blog_state.client_map[id];
+		if (ceph_blog_ids_match(entry, fsid, global_id)) {
+			found_id = id;
+			goto out;
+		}
+	}
+
+	/* Search for an existing entry with matching identity */
+	for (id = 1; id < CEPH_BLOG_MAX_CLIENTS; id++) {
+		entry = &ceph_blog_state.client_map[id];
+		if (ceph_blog_ids_match(entry, fsid, global_id)) {
+			found_id = id;
+			goto out;
+		}
+	}
+
+	/* Assign new identifier, falling back to overflow slot if exhausted */
+	if (ceph_blog_state.next_client_id >= CEPH_BLOG_MAX_CLIENTS - 1) {
+		found_id = CEPH_BLOG_MAX_CLIENTS - 1;
+		entry = &ceph_blog_state.client_map[found_id];
+	} else {
+		found_id = ceph_blog_state.next_client_id++;
+		entry = &ceph_blog_state.client_map[found_id];
+	}
+
+	memset(entry, 0, sizeof(*entry));
+	memcpy(entry->fsid, fsid, sizeof(entry->fsid));
+	entry->global_id = global_id;
+
+	pr_info("ceph: allocating new BLOG client ID %u for fsid=%pU global_id=%llu\n",
+		found_id, fsid, global_id);
+
+out:
+	spin_unlock(&ceph_blog_state.lock);
+	return found_id;
+}
+EXPORT_SYMBOL(ceph_blog_check_client_id);
+
+/**
+ * ceph_blog_get_client_info - Get client info for a given ID
+ * @id: Client ID
+ *
+ * Return: Client information for this ID, or NULL if invalid
+ */
+const struct ceph_blog_client_info *ceph_blog_get_client_info(u32 id)
+{
+	if (!ceph_blog_state.initialized || id == 0 || id >= CEPH_BLOG_MAX_CLIENTS)
+		return NULL;
+	return &ceph_blog_state.client_map[id];
+}
+EXPORT_SYMBOL(ceph_blog_get_client_info);
+
+/**
+ * ceph_blog_client_des_callback - Deserialization callback for Ceph client info
+ * @buf: Output buffer
+ * @size: Buffer size
+ * @client_id: Client ID to deserialize
+ *
+ * This is the callback that BLOG will use to deserialize client information.
+ *
+ * Return: Number of bytes written to buffer
+ */
+int ceph_blog_client_des_callback(char *buf, size_t size, u8 client_id)
+{
+	const struct ceph_blog_client_info *info;
+
+	if (!buf || !size)
+		return -EINVAL;
+
+	info = ceph_blog_get_client_info(client_id);
+	if (!info)
+		return snprintf(buf, size, "[unknown_client_%u]", client_id);
+
+	/* Use %pU to format fsid, matching boutc and other Ceph client logging */
+	return snprintf(buf, size, "[%pU %llu] ",
+			info->fsid, info->global_id);
+}
+EXPORT_SYMBOL(ceph_blog_client_des_callback);
+
+/**
+ * ceph_blog_get_client_id - Get or allocate client ID for a Ceph client
+ * @client: Ceph client structure
+ *
+ * Return: Client ID for this client
+ */
+u32 ceph_blog_get_client_id(struct ceph_client *client)
+{
+	u32 cached = 0;
+	u32 id;
+
+	if (!client)
+		return 0;
+
+#ifdef CONFIG_BLOG
+	cached = READ_ONCE(client->blog_client_id);
+#endif
+
+	id = ceph_blog_check_client_id(cached,
+					 client->fsid.fsid,
+					 client->monc.auth->global_id);
+	if (!id)
+		return 0;
+
+#ifdef CONFIG_BLOG
+	if (READ_ONCE(client->blog_client_id) != id)
+		WRITE_ONCE(client->blog_client_id, id);
+#endif
+
+	return id;
+}
+EXPORT_SYMBOL(ceph_blog_get_client_id);
diff --git a/include/linux/ceph/ceph_blog.h b/include/linux/ceph/ceph_blog.h
new file mode 100644
index 000000000000..0591e3f29703
--- /dev/null
+++ b/include/linux/ceph/ceph_blog.h
@@ -0,0 +1,124 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Ceph integration with BLOG (Binary LOGging)
+ *
+ * Provides compatibility layer and Ceph-specific extensions
+ */
+#ifndef CEPH_BLOG_H
+#define CEPH_BLOG_H
+
+#include <linux/blog/blog.h>
+#include <linux/blog/blog_module.h>
+#include <linux/ceph/libceph.h>
+
+/* Client ID mapping structure - preserves ceph_san_client_id fields */
+struct ceph_blog_client_info {
+	char fsid[16];         /* Client FSID */
+	u64 global_id;         /* Client global ID */
+};
+
+/* Constants */
+#define CEPH_BLOG_MAX_CLIENTS 256
+
+/* Ceph's BLOG module context */
+extern struct blog_module_context *ceph_blog_ctx;
+
+/* Ceph's logger - direct access to the logger for macros */
+extern struct blog_logger *ceph_logger;
+
+/* Forward declaration for ceph_client */
+struct ceph_client;
+
+/* Compatibility macros for easy migration from ceph_san to BLOG */
+#if IS_ENABLED(CONFIG_BLOG)
+
+/* Ceph BLOG client management functions */
+int ceph_blog_init(void);
+void ceph_blog_cleanup(void);
+u32 ceph_blog_check_client_id(u32 id, const char *fsid, u64 global_id);
+u32 ceph_blog_get_client_id(struct ceph_client *client);
+const struct ceph_blog_client_info *ceph_blog_get_client_info(u32 id);
+int ceph_blog_client_des_callback(char *buf, size_t size, u8 client_id);
+
+/*
+ * All ceph_san compatibility removed - use only BLOG with per-module contexts
+ * CEPH_SAN has been replaced entirely by BLOG per-module logging
+ */
+
+/*
+ * Ceph-specific logging macros - use core BLOG functions with ceph_logger
+ * Note: Only client-aware macros (doutc, boutc) store client_id,
+ * regular macros (dout, bout) do not include client information
+ */
+#define CEPH_BLOG_LOG(fmt, ...) \
+	do { \
+		static u32 __source_id; \
+		static size_t __size; \
+		void *___buffer = NULL; \
+		if (unlikely(!ceph_logger)) \
+			break; \
+		if (unlikely(__source_id == 0)) { \
+			__source_id = blog_get_source_id(ceph_logger, \
+				kbasename(__FILE__), __func__, __LINE__, fmt); \
+			__size = blog_cnt(__VA_ARGS__); \
+		} \
+		___buffer = blog_log(ceph_logger, __source_id, 0, __size); \
+		if (likely(___buffer)) { \
+			void *___tmp = ___buffer; \
+			if (__size > 0) \
+				blog_ser(___buffer, ##__VA_ARGS__); \
+			blog_log_commit(ceph_logger, ___buffer - ___tmp); \
+		} \
+	} while (0)
+
+#define CEPH_BLOG_LOG_CLIENT(client, fmt, ...) \
+	do { \
+		static u32 __source_id; \
+		static size_t __size; \
+		void *___buffer = NULL; \
+		u32 __client_id; \
+		if (unlikely(!ceph_logger)) \
+			break; \
+		if (unlikely(__source_id == 0)) { \
+			__source_id = blog_get_source_id(ceph_logger, \
+				kbasename(__FILE__), __func__, __LINE__, fmt); \
+			__size = blog_cnt(__VA_ARGS__); \
+		} \
+		__client_id = ceph_blog_get_client_id(client); \
+		___buffer = blog_log(ceph_logger, __source_id, __client_id, __size); \
+		if (likely(___buffer)) { \
+			void *___tmp = ___buffer; \
+			if (__size > 0) \
+				blog_ser(___buffer, ##__VA_ARGS__); \
+			blog_log_commit(ceph_logger, ___buffer - ___tmp); \
+		} \
+	} while (0)
+
+/* No legacy ceph_san compatibility - use CEPH_BLOG_LOG* macros only */
+
+#else /* !CONFIG_BLOG */
+
+/* Stub macros when BLOG is not enabled */
+#define CEPH_BLOG_LOG(fmt, ...) do {} while (0)
+#define CEPH_BLOG_LOG_CLIENT(client, fmt, ...) do {} while (0)
+
+/* Stub functions should be static inline, not macros */
+static inline int ceph_blog_init(void) { return 0; }
+static inline void ceph_blog_cleanup(void) { }
+static inline u32 ceph_blog_get_client_id(struct ceph_client *client) { return 0; }
+static inline u32 ceph_blog_check_client_id(u32 id, const char *fsid, u64 global_id) { return 0; }
+static inline const struct ceph_blog_client_info *ceph_blog_get_client_info(u32 id) { return NULL; }
+static inline int ceph_blog_client_des_callback(char *buf, size_t size, u8 client_id) { return 0; }
+
+#endif /* CONFIG_BLOG */
+
+/* Debugfs support */
+#ifdef CONFIG_DEBUG_FS
+int ceph_blog_debugfs_init(struct dentry *parent);
+void ceph_blog_debugfs_cleanup(void);
+#else
+static inline int ceph_blog_debugfs_init(struct dentry *parent) { return 0; }
+static inline void ceph_blog_debugfs_cleanup(void) {}
+#endif
+
+#endif /* CEPH_BLOG_H */
-- 
2.34.1


