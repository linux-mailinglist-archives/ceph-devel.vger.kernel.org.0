Return-Path: <ceph-devel+bounces-1483-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 66BEC910F44
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2024 19:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23FDEB2B6B8
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2024 17:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D171C2338;
	Thu, 20 Jun 2024 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E3c+aZgO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B921C2300
	for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2024 17:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718904801; cv=none; b=X+89llJhoqXOS1aG0fbTy22JHNPJSfxkKG2IN/6QLCm/0HJlXXhwsS+TAJbHlINA4vlNky/xKOWmE8u6tx6mN24GTdFEj28yYzbMp2rDRR8lzNAh7XCySn12YJ/QnLPWCQJURpnToqrfCL7JmYVBMjYoSOyjdBFZbzr1hbVUc6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718904801; c=relaxed/simple;
	bh=2p9kWBbTHfnvBQ8i8TFWcwLEKkJ12Z5z63HjOwGkKNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPtFDtXIr2A4zlVOx499BgUH9qOEiZC/oBvu9Fiuy9k3TtOyCjGYWgwM2HrX32nt9CBsI7WdeCQf+OrkIxfcGkjk3Wzhl+4mYTkIFslWMrkOTYIb95Du4r424FoaqF4BKqF6/d8CuSuhou7OekMEkZF34TXoe+OLOXl3Qtut2NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E3c+aZgO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718904798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tcCzhA8XUd6wWPEL49ATAv4+dcrLDrKKLcUOQlZf5aE=;
	b=E3c+aZgO6DrT0poRT1Y+OHhlctVuTMIB6iHLzPtF3gYGg/yUhd5NMdNWeRBnoVPAawqaNz
	glUG7/8SCPMuEcClEQwshm6F8kDBMq9ROJ4PrpcjTeansbWiqzLK8MgYDwyA6FmMel35U3
	OjC8zRbGpQ6HtHwAHoYCQQMzciPIJSk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-dzyJCI2LOGq-cKgSo75gZA-1; Thu,
 20 Jun 2024 13:33:14 -0400
X-MC-Unique: dzyJCI2LOGq-cKgSo75gZA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E57F51956087;
	Thu, 20 Jun 2024 17:33:10 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.39.195.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B52743000602;
	Thu, 20 Jun 2024 17:33:04 +0000 (UTC)
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
	Steve French <sfrench@samba.org>
Subject: [PATCH 10/17] cifs: Only pick a channel once per read request
Date: Thu, 20 Jun 2024 18:31:28 +0100
Message-ID: <20240620173137.610345-11-dhowells@redhat.com>
In-Reply-To: <20240620173137.610345-1-dhowells@redhat.com>
References: <20240620173137.610345-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In cifs, only pick a channel when setting up a read request rather than
doing so individually for every subrequest and instead use that channel for
all.  This mirrors what the code in v6.9 does.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 14 +++-----------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 4b00512fb9f9..b48d3f5e8889 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1494,6 +1494,7 @@ struct cifs_aio_ctx {
 struct cifs_io_request {
 	struct netfs_io_request		rreq;
 	struct cifsFileInfo		*cfile;
+	struct TCP_Server_Info		*server;
 };
 
 /* asynchronous read support */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 67dd8fcd0e6d..16fa1ac1ed2d 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -134,17 +134,15 @@ static void cifs_issue_write(struct netfs_io_subrequest *subreq)
 static bool cifs_clamp_length(struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_request *rreq = subreq->rreq;
-	struct TCP_Server_Info *server;
 	struct cifs_io_subrequest *rdata = container_of(subreq, struct cifs_io_subrequest, subreq);
 	struct cifs_io_request *req = container_of(subreq->rreq, struct cifs_io_request, rreq);
+	struct TCP_Server_Info *server = req->server;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(rreq->inode->i_sb);
 	size_t rsize = 0;
 	int rc;
 
 	rdata->xid = get_xid();
 	rdata->have_xid = true;
-
-	server = cifs_pick_channel(tlink_tcon(req->cfile->tlink)->ses);
 	rdata->server = server;
 
 	if (cifs_sb->ctx->rsize == 0)
@@ -203,14 +201,7 @@ static void cifs_req_issue_read(struct netfs_io_subrequest *subreq)
 	__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
 	rdata->pid = pid;
 
-	rc = adjust_credits(rdata->server, &rdata->credits, rdata->subreq.len);
-	if (!rc) {
-		if (rdata->req->cfile->invalidHandle)
-			rc = -EAGAIN;
-		else
-			rc = rdata->server->ops->async_readv(rdata);
-	}
-
+	rc = rdata->server->ops->async_readv(rdata);
 out:
 	if (rc)
 		netfs_subreq_terminated(subreq, rc, false);
@@ -250,6 +241,7 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 		open_file = file->private_data;
 		rreq->netfs_priv = file->private_data;
 		req->cfile = cifsFileInfo_get(open_file);
+		req->server = cifs_pick_channel(tlink_tcon(req->cfile->tlink)->ses);
 	} else if (rreq->origin != NETFS_WRITEBACK) {
 		WARN_ON_ONCE(1);
 		return -EIO;


