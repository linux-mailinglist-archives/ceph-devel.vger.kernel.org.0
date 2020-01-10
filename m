Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76970137832
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2020 21:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgAJU5A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jan 2020 15:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbgAJU44 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 15:56:56 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E92382146E;
        Fri, 10 Jan 2020 20:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578689815;
        bh=1X/kV82S1589DZtqtGh5AMJpi6d/v09cea9roxLegh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAsTyqnIN5cHk/HO2e5WGS3u0bYEAgG66MH1AN+KR9QJ0SGFVw6E40QIrCUYzFaEx
         pCxUTtviIAm479knFzMg8I1JO056HCVQVQJQibfcCmOsR2Yp96GoUWtdXR4d1mC6eV
         gBWIjb9NHzI/RuTpf0l2UrDKZneqUqnJvzJSah2A=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com
Subject: [RFC PATCH 7/9] ceph: add flag to delegate an inode number for async create
Date:   Fri, 10 Jan 2020 15:56:45 -0500
Message-Id: <20200110205647.311023-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110205647.311023-1-jlayton@kernel.org>
References: <20200110205647.311023-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In order to issue an async create request, we need to send an inode
number when we do the request, but we don't know which to which MDS
we'll be issuing the request.

Add a new r_req_flag that tells the request sending machinery to
grab an inode number from the delegated set, and encode it into the
request. If it can't get one then have it return -ECHILD. The
requestor can then reissue a synchronous request.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c      |  1 +
 fs/ceph/mds_client.c | 19 ++++++++++++++++++-
 fs/ceph/mds_client.h |  2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 79bb1e6af090..9cfc093fd273 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1317,6 +1317,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		err = ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
 				NULL, session,
 				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
+				 !test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags) &&
 				 rinfo->head->result == 0) ?  req->r_fmode : -1,
 				&req->r_caps_reservation);
 		if (err < 0) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 852c46550d96..9e7492b21b50 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2623,7 +2623,10 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
 	rhead->flags = cpu_to_le32(flags);
 	rhead->num_fwd = req->r_num_fwd;
 	rhead->num_retry = req->r_attempts - 1;
-	rhead->ino = 0;
+	if (test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags))
+		rhead->ino = cpu_to_le64(req->r_deleg_ino);
+	else
+		rhead->ino = 0;
 
 	dout(" r_parent = %p\n", req->r_parent);
 	return 0;
@@ -2736,6 +2739,20 @@ static void __do_request(struct ceph_mds_client *mdsc,
 		goto out_session;
 	}
 
+	if (test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags) &&
+	    !req->r_deleg_ino) {
+		req->r_deleg_ino = get_delegated_ino(req->r_session);
+
+		if (!req->r_deleg_ino) {
+			/*
+			 * If we can't get a deleg ino, exit with -ECHILD,
+			 * so the caller can reissue a sync request
+			 */
+			err = -ECHILD;
+			goto out_session;
+		}
+	}
+
 	/* send request */
 	req->r_resend_mds = -1;   /* forget any previous mds hint */
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 3db7ef47e1c9..e0b36be7c44f 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -258,6 +258,7 @@ struct ceph_mds_request {
 #define CEPH_MDS_R_GOT_RESULT		(5) /* got a result */
 #define CEPH_MDS_R_DID_PREPOPULATE	(6) /* prepopulated readdir */
 #define CEPH_MDS_R_PARENT_LOCKED	(7) /* is r_parent->i_rwsem wlocked? */
+#define CEPH_MDS_R_DELEG_INO		(8) /* attempt to get r_deleg_ino */
 	unsigned long	r_req_flags;
 
 	struct mutex r_fill_mutex;
@@ -307,6 +308,7 @@ struct ceph_mds_request {
 	int               r_num_fwd;    /* number of forward attempts */
 	int               r_resend_mds; /* mds to resend to next, if any*/
 	u32               r_sent_on_mseq; /* cap mseq request was sent at*/
+	unsigned long	  r_deleg_ino;
 
 	struct list_head  r_wait;
 	struct completion r_completion;
-- 
2.24.1

