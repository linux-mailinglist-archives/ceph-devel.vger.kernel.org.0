Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E765B434C11
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 15:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhJTNa5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 09:30:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230168AbhJTNa5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 09:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634736522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQ2h7nXpi5Kisi/xMnS+FVduPYQWKZ4RWQWaNH0w2Fo=;
        b=SH21en8Yu1tPqG+XiPOqUvqwkGurL2Pe8Bjquisn7/zm7o6qnBTsEv3/Nf8qMOW13m6zfg
        lnKQa+X93B2cJZGFYmnkUoHMw5zqmoUJBKt04ldoHCkEcRfQTRJPLOsrIPQ7/QyuRoMPKj
        OsAeoIcDRe7taJcDYDPcJloeJzuxaQU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-cm119SwxP9eHjj9jJT8MaQ-1; Wed, 20 Oct 2021 09:28:38 -0400
X-MC-Unique: cm119SwxP9eHjj9jJT8MaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 099D510144F0;
        Wed, 20 Oct 2021 13:28:37 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CE7B1042AEE;
        Wed, 20 Oct 2021 13:28:34 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 3/4] ceph: return the real size readed when hit EOF
Date:   Wed, 20 Oct 2021 21:28:12 +0800
Message-Id: <20211020132813.543695-4-xiubli@redhat.com>
In-Reply-To: <20211020132813.543695-1-xiubli@redhat.com>
References: <20211020132813.543695-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 74db403a4c35..1988e75ad4a2 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -910,6 +910,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	ssize_t ret;
 	u64 off = *ki_pos;
 	u64 len = iov_iter_count(to);
+	u64 i_size = i_size_read(inode);
 
 	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
 
@@ -933,7 +934,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		struct page **pages;
 		int num_pages;
 		size_t page_off;
-		u64 i_size;
 		bool more;
 		int idx;
 		size_t left;
@@ -980,7 +980,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 
 		ceph_osdc_put_request(req);
 
-		i_size = i_size_read(inode);
 		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
 		     off, len, ret, i_size, (more ? " MORE" : ""));
 
@@ -1056,11 +1055,14 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	}
 
 	if (off > *ki_pos) {
-		if (ret >= 0 &&
-		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
+		if (off >= i_size) {
 			*retry_op = CHECK_EOF;
-		ret = off - *ki_pos;
-		*ki_pos = off;
+			ret = i_size - *ki_pos;
+			*ki_pos = i_size;
+		} else {
+			ret = off - *ki_pos;
+			*ki_pos = off;
+		}
 	}
 out:
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
-- 
2.27.0

