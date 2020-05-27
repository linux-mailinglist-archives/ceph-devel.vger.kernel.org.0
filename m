Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCC11E34D9
	for <lists+ceph-devel@lfdr.de>; Wed, 27 May 2020 03:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgE0Bmy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 May 2020 21:42:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21354 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725801AbgE0Bmx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 May 2020 21:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590543771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=K1KsYEcgTjn66zGLZZTwenjGdPKvbO20HNDlCHcVFH4=;
        b=MEyNCNN8yRo2XCoqo0qyo1fvnwbSvT+YXmbug97SN2v9V+Cc38qi3RoN1hJTXwZ/7ktSJN
        XEKvdcN13u7tCsiOsLINKQReirVuKNsqeB34jgfzGPEpps3UJiHPGtV0zO7LxEqw25ofoc
        bk9BjftC4A2r21XQXQ7bizPCfyr6Wis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-dQIPu6G7NDeu00vb4MRvdw-1; Tue, 26 May 2020 21:42:47 -0400
X-MC-Unique: dQIPu6G7NDeu00vb4MRvdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 400DD835B50;
        Wed, 27 May 2020 01:42:46 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D0996106A;
        Wed, 27 May 2020 01:42:43 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 1/2] ceph: add ceph_async_put_cap_refs to avoid double lock and deadlock
Date:   Tue, 26 May 2020 21:42:35 -0400
Message-Id: <1590543756-26773-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1590543756-26773-1-git-send-email-xiubli@redhat.com>
References: <1590543756-26773-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In the ceph_check_caps() it may call the session->s_mutex lock/unlock
and in ceph_flush_snaps() it may call the mdsc->mutex lock/unlock. And
both of them called from ceph_mdsc_put_request(), which may under the
session or mdsc mutex lock/unlock pair already, we will hit the dead
lock or double lock issue.

There have some deadlock cases, like:
handle_forward()
...
mutex_lock(&mdsc->mutex)
...
ceph_mdsc_put_request()
  --> ceph_mdsc_release_request()
    --> ceph_put_cap_request()
      --> ceph_put_cap_refs()
        --> ceph_check_caps()
...
mutex_unlock(&mdsc->mutex)

And also there maybe has some double session lock cases, like:

send_mds_reconnect()
...
mutex_lock(&session->s_mutex);
...
  --> replay_unsafe_requests()
    --> ceph_mdsc_release_dir_caps()
      --> ceph_put_cap_refs()
        --> ceph_check_caps()
...
mutex_unlock(&session->s_mutex);

This patch will just delays to call them in a queue work to avoid
the dead lock and double lock issues.

URL: https://tracker.ceph.com/issues/45635
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 89 ++++++++++++++++++++++++++++++++++++++++++++--------
 fs/ceph/inode.c      |  3 ++
 fs/ceph/mds_client.c |  2 +-
 fs/ceph/super.h      |  5 +++
 4 files changed, 85 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 27c2e60..996bedb 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -9,6 +9,7 @@
 #include <linux/wait.h>
 #include <linux/writeback.h>
 #include <linux/iversion.h>
+#include <linux/bits.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -3007,19 +3008,15 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
 	return 0;
 }
 
-/*
- * Release cap refs.
- *
- * If we released the last ref on any given cap, call ceph_check_caps
- * to release (or schedule a release).
- *
- * If we are releasing a WR cap (from a sync write), finalize any affected
- * cap_snap, and wake up any waiters.
- */
-void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
+#define CAP_REF_LAST_BIT       0
+#define CAP_REF_FLUSHSNAPS_BIT 1
+#define CAP_REF_WAKE_BIT       2
+
+static int __ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 {
 	struct inode *inode = &ci->vfs_inode;
 	int last = 0, put = 0, flushsnaps = 0, wake = 0;
+	unsigned long flags = 0;
 
 	spin_lock(&ci->i_ceph_lock);
 	if (had & CEPH_CAP_PIN)
@@ -3073,13 +3070,79 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 	     last ? " last" : "", put ? " put" : "");
 
 	if (last)
-		ceph_check_caps(ci, 0, NULL);
+		set_bit(CAP_REF_LAST_BIT, &flags);
 	else if (flushsnaps)
-		ceph_flush_snaps(ci, NULL);
+		set_bit(CAP_REF_FLUSHSNAPS_BIT, &flags);
 	if (wake)
-		wake_up_all(&ci->i_cap_wq);
+		set_bit(CAP_REF_WAKE_BIT, &flags);
 	while (put-- > 0)
 		iput(inode);
+
+	return flags;
+}
+
+/*
+ * This is the bottow half of __ceph_put_cap_refs(), which
+ * may take the mdsc->mutex and session->s_mutex and this
+ * will be called in a queue work to void dead/double lock
+ * issues if called from ceph_mdsc_put_request().
+ */
+static void __ceph_put_cap_refs_bh(struct ceph_inode_info *ci,
+				   unsigned long flags)
+{
+	if (test_bit(CAP_REF_LAST_BIT, &flags))
+		ceph_check_caps(ci, 0, NULL);
+	else if (test_bit(CAP_REF_FLUSHSNAPS_BIT, &flags))
+		ceph_flush_snaps(ci, NULL);
+	if (test_bit(CAP_REF_WAKE_BIT, &flags))
+		wake_up_all(&ci->i_cap_wq);
+}
+
+/*
+ * Release cap refs.
+ *
+ * If we released the last ref on any given cap, call ceph_check_caps
+ * to release (or schedule a release).
+ *
+ * If we are releasing a WR cap (from a sync write), finalize any affected
+ * cap_snap, and wake up any waiters.
+ */
+void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
+{
+	unsigned long flags;
+
+	flags = __ceph_put_cap_refs(ci, had);
+	__ceph_put_cap_refs_bh(ci, flags);
+}
+
+void ceph_async_put_cap_refs_work(struct work_struct *work)
+{
+	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
+						  put_cap_refs_work);
+	unsigned long flags;
+
+	spin_lock(&ci->i_ceph_lock);
+	flags = xchg(&ci->pending_put_flags, 0);
+	spin_unlock(&ci->i_ceph_lock);
+	if (!flags)
+		return;
+
+	__ceph_put_cap_refs_bh(ci, flags);
+}
+
+void ceph_async_put_cap_refs(struct ceph_inode_info *ci, int had)
+{
+	struct inode *inode = &ci->vfs_inode;
+	unsigned long flags;
+
+	flags = __ceph_put_cap_refs(ci, had);
+
+	spin_lock(&ci->i_ceph_lock);
+	ci->pending_put_flags |= flags;
+	spin_unlock(&ci->i_ceph_lock);
+
+	queue_work(ceph_inode_to_client(inode)->inode_wq,
+		   &ci->put_cap_refs_work);
 }
 
 /*
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 357c937..e0ea508 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -517,6 +517,9 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ci->i_snap_realm_item);
 	INIT_LIST_HEAD(&ci->i_snap_flush_item);
 
+	INIT_WORK(&ci->put_cap_refs_work, ceph_async_put_cap_refs_work);
+	ci->pending_put_flags = 0;
+
 	INIT_WORK(&ci->i_work, ceph_inode_work);
 	ci->i_work_mask = 0;
 	memset(&ci->i_btime, '\0', sizeof(ci->i_btime));
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0e0ab01..12506b7 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3398,7 +3398,7 @@ void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req)
 	dcaps = xchg(&req->r_dir_caps, 0);
 	if (dcaps) {
 		dout("releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
-		ceph_put_cap_refs(ceph_inode(req->r_parent), dcaps);
+		ceph_async_put_cap_refs(ceph_inode(req->r_parent), dcaps);
 	}
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 226f19c..ece94fc 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -421,6 +421,9 @@ struct ceph_inode_info {
 	struct timespec64 i_btime;
 	struct timespec64 i_snap_btime;
 
+	struct work_struct put_cap_refs_work;
+	unsigned long pending_put_flags;
+
 	struct work_struct i_work;
 	unsigned long  i_work_mask;
 
@@ -1095,6 +1098,8 @@ extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,
 				bool snap_rwsem_locked);
 extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
 extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
+extern void ceph_async_put_cap_refs(struct ceph_inode_info *ci, int had);
+extern void ceph_async_put_cap_refs_work(struct work_struct *work);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				       struct ceph_snap_context *snapc);
 extern void ceph_flush_snaps(struct ceph_inode_info *ci,
-- 
1.8.3.1

