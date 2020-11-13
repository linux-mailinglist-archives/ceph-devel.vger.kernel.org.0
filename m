Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0842B1B04
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Nov 2020 13:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgKMMVq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Nov 2020 07:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbgKMMVp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 07:21:45 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C887206CA;
        Fri, 13 Nov 2020 12:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605270104;
        bh=jKpY6YGy0uFRqgmT96bylX29wl+IBwotcf6uJSUxDl4=;
        h=From:To:Cc:Subject:Date:From;
        b=lCdIgrc8xKbOiRbjTrP32dPS+msF3FWpDBRlqLbxmRk5CIcwYvULfweusrC72L515
         1FLQpJqmez55bc8o6Z7Prp0/ZvwAOmRkU4EByx/RKyaemnCQEmkOfmbO2qusn7Kr9O
         eSXLwXdR9wdQ5abbIipH3on9wX1dwVmdz1iEL6tE=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     gengjichao@jd.com, lhenriques@suse.de
Subject: [PATCH v2] ceph: when filling trace, call ceph_get_inode outside of mutexes
Date:   Fri, 13 Nov 2020 07:21:42 -0500
Message-Id: <20201113122142.11979-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Geng Jichao reported a rather complex deadlock involving several
moving parts:

1) readahead is issued against an inode and some of its pages are locked
   while the read is in flight.

2) the same inode is evicted from the cache, and this task gets stuck
   waiting for the page lock because of the above readahead.

3) another task is processing a reply trace, and looks up the inode
   being evicted while holding the s_mutex. That ends up waiting for the
   eviction to complete.

4) a write reply for an unrelated inode is then processed in the
   ceph_con_workfn job. It calls ceph_check_caps after putting wrbuffer
   caps, and that gets stuck waiting on the s_mutex held by 3.

The reply to "1" is stuck behind the write reply in "4", so it deadlocks
at that point.

This patch changes the trace processing to call ceph_get_inode outside
of the s_mutex and snap_rwsem, which should break the cycle above.

URL: https://tracker.ceph.com/issues/47998
Reported-by: Geng Jichao <gengjichao@jd.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c      | 13 ++++---------
 fs/ceph/mds_client.c | 15 +++++++++++++++
 2 files changed, 19 insertions(+), 9 deletions(-)

v2: don't call ceph_get_inode if err < 0

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 88bbeb05bd27..9b85d86d8efb 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1315,15 +1315,10 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 	}
 
 	if (rinfo->head->is_target) {
-		tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
-		tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
-
-		in = ceph_get_inode(sb, tvino);
-		if (IS_ERR(in)) {
-			err = PTR_ERR(in);
-			goto done;
-		}
+		/* Should be filled in by handle_reply */
+		BUG_ON(!req->r_target_inode);
 
+		in = req->r_target_inode;
 		err = ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
 				NULL, session,
 				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
@@ -1333,13 +1328,13 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		if (err < 0) {
 			pr_err("ceph_fill_inode badness %p %llx.%llx\n",
 				in, ceph_vinop(in));
+			req->r_target_inode = NULL;
 			if (in->i_state & I_NEW)
 				discard_new_inode(in);
 			else
 				iput(in);
 			goto done;
 		}
-		req->r_target_inode = in;
 		if (in->i_state & I_NEW)
 			unlock_new_inode(in);
 	}
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b3c941503f8c..4fab37d858ce 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3179,6 +3179,21 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 		err = parse_reply_info(session, msg, rinfo, session->s_con.peer_features);
 	mutex_unlock(&mdsc->mutex);
 
+	/* Must find target inode outside of mutexes to avoid deadlocks */
+	if ((err >= 0) && rinfo->head->is_target) {
+		struct inode *in;
+		struct ceph_vino tvino = { .ino  = le64_to_cpu(rinfo->targeti.in->ino),
+					   .snap = le64_to_cpu(rinfo->targeti.in->snapid) };
+
+		in = ceph_get_inode(mdsc->fsc->sb, tvino);
+		if (IS_ERR(in)) {
+			err = PTR_ERR(in);
+			mutex_lock(&session->s_mutex);
+			goto out_err;
+		}
+		req->r_target_inode = in;
+	}
+
 	mutex_lock(&session->s_mutex);
 	if (err < 0) {
 		pr_err("mdsc_handle_reply got corrupt reply mds%d(tid:%lld)\n", mds, tid);
-- 
2.28.0

