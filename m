Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE71B3EFEA6
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 10:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbhHRIGx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 04:06:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238550AbhHRIGw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 04:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629273978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iV43omn4WtYbGj+mfdeYJEwJuxttprsI88LphUoIjxo=;
        b=ZpFlgg9f60z0I7ZJ7rTZu/i69rrhLHcWIdmjSL+T9tXdusQChbzgGk1aoIyQFig4aVlpYl
        YCgxbEJ66887VnDl+N0ejVH7NLokgtGDYLRRM6Oap7Zj/cLtgaNM2g2+sQqKpQpQbjHEF2
        SNAAT0xicCpHUqRU6wAd/L0I4/SP7hA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-CnpADLOhMM2MFcKJdEgwNA-1; Wed, 18 Aug 2021 04:06:16 -0400
X-MC-Unique: CnpADLOhMM2MFcKJdEgwNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9201A1009608;
        Wed, 18 Aug 2021 08:06:15 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C0CB5C232;
        Wed, 18 Aug 2021 08:06:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/3] ceph: don't WARN if we're iterate removing the session caps
Date:   Wed, 18 Aug 2021 16:06:03 +0800
Message-Id: <20210818080603.195722-4-xiubli@redhat.com>
In-Reply-To: <20210818080603.195722-1-xiubli@redhat.com>
References: <20210818080603.195722-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For example in case force umounting it will remove all the session
caps one by one even it's dirty cap.

URL: https://tracker.ceph.com/issues/52295
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 15 ++++++++-------
 fs/ceph/mds_client.c |  4 ++--
 fs/ceph/super.h      |  3 ++-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7def99fbdca6..1ed9b9d57dd3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1101,7 +1101,7 @@ int ceph_is_any_caps(struct inode *inode)
  * caller should hold i_ceph_lock.
  * caller will not hold session s_mutex if called from destroy_inode.
  */
-void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
+void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release, bool warn)
 {
 	struct ceph_mds_session *session = cap->session;
 	struct ceph_inode_info *ci = cap->ci;
@@ -1121,7 +1121,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 	/* remove from inode's cap rbtree, and clear auth cap */
 	rb_erase(&cap->ci_node, &ci->i_caps);
 	if (ci->i_auth_cap == cap) {
-		WARN_ON_ONCE(!list_empty(&ci->i_dirty_item) &&
+		WARN_ON_ONCE(warn && !list_empty(&ci->i_dirty_item) &&
 			     !mdsc->fsc->blocklisted);
 		ci->i_auth_cap = NULL;
 	}
@@ -1304,7 +1304,7 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
 	while (p) {
 		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
 		p = rb_next(p);
-		__ceph_remove_cap(cap, true);
+		__ceph_remove_cap(cap, true, true);
 	}
 	spin_unlock(&ci->i_ceph_lock);
 }
@@ -3815,7 +3815,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		goto out_unlock;
 
 	if (target < 0) {
-		__ceph_remove_cap(cap, false);
+		__ceph_remove_cap(cap, false, true);
 		goto out_unlock;
 	}
 
@@ -3850,7 +3850,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 				change_auth_cap_ses(ci, tcap->session);
 			}
 		}
-		__ceph_remove_cap(cap, false);
+		__ceph_remove_cap(cap, false, true);
 		goto out_unlock;
 	} else if (tsession) {
 		/* add placeholder for the export tagert */
@@ -3867,7 +3867,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 			spin_unlock(&mdsc->cap_dirty_lock);
 		}
 
-		__ceph_remove_cap(cap, false);
+		__ceph_remove_cap(cap, false, true);
 		goto out_unlock;
 	}
 
@@ -3978,7 +3978,8 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 					ocap->mseq, mds, le32_to_cpu(ph->seq),
 					le32_to_cpu(ph->mseq));
 		}
-		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
+		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE),
+				  true);
 	}
 
 	*old_issued = issued;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0302af53e079..d99ec2618585 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1636,7 +1636,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	dout("removing cap %p, ci is %p, inode is %p\n",
 	     cap, ci, &ci->vfs_inode);
 	spin_lock(&ci->i_ceph_lock);
-	__ceph_remove_cap(cap, false);
+	__ceph_remove_cap(cap, false, false);
 	if (!ci->i_auth_cap) {
 		struct ceph_cap_flush *cf;
 
@@ -2008,7 +2008,7 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 
 	if (oissued) {
 		/* we aren't the only cap.. just remove us */
-		__ceph_remove_cap(cap, true);
+		__ceph_remove_cap(cap, true, true);
 		(*remaining)--;
 	} else {
 		struct dentry *dentry;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 51ec17d12b26..106ddfd1ce92 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1142,7 +1142,8 @@ extern void ceph_add_cap(struct inode *inode,
 			 unsigned issued, unsigned wanted,
 			 unsigned cap, unsigned seq, u64 realmino, int flags,
 			 struct ceph_cap **new_cap);
-extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
+extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release,
+			      bool warn);
 extern void __ceph_remove_caps(struct ceph_inode_info *ci);
 extern void ceph_put_cap(struct ceph_mds_client *mdsc,
 			 struct ceph_cap *cap);
-- 
2.27.0

