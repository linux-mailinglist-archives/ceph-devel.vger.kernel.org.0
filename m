Return-Path: <ceph-devel+bounces-3351-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0011DB19F26
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Aug 2025 12:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77B4F7A265F
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Aug 2025 09:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE15248166;
	Mon,  4 Aug 2025 09:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YiqEVb6E"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BC11C6FF5
	for <ceph-devel@vger.kernel.org>; Mon,  4 Aug 2025 09:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754301598; cv=none; b=ak+QQFqwCE7JGXuv9khmnIpfWhZHJv21TzuUdwhvUM/QA6lxXV++1gDEc76WaOIhoMU1i875D7O5Q0DnrsyU7x90mexHpCPMthkcNMphqiR8xfJfq0nyn/Z3qP+0wwh47rG7+WpAF8m1vmuGOTEv2T4t5qzCaaYBoW5DzXfNSKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754301598; c=relaxed/simple;
	bh=3ksWP6pfixZY81YtiYC+chRXxSOGQDzyt8L7OQfG2v0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZLPpZ7G8w+agQ6Ercokhk1fLJEfTIyVVyAv9Lwp2wHkYdPepdhu4HDLREP1Nb60ApSrKnjvSPWUMqlUBmmvGCfUg4+cXZd/LEEGofi/m1NUoEm+EDYNPm2NsyPFCGlOG6fj0NscN5qzNoS0BVK0Qn4IZ2A4aaJt6zK4V5LhHKjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YiqEVb6E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754301596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4uotoFYubX4ZtXqSpgKHCX/SSQDrgaT9v955ZDKGWl4=;
	b=YiqEVb6Eq4S1BdJku0DQmF7eLtp711uINUQSwWdWY2sUhLB1C95OspkbsYPvzDgNzbM/Lp
	miQuUVVRFIL7EaMcXqGi/rVZqaUgWaO/SM2iQq2pYN8lTNuyQGL7sKAYnLUXIwmOgNAc7x
	rjzngWZnIlN/evafxSsmDJzsR76/QH8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-ur-KWP3FMBOOArMjq8XIQA-1; Mon, 04 Aug 2025 05:59:55 -0400
X-MC-Unique: ur-KWP3FMBOOArMjq8XIQA-1
X-Mimecast-MFC-AGG-ID: ur-KWP3FMBOOArMjq8XIQA_1754301594
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-af97757b46eso14606666b.3
        for <ceph-devel@vger.kernel.org>; Mon, 04 Aug 2025 02:59:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754301593; x=1754906393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4uotoFYubX4ZtXqSpgKHCX/SSQDrgaT9v955ZDKGWl4=;
        b=PUKJ+dz3lwcM/q/newR1WGJv5YFSHpR56GoWKnVD00cHk2wgzaFIrF97U+SgrBvxU0
         h5SWFcEgOS4+B0bLZj7iWWAv2YjS54gtOGAFRFoCMPtUj1tyY5TxdnaNIs7l8RfKWXvm
         tmJoshcgz9oIHjhYeZSmkKA3YPwh5th/gI+1x+/j82nXxNrYe5ReA5V5VVlocKlf9vEu
         SijliQjj6zc20n/grulzje7nGtiORlqd4gANSGkbVcxT1okGbdZUDiSW8bYkiDM0j+d7
         Ns5A7IRDgT1htotOihr/bwGEiGZD3UFXa1+1byzdAwhbr2s8ut+2XRVMYLsJCPNNotGP
         xMLQ==
X-Gm-Message-State: AOJu0YwoSO2uiagwRA8ZS8WWbG26hzwGR2rSR8SXD5N2/I6+gzvyPiKi
	41KSMvsWVUc2pmI6qQmsKOkVE+nQO/f6eoPlQGfhXHiUWNHMKL/cZqu44viwKHgEc/d3t9sVeM5
	uczZ8jMoKQLhnwKz3avrx3ILm9nEgxmUTHvp6+y2D1wPAYp3WNBf3UTaz0lNellDHlSbsMo7rea
	p0fMPVkJ7WmI8Co+KL3DuUbnq+s0raSXiINjbtLF4fpiGmvNW64I+5
X-Gm-Gg: ASbGnctGa5bzDF+d0CbyoWE8d3xbSn/HZU8uqKWuNJ+AGM2YxOOybj6aNj3SC8YPqfy
	ubdMAqNuTqTqEzUBueZOcZ7iV4BwpBcXOxHEyPqxr2N5yzyoyjs4AGzVIr1Cqtkx21gdSQDhhhz
	CdkrHacdYTQeO47tzHWIjA8ROkq1cNSyOxEjh8Xk31WIW7cYaQxN8z8BEZc18UPUY8neMxkw0CL
	TpHnI2vtW9mD2O0kP06fwTzIUR96ggm58lr+quLiX7PdYYepjWCTfHto79K3Ca5V9RY45nL7/G4
	R9Ux8Imdn9IZsCgCSwH0Kh/m7IVB27FUMT4WTXbr/welSvARivdzjdBC6XZQaFTRia5I0Ur/iw=
	=
X-Received: by 2002:a17:907:3fa2:b0:ae0:ad5c:4185 with SMTP id a640c23a62f3a-af94024f22emr924328066b.57.1754301593524;
        Mon, 04 Aug 2025 02:59:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+nnHYbeFkYXBWGzroGgRCReKRjMsUUhkQES2+aUsPNuNZysvQn/YuZujog/jnwUM/EWJm9A==
X-Received: by 2002:a17:907:3fa2:b0:ae0:ad5c:4185 with SMTP id a640c23a62f3a-af94024f22emr924324866b.57.1754301593017;
        Mon, 04 Aug 2025 02:59:53 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a078bcbsm715458766b.13.2025.08.04.02.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 02:59:52 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH v2 2/2] ceph: fix client race condition where r_parent becomes stale before sending message
Date: Mon,  4 Aug 2025 09:59:42 +0000
Message-Id: <20250804095942.2167541-3-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250804095942.2167541-1-amarkuze@redhat.com>
References: <20250804095942.2167541-1-amarkuze@redhat.com>
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
index 814f9e9656a0..7da648b5e901 100644
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


