Return-Path: <ceph-devel+bounces-1524-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80DF292F4AD
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Jul 2024 06:40:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4CD41C21EC0
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Jul 2024 04:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291E515AC4;
	Fri, 12 Jul 2024 04:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yu1P5Vcx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988CBFC12
	for <ceph-devel@vger.kernel.org>; Fri, 12 Jul 2024 04:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720759243; cv=none; b=rg5kPYYaXRTbSy1UkS9YcJXjAzFzRy+ugqKwZe7j8B7p1ZPsENmSsqaiFd8H7hRUuGHA8oc5qt1eSv1lOIjqJ0nlGdwZkB6h8o+bG7laapNps6zmB1Gq5aH8OqLLK+rfrCT/et2D+1IWr4Jr4CafQkraOE+ufqKqpTUVP4EP+ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720759243; c=relaxed/simple;
	bh=myd6qqZHtPERESyI/LBQO0jljEE3yI5d+GqOjZPy03s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V0FGYyf4LZyqQev9N0rFKXRQ8nYC8Grnfj/2MvzE3zMWQmdXJmo6i0NBJlfNxKfQ9e4yAddRmLkf+VNny1tHGMN54M/tbskdvnmzZj9LaxFCdZrier/dffLHFF8Pl504lmQ51WFpOufwj/EXvshGqeRPaAb3d9LxNeP01kFjlLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yu1P5Vcx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720759240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c/fIAAm4engsYe1vxstOXFdy7qlJOMOzCDDhYdd8rr8=;
	b=Yu1P5VcxKr1fHkaBghhvbfar93lsZdUjlXNs49cD6MamHnY7j1Yd/tLldvLvNv5M/Wth2Y
	urAW1jaYAd2VplidnA8lTS7AgnX3K1X3hWlzQ+Hnz648JO6tOCk8RI573goiguEiC4LNWj
	OVNWbGC6RDv9dsSgrCTqQsy6m9mBzeo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-9QHWUMkyNkarQlL1F_yfgA-1; Fri,
 12 Jul 2024 00:40:32 -0400
X-MC-Unique: 9QHWUMkyNkarQlL1F_yfgA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 541AD19560AA;
	Fri, 12 Jul 2024 04:40:31 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.134])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4425A19560AE;
	Fri, 12 Jul 2024 04:40:26 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org,
	idryomov@gmail.com
Cc: vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] ceph: force sending a cap update msg back to MDS for revoke op
Date: Fri, 12 Jul 2024 12:40:19 +0800
Message-ID: <20240712044019.1043533-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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

V2:
- Improved the patch to force send the cap update only when no caps
being used.

 fs/ceph/caps.c  | 33 ++++++++++++++++++++++-----------
 fs/ceph/super.h |  7 ++++---
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 24c31f795938..b5473085a47b 100644
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
@@ -2223,6 +2226,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 				goto ack;
 		}
 
+		if (flags & CHECK_CAPS_FLUSH_FORCE)
+			goto ack;
+
 		/* things we might delay */
 		if ((cap->issued & ~retain) == 0)
 			continue;     /* nope, all good */
@@ -3518,6 +3524,8 @@ static void handle_cap_grant(struct inode *inode,
 	bool queue_invalidate = false;
 	bool deleted_inode = false;
 	bool fill_inline = false;
+	bool revoke_wait = false;
+	int flags = 0;
 
 	/*
 	 * If there is at least one crypto block then we'll trust
@@ -3713,16 +3721,18 @@ static void handle_cap_grant(struct inode *inode,
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
@@ -3749,8 +3759,9 @@ static void handle_cap_grant(struct inode *inode,
 	BUG_ON(cap->issued & ~cap->implemented);
 
 	/* don't let check_caps skip sending a response to MDS for revoke msgs */
-	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
+	if (!revoke_wait && le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
 		cap->mds_wanted = 0;
+		flags |= CHECK_CAPS_FLUSH_FORCE;
 		if (cap == ci->i_auth_cap)
 			check_caps = 1; /* check auth cap only */
 		else
@@ -3806,9 +3817,9 @@ static void handle_cap_grant(struct inode *inode,
 
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


