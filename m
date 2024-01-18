Return-Path: <ceph-devel+bounces-584-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1788C831712
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 11:53:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AB881C22211
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 10:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483FF2377A;
	Thu, 18 Jan 2024 10:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AU3t21js"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B9522F06
	for <ceph-devel@vger.kernel.org>; Thu, 18 Jan 2024 10:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575189; cv=none; b=EmM9b8LFVx0PIQrGN1AUYPpuD9OtFZL77u2YSsTSXV9gs4HJnQAePtSoEgNC93OZVP9ONcBokd4ZX4642Jar8Tb8Rj+DFX9cwpUdl3gTZLJ73VXZ1UFE1nIZAg9Ezh4LFUc1+wR7xYuRbW5oysM8aIC/P1n3u0IcNbsFyVQfV2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575189; c=relaxed/simple;
	bh=lARG60+yEeBfctx2lgyF7Mf/1TOgOxqBtXjvdSfY39k=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By; b=DwiX/yMWYoeCZkpCemnlDddtfTAxVRMxFDC6IAMfn6krc809wzb04Z/RlxAGf/A0JBjkCNohK8otJH5S31UISzcFIn3FSaG4HuFeGLMDFMUCNi5Xvo08cg8EvmCuiyvR10dJA5HigEfUlQpo6woPxxVVTavk3cHsPKjvI8unFhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AU3t21js; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705575186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zKgYZs6xoNW0t7R/S+SqB3PMTQfMwTdhZMSMbm4mr6I=;
	b=AU3t21jssHqPVaE5EE+QYYtxF5QmrwOTWtnI8dgKrP20kvFy5HJvsmIJH7UM3weemEd4O/
	puF27Kyy6zlOCEV8QUU38A36aI+XNpElx5w7ZzNJUfb0mTiJJDaOFjsM2+ux+FjvSQ52eu
	Q6aB43ExXGSUx5tt1gB7W2ddyHw7gx0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-gLpzClq9NCKgD7aOZ2wIOw-1; Thu,
 18 Jan 2024 05:53:03 -0500
X-MC-Unique: gLpzClq9NCKgD7aOZ2wIOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB67D1C0BB6E;
	Thu, 18 Jan 2024 10:53:02 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D65172166B33;
	Thu, 18 Jan 2024 10:52:59 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 1/3] libceph: fail the sparse-read if there still has data in socket
Date: Thu, 18 Jan 2024 18:50:45 +0800
Message-ID: <20240118105047.792879-2-xiubli@redhat.com>
In-Reply-To: <20240118105047.792879-1-xiubli@redhat.com>
References: <20240118105047.792879-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

Once this happens that means there have bugs.

URL: https://tracker.ceph.com/issues/63586
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/osd_client.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 9be80d01c1dc..f8029b30a3fb 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5912,6 +5912,13 @@ static int osd_sparse_read(struct ceph_connection *con,
 		fallthrough;
 	case CEPH_SPARSE_READ_DATA:
 		if (sr->sr_index >= count) {
+			if (sr->sr_datalen) {
+				pr_warn_ratelimited("sr_datalen %u sr_index %d count %u\n",
+						    sr->sr_datalen, sr->sr_index,
+						    count);
+				return -EREMOTEIO;
+			}
+
 			sr->sr_state = CEPH_SPARSE_READ_HDR;
 			goto next_op;
 		}
@@ -5919,6 +5926,8 @@ static int osd_sparse_read(struct ceph_connection *con,
 		eoff = sr->sr_extent[sr->sr_index].off;
 		elen = sr->sr_extent[sr->sr_index].len;
 
+		sr->sr_datalen -= elen;
+
 		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
 		     o->o_osd, sr->sr_index, eoff, elen);
 
-- 
2.43.0


