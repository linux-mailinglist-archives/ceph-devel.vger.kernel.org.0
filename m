Return-Path: <ceph-devel+bounces-1518-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39C5B92E4EC
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 12:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADF211F2412F
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 10:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB38157A74;
	Thu, 11 Jul 2024 10:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TkdJZ5TL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF315748A
	for <ceph-devel@vger.kernel.org>; Thu, 11 Jul 2024 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720694444; cv=none; b=IfQBddQ1pl55ONwkgl+BNT1mUcFj9ALfPe+wihprDEM+aCx4Qq71eBgMpUBBzdNTZwFmtO7DAOqS3pTkdnzA820wvHNol/KVjm8jX5fVaKcGzcUibPEf53iPlOdF7Gl6bk+CnXyGrBYmPp8+8GzNjgbfu3hGNQvEL80FNU+jzgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720694444; c=relaxed/simple;
	bh=6t/gMVZAisIpYy04WZFG/a2vLk4axtjfpsFHfCtSFsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gzVKALOntDOnhz+crfNJeVf/QTk1ydTJrM2KzRNVpjvDScpOhJyCMVumOr82DUBmCjZWa6B4xQoxtGUxdLQpRgOi5UzoUoLXy0R1LtWJEQbBnzALv519XBJWm6KYbJC//tdnppnUsxosG/74iwU3wH08Adf/3ERe6V6YXoQjRQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TkdJZ5TL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720694441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VGUvY3B1btnR1Zr6JZyqPyJpVhwgLpvFz2sGlKuqBkg=;
	b=TkdJZ5TLmA86mUo6QVrPBn1ko5RKgepyUsB4e+nFs0O6Ttsuh45oRPyM9S3u7stIVceH2g
	gLwZNWXZNNFdiRMul2wpwRx8C4ceVdUJgjIMb4s20GloAxN62vTAduW0irKkHgEBwiRNMI
	tFzFD/ovWL8q4Y5/+WMAfdaYnCnzWlU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-wqrxq8ALN1O-nLfylwsfSA-1; Thu,
 11 Jul 2024 06:40:38 -0400
X-MC-Unique: wqrxq8ALN1O-nLfylwsfSA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D12F1944D3B;
	Thu, 11 Jul 2024 10:40:37 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.134])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07D531955F40;
	Thu, 11 Jul 2024 10:40:33 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	vshankar@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] ceph: force sending a cap update msg back to MDS for revoke op
Date: Thu, 11 Jul 2024 18:40:19 +0800
Message-ID: <20240711104019.987090-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
 fs/ceph/caps.c  | 16 ++++++++++++----
 fs/ceph/super.h |  7 ++++---
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 24c31f795938..ba5809cf8f02 100644
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
@@ -3518,6 +3524,7 @@ static void handle_cap_grant(struct inode *inode,
 	bool queue_invalidate = false;
 	bool deleted_inode = false;
 	bool fill_inline = false;
+	int flags = 0;
 
 	/*
 	 * If there is at least one crypto block then we'll trust
@@ -3751,6 +3758,7 @@ static void handle_cap_grant(struct inode *inode,
 	/* don't let check_caps skip sending a response to MDS for revoke msgs */
 	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
 		cap->mds_wanted = 0;
+		flags |= CHECK_CAPS_FLUSH_FORCE;
 		if (cap == ci->i_auth_cap)
 			check_caps = 1; /* check auth cap only */
 		else
@@ -3806,9 +3814,9 @@ static void handle_cap_grant(struct inode *inode,
 
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


