Return-Path: <ceph-devel+bounces-262-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D66C4809B03
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 05:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 146C31C20D1B
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 04:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8124400;
	Fri,  8 Dec 2023 04:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aYT56KkA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89188D54
	for <ceph-devel@vger.kernel.org>; Thu,  7 Dec 2023 20:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702010050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2iBj4oESqEx4dfQ1FFTemtoUtu0oiWD48NqFUk5NJyU=;
	b=aYT56KkAkYFbNkJ2xz+iL9N/TFBmGiDmnevv8uRbAIIJycyjhi33kqSz71QMI1WqPd7XcY
	s5lUN7ByT7YrPtKS6iBriGeXffUPAlvZ9xWc+S1Na7dRDkfbaeL3/ekJWJ0m6l/3HvjqxB
	+GNP3cRJYY4J0ZXQdmCCoUCPCBVcMDw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-cdgRY_CZNUyQrLv8FxIqWw-1; Thu, 07 Dec 2023 23:34:07 -0500
X-MC-Unique: cdgRY_CZNUyQrLv8FxIqWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE892185A780;
	Fri,  8 Dec 2023 04:34:06 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.27])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDE6E2166AE2;
	Fri,  8 Dec 2023 04:34:03 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] libceph: just wait for more data to be available on the socket
Date: Fri,  8 Dec 2023 12:33:05 +0800
Message-ID: <20231208043305.91249-3-xiubli@redhat.com>
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

The messages from ceph maybe split into multiple socket packages
and we just need to wait for all the data to be availiable on the
sokcet.

URL: https://tracker.ceph.com/issues/63586
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/messenger_v1.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index f9a50d7f0d20..aff81fef932f 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -1160,15 +1160,17 @@ static int read_partial_message(struct ceph_connection *con)
 	/* header */
 	size = sizeof(con->v1.in_hdr);
 	end = size;
-	ret = read_partial(con, end, size, &con->v1.in_hdr);
-	if (ret <= 0)
-		return ret;
+	if (con->v1.in_base_pos < end) {
+		ret = read_partial(con, end, size, &con->v1.in_hdr);
+		if (ret <= 0)
+			return ret;
 
-	crc = crc32c(0, &con->v1.in_hdr, offsetof(struct ceph_msg_header, crc));
-	if (cpu_to_le32(crc) != con->v1.in_hdr.crc) {
-		pr_err("read_partial_message bad hdr crc %u != expected %u\n",
-		       crc, con->v1.in_hdr.crc);
-		return -EBADMSG;
+		crc = crc32c(0, &con->v1.in_hdr, offsetof(struct ceph_msg_header, crc));
+		if (cpu_to_le32(crc) != con->v1.in_hdr.crc) {
+			pr_err("read_partial_message bad hdr crc %u != expected %u\n",
+			       crc, con->v1.in_hdr.crc);
+			return -EBADMSG;
+		}
 	}
 
 	front_len = le32_to_cpu(con->v1.in_hdr.front_len);
-- 
2.43.0


