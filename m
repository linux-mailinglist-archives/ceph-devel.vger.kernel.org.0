Return-Path: <ceph-devel+bounces-1779-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B125F963385
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2024 23:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FCB128344D
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2024 21:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2F881B010A;
	Wed, 28 Aug 2024 21:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H84WH5+U"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBAB1AED5A
	for <ceph-devel@vger.kernel.org>; Wed, 28 Aug 2024 21:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724879031; cv=none; b=cpS1JC67NGLX12ts2BC/gDzzFIMtQerYzQ5xjobszxto7rwSlIwbws7U6BXbxsguDunZO7MC+m3ggmk5yWzO3fW+PwsagVFbzxq3hjU6wW5DQu4icmWsaZWxQu+m96R4C83YxrZyUxqYuz7wgUr7LmK7NnWlE/Vz6nFxddrPMII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724879031; c=relaxed/simple;
	bh=dZLD/JcsA3bm8Cz88EokWnyb6qwNyJsN5B2wjUVoB8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LN4MtQTEjgwZV2/An9cnj0Jo/GSWHZFDvNRD936c4Qzc3w5wwfRSMnb3Y3VamuvC8JW3HWQPwgrwOXf9usQe/NPswmcem/F4f+6RuSNTWrmQ+8ZYwbgUAzPAcAeZgKXYOX3lzATW7AvYBd2/7nUZBlYY6i9Ah/wlNAYzNd83Gs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H84WH5+U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724879028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HnRbucMY226i4IUYHJiuv+7kBNxjZEs05bItUy7sjXs=;
	b=H84WH5+UL8UxRRVnpf9p0V5mVablrgZRKX406GqAboL5SOin45CuNKCcuFozUU0bEwRyec
	qjP2uVZ1VVWKany/0WmjH6KWnSDFP0Vlh/VP0Qsa8NxmknjEhinTRBRoZts5gj88ABxVzg
	8NGDYgEtsEK62SYEr0xLuu+d+w+flSo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-iAIpNcUkPheyG0CeJjFQ_w-1; Wed,
 28 Aug 2024 17:03:45 -0400
X-MC-Unique: iAIpNcUkPheyG0CeJjFQ_w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 010F11955BF1;
	Wed, 28 Aug 2024 21:03:43 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.30])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5B35C1955BF2;
	Wed, 28 Aug 2024 21:03:38 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Jeff Layton <jlayton@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] netfs, cifs: Improve some debugging bits
Date: Wed, 28 Aug 2024 22:02:47 +0100
Message-ID: <20240828210249.1078637-7-dhowells@redhat.com>
In-Reply-To: <20240828210249.1078637-1-dhowells@redhat.com>
References: <20240828210249.1078637-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Improve some debugging bits:

 (1) The netfslib _debug() macro doesn't need a newline in its format
     string.

 (2) Display the request debug ID and subrequest index in messages emitted
     in smb2_adjust_credits() to make it easier to reference in traces.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/io.c           | 2 +-
 fs/smb/client/smb2ops.c | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/netfs/io.c b/fs/netfs/io.c
index 943128507af5..d6ada4eba744 100644
--- a/fs/netfs/io.c
+++ b/fs/netfs/io.c
@@ -270,7 +270,7 @@ static void netfs_reset_subreq_iter(struct netfs_io_request *rreq,
 	if (count == remaining)
 		return;
 
-	_debug("R=%08x[%u] ITER RESUB-MISMATCH %zx != %zx-%zx-%llx %x\n",
+	_debug("R=%08x[%u] ITER RESUB-MISMATCH %zx != %zx-%zx-%llx %x",
 	       rreq->debug_id, subreq->debug_index,
 	       iov_iter_count(&subreq->io_iter), subreq->transferred,
 	       subreq->len, rreq->i_size,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4df84ebe8dbe..e6540072ffb0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -316,7 +316,8 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 				      cifs_trace_rw_credits_no_adjust_up);
 		trace_smb3_too_many_credits(server->CurrentMid,
 				server->conn_id, server->hostname, 0, credits->value - new_val, 0);
-		cifs_server_dbg(VFS, "request has less credits (%d) than required (%d)",
+		cifs_server_dbg(VFS, "R=%x[%x] request has less credits (%d) than required (%d)",
+				subreq->rreq->debug_id, subreq->subreq.debug_index,
 				credits->value, new_val);
 
 		return -EOPNOTSUPP;
@@ -338,8 +339,9 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 		trace_smb3_reconnect_detected(server->CurrentMid,
 			server->conn_id, server->hostname, scredits,
 			credits->value - new_val, in_flight);
-		cifs_server_dbg(VFS, "trying to return %d credits to old session\n",
-			 credits->value - new_val);
+		cifs_server_dbg(VFS, "R=%x[%x] trying to return %d credits to old session\n",
+				subreq->rreq->debug_id, subreq->subreq.debug_index,
+				credits->value - new_val);
 		return -EAGAIN;
 	}
 


