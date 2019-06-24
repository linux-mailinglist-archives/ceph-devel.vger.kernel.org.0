Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC70518A2
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 18:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732117AbfFXQ1b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jun 2019 12:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfFXQ1a (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 12:27:30 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0EFD20673;
        Mon, 24 Jun 2019 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561393649;
        bh=4IC/1e26jtX/gURgXwlb4EJuiJBLoMs7MoQNxnxvtRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQJF88TVtcTAe0GUFChy3C7pLNXcJ+HZTXNihPj63+DORncvfzmG8qPR4V7Ub86bv
         PyWgYa1LbQZQ454W1E7L5zGuIa0PHVwnFti8cmM6R3Oku/oSGLBss/L2r+b8kludFn
         7gCDM4bx+M3hlPruSd57VWDgj+Qk/PvCcbr3zElA=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, sage@redhat.com,
        agruenba@redhat.com
Subject: [PATCH v4 1/3] ceph: make getxattr_cb return ssize_t
Date:   Mon, 24 Jun 2019 12:27:24 -0400
Message-Id: <20190624162726.17413-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190624162726.17413-1-jlayton@kernel.org>
References: <20190624162726.17413-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The getxattr_cb functions return size_t, which is unsigned and then
cast that value to int and then ssize_t before returning it. While all
of this works, it relies on implicit casting rules for signed/unsigned
conversions.

Change getxattr_cb to return ssize_t to better conform with what the
caller actually wants. Also, remove some suspicious casts.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 90 ++++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 6621d27e64f5..e90e19e9660b 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -32,8 +32,8 @@ static bool ceph_is_valid_xattr(const char *name)
 struct ceph_vxattr {
 	char *name;
 	size_t name_size;	/* strlen(name) + 1 (for '\0') */
-	size_t (*getxattr_cb)(struct ceph_inode_info *ci, char *val,
-			      size_t size);
+	ssize_t (*getxattr_cb)(struct ceph_inode_info *ci, char *val,
+			       size_t size);
 	bool (*exists_cb)(struct ceph_inode_info *ci);
 	unsigned int flags;
 };
@@ -52,8 +52,8 @@ static bool ceph_vxattrcb_layout_exists(struct ceph_inode_info *ci)
 		rcu_dereference_raw(fl->pool_ns) != NULL);
 }
 
-static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
-				   size_t size)
+static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
+				    size_t size)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
 	struct ceph_osd_client *osdc = &fsc->client->osdc;
@@ -80,7 +80,7 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 		len = snprintf(buf, sizeof(buf),
 		"stripe_unit=%u stripe_count=%u object_size=%u pool=%lld",
 		ci->i_layout.stripe_unit, ci->i_layout.stripe_count,
-	        ci->i_layout.object_size, (unsigned long long)pool);
+		ci->i_layout.object_size, pool);
 		total_len = len;
 	}
 
@@ -112,28 +112,28 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 	return ret;
 }
 
-static size_t ceph_vxattrcb_layout_stripe_unit(struct ceph_inode_info *ci,
-					       char *val, size_t size)
+static ssize_t ceph_vxattrcb_layout_stripe_unit(struct ceph_inode_info *ci,
+						char *val, size_t size)
 {
 	return snprintf(val, size, "%u", ci->i_layout.stripe_unit);
 }
 
-static size_t ceph_vxattrcb_layout_stripe_count(struct ceph_inode_info *ci,
-						char *val, size_t size)
+static ssize_t ceph_vxattrcb_layout_stripe_count(struct ceph_inode_info *ci,
+						 char *val, size_t size)
 {
 	return snprintf(val, size, "%u", ci->i_layout.stripe_count);
 }
 
-static size_t ceph_vxattrcb_layout_object_size(struct ceph_inode_info *ci,
-					       char *val, size_t size)
+static ssize_t ceph_vxattrcb_layout_object_size(struct ceph_inode_info *ci,
+						char *val, size_t size)
 {
 	return snprintf(val, size, "%u", ci->i_layout.object_size);
 }
 
-static size_t ceph_vxattrcb_layout_pool(struct ceph_inode_info *ci,
-					char *val, size_t size)
+static ssize_t ceph_vxattrcb_layout_pool(struct ceph_inode_info *ci,
+					 char *val, size_t size)
 {
-	int ret;
+	ssize_t ret;
 	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
 	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	s64 pool = ci->i_layout.pool_id;
@@ -144,18 +144,18 @@ static size_t ceph_vxattrcb_layout_pool(struct ceph_inode_info *ci,
 	if (pool_name)
 		ret = snprintf(val, size, "%s", pool_name);
 	else
-		ret = snprintf(val, size, "%lld", (unsigned long long)pool);
+		ret = snprintf(val, size, "%lld", pool);
 	up_read(&osdc->lock);
 	return ret;
 }
 
-static size_t ceph_vxattrcb_layout_pool_namespace(struct ceph_inode_info *ci,
-						  char *val, size_t size)
+static ssize_t ceph_vxattrcb_layout_pool_namespace(struct ceph_inode_info *ci,
+						   char *val, size_t size)
 {
 	int ret = 0;
 	struct ceph_string *ns = ceph_try_get_string(ci->i_layout.pool_ns);
 	if (ns) {
-		ret = snprintf(val, size, "%.*s", (int)ns->len, ns->str);
+		ret = snprintf(val, size, "%.*s", ns->len, ns->str);
 		ceph_put_string(ns);
 	}
 	return ret;
@@ -163,50 +163,50 @@ static size_t ceph_vxattrcb_layout_pool_namespace(struct ceph_inode_info *ci,
 
 /* directories */
 
-static size_t ceph_vxattrcb_dir_entries(struct ceph_inode_info *ci, char *val,
-					size_t size)
+static ssize_t ceph_vxattrcb_dir_entries(struct ceph_inode_info *ci, char *val,
+					 size_t size)
 {
 	return snprintf(val, size, "%lld", ci->i_files + ci->i_subdirs);
 }
 
-static size_t ceph_vxattrcb_dir_files(struct ceph_inode_info *ci, char *val,
-				      size_t size)
+static ssize_t ceph_vxattrcb_dir_files(struct ceph_inode_info *ci, char *val,
+				       size_t size)
 {
 	return snprintf(val, size, "%lld", ci->i_files);
 }
 
-static size_t ceph_vxattrcb_dir_subdirs(struct ceph_inode_info *ci, char *val,
-					size_t size)
+static ssize_t ceph_vxattrcb_dir_subdirs(struct ceph_inode_info *ci, char *val,
+					 size_t size)
 {
 	return snprintf(val, size, "%lld", ci->i_subdirs);
 }
 
-static size_t ceph_vxattrcb_dir_rentries(struct ceph_inode_info *ci, char *val,
-					 size_t size)
+static ssize_t ceph_vxattrcb_dir_rentries(struct ceph_inode_info *ci, char *val,
+					  size_t size)
 {
 	return snprintf(val, size, "%lld", ci->i_rfiles + ci->i_rsubdirs);
 }
 
-static size_t ceph_vxattrcb_dir_rfiles(struct ceph_inode_info *ci, char *val,
-				       size_t size)
+static ssize_t ceph_vxattrcb_dir_rfiles(struct ceph_inode_info *ci, char *val,
+					size_t size)
 {
 	return snprintf(val, size, "%lld", ci->i_rfiles);
 }
 
-static size_t ceph_vxattrcb_dir_rsubdirs(struct ceph_inode_info *ci, char *val,
-					 size_t size)
+static ssize_t ceph_vxattrcb_dir_rsubdirs(struct ceph_inode_info *ci, char *val,
+					  size_t size)
 {
 	return snprintf(val, size, "%lld", ci->i_rsubdirs);
 }
 
-static size_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
-				       size_t size)
+static ssize_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
+					size_t size)
 {
 	return snprintf(val, size, "%lld", ci->i_rbytes);
 }
 
-static size_t ceph_vxattrcb_dir_rctime(struct ceph_inode_info *ci, char *val,
-				       size_t size)
+static ssize_t ceph_vxattrcb_dir_rctime(struct ceph_inode_info *ci, char *val,
+					size_t size)
 {
 	return snprintf(val, size, "%lld.%09ld", ci->i_rctime.tv_sec,
 			ci->i_rctime.tv_nsec);
@@ -218,8 +218,8 @@ static bool ceph_vxattrcb_dir_pin_exists(struct ceph_inode_info *ci)
 	return ci->i_dir_pin != -ENODATA;
 }
 
-static size_t ceph_vxattrcb_dir_pin(struct ceph_inode_info *ci, char *val,
-                                    size_t size)
+static ssize_t ceph_vxattrcb_dir_pin(struct ceph_inode_info *ci, char *val,
+				     size_t size)
 {
 	return snprintf(val, size, "%d", (int)ci->i_dir_pin);
 }
@@ -238,21 +238,21 @@ static bool ceph_vxattrcb_quota_exists(struct ceph_inode_info *ci)
 	return ret;
 }
 
-static size_t ceph_vxattrcb_quota(struct ceph_inode_info *ci, char *val,
-				  size_t size)
+static ssize_t ceph_vxattrcb_quota(struct ceph_inode_info *ci, char *val,
+				   size_t size)
 {
 	return snprintf(val, size, "max_bytes=%llu max_files=%llu",
 			ci->i_max_bytes, ci->i_max_files);
 }
 
-static size_t ceph_vxattrcb_quota_max_bytes(struct ceph_inode_info *ci,
-					    char *val, size_t size)
+static ssize_t ceph_vxattrcb_quota_max_bytes(struct ceph_inode_info *ci,
+					     char *val, size_t size)
 {
 	return snprintf(val, size, "%llu", ci->i_max_bytes);
 }
 
-static size_t ceph_vxattrcb_quota_max_files(struct ceph_inode_info *ci,
-					    char *val, size_t size)
+static ssize_t ceph_vxattrcb_quota_max_files(struct ceph_inode_info *ci,
+					     char *val, size_t size)
 {
 	return snprintf(val, size, "%llu", ci->i_max_files);
 }
@@ -263,8 +263,8 @@ static bool ceph_vxattrcb_snap_btime_exists(struct ceph_inode_info *ci)
 	return (ci->i_snap_btime.tv_sec != 0 || ci->i_snap_btime.tv_nsec != 0);
 }
 
-static size_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
-				       size_t size)
+static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
+					size_t size)
 {
 	return snprintf(val, size, "%lld.%09ld", ci->i_snap_btime.tv_sec,
 			ci->i_snap_btime.tv_nsec);
@@ -791,7 +791,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	struct ceph_inode_xattr *xattr;
 	struct ceph_vxattr *vxattr = NULL;
 	int req_mask;
-	int err;
+	ssize_t err;
 
 	/* let's see if a virtual xattr was requested */
 	vxattr = ceph_match_vxattr(inode, name);
-- 
2.21.0

