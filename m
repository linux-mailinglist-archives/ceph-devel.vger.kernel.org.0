Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C340913CE70
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 21:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgAOU7V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Jan 2020 15:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbgAOU7S (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 15:59:18 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1870124671;
        Wed, 15 Jan 2020 20:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579121957;
        bh=3djIca+LD0QGk9vR7OuTiPP6xKeETdAmcussQhwSZZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Vk3R6kOqD65RE9w2rT90rs2TY61DcnDdKBRlVXHVwvYjTnhfEnagWQY8hr4BwaH4
         uF5zgc2/XS+2W5JpT/TpEc0MowJw7K+h6QUyTEJPXN853n7wejTTPogUA8xam1idTG
         qyOydrNxfNqXaLuSe7dAm7er/H9RfAttNEu4ZbRo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [RFC PATCH v2 03/10] ceph: make dentry_lease_is_valid non-static
Date:   Wed, 15 Jan 2020 15:59:05 -0500
Message-Id: <20200115205912.38688-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115205912.38688-1-jlayton@kernel.org>
References: <20200115205912.38688-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...and move a comment over the proper function.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c   | 10 +++++-----
 fs/ceph/super.h |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 10294f07f5f0..9d2eca67985a 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1477,10 +1477,6 @@ void ceph_invalidate_dentry_lease(struct dentry *dentry)
 	spin_unlock(&dentry->d_lock);
 }
 
-/*
- * Check if dentry lease is valid.  If not, delete the lease.  Try to
- * renew if the least is more than half up.
- */
 static bool __dentry_lease_is_valid(struct ceph_dentry_info *di)
 {
 	struct ceph_mds_session *session;
@@ -1507,7 +1503,11 @@ static bool __dentry_lease_is_valid(struct ceph_dentry_info *di)
 	return false;
 }
 
-static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags)
+/*
+ * Check if dentry lease is valid.  If not, delete the lease.  Try to
+ * renew if the least is more than half up.
+ */
+int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags)
 {
 	struct ceph_dentry_info *di;
 	struct ceph_mds_session *session = NULL;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ec4d66d7c261..f27b2bf9a3f5 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1121,6 +1121,7 @@ extern int ceph_handle_snapdir(struct ceph_mds_request *req,
 extern struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
 					 struct dentry *dentry, int err);
 
+extern int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags);
 extern void __ceph_dentry_lease_touch(struct ceph_dentry_info *di);
 extern void __ceph_dentry_dir_lease_touch(struct ceph_dentry_info *di);
 extern void ceph_invalidate_dentry_lease(struct dentry *dentry);
-- 
2.24.1

