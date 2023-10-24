Return-Path: <ceph-devel+bounces-5-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0627D46CC
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Oct 2023 07:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A64F281846
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Oct 2023 05:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B3C2F5E;
	Tue, 24 Oct 2023 05:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLNi/RP5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C58C79C6
	for <ceph-devel@vger.kernel.org>; Tue, 24 Oct 2023 05:03:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B9FD7B
	for <ceph-devel@vger.kernel.org>; Mon, 23 Oct 2023 22:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698123797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0KQow/qMje6wifzRqHdFILoOHijhLL8PtlQwGXXptc=;
	b=ZLNi/RP5g0SRxu64B/Lwginbm9q54Kb44rtl61MlOKL/Eoy6COym+gW2qAdM8buLHKqSHZ
	ADu4M2hLXTjUxNpap5ctqfvYodCc9xi/gm3wDF/q5NxaqpWLrXSmUPhxKDrcVmp6658+zO
	j0ljEg4MW7ro3t6UsMzAzna9qu28Y7g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-nglan7v4PjKrW_r5dpUHag-1; Tue, 24 Oct 2023 01:03:03 -0400
X-MC-Unique: nglan7v4PjKrW_r5dpUHag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65270802891;
	Tue, 24 Oct 2023 05:03:03 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.168])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB2D1143;
	Tue, 24 Oct 2023 05:03:00 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/3] libceph: save and covert sr_datalen to host-endian
Date: Tue, 24 Oct 2023 13:00:38 +0800
Message-ID: <20231024050039.231143-3-xiubli@redhat.com>
In-Reply-To: <20231024050039.231143-1-xiubli@redhat.com>
References: <20231024050039.231143-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Xiubo Li <xiubli@redhat.com>

We need to save the real data length to determine exactly how many
data we can parse later.

URL: https://tracker.ceph.com/issues/62081
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/osd_client.h | 3 ++-
 net/ceph/osd_client.c           | 7 ++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index bf9823956758..f703fb8030de 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -45,6 +45,7 @@ enum ceph_sparse_read_state {
 	CEPH_SPARSE_READ_HDR	= 0,
 	CEPH_SPARSE_READ_EXTENTS,
 	CEPH_SPARSE_READ_DATA_LEN,
+	CEPH_SPARSE_READ_DATA_PRE,
 	CEPH_SPARSE_READ_DATA,
 };
 
@@ -64,7 +65,7 @@ struct ceph_sparse_read {
 	u64				sr_req_len;  /* orig request length */
 	u64				sr_pos;      /* current pos in buffer */
 	int				sr_index;    /* current extent index */
-	__le32				sr_datalen;  /* length of actual data */
+	u32				sr_datalen;  /* length of actual data */
 	u32				sr_count;    /* extent count in reply */
 	int				sr_ext_len;  /* length of extent array */
 	struct ceph_sparse_extent	*sr_extent;  /* extent array */
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index d3a759e052c8..800a2acec069 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5912,8 +5912,13 @@ static int osd_sparse_read(struct ceph_connection *con,
 		convert_extent_map(sr);
 		ret = sizeof(sr->sr_datalen);
 		*pbuf = (char *)&sr->sr_datalen;
-		sr->sr_state = CEPH_SPARSE_READ_DATA;
+		sr->sr_state = CEPH_SPARSE_READ_DATA_PRE;
 		break;
+	case CEPH_SPARSE_READ_DATA_PRE:
+		/* Convert sr_datalen to host-endian */
+		sr->sr_datalen = le32_to_cpu((__force __le32)sr->sr_datalen);
+		sr->sr_state = CEPH_SPARSE_READ_DATA;
+		fallthrough;
 	case CEPH_SPARSE_READ_DATA:
 		if (sr->sr_index >= count) {
 			sr->sr_state = CEPH_SPARSE_READ_HDR;
-- 
2.39.1


