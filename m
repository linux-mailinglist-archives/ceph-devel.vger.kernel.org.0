Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5842EC81A
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Jan 2021 03:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbhAGCcc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Jan 2021 21:32:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726260AbhAGCcc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Jan 2021 21:32:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609986665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EHX47YJjKNPGE1mfx+oerNTfk5EIfIddmNM+zNloncA=;
        b=Kk1GOovbid98O+coe/I5bL3TDfCgl4ENIulVK6Q/+5x/U6dqzPdzb9E9Xblbf4GtNKvzzW
        J5KwBxBAJ8XBjF84/DVKDJsgvxW7Q2S07mXaORUlYxCBNuY6yfXmtNkFMqc0krVcO7Ziqq
        Mrugz9tj89Qp2VRTbGvLI4DdK2Z4veY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-9gZq9zNkPn2MIVAH2_GMEw-1; Wed, 06 Jan 2021 21:31:03 -0500
X-MC-Unique: 9gZq9zNkPn2MIVAH2_GMEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 879F7180A093;
        Thu,  7 Jan 2021 02:31:02 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA75D10013BD;
        Thu,  7 Jan 2021 02:31:00 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: defer flushing the capsnap if the Fb is used
Date:   Thu,  7 Jan 2021 10:30:51 +0800
Message-Id: <20210107023051.119063-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the Fb cap is used it means the client is flushing the dirty
data to OSD, just defer flushing the capsnap.

URL: https://tracker.ceph.com/issues/48679
URL: https://tracker.ceph.com/issues/48640
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Fix inode reference leak bug

 fs/ceph/caps.c | 32 +++++++++++++++++++-------------
 fs/ceph/snap.c |  6 +++---
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index abbf48fc6230..2f2451d563bd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3047,6 +3047,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 {
 	struct inode *inode = &ci->vfs_inode;
 	int last = 0, put = 0, flushsnaps = 0, wake = 0;
+	bool check_flushsnaps = false;
 
 	spin_lock(&ci->i_ceph_lock);
 	if (had & CEPH_CAP_PIN)
@@ -3064,25 +3065,15 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 		if (--ci->i_wb_ref == 0) {
 			last++;
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
@@ -3094,6 +3085,21 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
 				drop_inode_snap_realm(ci);
 		}
+	}
+	if (check_flushsnaps) {
+		if (__ceph_have_pending_cap_snap(ci)) {
+			struct ceph_cap_snap *capsnap =
+				list_last_entry(&ci->i_cap_snaps,
+						struct ceph_cap_snap,
+						ci_item);
+			capsnap->writing = 0;
+			if (ceph_try_drop_cap_snap(ci, capsnap))
+				put++;
+			else if (__ceph_finish_cap_snap(ci, capsnap))
+				flushsnaps = 1;
+			wake = 1;
+		}
+	}
 	spin_unlock(&ci->i_ceph_lock);
 
 	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index b611f829cb61..639fb91cc9db 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -561,10 +561,10 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	capsnap->context = old_snapc;
 	list_add_tail(&capsnap->ci_item, &ci->i_cap_snaps);
 
-	if (used & CEPH_CAP_FILE_WR) {
+	if (used & (CEPH_CAP_FILE_WR | CEPH_CAP_FILE_BUFFER)) {
 		dout("queue_cap_snap %p cap_snap %p snapc %p"
-		     " seq %llu used WR, now pending\n", inode,
-		     capsnap, old_snapc, old_snapc->seq);
+		     " seq %llu used WR | BUFFFER, now pending\n",
+		     inode, capsnap, old_snapc, old_snapc->seq);
 		capsnap->writing = 1;
 	} else {
 		/* note mtime, size NOW. */
-- 
2.27.0

