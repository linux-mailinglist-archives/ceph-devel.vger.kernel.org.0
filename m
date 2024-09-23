Return-Path: <ceph-devel+bounces-1818-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E51A97EDA0
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Sep 2024 17:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BED0C1C21294
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Sep 2024 15:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E7D199FC6;
	Mon, 23 Sep 2024 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZMQNx6dw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B5E199FD3
	for <ceph-devel@vger.kernel.org>; Mon, 23 Sep 2024 15:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727104106; cv=none; b=s5hO3ICwtQpDmDHDN9CLWrBflinPX5pzbq1GEMh1IOcr/UbALW7yQYAhwC/vmBKMa6ZWE68POXqjKCHSYEC2HJ16EE+vpHltXGW221LwFlUIT0zki5s2wpwBSSfnkRF3lkIk8LbpW95R8YcabcW7i0o3JvcVq1/bwh8CWpnlMkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727104106; c=relaxed/simple;
	bh=sELOFazXkw60MBAdUmT5pDhOXyWrixKsDme59VZt+T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+2oZQ5fBQec1wC3FAIEl8UyLXFy2ajcdkRDkGwhTEfgxr10tGJZEfEU4xYFFyJroFJs0OHxjxwQ7L4xx+nMJRJ2+mmSHYz7SD7dXvQjYyxC6VcYSujKaSHXqSzFh9pp6mHZH1tVFpSypy7eYdpM30mzS8CVYWHcAB60pLaPvXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZMQNx6dw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727104103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UHKFm+zddtgJAu8raP8xj5T/wroKl8vpea/DCvZ5VL0=;
	b=ZMQNx6dwnvZ0pg3Jbs2f+fC0ZN586l1NuguxMXAwgLPlGNjUWTPpZOqehF4mNBOLkrXsBw
	3cP9JmF7z2z92NLDS2PkVsKxQG7Leev5WFVegyGAHgoMWC7J5Uite8O7QartgQaXrm7/nq
	9H5Sxx5adew40ZVaZS1dZQvhi6EvZMo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-YwYfIXcXPKSEJj725uT1xQ-1; Mon,
 23 Sep 2024 11:08:20 -0400
X-MC-Unique: YwYfIXcXPKSEJj725uT1xQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59BFD18E6A7E;
	Mon, 23 Sep 2024 15:08:18 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9EE911954190;
	Mon, 23 Sep 2024 15:08:06 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <sfrench@samba.org>,
	Marc Dionne <marc.dionne@auristor.com>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
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
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH 1/8] netfs: Fix mtime/ctime update for mmapped writes
Date: Mon, 23 Sep 2024 16:07:45 +0100
Message-ID: <20240923150756.902363-2-dhowells@redhat.com>
In-Reply-To: <20240923150756.902363-1-dhowells@redhat.com>
References: <20240923150756.902363-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The cifs flag CIFS_INO_MODIFIED_ATTR, which indicates that the mtime and
ctime need to be written back on close, got taken over by netfs as
NETFS_ICTX_MODIFIED_ATTR to avoid the need to call a function pointer to
set it.

The flag gets set correctly on buffered writes, but doesn't get set by
netfs_page_mkwrite(), leading to occasional failures in generic/080 and
generic/215.

Fix this by setting the flag in netfs_page_mkwrite().

Fixes: 73425800ac94 ("netfs, cifs: Move CIFS_INO_MODIFIED_ATTR to netfs_inode")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202409161629.98887b2-oliver.sang@intel.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index d7eae597e54d..b3910dfcb56d 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -552,6 +552,7 @@ vm_fault_t netfs_page_mkwrite(struct vm_fault *vmf, struct netfs_group *netfs_gr
 		trace_netfs_folio(folio, netfs_folio_trace_mkwrite);
 	netfs_set_group(folio, netfs_group);
 	file_update_time(file);
+	set_bit(NETFS_ICTX_MODIFIED_ATTR, &ictx->flags);
 	if (ictx->ops->post_modify)
 		ictx->ops->post_modify(inode);
 	ret = VM_FAULT_LOCKED;


