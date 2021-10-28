Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552B643DD8C
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 11:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhJ1JRc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 05:17:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230102AbhJ1JRb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 05:17:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635412504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQ2h7nXpi5Kisi/xMnS+FVduPYQWKZ4RWQWaNH0w2Fo=;
        b=YbUX/yv8yyHOnWQgeDsbemCGLHbNccjANxuW/PP1BibzC2d6m88IPa5cdZgfnKaPWQgUnZ
        zgbQHj6P7NE8EvN0NZCXjDODEzD5DevNpqLfzpLpoNH0cdbP7kuQjyNZBN2CaZ1CQ1XdI+
        Tg1q04cP8ZOEUmir4LgwjqEbqRFep88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-yRdfErhzNPibeyqU6NMUYA-1; Thu, 28 Oct 2021 05:15:01 -0400
X-MC-Unique: yRdfErhzNPibeyqU6NMUYA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DFBB101F000;
        Thu, 28 Oct 2021 09:15:00 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7C0C54469;
        Thu, 28 Oct 2021 09:14:56 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 3/4] ceph: return the real size readed when hit EOF
Date:   Thu, 28 Oct 2021 17:14:37 +0800
Message-Id: <20211028091438.21402-4-xiubli@redhat.com>
In-Reply-To: <20211028091438.21402-1-xiubli@redhat.com>
References: <20211028091438.21402-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

