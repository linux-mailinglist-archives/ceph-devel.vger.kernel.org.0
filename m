Return-Path: <ceph-devel+bounces-3392-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 046A6B204EF
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 12:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F5621683B6
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 10:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30EC52253A7;
	Mon, 11 Aug 2025 10:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B5Po39gp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9E122B8D9
	for <ceph-devel@vger.kernel.org>; Mon, 11 Aug 2025 10:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907014; cv=none; b=cxFTbKW7be9Je0mjtVOItaqkHfyZ0noAC+Qu8tWxq6KCqjqhCBGDBPonUyUe+akruDJ6GdcQkRj0P/qAa2I2TkAccpEcH9AzDFiO36S4OtozjN2APHYzeZNg6z+fRCJKvkAcpB+PVd1Svbuy+FdfFYY2bkReUCaY4Ofgcb58I00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907014; c=relaxed/simple;
	bh=iqhYFYTxQa/K2nVowETY6ZlfzDTcoa5uKhkMJRu1DNo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YiGMoqAZ7blV5SoddWQhI2SdYeorJe859LYOvDslrxUFhI9ba4ek8xRA47uwWJFzlxLNKp1u8CQuTcdM/IviHd3yKXYLMoNl9ulyHdl2D9jDqdjVxy4U4BqdhCX9WvIypHdUHRRuCmwIsazStDLkKruNglR+t3gYQhv6Bjo1gTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B5Po39gp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754907011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ADXa+JUacIlGyQHrCfYdOEZrY+dSv3yGk/IhF4XPHU=;
	b=B5Po39gp5Rr1z2IUD93ogbiyqmSStu9KLCgoGLWsyeDwcgsZ6DzUKfJ3U8CkRbOsO7iQeM
	d40JMqskYmZnDz0FfGnpCOqUJHT86zFJ/rwmf2K4oz+trcz0nm5vgmVI/yaWYehKyk6Y96
	inXHYNul6F5FTeVS5t6NbgNobgW9Njw=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-rLsyUc6gMhmvl86j0ylGXg-1; Mon, 11 Aug 2025 06:10:10 -0400
X-MC-Unique: rLsyUc6gMhmvl86j0ylGXg-1
X-Mimecast-MFC-AGG-ID: rLsyUc6gMhmvl86j0ylGXg_1754907009
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-743089b1d50so6719131a34.0
        for <ceph-devel@vger.kernel.org>; Mon, 11 Aug 2025 03:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907009; x=1755511809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ADXa+JUacIlGyQHrCfYdOEZrY+dSv3yGk/IhF4XPHU=;
        b=O1NopRXTNjlNXBMYvrMC4nsinNPMxFbxpEVY90pTjH5ER5i26atKLI7GYaaX/RtRdI
         jHN1zMyxnoxk2AkJxVW5i0XiVXJcN+NNxTQz/4ZBwW//EbcZiZSBzNpDG/Ki1p7B9X9Z
         w5WcgXIptT+vq7ZWtB8Mp8vT8Ir7XJCTLJhvyDT0mvcrRTWjX96XKMrlL0IJNUKh0tQS
         qgzRvjVD+Gl19EdKlD7AdBYSfeV3AiMHhT4mJgOooqRxRuNoeHjkz+PxbwUCv6XSACqI
         j9zvlLhX6Lf5Da02+0mXArthZi8WAQpwOlnYS/cKvqSTitgd7gyW+Y2jSVFdyFRUbCZw
         2eWA==
X-Gm-Message-State: AOJu0Yyp64IvXlaEa7N8rQRggSCZDZKhF/oVzRPoFc2VHeGn1PfNJI92
	SdSKcz2VBgQcAQp4hPJuFR4Z6mmrPOR7n3AbxIaQ1QqvWE/aMOsboOXsHE2JMOdMrYsUzWudOgc
	iYyq5z5weY1ITlvs1h5OrHH/veYSHVcymV5bzYUTCR1Cib3j2MZ9bJsxx0y1HHNc1pyq66kK5sr
	fiAe9aYmZubZi+6FIexvX8aUzGe+PknzTcsey6BQdd01gZKDF9KQ==
X-Gm-Gg: ASbGnctAs5OQ140bRE7PXSwXvHm7L2F6d36C/jspLtS9sWWqiSVhn+3B5wPSbVOMygJ
	Q+0nQt+WpPcIeeJsynr7rj5vOzcMeswqfleYqyC2d/XUfO8UzRMg0p3/xzfG9tq0qHWSmBE5k6D
	YvdnAjhS/ttUzBY4+5vg99BFK3rqPdkb24ukEYU0ekTjoTQ3qc+1fP1fUE4rRhesFGDqwBwxIAH
	vYiWPKhjRk0OOYuvM94tYmBcMV51zR2bNwog0yLWEkkZEq6tNf3pCk2yhooks7kPvob4RWbDClC
	KYxbbROZ+AWbVZCs3lfrhBS/gPJMmYuY4q73CSOTGGdgHEVVQmc2S6dltxyzUllxVpBDZm/D1g=
	=
X-Received: by 2002:a05:6830:91e:b0:742:f82b:4f35 with SMTP id 46e09a7af769-7432c6fef53mr5163251a34.7.1754907009182;
        Mon, 11 Aug 2025 03:10:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGDV61T6bvbfrGKdhItBqh9I5e/MeC98JhftfpIquS5ORyE/FnDauZZJrP6yCeLaeggPjNhA==
X-Received: by 2002:a05:6830:91e:b0:742:f82b:4f35 with SMTP id 46e09a7af769-7432c6fef53mr5163237a34.7.1754907008721;
        Mon, 11 Aug 2025 03:10:08 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-61b84cb7630sm849522eaf.19.2025.08.11.03.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 03:10:08 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH v3 2/2] ceph: fix client race condition where r_parent becomes stale before sending message
Date: Mon, 11 Aug 2025 10:09:53 +0000
Message-Id: <20250811100953.3103970-3-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811100953.3103970-1-amarkuze@redhat.com>
References: <20250811100953.3103970-1-amarkuze@redhat.com>
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
 fs/ceph/inode.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 58da0f6419f7..c6f7fd9a25f3 100644
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
+    WARN(1, "ceph: reply dir mismatch (parent valid %llx.%llx reply %llx.%llx)\n",
+         ceph_ino(parent), ceph_snap(parent), vino.ino, vino.snap);
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


