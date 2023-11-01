Return-Path: <ceph-devel+bounces-27-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5817DDA67
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Nov 2023 01:53:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87B181C20D16
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Nov 2023 00:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EFFCA40;
	Wed,  1 Nov 2023 00:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B7CefXST"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306127EB
	for <ceph-devel@vger.kernel.org>; Wed,  1 Nov 2023 00:52:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF37DEA
	for <ceph-devel@vger.kernel.org>; Tue, 31 Oct 2023 17:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698799974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jprnKmnNGVC2xwMYvaRrNfAhVlSOBG8tzYw7UCUtXOQ=;
	b=B7CefXSTe2Rt5Q7+vrAzzht8KPfmZ8zJGx1X1pVB1UKWPt2YTN9HtyW2yce1D9FUP1qCAX
	as3xj6ElYdSJRVQK7L3wHDI+0tgnk5AfZfjaVP2uxm6CL/AVHHqbJx5wjSu+gjw1yc/av1
	oA3iBw2i4zHfrday/fmeJoN+w4AbFCE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-_5xeuAy-PZ66bfEhiyDBmA-1; Tue, 31 Oct 2023 20:52:47 -0400
X-MC-Unique: _5xeuAy-PZ66bfEhiyDBmA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EBF085A5BD;
	Wed,  1 Nov 2023 00:52:47 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.128])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5ECFF2166B26;
	Wed,  1 Nov 2023 00:52:43 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] libceph: check the data length when finishes
Date: Wed,  1 Nov 2023 08:50:33 +0800
Message-ID: <20231101005033.21995-3-xiubli@redhat.com>
In-Reply-To: <20231101005033.21995-1-xiubli@redhat.com>
References: <20231101005033.21995-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

For sparse reading the real length of the data should equal to the
total length from the extent array.

URL: https://tracker.ceph.com/issues/62081
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
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
2.41.0


