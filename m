Return-Path: <ceph-devel+bounces-2922-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E392EA605EC
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 00:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 752B63B617C
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 23:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83AD61FCD1B;
	Thu, 13 Mar 2025 23:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VqLnLSat"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F071FDA6D
	for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 23:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741908948; cv=none; b=rzYPFbNhmu7hTCaTNeRIM17oK0lfJK1HfgUZCnXoHhYqJv6k+v5BaHHfnPkkQ9gtmBQSqQa21YuQSTK4YV30arsm87JG0HZsNnNpDHyMWCN//h7oqk8OmFyqMfCw+KAUkU5tJDQPHuu7eFNb3ALsDGrhauqFjX9gJg52A5W65tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741908948; c=relaxed/simple;
	bh=uny3v++/iPmenzGDz3NHnhj0MBwuYiajQoqDAzVy0pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpctnI+A/8jrdV1JV/vIekUvZbRK4JVPcKCga2kLc4mTQRZtz/vtOTrEYSxjgsSjDJK33HVci5O2X7cYrqdatGFkpnpm4J62zf+o+5jNUTOHaa/ZYxr4j3Ct2LuoVli2bE2/Y0mxqekdb0rJ1mosK/hKbCYe9tsCTquNryk2cyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VqLnLSat; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741908945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cCZDwnJsjHU0vEGdI7THy8y1XEAMyhcYhOuUJ0O6NiA=;
	b=VqLnLSat0U+8a3BkmpYaBXmj7/dY3GzJtREFfoK8wYzwXXIVPBr8+8CEKA5gCO6tYYuZWN
	O8zrh5tGJaMtDcnVA9a6evDLbxU/1l+/0YVDwE3B9zipCenZgUmBQf4+7uikyw4oOr+oqZ
	vk58/wQ1+Y2wwe3qfUxM/h2j2T3GQbo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-EjBfogNUNre6JggkmeyI-w-1; Thu,
 13 Mar 2025 19:35:42 -0400
X-MC-Unique: EjBfogNUNre6JggkmeyI-w-1
X-Mimecast-MFC-AGG-ID: EjBfogNUNre6JggkmeyI-w_1741908941
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35D461955E90;
	Thu, 13 Mar 2025 23:35:41 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.61])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DFE501955BCB;
	Thu, 13 Mar 2025 23:35:38 +0000 (UTC)
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
Subject: [RFC PATCH 30/35] netfs: Make netfs_page_mkwrite() use folio_mkwrite_check_truncate()
Date: Thu, 13 Mar 2025 23:33:22 +0000
Message-ID: <20250313233341.1675324-31-dhowells@redhat.com>
In-Reply-To: <20250313233341.1675324-1-dhowells@redhat.com>
References: <20250313233341.1675324-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Make netfs_page_mkwrite() use folio_mkwrite_check_truncate() rather than
doing the checks itself (and it doesn't currently do all the checks).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Viacheslav Dubeyko <slava@dubeyko.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: ceph-devel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 12ddbe9bc78b..64a0f0620399 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -506,7 +506,7 @@ vm_fault_t netfs_page_mkwrite(struct vm_fault *vmf, struct netfs_group *netfs_gr
 
 	if (folio_lock_killable(folio) < 0)
 		goto out;
-	if (folio->mapping != mapping)
+	if (folio_mkwrite_check_truncate(folio, inode) < 0)
 		goto unlock;
 	if (folio_wait_writeback_killable(folio) < 0)
 		goto unlock;


