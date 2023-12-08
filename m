Return-Path: <ceph-devel+bounces-272-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1A380A83C
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 17:08:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A760C281833
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 16:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1138A37159;
	Fri,  8 Dec 2023 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fqLJU5RY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF741989
	for <ceph-devel@vger.kernel.org>; Fri,  8 Dec 2023 08:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702051708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rdgn8uBcE/VTGNv+97N7KVitwI+kU0DkHqPR3/b769c=;
	b=fqLJU5RYwlSMxbjy0+JyUOeJe13q+/lJdaVE5sNG+Trr4Yjkg9QeXBGXgAH0r6lTZwt171
	aw8a+yASrA0YtT/1QTNIWXMGX1/oozFUU/v6YW8KukYZ97jPs41fPe/GzNwemchb/oG/65
	7EXrVcmhAby26lFW3UCs54QvaBxRKks=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169-S9BKOglBNT6MsLb3EdOOVA-1; Fri,
 08 Dec 2023 11:08:26 -0500
X-MC-Unique: S9BKOglBNT6MsLb3EdOOVA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 362D93C0278B;
	Fri,  8 Dec 2023 16:08:26 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.27])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 453CF8CE5;
	Fri,  8 Dec 2023 16:08:22 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] libceph: just wait for more data to be available on the socket
Date: Sat,  9 Dec 2023 00:06:01 +0800
Message-ID: <20231208160601.124892-3-xiubli@redhat.com>
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

The messages from ceph maybe split into multiple socket packages
and we just need to wait for all the data to be availiable on the
sokcet.

This will add a new _FINISH state for the sparse-read to mark the
current sparse-read succeeded. Else it will treat it as a new
sparse-read when the socket receives the last piece of the osd
request reply message, and the cancel_request() later will help
init the sparse-read context.

URL: https://tracker.ceph.com/issues/63586
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/osd_client.h | 1 +
 net/ceph/osd_client.c           | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 493de3496cd3..00d98e13100f 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
 	CEPH_SPARSE_READ_DATA_LEN,
 	CEPH_SPARSE_READ_DATA_PRE,
 	CEPH_SPARSE_READ_DATA,
+	CEPH_SPARSE_READ_FINISH,
 };
 
 /*
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 848ef19055a0..f1705b4f19eb 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5802,8 +5802,6 @@ static int prep_next_sparse_read(struct ceph_connection *con,
 			advance_cursor(cursor, sr->sr_req_len - end, false);
 	}
 
-	ceph_init_sparse_read(sr);
-
 	/* find next op in this request (if any) */
 	while (++o->o_sparse_op_idx < req->r_num_ops) {
 		op = &req->r_ops[o->o_sparse_op_idx];
@@ -5919,7 +5917,7 @@ static int osd_sparse_read(struct ceph_connection *con,
 				return -EREMOTEIO;
 			}
 
-			sr->sr_state = CEPH_SPARSE_READ_HDR;
+			sr->sr_state = CEPH_SPARSE_READ_FINISH;
 			goto next_op;
 		}
 
@@ -5952,6 +5950,8 @@ static int osd_sparse_read(struct ceph_connection *con,
 		/* Bump the array index */
 		++sr->sr_index;
 		break;
+	case CEPH_SPARSE_READ_FINISH:
+		return 0;
 	}
 	return ret;
 }
-- 
2.43.0


