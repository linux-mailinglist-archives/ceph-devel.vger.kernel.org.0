Return-Path: <ceph-devel+bounces-4464-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E0CA4D39911
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Jan 2026 19:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F1CE33009FF2
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Jan 2026 18:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937DB2FDC37;
	Sun, 18 Jan 2026 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a7TZhoP/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UkmpLudI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C722FD1D0
	for <ceph-devel@vger.kernel.org>; Sun, 18 Jan 2026 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768760699; cv=none; b=NFoahth1TnNglegN/DK53YbsXNEJqLWyUAJxGJB+wDEfIzj3CYp2WTjFttpZj+ioQ+7hYQZZWGeBv6uiXMMeFH/4aome31m+GLOXRr9O+Cefbi0NYgXgBECjzaU9ebDXvr0/61MpUZrkFXnQfkt+592ZF4rgKbN75c4gTfnmVyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768760699; c=relaxed/simple;
	bh=V8GNQLVl8ea8her9f6vS1z+ujThrv5LOxNW0TdIYquQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HGn0CXWq/iCxMZf4/WRawWXI76bhh6GanC+VEc+f+wXoKFNdDut44LHxhAkB3/NJmD9bljGXuKma65uS8wWTIdYn3RZnOhRwo/Lv2eZTl1WwAULwe2YjfE+P8zWyMg14PvvaCYMMGTuwFV4njj8d3H5aFPY6OIeQ5mXxYm8XQZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a7TZhoP/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UkmpLudI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768760697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=34nz+iTyAQI0YfxLn7UsknoNkzo6iEwqBxq+qC62PC8=;
	b=a7TZhoP/3JMcdO5cCTvIIHf/d5UB2mr+HKfnAdvf+a3Eq3m8ezab20FX2zqTzhoBgg5KzX
	vKaGtS5s1vZ/FYtchNXOhKl3GjAfj1+Ut63Y3lDrc6xIHiMPSXfFxb9Zc4VMpyX7Irhb7k
	x04NhlaUmnIp3blukXaNVbgG1rOlCMQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-xC5Xu-6LODK3NGWgY0Tzpw-1; Sun, 18 Jan 2026 13:24:55 -0500
X-MC-Unique: xC5Xu-6LODK3NGWgY0Tzpw-1
X-Mimecast-MFC-AGG-ID: xC5Xu-6LODK3NGWgY0Tzpw_1768760694
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-64c7242a456so6231805a12.3
        for <ceph-devel@vger.kernel.org>; Sun, 18 Jan 2026 10:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768760694; x=1769365494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34nz+iTyAQI0YfxLn7UsknoNkzo6iEwqBxq+qC62PC8=;
        b=UkmpLudI4XxBdb5ctpCcHfD7nnqFxpg/yuRFocpchvkLpX4qnO3D9JeemEKm9nwcFg
         67OW+h72M6hbZIEOgzJzz5dxqOWauoe+mArqnWBjIGozIw095xxJEe5EbaZfN36UlHwK
         1iVIQKnA4aToTEvH8PguikIQTV2b567Z88VNucltfj+bgmDDS0gHDdX00fypvjkQEy9+
         6fRovCKZLunxoQuJTVm55Rkx3s38LDoYyde49Szsjr8g06Mp6EVbfKd1anmlBz2OePem
         Zr5rYKEFanW6uOjuNlB7ojHOp1yTFSbJSiutgIC84IYicNXpPBYHUMkwi+M5Dz6M+6Qn
         fRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768760694; x=1769365494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=34nz+iTyAQI0YfxLn7UsknoNkzo6iEwqBxq+qC62PC8=;
        b=AWrf2BabmJoCv0H0TB5dZYz1O5gULFORj6IzSXRtiyknI6d9tmxpTPm/up1mIqxF+u
         kBMdoPetwAzDfaGYt5Q6yfmNN4XDNAjvsyNbcEP7sHQqHJtBBsF7U45z+VB2DkUPD+MZ
         fz/5buwYOvVwubMJ9wUbDJKBS2SmMtQZq3BMBRtTL8ESIh+Xd9XG79IW9SQ+yNWzPPXh
         u/6wlLTxMCYEmaHO/hziFb03XiYDk3jUnhfOuh6RJ8x+skvVEA+avx8FISfVCqq1nQOR
         Y4ypjZmkcznNCJjLiSfxAysiutyc4MPEyyU+0T73n1Dd0YlAYvUK53tbyT6OHdmvOel9
         QQEw==
X-Gm-Message-State: AOJu0YxMJlwmTgyomzJ1UvdURjjsNgS65yjtV9q+DdWYtkNGA55g1lnJ
	q1McCSB4+C6HIX/17Tr56c8HOIlOVhBZvHu5BAOencdssjbu+eHDhaUot3u3hS/ZQDMOPTO5Ww2
	PFWM+pkyP2RiMB7xF0NKyukJJLPfGX4xnAm74AsEqo0JEf1zdsTYSBm72Zc8RWlTm071Wvw2XhI
	5ePKoiC3BrPYujmhawIAS/U9qXFIwWIuaF+5I4DLjO4CtUrzv58Q==
X-Gm-Gg: AY/fxX7n3iXB3qeU8afp4uSRy7HK5bWelG61Ho1ORIDxK3nv+GtJItzmAUD1qNDaO7N
	fhB5BsIxUTlb0vgi2baHi39M/fBSSTLmZSqRXAn/KUdyB+MuP2vXcbviYUg1P4Y7hyeP0je/i1/
	I4r4aM4DMQdKH5H4302fyehNOP5j7JcGzpNx2Odv+u8b/N+GXEMSlNK+VK1U7vqq/hjkG+5W9rg
	cdqrlziZuU7At80O5EqsLiNUyvCGnjYo4c53t+UwKglbQXBSJwPmrHizujR7FjDY4RV+T4uonzh
	VpU4YGjD/iWkKqd4pbc8vw4Dsj/1EzZhZD/OLqJ00549hqOp1u0rMwbvAMvnSa3tJef4wThS/WD
	ocXyRAlcQmRjxNfNiC+zgoTUcE7+h757m6XSapumGN6A=
X-Received: by 2002:a17:907:7256:b0:b84:40d3:43e6 with SMTP id a640c23a62f3a-b8792e0b88fmr710932766b.6.1768760694050;
        Sun, 18 Jan 2026 10:24:54 -0800 (PST)
X-Received: by 2002:a17:907:7256:b0:b84:40d3:43e6 with SMTP id a640c23a62f3a-b8792e0b88fmr710930666b.6.1768760693503;
        Sun, 18 Jan 2026 10:24:53 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b879513e8d1sm907624666b.2.2026.01.18.10.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 10:24:53 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH v5 2/3] ceph: parse subvolume_id from InodeStat v9 and store in inode
Date: Sun, 18 Jan 2026 18:24:45 +0000
Message-Id: <20260118182446.3514417-3-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260118182446.3514417-1-amarkuze@redhat.com>
References: <20260118182446.3514417-1-amarkuze@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for parsing the subvolume_id field from InodeStat v9 and
storing it in the inode for later use by subvolume metrics tracking.

The subvolume_id identifies which CephFS subvolume an inode belongs to,
enabling per-subvolume I/O metrics collection and reporting.

This patch:
- Adds subvolume_id field to struct ceph_mds_reply_info_in
- Adds i_subvolume_id field to struct ceph_inode_info
- Parses subvolume_id from v9 InodeStat in parse_reply_info_in()
- Adds ceph_inode_set_subvolume() helper to propagate the ID to inodes
- Initializes i_subvolume_id in inode allocation and clears on destroy

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/inode.c      | 41 +++++++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c | 38 ++++++++++++++++++++++++--------------
 fs/ceph/mds_client.h |  1 +
 fs/ceph/super.h      | 10 ++++++++++
 4 files changed, 76 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index a6e260d9e420..257b3e27b741 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -638,6 +638,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	ci->i_max_bytes = 0;
 	ci->i_max_files = 0;
+	ci->i_subvolume_id = CEPH_SUBVOLUME_ID_NONE;
 
 	memset(&ci->i_dir_layout, 0, sizeof(ci->i_dir_layout));
 	memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
@@ -742,6 +743,8 @@ void ceph_evict_inode(struct inode *inode)
 
 	percpu_counter_dec(&mdsc->metric.total_inodes);
 
+	ci->i_subvolume_id = CEPH_SUBVOLUME_ID_NONE;
+
 	netfs_wait_for_outstanding_io(inode);
 	truncate_inode_pages_final(&inode->i_data);
 	if (inode->i_state & I_PINNING_NETFS_WB)
@@ -873,6 +876,40 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 	return queue_trunc;
 }
 
+/*
+ * Set the subvolume ID for an inode.
+ *
+ * The subvolume_id identifies which CephFS subvolume this inode belongs to.
+ * CEPH_SUBVOLUME_ID_NONE (0) means unknown/unset - the MDS only sends
+ * non-zero IDs for inodes within subvolumes.
+ *
+ * An inode's subvolume membership is immutable - once an inode is created
+ * in a subvolume, it stays there. Therefore, if we already have a valid
+ * (non-zero) subvolume_id and receive a different one, that indicates a bug.
+ */
+void ceph_inode_set_subvolume(struct inode *inode, u64 subvolume_id)
+{
+	struct ceph_inode_info *ci;
+	u64 old;
+
+	if (!inode || subvolume_id == CEPH_SUBVOLUME_ID_NONE)
+		return;
+
+	ci = ceph_inode(inode);
+	old = READ_ONCE(ci->i_subvolume_id);
+
+	if (old == subvolume_id)
+		return;
+
+	if (old != CEPH_SUBVOLUME_ID_NONE) {
+		/* subvolume_id should not change once set */
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	WRITE_ONCE(ci->i_subvolume_id, subvolume_id);
+}
+
 void ceph_fill_file_time(struct inode *inode, int issued,
 			 u64 time_warp_seq, struct timespec64 *ctime,
 			 struct timespec64 *mtime, struct timespec64 *atime)
@@ -1087,6 +1124,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 	new_issued = ~issued & info_caps;
 
 	__ceph_update_quota(ci, iinfo->max_bytes, iinfo->max_files);
+	ceph_inode_set_subvolume(inode, iinfo->subvolume_id);
 
 #ifdef CONFIG_FS_ENCRYPTION
 	if (iinfo->fscrypt_auth_len &&
@@ -1594,6 +1632,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			goto done;
 		}
 		if (parent_dir) {
+			ceph_inode_set_subvolume(parent_dir,
+						 rinfo->diri.subvolume_id);
 			err = ceph_fill_inode(parent_dir, NULL, &rinfo->diri,
 					      rinfo->dirfrag, session, -1,
 					      &req->r_caps_reservation);
@@ -1682,6 +1722,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		BUG_ON(!req->r_target_inode);
 
 		in = req->r_target_inode;
+		ceph_inode_set_subvolume(in, rinfo->targeti.subvolume_id);
 		err = ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
 				NULL, session,
 				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d7d8178e1f9a..c765367ac947 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -95,19 +95,19 @@ static int parse_reply_info_quota(void **p, void *end,
 	return -EIO;
 }
 
-/*
- * parse individual inode info
- */
 static int parse_reply_info_in(void **p, void *end,
 			       struct ceph_mds_reply_info_in *info,
-			       u64 features)
+			       u64 features,
+			       struct ceph_mds_client *mdsc)
 {
 	int err = 0;
 	u8 struct_v = 0;
+	u8 struct_compat = 0;
+	u32 struct_len = 0;
+
+	info->subvolume_id = CEPH_SUBVOLUME_ID_NONE;
 
 	if (features == (u64)-1) {
-		u32 struct_len;
-		u8 struct_compat;
 		ceph_decode_8_safe(p, end, struct_v, bad);
 		ceph_decode_8_safe(p, end, struct_compat, bad);
 		/* struct_v is expected to be >= 1. we only understand
@@ -251,6 +251,10 @@ static int parse_reply_info_in(void **p, void *end,
 			ceph_decode_skip_n(p, end, v8_struct_len, bad);
 		}
 
+		/* struct_v 9 added subvolume_id */
+		if (struct_v >= 9)
+			ceph_decode_64_safe(p, end, info->subvolume_id, bad);
+
 		*p = end;
 	} else {
 		/* legacy (unversioned) struct */
@@ -383,12 +387,13 @@ static int parse_reply_info_lease(void **p, void *end,
  */
 static int parse_reply_info_trace(void **p, void *end,
 				  struct ceph_mds_reply_info_parsed *info,
-				  u64 features)
+				  u64 features,
+				  struct ceph_mds_client *mdsc)
 {
 	int err;
 
 	if (info->head->is_dentry) {
-		err = parse_reply_info_in(p, end, &info->diri, features);
+		err = parse_reply_info_in(p, end, &info->diri, features, mdsc);
 		if (err < 0)
 			goto out_bad;
 
@@ -408,7 +413,8 @@ static int parse_reply_info_trace(void **p, void *end,
 	}
 
 	if (info->head->is_target) {
-		err = parse_reply_info_in(p, end, &info->targeti, features);
+		err = parse_reply_info_in(p, end, &info->targeti, features,
+					  mdsc);
 		if (err < 0)
 			goto out_bad;
 	}
@@ -429,7 +435,8 @@ static int parse_reply_info_trace(void **p, void *end,
  */
 static int parse_reply_info_readdir(void **p, void *end,
 				    struct ceph_mds_request *req,
-				    u64 features)
+				    u64 features,
+				    struct ceph_mds_client *mdsc)
 {
 	struct ceph_mds_reply_info_parsed *info = &req->r_reply_info;
 	struct ceph_client *cl = req->r_mdsc->fsc->client;
@@ -544,7 +551,7 @@ static int parse_reply_info_readdir(void **p, void *end,
 		rde->name_len = oname.len;
 
 		/* inode */
-		err = parse_reply_info_in(p, end, &rde->inode, features);
+		err = parse_reply_info_in(p, end, &rde->inode, features, mdsc);
 		if (err < 0)
 			goto out_bad;
 		/* ceph_readdir_prepopulate() will update it */
@@ -752,7 +759,8 @@ static int parse_reply_info_extra(void **p, void *end,
 	if (op == CEPH_MDS_OP_GETFILELOCK)
 		return parse_reply_info_filelock(p, end, info, features);
 	else if (op == CEPH_MDS_OP_READDIR || op == CEPH_MDS_OP_LSSNAP)
-		return parse_reply_info_readdir(p, end, req, features);
+		return parse_reply_info_readdir(p, end, req, features,
+						req->r_mdsc);
 	else if (op == CEPH_MDS_OP_CREATE)
 		return parse_reply_info_create(p, end, info, features, s);
 	else if (op == CEPH_MDS_OP_GETVXATTR)
@@ -781,7 +789,8 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
 	ceph_decode_32_safe(&p, end, len, bad);
 	if (len > 0) {
 		ceph_decode_need(&p, end, len, bad);
-		err = parse_reply_info_trace(&p, p+len, info, features);
+		err = parse_reply_info_trace(&p, p + len, info, features,
+					     s->s_mdsc);
 		if (err < 0)
 			goto out_bad;
 	}
@@ -790,7 +799,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
 	ceph_decode_32_safe(&p, end, len, bad);
 	if (len > 0) {
 		ceph_decode_need(&p, end, len, bad);
-		err = parse_reply_info_extra(&p, p+len, req, features, s);
+		err = parse_reply_info_extra(&p, p + len, req, features, s);
 		if (err < 0)
 			goto out_bad;
 	}
@@ -3970,6 +3979,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 			goto out_err;
 		}
 		req->r_target_inode = in;
+		ceph_inode_set_subvolume(in, rinfo->targeti.subvolume_id);
 	}
 
 	mutex_lock(&session->s_mutex);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 0428a5eaf28c..bd3690baa65c 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -118,6 +118,7 @@ struct ceph_mds_reply_info_in {
 	u32 fscrypt_file_len;
 	u64 rsnaps;
 	u64 change_attr;
+	u64 subvolume_id;
 };
 
 struct ceph_mds_reply_dir_entry {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a1f781c46b41..74fe2dd914e0 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -386,6 +386,15 @@ struct ceph_inode_info {
 	/* quotas */
 	u64 i_max_bytes, i_max_files;
 
+	/*
+	 * Subvolume ID this inode belongs to. CEPH_SUBVOLUME_ID_NONE (0)
+	 * means unknown/unset, matching the FUSE client convention.
+	 * Once set to a valid (non-zero) value, it should not change
+	 * during the inode's lifetime.
+	 */
+#define CEPH_SUBVOLUME_ID_NONE 0
+	u64 i_subvolume_id;
+
 	s32 i_dir_pin;
 
 	struct rb_root i_fragtree;
@@ -1057,6 +1066,7 @@ extern struct inode *ceph_get_inode(struct super_block *sb,
 extern struct inode *ceph_get_snapdir(struct inode *parent);
 extern int ceph_fill_file_size(struct inode *inode, int issued,
 			       u32 truncate_seq, u64 truncate_size, u64 size);
+extern void ceph_inode_set_subvolume(struct inode *inode, u64 subvolume_id);
 extern void ceph_fill_file_time(struct inode *inode, int issued,
 				u64 time_warp_seq, struct timespec64 *ctime,
 				struct timespec64 *mtime,
-- 
2.34.1


