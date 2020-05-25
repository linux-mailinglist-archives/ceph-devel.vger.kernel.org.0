Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092F91E0CAB
	for <lists+ceph-devel@lfdr.de>; Mon, 25 May 2020 13:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390127AbgEYLQq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 May 2020 07:16:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389897AbgEYLQp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 May 2020 07:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590405403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=v+9Dqn42XjvwBYmW7o9AicoD8x3gR4MLErRCHxp6WjQ=;
        b=E55JjVDIn92LN+5mswImDC/VVZvfF4CIeiUD+D9CgNKIOzBwfXM8fqJfALg8yBdrVnBnFk
        SUxQit/K38eZSPir7Oclj8Xnojrk5gBdOLHDSTuVOvBVj5Yoj08cbbZef2RmyzKbSwuKLv
        w2L+WDJQ4s9BTKxINTBBJwOBzusEkmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-Ev54q1JFP9eePIZzWHQsIQ-1; Mon, 25 May 2020 07:16:39 -0400
X-MC-Unique: Ev54q1JFP9eePIZzWHQsIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81C57800688;
        Mon, 25 May 2020 11:16:38 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62FA45C1BB;
        Mon, 25 May 2020 11:16:36 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] ceph: do not check the caps when reconnecting to mds
Date:   Mon, 25 May 2020 07:16:25 -0400
Message-Id: <1590405385-27406-3-git-send-email-xiubli@redhat.com>
In-Reply-To: <1590405385-27406-1-git-send-email-xiubli@redhat.com>
References: <1590405385-27406-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It make no sense to check the caps when reconnecting to mds.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 16 ++++++++++++++--
 fs/ceph/dir.c        |  2 +-
 fs/ceph/file.c       |  2 +-
 fs/ceph/mds_client.c | 14 ++++++++++----
 fs/ceph/mds_client.h |  3 ++-
 fs/ceph/super.h      |  2 ++
 6 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index aea66c1..1fcf0a9 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3016,7 +3016,8 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
  * If we are releasing a WR cap (from a sync write), finalize any affected
  * cap_snap, and wake up any waiters.
  */
-void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
+void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
+			 bool skip_checking_caps)
 {
 	struct inode *inode = &ci->vfs_inode;
 	int last = 0, put = 0, flushsnaps = 0, wake = 0;
@@ -3072,7 +3073,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
 	     last ? " last" : "", put ? " put" : "");
 
-	if (last)
+	if (last && !skip_checking_caps)
 		ceph_check_caps(ci, 0, NULL);
 	else if (flushsnaps)
 		ceph_flush_snaps(ci, NULL);
@@ -3082,6 +3083,16 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 		iput(inode);
 }
 
+void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
+{
+	__ceph_put_cap_refs(ci, had, false);
+}
+
+void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
+{
+	__ceph_put_cap_refs(ci, had, true);
+}
+
 void ceph_async_put_cap_refs_work(struct work_struct *work)
 {
 	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
@@ -3111,6 +3122,7 @@ void ceph_async_put_cap_refs(struct ceph_inode_info *ci, int had)
 	queue_work(ceph_inode_to_client(inode)->inode_wq,
 		   &ci->put_cap_refs_work);
 }
+
 /*
  * Release @nr WRBUFFER refs on dirty pages for the given @snapc snap
  * context.  Adjust per-snap dirty page accounting as appropriate.
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 39f5311..9f66ea5 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1079,7 +1079,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 	}
 out:
 	iput(req->r_old_inode);
-	ceph_mdsc_release_dir_caps(req);
+	ceph_mdsc_release_dir_caps(req, false);
 }
 
 static int get_caps_for_async_unlink(struct inode *dir, struct dentry *dentry)
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 160644d..812da94 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -565,7 +565,7 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
 			req->r_deleg_ino);
 	}
 out:
-	ceph_mdsc_release_dir_caps(req);
+	ceph_mdsc_release_dir_caps(req, false);
 }
 
 static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 40b31da..a784f0e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -804,7 +804,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 	struct ceph_mds_request *req = container_of(kref,
 						    struct ceph_mds_request,
 						    r_kref);
-	ceph_mdsc_release_dir_caps(req);
+	ceph_mdsc_release_dir_caps(req, false);
 	destroy_reply_info(&req->r_reply_info);
 	if (req->r_request)
 		ceph_msg_put(req->r_request);
@@ -3393,14 +3393,20 @@ static void handle_session(struct ceph_mds_session *session,
 	return;
 }
 
-void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req)
+void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req,
+				bool skip_checking_caps)
 {
 	int dcaps;
 
 	dcaps = xchg(&req->r_dir_caps, 0);
 	if (dcaps) {
 		dout("releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
-		ceph_async_put_cap_refs(ceph_inode(req->r_parent), dcaps);
+		if (skip_checking_caps)
+			ceph_put_cap_refs_no_check_caps(ceph_inode(req->r_parent),
+							dcaps);
+		else
+			ceph_async_put_cap_refs(ceph_inode(req->r_parent),
+						dcaps);
 	}
 }
 
@@ -3436,7 +3442,7 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
 		if (req->r_session->s_mds != session->s_mds)
 			continue;
 
-		ceph_mdsc_release_dir_caps(req);
+		ceph_mdsc_release_dir_caps(req, true);
 
 		__send_request(mdsc, session, req, true);
 	}
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 43111e4..73ee022 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -506,7 +506,8 @@ extern int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc,
 extern int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
 				struct inode *dir,
 				struct ceph_mds_request *req);
-extern void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req);
+extern void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req,
+				       bool skip_checking_caps);
 static inline void ceph_mdsc_get_request(struct ceph_mds_request *req)
 {
 	kref_get(&req->r_kref);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 01d206f..4e0b18a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1098,6 +1098,8 @@ extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,
 				bool snap_rwsem_locked);
 extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
 extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
+extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
+					    int had);
 extern void ceph_async_put_cap_refs(struct ceph_inode_info *ci, int had);
 extern void ceph_async_put_cap_refs_work(struct work_struct *work);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
-- 
1.8.3.1

