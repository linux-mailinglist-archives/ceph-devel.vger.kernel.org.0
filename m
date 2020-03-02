Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6861A175CAF
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 15:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgCBOOj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Mar 2020 09:14:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbgCBOOi (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 09:14:38 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E2E21D56;
        Mon,  2 Mar 2020 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583158478;
        bh=xz7AZ/VC3jemDxDDzYE4aFgQqvBnEj8QqVsSnY8fwZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4daZkQqm6QBLG5/V8dDtXTbOk8VbLwSTZ9oesk3ku+ndMBZtX3/1Rt416YtoLNcf
         QifUXlb+5awn/HcKaQ8HIBZKe/7s3dbFPifyxTnNKb4LlomqHazi73KMXRpNjgeKfb
         11MQeEoV3KMKib2+HG/eicoJTvv+4Mmc+auukbfo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH v6 02/13] ceph: add flag to designate that a request is asynchronous
Date:   Mon,  2 Mar 2020 09:14:23 -0500
Message-Id: <20200302141434.59825-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302141434.59825-1-jlayton@kernel.org>
References: <20200302141434.59825-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...and ensure that such requests are never queued. The MDS has need to
know that a request is asynchronous so add flags and proper
infrastructure for that.

Also, delegated inode numbers and directory caps are associated with the
session, so ensure that async requests are always transmitted on the
first attempt and are never queued to wait for session reestablishment.

If it does end up looking like we'll need to queue the request, then
have it return -EJUKEBOX so the caller can reattempt with a synchronous
request.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c              |  1 +
 fs/ceph/mds_client.c         | 15 +++++++++++++++
 fs/ceph/mds_client.h         |  1 +
 include/linux/ceph/ceph_fs.h |  5 +++--
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 896d30820035..6004ea0d2ef1 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1312,6 +1312,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
 				session,
 				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
+				 !test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags) &&
 				 rinfo->head->result == 0) ?  req->r_fmode : -1,
 				&req->r_caps_reservation);
 		if (err < 0) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index baf801ba34d9..5d6959c0cf33 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2523,6 +2523,8 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
 	rhead->oldest_client_tid = cpu_to_le64(__get_oldest_tid(mdsc));
 	if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags))
 		flags |= CEPH_MDS_FLAG_REPLAY;
+	if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags))
+		flags |= CEPH_MDS_FLAG_ASYNC;
 	if (req->r_parent)
 		flags |= CEPH_MDS_FLAG_WANT_DENTRY;
 	rhead->flags = cpu_to_le32(flags);
@@ -2606,6 +2608,10 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	mds = __choose_mds(mdsc, req, &random);
 	if (mds < 0 ||
 	    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
+		if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags)) {
+			err = -EJUKEBOX;
+			goto finish;
+		}
 		dout("do_request no mds or not active, waiting for map\n");
 		list_add(&req->r_wait, &mdsc->waiting_for_map);
 		return;
@@ -2630,6 +2636,15 @@ static void __do_request(struct ceph_mds_client *mdsc,
 			err = -EACCES;
 			goto out_session;
 		}
+		/*
+		 * We cannot queue async requests since the caps and delegated
+		 * inodes are bound to the session. Just return -EJUKEBOX and
+		 * let the caller retry a sync request in that case.
+		 */
+		if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags)) {
+			err = -EJUKEBOX;
+			goto out_session;
+		}
 		if (session->s_state == CEPH_MDS_SESSION_NEW ||
 		    session->s_state == CEPH_MDS_SESSION_CLOSING) {
 			__open_session(mdsc, session);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index a0918d00117c..95ac00e59e66 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -255,6 +255,7 @@ struct ceph_mds_request {
 #define CEPH_MDS_R_GOT_RESULT		(5) /* got a result */
 #define CEPH_MDS_R_DID_PREPOPULATE	(6) /* prepopulated readdir */
 #define CEPH_MDS_R_PARENT_LOCKED	(7) /* is r_parent->i_rwsem wlocked? */
+#define CEPH_MDS_R_ASYNC		(8) /* async request */
 	unsigned long	r_req_flags;
 
 	struct mutex r_fill_mutex;
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 8017130a08a1..81d934dae129 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -444,8 +444,9 @@ union ceph_mds_request_args {
 	} __attribute__ ((packed)) lookupino;
 } __attribute__ ((packed));
 
-#define CEPH_MDS_FLAG_REPLAY        1  /* this is a replayed op */
-#define CEPH_MDS_FLAG_WANT_DENTRY   2  /* want dentry in reply */
+#define CEPH_MDS_FLAG_REPLAY		1 /* this is a replayed op */
+#define CEPH_MDS_FLAG_WANT_DENTRY	2 /* want dentry in reply */
+#define CEPH_MDS_FLAG_ASYNC		4 /* request is asynchronous */
 
 struct ceph_mds_request_head {
 	__le64 oldest_client_tid;
-- 
2.24.1

