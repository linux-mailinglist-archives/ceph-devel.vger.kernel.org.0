Return-Path: <ceph-devel+bounces-991-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8BB881B2A
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Mar 2024 03:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC65228529F
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Mar 2024 02:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43AC1FA2;
	Thu, 21 Mar 2024 02:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JWE8oM+K"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502785660
	for <ceph-devel@vger.kernel.org>; Thu, 21 Mar 2024 02:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710987484; cv=none; b=u13bW7omIJNljbfpgMfiHPvYwYxl2tq9CVNDOzpuYtBT8CRWh/BHYFCL8z+DAvXv+1PIu98u3JzoKpMi/0WSz13sO43xq6yDISxpO3yPH/0VEH/MxsW5i+tsDqgUulgI+gKjVRAuPIPDvvc6UzCmSrp8f+XXZA+XzQk3wzi42e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710987484; c=relaxed/simple;
	bh=Cat/Tvq3oeGsG9xqSx7bX74Fygx9pXxw2MmBcSTxezA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o0wZa+VeVrEqe20qptwAwkkXNt5SjVhvZs3+4N0+mFLu1H40oLXGjPRx8MTKccXVOZfjmeWhl/M1gH44H7JVA5wJI2qruROAl5F64mEaNYTrgBwRVjE53t992uWAS9x0J3GqS77XHNYoShkWT7R3rat7W+ibjGID0wl9luDwR+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JWE8oM+K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710987480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=j59PTLMDxYOFJM3q5U1JQbi4m2vsY64uVQTexjFuzik=;
	b=JWE8oM+K9g/Rsz1zU3PiUkV5W+mDJPcGOl7ZkK7CLUYLclXFtzCXf+hjhY4g3fQSv7/c+d
	JvistTvpEVpTK+c7gNEWQ7Dj6fnF2NNa4IQgrhinbKE3PhXZZStAXh/6vdTTvttOEni0rB
	wr2/hK5IoGQt8wHfi6YZwgM1YY5KIL0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-fVgzoMBpMRu2k3y1C0UonA-1; Wed, 20 Mar 2024 22:17:55 -0400
X-MC-Unique: fVgzoMBpMRu2k3y1C0UonA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F3F98007A4;
	Thu, 21 Mar 2024 02:17:55 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC5ABC017A0;
	Thu, 21 Mar 2024 02:17:51 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	Stefan Kooman <stefan@bit.nl>
Subject: [PATCH] ceph: make the ceph-cap workqueue UNBOUND
Date: Thu, 21 Mar 2024 10:15:36 +0800
Message-ID: <20240321021536.64693-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Xiubo Li <xiubli@redhat.com>

There is not harm to mark the ceph-cap workqueue unbounded, just
like we do in ceph-inode workqueue.

URL: https://www.spinics.net/lists/ceph-users/msg78775.html
URL: https://tracker.ceph.com/issues/64977
Reported-by: Stefan Kooman <stefan@bit.nl>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 4dcbbaa297f6..0bfe4f8418fd 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -851,7 +851,7 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 	fsc->inode_wq = alloc_workqueue("ceph-inode", WQ_UNBOUND, 0);
 	if (!fsc->inode_wq)
 		goto fail_client;
-	fsc->cap_wq = alloc_workqueue("ceph-cap", 0, 1);
+	fsc->cap_wq = alloc_workqueue("ceph-cap", WQ_UNBOUND, 1);
 	if (!fsc->cap_wq)
 		goto fail_inode_wq;
 
-- 
2.43.0


