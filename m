Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8396422EC
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Dec 2022 07:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiLEGQT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Dec 2022 01:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiLEGQS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Dec 2022 01:16:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABC21117E
        for <ceph-devel@vger.kernel.org>; Sun,  4 Dec 2022 22:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670220923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WYpChL7GKa3f/mbGcsa78Y6HNzeeW+i9xuzFhMaiRqQ=;
        b=hNaaH4l5YAnEOAcMqcmpu2v8rMpmXGdhplpxn+hxD7xIpNkS3EV+DMj8TnDBwZPKhYNZPp
        1m0bpaK26aRn0W+U3lBaHBM51N0Z6NYD7seylQBdFaLFcwfKfWXLVKIPAKzdjlhVchYleJ
        d7vRZ2OQrBQr3K2BUlByHOooYYRASgk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-o0bVh7L-MxSicfDj7iTJ1A-1; Mon, 05 Dec 2022 01:15:21 -0500
X-MC-Unique: o0bVh7L-MxSicfDj7iTJ1A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AA5C85A59D;
        Mon,  5 Dec 2022 06:15:21 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11E63140EBF3;
        Mon,  5 Dec 2022 06:15:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: blocklist the kclient when receiving corrupt snap trace
Date:   Mon,  5 Dec 2022 14:15:14 +0800
Message-Id: <20221205061514.50423-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

When received corrupted snap trace we don't know what exactly has
happened in MDS side. And we shouldn't continue writing to OSD,
which may corrupt the snapshot contents.

Just try to blocklist this client and If fails we need to crash the
client instead of leaving it writeable to OSDs.

URL: https://tracker.ceph.com/issues/57686
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c |  3 ++-
 fs/ceph/mds_client.h |  1 +
 fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index cbbaf334b6b8..59094944af28 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct ceph_connection *con)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 
 	pr_warn("mds%d closed our session\n", s->s_mds);
-	send_mds_reconnect(mdsc, s);
+	if (!mdsc->no_reconnect)
+		send_mds_reconnect(mdsc, s);
 }
 
 static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 728b7d72bf76..8e8f0447c0ad 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -413,6 +413,7 @@ struct ceph_mds_client {
 	atomic_t		num_sessions;
 	int                     max_sessions;  /* len of sessions array */
 	int                     stopping;      /* true if shutting down */
+	int                     no_reconnect;  /* true if snap trace is corrupted */
 
 	atomic64_t		quotarealms_count; /* # realms with quota */
 	/*
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index c1c452afa84d..5b211ec7d7f7 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
+	struct ceph_client *client = mdsc->fsc->client;
 	int rebuild_snapcs;
 	int err = -ENOMEM;
+	int ret;
 	LIST_HEAD(dirty_realms);
 
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
@@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	if (first_realm)
 		ceph_put_snap_realm(mdsc, first_realm);
 	pr_err("%s error %d\n", __func__, err);
+
+	/*
+	 * When received corrupted snap trace we don't know what
+	 * exactly has happened in MDS side. And we shouldn't continue
+	 * writing to OSD, which may corrupt the snapshot contents.
+	 *
+	 * Just try to blocklist this client and if fails we need to
+	 * crash the client instead of leaving it writeable to OSDs.
+	 *
+	 * Then this kclient must be remounted to continue after the
+	 * corrupted metadata fixed in MDS side.
+	 */
+	mdsc->no_reconnect = 1;
+	ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
+	if (ret) {
+		pr_err("%s blocklist of %s failed: %d", __func__,
+		       ceph_pr_addr(&client->msgr.inst.addr), ret);
+		BUG();
+	}
+	pr_err("%s %s was blocklisted, do remount to continue%s",
+	       __func__, ceph_pr_addr(&client->msgr.inst.addr),
+	       err == -EIO ? " after corrupted snaptrace fixed": "");
+
 	return err;
 }
 
-- 
2.31.1

