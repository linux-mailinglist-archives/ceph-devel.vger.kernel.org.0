Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7998E4BC5FF
	for <lists+ceph-devel@lfdr.de>; Sat, 19 Feb 2022 07:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiBSG3E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 19 Feb 2022 01:29:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiBSG3E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 19 Feb 2022 01:29:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFAA79F6C8
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 22:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645252124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+NsnBPhl8arH3F4TZU3nRg1wIATuDlYS10z1F34L8YE=;
        b=bM6H0GZybND8HigYLjx7lWRBVbGb8+OpTkzJoUJYp9pT9Gk2yHQpO8dV24nKgyJuXwA+T5
        dNhiBTf442d58Ge0vg+nKvp19h0calaHfNvJAfAMQbiLhsFZoH4U9Ia2UoSjc5Q2tcpjbo
        vo55o+N56BBXtstl82IOiLgEi2+1i3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-Dv0LEKtBOo6wMeIJc3lAnA-1; Sat, 19 Feb 2022 01:28:43 -0500
X-MC-Unique: Dv0LEKtBOo6wMeIJc3lAnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 235AC2F47;
        Sat, 19 Feb 2022 06:28:42 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 820724EC70;
        Sat, 19 Feb 2022 06:28:36 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: do not update snapshot context when there is no new snapshot
Date:   Sat, 19 Feb 2022 14:28:33 +0800
Message-Id: <20220219062833.30192-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

We will only track the uppest parent snapshot realm from which we
need to rebuild the snapshot contexts _downward_ in hierarchy. For
all the others having no new snapshot we will do nothing.

This fix will avoid calling ceph_queue_cap_snap() on some inodes
inappropriately. For example, with the code in mainline, suppose there
are 2 directory hierarchies (with 6 directories total), like this:

/dir_X1/dir_X2/dir_X3/
/dir_Y1/dir_Y2/dir_Y3/

Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then make a
root snapshot under /.snap/root_snap. Every time we make snapshots under
/dir_Y1/..., the kclient will always try to rebuild the snap context for
snap_X2 realm and finally will always try to queue cap snaps for dir_Y2
and dir_Y3, which makes no sense.

That's because the snap_X2's seq is 2 and root_snap's seq is 3. So when
creating a new snapshot under /dir_Y1/... the new seq will be 4, and
the mds will send the kclient a snapshot backtrace in _downward_
order: seqs 4, 3.

When ceph_update_snap_trace() is called, it will always rebuild the from
the last realm, that's the root_snap. So later when rebuilding the snap
context, the current logic will always cause it to rebuild the snap_X2
realm and then try to queue cap snaps for all the inodes related in that
realm, even though it's not necessary.

This is accompanied by a lot of these sorts of dout messages:

    "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"

Fix the logic to avoid this situation.

Also, the 'invalidate' word is not precise here. In actuality, it will
cause a rebuild of the existing snapshot contexts or just build
non-existant ones. Rename it to 'rebuild_snapcs'.

URL: https://tracker.ceph.com/issues/44100
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---



V3:
- Fixed the crash issue reproduced by Luís.




 fs/ceph/snap.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 32e246138793..25a29304b74d 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -736,7 +736,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	__le64 *prior_parent_snaps;        /* encoded */
 	struct ceph_snap_realm *realm = NULL;
 	struct ceph_snap_realm *first_realm = NULL;
-	int invalidate = 0;
+	struct ceph_snap_realm *realm_to_rebuild = NULL;
+	int rebuild_snapcs;
 	int err = -ENOMEM;
 	LIST_HEAD(dirty_realms);
 
@@ -744,6 +745,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
+	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
 	p += sizeof(*ri);
@@ -767,7 +769,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	err = adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
 	if (err < 0)
 		goto fail;
-	invalidate += err;
+	rebuild_snapcs += err;
 
 	if (le64_to_cpu(ri->seq) > realm->seq) {
 		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
@@ -792,22 +794,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 		if (realm->seq > mdsc->last_snap_seq)
 			mdsc->last_snap_seq = realm->seq;
 
-		invalidate = 1;
+		rebuild_snapcs = 1;
 	} else if (!realm->cached_context) {
 		dout("update_snap_trace %llx %p seq %lld new\n",
 		     realm->ino, realm, realm->seq);
-		invalidate = 1;
+		rebuild_snapcs = 1;
 	} else {
 		dout("update_snap_trace %llx %p seq %lld unchanged\n",
 		     realm->ino, realm, realm->seq);
 	}
 
-	dout("done with %llx %p, invalidated=%d, %p %p\n", realm->ino,
-	     realm, invalidate, p, e);
+	dout("done with %llx %p, rebuild_snapcs=%d, %p %p\n", realm->ino,
+	     realm, rebuild_snapcs, p, e);
 
-	/* invalidate when we reach the _end_ (root) of the trace */
-	if (invalidate && p >= e)
-		rebuild_snap_realms(realm, &dirty_realms);
+	/*
+	 * this will always track the uppest parent realm from which
+	 * we need to rebuild the snapshot contexts _downward_ in
+	 * hierarchy.
+	 */
+	if (rebuild_snapcs)
+		realm_to_rebuild = realm;
+
+	/* rebuild_snapcs when we reach the _end_ (root) of the trace */
+	if (realm_to_rebuild && p >= e)
+		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
 
 	if (!first_realm)
 		first_realm = realm;
-- 
2.27.0

