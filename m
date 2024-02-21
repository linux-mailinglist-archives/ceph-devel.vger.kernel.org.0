Return-Path: <ceph-devel+bounces-891-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55CB685CF61
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 05:54:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 068701F2196E
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 04:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB1BD39851;
	Wed, 21 Feb 2024 04:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFvBjIk4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855053984A
	for <ceph-devel@vger.kernel.org>; Wed, 21 Feb 2024 04:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708491257; cv=none; b=p3y8x3c7mndGZlyOG8VrH4Y7oTsE0pAc7/C6xmQF2SnhLxKyb5OxuWOezEKGm55PufNAEpopzeiKmnglFOdpp/cpvglI0uZ1J9zt59cXvXDlAZ0Y9TiyAnIdWoOKvGIVZs2oyc8e4IQ2op1vMErhgWLqht9QNxXn5SDFLsYBddc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708491257; c=relaxed/simple;
	bh=YsMYYfzoOyqX/IYbwdJ1BIggWqVYspCiExIEEm623Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CRK0PmTmL4/lpKYylXefzGYJlaeXr4j4yM6Fx3tHTywY4ogWygabp73wz/sLOvhRKQX0+3P3WfhHVagcfSrdi7/D+OmY4+yUVl+JS8dgDLVwr3viuJgf8dyLFbekszJxirePnd8Dp0bJcFCoxScXxZWne73tZBFsiMBWJTb4IJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hFvBjIk4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708491254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C+ENwtjHVh/vGO6j1hLCBBVylr2JBm1f2bie+92ZIsE=;
	b=hFvBjIk4VD/g0MSxn2CmyAEZYce0RCB6EtVj22adzsI80MSiEoRBHaD8EuUJj89eU7eot+
	vCYRfdIt/Ce3BmPEcUIqSlZD/bdNw4dUZsFH90n31wiko8/5u+2tG/570RtAxxttbigOhh
	wJeo7T4fyQ+n3u0F0uZLtOZ9IdmnQmw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-b_MK_h2lMaagSt-hzNKgeg-1; Tue, 20 Feb 2024 23:54:10 -0500
X-MC-Unique: b_MK_h2lMaagSt-hzNKgeg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7391A1064BFC;
	Wed, 21 Feb 2024 04:54:10 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.141])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8D9112166AEA;
	Wed, 21 Feb 2024 04:54:06 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Patrick Donnelly <pdonnell@ibm.com>
Subject: [PATCH v3] ceph: reverse MDSMap dencoding of max_xattr_size/bal_rank_mask
Date: Wed, 21 Feb 2024 12:51:58 +0800
Message-ID: <20240221045158.75644-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

Ceph added the bal_rank_mask with encoded (ev) version 17.  This
was merged into main Oct 2022 and made it into the reef release
normally. While a latter commit added the max_xattr_size also
with encoded (ev) version 17 but places it before bal_rank_mask.

And this will breaks some usages, for example when upgrading old
cephs to newer versions.

URL: https://tracker.ceph.com/issues/64440
Reported-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@ibm.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
---

V3:
- Fix the comment suggested by Patrick in V2.


 fs/ceph/mdsmap.c | 7 ++++---
 fs/ceph/mdsmap.h | 6 +++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index fae97c25ce58..8109aba66e02 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -380,10 +380,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		ceph_decode_skip_8(p, end, bad_ext);
 		/* required_client_features */
 		ceph_decode_skip_set(p, end, 64, bad_ext);
+		/* bal_rank_mask */
+		ceph_decode_skip_string(p, end, bad_ext);
+	}
+	if (mdsmap_ev >= 18) {
 		ceph_decode_64_safe(p, end, m->m_max_xattr_size, bad_ext);
-	} else {
-		/* This forces the usage of the (sync) SETXATTR Op */
-		m->m_max_xattr_size = 0;
 	}
 bad_ext:
 	doutc(cl, "m_enabled: %d, m_damaged: %d, m_num_laggy: %d\n",
diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
index 89f1931f1ba6..1f2171dd01bf 100644
--- a/fs/ceph/mdsmap.h
+++ b/fs/ceph/mdsmap.h
@@ -27,7 +27,11 @@ struct ceph_mdsmap {
 	u32 m_session_timeout;          /* seconds */
 	u32 m_session_autoclose;        /* seconds */
 	u64 m_max_file_size;
-	u64 m_max_xattr_size;		/* maximum size for xattrs blob */
+	/*
+	 * maximum size for xattrs blob.
+	 * Zeroed by default to force the usage of the (sync) SETXATTR Op.
+	 */
+	u64 m_max_xattr_size;
 	u32 m_max_mds;			/* expected up:active mds number */
 	u32 m_num_active_mds;		/* actual up:active mds number */
 	u32 possible_max_rank;		/* possible max rank index */
-- 
2.43.0


