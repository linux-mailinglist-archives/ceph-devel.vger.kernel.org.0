Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0274D15AEA6
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 18:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgBLR1d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 12:27:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgBLR1c (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 12:27:32 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B08B52168B;
        Wed, 12 Feb 2020 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581528452;
        bh=9Y6Pvj19NS6rmerUsFnIWVh6Y6oP0cAhttaNAOYNaq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CeEdk7KUcHcxsrYYi0XxQWFfZIrz/wJ19pK2RgQq7NZNOETrpy/g4JVeKBVqRaBVW
         UpBjE96dLskZ8RhlOibvzcDpFv+H/SU39NLI6VefSVoXxZKA3fH1/SjFvsPCwlrp0C
         iK0iYmsOeeEQpYyW2cemx1fzH8qRFFt/AUqlRrLw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idridryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH v4 1/9] ceph: add flag to designate that a request is asynchronous
Date:   Wed, 12 Feb 2020 12:27:21 -0500
Message-Id: <20200212172729.260752-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212172729.260752-1-jlayton@kernel.org>
References: <20200212172729.260752-1-jlayton@kernel.org>
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
 fs/ceph/mds_client.c         | 11 +++++++++++
 fs/ceph/mds_client.h         |  1 +
 include/linux/ceph/ceph_fs.h |  5 +++--
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 094b8fc37787..9869ec101e88 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1311,6 +1311,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
 				session,
 				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
+				 !test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags) &&
 				 rinfo->head->result == 0) ?  req->r_fmode : -1,
 				&req->r_caps_reservation);
 		if (err < 0) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2980e57ca7b9..9f2aeb6908b2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2527,6 +2527,8 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
 	rhead->oldest_client_tid = cpu_to_le64(__get_oldest_tid(mdsc));
 	if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags))
 		flags |= CEPH_MDS_FLAG_REPLAY;
+	if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags))
+		flags |= CEPH_MDS_FLAG_ASYNC;
 	if (req->r_parent)
 		flags |= CEPH_MDS_FLAG_WANT_DENTRY;
 	rhead->flags = cpu_to_le32(flags);
@@ -2634,6 +2636,15 @@ static void __do_request(struct ceph_mds_client *mdsc,
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
index 27a7446e10d3..0327974d0763 100644
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
index cb21c5cf12c3..9f747a1b8788 100644
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

