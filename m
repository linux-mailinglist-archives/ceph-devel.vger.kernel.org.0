Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9FC4265D9
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Oct 2021 10:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhJHI0E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Oct 2021 04:26:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229850AbhJHI0C (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 Oct 2021 04:26:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633681447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=We6btKQiV7jJEDNLPwt8bgBo4mBCZ7r//ABd3tkTT5I=;
        b=Ey3EXyxkIO3amrPTLY+FcBM1C3/k7Jl6rfG/xpX547yNd10OEkNQqeDXH5MBeM1ywm6qNt
        I3plg/iRUYUDqO/gCpgSXVugaLqY/G2X2s4UQ7QLMqp2NCCcI54Gl1+9Uvzy1s40vdKwZW
        x/JO5BW5duClJGXS8GEA/5NQ4c7R/Gc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-w4xXWmqXOVGCRQkFsOIoLA-1; Fri, 08 Oct 2021 04:24:05 -0400
X-MC-Unique: w4xXWmqXOVGCRQkFsOIoLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7D63BBEE3;
        Fri,  8 Oct 2021 08:24:04 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E49CA5D9C6;
        Fri,  8 Oct 2021 08:24:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: ignore the truncate when size won't change with Fx caps ssued
Date:   Fri,  8 Oct 2021 16:23:58 +0800
Message-Id: <20211008082358.679074-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the new size is the same with current size, the MDS will do nothing
except changing the mtime/atime. The posix doesn't mandate that the
filesystems must update them. So just ignore it.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 23b5a0867e3a..81a7b342fae7 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2105,12 +2105,14 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 		loff_t isize = i_size_read(inode);
 
 		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
-		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size > isize) {
-			i_size_write(inode, attr->ia_size);
-			inode->i_blocks = calc_inode_blocks(attr->ia_size);
-			ci->i_reported_size = attr->ia_size;
-			dirtied |= CEPH_CAP_FILE_EXCL;
-			ia_valid |= ATTR_MTIME;
+		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
+			if (attr->ia_size > isize) {
+				i_size_write(inode, attr->ia_size);
+				inode->i_blocks = calc_inode_blocks(attr->ia_size);
+				ci->i_reported_size = attr->ia_size;
+				dirtied |= CEPH_CAP_FILE_EXCL;
+				ia_valid |= ATTR_MTIME;
+			}
 		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
 			   attr->ia_size != isize) {
 			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
-- 
2.27.0

