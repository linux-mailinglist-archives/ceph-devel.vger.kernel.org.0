Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB74A652E92
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Dec 2022 10:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbiLUJb2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Dec 2022 04:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiLUJb1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 21 Dec 2022 04:31:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8482AE82
        for <ceph-devel@vger.kernel.org>; Wed, 21 Dec 2022 01:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671615044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Zqhrg1RnxM1wYr09Yf1gC5swRXkriwdKmEmMal6ZVdI=;
        b=WeakOZvIzlOv7NSo56zu+P1TT2zimXoubTE/06zLVYfe0HJ8dcnvnBz5MBEFq3Ytuj5S0a
        0wG70K+vpsMMJsf/4ybQy73hRh4iWKi76De5BZkMm6RXfx4bfCBXpD2I/hS+kIunA02Lw7
        F6VlhXbN4wtCeUUXHQmFP14OugM6Lok=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-Qq2aVy58OnGhCn4rhcJXEA-1; Wed, 21 Dec 2022 04:30:41 -0500
X-MC-Unique: Qq2aVy58OnGhCn4rhcJXEA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FD8E10113C1;
        Wed, 21 Dec 2022 09:30:40 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0F37492B02;
        Wed, 21 Dec 2022 09:30:37 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, lhenriques@suse.de,
        vshankar@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: drop the messages from MDS when unmouting
Date:   Wed, 21 Dec 2022 17:30:31 +0800
Message-Id: <20221221093031.132792-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When unmounting it will just wait for the inflight requests to be
finished, but just before the sessions are closed the kclient still
could receive the caps/snaps/lease/quota msgs from MDS. All these
msgs need to hold some inodes, which will cause ceph_kill_sb() failing
to evict the inodes in time.

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

URL: https://tracker.ceph.com/issues/58126
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Fix it in ceph layer.


 fs/ceph/caps.c       |  3 +++
 fs/ceph/mds_client.c |  5 ++++-
 fs/ceph/mds_client.h |  7 ++++++-
 fs/ceph/quota.c      |  3 +++
 fs/ceph/snap.c       |  3 +++
 fs/ceph/super.c      | 14 ++++++++++++++
 6 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 15d9e0f0d65a..e8a53aeb2a8c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4222,6 +4222,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 
 	dout("handle_caps from mds%d\n", session->s_mds);
 
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
+		return;
+
 	/* decode */
 	end = msg->front.iov_base + msg->front.iov_len;
 	if (msg->front.iov_len < sizeof(*h))
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d41ab68f0130..1ad85af49b45 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4869,6 +4869,9 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 
 	dout("handle_lease from mds%d\n", mds);
 
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
+		return;
+
 	/* decode */
 	if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
 		goto bad;
@@ -5262,7 +5265,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
 void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 {
 	dout("pre_umount\n");
-	mdsc->stopping = 1;
+	mdsc->stopping = CEPH_MDSC_STOPPING_BEGAIN;
 
 	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
 	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 81a1f9a4ac3b..56f9d8077068 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -398,6 +398,11 @@ struct cap_wait {
 	int			want;
 };
 
+enum {
+	CEPH_MDSC_STOPPING_BEGAIN = 1,
+	CEPH_MDSC_STOPPING_FLUSHED = 2,
+};
+
 /*
  * mds client state
  */
@@ -414,7 +419,7 @@ struct ceph_mds_client {
 	struct ceph_mds_session **sessions;    /* NULL for mds if no session */
 	atomic_t		num_sessions;
 	int                     max_sessions;  /* len of sessions array */
-	int                     stopping;      /* true if shutting down */
+	int                     stopping;      /* the stage of shutting down */
 
 	atomic64_t		quotarealms_count; /* # realms with quota */
 	/*
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 64592adfe48f..f5819fc31d28 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -47,6 +47,9 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
+		return;
+
 	if (msg->front.iov_len < sizeof(*h)) {
 		pr_err("%s corrupt message mds%d len %d\n", __func__,
 		       session->s_mds, (int)msg->front.iov_len);
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index a73943e51a77..eeabdd0211d8 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -1010,6 +1010,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	int locked_rwsem = 0;
 	bool close_sessions = false;
 
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
+		return;
+
 	/* decode */
 	if (msg->front.iov_len < sizeof(*h))
 		goto bad;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f10a076f47e5..012b35be41a9 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1483,6 +1483,20 @@ static void ceph_kill_sb(struct super_block *s)
 	ceph_mdsc_pre_umount(fsc->mdsc);
 	flush_fs_workqueues(fsc);
 
+	/*
+	 * Though the kill_anon_super() will finally trigger the
+	 * sync_filesystem() anyway, we still need to do it here and
+	 * then bump the stage of shutdown. This will drop any further
+	 * message, which makes no sense any more, from MDSs.
+	 *
+	 * Without this when evicting the inodes it may fail in the
+	 * kill_anon_super(), which will trigger a warning when
+	 * destroying the fscrypt keyring and then possibly trigger
+	 * a further crash in ceph module when iput() the inodes.
+	 */
+	sync_filesystem(s);
+	fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
+
 	kill_anon_super(s);
 
 	fsc->client->extra_mon_dispatch = NULL;
-- 
2.31.1

