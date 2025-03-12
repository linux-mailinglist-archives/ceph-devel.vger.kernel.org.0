Return-Path: <ceph-devel+bounces-2882-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B7EA5DAD4
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Mar 2025 11:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F2BE3A24D1
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Mar 2025 10:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF47C238D34;
	Wed, 12 Mar 2025 10:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bVHRvpYg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832951DB124
	for <ceph-devel@vger.kernel.org>; Wed, 12 Mar 2025 10:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741776441; cv=none; b=XbiUCqhEn6q8nrsYSMsE1RDmo0Ap3KHDQl23TunUmBd+k9fN1ugya1QZICeN1BPfyXC9ZVlCBcY8lV0+gJPXGxXkWhik6y7e+NC4F7o25OM38VoTFbnaSRNA9nnDDRA8NH5T8c+frRMXD9b9cc05/gSQFflmncne7ziHaJ5uoDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741776441; c=relaxed/simple;
	bh=R5rLCfIh3wkA1X4M48P9ltJ/JGLhQy59LLBsp6c/nSo=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=dF5lqP0nOQiDXrVBDQ+Pg6XT9y05bF45aLCXuPZL37voaOnHJta9MtmPCZFer9BERHEECLanNy047F4l3ZQ5lFcySCEU3SloEbMHo0Ru2/SMeSDh+Pd1ImOl4Ca61Iwc15wpbaFhH8TmHUoxUxaezYzGBf/bfhBdqAsMRZCg5j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bVHRvpYg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741776438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=C6XL4x7UtP7FT0DII+3H1l0/E12h2d8rNjwlhWXdZe0=;
	b=bVHRvpYgpMOY8X8qlQ/n+u0AxfNMc9VAbQ55dzuQ2wxcRb2j53GVwZ39bWDItT281NfjsM
	XiMzRJ9pxIYSH4yOLvBhoTDdtCKmmCGATWhhc+maR8fm175QRlZunfN1wUI+MxwsMuJE7h
	8q/7kxUvO6tgiPRTYMp6Oz2t2Z0wCbo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135--aI8Gc-YNEOsSDpQxbe5Nw-1; Wed,
 12 Mar 2025 06:47:17 -0400
X-MC-Unique: -aI8Gc-YNEOsSDpQxbe5Nw-1
X-Mimecast-MFC-AGG-ID: -aI8Gc-YNEOsSDpQxbe5Nw_1741776435
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7971C180AF55;
	Wed, 12 Mar 2025 10:47:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 116BE1801752;
	Wed, 12 Mar 2025 10:47:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
cc: dhowells@redhat.com, Alex Markuze <amarkuze@redhat.com>,
    Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
    Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: Fix incorrect flush end position calculation
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1243043.1741776431.1@warthog.procyon.org.uk>
Date: Wed, 12 Mar 2025 10:47:11 +0000
Message-ID: <1243044.1741776431@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

In ceph, in fill_fscrypt_truncate(), the end flush position is calculated
by:

                loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;

but that's using the block shift not the block size.

Fix this to use the block size instead.

Fixes: 5c64737d2536 ("ceph: add truncate size handling support for fscrypt")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Viacheslav Dubeyko <slava@dubeyko.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Xiubo Li <xiubli@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: ceph-devel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/ceph/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index ab63c7ebce5b..ec9b80fec7be 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2363,7 +2363,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 
 	/* Try to writeback the dirty pagecaches */
 	if (issued & (CEPH_CAP_FILE_BUFFER)) {
-		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;
+		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SIZE - 1;
 
 		ret = filemap_write_and_wait_range(inode->i_mapping,
 						   orig_pos, lend);


