Return-Path: <ceph-devel+bounces-1594-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 973D293FAD8
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 18:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53B76288460
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 16:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4BA18308E;
	Mon, 29 Jul 2024 16:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NBsbDdfp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC30181B99
	for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722270106; cv=none; b=svmAj6sEZ9s4TypfqUZBd/eHo+NgUwt9TVMX1jH28W2qBtFenwYp4MEi5FjtxfgHmXj3SReJRT567fL55KanQZoTMSWsvxisOuzXSpmgzzqjP3zcTwnyq/MS/goY/KJ+rrK6GVh9TFuAjuHqixY/MpwMaEYKOy7w8XA4vdOGFck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722270106; c=relaxed/simple;
	bh=Xp9h1oxsBE7ptoWzGWenivDQai71kJ1ZC0VChH4GqGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFGqITFJOlzH+rcmQaeaZN27nx0E8lV9UlK9+Pv2kGu8y4AX5GLItpDykRWM3NiBiveKMYpWzSrkf1YHQITswFywncFkFxR1zeXAxe2U8K3KucXqScAq1Z3x4VbURctfNopDtxJlldf35M4ccn/qwTjfeaf0UIurbJQ6YdbENoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NBsbDdfp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722270104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b5eevWbmfPigkA2FdYCNfJwGB2DQgwa2DeAbWa0pHZ0=;
	b=NBsbDdfpANJDJhutbv1/vIqGp185orA/f0uRWsHGXHfwSjxnrCUMLQaVGFPecIzZSC2m2M
	6GPcOBG02n4pJL9K7p4mVM5wYg46eSMgreLF8tgaUDQx7EWb4tqS7N9ryODWiIgEjYrW6m
	ZBg4KVsmE/WBIt2tOBwS+SFb/MEgyTs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-U_DNJ7EfOGy2k1Ad-Ws3sQ-1; Mon,
 29 Jul 2024 12:21:40 -0400
X-MC-Unique: U_DNJ7EfOGy2k1Ad-Ws3sQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7D201955F41;
	Mon, 29 Jul 2024 16:21:35 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 388E81955F40;
	Mon, 29 Jul 2024 16:21:30 +0000 (UTC)
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
Subject: [PATCH 11/24] netfs: Use bh-disabling spinlocks for rreq->lock
Date: Mon, 29 Jul 2024 17:19:40 +0100
Message-ID: <20240729162002.3436763-12-dhowells@redhat.com>
In-Reply-To: <20240729162002.3436763-1-dhowells@redhat.com>
References: <20240729162002.3436763-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Use bh-disabling spinlocks when accessing rreq->lock because, in the
future, it may be twiddled from softirq context when cleanup is driven from
cache backend DIO completion.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_collect.c | 4 ++--
 fs/netfs/write_issue.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index e105ac270090..5f504b03a1e7 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -466,7 +466,7 @@ static void netfs_collect_write_results(struct netfs_io_request *wreq)
 
 		cancel:
 			/* Remove if completely consumed. */
-			spin_lock(&wreq->lock);
+			spin_lock_bh(&wreq->lock);
 
 			remove = front;
 			list_del_init(&front->rreq_link);
@@ -482,7 +482,7 @@ static void netfs_collect_write_results(struct netfs_io_request *wreq)
 				}
 			}
 
-			spin_unlock(&wreq->lock);
+			spin_unlock_bh(&wreq->lock);
 			netfs_put_subrequest(remove, false,
 					     notes & SAW_FAILURE ?
 					     netfs_sreq_trace_put_cancel :
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 6e835670dc58..0354c992467b 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -189,7 +189,7 @@ static void netfs_prepare_write(struct netfs_io_request *wreq,
 	 * the list.  The collector only goes nextwards and uses the lock to
 	 * remove entries off of the front.
 	 */
-	spin_lock(&wreq->lock);
+	spin_lock_bh(&wreq->lock);
 	list_add_tail(&subreq->rreq_link, &stream->subrequests);
 	if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
 		stream->front = subreq;
@@ -200,7 +200,7 @@ static void netfs_prepare_write(struct netfs_io_request *wreq,
 		}
 	}
 
-	spin_unlock(&wreq->lock);
+	spin_unlock_bh(&wreq->lock);
 
 	stream->construct = subreq;
 }


