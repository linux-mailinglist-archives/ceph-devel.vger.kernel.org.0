Return-Path: <ceph-devel+bounces-126-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC797EF985
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 22:16:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD38E1F2733B
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 21:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19424652E;
	Fri, 17 Nov 2023 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a6s1YE4C"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B78B198A
	for <ceph-devel@vger.kernel.org>; Fri, 17 Nov 2023 13:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700255768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hEis0LpqHig0B1ZU0ewbKxCSS/w/yhv1086SqFY6jkI=;
	b=a6s1YE4CYOaUrcpX3V7VYp1p67BSGuhLtipDzjC3qSkjZ1yTzqgWOGhTA+IrSrUWyZSxtO
	nMk5EmqHdahIWfVojmlljxY1874oTr2FEzUb52sX3hWFDeT8B9SPQ0MGGjSCkjVGk02Xwa
	uAWcPYb2eEcpPCfbRlA6do7QbLI4PGE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-6kgqm_xqNl-O_djWqEdQ7g-1; Fri, 17 Nov 2023 16:16:04 -0500
X-MC-Unique: 6kgqm_xqNl-O_djWqEdQ7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E659A185A784;
	Fri, 17 Nov 2023 21:16:02 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.16])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 52EBD2166B29;
	Fri, 17 Nov 2023 21:16:00 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Jeff Layton <jlayton@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Christian Brauner <christian@brauner.io>,
	linux-cachefs@redhat.com,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/51] netfs: Add a ->free_subrequest() op
Date: Fri, 17 Nov 2023 21:14:56 +0000
Message-ID: <20231117211544.1740466-5-dhowells@redhat.com>
In-Reply-To: <20231117211544.1740466-1-dhowells@redhat.com>
References: <20231117211544.1740466-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Add a ->free_subrequest() op so that the netfs can clean up data attached
to a subrequest.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cachefs@redhat.com
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/netfs/objects.c    | 2 ++
 include/linux/netfs.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index c4229c5f3f54..1bd20bdad983 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -145,6 +145,8 @@ static void netfs_free_subrequest(struct netfs_io_subrequest *subreq,
 	struct netfs_io_request *rreq = subreq->rreq;
 
 	trace_netfs_sreq(subreq, netfs_sreq_trace_free);
+	if (rreq->netfs_ops->free_subrequest)
+		rreq->netfs_ops->free_subrequest(subreq);
 	kfree(subreq);
 	netfs_stat_d(&netfs_n_rh_sreq);
 	netfs_put_request(rreq, was_async, netfs_rreq_trace_put_subreq);
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index ddd55b35e650..0633cd9644e1 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -216,6 +216,7 @@ struct netfs_request_ops {
 	unsigned int	io_subrequest_size;	/* Alloc size for netfs_io_subrequest struct */
 	int (*init_request)(struct netfs_io_request *rreq, struct file *file);
 	void (*free_request)(struct netfs_io_request *rreq);
+	void (*free_subrequest)(struct netfs_io_subrequest *rreq);
 	int (*begin_cache_operation)(struct netfs_io_request *rreq);
 
 	void (*expand_readahead)(struct netfs_io_request *rreq);


