Return-Path: <ceph-devel+bounces-955-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9399872BF6
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Mar 2024 02:08:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E80C28A9D3
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Mar 2024 01:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4766FAF;
	Wed,  6 Mar 2024 01:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRYtzf92"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EAA33D1
	for <ceph-devel@vger.kernel.org>; Wed,  6 Mar 2024 01:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709687292; cv=none; b=hTR77W2JYCt1w+KjP0am9QnIRRtklovZg3H+XP3oK+MzVBvMucx8AUtRvHBjSRcbGB221n2XCYvUPTHXNewCG3pypk++b6/fNLN5LM2EBpfdyOM2Ixc3TAX+PHodtx0182KpalVdK1rYXcjrlGrB8AEExv1qI30fpkToNrXGxYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709687292; c=relaxed/simple;
	bh=SsmH7y7phE3+6HRd1ag269qvwQMP8NQvOUrkGiQ2yWs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ib2dHSf/WzbTx3iTIeB+dOeXG3sAcoqCoz4Isb/OIz1zSd90N6IHu/9v9V3LnJcHwKl7CGIvyR3aHIyGzwtOG4uuuGbN+oq8Bv08DD7kJoGK6eVygipFS0B5kVaFnSKmjBXIyO1iAe4kMLlo9f0//Sj2aAdRAbALW79d5r59EJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IRYtzf92; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709687288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4J6XVV139H2p+jUWQqRDSu5CtocuL0hjR/mC6mRpU1A=;
	b=IRYtzf92xCqx4iTCyulS4fBJm+Qpy4cN/XlbBN/JQK26Ar1y5nkmzzFYLd2wQfKPIJbIGd
	MdW+15THZMLqQF/W8u5Lh/M/hhq8kdx+hrMUXhNKPyJEAlv5bAn4CpkJWkye4x2us7S4sy
	ScVH/pLxOLQM437hZMnfA8Ayxs5aoI0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-sSyz-_hsMe6ZPxEx4RCtBw-1; Tue, 05 Mar 2024 20:08:05 -0500
X-MC-Unique: sSyz-_hsMe6ZPxEx4RCtBw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91FE48007B0;
	Wed,  6 Mar 2024 01:08:04 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.9])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8163C492BE8;
	Wed,  6 Mar 2024 01:08:00 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	stable@vger.kernel.org,
	Luis Henriques <lhenriques@suse.de>
Subject: [PATCH v2] libceph: init the cursor when preparing the sparse read
Date: Wed,  6 Mar 2024 09:05:44 +0800
Message-ID: <20240306010544.182527-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

From: Xiubo Li <xiubli@redhat.com>

The osd code has remove cursor initilizing code and this will make
the sparse read state into a infinite loop. We should initialize
the cursor just before each sparse-read in messnger v2.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/64607
Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on the socket")
Reported-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Just removed the unnecessary 'sparse_read_total' check.


 net/ceph/messenger_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index a0ca5414b333..ab3ab130a911 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2034,6 +2034,9 @@ static int prepare_sparse_read_data(struct ceph_connection *con)
 	if (!con_secure(con))
 		con->in_data_crc = -1;
 
+	ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg,
+				  con->in_msg->sparse_read_total);
+
 	reset_in_kvecs(con);
 	con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
 	con->v2.data_len_remain = data_len(msg);
-- 
2.43.0


