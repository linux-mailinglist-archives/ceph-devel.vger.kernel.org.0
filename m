Return-Path: <ceph-devel+bounces-2653-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA9DEA33285
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2025 23:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 926BF164AF8
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2025 22:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C565B263C82;
	Wed, 12 Feb 2025 22:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahBUMkjh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA6F263C62
	for <ceph-devel@vger.kernel.org>; Wed, 12 Feb 2025 22:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739399087; cv=none; b=nYiUUTR1E0k+fz/cqHfSA5Tl1L064dov/JyixOqc0oKvPXpxQjwh1vC0tfKywlmGZaVjVkWVgeBR9r/eNQtiYHaPm33IXazMuJFgmx7Iv7Uej5LBkr2HUD0SbK0G7Ei63wcm7an6JH5qhUxChHkQd3cWT8JYg2EW0snRO8zvunQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739399087; c=relaxed/simple;
	bh=yWnkbiNcQ6t7qYxrt46zdDa0QIZXGwyGHgRdFljHBVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyk9wmSRrE8A3+Lmido5zeVV0OuCSCtSns6M2osFwUQw+32tGPpd9a4pa4htVtwt/wo+ZsShk2ERyZjUUCZNSIqvaGrlyhQ0qU0O7vTPqI5GEVwccQ4QJ3Jh4xEsRac9MXNR3f4VY5Ng58J30i8A8vZgbvRUqNgSpJuDuXta874=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ahBUMkjh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739399084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EHAXmEebuXfGaW+Cbp856q5t3oORgVUeZdmoxZNWAV4=;
	b=ahBUMkjhlXWOHD0BYgZfEkVjaHEaLahHpS0huenCoCeOysq62ngohN/ng2RdraxXf+9E2U
	VrILOgCAJ5VD4A/Qy8sK+0TOM2hSNxtEgIJUAiRf3p36bQOXGzsW78cKjR2drRSqb34Qza
	D3gNRMm6NsNYwmwujoMQMCLj/mgl4Ic=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-117-0JhFd5MBMq-N6YBSpy5hVg-1; Wed,
 12 Feb 2025 17:24:40 -0500
X-MC-Unique: 0JhFd5MBMq-N6YBSpy5hVg-1
X-Mimecast-MFC-AGG-ID: 0JhFd5MBMq-N6YBSpy5hVg_1739399077
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B56B7195608B;
	Wed, 12 Feb 2025 22:24:36 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.92])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B79951955F21;
	Wed, 12 Feb 2025 22:24:29 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Max Kellermann <max.kellermann@ionos.com>,
	Steve French <sfrench@samba.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeff Layton <jlayton@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ihor Solodrai <ihor.solodrai@pm.me>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 3/3] netfs: Fix setting NETFS_RREQ_ALL_QUEUED to be after all subreqs queued
Date: Wed, 12 Feb 2025 22:24:01 +0000
Message-ID: <20250212222402.3618494-4-dhowells@redhat.com>
In-Reply-To: <20250212222402.3618494-1-dhowells@redhat.com>
References: <20250212222402.3618494-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Due to the code that queues a subreq on the active subrequest list getting
moved to netfs_issue_read(), the NETFS_RREQ_ALL_QUEUED flag may now get set
before the list-add actually happens.  This is not a problem if the
collection worker happens after the list-add, but it's a race - and, for
9P, where the read from the server is synchronous and done in the
submitting thread, this is a lot more likely.

The result is that, if the timing is wrong, a ref gets leaked because the
collector thinks that all the subreqs have completed (because it can't see
the last one yet) and clears NETFS_RREQ_IN_PROGRESS - at which point, the
collection worker no longer goes into the collector.

This can be provoked with AFS by injecting an msleep() right before the
final subreq is queued.

Fix this by splitting the queuing part out of netfs_issue_read() into a new
function, netfs_queue_read(), and calling it separately.  The setting of
NETFS_RREQ_ALL_QUEUED is then done by netfs_queue_read() whilst it is
holding the spinlock (that's probably unnecessary, but shouldn't hurt).

It might be better to set a flag on the final subreq, but this could be a
problem if an error occurs and we can't queue it.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Reported-by: Ihor Solodrai <ihor.solodrai@pm.me>
Closes: https://lore.kernel.org/r/a7x33d4dnMdGTtRivptq6S1i8btK70SNBP2XyX_xwDAhLvgQoPox6FVBOkifq4eBinfFfbZlIkMZBe3QarlWTxoEtHZwJCZbNKtaqrR7PvI=@pm.me/
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
cc: Eric Van Hensbergen <ericvh@kernel.org>
cc: Latchesar Ionkov <lucho@ionkov.net>
cc: Dominique Martinet <asmadeus@codewreck.org>
cc: Christian Schoenebeck <linux_oss@crudebyte.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Steve French <stfrench@microsoft.com>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: v9fs@lists.linux.dev
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index f761d44b3436..0d1b6d35ff3b 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -155,8 +155,9 @@ static void netfs_read_cache_to_pagecache(struct netfs_io_request *rreq,
 			netfs_cache_read_terminated, subreq);
 }
 
-static void netfs_issue_read(struct netfs_io_request *rreq,
-			     struct netfs_io_subrequest *subreq)
+static void netfs_queue_read(struct netfs_io_request *rreq,
+			     struct netfs_io_subrequest *subreq,
+			     bool last_subreq)
 {
 	struct netfs_io_stream *stream = &rreq->io_streams[0];
 
@@ -177,8 +178,17 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
 		}
 	}
 
+	if (last_subreq) {
+		smp_wmb(); /* Write lists before ALL_QUEUED. */
+		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+	}
+
 	spin_unlock(&rreq->lock);
+}
 
+static void netfs_issue_read(struct netfs_io_request *rreq,
+			     struct netfs_io_subrequest *subreq)
+{
 	switch (subreq->source) {
 	case NETFS_DOWNLOAD_FROM_SERVER:
 		rreq->netfs_ops->issue_read(subreq);
@@ -293,11 +303,8 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 		}
 		size -= slice;
 		start += slice;
-		if (size <= 0) {
-			smp_wmb(); /* Write lists before ALL_QUEUED. */
-			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
-		}
 
+		netfs_queue_read(rreq, subreq, size <= 0);
 		netfs_issue_read(rreq, subreq);
 		cond_resched();
 	} while (size > 0);


