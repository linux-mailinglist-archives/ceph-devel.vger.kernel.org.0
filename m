Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A099673493C
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Jun 2023 01:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjFRXNZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 18 Jun 2023 19:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjFRXNY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 18 Jun 2023 19:13:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16897E42
        for <ceph-devel@vger.kernel.org>; Sun, 18 Jun 2023 16:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687129958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=O+7P5fF9xxCnln7LbHU/L6wZqiuLHZe9/xySCMVwwUU=;
        b=LQ7Onwf8VwYnjEGQTpigkVUTg7q0zeuk6oFdRrQjF6QtUXEIbMEH70BEmhx2075EL2D5i5
        P+GaEWhUUgYFZaorQXIQp4JuwEFuyyogYhEJ5HsKR/I2SN4OiVG+VtQS/JiC1fd2Xqo5s0
        wgMBOqfoSV55OrKRO00V5RLmPM+qBBo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-ptDLhnG0N5CFSe698r36iw-1; Sun, 18 Jun 2023 19:12:36 -0400
X-MC-Unique: ptDLhnG0N5CFSe698r36iw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8900C185A78F;
        Sun, 18 Jun 2023 23:12:36 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-38.pek2.redhat.com [10.72.12.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0502C1603B;
        Sun, 18 Jun 2023 23:12:33 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: issue a cap release immediately if no cap exists
Date:   Mon, 19 Jun 2023 07:10:11 +0800
Message-Id: <20230618231011.9077-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In case:

           mds                             client
                                - Releases cap and put Inode
  - Increase cap->seq and sends
    revokes req to the client
  - Receives release req and    - Receives & drops the revoke req
    skip removing the cap and
    then eval the CInode and
    issue or revoke caps again.
                                - Receives & drops the caps update
                                  or revoke req
  - Health warning for client
    isn't responding to
    mclientcaps(revoke)

All the IMPORT/REVOKE/GRANT cap ops will increase the session seq
in MDS side and then the client need to issue a cap release to
unblock MDS to remove the corresponding cap to unblock possible
waiters.

URL: https://tracker.ceph.com/issues/61332
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5498bc36c1e7..59ab5d905ac4 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4232,6 +4232,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	struct cap_extra_info extra_info = {};
 	bool queue_trunc;
 	bool close_sessions = false;
+	bool do_cap_release = false;
 
 	dout("handle_caps from mds%d\n", session->s_mds);
 
@@ -4349,17 +4350,14 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		else
 			dout(" i don't have ino %llx\n", vino.ino);
 
-		if (op == CEPH_CAP_OP_IMPORT) {
-			cap = ceph_get_cap(mdsc, NULL);
-			cap->cap_ino = vino.ino;
-			cap->queue_release = 1;
-			cap->cap_id = le64_to_cpu(h->cap_id);
-			cap->mseq = mseq;
-			cap->seq = seq;
-			cap->issue_seq = seq;
-			spin_lock(&session->s_cap_lock);
-			__ceph_queue_cap_release(session, cap);
-			spin_unlock(&session->s_cap_lock);
+		switch (op) {
+		case CEPH_CAP_OP_IMPORT:
+		case CEPH_CAP_OP_REVOKE:
+		case CEPH_CAP_OP_GRANT:
+			do_cap_release = true;
+			break;
+		default:
+			break;
 		}
 		goto flush_cap_releases;
 	}
@@ -4413,6 +4411,14 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 			pr_info("%s: no cap on %p ino %llx:%llx from mds%d for flush_ack!\n",
 				__func__, inode, ceph_ino(inode),
 				ceph_snap(inode), session->s_mds);
+		switch (op) {
+		case CEPH_CAP_OP_REVOKE:
+		case CEPH_CAP_OP_GRANT:
+			do_cap_release = true;
+			break;
+		default:
+			break;
+		}
 		goto flush_cap_releases;
 	}
 
@@ -4467,6 +4473,18 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	 * along for the mds (who clearly thinks we still have this
 	 * cap).
 	 */
+	if (do_cap_release) {
+		cap = ceph_get_cap(mdsc, NULL);
+		cap->cap_ino = vino.ino;
+		cap->queue_release = 1;
+		cap->cap_id = le64_to_cpu(h->cap_id);
+		cap->mseq = mseq;
+		cap->seq = seq;
+		cap->issue_seq = seq;
+		spin_lock(&session->s_cap_lock);
+		__ceph_queue_cap_release(session, cap);
+		spin_unlock(&session->s_cap_lock);
+	}
 	ceph_flush_cap_releases(mdsc, session);
 	goto done;
 
-- 
2.40.1

