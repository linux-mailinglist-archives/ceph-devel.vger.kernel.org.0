Return-Path: <ceph-devel+bounces-41-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 374F37E1848
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 02:19:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A3D21C20AD0
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 01:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC63D39B;
	Mon,  6 Nov 2023 01:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V5uuFBZ5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD1164C
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 01:19:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E97DD
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 17:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699233552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NeEL1NoYy5RsozzAwLXe7Xb5cfcgSIiDgHbSxXMXQMs=;
	b=V5uuFBZ58akNRWFo6/RE899IYiQLUB1k7yq0+CDggccJ5oRvad1g+iPUqEanQYrKXVL0t/
	1ca4xKWcq6gjMRNPQjJVr90ouArCQLZgsV1K5c4z+NggCDFMjtFUWl7KJ6M3fHFRrW1ujs
	/spl1sbx3wvFomfBhi5IxW6jbUIndws=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-183-FlipThMBNx-ToOIPxYvpzw-1; Sun,
 05 Nov 2023 20:19:08 -0500
X-MC-Unique: FlipThMBNx-ToOIPxYvpzw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AC811C068CC;
	Mon,  6 Nov 2023 01:19:08 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.124])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 855C51121307;
	Mon,  6 Nov 2023 01:19:05 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/2] libceph: check the data length when sparse-read finishes
Date: Mon,  6 Nov 2023 09:16:44 +0800
Message-ID: <20231106011644.248119-3-xiubli@redhat.com>
In-Reply-To: <20231106011644.248119-1-xiubli@redhat.com>
References: <20231106011644.248119-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

From: Xiubo Li <xiubli@redhat.com>

For sparse reading the real length of the data should equal to the
total length from the extent array.

URL: https://tracker.ceph.com/issues/62081
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/osd_client.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 0e629dfd55ee..050dc39065fb 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5920,6 +5920,12 @@ static int osd_sparse_read(struct ceph_connection *con,
 		fallthrough;
 	case CEPH_SPARSE_READ_DATA:
 		if (sr->sr_index >= count) {
+			if (sr->sr_datalen && count) {
+				pr_warn_ratelimited("%s: datalen and extents mismath, %d left\n",
+						    __func__, sr->sr_datalen);
+				return -EREMOTEIO;
+			}
+
 			sr->sr_state = CEPH_SPARSE_READ_HDR;
 			goto next_op;
 		}
@@ -5927,6 +5933,8 @@ static int osd_sparse_read(struct ceph_connection *con,
 		eoff = sr->sr_extent[sr->sr_index].off;
 		elen = sr->sr_extent[sr->sr_index].len;
 
+		sr->sr_datalen -= elen;
+
 		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
 		     o->o_osd, sr->sr_index, eoff, elen);
 
-- 
2.39.1


