Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933123D0A9E
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Jul 2021 10:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbhGUHss (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Jul 2021 03:48:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235945AbhGUHrR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 03:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626856074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4wHsODV3aPV+70T9+Ft7epkH8xaG/LhdbBbvmkWbuVk=;
        b=DHiK7oOBtPx/+aPdpIDEFYGDJz85FGteVWq+EX+aUMSrBIGj5w7SOJq3c4E3gFwU+xF5S3
        8mzZ8PNLVV/GC46XH16MjuqjvuAB4qSCpz35yPiS9/3mfrRlROgzJEyL0GKrJqVRHtOFjt
        u0rZsNn/p5iNz1PiGIh/4q7pBhisZk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-JbOVW6zbNs6j2WAokPDKPw-1; Wed, 21 Jul 2021 04:27:52 -0400
X-MC-Unique: JbOVW6zbNs6j2WAokPDKPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0314190B2BF;
        Wed, 21 Jul 2021 08:27:30 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8E2A60BF1;
        Wed, 21 Jul 2021 08:27:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH RFC] ceph: flush the delayed caps in time
Date:   Wed, 21 Jul 2021 16:27:20 +0800
Message-Id: <20210721082720.110202-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The delayed_work will be executed per 5 seconds, during this time
the cap_delay_list may accumulate thounsands of caps need to flush,
this will make the MDS's dispatch queue be full and need a very long
time to handle them. And if there has some other operations, likes
a rmdir request, it will be add in the tail of dispath queue and
need to wait for several or tens of seconds.

In client side we shouldn't queue to many of the cap requests and
flush them if there has more than 100 items.

URL: https://tracker.ceph.com/issues/51734
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 21 ++++++++++++++++++++-
 fs/ceph/mds_client.c |  3 ++-
 fs/ceph/mds_client.h |  3 +++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 4b966c29d9b5..064865761d2b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -507,6 +507,8 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
 static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
 				struct ceph_inode_info *ci)
 {
+	int num = 0;
+
 	dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
 	     ci->i_ceph_flags, ci->i_hold_caps_max);
 	if (!mdsc->stopping) {
@@ -515,12 +517,19 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
 			if (ci->i_ceph_flags & CEPH_I_FLUSH)
 				goto no_change;
 			list_del_init(&ci->i_cap_delay_list);
+			mdsc->num_cap_delay--;
 		}
 		__cap_set_timeouts(mdsc, ci);
 		list_add_tail(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
+		num = ++mdsc->num_cap_delay;
 no_change:
 		spin_unlock(&mdsc->cap_delay_lock);
 	}
+
+	if (num > 100) {
+		flush_delayed_work(&mdsc->delayed_work);
+		schedule_delayed(mdsc);
+	}
 }
 
 /*
@@ -531,13 +540,23 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
 static void __cap_delay_requeue_front(struct ceph_mds_client *mdsc,
 				      struct ceph_inode_info *ci)
 {
+	int num;
+
 	dout("__cap_delay_requeue_front %p\n", &ci->vfs_inode);
 	spin_lock(&mdsc->cap_delay_lock);
 	ci->i_ceph_flags |= CEPH_I_FLUSH;
-	if (!list_empty(&ci->i_cap_delay_list))
+	if (!list_empty(&ci->i_cap_delay_list)) {
 		list_del_init(&ci->i_cap_delay_list);
+		mdsc->num_cap_delay--;
+	}
 	list_add(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
+	num = ++mdsc->num_cap_delay;
 	spin_unlock(&mdsc->cap_delay_lock);
+
+	if (num > 100) {
+		flush_delayed_work(&mdsc->delayed_work);
+		schedule_delayed(mdsc);
+	}
 }
 
 /*
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 79aa4ce3a388..14e44de05812 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4514,7 +4514,7 @@ void inc_session_sequence(struct ceph_mds_session *s)
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
-static void schedule_delayed(struct ceph_mds_client *mdsc)
+void schedule_delayed(struct ceph_mds_client *mdsc)
 {
 	int delay = 5;
 	unsigned hz = round_jiffies_relative(HZ * delay);
@@ -4616,6 +4616,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	mdsc->request_tree = RB_ROOT;
 	INIT_DELAYED_WORK(&mdsc->delayed_work, delayed_work);
 	mdsc->last_renew_caps = jiffies;
+	mdsc->num_cap_delay = 0;
 	INIT_LIST_HEAD(&mdsc->cap_delay_list);
 	INIT_LIST_HEAD(&mdsc->cap_wait_list);
 	spin_lock_init(&mdsc->cap_delay_lock);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index a7af09257382..b4289b8d23ec 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -423,6 +423,7 @@ struct ceph_mds_client {
 	struct rb_root         request_tree;  /* pending mds requests */
 	struct delayed_work    delayed_work;  /* delayed work */
 	unsigned long    last_renew_caps;  /* last time we renewed our caps */
+	unsigned long    num_cap_delay;    /* caps in the cap_delay_list */
 	struct list_head cap_delay_list;   /* caps with delayed release */
 	spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
 	struct list_head snap_flush_list;  /* cap_snaps ready to flush */
@@ -568,6 +569,8 @@ extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
 			  struct ceph_mds_session *session,
 			  int max_caps);
 
+extern void schedule_delayed(struct ceph_mds_client *mdsc);
+
 static inline int ceph_wait_on_async_create(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
-- 
2.27.0

