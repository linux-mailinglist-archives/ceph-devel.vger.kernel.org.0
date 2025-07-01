Return-Path: <ceph-devel+bounces-3256-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3574AF003E
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Jul 2025 18:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 020A9522F18
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Jul 2025 16:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E768027F19B;
	Tue,  1 Jul 2025 16:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJE6Xots"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3D9285073
	for <ceph-devel@vger.kernel.org>; Tue,  1 Jul 2025 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751388001; cv=none; b=NGkvkHDS5FaHzaJaxARroJ5OStSqIwKnNkwn1pU8cP//R17ObQfCm6apssvpEcIZ3LRMihhvUS0Hro3ymbCHNyPm8+s+Kk7ZN/z2nqychGP+rzwCpj4///U239KpzRAp8+FRdczCrymSkP82IXMzCKu1axYYoTC02+xMr1Anysw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751388001; c=relaxed/simple;
	bh=1Q0oRaEau5feOQFhapDNP3oBG+YvQd7mZg8rXCKBmuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l77RrQf3XGk9fCdfOwwT4cztGqDU7gJSzbM7BGTSUMSEVmDcFiS1WY0xZThg7aBDQCPbQo7PA9WJ5QyF1KrQsT1Ed5z8iUXkwLQJCtZ50FCBBNVDNlcSnP4esZz/UdMH2MUqw8kX6E5DCQY5k4WeULvM5i8YlzQWq9fYnLdikp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJE6Xots; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751387999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2kkM7h4v2yYu8R7RF4RBij465q6rvNjUtPG15oPL6BE=;
	b=OJE6Xots7Tbd2oPDHS2L5blHGZiItFu+Ye/hYN6rWuBzMB2SXeg99VsKMuuodYPg07y3HP
	UaZrSphuHmvQpqCpl8QexzoFBAEyhNRZM3mNLEfc5LH5O3fkvh3K5FbYotY6aFksrC7ybZ
	GGtSdrxs5gDoMO2lqfzPYOCddQ5j3gw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-MtnioAmtNhKSTltnRjGcGw-1; Tue,
 01 Jul 2025 12:39:52 -0400
X-MC-Unique: MtnioAmtNhKSTltnRjGcGw-1
X-Mimecast-MFC-AGG-ID: MtnioAmtNhKSTltnRjGcGw_1751387990
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13811180136B;
	Tue,  1 Jul 2025 16:39:50 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.81])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C662330001B9;
	Tue,  1 Jul 2025 16:39:46 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 10/13] netfs: Fix i_size updating
Date: Tue,  1 Jul 2025 17:38:45 +0100
Message-ID: <20250701163852.2171681-11-dhowells@redhat.com>
In-Reply-To: <20250701163852.2171681-1-dhowells@redhat.com>
References: <20250701163852.2171681-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Fix the updating of i_size, particularly in regard to the completion of DIO
writes and especially async DIO writes by using a lock.

The bug is triggered occasionally by the generic/207 xfstest as it chucks a
bunch of AIO DIO writes at the filesystem and then checks that fstat()
returns a reasonable st_size as each completes.

The problem is that netfs is trying to do "if new_size > inode->i_size,
update inode->i_size" sort of thing but without a lock around it.

This can be seen with cifs, but shouldn't be seen with kafs because kafs
serialises modification ops on the client whereas cifs sends the requests
to the server as they're generated and lets the server order them.

Fixes: 153a9961b551 ("netfs: Implement unbuffered/DIO write support")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c | 2 ++
 fs/netfs/direct_write.c   | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 72a3e6db2524..b87ef3fe4ea4 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -64,6 +64,7 @@ static void netfs_update_i_size(struct netfs_inode *ctx, struct inode *inode,
 		return;
 	}
 
+	spin_lock(&inode->i_lock);
 	i_size_write(inode, pos);
 #if IS_ENABLED(CONFIG_FSCACHE)
 	fscache_update_cookie(ctx->cache, NULL, &pos);
@@ -77,6 +78,7 @@ static void netfs_update_i_size(struct netfs_inode *ctx, struct inode *inode,
 					DIV_ROUND_UP(pos, SECTOR_SIZE),
 					inode->i_blocks + add);
 	}
+	spin_unlock(&inode->i_lock);
 }
 
 /**
diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index fa9a5bf3c6d5..3efa5894b2c0 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -14,13 +14,17 @@ static void netfs_cleanup_dio_write(struct netfs_io_request *wreq)
 	struct inode *inode = wreq->inode;
 	unsigned long long end = wreq->start + wreq->transferred;
 
-	if (!wreq->error &&
-	    i_size_read(inode) < end) {
+	if (wreq->error || end <= i_size_read(inode))
+		return;
+
+	spin_lock(&inode->i_lock);
+	if (end > i_size_read(inode)) {
 		if (wreq->netfs_ops->update_i_size)
 			wreq->netfs_ops->update_i_size(inode, end);
 		else
 			i_size_write(inode, end);
 	}
+	spin_unlock(&inode->i_lock);
 }
 
 /*


