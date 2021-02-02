Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D8030B821
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 07:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhBBG4j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 01:56:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232187AbhBBG42 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Feb 2021 01:56:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612248902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CLHHonDROcrySJNPefghndyHulIVW/U58Q/iBSSMLEA=;
        b=TFA1kV46bzg2PcfLZsOaxNwMYAQjI5uGHLGxh1oyVzrc+nzzuUUq8yfltPN6bi5GBFaXmC
        vN2AJ1fPVmpBgbrxdQSSs6XMRaVrOhfSo01/3dmdPXKodHWbtdvvKtHIL9FhN3Md7l4iL4
        hpQD9VOAnME86ArVYn6eOapO0E3f+vg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-KArkYZwHNQ6J9as8M-o3rg-1; Tue, 02 Feb 2021 01:54:58 -0500
X-MC-Unique: KArkYZwHNQ6J9as8M-o3rg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55702801B13;
        Tue,  2 Feb 2021 06:54:57 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94B8D5D9C6;
        Tue,  2 Feb 2021 06:54:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4] ceph: defer flushing the capsnap if the Fb is used
Date:   Tue,  2 Feb 2021 14:54:53 +0800
Message-Id: <20210202065453.814859-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the Fb cap is used it means the current inode is flushing the
dirty data to OSD, just defer flushing the capsnap.

URL: https://tracker.ceph.com/issues/48679
URL: https://tracker.ceph.com/issues/48640
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V4:
- Fix stuck issue when running the snaptest-git-ceph.sh pointed by Jeff.

V3:
- Add more comments about putting the inode ref
- A small change about the code style

V2:
- Fix inode reference leak bug


 fs/ceph/caps.c | 33 ++++++++++++++++++++-------------
 fs/ceph/snap.c | 10 ++++++++++
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index abbf48fc6230..570731c4d019 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3047,6 +3047,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 {
 	struct inode *inode = &ci->vfs_inode;
 	int last = 0, put = 0, flushsnaps = 0, wake = 0;
+	bool check_flushsnaps = false;
 
 	spin_lock(&ci->i_ceph_lock);
 	if (had & CEPH_CAP_PIN)
@@ -3063,26 +3064,17 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 	if (had & CEPH_CAP_FILE_BUFFER) {
 		if (--ci->i_wb_ref == 0) {
 			last++;
+			/* put the ref held by ceph_take_cap_refs() */
 			put++;
+			check_flushsnaps = true;
 		}
 		dout("put_cap_refs %p wb %d -> %d (?)\n",
 		     inode, ci->i_wb_ref+1, ci->i_wb_ref);
 	}
-	if (had & CEPH_CAP_FILE_WR)
+	if (had & CEPH_CAP_FILE_WR) {
 		if (--ci->i_wr_ref == 0) {
 			last++;
-			if (__ceph_have_pending_cap_snap(ci)) {
-				struct ceph_cap_snap *capsnap =
-					list_last_entry(&ci->i_cap_snaps,
-							struct ceph_cap_snap,
-							ci_item);
-				capsnap->writing = 0;
-				if (ceph_try_drop_cap_snap(ci, capsnap))
-					put++;
-				else if (__ceph_finish_cap_snap(ci, capsnap))
-					flushsnaps = 1;
-				wake = 1;
-			}
+			check_flushsnaps = true;
 			if (ci->i_wrbuffer_ref_head == 0 &&
 			    ci->i_dirty_caps == 0 &&
 			    ci->i_flushing_caps == 0) {
@@ -3094,6 +3086,21 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
 				drop_inode_snap_realm(ci);
 		}
+	}
+	if (check_flushsnaps && __ceph_have_pending_cap_snap(ci)) {
+		struct ceph_cap_snap *capsnap =
+			list_last_entry(&ci->i_cap_snaps,
+					struct ceph_cap_snap,
+					ci_item);
+
+		capsnap->writing = 0;
+		if (ceph_try_drop_cap_snap(ci, capsnap))
+			/* put the ref held by ceph_queue_cap_snap() */
+			put++;
+		else if (__ceph_finish_cap_snap(ci, capsnap))
+			flushsnaps = 1;
+		wake = 1;
+	}
 	spin_unlock(&ci->i_ceph_lock);
 
 	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index b611f829cb61..0728b01d4d43 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -623,6 +623,16 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 		return 0;
 	}
 
+	/* Fb cap still in use, delay it */
+	if (ci->i_wb_ref) {
+		dout("finish_cap_snap %p cap_snap %p snapc %p %llu %s s=%llu "
+		     "used WRBUFFER, delaying\n", inode, capsnap,
+		     capsnap->context, capsnap->context->seq,
+		     ceph_cap_string(capsnap->dirty), capsnap->size);
+		capsnap->writing = 1;
+		return 0;
+	}
+
 	ci->i_ceph_flags |= CEPH_I_FLUSH_SNAPS;
 	dout("finish_cap_snap %p cap_snap %p snapc %p %llu %s s=%llu\n",
 	     inode, capsnap, capsnap->context,
-- 
2.27.0

