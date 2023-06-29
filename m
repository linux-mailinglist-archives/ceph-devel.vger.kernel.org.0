Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01537741EC6
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Jun 2023 05:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjF2Diy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Jun 2023 23:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjF2Dix (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Jun 2023 23:38:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E78C0
        for <ceph-devel@vger.kernel.org>; Wed, 28 Jun 2023 20:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688009880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4ysiqyRGDJPv7mFwqkPDxDhYuunIT2meZ9lzoXm+YkI=;
        b=HU12pZR2asxPbbtnteZIbyFlUUK232r79v1oXoZ4tQf5oIef6nXlwgHDQndeoimJsplYvd
        DaQUseE3hP05NIkMPVYlMmh2wsP/iaj1RE5/sRV5+amwMQyNGM7mi4GXiV/3QJ1ozmzr3U
        xG9/bdEYpA3orvN21FOjuQY5S2NKbGI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-Ki5cCneHPT23ADHF_wKpZg-1; Wed, 28 Jun 2023 23:37:56 -0400
X-MC-Unique: Ki5cCneHPT23ADHF_wKpZg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 054B93806736;
        Thu, 29 Jun 2023 03:37:56 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-13-91.pek2.redhat.com [10.72.13.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42FAF111F3B0;
        Thu, 29 Jun 2023 03:37:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ceph: defer stopping the mdsc delayed_work
Date:   Thu, 29 Jun 2023 11:35:33 +0800
Message-Id: <20230629033533.270535-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Flushing the dirty buffer may take a long time if the Rados is
overloaded or if there is network issue. So we should ping the
MDSs perioudically to keep alive, else the MDS will blocklist
the kclient.

Cc: stable@vger.kernel.org
Cc: Venky Shankar <vshankar@redhat.com>
URL: https://tracker.ceph.com/issues/61843
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 2 +-
 fs/ceph/mds_client.h | 3 ++-
 fs/ceph/super.c      | 7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 65230ebefd51..70987b3c198a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5192,7 +5192,7 @@ static void delayed_work(struct work_struct *work)
 
 	doutc(mdsc->fsc->client, "mdsc delayed_work\n");
 
-	if (mdsc->stopping)
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
 		return;
 
 	mutex_lock(&mdsc->mutex);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 5d02c8c582fd..befbd384428e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -400,7 +400,8 @@ struct cap_wait {
 
 enum {
 	CEPH_MDSC_STOPPING_BEGIN = 1,
-	CEPH_MDSC_STOPPING_FLUSHED = 2,
+	CEPH_MDSC_STOPPING_FLUSHING = 2,
+	CEPH_MDSC_STOPPING_FLUSHED = 3,
 };
 
 /*
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 8e1e517a45db..fb694ba72955 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1488,7 +1488,7 @@ static int ceph_init_fs_context(struct fs_context *fc)
 static bool __inc_stopping_blocker(struct ceph_mds_client *mdsc)
 {
 	spin_lock(&mdsc->stopping_lock);
-	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED) {
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHING) {
 		spin_unlock(&mdsc->stopping_lock);
 		return false;
 	}
@@ -1501,7 +1501,7 @@ static void __dec_stopping_blocker(struct ceph_mds_client *mdsc)
 {
 	spin_lock(&mdsc->stopping_lock);
 	if (!atomic_dec_return(&mdsc->stopping_blockers) &&
-	    mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
+	    mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHING)
 		complete_all(&mdsc->stopping_waiter);
 	spin_unlock(&mdsc->stopping_lock);
 }
@@ -1562,7 +1562,7 @@ static void ceph_kill_sb(struct super_block *s)
 	sync_filesystem(s);
 
 	spin_lock(&mdsc->stopping_lock);
-	mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
+	mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHING;
 	wait = !!atomic_read(&mdsc->stopping_blockers);
 	spin_unlock(&mdsc->stopping_lock);
 
@@ -1576,6 +1576,7 @@ static void ceph_kill_sb(struct super_block *s)
 			pr_warn_client(cl, "umount was killed, %ld\n", timeleft);
 	}
 
+	mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
 	kill_anon_super(s);
 
 	fsc->client->extra_mon_dispatch = NULL;
-- 
2.40.1

