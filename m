Return-Path: <ceph-devel+bounces-2432-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B90A2A08D54
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2025 11:05:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 875701888902
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2025 10:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16587209F3B;
	Fri, 10 Jan 2025 10:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gA96WmYt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E415920967C;
	Fri, 10 Jan 2025 10:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736503547; cv=none; b=R7CBR7hxstSgctz2debyPRQzmV9QWO1Rz05Q+395GjOv3kVP5GH44EfdW++3qW7XmgtW8VC2M/jrwXeOzdMqFZbJLBdGXQ5+AzbjM+YzyNB78CcYKVZxF80/bgqOXVwyRdK4+5Rl+zUfnhsqb1r1J5j5tBqKXUOpnHIU9DAd9IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736503547; c=relaxed/simple;
	bh=xASOCwCEXLpPIdNbfETuyhUveLSXrYHW7i9ahbdSGJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sVd5sFnbYA21GQhvBOn1YBYS5G5uB3yFoZ//YoeRhsET+a3nA1gulqZbiUUzlkoPeLf6eSqx0dwnAn6hfsPP0MuVeQlr4XwlLqr61QzqRmxfyeRlZZRjEZqxChK0VR8Y2LFg1cl+MyGxPhQf4peV563RW+nJZMSFYkf3GDkBlD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gA96WmYt; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=fkyBQ
	N9I/JTRDwYkFSaOZd/JK8tT4j0wrdYiWjVUMLY=; b=gA96WmYtw91EvSGN3DWsF
	O3GOYau/STx0LGWGYU7e8UVcnQouWX4wXe69aKIhOkyM1nQe2fLLnWL/r1OGbh6Y
	oVxL5927oc9lY3NXALxvpGkHB1jzbRwCcIHfDQWbltsOrDXZZrpgOwVtSLFHADFi
	Ev9Qxi+7pDZrJEzPWxHGMQ=
Received: from hello.company.local (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3vZLm8IBn2LfZEw--.28436S2;
	Fri, 10 Jan 2025 18:05:27 +0800 (CST)
From: Liang Jie <buaajxlj@163.com>
To: xiubli@redhat.com
Cc: idryomov@gmail.com,
	fanggeng@lixiang.com,
	yangchen11@lixiang.com,
	buaajxlj@163.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liang Jie <liangjie@lixiang.com>
Subject: [PATCH] ceph: streamline request head structures in MDS client
Date: Fri, 10 Jan 2025 18:05:24 +0800
Message-Id: <20250110100524.1891669-1-buaajxlj@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3vZLm8IBn2LfZEw--.28436S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWr1kAw18CFWfWrWfAF1rtFb_yoWrtF4fpF
	WDCa9Fkr4rJa1agF1kAa4j9rnYkrs7Cry7JFWUta42kFyDK3y0ya4UJa4Sv347ZFWxtr1q
	gr1vgF98Wr12q3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pELvtJUUUUU=
X-CM-SenderInfo: pexdtyx0omqiywtou0bp/1tbiNgjQIGeA6KJymQABsJ

From: Liang Jie <liangjie@lixiang.com>

The existence of the ceph_mds_request_head_old structure in the MDS client
code is no longer required due to improvements in handling different MDS
request header versions. This patch removes the now redundant
ceph_mds_request_head_old structure and replaces its usage with the
flexible and extensible ceph_mds_request_head structure.

Changes include:
- Modification of find_legacy_request_head to directly cast the pointer to
  ceph_mds_request_head_legacy without going through the old structure.
- Update sizeof calculations in create_request_message to use offsetofend
  for consistency and future-proofing, rather than referencing the old
  structure.
- Use of the structured ceph_mds_request_head directly instead of the old
  one.

Additionally, this consolidation normalizes the handling of
request_head_version v1 to align with versions v2 and v3, leading to a
more consistent and maintainable codebase.

These changes simplify the codebase and reduce potential confusion stemming
from the existence of an obsolete structure.

Signed-off-by: Liang Jie <liangjie@lixiang.com>
---
 fs/ceph/mds_client.c         | 16 ++++++++--------
 include/linux/ceph/ceph_fs.h | 14 --------------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 785fe489ef4b..2196e404318c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2945,12 +2945,12 @@ static struct ceph_mds_request_head_legacy *
 find_legacy_request_head(void *p, u64 features)
 {
 	bool legacy = !(features & CEPH_FEATURE_FS_BTIME);
-	struct ceph_mds_request_head_old *ohead;
+	struct ceph_mds_request_head *head;
 
 	if (legacy)
 		return (struct ceph_mds_request_head_legacy *)p;
-	ohead = (struct ceph_mds_request_head_old *)p;
-	return (struct ceph_mds_request_head_legacy *)&ohead->oldest_client_tid;
+	head = (struct ceph_mds_request_head *)p;
+	return (struct ceph_mds_request_head_legacy *)&head->oldest_client_tid;
 }
 
 /*
@@ -3020,7 +3020,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	if (legacy)
 		len = sizeof(struct ceph_mds_request_head_legacy);
 	else if (request_head_version == 1)
-		len = sizeof(struct ceph_mds_request_head_old);
+		len = offsetofend(struct ceph_mds_request_head, args);
 	else if (request_head_version == 2)
 		len = offsetofend(struct ceph_mds_request_head, ext_num_fwd);
 	else
@@ -3104,11 +3104,11 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 		msg->hdr.version = cpu_to_le16(3);
 		p = msg->front.iov_base + sizeof(*lhead);
 	} else if (request_head_version == 1) {
-		struct ceph_mds_request_head_old *ohead = msg->front.iov_base;
+		struct ceph_mds_request_head *nhead = msg->front.iov_base;
 
 		msg->hdr.version = cpu_to_le16(4);
-		ohead->version = cpu_to_le16(1);
-		p = msg->front.iov_base + sizeof(*ohead);
+		nhead->version = cpu_to_le16(1);
+		p = msg->front.iov_base + offsetofend(struct ceph_mds_request_head, args);
 	} else if (request_head_version == 2) {
 		struct ceph_mds_request_head *nhead = msg->front.iov_base;
 
@@ -3265,7 +3265,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 	 * so we limit to retry at most 256 times.
 	 */
 	if (req->r_attempts) {
-	       old_max_retry = sizeof_field(struct ceph_mds_request_head_old,
+		old_max_retry = sizeof_field(struct ceph_mds_request_head,
 					    num_retry);
 	       old_max_retry = 1 << (old_max_retry * BITS_PER_BYTE);
 	       if ((old_version && req->r_attempts >= old_max_retry) ||
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 2d7d86f0290d..c7f2c63b3bc3 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -504,20 +504,6 @@ struct ceph_mds_request_head_legacy {
 
 #define CEPH_MDS_REQUEST_HEAD_VERSION  3
 
-struct ceph_mds_request_head_old {
-	__le16 version;                /* struct version */
-	__le64 oldest_client_tid;
-	__le32 mdsmap_epoch;           /* on client */
-	__le32 flags;                  /* CEPH_MDS_FLAG_* */
-	__u8 num_retry, num_fwd;       /* count retry, fwd attempts */
-	__le16 num_releases;           /* # include cap/lease release records */
-	__le32 op;                     /* mds op code */
-	__le32 caller_uid, caller_gid;
-	__le64 ino;                    /* use this ino for openc, mkdir, mknod,
-					  etc. (if replaying) */
-	union ceph_mds_request_args_ext args;
-} __attribute__ ((packed));
-
 struct ceph_mds_request_head {
 	__le16 version;                /* struct version */
 	__le64 oldest_client_tid;
-- 
2.25.1


