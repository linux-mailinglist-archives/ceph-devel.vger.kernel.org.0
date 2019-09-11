Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E9BB01CF
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbfIKQkk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 12:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbfIKQkj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 12:40:39 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26F832089F
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2019 16:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568220038;
        bh=sxzdZc6aUw9t4hGOgnTNnv0ldvUmuAyexDbKNV37gUk=;
        h=From:To:Subject:Date:From;
        b=Mjz5x9JSwmhebgDE8IgzXEMRwDc4R1qnv5/p1Utbcyda8I4nA6648xBOMZri4Ly7E
         Kx7v1QOpSVIM8JYM2X7lARRx43NKhsQ9hCXJ+BgeLfGakVWOD6sDgcUnHLOYjiCH4B
         d+rrHif0aDTWiKQKtCbaT7Got2Ty2Pz28VdCiOe0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: convert int fields in ceph_mount_options to unsigned int
Date:   Wed, 11 Sep 2019 12:40:37 -0400
Message-Id: <20190911164037.23495-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Most of these values should never be negative, so convert them to
unsigned values. Leave caps_max alone however, as it will be compared
with a counter that we want to leave signed.

Add some sanity checking to the parsed values, and clean up some
unneeded casts.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c |  5 +++--
 fs/ceph/super.c      | 34 ++++++++++++++++++----------------
 fs/ceph/super.h      | 16 ++++++++--------
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0d7afabb1f49..da882217d04d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2031,12 +2031,13 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 	struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
 	struct ceph_mount_options *opt = req->r_mdsc->fsc->mount_options;
 	size_t size = sizeof(struct ceph_mds_reply_dir_entry);
-	int order, num_entries;
+	unsigned int num_entries;
+	int order;
 
 	spin_lock(&ci->i_ceph_lock);
 	num_entries = ci->i_files + ci->i_subdirs;
 	spin_unlock(&ci->i_ceph_lock);
-	num_entries = max(num_entries, 1);
+	num_entries = max(num_entries, 1U);
 	num_entries = min(num_entries, opt->max_readdir);
 
 	order = get_order(size * num_entries);
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 2710f9a4a372..fa95c2faf167 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -170,10 +170,10 @@ static const struct fs_parameter_enum ceph_param_enums[] = {
 static const struct fs_parameter_spec ceph_param_specs[] = {
 	fsparam_flag_no ("acl",				Opt_acl),
 	fsparam_flag_no ("asyncreaddir",		Opt_asyncreaddir),
-	fsparam_u32	("caps_max",			Opt_caps_max),
+	fsparam_s32	("caps_max",			Opt_caps_max),
 	fsparam_u32	("caps_wanted_delay_max",	Opt_caps_wanted_delay_max),
 	fsparam_u32	("caps_wanted_delay_min",	Opt_caps_wanted_delay_min),
-	fsparam_s32	("write_congestion_kb",		Opt_congestion_kb),
+	fsparam_u32	("write_congestion_kb",		Opt_congestion_kb),
 	fsparam_flag_no ("copyfrom",			Opt_copyfrom),
 	fsparam_flag_no ("dcache",			Opt_dcache),
 	fsparam_flag_no ("dirstat",			Opt_dirstat),
@@ -185,8 +185,8 @@ static const struct fs_parameter_spec ceph_param_specs[] = {
 	fsparam_flag_no ("quotadf",			Opt_quotadf),
 	fsparam_u32	("rasize",			Opt_rasize),
 	fsparam_flag_no ("rbytes",			Opt_rbytes),
-	fsparam_s32	("readdir_max_bytes",		Opt_readdir_max_bytes),
-	fsparam_s32	("readdir_max_entries",		Opt_readdir_max_entries),
+	fsparam_u32	("readdir_max_bytes",		Opt_readdir_max_bytes),
+	fsparam_u32	("readdir_max_entries",		Opt_readdir_max_entries),
 	fsparam_enum	("recover_session",		Opt_recover_session),
 	fsparam_flag_no ("require_active_mds",		Opt_require_active_mds),
 	fsparam_u32	("rsize",			Opt_rsize),
@@ -301,12 +301,12 @@ static int ceph_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			goto invalid_value;
 		break;
 	case Opt_wsize:
-		if (result.uint_32 < (int)PAGE_SIZE || result.uint_32 > CEPH_MAX_WRITE_SIZE)
+		if (result.uint_32 < PAGE_SIZE || result.uint_32 > CEPH_MAX_WRITE_SIZE)
 			goto invalid_value;
 		fsopt->wsize = ALIGN(result.uint_32, PAGE_SIZE);
 		break;
 	case Opt_rsize:
-		if (result.uint_32 < (int)PAGE_SIZE || result.uint_32 > CEPH_MAX_READ_SIZE)
+		if (result.uint_32 < PAGE_SIZE || result.uint_32 > CEPH_MAX_READ_SIZE)
 			goto invalid_value;
 		fsopt->rsize = ALIGN(result.uint_32, PAGE_SIZE);
 		break;
@@ -324,7 +324,9 @@ static int ceph_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		fsopt->caps_wanted_delay_max = result.uint_32;
 		break;
 	case Opt_caps_max:
-		fsopt->caps_max = result.uint_32;
+		if (result.int_32 < 0)
+			goto invalid_value;
+		fsopt->caps_max = result.int_32;
 		break;
 	case Opt_readdir_max_entries:
 		if (result.uint_32 < 1)
@@ -332,7 +334,7 @@ static int ceph_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		fsopt->max_readdir = result.uint_32;
 		break;
 	case Opt_readdir_max_bytes:
-		if (result.uint_32 < (int)PAGE_SIZE && result.uint_32 != 0)
+		if (result.uint_32 < PAGE_SIZE && result.uint_32 != 0)
 			goto invalid_value;
 		fsopt->max_readdir_bytes = result.uint_32;
 		break;
@@ -539,25 +541,25 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 		seq_show_option(m, "recover_session", "clean");
 
 	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
-		seq_printf(m, ",wsize=%d", fsopt->wsize);
+		seq_printf(m, ",wsize=%u", fsopt->wsize);
 	if (fsopt->rsize != CEPH_MAX_READ_SIZE)
-		seq_printf(m, ",rsize=%d", fsopt->rsize);
+		seq_printf(m, ",rsize=%u", fsopt->rsize);
 	if (fsopt->rasize != CEPH_RASIZE_DEFAULT)
-		seq_printf(m, ",rasize=%d", fsopt->rasize);
+		seq_printf(m, ",rasize=%u", fsopt->rasize);
 	if (fsopt->congestion_kb != default_congestion_kb())
-		seq_printf(m, ",write_congestion_kb=%d", fsopt->congestion_kb);
+		seq_printf(m, ",write_congestion_kb=%u", fsopt->congestion_kb);
 	if (fsopt->caps_max)
 		seq_printf(m, ",caps_max=%d", fsopt->caps_max);
 	if (fsopt->caps_wanted_delay_min != CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT)
-		seq_printf(m, ",caps_wanted_delay_min=%d",
+		seq_printf(m, ",caps_wanted_delay_min=%u",
 			 fsopt->caps_wanted_delay_min);
 	if (fsopt->caps_wanted_delay_max != CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT)
-		seq_printf(m, ",caps_wanted_delay_max=%d",
+		seq_printf(m, ",caps_wanted_delay_max=%u",
 			   fsopt->caps_wanted_delay_max);
 	if (fsopt->max_readdir != CEPH_MAX_READDIR_DEFAULT)
-		seq_printf(m, ",readdir_max_entries=%d", fsopt->max_readdir);
+		seq_printf(m, ",readdir_max_entries=%u", fsopt->max_readdir);
 	if (fsopt->max_readdir_bytes != CEPH_MAX_READDIR_BYTES_DEFAULT)
-		seq_printf(m, ",readdir_max_bytes=%d", fsopt->max_readdir_bytes);
+		seq_printf(m, ",readdir_max_bytes=%u", fsopt->max_readdir_bytes);
 	if (strcmp(fsopt->snapdir_name, CEPH_SNAPDIRNAME_DEFAULT))
 		seq_show_option(m, "snapdirname", fsopt->snapdir_name);
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a8d8d59155d8..e174425cf44c 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -73,16 +73,16 @@
 #define CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT     60  /* cap release delay */
 
 struct ceph_mount_options {
-	int flags;
+	unsigned int flags;
 
-	int wsize;            /* max write size */
-	int rsize;            /* max read size */
-	int rasize;           /* max readahead */
-	int congestion_kb;    /* max writeback in flight */
-	int caps_wanted_delay_min, caps_wanted_delay_max;
+	unsigned int wsize;            /* max write size */
+	unsigned int rsize;            /* max read size */
+	unsigned int rasize;           /* max readahead */
+	unsigned int congestion_kb;    /* max writeback in flight */
+	unsigned int caps_wanted_delay_min, caps_wanted_delay_max;
 	int caps_max;
-	int max_readdir;       /* max readdir result (entires) */
-	int max_readdir_bytes; /* max readdir result (bytes) */
+	unsigned int max_readdir;       /* max readdir result (entries) */
+	unsigned int max_readdir_bytes; /* max readdir result (bytes) */
 
 	/*
 	 * everything above this point can be memcmp'd; everything below
-- 
2.21.0

