Return-Path: <ceph-devel+bounces-101-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D8D7EDBD3
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 08:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25B5C280F47
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 07:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EAB6D516;
	Thu, 16 Nov 2023 07:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BlQWhbBt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5806019D
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 23:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700118950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LwoZ33AUJSb4k9JgS4boiSLGm1plZCrQA70zBu0sQyY=;
	b=BlQWhbBtKIIRKYTjAzWVXOqH1jU08D8VBu1KUmDnFY5J/qii/0xKALu7JN6HLsfABZ1enX
	IcQ8S4YQmnSm8P3VSufkL/kE0BFCMt/SN2nZqotB0iEvu+vKXphJeX230R4yWo3n+TIpAF
	R7k9sz4hcxn+uqJfq3dVRbQAx/1SjGM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-IHamH-IjMUi_bd1d3OOfwA-1; Thu,
 16 Nov 2023 02:15:48 -0500
X-MC-Unique: IHamH-IjMUi_bd1d3OOfwA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1904C383DC5E;
	Thu, 16 Nov 2023 07:15:48 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.63])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F194492BFD;
	Thu, 16 Nov 2023 07:15:44 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	idryomov@gmail.com,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: rename create_session_open_msg() to create_session_full_msg()
Date: Thu, 16 Nov 2023 15:13:37 +0800
Message-ID: <20231116071338.678918-2-xiubli@redhat.com>
In-Reply-To: <20231116071338.678918-1-xiubli@redhat.com>
References: <20231116071338.678918-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

From: Xiubo Li <xiubli@redhat.com>

Makes the create session msg helper to be more general and could
be used by other OPs.

URL: https://tracker.ceph.com/issues/63364
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 81040052eb4d..fdfea11d9568 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1534,7 +1534,8 @@ static int encode_metric_spec(void **p, void *end)
  * session message, specialization for CEPH_SESSION_REQUEST_OPEN
  * to include additional client metadata fields.
  */
-static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u64 seq)
+static struct ceph_msg *
+create_session_full_msg(struct ceph_mds_client *mdsc, int op, u64 seq)
 {
 	struct ceph_msg *msg;
 	struct ceph_mds_session_head *h;
@@ -1589,7 +1590,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 	end = p + msg->front.iov_len;
 
 	h = p;
-	h->op = cpu_to_le32(CEPH_SESSION_REQUEST_OPEN);
+	h->op = cpu_to_le32(op);
 	h->seq = cpu_to_le64(seq);
 
 	/*
@@ -1663,7 +1664,8 @@ static int __open_session(struct ceph_mds_client *mdsc,
 	session->s_renew_requested = jiffies;
 
 	/* send connect message */
-	msg = create_session_open_msg(mdsc, session->s_seq);
+	msg = create_session_full_msg(mdsc, CEPH_SESSION_REQUEST_OPEN,
+				      session->s_seq);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 	ceph_con_send(&session->s_con, msg);
-- 
2.41.0


