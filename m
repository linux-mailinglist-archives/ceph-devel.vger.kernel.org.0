Return-Path: <ceph-devel+bounces-2005-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B55F9BEA1D
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Nov 2024 13:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F9171F212B8
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Nov 2024 12:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4B81F6664;
	Wed,  6 Nov 2024 12:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OttUfTre"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262D51F5844
	for <ceph-devel@vger.kernel.org>; Wed,  6 Nov 2024 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896642; cv=none; b=qgTwNqW58LDhNsu44O4txWRo84glpuRMKG4IQqL6cLzsc+7OHK2VUm57EPcgBbmaf8tBP84yv/IP0Dp9gyGITf1cPChy2iui3V4Ov9ivdoHPHISat8UHBLF2OuVIPBZJzAru3p+TVmYExGWE3cAfCqMSxUjOq2QS6NnXYgqhxGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896642; c=relaxed/simple;
	bh=9SCEKbNtvAFB8fJZcHIRQXCI/OprF81chlgQt47QcC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQzmnaYnb4YTe0G/uco7zo8/QJ3xcXKZNM/rJaMLnNsMoPcSGh2WKBbsDcJSeOvFUDjWhzlSyJlBzlhq1thzMW/nTXMZ3jq5ZFN+ft+QZvtu7Opg8FgNHe/AOudToMLjhkQzqWZ3cT4HMdaB731ktacNR2ESWGPPF1XhSE+7FrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OttUfTre; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730896640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X3twVFG043O59vporSoGB49KW0yXOb7j0HiRw4sYWo4=;
	b=OttUfTrefY9k/Rh4/9HPt4vILKxc4MK+YU3fy7qyxv9pD3B0YZNRhcq73S55+nBICohmNT
	dJAP9Z4oV7gi4I9dP4IbQbo4AzX+ZDtDtW0ljBnw6QPTLhMbsWNwokYrIHpy6T8w9HCFOs
	Nl6hocB/Dw3v/oHqjUH5h6Chr1Rbr8I=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471--vc-UjHAN7GH84QOk_v9DA-1; Wed,
 06 Nov 2024 07:37:17 -0500
X-MC-Unique: -vc-UjHAN7GH84QOk_v9DA-1
X-Mimecast-MFC-AGG-ID: -vc-UjHAN7GH84QOk_v9DA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A0371955D91;
	Wed,  6 Nov 2024 12:37:14 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.231])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C38391956088;
	Wed,  6 Nov 2024 12:37:07 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	linux-cachefs@redhat.com
Subject: [PATCH v3 08/33] netfs: Make netfs_advance_write() return size_t
Date: Wed,  6 Nov 2024 12:35:32 +0000
Message-ID: <20241106123559.724888-9-dhowells@redhat.com>
In-Reply-To: <20241106123559.724888-1-dhowells@redhat.com>
References: <20241106123559.724888-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

netfs_advance_write() calculates the amount of data it's attaching to a
stream with size_t, but then returns this as an int.  Switch the return
value to size_t for consistency.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cachefs@redhat.com
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/netfs/internal.h    | 6 +++---
 fs/netfs/write_issue.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index ccd9058acb61..6aa2a8d49b37 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -178,9 +178,9 @@ void netfs_reissue_write(struct netfs_io_stream *stream,
 			 struct iov_iter *source);
 void netfs_issue_write(struct netfs_io_request *wreq,
 		       struct netfs_io_stream *stream);
-int netfs_advance_write(struct netfs_io_request *wreq,
-			struct netfs_io_stream *stream,
-			loff_t start, size_t len, bool to_eof);
+size_t netfs_advance_write(struct netfs_io_request *wreq,
+			   struct netfs_io_stream *stream,
+			   loff_t start, size_t len, bool to_eof);
 struct netfs_io_request *netfs_begin_writethrough(struct kiocb *iocb, size_t len);
 int netfs_advance_writethrough(struct netfs_io_request *wreq, struct writeback_control *wbc,
 			       struct folio *folio, size_t copied, bool to_page_end,
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 993cc6def38e..c186221b45c0 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -271,9 +271,9 @@ void netfs_issue_write(struct netfs_io_request *wreq,
  * we can avoid overrunning the credits obtained (cifs) and try to parallelise
  * content-crypto preparation with network writes.
  */
-int netfs_advance_write(struct netfs_io_request *wreq,
-			struct netfs_io_stream *stream,
-			loff_t start, size_t len, bool to_eof)
+size_t netfs_advance_write(struct netfs_io_request *wreq,
+			   struct netfs_io_stream *stream,
+			   loff_t start, size_t len, bool to_eof)
 {
 	struct netfs_io_subrequest *subreq = stream->construct;
 	size_t part;


