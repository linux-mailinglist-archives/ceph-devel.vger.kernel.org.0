Return-Path: <ceph-devel+bounces-3410-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC37FB223D6
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 11:58:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD444506D35
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 09:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2129D2EA75E;
	Tue, 12 Aug 2025 09:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iqiy7xzB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1C82EA753
	for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 09:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754992672; cv=none; b=R+1fdLANKQD/NezpOLZMslXLHMJ+UcUB5xjiVN2YIVKRgr1NJXLppKrUVRXu8xTDB0vqlsXCBBawBCHSBmkg0IbXoX4DW3aWWC1DH29ftgFWBQUFb6dXPXGLiFZdFI5QGVbt8Vt2bKdnWN3L/WRpp7hrXLTlh/TzyJA2WHSG6o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754992672; c=relaxed/simple;
	bh=dZaQ1edKSllTGuRXQiHFANbzt+3XERk5gU5vSoToyzM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Po6R57gwVBdrrjEG/kPzkK0LC2MRLQMBYO+FrpIflRJnmtSqXirgGlB2fH6pxvLi+6P8KOLl6RMiwLKCZpQletszoWsCwGy9P/6rZmwOanudziVW4Si1SIv7+QPerVkh2zxqMp/g5dWmHzWf3ZWPColV+qnUfw8dbYtWgZx18XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Iqiy7xzB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754992670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8JhP0X98VGM6Ic3v1hqPyqTx6SwefbyP25WkheESX9U=;
	b=Iqiy7xzBHYGpTobDYZIM82BjPAOrFpuBKuC26TmPjtUDtAPAZH8/x7feRj2swdp64lxDqx
	v1vP+0BuPViZqtVtBNmF1cUr/DXYA2ICfcEMn1x8KWBK9oLP19QPRmoxQab0rFHfJ4a/Rg
	0TXkYB+PkpVPCnDte2ec9XBB/cGH/AM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-Z2ZSk0ftPCmU9a6kdFNBxw-1; Tue, 12 Aug 2025 05:57:48 -0400
X-MC-Unique: Z2ZSk0ftPCmU9a6kdFNBxw-1
X-Mimecast-MFC-AGG-ID: Z2ZSk0ftPCmU9a6kdFNBxw_1754992667
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ae98864f488so543743866b.0
        for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 02:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754992667; x=1755597467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8JhP0X98VGM6Ic3v1hqPyqTx6SwefbyP25WkheESX9U=;
        b=EE3LBlbjbSuWPGciv35y0vOlHeodQTNp8MU6NuWLbA3MniaKumWdCcl/hOmK0PyIxL
         2RFQhpqn+fogb98AIq5/fkhrS8aDJx5bRfy3WPkrt3Gc5TeybX8RQM0zuqxa/zkbN5Ht
         jKo4sDuhDJGEQ+NX+njW6cSq7EcyW62J6gID2nAlj0BUhcu1bJBOtd+Tfevtc7TyWLVq
         byXB3QqbkZvBjP5kCVwCI9n4aSX8buYBlIA4Xfils9djCpzHhoJuK/HB9/DlUoizQI6N
         HuVGL6v6COGqEGbpcyCd+tOmi2CvOp+ko62FkxeDAGdkHUat1NDV48hbSI1T7kDYCIYw
         1nKQ==
X-Gm-Message-State: AOJu0YyucxzV4LCl2/WFTp9+gFhVzHLVPeWCIZTo6xQu0zzgkn+ocfWv
	tEBQ7l8qJF7XSeLndYRKbMUZDmPpAFb6Tpp1CDbJu/g1vO9hb1JL2NRdtT4w0LivkvCTjyMdnE7
	8uzF4rRLNnQhHgasO0SrZdFn0pCPEdef1dqvvay9m7BVl2LS1Ln9gfmcZu7leFM1yDWhOhrZrCY
	38e7ZZ+JDmPAftmEPwlwWF6XVQI5nFI7ncPV3qVwDu0qMf7bRAqg==
X-Gm-Gg: ASbGncvo2C2141F68ArGfi8Sa5y7SAN14LbjJoVGrMj8xblYXrYO7kkHG82Mmq9qO1R
	+XWxU7AN/1JkN4bKnWKHiMo+BjgqTnWTAE2SPxSfchW+xgicDQac6jg9SmhiwKQTrapQ4uUF5lr
	wTmWg2XmEhfrsdh8muuFjmxcCARzyZqTCQnCCpkOoIZEx57gDXmvCwtiNjmv1yrFRjXR7Ct2B8X
	cS0iQFXbS72tZV+7Vg3APi7fiPykBcCoUTUgyjIKYD4HVAEnIY4gQPABRfCOdKdIfHmUEevWN4h
	iTXAruM3GqV0JzQsofi537yC6nWUgZoPscFVMQ3NAWV1BWnoDmf/B6YsTOAkyosNZGw4Ei+rDw=
	=
X-Received: by 2002:a17:907:3f13:b0:af9:adc8:66e3 with SMTP id a640c23a62f3a-afa1e1ee7c5mr182423966b.60.1754992667025;
        Tue, 12 Aug 2025 02:57:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+Hk34CBIigzIRSaCUmDcaKHxHvVydbgGKP3jDnDcJjoC7dJmBUl0JwjuTXTLzPv1PW3JbPA==
X-Received: by 2002:a17:907:3f13:b0:af9:adc8:66e3 with SMTP id a640c23a62f3a-afa1e1ee7c5mr182420266b.60.1754992666413;
        Tue, 12 Aug 2025 02:57:46 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a21c0a4sm2180821466b.109.2025.08.12.02.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 02:57:46 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH v4 2/2] ceph: fix client race condition where r_parent becomes stale before sending message
Date: Tue, 12 Aug 2025 09:57:39 +0000
Message-Id: <20250812095739.3194337-3-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250812095739.3194337-1-amarkuze@redhat.com>
References: <20250812095739.3194337-1-amarkuze@redhat.com>
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

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/inode.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 36981950a368..42110d133f15 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -56,6 +56,51 @@ static int ceph_set_ino_cb(struct inode *inode, void *data)
 	return 0;
 }
 
+/*
+ * Check if the parent inode matches the vino from directory reply info
+ */
+static inline bool ceph_vino_matches_parent(struct inode *parent, struct ceph_vino vino)
+{
+	return ceph_ino(parent) == vino.ino && ceph_snap(parent) == vino.snap;
+}
+
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
+    if (likely(ceph_vino_matches_parent(parent, vino)))
+        return parent; /* matches – use the original reference */
+
+    /* Mismatch – this should be rare.  Emit a WARN and obtain the correct inode. */
+    WARN_ONCE(1, "ceph: reply dir mismatch (parent valid %llx.%llx reply %llx.%llx)\n",
+              ceph_ino(parent), ceph_snap(parent), vino.ino, vino.snap);
+
+    return ceph_get_inode(sb, vino, NULL);
+}
+
 /**
  * ceph_new_inode - allocate a new inode in advance of an expected create
  * @dir: parent directory for new inode
@@ -1548,8 +1593,11 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 	}
 
 	if (rinfo->head->is_dentry) {
-		struct inode *dir = req->r_parent;
-
+		/*
+		 * r_parent may be stale, in cases when R_PARENT_LOCKED is not set,
+		 * so we need to get the correct inode
+		 */
+		struct inode *dir = ceph_get_reply_dir(sb, req->r_parent, rinfo);
 		if (dir) {
 			err = ceph_fill_inode(dir, NULL, &rinfo->diri,
 					      rinfo->dirfrag, session, -1,
-- 
2.34.1


