Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129302D498A
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 19:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbgLISyo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Dec 2020 13:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387434AbgLISyi (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 13:54:38 -0500
From:   Jeff Layton <jlayton@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, xiubli@redhat.com, idryomov@gmail.com
Subject: [PATCH 2/4] ceph: take a cred reference instead of tracking individual uid/gid
Date:   Wed,  9 Dec 2020 13:53:52 -0500
Message-Id: <20201209185354.29097-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209185354.29097-1-jlayton@kernel.org>
References: <20201209185354.29097-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Replace req->r_uid/r_gid with an r_cred pointer and take a reference to
that at the point where we previously would sample the two.  Use that to
populate the uid and gid in the header and release the reference when
the request is freed.

This should enable us to later add support for sending supplementary
group lists in MDS requests.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 8 ++++----
 fs/ceph/mds_client.h | 3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7d354d4e7933..1f1c5e490596 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -833,6 +833,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 	}
 	kfree(req->r_path1);
 	kfree(req->r_path2);
+	put_cred(req->r_cred);
 	if (req->r_pagelist)
 		ceph_pagelist_release(req->r_pagelist);
 	put_request_session(req);
@@ -888,8 +889,7 @@ static void __register_request(struct ceph_mds_client *mdsc,
 	ceph_mdsc_get_request(req);
 	insert_request(&mdsc->request_tree, req);
 
-	req->r_uid = current_fsuid();
-	req->r_gid = current_fsgid();
+	req->r_cred = get_current_cred();
 
 	if (mdsc->oldest_tid == 0 && req->r_op != CEPH_MDS_OP_SETFILELOCK)
 		mdsc->oldest_tid = req->r_tid;
@@ -2542,8 +2542,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 
 	head->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
 	head->op = cpu_to_le32(req->r_op);
-	head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
-	head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
+	head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_cred->fsuid));
+	head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_cred->fsgid));
 	head->ino = cpu_to_le64(req->r_deleg_ino);
 	head->args = req->r_args;
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index f5adbebcb38e..eaa7c5422116 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -275,8 +275,7 @@ struct ceph_mds_request {
 
 	union ceph_mds_request_args r_args;
 	int r_fmode;        /* file mode, if expecting cap */
-	kuid_t r_uid;
-	kgid_t r_gid;
+	const struct cred *r_cred;
 	int r_request_release_offset;
 	struct timespec64 r_stamp;
 
-- 
2.29.2

