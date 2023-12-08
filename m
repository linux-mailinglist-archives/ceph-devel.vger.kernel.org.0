Return-Path: <ceph-devel+bounces-261-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DDD2809B02
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 05:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65247282282
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 04:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8AAB4C6F;
	Fri,  8 Dec 2023 04:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnWeDzOK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7831720
	for <ceph-devel@vger.kernel.org>; Thu,  7 Dec 2023 20:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702010048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ULBg+Xts6xLVxY1zqrdd6exvruwenCwULOJ/Ux+qrEc=;
	b=GnWeDzOKC4Wm/LJPKSE/qYMOdOXETx87C/kgrycAxY2OVf8HxXTbJ4yci733MfKUEt4Hqn
	H3mfrji4H9eKVSQUmTJLLlqAGTd9qPQAp/EflJqMqbTrZ4Lw/bjWtFY0mCzu4LNcA2SCw8
	R8XmrLzEqC2UCDbZ+vtmOUtYABcwvHA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-D-t3vxhHMRC3Jjn6qwIypg-1; Thu, 07 Dec 2023 23:34:03 -0500
X-MC-Unique: D-t3vxhHMRC3Jjn6qwIypg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C4451014706;
	Fri,  8 Dec 2023 04:34:03 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.27])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DCC8E2166B35;
	Fri,  8 Dec 2023 04:33:59 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] libceph: fail the sparse-read if there still has data in socket
Date: Fri,  8 Dec 2023 12:33:04 +0800
Message-ID: <20231208043305.91249-2-xiubli@redhat.com>
In-Reply-To: <20231208043305.91249-1-xiubli@redhat.com>
References: <20231208043305.91249-1-xiubli@redhat.com>
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


