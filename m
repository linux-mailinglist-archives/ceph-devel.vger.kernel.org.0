Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5312D3F6EB6
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 07:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhHYFOy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 01:14:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231669AbhHYFOx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 01:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629868448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qQrlEzSGwUkxAHAej3AfeLHd4ljsa9EOR1GHitVnP90=;
        b=CusCN2Y0zhZHBPBU6zcSGGfN4jJ/uL3c6Rrmxhsq2nWq9x1Y3vdEfovhqwnZ2KBMGzZaow
        e35gmaplOjuP7mPsHzhlPP+8rSKElmgywObEroAG2qKCX+4WlHavzvL/Ux1BoXXY+KGBg4
        wOFXaAo2ABOL2G6td315l5Gs1iKhdB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-djCQ4_2lOJKZz-DLlI0W1A-1; Wed, 25 Aug 2021 01:14:03 -0400
X-MC-Unique: djCQ4_2lOJKZz-DLlI0W1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AABF1082921;
        Wed, 25 Aug 2021 05:14:02 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25D2B3AC1;
        Wed, 25 Aug 2021 05:13:59 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/3] ceph: remove the capsnaps when removing the caps
Date:   Wed, 25 Aug 2021 13:13:53 +0800
Message-Id: <20210825051355.5820-2-xiubli@redhat.com>
In-Reply-To: <20210825051355.5820-1-xiubli@redhat.com>
References: <20210825051355.5820-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The capsnaps will ihold the inodes when queuing to flush, so when
force umounting it will close the sessions first and if the MDSes
respond very fast and the session connections are closed just
before killing the superblock, which will flush the msgr queue,
then the flush capsnap callback won't ever be called, which will
lead the memory leak bug for the ceph_inode_info.

URL: https://tracker.ceph.com/issues/52295
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 56 +++++++++++++++++++++++++++++++-------------
 fs/ceph/mds_client.c | 25 +++++++++++++++++++-
 fs/ceph/super.h      |  6 +++++
 3 files changed, 70 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ddd86106e6d0..557c610289fb 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3658,6 +3658,43 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 		iput(inode);
 }
 
+void __ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
+			   bool *wake_ci, bool *wake_mdsc)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
+	bool ret;
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	dout("removing capsnap %p, inode %p ci %p\n", capsnap, inode, ci);
+
+	list_del_init(&capsnap->ci_item);
+	ret = __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
+	if (wake_ci)
+		*wake_ci = ret;
+
+	spin_lock(&mdsc->cap_dirty_lock);
+	if (list_empty(&ci->i_cap_flush_list))
+		list_del_init(&ci->i_flushing_item);
+
+	ret = __detach_cap_flush_from_mdsc(mdsc, &capsnap->cap_flush);
+	if (wake_mdsc)
+		*wake_mdsc = ret;
+	spin_unlock(&mdsc->cap_dirty_lock);
+}
+
+void ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
+			 bool *wake_ci, bool *wake_mdsc)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	WARN_ON_ONCE(capsnap->dirty_pages || capsnap->writing);
+	__ceph_remove_capsnap(inode, capsnap, wake_ci, wake_mdsc);
+}
+
 /*
  * Handle FLUSHSNAP_ACK.  MDS has flushed snap data to disk and we can
  * throw away our cap_snap.
@@ -3695,23 +3732,10 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
 			     capsnap, capsnap->follows);
 		}
 	}
-	if (flushed) {
-		WARN_ON(capsnap->dirty_pages || capsnap->writing);
-		dout(" removing %p cap_snap %p follows %lld\n",
-		     inode, capsnap, follows);
-		list_del(&capsnap->ci_item);
-		wake_ci |= __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
-
-		spin_lock(&mdsc->cap_dirty_lock);
-
-		if (list_empty(&ci->i_cap_flush_list))
-			list_del_init(&ci->i_flushing_item);
-
-		wake_mdsc |= __detach_cap_flush_from_mdsc(mdsc,
-							  &capsnap->cap_flush);
-		spin_unlock(&mdsc->cap_dirty_lock);
-	}
+	if (flushed)
+		ceph_remove_capsnap(inode, capsnap, &wake_ci, &wake_mdsc);
 	spin_unlock(&ci->i_ceph_lock);
+
 	if (flushed) {
 		ceph_put_snap_context(capsnap->context);
 		ceph_put_cap_snap(capsnap);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index df3a735f7837..df10f9b33660 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1604,10 +1604,32 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	return ret;
 }
 
+static void remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_cap_snap *capsnap;
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	dout("removing capsnaps, ci is %p, inode is %p\n", ci, inode);
+
+	while (!list_empty(&ci->i_cap_snaps)) {
+		capsnap = list_first_entry(&ci->i_cap_snaps,
+					   struct ceph_cap_snap, ci_item);
+		__ceph_remove_capsnap(inode, capsnap, NULL, NULL);
+		ceph_put_snap_context(capsnap->context);
+		ceph_put_cap_snap(capsnap);
+		iput(inode);
+	}
+	wake_up_all(&ci->i_cap_wq);
+	wake_up_all(&mdsc->cap_flushing_wq);
+}
+
 static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 				  void *arg)
 {
 	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
+	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	LIST_HEAD(to_remove);
 	bool dirty_dropped = false;
@@ -1619,7 +1641,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	__ceph_remove_cap(cap, false);
 	if (!ci->i_auth_cap) {
 		struct ceph_cap_flush *cf;
-		struct ceph_mds_client *mdsc = fsc->mdsc;
 
 		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
 			if (inode->i_data.nrpages > 0)
@@ -1684,6 +1705,8 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			ci->i_prealloc_cap_flush = NULL;
 		}
 	}
+	if (!list_empty(&ci->i_cap_snaps))
+		remove_capsnaps(mdsc, inode);
 	spin_unlock(&ci->i_ceph_lock);
 	while (!list_empty(&to_remove)) {
 		struct ceph_cap_flush *cf;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 8f4f2747be65..445d13d760d1 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1169,6 +1169,12 @@ extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
 					    int had);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				       struct ceph_snap_context *snapc);
+extern void __ceph_remove_capsnap(struct inode *inode,
+				  struct ceph_cap_snap *capsnap,
+				  bool *wake_ci, bool *wake_mdsc);
+extern void ceph_remove_capsnap(struct inode *inode,
+				struct ceph_cap_snap *capsnap,
+				bool *wake_ci, bool *wake_mdsc);
 extern void ceph_flush_snaps(struct ceph_inode_info *ci,
 			     struct ceph_mds_session **psession);
 extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
-- 
2.27.0

