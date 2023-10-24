Return-Path: <ceph-devel+bounces-6-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 937BC7D46CD
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Oct 2023 07:03:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3151EB20D02
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Oct 2023 05:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FF363AC;
	Tue, 24 Oct 2023 05:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QzSLfhoE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8119D5250
	for <ceph-devel@vger.kernel.org>; Tue, 24 Oct 2023 05:03:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547E21A4
	for <ceph-devel@vger.kernel.org>; Mon, 23 Oct 2023 22:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698123807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y0jQsmxP+0JJXk1ftassBNI6/YPO3FyLbpWx9jswbms=;
	b=QzSLfhoELHYu9KWK8N8nFK/qOzpp6/rzIDEQl5qEloIJJg5dYc0YRmJhFvQY2gac+cBxFH
	YYTXI+IThlkLpm4JUhgVEJRZhWE2eE//6XuVwPnrEwvgwMyZhp4yYgwrC2+uvGVpTZtDl/
	UjbL9Y9kwgl0hUvBeWBV9cQlW5vWvQY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-5RRrKIdWO0-HightyeaDWw-1; Tue, 24 Oct 2023 01:03:07 -0400
X-MC-Unique: 5RRrKIdWO0-HightyeaDWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAA76185A78E;
	Tue, 24 Oct 2023 05:03:06 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.168])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12E4B25C0;
	Tue, 24 Oct 2023 05:03:03 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/3] libceph: check the data length when finishes
Date: Tue, 24 Oct 2023 13:00:39 +0800
Message-ID: <20231024050039.231143-4-xiubli@redhat.com>
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

For sparse reading the real length of the data should equal to the
total length from the extent array.

URL: https://tracker.ceph.com/issues/62081
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/osd_client.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 800a2acec069..7af35106acaf 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5921,6 +5921,13 @@ static int osd_sparse_read(struct ceph_connection *con,
 		fallthrough;
 	case CEPH_SPARSE_READ_DATA:
 		if (sr->sr_index >= count) {
+			if (sr->sr_datalen && count) {
+				pr_warn_ratelimited("sr_datalen %d sr_index %d count %d\n",
+						    sr->sr_datalen, sr->sr_index,
+						    count);
+				WARN_ON_ONCE(sr->sr_datalen);
+			}
+
 			sr->sr_state = CEPH_SPARSE_READ_HDR;
 			goto next_op;
 		}
@@ -5928,6 +5935,8 @@ static int osd_sparse_read(struct ceph_connection *con,
 		eoff = sr->sr_extent[sr->sr_index].off;
 		elen = sr->sr_extent[sr->sr_index].len;
 
+		sr->sr_datalen -= elen;
+
 		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
 		     o->o_osd, sr->sr_index, eoff, elen);
 
-- 
2.39.1


