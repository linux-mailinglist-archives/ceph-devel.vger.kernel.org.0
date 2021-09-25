Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D790418096
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Sep 2021 10:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhIYIxg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 25 Sep 2021 04:53:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231625AbhIYIxf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 04:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632559919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g8w/JREduhwblmgMfyq9HhOz2uzDaP4nJ+4XwSeDl/Y=;
        b=ERFIlmraAGsv/vhs2+GjNAT5fND9Y4U4me2uaXDnWzmTsZSOqB/IJ3MTGlhJY/Y6BkcCys
        aVS90TFdWQAo7gH08dgGIrdi0Ps8y4zR7hFg0EPWN4A5VDjzU+gSL7j5RaZAKXSqW6a62p
        MzSEdrYuTXN54w6jqB6NYHAuUHsta28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-zPkEbAQEN8CrWQgTpdPa-A-1; Sat, 25 Sep 2021 04:51:58 -0400
X-MC-Unique: zPkEbAQEN8CrWQgTpdPa-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2D8D801FCD;
        Sat, 25 Sep 2021 08:51:56 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D99C4180;
        Sat, 25 Sep 2021 08:51:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: buffer the truncate when size won't change with Fx caps issued
Date:   Sat, 25 Sep 2021 16:51:49 +0800
Message-Id: <20210925085149.429710-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the new size is the same with current size, the MDS will do nothing
except changing the mtime/atime. We can just buffer the truncate in
this case.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 03530793c969..14989b961431 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2370,7 +2370,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 		loff_t isize = i_size_read(inode);
 
 		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
-		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size > isize) {
+		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
 			i_size_write(inode, attr->ia_size);
 			inode->i_blocks = calc_inode_blocks(attr->ia_size);
 			ci->i_reported_size = attr->ia_size;
-- 
2.27.0

