Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B80972D95B
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbjFMFgO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240266AbjFMFfi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:35:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642BE172A
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EOg8z4ddqZDCTf2dpJGIfz4l4A0IbGutLg3Q4VQpVFs=;
        b=MWJT81bFJSgcHYMpxesEoHXKpz8A8EGpeBvRgw+j2xqLCIGwflO2fktRd0ZIWe72eBd//U
        BcfDnawTxc/nJJ2JXdMuIfKTVVm7+GXeoYpumgMOTq7Vf2FIIzolkeac7vtEBPWB7Htylu
        HYNABz3Zk4z4HNVGIw8DoJ+hO9rjHO4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-lTmzxIFCMAKy6ygH6ze4PQ-1; Tue, 13 Jun 2023 01:31:41 -0400
X-MC-Unique: lTmzxIFCMAKy6ygH6ze4PQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B6B5811E86;
        Tue, 13 Jun 2023 05:31:40 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FFF51121314;
        Tue, 13 Jun 2023 05:31:36 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 68/71] ceph: just wait the osd requests' callbacks to finish when unmounting
Date:   Tue, 13 Jun 2023 13:24:21 +0800
Message-Id: <20230613052424.254540-69-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Reviewed-by: Milind Changire <mchangir@redhat.com>
Tested-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c  | 10 ++++++++++
 fs/ceph/super.c | 11 +++++++++++
 fs/ceph/super.h |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ca4dc6450887..d88e310d411a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -258,6 +258,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	}
 	netfs_subreq_terminated(subreq, err, false);
 	iput(req->r_inode);
+	ceph_dec_osd_stopping_blocker(fsc->mdsc);
 }
 
 static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
@@ -385,6 +386,10 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	} else {
 		osd_req_op_extent_osd_iter(req, 0, &iter);
 	}
+	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
+		err = -EIO;
+		goto out;
+	}
 	req->r_callback = finish_netfs_read;
 	req->r_priv = subreq;
 	req->r_inode = inode;
@@ -857,6 +862,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 	else
 		kfree(osd_data->pages);
 	ceph_osdc_put_request(req);
+	ceph_dec_osd_stopping_blocker(fsc->mdsc);
 }
 
 /*
@@ -1165,6 +1171,10 @@ static int ceph_writepages_start(struct address_space *mapping,
 		BUG_ON(len < ceph_fscrypt_page_offset(pages[locked_pages - 1]) +
 			     thp_size(pages[locked_pages - 1]) - offset);
 
+		if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
+			rc = -EIO;
+			goto release_folios;
+		}
 		req->r_callback = writepages_finish;
 		req->r_inode = inode;
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 48da49e21466..730140edb6f9 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1502,6 +1502,17 @@ void ceph_dec_mds_stopping_blocker(struct ceph_mds_client *mdsc)
 	__dec_stopping_blocker(mdsc);
 }
 
+/* For data IO requests */
+bool ceph_inc_osd_stopping_blocker(struct ceph_mds_client *mdsc)
+{
+	return __inc_stopping_blocker(mdsc);
+}
+
+void ceph_dec_osd_stopping_blocker(struct ceph_mds_client *mdsc)
+{
+	__dec_stopping_blocker(mdsc);
+}
+
 static void ceph_kill_sb(struct super_block *s)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(s);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 789b47c4e2b3..37e022cfe330 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1402,4 +1402,6 @@ extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc);
 bool ceph_inc_mds_stopping_blocker(struct ceph_mds_client *mdsc,
 			       struct ceph_mds_session *session);
 void ceph_dec_mds_stopping_blocker(struct ceph_mds_client *mdsc);
+bool ceph_inc_osd_stopping_blocker(struct ceph_mds_client *mdsc);
+void ceph_dec_osd_stopping_blocker(struct ceph_mds_client *mdsc);
 #endif /* _FS_CEPH_SUPER_H */
-- 
2.40.1

