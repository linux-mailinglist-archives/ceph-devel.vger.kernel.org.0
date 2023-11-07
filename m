Return-Path: <ceph-devel+bounces-63-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E2BA7E335A
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 03:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F5D41C209AA
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 02:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCF415BD;
	Tue,  7 Nov 2023 02:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AKspRPd+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767F920FB
	for <ceph-devel@vger.kernel.org>; Tue,  7 Nov 2023 02:56:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4064511C
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 18:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699325810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zrEXYQOdiAirkzgP5w7SdddNp3gprm/ijV0gPDyOXMY=;
	b=AKspRPd+P/y6p8l5vIZf90MGYJApMxd/ScUr5AsG8e/XTTDrtyN4X1iE3My/FSuxsGDehF
	vN3/ng6RnYRGMNUZzBbeNm68Y5oNEnfq9YMqhj9P1sz6vLyNw2RCmC1weGjMPvrviEqf4v
	ROUDpVWF1TdmeDgYIDsLkxxvHPVjyOM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-ZenKidw9ObmN5EUcxQqMHA-1; Mon, 06 Nov 2023 21:56:46 -0500
X-MC-Unique: ZenKidw9ObmN5EUcxQqMHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E76A101A550;
	Tue,  7 Nov 2023 02:56:46 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F25BCC016B3;
	Tue,  7 Nov 2023 02:56:42 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] libceph: specify the sparse read extent count
Date: Tue,  7 Nov 2023 10:54:22 +0800
Message-ID: <20231107025423.302404-2-xiubli@redhat.com>
In-Reply-To: <20231107025423.302404-1-xiubli@redhat.com>
References: <20231107025423.302404-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Xiubo Li <xiubli@redhat.com>

Try to use the specified extent count to allocate the extent array
memory.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/osd_client.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index f703fb8030de..493de3496cd3 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -573,9 +573,11 @@ int __ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt);
  */
 #define CEPH_SPARSE_EXT_ARRAY_INITIAL  16
 
-static inline int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op)
+static inline int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
 {
-	return __ceph_alloc_sparse_ext_map(op, CEPH_SPARSE_EXT_ARRAY_INITIAL);
+	int _cnt = cnt ? cnt : CEPH_SPARSE_EXT_ARRAY_INITIAL;
+
+	return __ceph_alloc_sparse_ext_map(op, _cnt);
 }
 
 extern void ceph_osdc_get_request(struct ceph_osd_request *req);
-- 
2.41.0


