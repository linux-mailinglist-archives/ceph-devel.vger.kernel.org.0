Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894BF40F978
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Sep 2021 15:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbhIQNp0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Sep 2021 09:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237066AbhIQNpS (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 09:45:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB746113A;
        Fri, 17 Sep 2021 13:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631886235;
        bh=r84/4Qqcyx2CGi4Po9PErklSx5W2dDF1re2ExnMeUmw=;
        h=From:To:Cc:Subject:Date:From;
        b=AT7+ask0ffoxH8wD5gPogUh+gI+PEUO3USeYvkei+Ze4PPgGorG2QY8FtLZtIy664
         P7heDjbieR25rP3g/hXJwCQRJZzFGaN8NSLN8pbQrj79dgcvae8OVMsayGfgeaj+ew
         v1Zs0VQTgm9x/hvZ0A+F1uFQ1mh5MgB/DcTYOXSWO3Zi3CDGZ2mqGZfQbFekjulklT
         8jGWV1UgYdmNcvCoMnysNzyn98YDGkQsIAE2uSMX9oqbcgZG/M3/civKxLOhHhzuxd
         m4drEwiGsqfeNdds2dgkDRrESnc48lu4CaYIJg18FXLWE41g9deKt/bzn8fdwhnY4T
         n080wPFGHY6Gg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, linux-cachefs@redhat.com, dhowells@redhat.com
Subject: [PATCH] ceph: just use ci->i_version for fscache aux info
Date:   Fri, 17 Sep 2021 09:43:53 -0400
Message-Id: <20210917134353.138782-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If the i_version regresses, then it's likely that the mtime will do the
same in lockstep with it. There's no need to track both here, just use
the i_version counter since it's just as good and gets the aux size down
to 64 bits.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/cache.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index 9cfadbb86568..457afda5498a 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -12,12 +12,6 @@
 #include "super.h"
 #include "cache.h"
 
-struct ceph_aux_inode {
-	u64 	version;
-	u64	mtime_sec;
-	u64	mtime_nsec;
-};
-
 struct fscache_netfs ceph_cache_netfs = {
 	.name		= "ceph",
 	.version	= 0,
@@ -109,20 +103,14 @@ static enum fscache_checkaux ceph_fscache_inode_check_aux(
 	void *cookie_netfs_data, const void *data, uint16_t dlen,
 	loff_t object_size)
 {
-	struct ceph_aux_inode aux;
 	struct ceph_inode_info* ci = cookie_netfs_data;
 	struct inode* inode = &ci->vfs_inode;
 
-	if (dlen != sizeof(aux) ||
+	if (dlen != sizeof(ci->i_version) ||
 	    i_size_read(inode) != object_size)
 		return FSCACHE_CHECKAUX_OBSOLETE;
 
-	memset(&aux, 0, sizeof(aux));
-	aux.version = ci->i_version;
-	aux.mtime_sec = inode->i_mtime.tv_sec;
-	aux.mtime_nsec = inode->i_mtime.tv_nsec;
-
-	if (memcmp(data, &aux, sizeof(aux)) != 0)
+	if (*(u64 *)data != ci->i_version)
 		return FSCACHE_CHECKAUX_OBSOLETE;
 
 	dout("ceph inode 0x%p cached okay\n", ci);
@@ -139,7 +127,6 @@ void ceph_fscache_register_inode_cookie(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_aux_inode aux;
 
 	/* No caching for filesystem */
 	if (!fsc->fscache)
@@ -151,14 +138,10 @@ void ceph_fscache_register_inode_cookie(struct inode *inode)
 
 	inode_lock_nested(inode, I_MUTEX_CHILD);
 	if (!ci->fscache) {
-		memset(&aux, 0, sizeof(aux));
-		aux.version = ci->i_version;
-		aux.mtime_sec = inode->i_mtime.tv_sec;
-		aux.mtime_nsec = inode->i_mtime.tv_nsec;
 		ci->fscache = fscache_acquire_cookie(fsc->fscache,
 						     &ceph_fscache_inode_object_def,
 						     &ci->i_vino, sizeof(ci->i_vino),
-						     &aux, sizeof(aux),
+						     &ci->i_version, sizeof(ci->i_version),
 						     ci, i_size_read(inode), false);
 	}
 	inode_unlock(inode);
-- 
2.31.1

