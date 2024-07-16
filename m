Return-Path: <ceph-devel+bounces-1532-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA65932637
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jul 2024 14:08:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 697341C22B09
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jul 2024 12:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3991919A847;
	Tue, 16 Jul 2024 12:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RNwFALi0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB3719A2A0
	for <ceph-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721131677; cv=none; b=Oyy1ysontkpZ1wBAcYPywsuFzLWkoV2BoMwOmUNKiAhLHys7fpykoIaS9gQrOhl86gNWb7vCJq9H8sFZ5ISb87VMJs5b1wUCGw8iEM2NA/qUh097eZdNrW05WuAP2pPFiFRrQHo96WHT/kSEwW7khDNuSPHu9oDPYBt68aG8vyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721131677; c=relaxed/simple;
	bh=sJNaQQ8z+UMQkMXmX+aHHOIETmZlhJGofI6ILpW+yNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZjqBrjGaCdNyAPFJDdTuM19pmtvTrSHA8wBQMs5fHnHzjkvr+udBMr9lEYZtFwD5brxU0+EsqZOCdg+ETo7qacPpeIDtNe/2K0LxGdpk1wGTpaPAV5VBmXT+K/nLZlP1zXa6kHIXGLXfKQMhbzSfdHoYY1+cD6gDOqOFeZSZM9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RNwFALi0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721131675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D+bPivzczJ9pAjIr87r9UjtTBufZdVjCZHzu0pDoqKs=;
	b=RNwFALi0XWrlZVx9+BpkkT5PjjzxbMDYSz/uNCj3y8K/wDpoFAfcOyJzAWNZU0RAnQtSL9
	j/RAs2IBKnyH5Czbw2brTZckUMVle6adzYVWd0GWjBkuktgg0+vajcN6yZ6RJVWjZHzFj0
	Qeqo1T4rd8gHO7HVmvtNxlCA2WVanHg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-kSm3ky6INluXHuZniLihOw-1; Tue,
 16 Jul 2024 08:07:48 -0400
X-MC-Unique: kSm3ky6INluXHuZniLihOw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABED01956046;
	Tue, 16 Jul 2024 12:07:46 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.106])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 32EBB300018E;
	Tue, 16 Jul 2024 12:07:42 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	vshankar@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] ceph: force sending a cap update msg back to MDS for revoke op
Date: Tue, 16 Jul 2024 20:07:24 +0800
Message-ID: <20240716120724.134512-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Xiubo Li <xiubli@redhat.com>

If a client sends out a cap update dropping caps with the prior 'seq'
just before an incoming cap revoke request, then the client may drop
the revoke because it believes it's already released the requested
capabilities.

This causes the MDS to wait indefinitely for the client to respond
to the revoke. It's therefore always a good idea to ack the cap
revoke request with the bumped up 'seq'.

Currently if the cap->issued equals to the newcaps the check_caps()
will do nothing, we should force flush the caps.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/61782
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- Move the force check earlier

V2:
- Improved the patch to force send the cap update only when no caps
being used.


 fs/ceph/caps.c  | 35 ++++++++++++++++++++++++-----------
 fs/ceph/super.h |  7 ++++---
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 24c31f795938..672c6611d749 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2024,6 +2024,8 @@ bool __ceph_should_report_size(struct ceph_inode_info *ci)
  *  CHECK_CAPS_AUTHONLY - we should only check the auth cap
  *  CHECK_CAPS_FLUSH - we should flush any dirty caps immediately, without
  *    further delay.
+ *  CHECK_CAPS_FLUSH_FORCE - we should flush any caps immediately, without
+ *    further delay.
  */
 void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 {
@@ -2105,7 +2107,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 	}
 
 	doutc(cl, "%p %llx.%llx file_want %s used %s dirty %s "
-	      "flushing %s issued %s revoking %s retain %s %s%s%s\n",
+	      "flushing %s issued %s revoking %s retain %s %s%s%s%s\n",
 	     inode, ceph_vinop(inode), ceph_cap_string(file_wanted),
 	     ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
 	     ceph_cap_string(ci->i_flushing_caps),
@@ -2113,7 +2115,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 	     ceph_cap_string(retain),
 	     (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
 	     (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "",
-	     (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "");
+	     (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "",
+	     (flags & CHECK_CAPS_FLUSH_FORCE) ? " FLUSH_FORCE" : "");
 
 	/*
 	 * If we no longer need to hold onto old our caps, and we may
@@ -2188,6 +2191,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 				queue_writeback = true;
 		}
 
+		if (flags & CHECK_CAPS_FLUSH_FORCE) {
+			doutc(cl, "force to flush caps\n");
+			goto ack;
+		}
+
 		if (cap == ci->i_auth_cap &&
 		    (cap->issued & CEPH_CAP_FILE_WR)) {
 			/* request larger max_size from MDS? */
@@ -3518,6 +3526,8 @@ static void handle_cap_grant(struct inode *inode,
 	bool queue_invalidate = false;
 	bool deleted_inode = false;
 	bool fill_inline = false;
+	bool revoke_wait = false;
+	int flags = 0;
 
 	/*
 	 * If there is at least one crypto block then we'll trust
@@ -3713,16 +3723,18 @@ static void handle_cap_grant(struct inode *inode,
 		      ceph_cap_string(cap->issued), ceph_cap_string(newcaps),
 		      ceph_cap_string(revoking));
 		if (S_ISREG(inode->i_mode) &&
-		    (revoking & used & CEPH_CAP_FILE_BUFFER))
+		    (revoking & used & CEPH_CAP_FILE_BUFFER)) {
 			writeback = true;  /* initiate writeback; will delay ack */
-		else if (queue_invalidate &&
+			revoke_wait = true;
+		} else if (queue_invalidate &&
 			 revoking == CEPH_CAP_FILE_CACHE &&
-			 (newcaps & CEPH_CAP_FILE_LAZYIO) == 0)
-			; /* do nothing yet, invalidation will be queued */
-		else if (cap == ci->i_auth_cap)
+			 (newcaps & CEPH_CAP_FILE_LAZYIO) == 0) {
+			revoke_wait = true; /* do nothing yet, invalidation will be queued */
+		} else if (cap == ci->i_auth_cap) {
 			check_caps = 1; /* check auth cap only */
-		else
+		} else {
 			check_caps = 2; /* check all caps */
+		}
 		/* If there is new caps, try to wake up the waiters */
 		if (~cap->issued & newcaps)
 			wake = true;
@@ -3749,8 +3761,9 @@ static void handle_cap_grant(struct inode *inode,
 	BUG_ON(cap->issued & ~cap->implemented);
 
 	/* don't let check_caps skip sending a response to MDS for revoke msgs */
-	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
+	if (!revoke_wait && le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
 		cap->mds_wanted = 0;
+		flags |= CHECK_CAPS_FLUSH_FORCE;
 		if (cap == ci->i_auth_cap)
 			check_caps = 1; /* check auth cap only */
 		else
@@ -3806,9 +3819,9 @@ static void handle_cap_grant(struct inode *inode,
 
 	mutex_unlock(&session->s_mutex);
 	if (check_caps == 1)
-		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL);
+		ceph_check_caps(ci, flags | CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL);
 	else if (check_caps == 2)
-		ceph_check_caps(ci, CHECK_CAPS_NOINVAL);
+		ceph_check_caps(ci, flags | CHECK_CAPS_NOINVAL);
 }
 
 /*
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b0b368ed3018..831e8ec4d5da 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -200,9 +200,10 @@ struct ceph_cap {
 	struct list_head caps_item;
 };
 
-#define CHECK_CAPS_AUTHONLY   1  /* only check auth cap */
-#define CHECK_CAPS_FLUSH      2  /* flush any dirty caps */
-#define CHECK_CAPS_NOINVAL    4  /* don't invalidate pagecache */
+#define CHECK_CAPS_AUTHONLY     1  /* only check auth cap */
+#define CHECK_CAPS_FLUSH        2  /* flush any dirty caps */
+#define CHECK_CAPS_NOINVAL      4  /* don't invalidate pagecache */
+#define CHECK_CAPS_FLUSH_FORCE  8  /* force flush any caps */
 
 struct ceph_cap_flush {
 	u64 tid;
-- 
2.45.1


