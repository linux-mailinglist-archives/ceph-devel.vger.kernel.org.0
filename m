Return-Path: <ceph-devel+bounces-1640-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B32DE94B11F
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Aug 2024 22:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7C291C21CC8
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Aug 2024 20:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86891145B1F;
	Wed,  7 Aug 2024 20:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bC5FrRG1"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E293A364BC
	for <ceph-devel@vger.kernel.org>; Wed,  7 Aug 2024 20:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723061888; cv=none; b=IUVlW0pvQRv9m/J7bxNoCpy433UuL6jIBLFXtsLJvheYVs5+COX5UQa0DL/E53TQjYnZEXJlAxliZoon/AElwtuL7r3a2q5xSmZDA4fyEFiwtAV1IeKLB5Zj0j8pdxVi33xBfaMsBU/QXVUfxxAx/fKD6S4SPn3K5LTcmrjIKFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723061888; c=relaxed/simple;
	bh=3oZmI4Bk2FG6XWDFzjxcfPmaEjo1nrh01Kq43vuvXBo=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=DNM00aba9DZaRqZz5/dQQ51agUsIoT5+k/yo9lfgXjQw+rX+WE1/VWXzsSXe2Cj6cD2a6qiOGR1w6jEKiPqfr/gzPIbi9LdZJOCgOftL2t8lcnJMhPG2AV0WL9/gvaScirriLmRIj8XqhZ7bfkY1f8pDE/8jiJ2lVu/q/i60OXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bC5FrRG1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723061883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PB7jDj4g6YqOIndRvSsTnVMDnIANmZYWu0a84ms3HyI=;
	b=bC5FrRG1NGBTe1r9BSovNQxK8n4LPBC0S3kQoA01U5MPr/h4KK17fur3DLC0GP1oKjpwKz
	u9J9psLqUrZsO7d//8ldOhLVEBxW/9VwGi4S9vtqAqMfPMhMeDvUAR/2dtheM/ceTU2V7X
	C0EQpSqfs2DuMB1idvbOb8xdN/gdXJM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-8jQ4ErJNP96l7RqN3XcAIg-1; Wed,
 07 Aug 2024 16:18:00 -0400
X-MC-Unique: 8jQ4ErJNP96l7RqN3XcAIg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 592AA1955D65;
	Wed,  7 Aug 2024 20:17:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.216])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3256C300018D;
	Wed,  7 Aug 2024 20:17:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAKPOu+-4LQM2-Ciro0LbbhVPa+YyHD3BnLL+drmG5Ca-b4wmLg@mail.gmail.com>
References: <CAKPOu+-4LQM2-Ciro0LbbhVPa+YyHD3BnLL+drmG5Ca-b4wmLg@mail.gmail.com> <20240729091532.855688-1-max.kellermann@ionos.com> <3575457.1722355300@warthog.procyon.org.uk> <CAKPOu+9_TQx8XaB2gDKzwN-YoN69uKoZGiCDPQjz5fO-2ztdFQ@mail.gmail.com> <CAKPOu+-4C7qPrOEe=trhmpqoC-UhCLdHGmeyjzaUymg=k93NEA@mail.gmail.com> <3717298.1722422465@warthog.procyon.org.uk>
To: Max Kellermann <max.kellermann@ionos.com>,
    Hristo Venev <hristo@venev.name>
Cc: dhowells@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
    Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
    willy@infradead.org, ceph-devel@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [RFC][PATCH] netfs: Fix handling of USE_PGPRIV2 and WRITE_TO_CACHE flags
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <861628.1723061874.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Aug 2024 21:17:54 +0100
Message-ID: <861629.1723061874@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The attached patch gets me most of the way there, applied on the top of th=
e
reversion one.  See:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Dnetfs-fixes

There's still an occasional slab-use-after-free that pops up:

	BUG: KASAN: slab-use-after-free in xa_head+0xe/0x70
	Read of size 8 at addr ffff8881b2cf6df8 by task kworker/0:1/9
	...
	 xa_head+0xe/0x70
	 xas_start+0xca/0x140
	 xas_load+0x16/0x110
	 xas_find+0x84/0x1f0
	 __fscache_clear_page_bits+0x136/0x340
	...

where the thing being allocated is a ceph inode.

Note that Hristo's patch is not sufficient.

David
---
    netfs: Fix handling of USE_PGPRIV2 and WRITE_TO_CACHE flags
    =

    The NETFS_RREQ_USE_PGPRIV2 and NETFS_RREQ_WRITE_TO_CACHE flags aren't =
used
    correctly.  The problem is that we try to set them up in the request
    initialisation, but we the cache may be in the process of setting up s=
till,
    and so the state may not be correct.  Further, we secondarily sample t=
he
    cache state and make contradictory decisions later.
    =

    The issue arises because we set up the cache resources, which allows t=
he
    cache's ->prepare_read() to switch on NETFS_SREQ_COPY_TO_CACHE - which
    triggers cache writing even if we didn't set the flags when allocating=
.
    =

    Fix this in the following way:
    =

     (1) Drop NETFS_ICTX_USE_PGPRIV2 and instead set NETFS_RREQ_USE_PGPRIV=
2 in
         ->init_request() rather than trying to juggle that in
         netfs_alloc_request().
    =

     (2) Repurpose NETFS_RREQ_USE_PGPRIV2 to merely indicate that if cachi=
ng is
         to be done, then PG_private_2 is to be used rather than only sett=
ing
         it if we decide to cache and then having netfs_rreq_unlock_folios=
()
         set the non-PG_private_2 writeback-to-cache if it wasn't set.
    =

     (3) Split netfs_rreq_unlock_folios() into two functions, one of which
         contains the deprecated code for using PG_private_2 to avoid
         accidentally doing the writeback path - and always use it if
         USE_PGPRIV2 is set.
    =

     (4) As NETFS_ICTX_USE_PGPRIV2 is removed, make netfs_write_begin() al=
ways
         wait for PG_private_2.  This function is deprecated and only used=
 by
         ceph anyway, and so label it so.
    =

     (5) Drop the NETFS_RREQ_WRITE_TO_CACHE flag and use
         fscache_operation_valid() on the cache_resources instead.  This h=
as
         the advantage of picking up the result of netfs_begin_cache_read(=
) and
         fscache_begin_write_operation() - which are called after the obje=
ct is
         initialised and will wait for the cache to come to a usable state=
.
    =

    Just reverting ae678317b95e[1] isn't a sufficient fix, so this need to=
 be
    applied on top of that.  Without this as well, things like:
    =

     rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: {
    =

    and:
    =

     WARNING: CPU: 13 PID: 3621 at fs/ceph/caps.c:3386
    =

    may happen, along with some UAFs due to PG_private_2 not getting used =
to
    wait on writeback completion.
    =

    Fixes: 2ff1e97587f4 ("netfs: Replace PG_fscache by setting folio->priv=
ate and marking dirty")
    Reported-by: Max Kellermann <max.kellermann@ionos.com>
    Signed-off-by: David Howells <dhowells@redhat.com>
    cc: Ilya Dryomov <idryomov@gmail.com>
    cc: Xiubo Li <xiubli@redhat.com>
    cc: Hristo Venev <hristo@venev.name>
    cc: Jeff Layton <jlayton@kernel.org>
    cc: Matthew Wilcox <willy@infradead.org>
    cc: ceph-devel@vger.kernel.org
    cc: netfs@lists.linux.dev
    cc: linux-fsdevel@vger.kernel.org
    cc: linux-mm@kvack.org
    Link: https://lore.kernel.org/r/3575457.1722355300@warthog.procyon.org=
.uk/ [1]

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 73b5a07bf94d..cc0a2240de98 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -424,6 +424,9 @@ static int ceph_init_request(struct netfs_io_request *=
rreq, struct file *file)
 	struct ceph_netfs_request_data *priv;
 	int ret =3D 0;
 =

+	/* [DEPRECATED] Use PG_private_2 to mark folio being written to the cach=
e. */
+	__set_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags);
+
 	if (rreq->origin !=3D NETFS_READAHEAD)
 		return 0;
 =

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 8f8de8f33abb..71cd70514efa 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -577,8 +577,6 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 =

 	/* Set parameters for the netfs library */
 	netfs_inode_init(&ci->netfs, &ceph_netfs_ops, false);
-	/* [DEPRECATED] Use PG_private_2 to mark folio being written to the cach=
e. */
-	__set_bit(NETFS_ICTX_USE_PGPRIV2, &ci->netfs.flags);
 =

 	spin_lock_init(&ci->i_ceph_lock);
 =

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 424048f9ed1f..79d83abb655b 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -9,6 +9,97 @@
 #include <linux/task_io_accounting_ops.h>
 #include "internal.h"
 =

+/*
+ * [DEPRECATED] Unlock the folios in a read operation for when the filesy=
stem
+ * is using PG_private_2 and direct writing to the cache from here rather=
 than
+ * marking the page for writeback.
+ *
+ * Note that we don't touch folio->private in this code.
+ */
+static void netfs_rreq_unlock_folios_pgpriv2(struct netfs_io_request *rre=
q)
+{
+	struct netfs_io_subrequest *subreq;
+	struct folio *folio;
+	pgoff_t start_page =3D rreq->start / PAGE_SIZE;
+	pgoff_t last_page =3D ((rreq->start + rreq->len) / PAGE_SIZE) - 1;
+	size_t account =3D 0;
+	bool subreq_failed =3D false;
+
+	XA_STATE(xas, &rreq->mapping->i_pages, start_page);
+
+	/* Walk through the pagecache and the I/O request lists simultaneously.
+	 * We may have a mixture of cached and uncached sections and we only
+	 * really want to write out the uncached sections.  This is slightly
+	 * complicated by the possibility that we might have huge pages with a
+	 * mixture inside.
+	 */
+	subreq =3D list_first_entry(&rreq->subrequests,
+				  struct netfs_io_subrequest, rreq_link);
+	subreq_failed =3D (subreq->error < 0);
+
+	trace_netfs_rreq(rreq, netfs_rreq_trace_unlock_pgpriv2);
+
+	rcu_read_lock();
+	xas_for_each(&xas, folio, last_page) {
+		loff_t pg_end;
+		bool pg_failed =3D false;
+		bool folio_started =3D false;
+
+		if (xas_retry(&xas, folio))
+			continue;
+
+		pg_end =3D folio_pos(folio) + folio_size(folio) - 1;
+
+		for (;;) {
+			loff_t sreq_end;
+
+			if (!subreq) {
+				pg_failed =3D true;
+				break;
+			}
+
+			if (!folio_started &&
+			    test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags) &&
+			    fscache_operation_valid(&rreq->cache_resources)) {
+				trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
+				folio_start_private_2(folio);
+				folio_started =3D true;
+			}
+
+			pg_failed |=3D subreq_failed;
+			sreq_end =3D subreq->start + subreq->len - 1;
+			if (pg_end < sreq_end)
+				break;
+
+			account +=3D subreq->transferred;
+			if (!list_is_last(&subreq->rreq_link, &rreq->subrequests)) {
+				subreq =3D list_next_entry(subreq, rreq_link);
+				subreq_failed =3D (subreq->error < 0);
+			} else {
+				subreq =3D NULL;
+				subreq_failed =3D false;
+			}
+
+			if (pg_end =3D=3D sreq_end)
+				break;
+		}
+
+		if (!pg_failed) {
+			flush_dcache_folio(folio);
+			folio_mark_uptodate(folio);
+		}
+
+		if (!test_bit(NETFS_RREQ_DONT_UNLOCK_FOLIOS, &rreq->flags)) {
+			if (folio->index =3D=3D rreq->no_unlock_folio &&
+			    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags))
+				kdebug("no unlock");
+			else
+				folio_unlock(folio);
+		}
+	}
+	rcu_read_unlock();
+}
+
 /*
  * Unlock the folios in a read operation.  We need to set PG_writeback on=
 any
  * folios we're going to write back before we unlock them.
@@ -35,6 +126,12 @@ void netfs_rreq_unlock_folios(struct netfs_io_request =
*rreq)
 		}
 	}
 =

+	/* Handle deprecated PG_private_2 case. */
+	if (test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
+		netfs_rreq_unlock_folios_pgpriv2(rreq);
+		goto out;
+	}
+
 	/* Walk through the pagecache and the I/O request lists simultaneously.
 	 * We may have a mixture of cached and uncached sections and we only
 	 * really want to write out the uncached sections.  This is slightly
@@ -52,7 +149,6 @@ void netfs_rreq_unlock_folios(struct netfs_io_request *=
rreq)
 		loff_t pg_end;
 		bool pg_failed =3D false;
 		bool wback_to_cache =3D false;
-		bool folio_started =3D false;
 =

 		if (xas_retry(&xas, folio))
 			continue;
@@ -66,17 +162,8 @@ void netfs_rreq_unlock_folios(struct netfs_io_request =
*rreq)
 				pg_failed =3D true;
 				break;
 			}
-			if (test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
-				if (!folio_started && test_bit(NETFS_SREQ_COPY_TO_CACHE,
-							       &subreq->flags)) {
-					trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
-					folio_start_private_2(folio);
-					folio_started =3D true;
-				}
-			} else {
-				wback_to_cache |=3D
-					test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
-			}
+
+			wback_to_cache |=3D test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags)=
;
 			pg_failed |=3D subreq_failed;
 			sreq_end =3D subreq->start + subreq->len - 1;
 			if (pg_end < sreq_end)
@@ -124,6 +211,7 @@ void netfs_rreq_unlock_folios(struct netfs_io_request =
*rreq)
 	}
 	rcu_read_unlock();
 =

+out:
 	task_io_account_read(account);
 	if (rreq->netfs_ops->done)
 		rreq->netfs_ops->done(rreq);
@@ -395,7 +483,7 @@ static bool netfs_skip_folio_read(struct folio *folio,=
 loff_t pos, size_t len,
 }
 =

 /**
- * netfs_write_begin - Helper to prepare for writing
+ * netfs_write_begin - Helper to prepare for writing [DEPRECATED]
  * @ctx: The netfs context
  * @file: The file to read from
  * @mapping: The mapping to read from
@@ -426,6 +514,9 @@ static bool netfs_skip_folio_read(struct folio *folio,=
 loff_t pos, size_t len,
  * inode before calling this.
  *
  * This is usable whether or not caching is enabled.
+ *
+ * Note that this should be considered deprecated and netfs_perform_write=
()
+ * used instead.
  */
 int netfs_write_begin(struct netfs_inode *ctx,
 		      struct file *file, struct address_space *mapping,
@@ -507,11 +598,9 @@ int netfs_write_begin(struct netfs_inode *ctx,
 	netfs_put_request(rreq, false, netfs_rreq_trace_put_return);
 =

 have_folio:
-	if (test_bit(NETFS_ICTX_USE_PGPRIV2, &ctx->flags)) {
-		ret =3D folio_wait_private_2_killable(folio);
-		if (ret < 0)
-			goto error;
-	}
+	ret =3D folio_wait_private_2_killable(folio);
+	if (ret < 0)
+		goto error;
 have_folio_no_wait:
 	*_folio =3D folio;
 	_leave(" =3D 0");
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index f4a642727479..0faea0cee179 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -57,10 +57,6 @@ struct netfs_io_request *netfs_alloc_request(struct add=
ress_space *mapping,
 =

 	__set_bit(NETFS_RREQ_IN_PROGRESS, &rreq->flags);
 	if (cached) {
-		__set_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags);
-		if (test_bit(NETFS_ICTX_USE_PGPRIV2, &ctx->flags))
-			/* Filesystem uses deprecated PG_private_2 marking. */
-			__set_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags);
 	}
 	if (file && file->f_flags & O_NONBLOCK)
 		__set_bit(NETFS_RREQ_NONBLOCK, &rreq->flags);
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 9258d30cffe3..d35bb0f25d69 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -102,7 +102,7 @@ struct netfs_io_request *netfs_create_write_req(struct=
 address_space *mapping,
 	_enter("R=3D%x", wreq->debug_id);
 =

 	ictx =3D netfs_inode(wreq->inode);
-	if (test_bit(NETFS_RREQ_WRITE_TO_CACHE, &wreq->flags))
+	if (fscache_operation_valid(&wreq->cache_resources))
 		fscache_begin_write_operation(&wreq->cache_resources, netfs_i_cookie(ic=
tx));
 =

 	wreq->contiguity =3D wreq->start;
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 7202ce84d0eb..bf29a65c5027 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -265,6 +265,8 @@ static int nfs_netfs_init_request(struct netfs_io_requ=
est *rreq, struct file *fi
 {
 	rreq->netfs_priv =3D get_nfs_open_context(nfs_file_open_context(file));
 	rreq->debug_id =3D atomic_inc_return(&nfs_netfs_debug_id);
+	/* [DEPRECATED] Use PG_private_2 to mark folio being written to the cach=
e. */
+	__set_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags);
 =

 	return 0;
 }
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index fbed0027996f..e8adae1bc260 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -81,8 +81,6 @@ static inline void nfs_netfs_put(struct nfs_netfs_io_dat=
a *netfs)
 static inline void nfs_netfs_inode_init(struct nfs_inode *nfsi)
 {
 	netfs_inode_init(&nfsi->netfs, &nfs_netfs_ops, false);
-	/* [DEPRECATED] Use PG_private_2 to mark folio being written to the cach=
e. */
-	__set_bit(NETFS_ICTX_USE_PGPRIV2, &nfsi->netfs.flags);
 }
 extern void nfs_netfs_initiate_read(struct nfs_pgio_header *hdr);
 extern void nfs_netfs_read_completion(struct nfs_pgio_header *hdr);
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 5d0288938cc2..983816608f15 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -73,8 +73,6 @@ struct netfs_inode {
 #define NETFS_ICTX_ODIRECT	0		/* The file has DIO in progress */
 #define NETFS_ICTX_UNBUFFERED	1		/* I/O should not use the pagecache */
 #define NETFS_ICTX_WRITETHROUGH	2		/* Write-through caching */
-#define NETFS_ICTX_USE_PGPRIV2	31		/* [DEPRECATED] Use PG_private_2 to ma=
rk
-						 * write to cache on read */
 };
 =

 /*
@@ -269,7 +267,6 @@ struct netfs_io_request {
 #define NETFS_RREQ_DONT_UNLOCK_FOLIOS	3	/* Don't unlock the folios on com=
pletion */
 #define NETFS_RREQ_FAILED		4	/* The request failed */
 #define NETFS_RREQ_IN_PROGRESS		5	/* Unlocked when the request completes =
*/
-#define NETFS_RREQ_WRITE_TO_CACHE	7	/* Need to write to the cache */
 #define NETFS_RREQ_UPLOAD_TO_SERVER	8	/* Need to write to the server */
 #define NETFS_RREQ_NONBLOCK		9	/* Don't block if possible (O_NONBLOCK) */
 #define NETFS_RREQ_BLOCKED		10	/* We blocked */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 24ec3434d32e..606b4a0f92da 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -51,6 +51,7 @@
 	EM(netfs_rreq_trace_resubmit,		"RESUBMT")	\
 	EM(netfs_rreq_trace_set_pause,		"PAUSE  ")	\
 	EM(netfs_rreq_trace_unlock,		"UNLOCK ")	\
+	EM(netfs_rreq_trace_unlock_pgpriv2,	"UNLCK-2")	\
 	EM(netfs_rreq_trace_unmark,		"UNMARK ")	\
 	EM(netfs_rreq_trace_wait_ip,		"WAIT-IP")	\
 	EM(netfs_rreq_trace_wait_pause,		"WT-PAUS")	\


