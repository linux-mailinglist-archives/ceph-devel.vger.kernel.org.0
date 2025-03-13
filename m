Return-Path: <ceph-devel+bounces-2893-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A1F37A60562
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 00:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76F177ABA8A
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 23:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E90E1FBC8A;
	Thu, 13 Mar 2025 23:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EaO2SAut"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2261FA851
	for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 23:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741908844; cv=none; b=OXEjx5kh3VSZrWCs7qJEqINPVvXkGJaYcv9QdDkFuYRIt3Pf4mclJZ1+7aN+oKEUb3TPnBJdKai0VVmRX2P4r4EuNlOd2mBBWQb3BXNiWZ3hegpc9mx31uOkfq8OHmHSepwp4EcsUnjVu6kmdsDNmt9z/8odEIKMALnnkEFGBbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741908844; c=relaxed/simple;
	bh=lwORvviNhSF8SgSU7winhQCg+6QYL87hKWXdsGcTc4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO6Fh0quxu0gMGhcWF49NoIAEyg6Fsy1dDkR13auG+rUC4/+aQuGJnLksGHYjKQeWc2P0oeaJN7wN/7FZvohkjjnzIfVed9Hk2FM1ZfR18mRjTMZvChOTaHgdSCVA+rfIMTvbUx8lO4Eih1BJFelsuBGVRp/3NyT8/Xy9jLiHts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EaO2SAut; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741908841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fi0cYhXmllmGlxSznwGExnwwbD78Vn5+i2/pgWu6QI4=;
	b=EaO2SAutB6d4fsOMMRLE0nM5GRPE3+dF7VejRlUVYE0Oq3Dz40IE4AnxsFUSzu/ExgSvZW
	0GJ0WAtWA0Ln3d7KDB5IbThzCLuZLGfFskoHftrYr4RAg0Cs0faApPkxmKz2LL/ZVtjiMb
	At7/lj60fPU6NyIvzQQhicvB4hFYIUU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-5yCKPd0pMzSflmKtr2Ob_Q-1; Thu,
 13 Mar 2025 19:33:56 -0400
X-MC-Unique: 5yCKPd0pMzSflmKtr2Ob_Q-1
X-Mimecast-MFC-AGG-ID: 5yCKPd0pMzSflmKtr2Ob_Q_1741908834
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF20919560B7;
	Thu, 13 Mar 2025 23:33:54 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5B3F81955F2D;
	Thu, 13 Mar 2025 23:33:51 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH 01/35] ceph: Fix incorrect flush end position calculation
Date: Thu, 13 Mar 2025 23:32:53 +0000
Message-ID: <20250313233341.1675324-2-dhowells@redhat.com>
In-Reply-To: <20250313233341.1675324-1-dhowells@redhat.com>
References: <20250313233341.1675324-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index c15970fa240f..b060f765ad20 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2364,7 +2364,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 
 	/* Try to writeback the dirty pagecaches */
 	if (issued & (CEPH_CAP_FILE_BUFFER)) {
-		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;
+		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SIZE - 1;
 
 		ret = filemap_write_and_wait_range(inode->i_mapping,
 						   orig_pos, lend);


