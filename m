Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156604A8B52
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Feb 2022 19:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345884AbiBCSPK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Feb 2022 13:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiBCSPI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Feb 2022 13:15:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64624C061714
        for <ceph-devel@vger.kernel.org>; Thu,  3 Feb 2022 10:15:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22DEFB8354A
        for <ceph-devel@vger.kernel.org>; Thu,  3 Feb 2022 18:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB96C340E8;
        Thu,  3 Feb 2022 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643912105;
        bh=QqD0odqnx5Qe7gTXQlRKAe80pQwGexDo+m0yBGDsE+c=;
        h=From:To:Cc:Subject:Date:From;
        b=BmgCXPoQjNHGNlLrxeYudTDxYVni1A7qM3zRw4S/g8w+YDH3kp96t9pGUXeYxPZ3G
         MZCAPORsQNh6j+ECO/tqFuwGtBDxK+5Q87WuY8DujCzn2VM+cjw3ccFk6StrWuo3Kn
         o4z4XkpfGYCEJeSyooGEzp/SXtKzL/kzgpSns8HZ/eodJVHbgTu7v4n3KX021sQ6PY
         GtUF5ePrm7c1uj0NNn0zrEp8dLPY0xOEvoVbhsgdAoEJi3zAr2t1AwKbXbQleXyqSR
         W+6/11QwUGEe+TJ2/xUhydzle4qLfjm+jzWqR7nTng3lChO9ylbNLkInri0c8hq9EL
         ueLA4KvLelRIg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: eliminate req->r_wait_for_completion
Date:   Thu,  3 Feb 2022 13:15:04 -0500
Message-Id: <20220203181504.90807-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...and instead just pass the wait function on the stack.

Make ceph_mdsc_wait_request non-static, and add an argument for wait for
completion. Then have ceph_lock_message call ceph_mdsc_submit_request,
and ceph_mdsc_wait_request and pass in the pointer to
ceph_lock_wait_for_completion.

While we're in there, rearrange some fields in ceph_mds_request, so we
save a total of 24 bytes per.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/locks.c      |  6 +++---
 fs/ceph/mds_client.c | 11 ++++++-----
 fs/ceph/mds_client.h |  9 +++++----
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index d1f154aec249..81336b62bb99 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -111,10 +111,10 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
 	req->r_args.filelock_change.length = cpu_to_le64(length);
 	req->r_args.filelock_change.wait = wait;
 
-	if (wait)
-		req->r_wait_for_completion = ceph_lock_wait_for_completion;
-
 	err = ceph_mdsc_do_request(mdsc, inode, req);
+	if (!err)
+		err = ceph_mdsc_wait_request(mdsc, req, wait ?
+					ceph_lock_wait_for_completion : NULL);
 	if (!err && operation == CEPH_MDS_OP_GETFILELOCK) {
 		fl->fl_pid = -le64_to_cpu(req->r_reply_info.filelock_reply->pid);
 		if (CEPH_LOCK_SHARED == req->r_reply_info.filelock_reply->type)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 5937cbfafd31..72ba22de2b46 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2974,15 +2974,16 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 	return err;
 }
 
-static int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
-				  struct ceph_mds_request *req)
+int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
+			   struct ceph_mds_request *req,
+			   ceph_mds_request_wait_callback_t wait_func)
 {
 	int err;
 
 	/* wait */
 	dout("do_request waiting\n");
-	if (!req->r_timeout && req->r_wait_for_completion) {
-		err = req->r_wait_for_completion(mdsc, req);
+	if (wait_func) {
+		err = wait_func(mdsc, req);
 	} else {
 		long timeleft = wait_for_completion_killable_timeout(
 					&req->r_completion,
@@ -3039,7 +3040,7 @@ int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
 	/* issue */
 	err = ceph_mdsc_submit_request(mdsc, dir, req);
 	if (!err)
-		err = ceph_mdsc_wait_request(mdsc, req);
+		err = ceph_mdsc_wait_request(mdsc, req, NULL);
 	dout("do_request %p done, result %d\n", req, err);
 	return err;
 }
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 97c7f7bfa55f..ab12f3ce81a3 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -274,8 +274,8 @@ struct ceph_mds_request {
 
 	union ceph_mds_request_args r_args;
 	int r_fmode;        /* file mode, if expecting cap */
-	const struct cred *r_cred;
 	int r_request_release_offset;
+	const struct cred *r_cred;
 	struct timespec64 r_stamp;
 
 	/* for choosing which mds to send this request to */
@@ -296,12 +296,11 @@ struct ceph_mds_request {
 	struct ceph_msg  *r_reply;
 	struct ceph_mds_reply_info_parsed r_reply_info;
 	int r_err;
-
+	u32               r_readdir_offset;
 
 	struct page *r_locked_page;
 	int r_dir_caps;
 	int r_num_caps;
-	u32               r_readdir_offset;
 
 	unsigned long r_timeout;  /* optional.  jiffies, 0 is "wait forever" */
 	unsigned long r_started;  /* start time to measure timeout against */
@@ -329,7 +328,6 @@ struct ceph_mds_request {
 	struct completion r_completion;
 	struct completion r_safe_completion;
 	ceph_mds_request_callback_t r_callback;
-	ceph_mds_request_wait_callback_t r_wait_for_completion;
 	struct list_head  r_unsafe_item;  /* per-session unsafe list item */
 
 	long long	  r_dir_release_cnt;
@@ -507,6 +505,9 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode);
 extern int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc,
 				    struct inode *dir,
 				    struct ceph_mds_request *req);
+int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
+			struct ceph_mds_request *req,
+			ceph_mds_request_wait_callback_t wait_func);
 extern int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
 				struct inode *dir,
 				struct ceph_mds_request *req);
-- 
2.34.1

