Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46E7505DAE
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 19:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345180AbiDRRsd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 13:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiDRRsc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 13:48:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410B13466A
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 10:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27A3DCE113A
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 17:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB057C385A7;
        Mon, 18 Apr 2022 17:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650303948;
        bh=Ic4y1Qv0zXOBofboddjH+75RKQO6nphtIDgoq+UPKJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=G4qI6bvcfaBWOi4ff8UapVDZUtWnzRo/F0kJGwOsbKgrchYMuJf/Oc9pjkppC+q5A
         bIMIHJJdyxahmmTh4L+MYxygvy4WPewRWnBdse1PCCxHjGD8xmXS+8syZbgsd1mr4Y
         2x+mnZ2N7uuX3qCE4DVLV3hfTcy2GiMw3TSYhx3yCOp3MLBxGlknZI9jRybteYnkan
         Gy9YSzYYMx67ygNJ8CBDlBggEbThQQzEq+0XzH+QYy9Qe4Mw8OQ1c+WO7JsPRQb1AF
         gd5Bh+c1AFhQhMH+S6hmk4fYtcd3nihqz2j9gYVh7hW+qQ/5K+9NJWHcQVd/lztySh
         BuAbj9d9c111w==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: fix lock inversion when flushing the mdlog for filesystem sync
Date:   Mon, 18 Apr 2022 13:45:40 -0400
Message-Id: <20220418174540.151546-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

    ======================================================
    WARNING: possible circular locking dependency detected
    5.18.0-rc2+ #237 Tainted: G            E
    ------------------------------------------------------
    fsstress/8647 is trying to acquire lock:
    ffff88810d910090 (&s->s_mutex){+.+.}-{3:3}, at: send_flush_mdlog+0x4c/0x150 [ceph]

                                but task is already holding lock:
    ffff888100ed4070 (&mdsc->mutex){+.+.}-{3:3}, at: ceph_mdsc_sync+0x14b/0x670 [ceph]

                                which lock already depends on the new lock.

                                the existing dependency chain (in reverse order) is:

                                -> #1 (&mdsc->mutex){+.+.}-{3:3}:
           __mutex_lock+0x110/0xc40
           mds_dispatch+0x1376/0x2480 [ceph]
           ceph_con_process_message+0xd9/0x240 [libceph]
           process_message+0x1b/0x1f0 [libceph]
           ceph_con_v2_try_read+0x1ac7/0x2b70 [libceph]
           ceph_con_workfn+0x56a/0x910 [libceph]
           process_one_work+0x4e8/0x970
           worker_thread+0x2c6/0x650
           kthread+0x16c/0x1a0
           ret_from_fork+0x22/0x30

                                -> #0 (&s->s_mutex){+.+.}-{3:3}:
           __lock_acquire+0x1990/0x2ca0
           lock_acquire+0x15d/0x3e0
           __mutex_lock+0x110/0xc40
           send_flush_mdlog+0x4c/0x150 [ceph]
           ceph_mdsc_sync+0x2a7/0x670 [ceph]
           ceph_sync_fs+0x50/0xd0 [ceph]
           iterate_supers+0xbd/0x140
           ksys_sync+0x96/0xf0
           __do_sys_sync+0xa/0x10
           do_syscall_64+0x3b/0x90
           entry_SYSCALL_64_after_hwframe+0x44/0xae

                                other info that might help us debug this:
     Possible unsafe locking scenario:
           CPU0                    CPU1
           ----                    ----
      lock(&mdsc->mutex);
                                   lock(&s->s_mutex);
                                   lock(&mdsc->mutex);
      lock(&s->s_mutex);

                                 *** DEADLOCK ***
    2 locks held by fsstress/8647:
     #0: ffff888100ed00e0 (&type->s_umount_key#68){++++}-{3:3}, at: iterate_supers+0x93/0x140
     #1: ffff888100ed4070 (&mdsc->mutex){+.+.}-{3:3}, at: ceph_mdsc_sync+0x14b/0x670 [ceph]

                                stack backtrace:
    CPU: 9 PID: 8647 Comm: fsstress Tainted: G            E     5.18.0-rc2+ #237
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x56/0x6f
     check_noncircular+0x1b8/0x1e0
     ? print_circular_bug+0x110/0x110
     ? __lock_acquire+0x830/0x2ca0
     ? lockdep_lock+0x9f/0x140
     ? add_chain_block+0x1dc/0x280
     __lock_acquire+0x1990/0x2ca0
     ? lockdep_hardirqs_on_prepare+0x220/0x220
     lock_acquire+0x15d/0x3e0
     ? send_flush_mdlog+0x4c/0x150 [ceph]
     ? lock_release+0x410/0x410
     ? lock_acquire+0x16d/0x3e0
     ? lock_release+0x410/0x410
     __mutex_lock+0x110/0xc40
     ? send_flush_mdlog+0x4c/0x150 [ceph]
     ? preempt_count_sub+0x14/0xc0
     ? send_flush_mdlog+0x4c/0x150 [ceph]
     ? mutex_lock_io_nested+0xbc0/0xbc0
     ? mutex_lock_io_nested+0xbc0/0xbc0
     ? ceph_mdsc_sync+0x13a/0x670 [ceph]
     ? lock_downgrade+0x380/0x380
     ? send_flush_mdlog+0x4c/0x150 [ceph]
     send_flush_mdlog+0x4c/0x150 [ceph]
     ceph_mdsc_sync+0x2a7/0x670 [ceph]
     ? ceph_mdsc_pre_umount+0x280/0x280 [ceph]
     ? ceph_osdc_sync+0xdd/0x180 [libceph]
     ? vfs_fsync_range+0x100/0x100
     ceph_sync_fs+0x50/0xd0 [ceph]
     iterate_supers+0xbd/0x140
     ksys_sync+0x96/0xf0
     ? vfs_fsync+0xe0/0xe0
     ? lockdep_hardirqs_on_prepare+0x128/0x220
     ? syscall_enter_from_user_mode+0x21/0x70
     __do_sys_sync+0xa/0x10
     do_syscall_64+0x3b/0x90
     entry_SYSCALL_64_after_hwframe+0x44/0xae
    RIP: 0033:0x7f90ca30829b
    Code: c3 66 0f 1f 44 00 00 48 8b 15 89 1b 0f 00 f7 d8 64 89 02 b8 ff ff ff ff eb b8 0f 1f 44 00 00 f3 0f 1e fa b8 a2 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d 1b 0f 00 f7 d8 64 >
    RSP: 002b:00007ffd202a72b8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a2
    RAX: ffffffffffffffda RBX: 00000000000001f4 RCX: 00007f90ca30829b
    RDX: 0000000000000000 RSI: 000000007c9a84db RDI: 000000000000029e
    RBP: 028f5c28f5c28f5c R08: 000000000000007d R09: 00007ffd202a6ca7
    R10: 0000000000000000 R11: 0000000000000202 R12: 000000000000029e
    R13: 8f5c28f5c28f5c29 R14: 00000000004033c0 R15: 00007f90ca5676c0
     </TASK>
Apr 18 12:23:38 client1 kernel: libceph: mon0 (2)192.168.1.81:3300 session lost, hunting for new mon

Fixes: 7d8f9923957f77 (ceph: flush the mdlog for filesystem sync)
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

I found this while testing today. Xiubo, feel free to fold this into
7d8f9923957f77, so we avoid the regression.

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 94bd4dd956fd..ff38d0eac5c9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5099,7 +5099,7 @@ static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *md
 						 u64 want_tid)
 {
 	struct ceph_mds_request *req = NULL, *nextreq;
-	struct ceph_mds_session *last_session = NULL, *s;
+	struct ceph_mds_session *last_session = NULL;
 	struct rb_node *n;
 
 	mutex_lock(&mdsc->mutex);
@@ -5115,23 +5115,29 @@ static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *md
 			nextreq = NULL;
 		if (req->r_op != CEPH_MDS_OP_SETFILELOCK &&
 		    (req->r_op & CEPH_MDS_OP_WRITE)) {
+			struct ceph_mds_session *s;
+
 			/* write op */
 			ceph_mdsc_get_request(req);
 			if (nextreq)
 				ceph_mdsc_get_request(nextreq);
 
-			s = req->r_session;
+			s = ceph_get_mds_session(req->r_session);
 			if (!s) {
 				req = nextreq;
 				continue;
 			}
+			mutex_unlock(&mdsc->mutex);
+
 			/* send flush mdlog request to MDS */
 			if (last_session != s) {
 				send_flush_mdlog(s);
 				ceph_put_mds_session(last_session);
-				last_session = ceph_get_mds_session(s);
+				last_session = s;
+			} else {
+				ceph_put_mds_session(s);
 			}
-			mutex_unlock(&mdsc->mutex);
+
 			dout("%s wait on %llu (want %llu)\n", __func__,
 			     req->r_tid, want_tid);
 			wait_for_completion(&req->r_safe_completion);
-- 
2.35.1

