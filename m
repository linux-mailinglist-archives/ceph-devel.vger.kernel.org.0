Return-Path: <ceph-devel+bounces-1970-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D03E99B10AC
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Oct 2024 22:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B731B216C3
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Oct 2024 20:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE432315B8;
	Fri, 25 Oct 2024 20:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7ljmFTo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52CA217661
	for <ceph-devel@vger.kernel.org>; Fri, 25 Oct 2024 20:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729888968; cv=none; b=g1dMMk1cuC1plWOfAvAbURJSz+Q9nXzCNBCLq4W6ZFw1W8bF5rqOd7yexoqUAT2a0LDia56FAWaomzZ4AroNMP2CwF0MH4E6kR2bu+f1ie3gTewBFtRLQ7IjuVpe18M+I3LCsG+8oLh1TOh01p55DCt+BA0jHjBOtFuK9m+QyJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729888968; c=relaxed/simple;
	bh=raCpdqcu2ygldk7gd5VDDvJXWwDH1Uhs8ai3Ef9spQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsR3FCn+it4P4qO8CQuyWHXMuZdJQxN59//KPirVUqiRXe1907q72NeBC3570rk72065og3vjmITB6oGy2qX4vnumNhmquJZgIhMf5mMQm2UTQCl92Moz6NRVEPftuYxbwWM5hpPxLxwV1aurYLrbr/GnNzpgGWtaGHFx5f2u7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7ljmFTo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729888965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u3/1sOVuQqHpfo8UyVSOFEz4LX0EnJcfMGVnlE5mJ3g=;
	b=L7ljmFToIRg5sutRaX9lg9qfYKObPPs4c2IljVyUvzCtjFuo1x61oxYmu4dLmDGrXCeusE
	f1r7u2jvzqkcK0psUal8DGFrY0YY3i+taztSn0pUsF5wTqy9Qlcis6KMPxxRrC8CSZ/PrU
	De+RAxTN0b/5Ap/Lpdl9MwjfEllwrlA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-05d17uMeOhmt3mB9GS9P3A-1; Fri,
 25 Oct 2024 16:42:41 -0400
X-MC-Unique: 05d17uMeOhmt3mB9GS9P3A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 140651955F2B;
	Fri, 25 Oct 2024 20:42:39 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.231])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 43D3A19560A2;
	Fri, 25 Oct 2024 20:42:34 +0000 (UTC)
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
Subject: [PATCH v2 21/31] afs: Make afs_init_request() get a key if not given a file
Date: Fri, 25 Oct 2024 21:39:48 +0100
Message-ID: <20241025204008.4076565-22-dhowells@redhat.com>
In-Reply-To: <20241025204008.4076565-1-dhowells@redhat.com>
References: <20241025204008.4076565-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In a future patch, AFS directory caching will go through netfslib and this
will involve, at times, running on behalf of ->lookup(), which doesn't
provide us with a file from which we can get an authentication key.

If a file isn't provided, make afs_init_request() get a key from the
process's keyrings instead when setting up a read.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 fs/afs/file.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index f717168da4ab..a9d98d18407c 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -372,10 +372,26 @@ static int afs_symlink_read_folio(struct file *file, struct folio *folio)
 
 static int afs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
+	struct afs_vnode *vnode = AFS_FS_I(rreq->inode);
+
 	if (file)
 		rreq->netfs_priv = key_get(afs_file_key(file));
 	rreq->rsize = 256 * 1024;
 	rreq->wsize = 256 * 1024 * 1024;
+
+	switch (rreq->origin) {
+	case NETFS_READ_SINGLE:
+		if (!file) {
+			struct key *key = afs_request_key(vnode->volume->cell);
+
+			if (IS_ERR(key))
+				return PTR_ERR(key);
+			rreq->netfs_priv = key;
+		}
+		break;
+	default:
+		break;
+	}
 	return 0;
 }
 


