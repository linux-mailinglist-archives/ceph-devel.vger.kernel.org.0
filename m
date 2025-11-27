Return-Path: <ceph-devel+bounces-4121-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C827BC8E929
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 14:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 107323B5F16
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 13:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790FF212549;
	Thu, 27 Nov 2025 13:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iQIO59eu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XIpVu4mh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823E81EB1A4
	for <ceph-devel@vger.kernel.org>; Thu, 27 Nov 2025 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764251209; cv=none; b=ibs0sWJ/IJ412dw7v+rpT1Ye9mMoGdzROF51yM9JaxShOZVLceGYv7FYpkg9mABwMKylSc6R68wvOSVb+7wqAzvfQz/siTu/ZpiUCX4OoMV38FmjaPEqnyRQ0Johv3+L7dRLNio6fltLsbk9G+6RiHSp26LfQ04EUhm1bwHQj/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764251209; c=relaxed/simple;
	bh=fKwmArmGey7L7GjqjhIl2PDdMy7Xs52/q7vTX4jwf3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TGE7Dp7hHJHElAUFYr/VJRmA9nDGgP1SdwrKTu4lO8oWmlwK/eAXP/2kFJTq3w55XoxhNj6J9gXFYk9L8UpEh+F/IDA829I6TvLbrwlO6M6hmWUtsc18eC+oWGhL1cJr31VC+ZGNF19LEzMnu79KAL4y7ufKgF91cxHVWVHBChc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iQIO59eu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XIpVu4mh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764251206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9fbNVavPneORVV3+5YpE/yBOETNjQuihBvU60uRE+Bk=;
	b=iQIO59eunCPtrAF1x+XfiHhq3Z2ApkNNcVVKx8PGAFLCeBueeLxxCrCVecivgQXPERekzu
	W/AhYJgtmC48PBs0r1N00wdZch7WXj7kiLU4VguusqeSf7E9Tuwp9HNsxHp9QsD4Hs8gb/
	h7TlqGXxjnbo56MkFPk+oz7f6WmHbnI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-JfUksy_dPOCjXaGYKh3RpA-1; Thu, 27 Nov 2025 08:46:45 -0500
X-MC-Unique: JfUksy_dPOCjXaGYKh3RpA-1
X-Mimecast-MFC-AGG-ID: JfUksy_dPOCjXaGYKh3RpA_1764251205
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b2e4b78e35so157060185a.0
        for <ceph-devel@vger.kernel.org>; Thu, 27 Nov 2025 05:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764251204; x=1764856004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9fbNVavPneORVV3+5YpE/yBOETNjQuihBvU60uRE+Bk=;
        b=XIpVu4mhkJZ4DBKY4L+ZW3l2GonFfHHVlAkSqvMSH643qhMUlI5zpKkS6ZG1S0CpAB
         Jz6OToN4JvKUW1aDoKI9vEz5rE1rJSnKyCNQymziX2TJQy5fcrYH7VQJI9QunJX3zAVa
         E2bqEHO5fIes4U+1a6YhD8y1+9+ORwCha/5ycub/iVGx/2y9udb2zGnge6P94B+gvYzJ
         G2uEGYT9VbN3PfiplQOBPXYPkaHdmqdRk2m6Sl1w74mUIcywvqdSAbURpnL3E2QyM/6v
         g6m2bTA4LALrjqB12Tkgt+iUKAy7sG2ExmigLqdTAqeMx/x35CnXD6CyN4AQiblKHG+E
         7fjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764251204; x=1764856004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9fbNVavPneORVV3+5YpE/yBOETNjQuihBvU60uRE+Bk=;
        b=vSLqzKaQMZluwPCUl6t644p3Fa/v0QqMETiV4/ZbNrmKnzyZcZRSoDepOKK2l5pw8t
         e3TNmCSbHKOBurm7jSwF0wJfDpjc3WG8zbyUyZOUQeLWspssHaVLfWcwrUrifCVouSq/
         xamfjxTeFOgalQR6RyJW5103b8As7LwbxNtuMvoKFWEuzsG6aAWHsIv3jBr+s6D7RdVG
         jZm11/x7TP73pX/+UoLNikitq9geXwEuBEp6uocCyN2JHy6oFlEwNmGrdEK9x5K2wNaT
         nI1rcClHBeAq1ZPBVOmX780U5SPDQFTs0NeA3JnjqIoILdrV38CrxNGPCzx4GobTWIgR
         DzaQ==
X-Gm-Message-State: AOJu0YxDH+zD5B7ZELdWcPi2Wh/M8ER6RyNxqRNmEFaRFejCc1przZhQ
	9SGg38rjYiwA+r0P6veUhEBh11VAuFNXQiylEP34tFu47l1RpcVn5HX2y/8eqYAyrm06AGzj5aN
	6ituFNpsYxCMq3lWon0Tx51JEZuN0yhCQIMopISt6lsxn4vSkg33bPQLONcQH9yEswegLcJ3+jK
	wZsbH1K6Y7ZEht9vwXDLQD2+4Ssk8jnaCOqAzYuUsseQ4FXYGpAQ==
X-Gm-Gg: ASbGncshAvHhrBhISFp0v0Elmd8xHA/NgYjRkpVt8ozwxRnb+wIZQLBgz4Y0N5hcpdX
	GpGO0VdQEFkJb/zJTRTcGM/LinYrL3kt6qQKl/ur6mssTLSXvVBp+kEwrvKWRtz0oQg28Le/2I0
	eLUm7qgETs710MCKkdKfeWX5oKTfblXLsvz5Ea7aAaybGQ5wvnsytvm2Oj5jktQZOxZJ9dXkVgx
	oh25jh1CDfa7qzUNM+kM+yqPaeTRWf36uiDfiTdbaPnKSAUA62OBA0uQZuaqTDX+iGg/5kcecAE
	M6IcYoJbXGHCC1T+NxGrtevYxoR6foBtqqtAF/rrYQlTC23iGbHXkjfNGJZiEanbHeaMemIvxBo
	3WN2TuNjJ2q4ZHLTKjqTNo+jdLlmFLZD60VjMqEehY3k=
X-Received: by 2002:a05:620a:3184:b0:8a0:fb41:7f3c with SMTP id af79cd13be357-8b4ebd702damr1528967985a.27.1764251204518;
        Thu, 27 Nov 2025 05:46:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+vSFs9NfoN4U05k763N5M46hygLmxTKtElLQqpKwIvoJ4HfHTT0i4Emc/2tePiiBuJUuYpg==
X-Received: by 2002:a05:620a:3184:b0:8a0:fb41:7f3c with SMTP id af79cd13be357-8b4ebd702damr1528963585a.27.1764251203953;
        Thu, 27 Nov 2025 05:46:43 -0800 (PST)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524fd33fsm9932946d6.24.2025.11.27.05.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 05:46:43 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	vdubeyko@redhat.com
Subject: [PATCH 2/3] ceph: parse subvolume_id from InodeStat v9 and store in inode
Date: Thu, 27 Nov 2025 13:46:19 +0000
Message-Id: <20251127134620.2035796-3-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251127134620.2035796-1-amarkuze@redhat.com>
References: <20251127134620.2035796-1-amarkuze@redhat.com>
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
 fs/ceph/inode.c      | 19 +++++++++++++++++++
 fs/ceph/mds_client.c |  7 +++++++
 fs/ceph/mds_client.h |  1 +
 fs/ceph/super.h      |  2 ++
 4 files changed, 29 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index a6e260d9e420..c3fb4dac4692 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -638,6 +638,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	ci->i_max_bytes = 0;
 	ci->i_max_files = 0;
+	ci->i_subvolume_id = 0;
 
 	memset(&ci->i_dir_layout, 0, sizeof(ci->i_dir_layout));
 	memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
@@ -742,6 +743,8 @@ void ceph_evict_inode(struct inode *inode)
 
 	percpu_counter_dec(&mdsc->metric.total_inodes);
 
+	ci->i_subvolume_id = 0;
+
 	netfs_wait_for_outstanding_io(inode);
 	truncate_inode_pages_final(&inode->i_data);
 	if (inode->i_state & I_PINNING_NETFS_WB)
@@ -873,6 +876,18 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 	return queue_trunc;
 }
 
+void ceph_inode_set_subvolume(struct inode *inode, u64 subvolume_id)
+{
+	struct ceph_inode_info *ci;
+
+	if (!inode || !subvolume_id)
+		return;
+
+	ci = ceph_inode(inode);
+	if (READ_ONCE(ci->i_subvolume_id) != subvolume_id)
+		WRITE_ONCE(ci->i_subvolume_id, subvolume_id);
+}
+
 void ceph_fill_file_time(struct inode *inode, int issued,
 			 u64 time_warp_seq, struct timespec64 *ctime,
 			 struct timespec64 *mtime, struct timespec64 *atime)
@@ -1087,6 +1102,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 	new_issued = ~issued & info_caps;
 
 	__ceph_update_quota(ci, iinfo->max_bytes, iinfo->max_files);
+	ceph_inode_set_subvolume(inode, iinfo->subvolume_id);
 
 #ifdef CONFIG_FS_ENCRYPTION
 	if (iinfo->fscrypt_auth_len &&
@@ -1594,6 +1610,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			goto done;
 		}
 		if (parent_dir) {
+			ceph_inode_set_subvolume(parent_dir,
+						 rinfo->diri.subvolume_id);
 			err = ceph_fill_inode(parent_dir, NULL, &rinfo->diri,
 					      rinfo->dirfrag, session, -1,
 					      &req->r_caps_reservation);
@@ -1682,6 +1700,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		BUG_ON(!req->r_target_inode);
 
 		in = req->r_target_inode;
+		ceph_inode_set_subvolume(in, rinfo->targeti.subvolume_id);
 		err = ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
 				NULL, session,
 				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 32561fc701e5..6f66097f740b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -105,6 +105,8 @@ static int parse_reply_info_in(void **p, void *end,
 	int err = 0;
 	u8 struct_v = 0;
 
+	info->subvolume_id = 0;
+
 	if (features == (u64)-1) {
 		u32 struct_len;
 		u8 struct_compat;
@@ -243,6 +245,10 @@ static int parse_reply_info_in(void **p, void *end,
 			ceph_decode_skip_n(p, end, v8_struct_len, bad);
 		}
 
+		/* struct_v 9 added subvolume_id */
+		if (struct_v >= 9)
+			ceph_decode_64_safe(p, end, info->subvolume_id, bad);
+
 		*p = end;
 	} else {
 		/* legacy (unversioned) struct */
@@ -3962,6 +3968,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
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
index a1f781c46b41..69069c920683 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -385,6 +385,7 @@ struct ceph_inode_info {
 
 	/* quotas */
 	u64 i_max_bytes, i_max_files;
+	u64 i_subvolume_id;
 
 	s32 i_dir_pin;
 
@@ -1057,6 +1058,7 @@ extern struct inode *ceph_get_inode(struct super_block *sb,
 extern struct inode *ceph_get_snapdir(struct inode *parent);
 extern int ceph_fill_file_size(struct inode *inode, int issued,
 			       u32 truncate_seq, u64 truncate_size, u64 size);
+extern void ceph_inode_set_subvolume(struct inode *inode, u64 subvolume_id);
 extern void ceph_fill_file_time(struct inode *inode, int issued,
 				u64 time_warp_seq, struct timespec64 *ctime,
 				struct timespec64 *mtime,
-- 
2.34.1


