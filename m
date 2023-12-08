Return-Path: <ceph-devel+bounces-271-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7BB080A83B
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 17:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EF622817EA
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 16:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD7337174;
	Fri,  8 Dec 2023 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbLhLsmT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F1A198C
	for <ceph-devel@vger.kernel.org>; Fri,  8 Dec 2023 08:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702051704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ULBg+Xts6xLVxY1zqrdd6exvruwenCwULOJ/Ux+qrEc=;
	b=PbLhLsmTHvjSxu+UMtE7dVim5cobC9hHhTD9VnNmvRcB3qYAJetNzaV7QXQVC9ckVzYD6+
	OrLWGmgV45VgpqXA3t/pLQ2pCQsBpgTc1jmwJRxWF+v8ULbSPaSS9zegFA5ocblCUGKgTE
	vKf0vWf4sfFE/SsOQO6MJJKcaOe3JiA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-w8WuXpo7NsuFJpMnZ_D3aQ-1; Fri,
 08 Dec 2023 11:08:22 -0500
X-MC-Unique: w8WuXpo7NsuFJpMnZ_D3aQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9789F3833351;
	Fri,  8 Dec 2023 16:08:22 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.27])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D78C18CD0;
	Fri,  8 Dec 2023 16:08:19 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/2] libceph: fail the sparse-read if there still has data in socket
Date: Sat,  9 Dec 2023 00:06:00 +0800
Message-ID: <20231208160601.124892-2-xiubli@redhat.com>
In-Reply-To: <20231208160601.124892-1-xiubli@redhat.com>
References: <20231208160601.124892-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Xiubo Li <xiubli@redhat.com>

Once this happens that means there have bugs.

URL: https://tracker.ceph.com/issues/63586
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/osd_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 5753036d1957..848ef19055a0 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5912,10 +5912,12 @@ static int osd_sparse_read(struct ceph_connection *con,
 		fallthrough;
 	case CEPH_SPARSE_READ_DATA:
 		if (sr->sr_index >= count) {
-			if (sr->sr_datalen && count)
+			if (sr->sr_datalen) {
 				pr_warn_ratelimited("sr_datalen %u sr_index %d count %u\n",
 						    sr->sr_datalen, sr->sr_index,
 						    count);
+				return -EREMOTEIO;
+			}
 
 			sr->sr_state = CEPH_SPARSE_READ_HDR;
 			goto next_op;
-- 
2.43.0


