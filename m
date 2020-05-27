Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8696B1E39B9
	for <lists+ceph-devel@lfdr.de>; Wed, 27 May 2020 08:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgE0G51 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 May 2020 02:57:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31181 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726025AbgE0G50 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 May 2020 02:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590562644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=5lf949QIBjvRfVl5V1phB/kav8uzWx/9oHyTb+GxinY=;
        b=V4beBDxCkiGYUZ9qi0qly5ffYyNQ7QmKTSNRlMhB70s+Cn4IBbhDPNf8r/hqWfL2yVMAxP
        QoIxwKDsK15Sxkf1NvPaSMdghSLij0Vv7tmLLqk/5yavPy0Fw3feDdFjEkcWyjTY+sGoTL
        9SJF+zOfNZHqemcJMozGvPr4ZTJFoNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-ixsGevlEOPC0ct9edW0Okw-1; Wed, 27 May 2020 02:57:20 -0400
X-MC-Unique: ixsGevlEOPC0ct9edW0Okw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0DFA1005510;
        Wed, 27 May 2020 06:57:19 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 666CC1A7D8;
        Wed, 27 May 2020 06:57:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4] ceph: skip checking the caps when session reconnecting and releasing reqs
Date:   Wed, 27 May 2020 02:57:14 -0400
Message-Id: <1590562634-29610-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It make no sense to check the caps when reconnecting to mds. And
for the async dirop caps, they will be put by its _cb() function,
so when releasing the requests, it will make no sense too.

URL: https://tracker.ceph.com/issues/45635
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V2:
- do not check the caps when reconnecting to mds
- switch ceph_async_check_caps() to ceph_async_put_cap_refs()

Changed in V3:
- fix putting the cap refs leak

Changed in V4:
- drop ceph_async_check_caps() stuff.


 fs/ceph/caps.c       | 15 +++++++++++++--
 fs/ceph/dir.c        |  2 +-
 fs/ceph/file.c       |  2 +-
 fs/ceph/mds_client.c | 14 ++++++++++----
 fs/ceph/mds_client.h |  3 ++-
 fs/ceph/super.h      |  2 ++
 6 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 62a066e..cea94cd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3016,7 +3016,8 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
  * If we are releasing a WR cap (from a sync write), finalize any affected
  * cap_snap, and wake up any waiters.
  */
-void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
+static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
+				bool skip_checking_caps)
 {
 	struct inode *inode = &ci->vfs_inode;
 	int last = 0, put = 0, wake = 0;
@@ -3072,7 +3073,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
 	     last ? " last" : "", put ? " put" : "");
 
-	if (last)
+	if (last && !skip_checking_caps)
 		ceph_check_caps(ci, 0, NULL);
 	if (wake)
 		wake_up_all(&ci->i_cap_wq);
@@ -3080,6 +3081,16 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
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
index 4999a4a..229bc5e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -804,7 +804,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 	struct ceph_mds_request *req = container_of(kref,
 						    struct ceph_mds_request,
 						    r_kref);
-	ceph_mdsc_release_dir_caps(req);
+	ceph_mdsc_release_dir_caps(req, true);
 	destroy_reply_info(&req->r_reply_info);
 	if (req->r_request)
 		ceph_msg_put(req->r_request);
@@ -3391,14 +3391,20 @@ static void handle_session(struct ceph_mds_session *session,
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
-		ceph_put_cap_refs(ceph_inode(req->r_parent), dcaps);
+		if (skip_checking_caps)
+			ceph_put_cap_refs_no_check_caps(ceph_inode(req->r_parent),
+							dcaps);
+		else
+			ceph_put_cap_refs(ceph_inode(req->r_parent),
+					  dcaps);
 	}
 }
 
@@ -3434,7 +3440,7 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
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
index 226f19c..5a6cdd3 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1095,6 +1095,8 @@ extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,
 				bool snap_rwsem_locked);
 extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
 extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
+extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
+					    int had);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				       struct ceph_snap_context *snapc);
 extern void ceph_flush_snaps(struct ceph_inode_info *ci,
-- 
1.8.3.1

