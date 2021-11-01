Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AF444120A
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Nov 2021 03:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhKACHe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 31 Oct 2021 22:07:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230191AbhKACHb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 31 Oct 2021 22:07:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635732298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lkCExoYHKmmP8kyQttX6GO+S2QrPi5ovhrz89ZkqFPE=;
        b=MeQs/R/L1zssAzYNzvm8Sr9/skOpKgDTjqPtI5i54zeouyjOoJPDsh9IALooM99OlP8rGZ
        DWJ8lGtylastDTPQw892xtjN2+xi9nkQ7cfSD1B4EUV6KjcoXFs36gaLgm3ezJ43FNqmIO
        fnshkQUmnFW+WczDnBtoQu4jDvLN8A4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-KkZnt5_vP1eu1QdyHesKAA-1; Sun, 31 Oct 2021 22:04:56 -0400
X-MC-Unique: KkZnt5_vP1eu1QdyHesKAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8430E1023F4D;
        Mon,  1 Nov 2021 02:04:55 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 282B55D6CF;
        Mon,  1 Nov 2021 02:04:52 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 1/4] Revert "ceph: make client zero partial trailing block on truncate"
Date:   Mon,  1 Nov 2021 10:04:44 +0800
Message-Id: <20211101020447.75872-2-xiubli@redhat.com>
In-Reply-To: <20211101020447.75872-1-xiubli@redhat.com>
References: <20211101020447.75872-1-xiubli@redhat.com>
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
index ee13512b610d..af58be73ce1c 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2250,7 +2250,8 @@ static void ceph_zero_pagecache_range(struct inode *inode, loff_t offset,
 		ceph_zero_partial_page(inode, offset, length);
 }
 
-int ceph_zero_partial_object(struct inode *inode, loff_t offset, loff_t *length)
+static int ceph_zero_partial_object(struct inode *inode,
+				    loff_t offset, loff_t *length)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 5d47b98b61af..9b798690fdc9 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2393,6 +2393,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 					cpu_to_le64(round_up(isize,
 							     CEPH_FSCRYPT_BLOCK_SIZE));
 				req->r_fscrypt_file = attr->ia_size;
+				/* FIXME: client must zero out any partial blocks! */
 			} else {
 				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
 				req->r_args.setattr.old_size = cpu_to_le64(isize);
@@ -2481,28 +2482,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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

