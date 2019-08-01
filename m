Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD5DD7E412
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfHAU0R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbfHAU0Q (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:26:16 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06052080C;
        Thu,  1 Aug 2019 20:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564691175;
        bh=p4CsUWSRZyq/rpts6dnbyJgEaqymmpri5IWTEPl/om8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwkEWFZVNx+7tfL8a4JIR3cahuoUcEmr9O8NHkMYinPETRHi1PWMJMBelQc5ZqYHh
         J9Kj69TCjbTYaUc8eX0H/a6POKNOqnAEiMFGGeKtrUaSuzDLdDHGnzTjnuZuYnXOir
         M6SonPOiWXCMw8oC40mi3lxsd8N1LllPwOyVmhTc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 9/9] ceph: add tracepoints for async and sync unlink
Date:   Thu,  1 Aug 2019 16:26:05 -0400
Message-Id: <20190801202605.18172-10-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801202605.18172-1-jlayton@kernel.org>
References: <20190801202605.18172-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

For now, they just show the parent inode info and dentry name.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c   |  3 +++
 fs/ceph/trace.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 2bd3e073249e..b318be1ff057 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -9,6 +9,7 @@
 
 #include "super.h"
 #include "mds_client.h"
+#include "trace.h"
 
 /*
  * Directory operations: readdir, lookup, create, link, unlink,
@@ -1154,6 +1155,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	    get_caps_for_async_unlink(dir, dentry)) {
 		dout("ceph: Async unlink on %lu/%.*s", dir->i_ino,
 		     dentry->d_name.len, dentry->d_name.name);
+		trace_ceph_async_unlink(dir, dentry);
 		req->r_callback = ceph_async_unlink_cb;
 		req->r_old_inode = d_inode(dentry);
 		ihold(req->r_old_inode);
@@ -1167,6 +1169,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 			d_delete(dentry);
 		}
 	} else {
+		trace_ceph_sync_unlink(dir, dentry);
 		set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 		err = ceph_mdsc_do_request(mdsc, dir, req);
 		if (!err && !req->r_reply_info.head->is_dentry)
diff --git a/fs/ceph/trace.h b/fs/ceph/trace.h
index d1cf4bb8a21d..48e65075e4e3 100644
--- a/fs/ceph/trace.h
+++ b/fs/ceph/trace.h
@@ -48,6 +48,37 @@ DEFINE_EVENT(ceph_cap_class, ceph_##name,       \
 DEFINE_CEPH_CAP_EVENT(add_cap);
 DEFINE_CEPH_CAP_EVENT(remove_cap);
 
+DECLARE_EVENT_CLASS(ceph_directory_class,
+		TP_PROTO(
+			const struct inode *dir,
+			const struct dentry *dentry
+		),
+		TP_ARGS(dir, dentry),
+		TP_STRUCT__entry(
+			__field(u64, ino)
+			__field(u64, snap)
+			__string(name, dentry->d_name.name)
+		),
+		TP_fast_assign(
+			__entry->ino = ceph_inode(dir)->i_vino.ino;
+			__entry->snap = ceph_inode(dir)->i_vino.snap;
+			__assign_str(name, dentry->d_name.name);
+		),
+		TP_printk(
+			"name=%s:0x%llx/%s",
+			show_snapid(__entry->snap), __entry->ino,
+			__get_str(name)
+		)
+);
+
+#define DEFINE_CEPH_DIRECTORY_EVENT(name)				\
+DEFINE_EVENT(ceph_directory_class, ceph_##name,				\
+	TP_PROTO(const struct inode *dir, const struct dentry *dentry),	\
+	TP_ARGS(dir, dentry))
+
+DEFINE_CEPH_DIRECTORY_EVENT(async_unlink);
+DEFINE_CEPH_DIRECTORY_EVENT(sync_unlink);
+
 #endif /* _CEPH_TRACE_H */
 
 #define TRACE_INCLUDE_PATH .
-- 
2.21.0

