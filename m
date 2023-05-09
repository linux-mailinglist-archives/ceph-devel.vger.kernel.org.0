Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C706FC1F0
	for <lists+ceph-devel@lfdr.de>; Tue,  9 May 2023 10:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjEIIsV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 May 2023 04:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjEIIsU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 May 2023 04:48:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC3426AE
        for <ceph-devel@vger.kernel.org>; Tue,  9 May 2023 01:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683622047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6rz100gvD+9kWnqB/+VxDpxbl28zeJMmrgipmOew/zo=;
        b=Wa49gpHnkFLaPgxR0EqpnRdCzEiQgj2JvinjwV6DwwaOL4vdMh30fzoDFNyiewU2899ywi
        y04c+Z9t9RbAHxATjDnUonxhICDK7iE1feIChHjbneT/MrBoFe8HqrtywayX/i7DyL9dHA
        lzpI2LLNoqtjVoNjKS72XgOqnqjBAeU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-dAtVR2gYOKuQk_s4GSKlBA-1; Tue, 09 May 2023 04:47:26 -0400
X-MC-Unique: dAtVR2gYOKuQk_s4GSKlBA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46026857DE7;
        Tue,  9 May 2023 08:47:26 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-156.pek2.redhat.com [10.72.12.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 246D41121314;
        Tue,  9 May 2023 08:47:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: just wait the osd requests' callbacks to finish when unmounting
Date:   Tue,  9 May 2023 16:46:37 +0800
Message-Id: <20230509084637.213326-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The sync_filesystem() will flush all the dirty buffer and submit the
osd reqs to the osdc and then is blocked to wait for all the reqs to
finish. But the when the reqs' replies come, the reqs will be removed
from osdc just before the req->r_callback()s are called. Which means
the sync_filesystem() will be woke up by leaving the req->r_callback()s
are still running.

This will be buggy when the waiter require the req->r_callback()s to
release some resources before continuing. So we need to make sure the
req->r_callback()s are called before removing the reqs from the osdc.

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

We need to increase the blocker counter to make sure all the osd
requests' callbacks have been finished just before calling the
kill_anon_super() when unmounting.

URL: https://tracker.ceph.com/issues/58126
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

This is based ceph-client's testing branch and the fscrypt patches.


 fs/ceph/addr.c  |  4 ++++
 fs/ceph/super.c | 12 ++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 683ba9fbd590..eb89e3f2a416 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -272,6 +272,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	}
 	netfs_subreq_terminated(subreq, err, false);
 	iput(req->r_inode);
+	ceph_dec_stopping_blocker(fsc->mdsc);
 }
 
 static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
@@ -399,6 +400,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	} else {
 		osd_req_op_extent_osd_iter(req, 0, &iter);
 	}
+	ceph_inc_stopping_blocker(fsc->mdsc, NULL);
 	req->r_callback = finish_netfs_read;
 	req->r_priv = subreq;
 	req->r_inode = inode;
@@ -871,6 +873,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 	else
 		kfree(osd_data->pages);
 	ceph_osdc_put_request(req);
+	ceph_dec_stopping_blocker(fsc->mdsc);
 }
 
 /*
@@ -1179,6 +1182,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 		BUG_ON(len < ceph_fscrypt_page_offset(pages[locked_pages - 1]) +
 			     thp_size(pages[locked_pages - 1]) - offset);
 
+		ceph_inc_stopping_blocker(fsc->mdsc, NULL);
 		req->r_callback = writepages_finish;
 		req->r_inode = inode;
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index de2a45fa451a..c29d2ddd1a7b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1475,16 +1475,20 @@ static int ceph_init_fs_context(struct fs_context *fc)
 /*
  * Return true if mdsc successfully increase blocker counter,
  * or false if the mdsc is in stopping and flushed state.
+ *
+ * session: NULL then it's for osd requests or for mds requests.
  */
 bool ceph_inc_stopping_blocker(struct ceph_mds_client *mdsc,
 			       struct ceph_mds_session *session)
 {
-	mutex_lock(&session->s_mutex);
-	inc_session_sequence(session);
-	mutex_unlock(&session->s_mutex);
+	if (session) {
+		mutex_lock(&session->s_mutex);
+		inc_session_sequence(session);
+		mutex_unlock(&session->s_mutex);
+	}
 
 	spin_lock(&mdsc->stopping_lock);
-	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED) {
+	if (session && mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED) {
 		spin_unlock(&mdsc->stopping_lock);
 		return false;
 	}
-- 
2.40.0

