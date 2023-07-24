Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66ED175EE27
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jul 2023 10:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjGXIpt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jul 2023 04:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjGXIpo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jul 2023 04:45:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125F51713
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 01:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690188278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gNjGyOHGg8yaH5XTgDLdljIb7kIAm6Nyzars9q4XRto=;
        b=alzBGSYsthfA8gjLjLxsE6fjS4pVOPiXud5nVS8+adUtAlNiCN0GRCDihEQiZYdv5j8nSg
        TuXcWTrjFkVyRIaUgIyyPj3uoywHKJ1uff1VboZiEmFwuUJFTR6xSVFUD6+n1vb7XZehN8
        VZIUdHKlNm8GEgY9V5FeM1YlfJuLoqU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-WkbNCUomNoWgkPaFdmekTA-1; Mon, 24 Jul 2023 04:44:37 -0400
X-MC-Unique: WkbNCUomNoWgkPaFdmekTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2ECA10504AA;
        Mon, 24 Jul 2023 08:44:36 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-127.pek2.redhat.com [10.72.12.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 763954094DC0;
        Mon, 24 Jul 2023 08:44:33 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] ceph: defer stopping the mdsc delayed_work
Date:   Mon, 24 Jul 2023 16:42:14 +0800
Message-Id: <20230724084214.321005-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

V2:
- Fixed a typo in commit comment, thanks Milind.


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
index 0a370852cf02..49fd17fbba9f 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1477,7 +1477,7 @@ static int ceph_init_fs_context(struct fs_context *fc)
 static bool __inc_stopping_blocker(struct ceph_mds_client *mdsc)
 {
 	spin_lock(&mdsc->stopping_lock);
-	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED) {
+	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHING) {
 		spin_unlock(&mdsc->stopping_lock);
 		return false;
 	}
@@ -1490,7 +1490,7 @@ static void __dec_stopping_blocker(struct ceph_mds_client *mdsc)
 {
 	spin_lock(&mdsc->stopping_lock);
 	if (!atomic_dec_return(&mdsc->stopping_blockers) &&
-	    mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
+	    mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHING)
 		complete_all(&mdsc->stopping_waiter);
 	spin_unlock(&mdsc->stopping_lock);
 }
@@ -1551,7 +1551,7 @@ static void ceph_kill_sb(struct super_block *s)
 	sync_filesystem(s);
 
 	spin_lock(&mdsc->stopping_lock);
-	mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
+	mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHING;
 	wait = !!atomic_read(&mdsc->stopping_blockers);
 	spin_unlock(&mdsc->stopping_lock);
 
@@ -1565,6 +1565,7 @@ static void ceph_kill_sb(struct super_block *s)
 			pr_warn_client(cl, "umount was killed, %ld\n", timeleft);
 	}
 
+	mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
 	kill_anon_super(s);
 
 	fsc->client->extra_mon_dispatch = NULL;
-- 
2.40.1

