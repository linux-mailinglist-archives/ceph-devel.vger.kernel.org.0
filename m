Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C9D1E34D8
	for <lists+ceph-devel@lfdr.de>; Wed, 27 May 2020 03:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgE0Bmx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 May 2020 21:42:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60051 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726746AbgE0Bmx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 May 2020 21:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590543772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=oGF2McV4P2uiaprz6DX1KR2eaJSeaaDqO6Atoj+Fq18=;
        b=AqpfzaYv6ksXLXpbdd+wDGJR8bzYlKuWXzQPoCTHGfxOyUxozIl2w7B6XKw1HEi73sCCsI
        eTtUoileB4hs1u53u1oS8LhDD9cP+BlnZrDNxQ+EAQQwJIZiWDFPwO7bR9mdRDeDBDTQwm
        bMpoeyiZDbGdYh89fkLjkp0Hwd9oW04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-8gd5SZGNNVuj3DDGVz84mg-1; Tue, 26 May 2020 21:42:49 -0400
X-MC-Unique: 8gd5SZGNNVuj3DDGVz84mg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC78C18FE860;
        Wed, 27 May 2020 01:42:48 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC71660C47;
        Wed, 27 May 2020 01:42:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/2] ceph: do not check the caps when reconnecting to mds
Date:   Tue, 26 May 2020 21:42:36 -0400
Message-Id: <1590543756-26773-3-git-send-email-xiubli@redhat.com>
In-Reply-To: <1590543756-26773-1-git-send-email-xiubli@redhat.com>
References: <1590543756-26773-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It make no sense to check the caps when reconnecting to mds.

URL: https://tracker.ceph.com/issues/45635
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       |  9 +++++++++
 fs/ceph/dir.c        |  2 +-
 fs/ceph/file.c       |  2 +-
 fs/ceph/mds_client.c | 14 ++++++++++----
 fs/ceph/mds_client.h |  3 ++-
 fs/ceph/super.h      |  2 ++
 6 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 996bedb..1d3301b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3115,6 +3115,15 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 	__ceph_put_cap_refs_bh(ci, flags);
 }
 
+void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
+{
+	unsigned long flags;
+
+	flags = __ceph_put_cap_refs(ci, had);
+	clear_bit(CAP_REF_LAST_BIT, &flags);
+	__ceph_put_cap_refs_bh(ci, flags);
+}
+
 void ceph_async_put_cap_refs_work(struct work_struct *work)
 {
 	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
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
index 12506b7..ec674f2 100644
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
-		ceph_async_put_cap_refs(ceph_inode(req->r_parent), dcaps);
+		if (skip_checking_caps)
+			ceph_put_cap_refs_no_check_caps(ceph_inode(req->r_parent),
+							dcaps);
+		else
+			ceph_async_put_cap_refs(ceph_inode(req->r_parent),
+						dcaps);
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
index ece94fc..5be5652 100644
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

