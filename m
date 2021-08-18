Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC893EFEA4
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 10:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbhHRIGs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 04:06:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239781AbhHRIGr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 04:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629273973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eHOkSBe23x1mddfFu84rXsgimGdj4smxXTSmrdiSfS4=;
        b=GSZOEphipoUlQwbiViAIubaxs9w2JRmQLk25bTw3g2jJXReaMK728FC19dxTM6lx0hfLP8
        dV3TjCc4DgsoxJqSL2k/14U/n68jXPPUWhkRk/jBXbb4BLeYPF8EJiR4G62ZV4SGkUgTYj
        /5QRiiOmE69maW/lnY0boYq++adD0N0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-Nzc6HQfgPQG49M0xZLoiDg-1; Wed, 18 Aug 2021 04:06:11 -0400
X-MC-Unique: Nzc6HQfgPQG49M0xZLoiDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9502A107ACF5;
        Wed, 18 Aug 2021 08:06:10 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F2B75C232;
        Wed, 18 Aug 2021 08:06:08 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/3] ceph: remove the capsnaps when removing the caps
Date:   Wed, 18 Aug 2021 16:06:01 +0800
Message-Id: <20210818080603.195722-2-xiubli@redhat.com>
In-Reply-To: <20210818080603.195722-1-xiubli@redhat.com>
References: <20210818080603.195722-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 fs/ceph/caps.c       | 47 +++++++++++++++++++++++++++++---------------
 fs/ceph/mds_client.c | 23 +++++++++++++++++++++-
 fs/ceph/super.h      |  3 +++
 3 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e239f06babbc..7def99fbdca6 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3663,6 +3663,34 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 		iput(inode);
 }
 
+/*
+ * Caller hold s_mutex and i_ceph_lock.
+ */
+void ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
+			 bool *wake_ci, bool *wake_mdsc)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
+	bool ret;
+
+	dout("removing capsnap %p, inode %p ci %p\n", capsnap, inode, ci);
+
+	WARN_ON(capsnap->dirty_pages || capsnap->writing);
+	list_del(&capsnap->ci_item);
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
 /*
  * Handle FLUSHSNAP_ACK.  MDS has flushed snap data to disk and we can
  * throw away our cap_snap.
@@ -3700,23 +3728,10 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
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
index fa4c0fe294c1..a632e1c7cef2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1604,10 +1604,30 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	return ret;
 }
 
+static void remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_cap_snap *capsnap;
+
+	dout("removing capsnaps, ci is %p, inode is %p\n", ci, inode);
+
+	while (!list_empty(&ci->i_cap_snaps)) {
+		capsnap = list_first_entry(&ci->i_cap_snaps,
+					   struct ceph_cap_snap, ci_item);
+		ceph_remove_capsnap(inode, capsnap, NULL, NULL);
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
@@ -1619,7 +1639,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	__ceph_remove_cap(cap, false);
 	if (!ci->i_auth_cap) {
 		struct ceph_cap_flush *cf;
-		struct ceph_mds_client *mdsc = fsc->mdsc;
 
 		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
 			if (inode->i_data.nrpages > 0)
@@ -1684,6 +1703,8 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			ci->i_prealloc_cap_flush = NULL;
 		}
 	}
+	if (!list_empty(&ci->i_cap_snaps))
+		remove_capsnaps(mdsc, inode);
 	spin_unlock(&ci->i_ceph_lock);
 	while (!list_empty(&to_remove)) {
 		struct ceph_cap_flush *cf;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 0bc36cf4c683..51ec17d12b26 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1168,6 +1168,9 @@ extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
 					    int had);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				       struct ceph_snap_context *snapc);
+extern void ceph_remove_capsnap(struct inode *inode,
+				struct ceph_cap_snap *capsnap,
+				bool *wake_ci, bool *wake_mdsc);
 extern void ceph_flush_snaps(struct ceph_inode_info *ci,
 			     struct ceph_mds_session **psession);
 extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
-- 
2.27.0

