Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD26433514
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Oct 2021 13:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhJSLyB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 07:54:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230129AbhJSLyA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 07:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634644307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=X+CzlCZ5OSaUatoBhEw38DKpXXTM/NbtsS1pzjOTZuE=;
        b=EjU8k+FO7IR+VugNt2tBqLN5V0oiRbyXIHOrW7ekdqZ5sCYO4ut/upfAFr+rjVbUrki9ew
        r1IawYiNXE98H/exWSRREUbKEAhwqDh/1ar+vitMFTfdT/cQh1X4Xd4f2MZX6ekFEmTfcH
        +thqKkY5uKMaRegr11IcBnWMONnyb60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-52R4yf1FNxm4kYVxYzsLMA-1; Tue, 19 Oct 2021 07:51:44 -0400
X-MC-Unique: 52R4yf1FNxm4kYVxYzsLMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52A37802575;
        Tue, 19 Oct 2021 11:51:43 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3088260C17;
        Tue, 19 Oct 2021 11:51:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, khiremat@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: return the real size readed when hit EOF
Date:   Tue, 19 Oct 2021 19:51:38 +0800
Message-Id: <20211019115138.414187-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

At the same time set the ki_pos to the file size.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 91173d3aa161..1abc3b591740 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -847,6 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	ssize_t ret;
 	u64 off = iocb->ki_pos;
 	u64 len = iov_iter_count(to);
+	u64 i_size = i_size_read(inode);
 
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
@@ -909,7 +909,6 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 
 		ceph_osdc_put_request(req);
 
-		i_size = i_size_read(inode);
 		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
 		     off, len, ret, i_size, (more ? " MORE" : ""));
 
@@ -954,10 +953,15 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 
 	if (off > iocb->ki_pos) {
 		if (ret >= 0 &&
-		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
+		    iov_iter_count(to) > 0 &&
+		    off >= i_size_read(inode)) {
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
2.27.0

