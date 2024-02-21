Return-Path: <ceph-devel+bounces-887-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A772985CE97
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 04:13:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 129BFB234B8
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 03:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D9E36120;
	Wed, 21 Feb 2024 03:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZkiTpY6F"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6865246A4
	for <ceph-devel@vger.kernel.org>; Wed, 21 Feb 2024 03:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708485198; cv=none; b=rfED5ypGGQ+0txPABR28FaIJKV4uc0ahPFerCOFq4mmfpQs2dFg+aGjPzQ7/0oYFtDXPVjLB3nudancncNBe6eu0XA565iVVyKf7m0NCK20U3IrFdF2a4TW4ksnrpE12WcY3l6JjVZIZFal7mZuZ9BhXBvlGqa3AAIngLZ1gTBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708485198; c=relaxed/simple;
	bh=firMZikqE8nUsArRin7eoppaPOJ3nirf5ZwCYsQY264=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mUNPlzOiQY2aSB41RpmiFiYSh2BhgwlDRAfk6QKRYFM2LVjqeXWu1I93y8BX6xZpyabK6+2sdue4nrdQL26EM8vGIz8UF8EdlLNgtRlpYhRSEfwfDSnj330yXCollZU/q0E7DHmvKYlWGPXSbghdS10B7pvPmWYN1imey9pjHCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZkiTpY6F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708485195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QIovgAvQUIuM1W4P3Mucg7+IUqNvNLU8T0fKJAJupJ8=;
	b=ZkiTpY6FmXoOBwoRWditUv3XeMvmP2oqJu8FYzh6p5wOlOS+/PWor9w4r7oLSzPgAbaHr2
	x4WKls6cWVQWTVzlpzg7JkmJjNu6pfRyGMuV9WnHYCLUyhgEH4XsFcOy5cCu/ecrJWLGXb
	m4WBbXEJ00hq4Md0qEeQWE2jeIS3OOg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-5IwgEVhZO6WJ_VgxMduJQA-1; Tue,
 20 Feb 2024 22:13:10 -0500
X-MC-Unique: 5IwgEVhZO6WJ_VgxMduJQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26A2E1C07F27;
	Wed, 21 Feb 2024 03:13:10 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.141])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E03B910F4C;
	Wed, 21 Feb 2024 03:13:06 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH v2] ceph: reverse MDSMap dencoding of max_xattr_size/bal_rank_mask
Date: Wed, 21 Feb 2024 11:10:52 +0800
Message-ID: <20240221031052.68959-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

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
---

V2:
- minor fix in the comment





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
index 89f1931f1ba6..43337e9ed539 100644
--- a/fs/ceph/mdsmap.h
+++ b/fs/ceph/mdsmap.h
@@ -27,7 +27,11 @@ struct ceph_mdsmap {
 	u32 m_session_timeout;          /* seconds */
 	u32 m_session_autoclose;        /* seconds */
 	u64 m_max_file_size;
-	u64 m_max_xattr_size;		/* maximum size for xattrs blob */
+	/*
+	 * maximum size for xattrs blob.
+	 * Setting it to 0 will force the usage of the (sync) SETXATTR Op.
+	 */
+	u64 m_max_xattr_size;
 	u32 m_max_mds;			/* expected up:active mds number */
 	u32 m_num_active_mds;		/* actual up:active mds number */
 	u32 possible_max_rank;		/* possible max rank index */
-- 
2.43.0


