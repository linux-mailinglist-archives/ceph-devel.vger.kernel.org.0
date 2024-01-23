Return-Path: <ceph-devel+bounces-646-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B82D838FBD
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jan 2024 14:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 336AD1F21248
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jan 2024 13:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3650B5EE95;
	Tue, 23 Jan 2024 13:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Muikmtks"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FD05F542
	for <ceph-devel@vger.kernel.org>; Tue, 23 Jan 2024 13:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706015673; cv=none; b=BFUCMGq6/w6B58hqQOd9j7kTN0aeGusUgE05ZPV+zUW4x0yK9mXZeleOqwXaBniRjCoeklyeM8t1zGK57is5/27m7/mSvkFVdHdetBcaiNAR1Fb5M703Bol9wbgDRpls7kLRDjWHVVTyMemQexAS52u/YJ7MLNbhM3Jl3Yg4//U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706015673; c=relaxed/simple;
	bh=8Hym+8IaaMjltUXxHpAsJ6ntje4Uz+e0pdStF41EdL0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hqBA8EyHNpon3OZDJPs2HijLTQZD2LB/00hCVGfFa0eJdI5T/zZyo6wL19M3BtRV0VW4Bh42g52jQEMVtWGy423LhL3d4MsMmDNAMYHMIvoPKUyekn9TIVcFiIpU4tAoIxMBZWS15jWT81Bdt4+NvayHAM1aRzMlc0W1HVBWCGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Muikmtks; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706015670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wQ6O3Kz8O+58uYJkcwfpUJCOcwPT+e8nkcljNw8Uhlw=;
	b=MuikmtksCLO/QAA9bxMZnTX/yXVSQ+w/CBmZOMonQaYAYNXCGUZuATwVfszQm2jxqvQYP9
	rHMDzmzHdaWzIkz41rnM5yZD/VlDKdlJ0C9uX4sVSOAQNLWASIJyigcmtyLHrjkTSijhwO
	YPymMVO1lASyl9plerDwlp0x+AEEpjU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-xSsojptPP4-dysKxc2-gIQ-1; Tue, 23 Jan 2024 08:14:26 -0500
X-MC-Unique: xSsojptPP4-dysKxc2-gIQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58A3383B82B;
	Tue, 23 Jan 2024 13:14:26 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6FE7D2026D66;
	Tue, 23 Jan 2024 13:14:23 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 0/3] libceph: fix sparse-read failure bug
Date: Tue, 23 Jan 2024 21:12:01 +0800
Message-ID: <20240123131204.1166101-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Xiubo Li <xiubli@redhat.com>

V5:
- remove sr_total_resid and reuse total_resid instead.

V4:
- remove the sr_resid_elen field
- improved the 'read_partial_sparse_msg_data()'

V3:
- rename read_sparse_msg_XX to read_partial_sparse_msg_XX
- fix the sparse-read bug in the messager v1 code.

V2:
- fix the sparse-read bug in the sparse-read code instead


Xiubo Li (3):
  libceph: fail the sparse-read if there still has data in socket
  libceph: rename read_sparse_msg_XX to read_partial_sparse_msg_XX
  libceph: just wait for more data to be available on the socket

 include/linux/ceph/messenger.h |  2 +-
 net/ceph/messenger_v1.c        | 33 +++++++++++++++++----------------
 net/ceph/messenger_v2.c        |  4 ++--
 net/ceph/osd_client.c          | 22 ++++++++++++++--------
 4 files changed, 34 insertions(+), 27 deletions(-)

-- 
2.43.0


