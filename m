Return-Path: <ceph-devel+bounces-4-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8897D46CB
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Oct 2023 07:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A33C1F224AB
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Oct 2023 05:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565C579C6;
	Tue, 24 Oct 2023 05:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VTrJkZOk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8219A79C0
	for <ceph-devel@vger.kernel.org>; Tue, 24 Oct 2023 05:03:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309F4B0
	for <ceph-devel@vger.kernel.org>; Mon, 23 Oct 2023 22:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698123782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izi/oE5AQB0oUlSISfoJaQtMtXYXjE/JmvswKQsz1G0=;
	b=VTrJkZOklvBYXSZWnU2tLYGSTKoWkBHTkNykWLVp679X6oMvxikEewlPHZa1YKTP5pCbsz
	ED06f4etVk2UNqWRoZa7DJIDR8MvE1t3/8hSNt9lx0PnE0xiJGvnjRolsVAAN1mbk/fkjD
	qihDrkwCAa5/AFbnvfOIBwC5oM70IWI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-pw2uqqflMy-Q4zksMkaSvw-1; Tue,
 24 Oct 2023 01:03:00 -0400
X-MC-Unique: pw2uqqflMy-Q4zksMkaSvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B4C628078CA;
	Tue, 24 Oct 2023 05:03:00 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.168])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A70425C0;
	Tue, 24 Oct 2023 05:02:57 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/3] libceph: do not decrease the data length more than once
Date: Tue, 24 Oct 2023 13:00:37 +0800
Message-ID: <20231024050039.231143-2-xiubli@redhat.com>
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

No need to decrease the data length again if we need to read the
left data.

URL: https://tracker.ceph.com/issues/62081
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/messenger_v2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index d09a39ff2cf0..9e3f95d5e425 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1966,7 +1966,6 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 				bv.bv_offset = 0;
 			}
 			set_in_bvec(con, &bv);
-			con->v2.data_len_remain -= bv.bv_len;
 			return 0;
 		}
 	} else if (iov_iter_is_kvec(&con->v2.in_iter)) {
-- 
2.39.1


