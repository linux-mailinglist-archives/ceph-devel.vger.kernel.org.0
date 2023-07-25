Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4485760702
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 06:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjGYEHV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 00:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjGYEHO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 00:07:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216BC19B
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690257987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HgBiSX0PXpQHphBJb2zYmC8Y8fFUR8vcZ7Z08zZI5lY=;
        b=am7flIQksTaCHWKTrMXnjyPhgNMdmFAElk5hUp7M8HStPPnOVGBQHxhwfh6PS20e346zth
        VGj8M0IIww7r7u32PA0Qoq+5fGqjWo6/I6HmaEdsUK7PPEJ3/QrnVI7mthDTpRWKD5EFSU
        o9440WZkxXUmJrKQB/Ori5LEjA9BlrM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-689-o8vwuSAvOkC_fuQKX3PH3A-1; Tue, 25 Jul 2023 00:06:23 -0400
X-MC-Unique: o8vwuSAvOkC_fuQKX3PH3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BE3F1039655;
        Tue, 25 Jul 2023 04:06:23 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-127.pek2.redhat.com [10.72.12.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44F9E10E5E;
        Tue, 25 Jul 2023 04:06:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v3] ceph: defer stopping the mdsc delayed_work
Date:   Tue, 25 Jul 2023 12:03:59 +0800
Message-Id: <20230725040359.363444-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Flushing the dirty buffer may take a long time if the Rados is
overloaded or if there is network issue. So we should ping the
MDSs periodically to keep alive, else the MDS will blocklist
the kclient.

Cc: stable@vger.kernel.org
Cc: Venky Shankar <vshankar@redhat.com>
URL: https://tracker.ceph.com/issues/61843
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- Rebased to the master branch


 fs/ceph/mds_client.c |  4 ++--
 fs/ceph/mds_client.h |  5 +++++
 fs/ceph/super.c      | 10 ++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 66048a86c480..5fb367b1d4b0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4764,7 +4764,7 @@ static void delayed_work(struct work_struct *work)
 
 	dout("mdsc delayed_work\n");
 
-	if (mdsc->stopping)
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
 		return;
 
 	mutex_lock(&mdsc->mutex);
@@ -4943,7 +4943,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
 void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 {
 	dout("pre_umount\n");
-	mdsc->stopping = 1;
+	mdsc->stopping = CEPH_MDSC_STOPPING_BEGIN;
 
 	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
 	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 724307ff89cd..86d2965e68a1 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -380,6 +380,11 @@ struct cap_wait {
 	int			want;
 };
 
+enum {
+       CEPH_MDSC_STOPPING_BEGIN = 1,
+       CEPH_MDSC_STOPPING_FLUSHED = 2,
+};
+
 /*
  * mds client state
  */
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 3fc48b43cab0..a5f52013314d 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1374,6 +1374,16 @@ static void ceph_kill_sb(struct super_block *s)
 	ceph_mdsc_pre_umount(fsc->mdsc);
 	flush_fs_workqueues(fsc);
 
+	/*
+	 * Though the kill_anon_super() will finally trigger the
+	 * sync_filesystem() anyway, we still need to do it here
+	 * and then bump the stage of shutdown to stop the work
+	 * queue as earlier as possible.
+	 */
+	sync_filesystem(s);
+
+	fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
+
 	kill_anon_super(s);
 
 	fsc->client->extra_mon_dispatch = NULL;
-- 
2.39.1

