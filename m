Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2013F2DC764
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Dec 2020 20:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgLPTv0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Dec 2020 14:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbgLPTv0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 14:51:26 -0500
From:   Jeff Layton <jlayton@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, xiubli@redhat.com
Subject: [PATCH v2] ceph: implement updated ceph_mds_request_head structure
Date:   Wed, 16 Dec 2020 14:50:43 -0500
Message-Id: <20201216195043.385741-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we added the btime feature in mainline ceph, we had to extend
struct ceph_mds_request_args so that it could be set. Implement the same
in the kernel client.

Rename ceph_mds_request_head with a _old extension, and a union
ceph_mds_request_args_ext to allow for the extended size of the new
header format.

Add the appropriate code to handle both formats in struct
create_request_message and key the behavior on whether the peer supports
CEPH_FEATURE_FS_BTIME.

The gid_list field in the payload is now populated from the saved
credential. For now, we don't add any support for setting the btime via
setattr, but this does enable us to add that in the future.

[ idryomov: break unnecessarily long lines ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c         | 101 ++++++++++++++++++++++++++---------
 include/linux/ceph/ceph_fs.h |  32 ++++++++++-
 2 files changed, 108 insertions(+), 25 deletions(-)

 v2: fix encoding of unsafe request resends
     add encode_payload_tail helper
     rework find_old_request_head to take a "legacy" flag argument
     
Ilya,

I'll go ahead and merge this into testing, but your call on whether we
should take this for v5.11, or wait for v5.12. We don't have anything
blocked on this just yet.

I dropped your SoB and Xiubo Reviewed-by tags as well, as the patch is
a bit different from the original.

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0ff76f21466a..cd0cc5d8c4f0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2475,15 +2475,46 @@ static int set_request_path_attr(struct inode *rinode, struct dentry *rdentry,
 	return r;
 }
 
+static struct ceph_mds_request_head_old *
+find_old_request_head(void *p, bool legacy)
+{
+	struct ceph_mds_request_head *new_head;
+
+	if (legacy)
+		return (struct ceph_mds_request_head_old *)p;
+	new_head = (struct ceph_mds_request_head *)p;
+	return (struct ceph_mds_request_head_old *)&new_head->oldest_client_tid;
+}
+
+static void encode_payload_tail(void **p, struct ceph_mds_request *req, bool legacy)
+{
+	struct ceph_timespec ts;
+
+	ceph_encode_timespec64(&ts, &req->r_stamp);
+	ceph_encode_copy(p, &ts, sizeof(ts));
+
+	/* gid list */
+	if (!legacy) {
+		int i;
+
+		ceph_encode_32(p, req->r_cred->group_info->ngroups);
+		for (i = 0; i < req->r_cred->group_info->ngroups; i++)
+			ceph_encode_64(p, from_kgid(&init_user_ns,
+				       req->r_cred->group_info->gid[i]));
+	}
+}
+
 /*
  * called under mdsc->mutex
  */
-static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
+static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 					       struct ceph_mds_request *req,
-					       int mds, bool drop_cap_releases)
+					       bool drop_cap_releases)
 {
+	int mds = session->s_mds;
+	struct ceph_mds_client *mdsc = session->s_mdsc;
 	struct ceph_msg *msg;
-	struct ceph_mds_request_head *head;
+	struct ceph_mds_request_head_old *head;
 	const char *path1 = NULL;
 	const char *path2 = NULL;
 	u64 ino1 = 0, ino2 = 0;
@@ -2493,6 +2524,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 	u16 releases;
 	void *p, *end;
 	int ret;
+	bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
 
 	ret = set_request_path_attr(req->r_inode, req->r_dentry,
 			      req->r_parent, req->r_path1, req->r_ino1.ino,
@@ -2514,14 +2546,23 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 		goto out_free1;
 	}
 
-	len = sizeof(*head) +
-		pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
+	if (legacy) {
+		/* Old style */
+		len = sizeof(*head);
+	} else {
+		/* New style: add gid_list and any later fields */
+		len = sizeof(struct ceph_mds_request_head) + sizeof(u32) +
+		      (sizeof(u64) * req->r_cred->group_info->ngroups);
+	}
+
+	len += pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
 		sizeof(struct ceph_timespec);
 
 	/* calculate (max) length for cap releases */
 	len += sizeof(struct ceph_mds_request_release) *
 		(!!req->r_inode_drop + !!req->r_dentry_drop +
 		 !!req->r_old_inode_drop + !!req->r_old_dentry_drop);
+
 	if (req->r_dentry_drop)
 		len += pathlen1;
 	if (req->r_old_dentry_drop)
@@ -2533,11 +2574,25 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 		goto out_free2;
 	}
 
-	msg->hdr.version = cpu_to_le16(3);
 	msg->hdr.tid = cpu_to_le64(req->r_tid);
 
-	head = msg->front.iov_base;
-	p = msg->front.iov_base + sizeof(*head);
+	/*
+	 * The old ceph_mds_request_header didn't contain a version field, and
+	 * one was added when we moved the message version from 3->4.
+	 */
+	if (legacy) {
+		msg->hdr.version = cpu_to_le16(3);
+		p = msg->front.iov_base + sizeof(*head);
+	} else {
+		struct ceph_mds_request_head *new_head = msg->front.iov_base;
+
+		msg->hdr.version = cpu_to_le16(4);
+		new_head->version = cpu_to_le16(CEPH_MDS_REQUEST_HEAD_VERSION);
+		p = msg->front.iov_base + sizeof(*new_head);
+	}
+
+	head = find_old_request_head(msg->front.iov_base, legacy);
+
 	end = msg->front.iov_base + msg->front.iov_len;
 
 	head->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
@@ -2583,12 +2638,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 
 	head->num_releases = cpu_to_le16(releases);
 
-	/* time stamp */
-	{
-		struct ceph_timespec ts;
-		ceph_encode_timespec64(&ts, &req->r_stamp);
-		ceph_encode_copy(&p, &ts, sizeof(ts));
-	}
+	encode_payload_tail(&p, req, legacy);
 
 	if (WARN_ON_ONCE(p > end)) {
 		ceph_msg_put(msg);
@@ -2642,9 +2692,10 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 {
 	int mds = session->s_mds;
 	struct ceph_mds_client *mdsc = session->s_mdsc;
-	struct ceph_mds_request_head *rhead;
+	struct ceph_mds_request_head_old *rhead;
 	struct ceph_msg *msg;
 	int flags = 0;
+	bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
 
 	req->r_attempts++;
 	if (req->r_inode) {
@@ -2661,6 +2712,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 
 	if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
 		void *p;
+
 		/*
 		 * Replay.  Do not regenerate message (and rebuild
 		 * paths, etc.); just use the original message.
@@ -2668,7 +2720,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 		 * d_move mangles the src name.
 		 */
 		msg = req->r_request;
-		rhead = msg->front.iov_base;
+		rhead = find_old_request_head(msg->front.iov_base, legacy);
 
 		flags = le32_to_cpu(rhead->flags);
 		flags |= CEPH_MDS_FLAG_REPLAY;
@@ -2682,13 +2734,14 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 		/* remove cap/dentry releases from message */
 		rhead->num_releases = 0;
 
-		/* time stamp */
+		/* verify that we haven't got mixed-feature MDSs */
+		if (legacy)
+			WARN_ON_ONCE(le16_to_cpu(msg->hdr.version) >= 4);
+		else
+			WARN_ON_ONCE(le16_to_cpu(msg->hdr.version) < 4);
+
 		p = msg->front.iov_base + req->r_request_release_offset;
-		{
-			struct ceph_timespec ts;
-			ceph_encode_timespec64(&ts, &req->r_stamp);
-			ceph_encode_copy(&p, &ts, sizeof(ts));
-		}
+		encode_payload_tail(&p, req, legacy);
 
 		msg->front.iov_len = p - msg->front.iov_base;
 		msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
@@ -2699,14 +2752,14 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 		ceph_msg_put(req->r_request);
 		req->r_request = NULL;
 	}
-	msg = create_request_message(mdsc, req, mds, drop_cap_releases);
+	msg = create_request_message(session, req, drop_cap_releases);
 	if (IS_ERR(msg)) {
 		req->r_err = PTR_ERR(msg);
 		return PTR_ERR(msg);
 	}
 	req->r_request = msg;
 
-	rhead = msg->front.iov_base;
+	rhead = find_old_request_head(msg->front.iov_base, legacy);
 	rhead->oldest_client_tid = cpu_to_le64(__get_oldest_tid(mdsc));
 	if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags))
 		flags |= CEPH_MDS_FLAG_REPLAY;
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 1a4cc7938694..e41a811026f6 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -457,11 +457,25 @@ union ceph_mds_request_args {
 	} __attribute__ ((packed)) lookupino;
 } __attribute__ ((packed));
 
+union ceph_mds_request_args_ext {
+	union ceph_mds_request_args old;
+	struct {
+		__le32 mode;
+		__le32 uid;
+		__le32 gid;
+		struct ceph_timespec mtime;
+		struct ceph_timespec atime;
+		__le64 size, old_size;       /* old_size needed by truncate */
+		__le32 mask;                 /* CEPH_SETATTR_* */
+		struct ceph_timespec btime;
+	} __attribute__ ((packed)) setattr_ext;
+};
+
 #define CEPH_MDS_FLAG_REPLAY		1 /* this is a replayed op */
 #define CEPH_MDS_FLAG_WANT_DENTRY	2 /* want dentry in reply */
 #define CEPH_MDS_FLAG_ASYNC		4 /* request is asynchronous */
 
-struct ceph_mds_request_head {
+struct ceph_mds_request_head_old {
 	__le64 oldest_client_tid;
 	__le32 mdsmap_epoch;           /* on client */
 	__le32 flags;                  /* CEPH_MDS_FLAG_* */
@@ -474,6 +488,22 @@ struct ceph_mds_request_head {
 	union ceph_mds_request_args args;
 } __attribute__ ((packed));
 
+#define CEPH_MDS_REQUEST_HEAD_VERSION  1
+
+struct ceph_mds_request_head {
+	__le16 version;                /* struct version */
+	__le64 oldest_client_tid;
+	__le32 mdsmap_epoch;           /* on client */
+	__le32 flags;                  /* CEPH_MDS_FLAG_* */
+	__u8 num_retry, num_fwd;       /* count retry, fwd attempts */
+	__le16 num_releases;           /* # include cap/lease release records */
+	__le32 op;                     /* mds op code */
+	__le32 caller_uid, caller_gid;
+	__le64 ino;                    /* use this ino for openc, mkdir, mknod,
+					  etc. (if replaying) */
+	union ceph_mds_request_args_ext args;
+} __attribute__ ((packed));
+
 /* cap/lease release record */
 struct ceph_mds_request_release {
 	__le64 ino, cap_id;            /* ino and unique cap id */
-- 
2.29.2

