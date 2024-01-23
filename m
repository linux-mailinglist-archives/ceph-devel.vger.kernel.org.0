Return-Path: <ceph-devel+bounces-647-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A5B838FBE
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jan 2024 14:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 443D81C26346
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jan 2024 13:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81FC25F555;
	Tue, 23 Jan 2024 13:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LKgeOzUs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9785F542
	for <ceph-devel@vger.kernel.org>; Tue, 23 Jan 2024 13:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706015677; cv=none; b=Adjtm7yLA/+CHBpfDd/vYpUCd1TPvaTSXbx9HBtl6o3ZrMS9q4eQaPZQpmipattHTFsk1//YgvMMCvoFGcocYEZDmAq90gdz43SwzM3lI5vOQgnkoT6dSa7CULHXIMZcq/ZV11j4Z/GxG/9/K89GoeyS8Mq7R4NBnUMcWIH9iVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706015677; c=relaxed/simple;
	bh=9PygA3B2rELCpS3b4SVPkPncDOlDortv4SQIacB/hZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPpc+pDG18GtrLwB0Dl9TcHpDX0CXQnVa2PUHSa5w8Inj58MsBg13nd7hNdT3ewpJUcPNPq98qdjp+rIXc+f0mRC2krBs0XjivaEMvF4Pu7XQ+WVcVil/DO7+TlQSBMkrqcKSzkWDyYwR58OKrhLMCJCL3PM12xhKM6yrrazy2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LKgeOzUs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706015674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eoHNIVdBMm5VW4u27kZxO2FDeELoYHINCdDws4AV+KU=;
	b=LKgeOzUs9DVGxocD7ZMmREOHU4ff/lTMELmvfwPGoEV6sUjsxWwFAspKmirVmcZINM3h0Q
	AUOW86oJWCZB/mpGVE6XOakx3zI3haLM0O0lIsuQ2P9Z83llPDthTgPMbqlT2pSstDUMwF
	pPAVVzBSKdhS3ViMGlHJ/uomJLKNBSo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-zmp3QgOJOJ6HsWwi-iA_zw-1; Tue,
 23 Jan 2024 08:14:31 -0500
X-MC-Unique: zmp3QgOJOJ6HsWwi-iA_zw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BC163C0F191;
	Tue, 23 Jan 2024 13:14:31 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21DF02026D66;
	Tue, 23 Jan 2024 13:14:26 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 1/3] libceph: fail the sparse-read if there still has data in socket
Date: Tue, 23 Jan 2024 21:12:02 +0800
Message-ID: <20240123131204.1166101-2-xiubli@redhat.com>
In-Reply-To: <20240123131204.1166101-1-xiubli@redhat.com>
References: <20240123131204.1166101-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Xiubo Li <xiubli@redhat.com>

Once this happens that means there have bugs.

URL: https://tracker.ceph.com/issues/63586
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/osd_client.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 9be80d01c1dc..6beab9be51e2 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5857,8 +5857,8 @@ static int osd_sparse_read(struct ceph_connection *con,
 	struct ceph_osd *o = con->private;
 	struct ceph_sparse_read *sr = &o->o_sparse_read;
 	u32 count = sr->sr_count;
-	u64 eoff, elen;
-	int ret;
+	u64 eoff, elen, len = 0;
+	int i, ret;
 
 	switch (sr->sr_state) {
 	case CEPH_SPARSE_READ_HDR:
@@ -5909,6 +5909,13 @@ static int osd_sparse_read(struct ceph_connection *con,
 		/* Convert sr_datalen to host-endian */
 		sr->sr_datalen = le32_to_cpu((__force __le32)sr->sr_datalen);
 		sr->sr_state = CEPH_SPARSE_READ_DATA;
+		for (i = 0; i < count; i++)
+			len += sr->sr_extent[i].len;
+		if (sr->sr_datalen != len) {
+			pr_warn_ratelimited("data len %u != extent len %llu\n",
+					    sr->sr_datalen, len);
+			return -EREMOTEIO;
+		}
 		fallthrough;
 	case CEPH_SPARSE_READ_DATA:
 		if (sr->sr_index >= count) {
@@ -5919,6 +5926,8 @@ static int osd_sparse_read(struct ceph_connection *con,
 		eoff = sr->sr_extent[sr->sr_index].off;
 		elen = sr->sr_extent[sr->sr_index].len;
 
+		sr->sr_datalen -= elen;
+
 		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
 		     o->o_osd, sr->sr_index, eoff, elen);
 
-- 
2.43.0


