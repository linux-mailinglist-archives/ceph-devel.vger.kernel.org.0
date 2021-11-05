Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47B24464CB
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 15:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhKEOZo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 10:25:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233245AbhKEOZk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Nov 2021 10:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636122180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T7NfZHttcD1IvGpDYjn9D/oM20m0iGfmyo0w1VRirTQ=;
        b=W9sUGzss5O4W59vKEfWnZFF2hgigInWW5Dt77r275ERSy9PnnjlTrEJNAcgc+IvC5asxQk
        H5/hkvU+uAHJh2Q0HpG2C430Yi6+8/6bj0JrPCQpBn6bbTNy0whajOcBDeXeU72+AsMVee
        GM0aYcDAKmBzY74CdllZr8DH+EU2z0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-_ZaXb2RLNMOkUSGHUFHcwQ-1; Fri, 05 Nov 2021 10:22:57 -0400
X-MC-Unique: _ZaXb2RLNMOkUSGHUFHcwQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3C96884DD2;
        Fri,  5 Nov 2021 14:22:49 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8362E19C79;
        Fri,  5 Nov 2021 14:22:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Subject: [PATCH v7 4/9] ceph: get file size from fscrypt_file when present in inode traces
Date:   Fri,  5 Nov 2021 22:22:10 +0800
Message-Id: <20211105142215.345566-5-xiubli@redhat.com>
In-Reply-To: <20211105142215.345566-1-xiubli@redhat.com>
References: <20211105142215.345566-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 4a7b2b0d88f7..15c2fb1e2c8a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -978,6 +978,16 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		     from_kgid(&init_user_ns, inode->i_gid));
 		ceph_decode_timespec64(&ci->i_btime, &iinfo->btime);
 		ceph_decode_timespec64(&ci->i_snap_btime, &iinfo->snap_btime);
+
+#ifdef CONFIG_FS_ENCRYPTION
+		if (iinfo->fscrypt_auth_len && !ci->fscrypt_auth) {
+			ci->fscrypt_auth_len = iinfo->fscrypt_auth_len;
+			ci->fscrypt_auth = iinfo->fscrypt_auth;
+			iinfo->fscrypt_auth = NULL;
+			iinfo->fscrypt_auth_len = 0;
+			inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
+		}
+#endif
 	}
 
 	if ((new_version || (new_issued & CEPH_CAP_LINK_SHARED)) &&
@@ -1001,6 +1011,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 	if (new_version ||
 	    (new_issued & (CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
+		u64 size = info->size;
 		s64 old_pool = ci->i_layout.pool_id;
 		struct ceph_string *old_ns;
 
@@ -1014,10 +1025,17 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 		pool_ns = old_ns;
 
+		if (IS_ENCRYPTED(inode) && size &&
+		    (iinfo->fscrypt_file_len == sizeof(__le64))) {
+			size = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
+			if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
+				pr_warn("size=%llu fscrypt_file=%llu\n", info->size, size);
+		}
+
 		queue_trunc = ceph_fill_file_size(inode, issued,
 					le32_to_cpu(info->truncate_seq),
 					le64_to_cpu(info->truncate_size),
-					le64_to_cpu(info->size));
+					le64_to_cpu(size));
 		/* only update max_size on auth cap */
 		if ((info->cap.flags & CEPH_CAP_FLAG_AUTH) &&
 		    ci->i_max_size != le64_to_cpu(info->max_size)) {
@@ -1057,16 +1075,6 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		xattr_blob = NULL;
 	}
 
-#ifdef CONFIG_FS_ENCRYPTION
-	if (iinfo->fscrypt_auth_len && !ci->fscrypt_auth) {
-		ci->fscrypt_auth_len = iinfo->fscrypt_auth_len;
-		ci->fscrypt_auth = iinfo->fscrypt_auth;
-		iinfo->fscrypt_auth = NULL;
-		iinfo->fscrypt_auth_len = 0;
-		inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
-	}
-#endif
-
 	/* finally update i_version */
 	if (le64_to_cpu(info->version) > ci->i_version)
 		ci->i_version = le64_to_cpu(info->version);
-- 
2.27.0

