Return-Path: <ceph-devel+bounces-2923-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D93A605F1
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 00:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6AC43B5FB9
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 23:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A615E1FDA8D;
	Thu, 13 Mar 2025 23:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKTQ+FJo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F5B211A12
	for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 23:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741908953; cv=none; b=KdrBNMzKuvLmrWL+USe89gSEp4vAzKBkhg1/XyY4ujw89IvJVRAplzHJkUirE1LcOmq7tj8mN6vYtCKGzBfYaRdCdP43SrXX+GW1bl7wHzpYSPoQxLGz/nGqqI/xQICatMDDceI3oEzYHUf/LfE0WOTs/VttkNxbjjh0BOLuwj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741908953; c=relaxed/simple;
	bh=gCChVgMBzGvrlJ7sZIvOLzGNcSU2zki3HyYavWVM5pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kk9qyvuJsl4BMddK89mUfXSmT1svjx6gIwqY6TwfT3XkZLP6RYJKkyrS3fn4gPZFjcRR7zAlt1cTRvUyXxLVZoxhePMijsrUwtvo4E7YJCmRn5HylatEjFwNatPmXfFgw3NltnktQs1ngINZgfGLyxOPGHtHAh/pjTdNiyWidzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QKTQ+FJo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741908951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d01oWNmun+xrcu/GBCdvzw0vab4iyfs4NG678lUElAM=;
	b=QKTQ+FJoTDP2TZKg6caFY1nYWVNzHKAsoTsnlJjwRl4228MmCPQ4ks2sTqzItiFoe9ggSk
	4kPkeWyA+gzlMKcelpTPtQuwMYm41Y3AT4BykgjFM7B8xvY5ZCtSxct9LS2cH5zWDnN+cy
	AIw8B7V43K3snAezBll7NUMhpQiGrc4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-PyevtBxrP3KxREWu0FWF4g-1; Thu,
 13 Mar 2025 19:35:46 -0400
X-MC-Unique: PyevtBxrP3KxREWu0FWF4g-1
X-Mimecast-MFC-AGG-ID: PyevtBxrP3KxREWu0FWF4g_1741908944
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B36101801A07;
	Thu, 13 Mar 2025 23:35:44 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.61])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6E5E8300376F;
	Thu, 13 Mar 2025 23:35:42 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 31/35] netfs: Fix netfs_unbuffered_read() to return ssize_t rather than int
Date: Thu, 13 Mar 2025 23:33:23 +0000
Message-ID: <20250313233341.1675324-32-dhowells@redhat.com>
In-Reply-To: <20250313233341.1675324-1-dhowells@redhat.com>
References: <20250313233341.1675324-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Fix netfs_unbuffered_read() to return an ssize_t rather than an int as
netfs_wait_for_read() returns ssize_t and this gets implicitly truncated.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Viacheslav Dubeyko <slava@dubeyko.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: ceph-devel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/direct_read.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/direct_read.c b/fs/netfs/direct_read.c
index 15a6923a92ca..5e4bd1e5a378 100644
--- a/fs/netfs/direct_read.c
+++ b/fs/netfs/direct_read.c
@@ -201,9 +201,9 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
  * Perform a read to an application buffer, bypassing the pagecache and the
  * local disk cache.
  */
-static int netfs_unbuffered_read(struct netfs_io_request *rreq, bool sync)
+static ssize_t netfs_unbuffered_read(struct netfs_io_request *rreq, bool sync)
 {
-	int ret;
+	ssize_t ret;
 
 	_enter("R=%x %llx-%llx",
 	       rreq->debug_id, rreq->start, rreq->start + rreq->len - 1);
@@ -231,7 +231,7 @@ static int netfs_unbuffered_read(struct netfs_io_request *rreq, bool sync)
 	else
 		ret = -EIOCBQUEUED;
 out:
-	_leave(" = %d", ret);
+	_leave(" = %zd", ret);
 	return ret;
 }
 


