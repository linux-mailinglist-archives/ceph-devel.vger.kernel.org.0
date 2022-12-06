Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CE6644333
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Dec 2022 13:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiLFMcg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Dec 2022 07:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiLFMc3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Dec 2022 07:32:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C54BFCB
        for <ceph-devel@vger.kernel.org>; Tue,  6 Dec 2022 04:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670329898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0R7NsQ2iiDGUy9tUoJFHYb24O0OlX231bmVxBzCU1so=;
        b=BlsagUXOLsXfU4PCrxxPhmF8hUx+w6w94R/klkYOodI52SHt0W3f++5lDoiL29/UnQBp2/
        EM3je8IB+TMCvXevXUCB4XqrZElDqcs531ZoQDz9dWPusMhEvzZ1TpIiDLjH+fz8UfplDo
        omihnwtHrEwYk0Y1qmqA4e5WaAnTiMw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-YliWdMdMNW2ptjA2nPxElg-1; Tue, 06 Dec 2022 07:31:35 -0500
X-MC-Unique: YliWdMdMNW2ptjA2nPxElg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAD83380390B;
        Tue,  6 Dec 2022 12:31:34 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4532A40C2064;
        Tue,  6 Dec 2022 12:31:31 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, atomlin@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: blocklist the kclient when receiving corrupted snap trace
Date:   Tue,  6 Dec 2022 20:31:17 +0800
Message-Id: <20221206123117.34015-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

V2:
- Switched to WARN() to taint the Linux kernel.


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
index c1c452afa84d..8d835590bad6 100644
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
+	 * When receiving a corrupted snap trace we don't know what
+	 * exactly has happened in MDS side. And we shouldn't continue
+	 * writing to OSD, which may corrupt the snapshot contents.
+	 *
+	 * Just try to blocklist this kclient and if it fails we need
+	 * to crash the kclient instead of leaving it writeable.
+	 *
+	 * Then this kclient must be remounted to continue after the
+	 * corrupted metadata fixed in the MDS side.
+	 */
+	mdsc->no_reconnect = 1;
+	ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
+	if (ret) {
+		pr_err("%s blocklist of %s failed: %d", __func__,
+		       ceph_pr_addr(&client->msgr.inst.addr), ret);
+		BUG();
+	}
+	WARN(1, "%s %s was blocklisted, do remount to continue%s",
+	     __func__, ceph_pr_addr(&client->msgr.inst.addr),
+	     err == -EIO ? " after corrupted snaptrace fixed": "");
+
 	return err;
 }
 
-- 
2.31.1

