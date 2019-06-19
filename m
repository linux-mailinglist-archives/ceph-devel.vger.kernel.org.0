Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8DA14BE85
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2019 18:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfFSQpg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Jun 2019 12:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbfFSQpf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 12:45:35 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03719217D7;
        Wed, 19 Jun 2019 16:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560962734;
        bh=sL/15lE2CkcpsfLA/Y/ogwWSKvknIF4LPwsicElD/Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grDSfuTAZtcizHMVXwgSHMEhq/+dGE2GY++j4krOH1ILuY8OgoXtgXBOYayTaOyRV
         JatwWUT5Mmo55ILL8D0YuqFPSrWRyP+ZOejOoKqBIOnHLts6tAXeFs7ek8FkOvRPjp
         df3s580mCx5JJKPo7OYex5FO0lrzESH6bHJYb7po=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, sage@redhat.com,
        agruenba@redhat.com, joe@perches.com, pmladek@suse.com,
        rostedt@goodmis.org, geert+renesas@glider.be,
        andriy.shevchenko@linux.intel.com
Subject: [PATCH v2 2/3] ceph: don't NULL terminate virtual xattr strings
Date:   Wed, 19 Jun 2019 12:45:27 -0400
Message-Id: <20190619164528.31958-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190619164528.31958-1-jlayton@kernel.org>
References: <20190619164528.31958-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The convention with xattrs is to not NULL terminate string data in the
value. Have ceph use snprintf_noterm to populate virtual xattrs.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 6621d27e64f5..a1cd9613be98 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -71,13 +71,13 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 	down_read(&osdc->lock);
 	pool_name = ceph_pg_pool_name_by_id(osdc->osdmap, pool);
 	if (pool_name) {
-		len = snprintf(buf, sizeof(buf),
+		len = snprintf_noterm(buf, sizeof(buf),
 		"stripe_unit=%u stripe_count=%u object_size=%u pool=",
 		ci->i_layout.stripe_unit, ci->i_layout.stripe_count,
 	        ci->i_layout.object_size);
 		total_len = len + strlen(pool_name);
 	} else {
-		len = snprintf(buf, sizeof(buf),
+		len = snprintf_noterm(buf, sizeof(buf),
 		"stripe_unit=%u stripe_count=%u object_size=%u pool=%lld",
 		ci->i_layout.stripe_unit, ci->i_layout.stripe_count,
 	        ci->i_layout.object_size, (unsigned long long)pool);
@@ -115,19 +115,19 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 static size_t ceph_vxattrcb_layout_stripe_unit(struct ceph_inode_info *ci,
 					       char *val, size_t size)
 {
-	return snprintf(val, size, "%u", ci->i_layout.stripe_unit);
+	return snprintf_noterm(val, size, "%u", ci->i_layout.stripe_unit);
 }
 
 static size_t ceph_vxattrcb_layout_stripe_count(struct ceph_inode_info *ci,
 						char *val, size_t size)
 {
-	return snprintf(val, size, "%u", ci->i_layout.stripe_count);
+	return snprintf_noterm(val, size, "%u", ci->i_layout.stripe_count);
 }
 
 static size_t ceph_vxattrcb_layout_object_size(struct ceph_inode_info *ci,
 					       char *val, size_t size)
 {
-	return snprintf(val, size, "%u", ci->i_layout.object_size);
+	return snprintf_noterm(val, size, "%u", ci->i_layout.object_size);
 }
 
 static size_t ceph_vxattrcb_layout_pool(struct ceph_inode_info *ci,
@@ -142,9 +142,10 @@ static size_t ceph_vxattrcb_layout_pool(struct ceph_inode_info *ci,
 	down_read(&osdc->lock);
 	pool_name = ceph_pg_pool_name_by_id(osdc->osdmap, pool);
 	if (pool_name)
-		ret = snprintf(val, size, "%s", pool_name);
+		ret = snprintf_noterm(val, size, "%s", pool_name);
 	else
-		ret = snprintf(val, size, "%lld", (unsigned long long)pool);
+		ret = snprintf_noterm(val, size, "%lld",
+					(unsigned long long)pool);
 	up_read(&osdc->lock);
 	return ret;
 }
@@ -155,7 +156,7 @@ static size_t ceph_vxattrcb_layout_pool_namespace(struct ceph_inode_info *ci,
 	int ret = 0;
 	struct ceph_string *ns = ceph_try_get_string(ci->i_layout.pool_ns);
 	if (ns) {
-		ret = snprintf(val, size, "%.*s", (int)ns->len, ns->str);
+		ret = snprintf_noterm(val, size, "%.*s", (int)ns->len, ns->str);
 		ceph_put_string(ns);
 	}
 	return ret;
@@ -166,49 +167,50 @@ static size_t ceph_vxattrcb_layout_pool_namespace(struct ceph_inode_info *ci,
 static size_t ceph_vxattrcb_dir_entries(struct ceph_inode_info *ci, char *val,
 					size_t size)
 {
-	return snprintf(val, size, "%lld", ci->i_files + ci->i_subdirs);
+	return snprintf_noterm(val, size, "%lld", ci->i_files + ci->i_subdirs);
 }
 
 static size_t ceph_vxattrcb_dir_files(struct ceph_inode_info *ci, char *val,
 				      size_t size)
 {
-	return snprintf(val, size, "%lld", ci->i_files);
+	return snprintf_noterm(val, size, "%lld", ci->i_files);
 }
 
 static size_t ceph_vxattrcb_dir_subdirs(struct ceph_inode_info *ci, char *val,
 					size_t size)
 {
-	return snprintf(val, size, "%lld", ci->i_subdirs);
+	return snprintf_noterm(val, size, "%lld", ci->i_subdirs);
 }
 
 static size_t ceph_vxattrcb_dir_rentries(struct ceph_inode_info *ci, char *val,
 					 size_t size)
 {
-	return snprintf(val, size, "%lld", ci->i_rfiles + ci->i_rsubdirs);
+	return snprintf_noterm(val, size, "%lld",
+				ci->i_rfiles + ci->i_rsubdirs);
 }
 
 static size_t ceph_vxattrcb_dir_rfiles(struct ceph_inode_info *ci, char *val,
 				       size_t size)
 {
-	return snprintf(val, size, "%lld", ci->i_rfiles);
+	return snprintf_noterm(val, size, "%lld", ci->i_rfiles);
 }
 
 static size_t ceph_vxattrcb_dir_rsubdirs(struct ceph_inode_info *ci, char *val,
 					 size_t size)
 {
-	return snprintf(val, size, "%lld", ci->i_rsubdirs);
+	return snprintf_noterm(val, size, "%lld", ci->i_rsubdirs);
 }
 
 static size_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
 				       size_t size)
 {
-	return snprintf(val, size, "%lld", ci->i_rbytes);
+	return snprintf_noterm(val, size, "%lld", ci->i_rbytes);
 }
 
 static size_t ceph_vxattrcb_dir_rctime(struct ceph_inode_info *ci, char *val,
 				       size_t size)
 {
-	return snprintf(val, size, "%lld.%09ld", ci->i_rctime.tv_sec,
+	return snprintf_noterm(val, size, "%lld.%09ld", ci->i_rctime.tv_sec,
 			ci->i_rctime.tv_nsec);
 }
 
@@ -221,7 +223,7 @@ static bool ceph_vxattrcb_dir_pin_exists(struct ceph_inode_info *ci)
 static size_t ceph_vxattrcb_dir_pin(struct ceph_inode_info *ci, char *val,
                                     size_t size)
 {
-	return snprintf(val, size, "%d", (int)ci->i_dir_pin);
+	return snprintf_noterm(val, size, "%d", (int)ci->i_dir_pin);
 }
 
 /* quotas */
@@ -241,20 +243,20 @@ static bool ceph_vxattrcb_quota_exists(struct ceph_inode_info *ci)
 static size_t ceph_vxattrcb_quota(struct ceph_inode_info *ci, char *val,
 				  size_t size)
 {
-	return snprintf(val, size, "max_bytes=%llu max_files=%llu",
+	return snprintf_noterm(val, size, "max_bytes=%llu max_files=%llu",
 			ci->i_max_bytes, ci->i_max_files);
 }
 
 static size_t ceph_vxattrcb_quota_max_bytes(struct ceph_inode_info *ci,
 					    char *val, size_t size)
 {
-	return snprintf(val, size, "%llu", ci->i_max_bytes);
+	return snprintf_noterm(val, size, "%llu", ci->i_max_bytes);
 }
 
 static size_t ceph_vxattrcb_quota_max_files(struct ceph_inode_info *ci,
 					    char *val, size_t size)
 {
-	return snprintf(val, size, "%llu", ci->i_max_files);
+	return snprintf_noterm(val, size, "%llu", ci->i_max_files);
 }
 
 /* snapshots */
@@ -266,7 +268,7 @@ static bool ceph_vxattrcb_snap_btime_exists(struct ceph_inode_info *ci)
 static size_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
 				       size_t size)
 {
-	return snprintf(val, size, "%lld.%09ld", ci->i_snap_btime.tv_sec,
+	return snprintf_noterm(val, size, "%lld.%09ld", ci->i_snap_btime.tv_sec,
 			ci->i_snap_btime.tv_nsec);
 }
 
-- 
2.21.0

