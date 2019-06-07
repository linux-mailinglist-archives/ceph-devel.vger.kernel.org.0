Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A1738F41
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbfFGPib (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730005AbfFGPi2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:28 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0E252147A;
        Fri,  7 Jun 2019 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921907;
        bh=Nz35dZZC6NclI6nr7qzHv1zsubxfriWiQTcmU4hIXss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=feJWylOQ2WSQikdNcyMua4ThChGggdD7ZGzLZxpYWwKIxBqFKsV8QQQKffO7U6beM
         5jXDQp+d+dptCAUViUFGJ6Iy1gfcpnxx9uW4FO7RfW8cQoO+QkMUCI2wNso3do/jsk
         A3O3oISpb5zQFrbAbUdCEqP9908eZCMiiFShwsCw=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 10/16] ceph: handle btime in cap messages
Date:   Fri,  7 Jun 2019 11:38:10 -0400
Message-Id: <20190607153816.12918-11-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153816.12918-1-jlayton@kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 18 ++++++++++++------
 fs/ceph/snap.c  |  1 +
 fs/ceph/super.h |  2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 50409d9fdc90..623b82684e90 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1139,7 +1139,7 @@ struct cap_msg_args {
 	u64			flush_tid, oldest_flush_tid, size, max_size;
 	u64			xattr_version;
 	struct ceph_buffer	*xattr_buf;
-	struct timespec64	atime, mtime, ctime;
+	struct timespec64	atime, mtime, ctime, btime;
 	int			op, caps, wanted, dirty;
 	u32			seq, issue_seq, mseq, time_warp_seq;
 	u32			flags;
@@ -1160,7 +1160,6 @@ static int send_cap_msg(struct cap_msg_args *arg)
 	struct ceph_msg *msg;
 	void *p;
 	size_t extra_len;
-	struct timespec64 zerotime = {0};
 	struct ceph_osd_client *osdc = &arg->session->s_mdsc->fsc->client->osdc;
 
 	dout("send_cap_msg %s %llx %llx caps %s wanted %s dirty %s"
@@ -1251,7 +1250,7 @@ static int send_cap_msg(struct cap_msg_args *arg)
 	 * We just zero these out for now, as the MDS ignores them unless
 	 * the requisite feature flags are set (which we don't do yet).
 	 */
-	ceph_encode_timespec64(p, &zerotime);
+	ceph_encode_timespec64(p, &arg->btime);
 	p += sizeof(struct ceph_timespec);
 	ceph_encode_64(&p, 0);
 
@@ -1379,6 +1378,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	arg.mtime = inode->i_mtime;
 	arg.atime = inode->i_atime;
 	arg.ctime = inode->i_ctime;
+	arg.btime = ci->i_btime;
 
 	arg.op = op;
 	arg.caps = cap->implemented;
@@ -1438,6 +1438,7 @@ static inline int __send_flush_snap(struct inode *inode,
 	arg.atime = capsnap->atime;
 	arg.mtime = capsnap->mtime;
 	arg.ctime = capsnap->ctime;
+	arg.btime = capsnap->btime;
 
 	arg.op = CEPH_CAP_OP_FLUSHSNAP;
 	arg.caps = capsnap->issued;
@@ -3044,6 +3045,7 @@ struct cap_extra_info {
 	u64 nsubdirs;
 	/* currently issued */
 	int issued;
+	struct timespec64 btime;
 };
 
 /*
@@ -3130,6 +3132,7 @@ static void handle_cap_grant(struct inode *inode,
 		inode->i_mode = le32_to_cpu(grant->mode);
 		inode->i_uid = make_kuid(&init_user_ns, le32_to_cpu(grant->uid));
 		inode->i_gid = make_kgid(&init_user_ns, le32_to_cpu(grant->gid));
+		ci->i_btime = extra_info->btime;
 		dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
 		     from_kuid(&init_user_ns, inode->i_uid),
 		     from_kgid(&init_user_ns, inode->i_gid));
@@ -3851,17 +3854,20 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		}
 	}
 
-	if (msg_version >= 11) {
+	if (msg_version >= 9) {
 		struct ceph_timespec *btime;
 		u64 change_attr;
-		u32 flags;
 
-		/* version >= 9 */
 		if (p + sizeof(*btime) > end)
 			goto bad;
 		btime = p;
+		ceph_decode_timespec64(&extra_info.btime, btime);
 		p += sizeof(*btime);
 		ceph_decode_64_safe(&p, end, change_attr, bad);
+	}
+
+	if (msg_version >= 11) {
+		u32 flags;
 		/* version >= 10 */
 		ceph_decode_32_safe(&p, end, flags, bad);
 		/* version >= 11 */
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 72c6c022f02b..854308e13f12 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -606,6 +606,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 	capsnap->mtime = inode->i_mtime;
 	capsnap->atime = inode->i_atime;
 	capsnap->ctime = inode->i_ctime;
+	capsnap->btime = ci->i_btime;
 	capsnap->time_warp_seq = ci->i_time_warp_seq;
 	capsnap->truncate_size = ci->i_truncate_size;
 	capsnap->truncate_seq = ci->i_truncate_seq;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 3dd9d467bb80..c3cb942e08b0 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -197,7 +197,7 @@ struct ceph_cap_snap {
 	u64 xattr_version;
 
 	u64 size;
-	struct timespec64 mtime, atime, ctime;
+	struct timespec64 mtime, atime, ctime, btime;
 	u64 time_warp_seq;
 	u64 truncate_size;
 	u32 truncate_seq;
-- 
2.21.0

