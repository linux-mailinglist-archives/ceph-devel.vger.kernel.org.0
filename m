Return-Path: <ceph-devel+bounces-2006-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C3629BEA2A
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Nov 2024 13:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDB0FB21232
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Nov 2024 12:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FAD1F7099;
	Wed,  6 Nov 2024 12:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYzm2GnQ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19901F7065
	for <ceph-devel@vger.kernel.org>; Wed,  6 Nov 2024 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896652; cv=none; b=ozuFPYxdqfND4sISCYAYxNGkD/Hx3NdDh4lH8jOECrVOFXs1Xe4zofLIXCNq1cXHN8y7hUQ7jzU9LQ1kpu5eSDpv+OfMi+M2VUVENiuWkEj9OwH3Wc9NdIgyIJcqGfswyTm6Zfj/b7sSmzWwV7g85SwX9wAA+Ty0MUrMu/iJSWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896652; c=relaxed/simple;
	bh=B1BUwxw64z+5qVgktuj5MQyZ0A0BcydF8lMOP9S4BVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlEl5FwTt2g9UUOQF2k4/k7V0Qyovu6CShREA1vmjF+LJ4ii2m77ueb1Ysn1nUWB/vbqTObkEG4nyszYlI+SHIvs7XzoKJbG8/blVyOioz3wOAb7yF7FernihPUI3Og4pnD1GN5P04mWey15+6li0WvV835NsrAnJ1I+sH3dXaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYzm2GnQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730896647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cXT5ALic3xBUT2yykbdv9+aDxF01hC9kmNJ9X8Q7R1c=;
	b=TYzm2GnQq8Z8eEcdRQHPzcJIqU0Kj7Cik33SaAxUbDOjX92jOPctBR/KLfoCT5JrzxtPgC
	+fvUSPMiWiavaINK3zy+xXJ4Fl6KQyPbI+fyKU5uCPuDZQzB5Fcb61AMey9ro3hTIfIuYR
	BVFsx/5l1YdrORM3X/JAN5+uEgnTW+E=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-VJlxQPBqPXWVEvxdgL7taQ-1; Wed,
 06 Nov 2024 07:37:24 -0500
X-MC-Unique: VJlxQPBqPXWVEvxdgL7taQ-1
X-Mimecast-MFC-AGG-ID: VJlxQPBqPXWVEvxdgL7taQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58B431955EA9;
	Wed,  6 Nov 2024 12:37:21 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.231])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A00F419541A5;
	Wed,  6 Nov 2024 12:37:15 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/33] netfs: Split retry code out of fs/netfs/write_collect.c
Date: Wed,  6 Nov 2024 12:35:33 +0000
Message-ID: <20241106123559.724888-10-dhowells@redhat.com>
In-Reply-To: <20241106123559.724888-1-dhowells@redhat.com>
References: <20241106123559.724888-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Split write-retry code out of fs/netfs/write_collect.c as it will become
more elaborate when content crypto is introduced.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/Makefile        |   3 +-
 fs/netfs/internal.h      |   5 +
 fs/netfs/write_collect.c | 215 ------------------------------------
 fs/netfs/write_retry.c   | 227 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 234 insertions(+), 216 deletions(-)
 create mode 100644 fs/netfs/write_retry.c

diff --git a/fs/netfs/Makefile b/fs/netfs/Makefile
index 7492c4aa331e..cbb30bdeacc4 100644
--- a/fs/netfs/Makefile
+++ b/fs/netfs/Makefile
@@ -15,7 +15,8 @@ netfs-y := \
 	read_retry.o \
 	rolling_buffer.o \
 	write_collect.o \
-	write_issue.o
+	write_issue.o \
+	write_retry.o
 
 netfs-$(CONFIG_NETFS_STATS) += stats.o
 
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 6aa2a8d49b37..73887525e939 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -189,6 +189,11 @@ int netfs_end_writethrough(struct netfs_io_request *wreq, struct writeback_contr
 			   struct folio *writethrough_cache);
 int netfs_unbuffered_write(struct netfs_io_request *wreq, bool may_wait, size_t len);
 
+/*
+ * write_retry.c
+ */
+void netfs_retry_writes(struct netfs_io_request *wreq);
+
 /*
  * Miscellaneous functions.
  */
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index f3fab41ca3e5..85e8e94da90a 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -151,221 +151,6 @@ static void netfs_writeback_unlock_folios(struct netfs_io_request *wreq,
 	wreq->buffer.first_tail_slot = slot;
 }
 
-/*
- * Perform retries on the streams that need it.
- */
-static void netfs_retry_write_stream(struct netfs_io_request *wreq,
-				     struct netfs_io_stream *stream)
-{
-	struct list_head *next;
-
-	_enter("R=%x[%x:]", wreq->debug_id, stream->stream_nr);
-
-	if (list_empty(&stream->subrequests))
-		return;
-
-	if (stream->source == NETFS_UPLOAD_TO_SERVER &&
-	    wreq->netfs_ops->retry_request)
-		wreq->netfs_ops->retry_request(wreq, stream);
-
-	if (unlikely(stream->failed))
-		return;
-
-	/* If there's no renegotiation to do, just resend each failed subreq. */
-	if (!stream->prepare_write) {
-		struct netfs_io_subrequest *subreq;
-
-		list_for_each_entry(subreq, &stream->subrequests, rreq_link) {
-			if (test_bit(NETFS_SREQ_FAILED, &subreq->flags))
-				break;
-			if (__test_and_clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
-				struct iov_iter source = subreq->io_iter;
-
-				iov_iter_revert(&source, subreq->len - source.count);
-				__set_bit(NETFS_SREQ_RETRYING, &subreq->flags);
-				netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
-				netfs_reissue_write(stream, subreq, &source);
-			}
-		}
-		return;
-	}
-
-	next = stream->subrequests.next;
-
-	do {
-		struct netfs_io_subrequest *subreq = NULL, *from, *to, *tmp;
-		struct iov_iter source;
-		unsigned long long start, len;
-		size_t part;
-		bool boundary = false;
-
-		/* Go through the stream and find the next span of contiguous
-		 * data that we then rejig (cifs, for example, needs the wsize
-		 * renegotiating) and reissue.
-		 */
-		from = list_entry(next, struct netfs_io_subrequest, rreq_link);
-		to = from;
-		start = from->start + from->transferred;
-		len   = from->len   - from->transferred;
-
-		if (test_bit(NETFS_SREQ_FAILED, &from->flags) ||
-		    !test_bit(NETFS_SREQ_NEED_RETRY, &from->flags))
-			return;
-
-		list_for_each_continue(next, &stream->subrequests) {
-			subreq = list_entry(next, struct netfs_io_subrequest, rreq_link);
-			if (subreq->start + subreq->transferred != start + len ||
-			    test_bit(NETFS_SREQ_BOUNDARY, &subreq->flags) ||
-			    !test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags))
-				break;
-			to = subreq;
-			len += to->len;
-		}
-
-		/* Determine the set of buffers we're going to use.  Each
-		 * subreq gets a subset of a single overall contiguous buffer.
-		 */
-		netfs_reset_iter(from);
-		source = from->io_iter;
-		source.count = len;
-
-		/* Work through the sublist. */
-		subreq = from;
-		list_for_each_entry_from(subreq, &stream->subrequests, rreq_link) {
-			if (!len)
-				break;
-			/* Renegotiate max_len (wsize) */
-			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
-			__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
-			__set_bit(NETFS_SREQ_RETRYING, &subreq->flags);
-			stream->prepare_write(subreq);
-
-			part = min(len, stream->sreq_max_len);
-			subreq->len = part;
-			subreq->start = start;
-			subreq->transferred = 0;
-			len -= part;
-			start += part;
-			if (len && subreq == to &&
-			    __test_and_clear_bit(NETFS_SREQ_BOUNDARY, &to->flags))
-				boundary = true;
-
-			netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
-			netfs_reissue_write(stream, subreq, &source);
-			if (subreq == to)
-				break;
-		}
-
-		/* If we managed to use fewer subreqs, we can discard the
-		 * excess; if we used the same number, then we're done.
-		 */
-		if (!len) {
-			if (subreq == to)
-				continue;
-			list_for_each_entry_safe_from(subreq, tmp,
-						      &stream->subrequests, rreq_link) {
-				trace_netfs_sreq(subreq, netfs_sreq_trace_discard);
-				list_del(&subreq->rreq_link);
-				netfs_put_subrequest(subreq, false, netfs_sreq_trace_put_done);
-				if (subreq == to)
-					break;
-			}
-			continue;
-		}
-
-		/* We ran out of subrequests, so we need to allocate some more
-		 * and insert them after.
-		 */
-		do {
-			subreq = netfs_alloc_subrequest(wreq);
-			subreq->source		= to->source;
-			subreq->start		= start;
-			subreq->debug_index	= atomic_inc_return(&wreq->subreq_counter);
-			subreq->stream_nr	= to->stream_nr;
-			__set_bit(NETFS_SREQ_RETRYING, &subreq->flags);
-
-			trace_netfs_sreq_ref(wreq->debug_id, subreq->debug_index,
-					     refcount_read(&subreq->ref),
-					     netfs_sreq_trace_new);
-			netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
-
-			list_add(&subreq->rreq_link, &to->rreq_link);
-			to = list_next_entry(to, rreq_link);
-			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
-
-			stream->sreq_max_len	= len;
-			stream->sreq_max_segs	= INT_MAX;
-			switch (stream->source) {
-			case NETFS_UPLOAD_TO_SERVER:
-				netfs_stat(&netfs_n_wh_upload);
-				stream->sreq_max_len = umin(len, wreq->wsize);
-				break;
-			case NETFS_WRITE_TO_CACHE:
-				netfs_stat(&netfs_n_wh_write);
-				break;
-			default:
-				WARN_ON_ONCE(1);
-			}
-
-			stream->prepare_write(subreq);
-
-			part = umin(len, stream->sreq_max_len);
-			subreq->len = subreq->transferred + part;
-			len -= part;
-			start += part;
-			if (!len && boundary) {
-				__set_bit(NETFS_SREQ_BOUNDARY, &to->flags);
-				boundary = false;
-			}
-
-			netfs_reissue_write(stream, subreq, &source);
-			if (!len)
-				break;
-
-		} while (len);
-
-	} while (!list_is_head(next, &stream->subrequests));
-}
-
-/*
- * Perform retries on the streams that need it.  If we're doing content
- * encryption and the server copy changed due to a third-party write, we may
- * need to do an RMW cycle and also rewrite the data to the cache.
- */
-static void netfs_retry_writes(struct netfs_io_request *wreq)
-{
-	struct netfs_io_subrequest *subreq;
-	struct netfs_io_stream *stream;
-	int s;
-
-	/* Wait for all outstanding I/O to quiesce before performing retries as
-	 * we may need to renegotiate the I/O sizes.
-	 */
-	for (s = 0; s < NR_IO_STREAMS; s++) {
-		stream = &wreq->io_streams[s];
-		if (!stream->active)
-			continue;
-
-		list_for_each_entry(subreq, &stream->subrequests, rreq_link) {
-			wait_on_bit(&subreq->flags, NETFS_SREQ_IN_PROGRESS,
-				    TASK_UNINTERRUPTIBLE);
-		}
-	}
-
-	// TODO: Enc: Fetch changed partial pages
-	// TODO: Enc: Reencrypt content if needed.
-	// TODO: Enc: Wind back transferred point.
-	// TODO: Enc: Mark cache pages for retry.
-
-	for (s = 0; s < NR_IO_STREAMS; s++) {
-		stream = &wreq->io_streams[s];
-		if (stream->need_retry) {
-			stream->need_retry = false;
-			netfs_retry_write_stream(wreq, stream);
-		}
-	}
-}
-
 /*
  * Collect and assess the results of various write subrequests.  We may need to
  * retry some of the results - or even do an RMW cycle for content crypto.
diff --git a/fs/netfs/write_retry.c b/fs/netfs/write_retry.c
new file mode 100644
index 000000000000..2222c3a6b9d1
--- /dev/null
+++ b/fs/netfs/write_retry.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Network filesystem write retrying.
+ *
+ * Copyright (C) 2024 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/slab.h>
+#include "internal.h"
+
+/*
+ * Perform retries on the streams that need it.
+ */
+static void netfs_retry_write_stream(struct netfs_io_request *wreq,
+				     struct netfs_io_stream *stream)
+{
+	struct list_head *next;
+
+	_enter("R=%x[%x:]", wreq->debug_id, stream->stream_nr);
+
+	if (list_empty(&stream->subrequests))
+		return;
+
+	if (stream->source == NETFS_UPLOAD_TO_SERVER &&
+	    wreq->netfs_ops->retry_request)
+		wreq->netfs_ops->retry_request(wreq, stream);
+
+	if (unlikely(stream->failed))
+		return;
+
+	/* If there's no renegotiation to do, just resend each failed subreq. */
+	if (!stream->prepare_write) {
+		struct netfs_io_subrequest *subreq;
+
+		list_for_each_entry(subreq, &stream->subrequests, rreq_link) {
+			if (test_bit(NETFS_SREQ_FAILED, &subreq->flags))
+				break;
+			if (__test_and_clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
+				struct iov_iter source = subreq->io_iter;
+
+				iov_iter_revert(&source, subreq->len - source.count);
+				__set_bit(NETFS_SREQ_RETRYING, &subreq->flags);
+				netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
+				netfs_reissue_write(stream, subreq, &source);
+			}
+		}
+		return;
+	}
+
+	next = stream->subrequests.next;
+
+	do {
+		struct netfs_io_subrequest *subreq = NULL, *from, *to, *tmp;
+		struct iov_iter source;
+		unsigned long long start, len;
+		size_t part;
+		bool boundary = false;
+
+		/* Go through the stream and find the next span of contiguous
+		 * data that we then rejig (cifs, for example, needs the wsize
+		 * renegotiating) and reissue.
+		 */
+		from = list_entry(next, struct netfs_io_subrequest, rreq_link);
+		to = from;
+		start = from->start + from->transferred;
+		len   = from->len   - from->transferred;
+
+		if (test_bit(NETFS_SREQ_FAILED, &from->flags) ||
+		    !test_bit(NETFS_SREQ_NEED_RETRY, &from->flags))
+			return;
+
+		list_for_each_continue(next, &stream->subrequests) {
+			subreq = list_entry(next, struct netfs_io_subrequest, rreq_link);
+			if (subreq->start + subreq->transferred != start + len ||
+			    test_bit(NETFS_SREQ_BOUNDARY, &subreq->flags) ||
+			    !test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags))
+				break;
+			to = subreq;
+			len += to->len;
+		}
+
+		/* Determine the set of buffers we're going to use.  Each
+		 * subreq gets a subset of a single overall contiguous buffer.
+		 */
+		netfs_reset_iter(from);
+		source = from->io_iter;
+		source.count = len;
+
+		/* Work through the sublist. */
+		subreq = from;
+		list_for_each_entry_from(subreq, &stream->subrequests, rreq_link) {
+			if (!len)
+				break;
+			/* Renegotiate max_len (wsize) */
+			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
+			__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
+			__set_bit(NETFS_SREQ_RETRYING, &subreq->flags);
+			stream->prepare_write(subreq);
+
+			part = min(len, stream->sreq_max_len);
+			subreq->len = part;
+			subreq->start = start;
+			subreq->transferred = 0;
+			len -= part;
+			start += part;
+			if (len && subreq == to &&
+			    __test_and_clear_bit(NETFS_SREQ_BOUNDARY, &to->flags))
+				boundary = true;
+
+			netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
+			netfs_reissue_write(stream, subreq, &source);
+			if (subreq == to)
+				break;
+		}
+
+		/* If we managed to use fewer subreqs, we can discard the
+		 * excess; if we used the same number, then we're done.
+		 */
+		if (!len) {
+			if (subreq == to)
+				continue;
+			list_for_each_entry_safe_from(subreq, tmp,
+						      &stream->subrequests, rreq_link) {
+				trace_netfs_sreq(subreq, netfs_sreq_trace_discard);
+				list_del(&subreq->rreq_link);
+				netfs_put_subrequest(subreq, false, netfs_sreq_trace_put_done);
+				if (subreq == to)
+					break;
+			}
+			continue;
+		}
+
+		/* We ran out of subrequests, so we need to allocate some more
+		 * and insert them after.
+		 */
+		do {
+			subreq = netfs_alloc_subrequest(wreq);
+			subreq->source		= to->source;
+			subreq->start		= start;
+			subreq->debug_index	= atomic_inc_return(&wreq->subreq_counter);
+			subreq->stream_nr	= to->stream_nr;
+			__set_bit(NETFS_SREQ_RETRYING, &subreq->flags);
+
+			trace_netfs_sreq_ref(wreq->debug_id, subreq->debug_index,
+					     refcount_read(&subreq->ref),
+					     netfs_sreq_trace_new);
+			netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
+
+			list_add(&subreq->rreq_link, &to->rreq_link);
+			to = list_next_entry(to, rreq_link);
+			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
+
+			stream->sreq_max_len	= len;
+			stream->sreq_max_segs	= INT_MAX;
+			switch (stream->source) {
+			case NETFS_UPLOAD_TO_SERVER:
+				netfs_stat(&netfs_n_wh_upload);
+				stream->sreq_max_len = umin(len, wreq->wsize);
+				break;
+			case NETFS_WRITE_TO_CACHE:
+				netfs_stat(&netfs_n_wh_write);
+				break;
+			default:
+				WARN_ON_ONCE(1);
+			}
+
+			stream->prepare_write(subreq);
+
+			part = umin(len, stream->sreq_max_len);
+			subreq->len = subreq->transferred + part;
+			len -= part;
+			start += part;
+			if (!len && boundary) {
+				__set_bit(NETFS_SREQ_BOUNDARY, &to->flags);
+				boundary = false;
+			}
+
+			netfs_reissue_write(stream, subreq, &source);
+			if (!len)
+				break;
+
+		} while (len);
+
+	} while (!list_is_head(next, &stream->subrequests));
+}
+
+/*
+ * Perform retries on the streams that need it.  If we're doing content
+ * encryption and the server copy changed due to a third-party write, we may
+ * need to do an RMW cycle and also rewrite the data to the cache.
+ */
+void netfs_retry_writes(struct netfs_io_request *wreq)
+{
+	struct netfs_io_subrequest *subreq;
+	struct netfs_io_stream *stream;
+	int s;
+
+	/* Wait for all outstanding I/O to quiesce before performing retries as
+	 * we may need to renegotiate the I/O sizes.
+	 */
+	for (s = 0; s < NR_IO_STREAMS; s++) {
+		stream = &wreq->io_streams[s];
+		if (!stream->active)
+			continue;
+
+		list_for_each_entry(subreq, &stream->subrequests, rreq_link) {
+			wait_on_bit(&subreq->flags, NETFS_SREQ_IN_PROGRESS,
+				    TASK_UNINTERRUPTIBLE);
+		}
+	}
+
+	// TODO: Enc: Fetch changed partial pages
+	// TODO: Enc: Reencrypt content if needed.
+	// TODO: Enc: Wind back transferred point.
+	// TODO: Enc: Mark cache pages for retry.
+
+	for (s = 0; s < NR_IO_STREAMS; s++) {
+		stream = &wreq->io_streams[s];
+		if (stream->need_retry) {
+			stream->need_retry = false;
+			netfs_retry_write_stream(wreq, stream);
+		}
+	}
+}


