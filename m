Return-Path: <ceph-devel+bounces-564-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B842D82FFA0
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 05:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBB7EB23D49
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 04:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338A86119;
	Wed, 17 Jan 2024 04:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IhPaHk7z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6B4567D
	for <ceph-devel@vger.kernel.org>; Wed, 17 Jan 2024 04:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705466997; cv=none; b=l8NWouwgshd5idfeO43yHyA89Qi1E4nso7UaeXRuBk22/OI811GQCMlJbHK6pKP27qbQa+g66Zn8Cki2Kao99eIjwv+AIsepFOXjPcNSA9Gn6+DtY/5+CHUR+Tbs0mznSr63620uEL7KTEfFJIPeJlPfziOU0R8zFMe/Lc53hC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705466997; c=relaxed/simple;
	bh=MND/N5C82xOHp6wTm0l6z6i/KZZpd9vr2F0yq/Bcazg=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:
	 X-Scanned-By; b=Y7h1FBx40q6xpzYDysTH2ECYrfcR/PqeOn0d4ZqrgLmkkRlE621KvnjfR2dHWQcFF5B2GC4cHjAIvHWIc1zR/CsqV1SEbCPxFpDJ0vau/kCOw70TtQJE4zmkknjYm5p0dLTNqJdh1uMmjui1lzIITFrXMp7rXQHPYV8t5atCOj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IhPaHk7z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705466995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z1FqyS8zd8u2e/IaKCs6fcAG4PH3wfGz5t+crp919Fc=;
	b=IhPaHk7zPSYLkHvY8JhPJH7q8VJcVCIuYgElLFAnvBksy8xfDvZT4BpPHuHKnzeIhg8NQ2
	37qu4fH3ycVvuxFFTb4TjUEyIMOcBFvgDkAqu9ixkHq6T8K5k9t0NgAE/YfTmGSnU1Pnts
	EwypHrQ4WOpU4/GeQcfupCMT95pDx6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-8APKTkDnPoiCpX8Tt8EZ_A-1; Tue, 16 Jan 2024 23:49:52 -0500
X-MC-Unique: 8APKTkDnPoiCpX8Tt8EZ_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0E591032961;
	Wed, 17 Jan 2024 04:49:51 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A2FDA2026D6F;
	Wed, 17 Jan 2024 04:49:48 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: break the check delayed cap loop every 5s
Date: Wed, 17 Jan 2024 12:47:35 +0800
Message-ID: <20240117044735.701196-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Xiubo Li <xiubli@redhat.com>

In some cases this may take a long time and will block renewing
the caps to MDS.

URL: https://tracker.ceph.com/issues/50223#note-21
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ba94ad6d45fe..5501c86b337d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4647,6 +4647,14 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 			iput(inode);
 			spin_lock(&mdsc->cap_delay_lock);
 		}
+
+		/*
+		 * Just in case too many dirty caps or slow
+		 * performance case won't block the delayed
+		 * work to renew the caps.
+		 */
+		if (jiffies - loop_start >= 5 * HZ)
+			break;
 	}
 	spin_unlock(&mdsc->cap_delay_lock);
 	doutc(cl, "done\n");
-- 
2.39.1


