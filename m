Return-Path: <ceph-devel+bounces-1750-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6EC95DDA5
	for <lists+ceph-devel@lfdr.de>; Sat, 24 Aug 2024 13:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8178C1C211E6
	for <lists+ceph-devel@lfdr.de>; Sat, 24 Aug 2024 11:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F071714AA;
	Sat, 24 Aug 2024 11:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CA5Ku8Vz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625631547E0
	for <ceph-devel@vger.kernel.org>; Sat, 24 Aug 2024 11:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724500628; cv=none; b=Fb7XB1zsr3vY5UIiUajjX2fvQwqApZgTZeuHFzuji2WkmBb+t7ay2rApC2jIZZ6h1dgyYx2phkpvStgLfRU3RmaNy9/SRvp9zwNBn7kNQEs3p60osvWQdT0XnbeWyLoNtpi0bdoCBjPo5HJf9E86RLCDSzXeiHHuEsWCVRSFrG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724500628; c=relaxed/simple;
	bh=IMUjvNv1A8WNE3OqnOHhUAD1EEtgyW1G59Xb24cgceQ=;
	h=From:In-Reply-To:References:Cc:Subject:MIME-Version:Content-Type:
	 Date:Message-ID; b=DTtF0Sr391OwzHG5pExt6jdXGcjmy8yLxPd8zlnwsAhKI6OM1AG7dlDIT6SF3v1483w+PbJysJTO+nM7iUJMOabxQfoXUCbTjAyLTJ/3Dph58Xbgs6F5SKvyx/tk4aJ4RXZ+kgHlCcPzqXVBs8D8hD6vPULe5lnW/wLebD5bwuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CA5Ku8Vz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724500625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7MlSZRgX4NtPTJfbL1OG/C/fCyXDm1yZsFhC7WYkkOo=;
	b=CA5Ku8Vzelh8UWL9LSgUv+MDFrR87Is44u0lTT0cJxyXidhVK+OwJJWPPD2bc7LDdJfvDK
	5EO1UsOin1XfWJNSWLJGt362NAxuJ68NExpY1lyMvb+jU8g211rvs+BjbbRveutRr6/OF5
	hjoBE/W/iM+YKmbhrMwNR9MMkVZ3vDc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-dsco4DIKOqS_7UEUarFQjQ-1; Sat,
 24 Aug 2024 07:57:03 -0400
X-MC-Unique: dsco4DIKOqS_7UEUarFQjQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A55D61955F43;
	Sat, 24 Aug 2024 11:56:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4C96919560AA;
	Sat, 24 Aug 2024 11:56:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240823200819.532106-1-dhowells@redhat.com>
References: <20240823200819.532106-1-dhowells@redhat.com>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>,
    Steve French <sfrench@samba.org>,
    Pankaj Raghav <p.raghav@samsung.com>,
    Paulo Alcantara <pc@manguebit.com>, Jeff Layton <jlayton@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH 10/9] netfs: Fix interaction of streaming writes with zero-point tracker
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <563285.1724500613.1@warthog.procyon.org.uk>
Date: Sat, 24 Aug 2024 12:56:53 +0100
Message-ID: <563286.1724500613@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

    
When a folio that is marked for streaming write (dirty, but not uptodate,
with partial content specified in the private data) is written back, the
folio is effectively switched to the blank state upon completion of the
write.  This means that if we want to read it in future, we need to reread
the whole folio.

However, if the folio is above the zero_point position, when it is read
back, it will just be cleared and the read skipped, leading to apparent
local corruption.

Fix this by increasing the zero_point to the end of the dirty data in the
folio when clearing the folio state after writeback.  This is analogous to
the folio having ->release_folio() called upon it.

This was causing the config.log generated by configuring a cpython tree on
a cifs share to get corrupted because the scripts involved were appending
text to the file in small pieces.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_collect.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 426cf87aaf2e..ae7a2043f670 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -33,6 +33,7 @@
 int netfs_folio_written_back(struct folio *folio)
 {
 	enum netfs_folio_trace why = netfs_folio_trace_clear;
+	struct netfs_inode *ictx = netfs_inode(folio->mapping->host);
 	struct netfs_folio *finfo;
 	struct netfs_group *group = NULL;
 	int gcount = 0;
@@ -41,6 +42,12 @@ int netfs_folio_written_back(struct folio *folio)
 		/* Streaming writes cannot be redirtied whilst under writeback,
 		 * so discard the streaming record.
 		 */
+		unsigned long long fend;
+
+		fend = folio_pos(folio) + finfo->dirty_offset + finfo->dirty_len;
+		if (fend > ictx->zero_point)
+			ictx->zero_point = fend;
+
 		folio_detach_private(folio);
 		group = finfo->netfs_group;
 		gcount++;


