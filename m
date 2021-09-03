Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC1B3FFBA9
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Sep 2021 10:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348197AbhICIRn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Sep 2021 04:17:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348151AbhICIRm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Sep 2021 04:17:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630657002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OAj2fSxYa9n0coRhPoLlePT7tDyl38FaP99dGA1xFYw=;
        b=eJrtL3D3WcsEDoW54YepBRrU8pLs0a/t7eD06Ue/xx19zxGXOGGDWjLUrY/3F8wh5VEBXH
        d3Z+vz8Lqpb8lDi9onZyzSDl42NnqMCIBZu9QJm/2bCdJ0yUCkZkMZgc5maevUmO/Si4wX
        sQO4thkht1vIssV4N+pQtPcLOyG57Z8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-R0sfm3oCPC60fSBlTqthTw-1; Fri, 03 Sep 2021 04:16:41 -0400
X-MC-Unique: R0sfm3oCPC60fSBlTqthTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D174B801AFC;
        Fri,  3 Sep 2021 08:16:39 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF85C6A8F8;
        Fri,  3 Sep 2021 08:16:37 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH RFC 1/2] Revert "ceph: make client zero partial trailing block on truncate"
Date:   Fri,  3 Sep 2021 16:15:09 +0800
Message-Id: <20210903081510.982827-2-xiubli@redhat.com>
In-Reply-To: <20210903081510.982827-1-xiubli@redhat.com>
References: <20210903081510.982827-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This reverts commit c97968122078ce0380cd8db405b8505a8b0a55d8.
---
 fs/ceph/file.c  |  3 ++-
 fs/ceph/inode.c | 23 ++---------------------
 fs/ceph/super.h |  1 -
 3 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3db7a3df4041..6e677b40410e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2247,7 +2247,8 @@ static void ceph_zero_pagecache_range(struct inode *inode, loff_t offset,
 		ceph_zero_partial_page(inode, offset, length);
 }
 
-int ceph_zero_partial_object(struct inode *inode, loff_t offset, loff_t *length)
+static int ceph_zero_partial_object(struct inode *inode,
+				    loff_t offset, loff_t *length)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 03530793c969..1a4c9bc485fc 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2391,6 +2391,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 					cpu_to_le64(round_up(isize,
 							     CEPH_FSCRYPT_BLOCK_SIZE));
 				req->r_fscrypt_file = attr->ia_size;
+				/* FIXME: client must zero out any partial blocks! */
 			} else {
 				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
 				req->r_args.setattr.old_size = cpu_to_le64(isize);
@@ -2479,28 +2480,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 	ceph_mdsc_put_request(req);
 	ceph_free_cap_flush(prealloc_cf);
 
-	if (err >= 0 && (mask & (CEPH_SETATTR_SIZE|CEPH_SETATTR_FSCRYPT_FILE))) {
+	if (err >= 0 && (mask & CEPH_SETATTR_SIZE))
 		__ceph_do_pending_vmtruncate(inode);
-		if (mask & CEPH_SETATTR_FSCRYPT_FILE) {
-			loff_t orig_len, len;
-
-			len = round_up(attr->ia_size, CEPH_FSCRYPT_BLOCK_SIZE) - attr->ia_size;
-			orig_len = len;
-
-			/*
-			 * FIXME: this is just doing the truncating the last OSD
-			 * 	  object, but for "real" fscrypt support, we need
-			 * 	  to do a RMW with the end of the block zeroed out.
-			 */
-			if (len) {
-				err = ceph_zero_partial_object(inode, attr->ia_size, &len);
-				/* This had better not be shortened */
-				WARN_ONCE(!err && len != orig_len,
-					  "attr->ia_size=%lld orig_len=%lld len=%lld\n",
-					  attr->ia_size, orig_len, len);
-			}
-		}
-	}
 
 	return err;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 6d4a22c6d32d..7f3976b3319d 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1236,7 +1236,6 @@ extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 extern int ceph_release(struct inode *inode, struct file *filp);
 extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 				  char *data, size_t len);
-int ceph_zero_partial_object(struct inode *inode, loff_t offset, loff_t *length);
 
 /* dir.c */
 extern const struct file_operations ceph_dir_fops;
-- 
2.27.0

