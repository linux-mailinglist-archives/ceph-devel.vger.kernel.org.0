Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCD52EB7C1
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Jan 2021 02:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbhAFBtD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 Jan 2021 20:49:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbhAFBtD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 5 Jan 2021 20:49:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609897656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xp73/I+FtjglsKeXMv6u0vLE4xFPsByo+lD5WjRV/2g=;
        b=VBtTqXlPT0Huew0UCRCq+mYvqF/mq0aDzTM02rFPpOKbLfJEpmo8BuFw2l6Gtlwu2aX4mc
        k9LeBJjxeoBlNwOaUhYDSVpJwcmQto8r4K7EY9XauGDXj/O0NnCSA2NAZgT6oPDn4ta7bI
        AWshzh6TWkiDzDiJQW4SA2c+xLKAaTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-cVQUFRZFPcayv1oKxzXyUw-1; Tue, 05 Jan 2021 20:47:32 -0500
X-MC-Unique: cVQUFRZFPcayv1oKxzXyUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD6E4801817;
        Wed,  6 Jan 2021 01:47:31 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1E8550DD5;
        Wed,  6 Jan 2021 01:47:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: defer flushing the capsnap if the Fb is used
Date:   Wed,  6 Jan 2021 09:47:26 +0800
Message-Id: <20210106014726.77614-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 fs/ceph/caps.c | 33 +++++++++++++++++++--------------
 fs/ceph/snap.c |  6 +++---
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index abbf48fc6230..a61ca9183f41 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3047,6 +3047,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 {
 	struct inode *inode = &ci->vfs_inode;
 	int last = 0, put = 0, flushsnaps = 0, wake = 0;
+	bool check_flushsnaps = false;
 
 	spin_lock(&ci->i_ceph_lock);
 	if (had & CEPH_CAP_PIN)
@@ -3063,26 +3064,15 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 	if (had & CEPH_CAP_FILE_BUFFER) {
 		if (--ci->i_wb_ref == 0) {
 			last++;
-			put++;
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
@@ -3094,6 +3084,21 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
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

