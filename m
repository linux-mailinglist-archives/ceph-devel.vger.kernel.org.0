Return-Path: <ceph-devel+bounces-492-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C03738284C2
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jan 2024 12:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EE8C28731C
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jan 2024 11:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2897637153;
	Tue,  9 Jan 2024 11:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VGm1xPZ3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEA4381AB
	for <ceph-devel@vger.kernel.org>; Tue,  9 Jan 2024 11:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704799246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rr5EJ/KUtWAGcPxbo/TizcNZKdZiXnS9Nbdtw3WvDek=;
	b=VGm1xPZ3EnfiDG6EmniZihp6F8t9DvEokfveu+z19Qz5uoSWAEfnEDzWh6gPFSMcptxKqd
	aI/pb5mxnX2uIDrONFf0HoisQpi7dllqVFkQ2RVnazoYQj1TVBVb/LkHFdLhfcKqDvbeoY
	KYFCKdgPqTCWjBtUPA3EiMx8HTpWFgE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-100-EIoi-qiVMCWdOvvkHaBtvw-1; Tue,
 09 Jan 2024 06:20:43 -0500
X-MC-Unique: EIoi-qiVMCWdOvvkHaBtvw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59A0D29AA3A5;
	Tue,  9 Jan 2024 11:20:42 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7E2DBC15A0C;
	Tue,  9 Jan 2024 11:20:39 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Cc: David Howells <dhowells@redhat.com>,
	Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
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
Subject: [PATCH 1/6] netfs: Mark netfs_unbuffered_write_iter_locked() static
Date: Tue,  9 Jan 2024 11:20:18 +0000
Message-ID: <20240109112029.1572463-2-dhowells@redhat.com>
In-Reply-To: <20240109112029.1572463-1-dhowells@redhat.com>
References: <20240109112029.1572463-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Mark netfs_unbuffered_write_iter_locked() static as it's only called from
the file in which it is defined.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cachefs@redhat.com
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/netfs/direct_write.c | 4 ++--
 fs/netfs/internal.h     | 6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index aad05f2349a4..b9cbfd6a8a01 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -27,8 +27,8 @@ static void netfs_cleanup_dio_write(struct netfs_io_request *wreq)
  * Perform an unbuffered write where we may have to do an RMW operation on an
  * encrypted file.  This can also be used for direct I/O writes.
  */
-ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *iter,
-					   struct netfs_group *netfs_group)
+static ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *iter,
+						  struct netfs_group *netfs_group)
 {
 	struct netfs_io_request *wreq;
 	unsigned long long start = iocb->ki_pos;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index d2d63120ac60..a6dfc8888377 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -26,12 +26,6 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *rreq);
 int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 			     size_t offset, size_t len);
 
-/*
- * direct_write.c
- */
-ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *iter,
-					   struct netfs_group *netfs_group);
-
 /*
  * io.c
  */


