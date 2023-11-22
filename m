Return-Path: <ceph-devel+bounces-179-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 101D27F3F70
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Nov 2023 09:03:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 884E2B20E27
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Nov 2023 08:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE7B20B31;
	Wed, 22 Nov 2023 08:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dbYyshax"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D67B9
	for <ceph-devel@vger.kernel.org>; Wed, 22 Nov 2023 00:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700640196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FLQphpZjebqy0UYtjAw3tWn+ZzZY0MTZLm7W3avAOC0=;
	b=dbYyshaxC776vgEIEZgQKV0Va+wzGS5EoCQBYl6LsYkj87sX7rFMi7PIIy+jo2e5DKyvNv
	IGJZDD4E1v0SuD5oNq9DvbCbeSS8gKygpI9p3vI2JYug1cTbThW9lX9JI949SqOKjAG8Gy
	P8dv4Uotw/shSKhy9MQZdONjf8bDPL0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-oS4LtOGmOrqOlUnHC5Mavg-1; Wed, 22 Nov 2023 03:03:12 -0500
X-MC-Unique: oS4LtOGmOrqOlUnHC5Mavg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8352585A59D;
	Wed, 22 Nov 2023 08:03:12 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.224])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C0E592166B26;
	Wed, 22 Nov 2023 08:03:09 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: remove duplicated code for ceph_netfs_issue_read
Date: Wed, 22 Nov 2023 16:01:01 +0800
Message-ID: <20231122080101.1016608-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

When allocating an osd request the libceph.ko will help add the
'read_from_replica' flag by default.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 4bb19596e339..2b5c06fd5c7f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -371,8 +371,8 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino,
 			off, &len, 0, 1, sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
-			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
-			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
+			CEPH_OSD_FLAG_READ, NULL, ci->i_truncate_seq,
+			ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		req = NULL;
-- 
2.41.0


