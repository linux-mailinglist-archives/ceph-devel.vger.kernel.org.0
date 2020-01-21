Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B4C144521
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Jan 2020 20:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgAUT3c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Jan 2020 14:29:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgAUT3c (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 14:29:32 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43EEE24655;
        Tue, 21 Jan 2020 19:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579634971;
        bh=zBUxbbWNjkr33vhkE5+2CQO8fqG7XgGumLlVydPRUBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNesf8by8OrWXGPHi4jrjdGehi53BnW6ecpHgeoh7xHbNP2r7VJSqAe5xOEKAPbDa
         5npUmlIMkPzHeqrXYenRe8Kvfj5l9iZnLXtzIpGsWog8OhpOJ+k5R44V6b3XowY03v
         Y8RyYYa1TngRBiAorCp7G7ejH8s+gkmrsgxamO8A=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idridryomov@gmail.com, sage@redhat.com, zyan@redhat.com
Subject: [RFC PATCH v3 01/10] ceph: move net/ceph/ceph_fs.c to fs/ceph/util.c
Date:   Tue, 21 Jan 2020 14:29:19 -0500
Message-Id: <20200121192928.469316-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200121192928.469316-1-jlayton@kernel.org>
References: <20200121192928.469316-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

All of these functions are only called from CephFS, so move them into
ceph.ko, and drop the exports.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/Makefile                     | 2 +-
 net/ceph/ceph_fs.c => fs/ceph/util.c | 4 ----
 net/ceph/Makefile                    | 2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)
 rename net/ceph/ceph_fs.c => fs/ceph/util.c (94%)

diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index c1da294418d1..0a0823d378db 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_CEPH_FS) += ceph.o
 ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
 	export.o caps.o snap.o xattr.o quota.o io.o \
 	mds_client.o mdsmap.o strings.o ceph_frag.o \
-	debugfs.o
+	debugfs.o util.o
 
 ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
 ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
diff --git a/net/ceph/ceph_fs.c b/fs/ceph/util.c
similarity index 94%
rename from net/ceph/ceph_fs.c
rename to fs/ceph/util.c
index 756a2dc10d27..2c34875675bf 100644
--- a/net/ceph/ceph_fs.c
+++ b/fs/ceph/util.c
@@ -39,7 +39,6 @@ void ceph_file_layout_from_legacy(struct ceph_file_layout *fl,
 	    fl->stripe_count == 0 && fl->object_size == 0)
 		fl->pool_id = -1;
 }
-EXPORT_SYMBOL(ceph_file_layout_from_legacy);
 
 void ceph_file_layout_to_legacy(struct ceph_file_layout *fl,
 				struct ceph_file_layout_legacy *legacy)
@@ -52,7 +51,6 @@ void ceph_file_layout_to_legacy(struct ceph_file_layout *fl,
 	else
 		legacy->fl_pg_pool = 0;
 }
-EXPORT_SYMBOL(ceph_file_layout_to_legacy);
 
 int ceph_flags_to_mode(int flags)
 {
@@ -82,7 +80,6 @@ int ceph_flags_to_mode(int flags)
 
 	return mode;
 }
-EXPORT_SYMBOL(ceph_flags_to_mode);
 
 int ceph_caps_for_mode(int mode)
 {
@@ -101,4 +98,3 @@ int ceph_caps_for_mode(int mode)
 
 	return caps;
 }
-EXPORT_SYMBOL(ceph_caps_for_mode);
diff --git a/net/ceph/Makefile b/net/ceph/Makefile
index 59d0ba2072de..ce09bb4fb249 100644
--- a/net/ceph/Makefile
+++ b/net/ceph/Makefile
@@ -13,5 +13,5 @@ libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
 	auth.o auth_none.o \
 	crypto.o armor.o \
 	auth_x.o \
-	ceph_fs.o ceph_strings.o ceph_hash.o \
+	ceph_strings.o ceph_hash.o \
 	pagevec.o snapshot.o string_table.o
-- 
2.24.1

