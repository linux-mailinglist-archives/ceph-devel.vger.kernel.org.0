Return-Path: <ceph-devel+bounces-3336-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2891B16381
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 17:19:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4DA8169F45
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 15:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97F92110E;
	Wed, 30 Jul 2025 15:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SaOhGQ1R"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8BD192D6B
	for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753888764; cv=none; b=HZN1AcCd4uv+BLsOIyN3MqlYSLEr17uF/mmz+mTS4ygYTqjXF48VHT+CbXnFs12QkLdn6mTld/S6zZHcE0jpyPdciuC6bNXUW6PsEpOZMu/gdHdnuZwgYqpIuTQXg5Vh8vt+kS3Y0SF6lGE7RppyrryJk+4I50/kjv2iD9CJJr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753888764; c=relaxed/simple;
	bh=6nfA3oThlIKf7RJ0EkMHH8F3YKcGIZY0D3Cwv1K2TPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l2+TndSgnggqc0dq2fxuwnVcz3iylqUnjeD/yRRi7eVqTgkg5M8YXvObtz/oUpcJboXFQC1FWNkUMXJ+mYxT5XAXq4iOQVR5FuwRXYeIQAPJQYvbjVGmErvCn5+/OY0m3QGlvcgDOmuayFFjlDr9/XO6BSfSlN4O8Yj3B5sYv50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SaOhGQ1R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753888761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K5eudngtJP8VUCvyP2XAUo7CX+0NxAuDo0XqglIVzH8=;
	b=SaOhGQ1RkShj04suZC5v7AkuHP3SzC0HTm2vFrLi8I5HYDaiyd6aZipnktQunUMYNeEZl/
	CllwI047iJXS7FfLmNZqdUqqpThl3bgGZtMoBj+DcLnPLyQNUeoynUaU5oUBUNsmx+cDWD
	lWM/rcsDtA6kIacWL9uB57lwvxMswBo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-aeIIvYUCNqCRlZ-oQRBUVA-1; Wed, 30 Jul 2025 11:19:20 -0400
X-MC-Unique: aeIIvYUCNqCRlZ-oQRBUVA-1
X-Mimecast-MFC-AGG-ID: aeIIvYUCNqCRlZ-oQRBUVA_1753888760
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-7074f138855so15541006d6.1
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 08:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753888759; x=1754493559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5eudngtJP8VUCvyP2XAUo7CX+0NxAuDo0XqglIVzH8=;
        b=nBzuD7xNEyMUNIFx0RJkNicYz90XZnEXWIAud3tUCDwKc7CxN6OBTwGboFixbGV4Ag
         FSysuSzIBF6QRVnLlAA1wkQN/3kVUteEKH3hO8UhED+SqNC7SP7xpwEdKHBiqDtJjqd6
         iAFs1FjOQaRZY022Ufx2yTtJjbrpVIt0Xpm6SfZ/YQCv0LoqXDKb90Ggp+b9x/BSNuN0
         MyDvbwPts7lYNmTcfY0xR2cQboxS7QsEr36kMWiDTQd3VmfkN5SrtUxlHh9LE72kbfZ/
         UzwYSHzM0tThP0sDmaSmV6g3fCRUFkEvDLfj0MmmAbuQhrrl5jyF7XCzYloTj6kGxgVb
         G3HA==
X-Gm-Message-State: AOJu0YxUO4ZbJglnLhuVikxtGLHHUcljOJQJgZ7dsx/fAt1G3hwSCoz/
	oiru7D7Ee36uMA0hSal58x3TKeBpwGDasK+Gv4KvOSmB8WBkhNsBDF3tpICZutMFSgVH6MWWzsG
	KjYvKOviUbdgT5g9mL2bTIU6FAqS0m6ikLK/VDLNA9BFXgtCm8o6jv6Dg86RcxpFpbILykISXFp
	BffvmRK2wKaMqcIx84ZYCYlJJgTVjPv4JU503VRFLag3um7bkvzEJ0
X-Gm-Gg: ASbGncvDJIy3/dbaM5olAcEuQMquCjGD26t1op59clM2DGNGGEdZlsjUdv3kKRjOMdg
	tG6QhU58XCRF7DeLBs60nnbHEay++wKWhC0YQoUEWziZULdBvlEF8b3dTcTP6/C+LwV6CRPbopH
	kdfBJEZNa+UOBBloVFwAGxWtywXA/ulyj0NuJU836VqJ+kz9mV/WoWCFA8MkHy6bjDB9uP8mcjR
	mimKTX2eBHDuvWrXjEc9y/rw9JmcxO1omPJR1rO/hcfHtGLQc4TyAXeHhhyuV7MM8ZMK6p0rDZ2
	MvRwkvFGcRsaS8dmEiZs2poNl3odBLs7Cbn7m3nVxahS/SpR73YFo6QPSyv8D3iVtQAjE3BJcw=
	=
X-Received: by 2002:a05:6214:dcc:b0:704:8afa:250c with SMTP id 6a1803df08f44-70766e6de7fmr41314876d6.15.1753888759156;
        Wed, 30 Jul 2025 08:19:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGklFJMvpw0WUka98XQ/5Ou+viWmghHs9bkGCnAKxXi4N2QA2NCQESRY83EPnGZlWHdHJFayA==
X-Received: by 2002:a05:6214:dcc:b0:704:8afa:250c with SMTP id 6a1803df08f44-70766e6de7fmr41313976d6.15.1753888757916;
        Wed, 30 Jul 2025 08:19:17 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7076ba8834asm11322986d6.25.2025.07.30.08.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 08:19:17 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 2/2] ceph: fix client race condition where r_parent becomes stale before sending message
Date: Wed, 30 Jul 2025 15:19:00 +0000
Message-Id: <20250730151900.1591177-3-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730151900.1591177-1-amarkuze@redhat.com>
References: <20250730151900.1591177-1-amarkuze@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When the parent directory's i_rwsem is not locked, req->r_parent may become
stale due to concurrent operations (e.g. rename) between dentry lookup and
message creation. Validate that r_parent matches the encoded parent inode
and update to the correct inode if a mismatch is detected.
---
 fs/ceph/inode.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 814f9e9656a0..49fb1e3a02e8 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -56,6 +56,46 @@ static int ceph_set_ino_cb(struct inode *inode, void *data)
 	return 0;
 }
 
+/*
+ * Validate that the directory inode referenced by @req->r_parent matches the
+ * inode number and snapshot id contained in the reply's directory record.  If
+ * they do not match – which can theoretically happen if the parent dentry was
+ * moved between the time the request was issued and the reply arrived – fall
+ * back to looking up the correct inode in the inode cache.
+ *
+ * A reference is *always* returned.  Callers that receive a different inode
+ * than the original @parent are responsible for dropping the extra reference
+ * once the reply has been processed.
+ */
+static struct inode *ceph_get_reply_dir(struct super_block *sb,
+                                       struct inode *parent,
+                                       struct ceph_mds_reply_info_parsed *rinfo)
+{
+    struct ceph_vino vino;
+
+    if (unlikely(!rinfo->diri.in))
+        return parent; /* nothing to compare against */
+
+    /* If we didn't have a cached parent inode to begin with, just bail out. */
+    if (!parent)
+        return NULL;
+
+    vino.ino  = le64_to_cpu(rinfo->diri.in->ino);
+    vino.snap = le64_to_cpu(rinfo->diri.in->snapid);
+
+    if (likely(parent && ceph_ino(parent) == vino.ino && ceph_snap(parent) == vino.snap))
+        return parent; /* matches – use the original reference */
+
+    /* Mismatch – this should be rare.  Emit a WARN and obtain the correct inode. */
+    WARN(1, "ceph: reply dir mismatch (parent %s %llx.%llx reply %llx.%llx)\n",
+         parent ? "valid" : "NULL",
+         parent ? ceph_ino(parent) : 0ULL,
+         parent ? ceph_snap(parent) : 0ULL,
+         vino.ino, vino.snap);
+
+    return ceph_get_inode(sb, vino, NULL);
+}
+
 /**
  * ceph_new_inode - allocate a new inode in advance of an expected create
  * @dir: parent directory for new inode
@@ -1548,8 +1588,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 	}
 
 	if (rinfo->head->is_dentry) {
-		struct inode *dir = req->r_parent;
-
+		/* r_parent may be stale, in cases when R_PARENT_LOCKED is not set, so we need to get the correct inode */
+		struct inode *dir = ceph_get_reply_dir(sb, req->r_parent, rinfo);
 		if (dir) {
 			err = ceph_fill_inode(dir, NULL, &rinfo->diri,
 					      rinfo->dirfrag, session, -1,
-- 
2.34.1


