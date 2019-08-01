Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF867E410
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfHAU0P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbfHAU0O (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:26:14 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC5A92087E;
        Thu,  1 Aug 2019 20:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564691174;
        bh=nZQgPJKv5fwJ8ut+b7rCh8xkm2nY5C7BWMl6iIexTP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbweZTEca2y2rjgMrm+LHR4wGSK1jUwTm5LV+zXoMoNvgOXXukpcmQmw/BVP+if81
         wa6PfAy5n/vTX3xsKt3gq+RCbD1zhcgqKWoiVZ6rOdrWyEufpVbwIjn96a0Lk9ikuz
         awk6R/G2sEdru3+ZzbNkyd7LVAB4bWg8GT1YKnl8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 8/9] ceph: new tracepoints when adding and removing caps
Date:   Thu,  1 Aug 2019 16:26:04 -0400
Message-Id: <20190801202605.18172-9-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801202605.18172-1-jlayton@kernel.org>
References: <20190801202605.18172-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add support for two new tracepoints surrounding the adding/updating and
removing of caps from the cache. To support this, we also add new functions
for printing cap strings a'la ceph_cap_string().

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/Makefile                |  3 +-
 fs/ceph/caps.c                  |  4 ++
 fs/ceph/trace.c                 | 76 +++++++++++++++++++++++++++++++++
 fs/ceph/trace.h                 | 55 ++++++++++++++++++++++++
 include/linux/ceph/ceph_debug.h |  1 +
 5 files changed, 138 insertions(+), 1 deletion(-)
 create mode 100644 fs/ceph/trace.c
 create mode 100644 fs/ceph/trace.h

diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index a699e320393f..5148284f74a9 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -3,12 +3,13 @@
 # Makefile for CEPH filesystem.
 #
 
+ccflags-y += -I$(src)	# needed for trace events
 obj-$(CONFIG_CEPH_FS) += ceph.o
 
 ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
 	export.o caps.o snap.o xattr.o quota.o \
 	mds_client.o mdsmap.o strings.o ceph_frag.o \
-	debugfs.o
+	debugfs.o trace.o
 
 ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
 ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 9344e742397e..236d9c205e3d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -13,6 +13,7 @@
 #include "super.h"
 #include "mds_client.h"
 #include "cache.h"
+#include "trace.h"
 #include <linux/ceph/decode.h>
 #include <linux/ceph/messenger.h>
 
@@ -754,6 +755,8 @@ void ceph_add_cap(struct inode *inode,
 	cap->mseq = mseq;
 	cap->cap_gen = gen;
 
+	trace_ceph_add_cap(cap);
+
 	if (fmode >= 0)
 		__ceph_get_fmode(ci, fmode);
 }
@@ -1078,6 +1081,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 	int removed = 0;
 
 	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
+	trace_ceph_remove_cap(cap);
 
 	/* remove from session list */
 	spin_lock(&session->s_cap_lock);
diff --git a/fs/ceph/trace.c b/fs/ceph/trace.c
new file mode 100644
index 000000000000..e082d4eb973f
--- /dev/null
+++ b/fs/ceph/trace.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+#define CEPH_CAP_BASE_MASK	(CEPH_CAP_GSHARED|CEPH_CAP_GEXCL)
+#define CEPH_CAP_FILE_MASK	(CEPH_CAP_GSHARED |	\
+				 CEPH_CAP_GEXCL |	\
+				 CEPH_CAP_GCACHE |	\
+				 CEPH_CAP_GRD |		\
+				 CEPH_CAP_GWR |		\
+				 CEPH_CAP_GBUFFER |	\
+				 CEPH_CAP_GWREXTEND |	\
+				 CEPH_CAP_GLAZYIO)
+
+static void
+trace_gcap_string(struct trace_seq *p, int c)
+{
+	if (c & CEPH_CAP_GSHARED)
+		trace_seq_putc(p, 's');
+	if (c & CEPH_CAP_GEXCL)
+		trace_seq_putc(p, 'x');
+	if (c & CEPH_CAP_GCACHE)
+		trace_seq_putc(p, 'c');
+	if (c & CEPH_CAP_GRD)
+		trace_seq_putc(p, 'r');
+	if (c & CEPH_CAP_GWR)
+		trace_seq_putc(p, 'w');
+	if (c & CEPH_CAP_GBUFFER)
+		trace_seq_putc(p, 'b');
+	if (c & CEPH_CAP_GWREXTEND)
+		trace_seq_putc(p, 'a');
+	if (c & CEPH_CAP_GLAZYIO)
+		trace_seq_putc(p, 'l');
+}
+
+const char *
+trace_ceph_cap_string(struct trace_seq *p, int caps)
+{
+	int c;
+	const char *ret = trace_seq_buffer_ptr(p);
+
+	if (caps == 0) {
+		trace_seq_putc(p, '-');
+		goto out;
+	}
+
+	if (caps & CEPH_CAP_PIN)
+		trace_seq_putc(p, 'p');
+
+	c = (caps >> CEPH_CAP_SAUTH) & CEPH_CAP_BASE_MASK;
+	if (c) {
+		trace_seq_putc(p, 'A');
+		trace_gcap_string(p, c);
+	}
+
+	c = (caps >> CEPH_CAP_SLINK) & CEPH_CAP_BASE_MASK;
+	if (c) {
+		trace_seq_putc(p, 'L');
+		trace_gcap_string(p, c);
+	}
+
+	c = (caps >> CEPH_CAP_SXATTR) & CEPH_CAP_BASE_MASK;
+	if (c) {
+		trace_seq_putc(p, 'X');
+		trace_gcap_string(p, c);
+	}
+
+	c = (caps >> CEPH_CAP_SFILE) & CEPH_CAP_FILE_MASK;
+	if (c) {
+		trace_seq_putc(p, 'F');
+		trace_gcap_string(p, c);
+	}
+out:
+	trace_seq_putc(p, '\0');
+	return ret;
+}
diff --git a/fs/ceph/trace.h b/fs/ceph/trace.h
new file mode 100644
index 000000000000..d1cf4bb8a21d
--- /dev/null
+++ b/fs/ceph/trace.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ceph
+
+#if !defined(_CEPH_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _CEPH_TRACE_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+#include "super.h"
+
+const char *trace_ceph_cap_string(struct trace_seq *p, int caps);
+#define show_caps(caps) ({ trace_ceph_cap_string(p, caps); })
+
+#define show_snapid(snap)	\
+	__print_symbolic_u64(snap, {CEPH_NOSNAP, "NOSNAP" })
+
+DECLARE_EVENT_CLASS(ceph_cap_class,
+	TP_PROTO(struct ceph_cap *cap),
+	TP_ARGS(cap),
+	TP_STRUCT__entry(
+		__field(u64, ino)
+		__field(u64, snap)
+		__field(int, issued)
+		__field(int, implemented)
+		__field(int, mds)
+		__field(int, mds_wanted)
+	),
+	TP_fast_assign(
+		__entry->ino = cap->ci->i_vino.ino;
+		__entry->snap = cap->ci->i_vino.snap;
+		__entry->issued = cap->issued;
+		__entry->implemented = cap->implemented;
+		__entry->mds = cap->mds;
+		__entry->mds_wanted = cap->mds_wanted;
+	),
+	TP_printk("ino=0x%llx snap=%s mds=%d issued=%s implemented=%s mds_wanted=%s",
+		__entry->ino, show_snapid(__entry->snap), __entry->mds,
+		show_caps(__entry->issued), show_caps(__entry->implemented),
+		show_caps(__entry->mds_wanted))
+)
+
+#define DEFINE_CEPH_CAP_EVENT(name)             \
+DEFINE_EVENT(ceph_cap_class, ceph_##name,       \
+	TP_PROTO(struct ceph_cap *cap),		\
+	TP_ARGS(cap))
+
+DEFINE_CEPH_CAP_EVENT(add_cap);
+DEFINE_CEPH_CAP_EVENT(remove_cap);
+
+#endif /* _CEPH_TRACE_H */
+
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
index d5a5da838caf..fa4a84e0e018 100644
--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -2,6 +2,7 @@
 #ifndef _FS_CEPH_DEBUG_H
 #define _FS_CEPH_DEBUG_H
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/string.h>
-- 
2.21.0

