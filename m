Return-Path: <ceph-devel+bounces-877-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F3C859CDE
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Feb 2024 08:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16DD9280DB9
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Feb 2024 07:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DC93208D7;
	Mon, 19 Feb 2024 07:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LKNqnE5h"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA2D200A8
	for <ceph-devel@vger.kernel.org>; Mon, 19 Feb 2024 07:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708327846; cv=none; b=AMj0FGVh/jfhARlug2C+KweTWh6R7MMQrlHFddRWTyNbDS0+IkQ7pQ4PFyz4KfnPe3M/MXOx0zjow7B7NzT8Eoc0WDhvZAQgwkQdN+wm0aBPv+FX3brcVBc0OIEUEYor6RnGEA4WW0h+wKN7vdmLztxU6nq16mY+N/bn5UUDMB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708327846; c=relaxed/simple;
	bh=fcmiswH5gETvfHfmxK5Qqt7ezwV/vjoUzFWmL0iL7F0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gLkyfhBPN1gEeLCuFr1DLbH6wwui9i6DWFwBqtbSQU2lKJ5l4dhUsdpGCvOuZdlUFjM8U6lQaCumLfT4fpFYxfBpqkE/4opuazvjlYup3M77sSR6UQWfHagYNYZ/asZ+VHlzFo2I2fkey9gAfpTslpmm2TFJBvpDoWAv5a7EGzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LKNqnE5h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708327844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0oTOHI1ld78xCIl+csGrh3KXKL/ZAzjWvqRsCb+xla8=;
	b=LKNqnE5h2T1+jnmaSWZ/NuMLhivE3+57HslaaBfWjnLSOdZdkaj337UyDU7YXxcSsqLjiH
	Q7hmY8zqXHcPxVNX0H0jBMpb/TSGx6WAgxiXz1lWFDaFVFfbHlvQN0nRWvcOtj9lwOc+ai
	BiP52ZeEf2nRhd4Pw6ookWCV3GLMgwo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-T5i48-Q2OqC-VS0dQQlpHw-1; Mon,
 19 Feb 2024 02:30:40 -0500
X-MC-Unique: T5i48-Q2OqC-VS0dQQlpHw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B7C61C54027;
	Mon, 19 Feb 2024 07:30:40 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.169])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04BAA492BE2;
	Mon, 19 Feb 2024 07:30:36 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	pdonnell@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: reverse MDSMap dencoding of max_xattr_size/bal_rank_mask
Date: Mon, 19 Feb 2024 15:28:08 +0800
Message-ID: <20240219072808.39272-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

From: Xiubo Li <xiubli@redhat.com>

Ceph added the bal_rank_mask with encoded (ev) version 17.  This
was merged into main Oct 2022 and made it into the reef release
normally. While a latter commit added the max_xattr_size also
with encoded (ev) version 17 but places it before bal_rank_mask.

And this will breaks some usages, for example when upgrading old
cephs to newer versions.

URL: https://tracker.ceph.com/issues/64440
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
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


