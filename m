Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660F93F6EB8
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 07:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhHYFPB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 01:15:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231873AbhHYFO7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 01:14:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629868453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sfdTLx+a2LW6CePNKM7IKpWZbhs7nigEAVeBQKkBqSA=;
        b=e5L4Qw0DUoWR2AxeggrH2rqwnI1vet00uMbcD8ZoMorxqtaQIFh+0vG7HQEnLQ6HEMgJKW
        K6QR+uoUiW8ahSuBmaTjD8EVgWhSr67BIsxuRsOS0o8WkQM23rGiNSf4uRZgAPS7rpCV+i
        4EO9LamP4G+p8q+cesgz3Qwu8MgBj/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-aFpZrewpMgyMbn5xbPB7Ow-1; Wed, 25 Aug 2021 01:14:11 -0400
X-MC-Unique: aFpZrewpMgyMbn5xbPB7Ow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3125801A92;
        Wed, 25 Aug 2021 05:14:10 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7665C3AC1;
        Wed, 25 Aug 2021 05:14:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 3/3] ceph: don't WARN if we're iterate removing the session caps
Date:   Wed, 25 Aug 2021 13:13:55 +0800
Message-Id: <20210825051355.5820-4-xiubli@redhat.com>
In-Reply-To: <20210825051355.5820-1-xiubli@redhat.com>
References: <20210825051355.5820-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For example in case force umounting it will remove all the session
caps one by one even it's dirty cap.

URL: https://tracker.ceph.com/issues/52295
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 39 ++++++++++++++++++++++++++++++---------
 fs/ceph/mds_client.c |  2 +-
 fs/ceph/super.h      |  1 +
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 557c610289fb..4f0dbc640b0b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1114,17 +1114,16 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 		return;
 	}
 
+	lockdep_assert_held(&ci->i_ceph_lock);
+
 	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
 
 	mdsc = ceph_inode_to_client(&ci->vfs_inode)->mdsc;
 
 	/* remove from inode's cap rbtree, and clear auth cap */
 	rb_erase(&cap->ci_node, &ci->i_caps);
-	if (ci->i_auth_cap == cap) {
-		WARN_ON_ONCE(!list_empty(&ci->i_dirty_item) &&
-			     !mdsc->fsc->blocklisted);
+	if (ci->i_auth_cap == cap)
 		ci->i_auth_cap = NULL;
-	}
 
 	/* remove from session list */
 	spin_lock(&session->s_cap_lock);
@@ -1176,6 +1175,28 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 	}
 }
 
+void ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
+{
+	struct ceph_inode_info *ci = cap->ci;
+	struct ceph_fs_client *fsc;
+
+	/* 'ci' being NULL means the remove have already occurred */
+	if (!ci) {
+		dout("%s: cap inode is NULL\n", __func__);
+		return;
+	}
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+	WARN_ON_ONCE(ci->i_auth_cap == cap &&
+		     !list_empty(&ci->i_dirty_item) &&
+		     !fsc->blocklisted &&
+		     READ_ONCE(fsc->mount_state) != CEPH_MOUNT_SHUTDOWN);
+
+	__ceph_remove_cap(cap, queue_release);
+}
+
 struct cap_msg_args {
 	struct ceph_mds_session	*session;
 	u64			ino, cid, follows;
@@ -1304,7 +1325,7 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
 	while (p) {
 		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
 		p = rb_next(p);
-		__ceph_remove_cap(cap, true);
+		ceph_remove_cap(cap, true);
 	}
 	spin_unlock(&ci->i_ceph_lock);
 }
@@ -3819,7 +3840,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		goto out_unlock;
 
 	if (target < 0) {
-		__ceph_remove_cap(cap, false);
+		ceph_remove_cap(cap, false);
 		goto out_unlock;
 	}
 
@@ -3854,7 +3875,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 				change_auth_cap_ses(ci, tcap->session);
 			}
 		}
-		__ceph_remove_cap(cap, false);
+		ceph_remove_cap(cap, false);
 		goto out_unlock;
 	} else if (tsession) {
 		/* add placeholder for the export tagert */
@@ -3871,7 +3892,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 			spin_unlock(&mdsc->cap_dirty_lock);
 		}
 
-		__ceph_remove_cap(cap, false);
+		ceph_remove_cap(cap, false);
 		goto out_unlock;
 	}
 
@@ -3982,7 +4003,7 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 					ocap->mseq, mds, le32_to_cpu(ph->seq),
 					le32_to_cpu(ph->mseq));
 		}
-		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
+		ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
 	}
 
 	*old_issued = issued;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 5831c7e137ee..a183a35e2805 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2010,7 +2010,7 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 
 	if (oissued) {
 		/* we aren't the only cap.. just remove us */
-		__ceph_remove_cap(cap, true);
+		ceph_remove_cap(cap, true);
 		(*remaining)--;
 	} else {
 		struct dentry *dentry;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 445d13d760d1..c1add4ed59d2 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1144,6 +1144,7 @@ extern void ceph_add_cap(struct inode *inode,
 			 unsigned cap, unsigned seq, u64 realmino, int flags,
 			 struct ceph_cap **new_cap);
 extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
+extern void ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
 extern void __ceph_remove_caps(struct ceph_inode_info *ci);
 extern void ceph_put_cap(struct ceph_mds_client *mdsc,
 			 struct ceph_cap *cap);
-- 
2.27.0

