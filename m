Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B216DF2FC
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjDLLRa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDLLRU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:17:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536807AAE
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/iFv56XVYGliPNySSlKVvgKcaLwvtGXYrCQ9H02YzmQ=;
        b=SlD5QzYSHyVcuIPp3PE+GOHAMJB8FG9XzYtzvcqYMNc6PuawdH9MyIrIN3bmYdphN0hIQW
        8Gpouh9oHkxJxpPZRvzz7Cx7baeNozHrHpDj+XPkmdF85xV5Nn55UTGAE8wli6Q5JbER0a
        IZ6NJSXQJZGMfPVkWGtnbd2Hwg4DzzM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-GeIP29-wP2qKtKYUDSWecg-1; Wed, 12 Apr 2023 07:15:14 -0400
X-MC-Unique: GeIP29-wP2qKtKYUDSWecg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0A533813F3D;
        Wed, 12 Apr 2023 11:15:13 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06679C15BB8;
        Wed, 12 Apr 2023 11:15:08 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 67/71] libceph: defer removing the req from osdc just after req->r_callback
Date:   Wed, 12 Apr 2023 19:09:26 +0800
Message-Id: <20230412110930.176835-68-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-1-xiubli@redhat.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

URL: https://tracker.ceph.com/issues/58126
Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/osd_client.c | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 78b622178a3d..db3d93d3e692 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2507,7 +2507,7 @@ static void submit_request(struct ceph_osd_request *req, bool wrlocked)
 	__submit_request(req, wrlocked);
 }
 
-static void finish_request(struct ceph_osd_request *req)
+static void __finish_request(struct ceph_osd_request *req)
 {
 	struct ceph_osd_client *osdc = req->r_osdc;
 
@@ -2516,12 +2516,6 @@ static void finish_request(struct ceph_osd_request *req)
 
 	req->r_end_latency = ktime_get();
 
-	if (req->r_osd) {
-		ceph_init_sparse_read(&req->r_osd->o_sparse_read);
-		unlink_request(req->r_osd, req);
-	}
-	atomic_dec(&osdc->num_requests);
-
 	/*
 	 * If an OSD has failed or returned and a request has been sent
 	 * twice, it's possible to get a reply and end up here while the
@@ -2532,13 +2526,46 @@ static void finish_request(struct ceph_osd_request *req)
 	ceph_msg_revoke_incoming(req->r_reply);
 }
 
+static void __remove_request(struct ceph_osd_request *req)
+{
+	struct ceph_osd_client *osdc = req->r_osdc;
+
+	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
+
+	if (req->r_osd) {
+		ceph_init_sparse_read(&req->r_osd->o_sparse_read);
+		unlink_request(req->r_osd, req);
+	}
+	atomic_dec(&osdc->num_requests);
+}
+
+static void finish_request(struct ceph_osd_request *req)
+{
+	__finish_request(req);
+	__remove_request(req);
+}
+
 static void __complete_request(struct ceph_osd_request *req)
 {
+	struct ceph_osd_client *osdc = req->r_osdc;
+	struct ceph_osd *osd = req->r_osd;
+
 	dout("%s req %p tid %llu cb %ps result %d\n", __func__, req,
 	     req->r_tid, req->r_callback, req->r_result);
 
 	if (req->r_callback)
 		req->r_callback(req);
+
+	down_read(&osdc->lock);
+	if (osd) {
+		mutex_lock(&osd->lock);
+		__remove_request(req);
+		mutex_unlock(&osd->lock);
+	} else {
+		atomic_dec(&osdc->num_requests);
+	}
+	up_read(&osdc->lock);
+
 	complete_all(&req->r_completion);
 	ceph_osdc_put_request(req);
 }
@@ -3873,7 +3900,7 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 	WARN_ON(!(m.flags & CEPH_OSD_FLAG_ONDISK));
 	req->r_version = m.user_version;
 	req->r_result = m.result ?: data_len;
-	finish_request(req);
+	__finish_request(req);
 	mutex_unlock(&osd->lock);
 	up_read(&osdc->lock);
 
-- 
2.39.2

