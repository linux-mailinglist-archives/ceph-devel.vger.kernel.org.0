Return-Path: <ceph-devel+bounces-937-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2770486BFD7
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Feb 2024 05:22:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC5D2284B2D
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Feb 2024 04:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F35CF37719;
	Thu, 29 Feb 2024 04:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpUyTEnu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB0C376E4
	for <ceph-devel@vger.kernel.org>; Thu, 29 Feb 2024 04:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709180531; cv=none; b=SX5sxBgrfNKoD9OoaE+Dh3XzM9ZGK7PBT02M+mi6qLG2dJH+aUS91YgsJzAdtDQjAt5k+b18RwVKcOUoh360BsJj7rSqAzcXdl2Vdi6XaEr+yUdd+P/BFki5uBy9Rnin5MLg9rt1s08KTHtEWJdo9mkPvL5PXxoRVfBMflLteW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709180531; c=relaxed/simple;
	bh=kKaaxdsU82qdSqRsR3fpq8hi38e/VeQJB9GbIdITGGo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pNR1LY5tYJjB3Me52CDL1k1VvoVH2KfbnQtDtH3nHYm6VOXhwcrsaRo4s4TUA01lFkD+tt70JAuYzYGr0E82t/Q9dEN4YhaRlqvtj3JUg8RGV4zLixBKCa7GCrLwsDNdfze/MIOnLZLK0QBSBldSNVojovWY9bN1CiyaXIAa7lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpUyTEnu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709180528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wX2/lKIfWZcCklNHF8a+xGBkRbnPqe+dovfkPOWmCCY=;
	b=bpUyTEnuwNsgV8D3JQwGFkguWvADeJ4ERVQfFhGHIQhWutFdv3LoRNXaQeJEtu/RmD10vP
	z5sV0GJC3K8KgbsJN2fVdwp8P0wf0Xtdhmgiz4PvuyeQaghvn159sE4B7ixVh1c2VhYEtY
	a4wiOxb4eolP/S7Vk4fKBeui0BqHxJg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-ofWSeSjdMbeSRDGeOk3qAQ-1; Wed,
 28 Feb 2024 23:22:07 -0500
X-MC-Unique: ofWSeSjdMbeSRDGeOk3qAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8CF33C0ED45;
	Thu, 29 Feb 2024 04:22:06 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.85])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3504D400D783;
	Thu, 29 Feb 2024 04:22:02 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	stable@vger.kernel.org,
	Luis Henriques <lhenriques@suse.de>
Subject: [PATCH] libceph: init the cursor when preparing the sparse read
Date: Thu, 29 Feb 2024 12:19:50 +0800
Message-ID: <20240229041950.738878-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Xiubo Li <xiubli@redhat.com>

The osd code has remove cursor initilizing code and this will make
the sparse read state into a infinite loop. We should initialize
the cursor just before each sparse-read in messnger v2.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/64607
Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on the socket")
Reported-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/messenger_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index a0ca5414b333..7ae0f80100f4 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 static int prepare_sparse_read_data(struct ceph_connection *con)
 {
 	struct ceph_msg *msg = con->in_msg;
+	u64 len = con->in_msg->sparse_read_total ? : data_len(con->in_msg);
 
 	dout("%s: starting sparse read\n", __func__);
 
@@ -2034,6 +2035,8 @@ static int prepare_sparse_read_data(struct ceph_connection *con)
 	if (!con_secure(con))
 		con->in_data_crc = -1;
 
+	ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, len);
+
 	reset_in_kvecs(con);
 	con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
 	con->v2.data_len_remain = data_len(msg);
-- 
2.43.0


