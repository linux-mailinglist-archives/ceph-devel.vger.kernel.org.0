Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F44A440796
	for <lists+ceph-devel@lfdr.de>; Sat, 30 Oct 2021 07:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhJ3FTX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 Oct 2021 01:19:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230012AbhJ3FTX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 01:19:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635571013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ASwHpuQ16OQ6RELzIYnYzsGGTf5jREOSI0esfj97kX4=;
        b=feE203WLJ9UhD/XnsxGlt0xHw231Mknht/6vTJSp4k+vl2TNNLYdF3rf8NWe3UBs4huOVn
        NVmYDXYXdmaJ4f7WU/GABNvqcgOAIigMT1sDr/rpg55/S++Tq+0GhaGhQB3lvUScTJ4cYs
        CSW3XHJfrbixg5QAFl14DaF3/c1q67U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-iucQoGRcNZaqajb43G7_jA-1; Sat, 30 Oct 2021 01:16:50 -0400
X-MC-Unique: iucQoGRcNZaqajb43G7_jA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA36A104ECE6;
        Sat, 30 Oct 2021 05:16:49 +0000 (UTC)
Received: from fedora.redhat.com (ovpn-12-190.pek2.redhat.com [10.72.12.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F19995C1C5;
        Sat, 30 Oct 2021 05:16:43 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4] ceph: return the real size read when we it hits EOF
Date:   Sat, 30 Oct 2021 13:16:40 +0800
Message-Id: <20211030051640.2402573-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Currently, if we end up reading more from the last object in the file
than the i_size indicates then we'll end up returning the wrong length.
Ensure that we cap the returned length and pos at the EOF.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V4:
- move the i_size_read() into the while loop and use the lastest i_size
  read to do the check at the end of ceph_sync_read().


 fs/ceph/file.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 91173d3aa161..6005b430f6f7 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -847,6 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	ssize_t ret;
 	u64 off = iocb->ki_pos;
 	u64 len = iov_iter_count(to);
+	u64 i_size;
 
 	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
 	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
@@ -870,7 +871,6 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		struct page **pages;
 		int num_pages;
 		size_t page_off;
-		u64 i_size;
 		bool more;
 		int idx;
 		size_t left;
@@ -953,11 +953,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	}
 
 	if (off > iocb->ki_pos) {
-		if (ret >= 0 &&
-		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
+		if (off >= i_size) {
 			*retry_op = CHECK_EOF;
-		ret = off - iocb->ki_pos;
-		iocb->ki_pos = off;
+			ret = i_size - iocb->ki_pos;
+			iocb->ki_pos = i_size;
+		} else {
+			ret = off - iocb->ki_pos;
+			iocb->ki_pos = off;
+		}
 	}
 
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
-- 
2.31.1

