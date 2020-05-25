Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55A01E0CAA
	for <lists+ceph-devel@lfdr.de>; Mon, 25 May 2020 13:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390115AbgEYLQn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 May 2020 07:16:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22935 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389897AbgEYLQn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 May 2020 07:16:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590405401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=VH1YUJ5RUWr/U8eQQWuNDywaK3q0gDj5oTLZbwU6tPk=;
        b=T/tTM2z05rt7iNtaLXsdCZZHu4CK4bdOYKEXcWjcmLTpLsPgMWifsWMqUhsShC44oL7N5N
        OjYB+8FN5Krbv9eOp6fN/E4cpvfLEpVhxlHtqX8VW/0mP2N1M9Z/0CO6C+ld1512BOP4cp
        2a0hZn81TVL8rnm07YKkmmIVhs49gbo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-nl2qTWi6NDyCaY8LjVqnbg-1; Mon, 25 May 2020 07:16:36 -0400
X-MC-Unique: nl2qTWi6NDyCaY8LjVqnbg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA248460;
        Mon, 25 May 2020 11:16:35 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB1045C1BB;
        Mon, 25 May 2020 11:16:33 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/2] ceph: add ceph_async_put_cap_refs to avoid double lock and deadlock
Date:   Mon, 25 May 2020 07:16:24 -0400
Message-Id: <1590405385-27406-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1590405385-27406-1-git-send-email-xiubli@redhat.com>
References: <1590405385-27406-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In the ceph_check_caps() it may call the session lock/unlock stuff.

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

URL: https://tracker.ceph.com/issues/45635
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 29 +++++++++++++++++++++++++++++
 fs/ceph/inode.c      |  3 +++
 fs/ceph/mds_client.c | 12 +++++++-----
 fs/ceph/super.h      |  5 +++++
 4 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 27c2e60..aea66c1 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3082,6 +3082,35 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 		iput(inode);
 }
 
+void ceph_async_put_cap_refs_work(struct work_struct *work)
+{
+	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
+						  put_cap_refs_work);
+	int caps;
+
+	spin_lock(&ci->i_ceph_lock);
+	caps = xchg(&ci->pending_put_caps, 0);
+	spin_unlock(&ci->i_ceph_lock);
+
+	ceph_put_cap_refs(ci, caps);
+}
+
+void ceph_async_put_cap_refs(struct ceph_inode_info *ci, int had)
+{
+	struct inode *inode = &ci->vfs_inode;
+
+	spin_lock(&ci->i_ceph_lock);
+	if (ci->pending_put_caps & had) {
+	        spin_unlock(&ci->i_ceph_lock);
+		return;
+	}
+
+	ci->pending_put_caps |= had;
+	spin_unlock(&ci->i_ceph_lock);
+
+	queue_work(ceph_inode_to_client(inode)->inode_wq,
+		   &ci->put_cap_refs_work);
+}
 /*
  * Release @nr WRBUFFER refs on dirty pages for the given @snapc snap
  * context.  Adjust per-snap dirty page accounting as appropriate.
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 357c937..303276a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -517,6 +517,9 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ci->i_snap_realm_item);
 	INIT_LIST_HEAD(&ci->i_snap_flush_item);
 
+	INIT_WORK(&ci->put_cap_refs_work, ceph_async_put_cap_refs_work);
+	ci->pending_put_caps = 0;
+
 	INIT_WORK(&ci->i_work, ceph_inode_work);
 	ci->i_work_mask = 0;
 	memset(&ci->i_btime, '\0', sizeof(ci->i_btime));
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0e0ab01..40b31da 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -811,12 +811,14 @@ void ceph_mdsc_release_request(struct kref *kref)
 	if (req->r_reply)
 		ceph_msg_put(req->r_reply);
 	if (req->r_inode) {
-		ceph_put_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
+		ceph_async_put_cap_refs(ceph_inode(req->r_inode),
+					CEPH_CAP_PIN);
 		/* avoid calling iput_final() in mds dispatch threads */
 		ceph_async_iput(req->r_inode);
 	}
 	if (req->r_parent) {
-		ceph_put_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
+		ceph_async_put_cap_refs(ceph_inode(req->r_parent),
+					CEPH_CAP_PIN);
 		ceph_async_iput(req->r_parent);
 	}
 	ceph_async_iput(req->r_target_inode);
@@ -831,8 +833,8 @@ void ceph_mdsc_release_request(struct kref *kref)
 		 * changed between the dir mutex being dropped and
 		 * this request being freed.
 		 */
-		ceph_put_cap_refs(ceph_inode(req->r_old_dentry_dir),
-				  CEPH_CAP_PIN);
+		ceph_async_put_cap_refs(ceph_inode(req->r_old_dentry_dir),
+					CEPH_CAP_PIN);
 		ceph_async_iput(req->r_old_dentry_dir);
 	}
 	kfree(req->r_path1);
@@ -3398,7 +3400,7 @@ void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req)
 	dcaps = xchg(&req->r_dir_caps, 0);
 	if (dcaps) {
 		dout("releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
-		ceph_put_cap_refs(ceph_inode(req->r_parent), dcaps);
+		ceph_async_put_cap_refs(ceph_inode(req->r_parent), dcaps);
 	}
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 226f19c..01d206f 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -421,6 +421,9 @@ struct ceph_inode_info {
 	struct timespec64 i_btime;
 	struct timespec64 i_snap_btime;
 
+	struct work_struct put_cap_refs_work;
+	int pending_put_caps;
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

