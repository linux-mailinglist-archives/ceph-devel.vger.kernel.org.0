Return-Path: <ceph-devel+bounces-1123-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B90BB8B7898
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2024 16:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82B25B25602
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2024 14:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C6D1C689F;
	Tue, 30 Apr 2024 14:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NblM76rH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5871C2313
	for <ceph-devel@vger.kernel.org>; Tue, 30 Apr 2024 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714485790; cv=none; b=DXJCM2NccHdmLg2sX0DBhbO1aAjSwU0LPpzebxWgeSmBFNJ0k3JfKjYbQubS9xtHY7LfwZQUw61KGvHN2B5t6BXJN3a2tbdTJ7EG5Kh2MsaqdVgol654S3lqTe+NKqiQ5d80InCBv2nxOisvikhKHqFjkpG+64YS1UIf7WkariY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714485790; c=relaxed/simple;
	bh=Fs+ByYPRKNYmi2F7ny9ZJLGxANz4TNfi7rvVwKEL1dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4UXYqYQ31l5ETV/2jl8PcX9ZrfHMqYiWQP66yS1/MKxSu+wF+QYZO/4s/gEozIULM+s94ERdGUhcn9Jn5fhvl1kJC/YAtDvYkT4+EKPb6GGG1C7w8qaaA9NHzgDA0u1oL2ObirduqLqHNrfZr2rTDsdXNPL13MsQ/chAMbe8oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NblM76rH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714485786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b5EgDjFNrAAafAzZBTKxBCvxuUsmkAdGKL3AYN1EAj4=;
	b=NblM76rHd4L+sT4rWLhKqiWi2zm+1C9hL6UCy65Gl+Z2ss6Co4Pp4DsTylc1XCbVSBc/WG
	GR/osjpF3uSjibeNRb9nu0oIO1DTxpC4h3Q/ChxlNNzK1TFf3a6Bt4kyah72rLl5552Mz1
	0a8rOn5dsHjRfCPp88YBigpyib0hb1c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-X6AaRPb4Mp-V7xLKIzX4rA-1; Tue, 30 Apr 2024 10:03:02 -0400
X-MC-Unique: X6AaRPb4Mp-V7xLKIzX4rA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9766F834FFE;
	Tue, 30 Apr 2024 14:02:08 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.22])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A59F2581CA;
	Tue, 30 Apr 2024 14:02:05 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Cc: David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Steve French <smfrench@gmail.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-cachefs@redhat.com,
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
Subject: [PATCH v2 15/22] netfs: Add some write-side stats and clean up some stat names
Date: Tue, 30 Apr 2024 15:00:46 +0100
Message-ID: <20240430140056.261997-16-dhowells@redhat.com>
In-Reply-To: <20240430140056.261997-1-dhowells@redhat.com>
References: <20240430140056.261997-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Add some write-side stats to count buffered writes, buffered writethrough,
and writepages calls.

Whilst we're at it, clean up the naming on some of the existing stats
counters and organise the output into two sets.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c  |  2 +-
 fs/netfs/buffered_write.c |  3 +++
 fs/netfs/direct_write.c   |  2 +-
 fs/netfs/internal.h       |  7 +++++--
 fs/netfs/stats.c          | 17 ++++++++++++-----
 fs/netfs/write_issue.c    |  1 +
 6 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 47603f08680e..a6bb03bea920 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -282,7 +282,7 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	if (ret == -ENOMEM || ret == -EINTR || ret == -ERESTARTSYS)
 		goto discard;
 
-	netfs_stat(&netfs_n_rh_readpage);
+	netfs_stat(&netfs_n_rh_read_folio);
 	trace_netfs_read(rreq, rreq->start, rreq->len, netfs_read_trace_readpage);
 
 	/* Set up the output buffer */
diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 84ac95ee4b4d..33ea4c20e7e7 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -210,6 +210,9 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		if (!is_sync_kiocb(iocb))
 			wreq->iocb = iocb;
 		wreq->cleanup = netfs_cleanup_buffered_write;
+		netfs_stat(&netfs_n_wh_writethrough);
+	} else {
+		netfs_stat(&netfs_n_wh_buffered_write);
 	}
 
 	do {
diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 2b81cd4aae6e..36b6db504500 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -145,7 +145,7 @@ ssize_t netfs_unbuffered_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return 0;
 
 	trace_netfs_write_iter(iocb, from);
-	netfs_stat(&netfs_n_rh_dio_write);
+	netfs_stat(&netfs_n_wh_dio_write);
 
 	ret = netfs_start_io_direct(inode);
 	if (ret < 0)
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index dc11d1f67363..5d3f74a70fa7 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -106,9 +106,8 @@ int netfs_end_writethrough(struct netfs_io_request *wreq, struct kiocb *iocb);
  */
 #ifdef CONFIG_NETFS_STATS
 extern atomic_t netfs_n_rh_dio_read;
-extern atomic_t netfs_n_rh_dio_write;
 extern atomic_t netfs_n_rh_readahead;
-extern atomic_t netfs_n_rh_readpage;
+extern atomic_t netfs_n_rh_read_folio;
 extern atomic_t netfs_n_rh_rreq;
 extern atomic_t netfs_n_rh_sreq;
 extern atomic_t netfs_n_rh_download;
@@ -125,6 +124,10 @@ extern atomic_t netfs_n_rh_write_begin;
 extern atomic_t netfs_n_rh_write_done;
 extern atomic_t netfs_n_rh_write_failed;
 extern atomic_t netfs_n_rh_write_zskip;
+extern atomic_t netfs_n_wh_buffered_write;
+extern atomic_t netfs_n_wh_writethrough;
+extern atomic_t netfs_n_wh_dio_write;
+extern atomic_t netfs_n_wh_writepages;
 extern atomic_t netfs_n_wh_wstream_conflict;
 extern atomic_t netfs_n_wh_upload;
 extern atomic_t netfs_n_wh_upload_done;
diff --git a/fs/netfs/stats.c b/fs/netfs/stats.c
index deeba9f9dcf5..0892768eea32 100644
--- a/fs/netfs/stats.c
+++ b/fs/netfs/stats.c
@@ -10,9 +10,8 @@
 #include "internal.h"
 
 atomic_t netfs_n_rh_dio_read;
-atomic_t netfs_n_rh_dio_write;
 atomic_t netfs_n_rh_readahead;
-atomic_t netfs_n_rh_readpage;
+atomic_t netfs_n_rh_read_folio;
 atomic_t netfs_n_rh_rreq;
 atomic_t netfs_n_rh_sreq;
 atomic_t netfs_n_rh_download;
@@ -29,6 +28,10 @@ atomic_t netfs_n_rh_write_begin;
 atomic_t netfs_n_rh_write_done;
 atomic_t netfs_n_rh_write_failed;
 atomic_t netfs_n_rh_write_zskip;
+atomic_t netfs_n_wh_buffered_write;
+atomic_t netfs_n_wh_writethrough;
+atomic_t netfs_n_wh_dio_write;
+atomic_t netfs_n_wh_writepages;
 atomic_t netfs_n_wh_wstream_conflict;
 atomic_t netfs_n_wh_upload;
 atomic_t netfs_n_wh_upload_done;
@@ -39,13 +42,17 @@ atomic_t netfs_n_wh_write_failed;
 
 int netfs_stats_show(struct seq_file *m, void *v)
 {
-	seq_printf(m, "Netfs  : DR=%u DW=%u RA=%u RP=%u WB=%u WBZ=%u\n",
+	seq_printf(m, "Netfs  : DR=%u RA=%u RF=%u WB=%u WBZ=%u\n",
 		   atomic_read(&netfs_n_rh_dio_read),
-		   atomic_read(&netfs_n_rh_dio_write),
 		   atomic_read(&netfs_n_rh_readahead),
-		   atomic_read(&netfs_n_rh_readpage),
+		   atomic_read(&netfs_n_rh_read_folio),
 		   atomic_read(&netfs_n_rh_write_begin),
 		   atomic_read(&netfs_n_rh_write_zskip));
+	seq_printf(m, "Netfs  : BW=%u WT=%u DW=%u WP=%u\n",
+		   atomic_read(&netfs_n_wh_buffered_write),
+		   atomic_read(&netfs_n_wh_writethrough),
+		   atomic_read(&netfs_n_wh_dio_write),
+		   atomic_read(&netfs_n_wh_writepages));
 	seq_printf(m, "Netfs  : ZR=%u sh=%u sk=%u\n",
 		   atomic_read(&netfs_n_rh_zero),
 		   atomic_read(&netfs_n_rh_short_read),
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 0293b714d8ee..11b62e6f82fa 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -510,6 +510,7 @@ int new_netfs_writepages(struct address_space *mapping,
 	}
 
 	trace_netfs_write(wreq, netfs_write_trace_writeback);
+	netfs_stat(&netfs_n_wh_writepages);
 
 	do {
 		_debug("wbiter %lx %llx", folio->index, wreq->start + wreq->submitted);


