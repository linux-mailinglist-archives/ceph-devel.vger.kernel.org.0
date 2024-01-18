Return-Path: <ceph-devel+bounces-580-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1EC383143D
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 09:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 007021C22C2A
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 08:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B941400F;
	Thu, 18 Jan 2024 08:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jqjfx83+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9311F5FF
	for <ceph-devel@vger.kernel.org>; Thu, 18 Jan 2024 08:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705565193; cv=none; b=eGfKg9Ont6e1TXAW4HDVCejiBklGqUMMvQEV18mSr7n/iBnRcS9cPK+54AnCheUL2ps7zXn3EKtw+faY2qIiaF41vV9rjalDFZpDNGriLfXIuK+s66JyJ47pN67e95jE+kOz2CPYtuJi7Sa9CeQU3PCjwwPMUykAs0p03oQbTRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705565193; c=relaxed/simple;
	bh=xy6VirEvg0XpSVlD70yHNm9piBmso2R+c/1Wd9K93ag=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:
	 X-Scanned-By; b=fg5vMlhuaAIYVF4PdQvA4nGw3RxkekwPd7NjCbTu2/aZG8/Ae1VnMho5LCiu7NpAbGfFpa9C5Vc8KSL/17HD8d3nBr6FXe4chciizGK2eUR+vV60a3l5p39FuzZWXqw5r0vX/rXfRLvEEi1oUw/CTU/uUeaWEea6F4BFpBqdusk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jqjfx83+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705565190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YYqIwoWpCA2EIg2F082JPBtakZctdOQFEjoG5GW5JKE=;
	b=Jqjfx83+VoqWDj4HTXKDIIHsp/sGqmgeWneqHfxYAraFKi/ShTpV9Vo790feyu8vIrEgUu
	J9fROhQ0zaNHBj9Y9720uR0kbDSuqiSFIdnu1EOEv/R5ge+sCZqKQ7DsKqUWYaMFb0p6Hs
	2HoG3N0CI9p06Tr2pt+Rc99mthdHy+w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-pvbggrkgNMaUcJ6I4lFL-A-1; Thu, 18 Jan 2024 03:06:24 -0500
X-MC-Unique: pvbggrkgNMaUcJ6I4lFL-A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9987F84ACA6;
	Thu, 18 Jan 2024 08:06:24 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD7EE492BC6;
	Thu, 18 Jan 2024 08:06:21 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: always set the initial i_blkbits to CEPH_FSCRYPT_BLOCK_SHIFT
Date: Thu, 18 Jan 2024 16:04:04 +0800
Message-ID: <20240118080404.783677-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Xiubo Li <xiubli@redhat.com>

The fscrypt code will use i_blkbits to setup the 'ci_data_unit_bits'
when allocating the new inode, but ceph will initiate i_blkbits
ater when filling the inode, which is too late. Since the
'ci_data_unit_bits' will only be used by the fscrypt framework so
initiating i_blkbits with CEPH_FSCRYPT_BLOCK_SHIFT is safe.

Fixes: commit 5b1188847180 ("fscrypt: support crypto data unit size
       less than filesystem block size")
URL: https://tracker.ceph.com/issues/64035
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 62af452cdba4..d96d97b31f68 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -79,6 +79,8 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
+	inode->i_blkbits = CEPH_FSCRYPT_BLOCK_SHIFT;
+
 	if (!S_ISLNK(*mode)) {
 		err = ceph_pre_init_acls(dir, mode, as_ctx);
 		if (err < 0)
-- 
2.39.1


