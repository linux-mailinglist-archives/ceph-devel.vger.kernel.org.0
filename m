Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB4579F693
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Sep 2023 03:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbjINBzK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Sep 2023 21:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbjINBzJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Sep 2023 21:55:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8B11BCB;
        Wed, 13 Sep 2023 18:55:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A7AC433CA;
        Thu, 14 Sep 2023 01:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694656505;
        bh=LezNPFGAK/y+EDXzVgadFeemqrl+IUwRWAnyhs9Hge4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cotcmnEASJEL8LmX8fxkLO3tNyojHTbBmpz+Of2r1OA4e7eD7Ga5FzXnFviAkrrYQ
         xba3t91ZdOHIhi/xNEDEGhTKfh2GdYK1F0lOun7awEWf9b6y2uFp1qz8jcqzg81WCh
         i9wBA9HaAjKGBmGpr9cA86EvODyTYvTHBoRuL0erH74v06voqLycdnI40q6rqCf+WF
         E3Uh4g+M7zsIlPbSEUD6Q3UOpq5SAONS+/NNMgjjKIjDNIcFHLIeeCn5/wdYlnQPIu
         A040v0f/W3ouV0aEUWeH61jFW0DqcaeJGyCwTFU32pVSWE5DZCbBCELxO01VS0AO9m
         cSkQ8GytFOfew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Milind Changire <mchangir@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.5 2/7] ceph: drop messages from MDS when unmounting
Date:   Wed, 13 Sep 2023 21:54:46 -0400
Message-Id: <20230914015459.51740-2-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230914015459.51740-1-sashal@kernel.org>
References: <20230914015459.51740-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.5.3
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit e3dfcab2080dc1f9a4b09cc1327361bc2845bfcd ]

When unmounting all the dirty buffers will be flushed and after
the last osd request is finished the last reference of the i_count
will be released. Then it will flush the dirty cap/snap to MDSs,
and the unmounting won't wait the possible acks, which will ihold
the inodes when updating the metadata locally but makes no sense
any more, of this. This will make the evict_inodes() to skip these
inodes.

If encrypt is enabled the kernel generate a warning when removing
the encrypt keys when the skipped inodes still hold the keyring:

WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
generic_shutdown_super+0x47/0x120
kill_anon_super+0x14/0x30
ceph_kill_sb+0x36/0x90 [ceph]
deactivate_locked_super+0x29/0x60
cleanup_mnt+0xb8/0x140
task_work_run+0x67/0xb0
exit_to_user_mode_prepare+0x23d/0x240
syscall_exit_to_user_mode+0x25/0x60
do_syscall_64+0x40/0x80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fd83dc39e9b

Later the kernel will crash when iput() the inodes and dereferencing
the "sb->s_master_keys", which has been released by the
generic_shutdown_super().

Link: https://tracker.ceph.com/issues/59162
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-and-tested-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c       |  6 +++-
 fs/ceph/mds_client.c | 12 +++++--
 fs/ceph/mds_client.h | 11 +++++--
 fs/ceph/quota.c      | 14 ++++-----
 fs/ceph/snap.c       | 10 +++---
 fs/ceph/super.c      | 75 +++++++++++++++++++++++++++++++++++++++++---
 fs/ceph/super.h      |  3 ++
 7 files changed, 109 insertions(+), 22 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e2bb0d0072da5..c268bd07e7ddd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4105,6 +4105,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 
 	dout("handle_caps from mds%d\n", session->s_mds);
 
+	if (!ceph_inc_mds_stopping_blocker(mdsc, session))
+		return;
+
 	/* decode */
 	end = msg->front.iov_base + msg->front.iov_len;
 	if (msg->front.iov_len < sizeof(*h))
@@ -4201,7 +4204,6 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	     vino.snap, inode);
 
 	mutex_lock(&session->s_mutex);
-	inc_session_sequence(session);
 	dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
 	     (unsigned)seq);
 
@@ -4309,6 +4311,8 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 done_unlocked:
 	iput(inode);
 out:
+	ceph_dec_mds_stopping_blocker(mdsc);
+
 	ceph_put_string(extra_info.pool_ns);
 
 	/* Defer closing the sessions after s_mutex lock being released */
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 5fb367b1d4b06..4b0ba067e9c93 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4550,6 +4550,9 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 
 	dout("handle_lease from mds%d\n", mds);
 
+	if (!ceph_inc_mds_stopping_blocker(mdsc, session))
+		return;
+
 	/* decode */
 	if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
 		goto bad;
@@ -4568,8 +4571,6 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 	     dname.len, dname.name);
 
 	mutex_lock(&session->s_mutex);
-	inc_session_sequence(session);
-
 	if (!inode) {
 		dout("handle_lease no inode %llx\n", vino.ino);
 		goto release;
@@ -4631,9 +4632,13 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 out:
 	mutex_unlock(&session->s_mutex);
 	iput(inode);
+
+	ceph_dec_mds_stopping_blocker(mdsc);
 	return;
 
 bad:
+	ceph_dec_mds_stopping_blocker(mdsc);
+
 	pr_err("corrupt lease message\n");
 	ceph_msg_dump(msg);
 }
@@ -4829,6 +4834,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	}
 
 	init_completion(&mdsc->safe_umount_waiters);
+	spin_lock_init(&mdsc->stopping_lock);
+	atomic_set(&mdsc->stopping_blockers, 0);
+	init_completion(&mdsc->stopping_waiter);
 	init_waitqueue_head(&mdsc->session_close_wq);
 	INIT_LIST_HEAD(&mdsc->waiting_for_map);
 	mdsc->quotarealms_inodes = RB_ROOT;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 86d2965e68a1f..cff7392809032 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -381,8 +381,9 @@ struct cap_wait {
 };
 
 enum {
-       CEPH_MDSC_STOPPING_BEGIN = 1,
-       CEPH_MDSC_STOPPING_FLUSHED = 2,
+	CEPH_MDSC_STOPPING_BEGIN = 1,
+	CEPH_MDSC_STOPPING_FLUSHING = 2,
+	CEPH_MDSC_STOPPING_FLUSHED = 3,
 };
 
 /*
@@ -401,7 +402,11 @@ struct ceph_mds_client {
 	struct ceph_mds_session **sessions;    /* NULL for mds if no session */
 	atomic_t		num_sessions;
 	int                     max_sessions;  /* len of sessions array */
-	int                     stopping;      /* true if shutting down */
+
+	spinlock_t              stopping_lock;  /* protect snap_empty */
+	int                     stopping;      /* the stage of shutting down */
+	atomic_t                stopping_blockers;
+	struct completion	stopping_waiter;
 
 	atomic64_t		quotarealms_count; /* # realms with quota */
 	/*
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 64592adfe48fb..f7fcf7f08ec64 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -47,25 +47,23 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 
+	if (!ceph_inc_mds_stopping_blocker(mdsc, session))
+		return;
+
 	if (msg->front.iov_len < sizeof(*h)) {
 		pr_err("%s corrupt message mds%d len %d\n", __func__,
 		       session->s_mds, (int)msg->front.iov_len);
 		ceph_msg_dump(msg);
-		return;
+		goto out;
 	}
 
-	/* increment msg sequence number */
-	mutex_lock(&session->s_mutex);
-	inc_session_sequence(session);
-	mutex_unlock(&session->s_mutex);
-
 	/* lookup inode */
 	vino.ino = le64_to_cpu(h->ino);
 	vino.snap = CEPH_NOSNAP;
 	inode = ceph_find_inode(sb, vino);
 	if (!inode) {
 		pr_warn("Failed to find inode %llu\n", vino.ino);
-		return;
+		goto out;
 	}
 	ci = ceph_inode(inode);
 
@@ -78,6 +76,8 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
 	spin_unlock(&ci->i_ceph_lock);
 
 	iput(inode);
+out:
+	ceph_dec_mds_stopping_blocker(mdsc);
 }
 
 static struct ceph_quotarealm_inode *
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 343d738448dcd..7ddc6bad77ef3 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -1015,6 +1015,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	int locked_rwsem = 0;
 	bool close_sessions = false;
 
+	if (!ceph_inc_mds_stopping_blocker(mdsc, session))
+		return;
+
 	/* decode */
 	if (msg->front.iov_len < sizeof(*h))
 		goto bad;
@@ -1030,10 +1033,6 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	dout("%s from mds%d op %s split %llx tracelen %d\n", __func__,
 	     mds, ceph_snap_op_name(op), split, trace_len);
 
-	mutex_lock(&session->s_mutex);
-	inc_session_sequence(session);
-	mutex_unlock(&session->s_mutex);
-
 	down_write(&mdsc->snap_rwsem);
 	locked_rwsem = 1;
 
@@ -1151,6 +1150,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	up_write(&mdsc->snap_rwsem);
 
 	flush_snaps(mdsc);
+	ceph_dec_mds_stopping_blocker(mdsc);
 	return;
 
 bad:
@@ -1160,6 +1160,8 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	if (locked_rwsem)
 		up_write(&mdsc->snap_rwsem);
 
+	ceph_dec_mds_stopping_blocker(mdsc);
+
 	if (close_sessions)
 		ceph_mdsc_close_sessions(mdsc);
 	return;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index a5f52013314d6..281b493fdac8e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1365,25 +1365,90 @@ static int ceph_init_fs_context(struct fs_context *fc)
 	return -ENOMEM;
 }
 
+/*
+ * Return true if it successfully increases the blocker counter,
+ * or false if the mdsc is in stopping and flushed state.
+ */
+static bool __inc_stopping_blocker(struct ceph_mds_client *mdsc)
+{
+	spin_lock(&mdsc->stopping_lock);
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHING) {
+		spin_unlock(&mdsc->stopping_lock);
+		return false;
+	}
+	atomic_inc(&mdsc->stopping_blockers);
+	spin_unlock(&mdsc->stopping_lock);
+	return true;
+}
+
+static void __dec_stopping_blocker(struct ceph_mds_client *mdsc)
+{
+	spin_lock(&mdsc->stopping_lock);
+	if (!atomic_dec_return(&mdsc->stopping_blockers) &&
+	    mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHING)
+		complete_all(&mdsc->stopping_waiter);
+	spin_unlock(&mdsc->stopping_lock);
+}
+
+/* For metadata IO requests */
+bool ceph_inc_mds_stopping_blocker(struct ceph_mds_client *mdsc,
+				   struct ceph_mds_session *session)
+{
+	mutex_lock(&session->s_mutex);
+	inc_session_sequence(session);
+	mutex_unlock(&session->s_mutex);
+
+	return __inc_stopping_blocker(mdsc);
+}
+
+void ceph_dec_mds_stopping_blocker(struct ceph_mds_client *mdsc)
+{
+	__dec_stopping_blocker(mdsc);
+}
+
 static void ceph_kill_sb(struct super_block *s)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(s);
+	struct ceph_mds_client *mdsc = fsc->mdsc;
+	bool wait;
 
 	dout("kill_sb %p\n", s);
 
-	ceph_mdsc_pre_umount(fsc->mdsc);
+	ceph_mdsc_pre_umount(mdsc);
 	flush_fs_workqueues(fsc);
 
 	/*
 	 * Though the kill_anon_super() will finally trigger the
-	 * sync_filesystem() anyway, we still need to do it here
-	 * and then bump the stage of shutdown to stop the work
-	 * queue as earlier as possible.
+	 * sync_filesystem() anyway, we still need to do it here and
+	 * then bump the stage of shutdown. This will allow us to
+	 * drop any further message, which will increase the inodes'
+	 * i_count reference counters but makes no sense any more,
+	 * from MDSs.
+	 *
+	 * Without this when evicting the inodes it may fail in the
+	 * kill_anon_super(), which will trigger a warning when
+	 * destroying the fscrypt keyring and then possibly trigger
+	 * a further crash in ceph module when the iput() tries to
+	 * evict the inodes later.
 	 */
 	sync_filesystem(s);
 
-	fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
+	spin_lock(&mdsc->stopping_lock);
+	mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHING;
+	wait = !!atomic_read(&mdsc->stopping_blockers);
+	spin_unlock(&mdsc->stopping_lock);
+
+	if (wait && atomic_read(&mdsc->stopping_blockers)) {
+		long timeleft = wait_for_completion_killable_timeout(
+					&mdsc->stopping_waiter,
+					fsc->client->options->mount_timeout);
+		if (!timeleft) /* timed out */
+			pr_warn("umount timed out, %ld\n", timeleft);
+		else if (timeleft < 0) /* killed */
+			pr_warn("umount was killed, %ld\n", timeleft);
+	}
 
+	mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
 	kill_anon_super(s);
 
 	fsc->client->extra_mon_dispatch = NULL;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 3bfddf34d488b..e6c1edf9e12b0 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1375,4 +1375,7 @@ extern bool ceph_quota_update_statfs(struct ceph_fs_client *fsc,
 				     struct kstatfs *buf);
 extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc);
 
+bool ceph_inc_mds_stopping_blocker(struct ceph_mds_client *mdsc,
+			       struct ceph_mds_session *session);
+void ceph_dec_mds_stopping_blocker(struct ceph_mds_client *mdsc);
 #endif /* _FS_CEPH_SUPER_H */
-- 
2.40.1

