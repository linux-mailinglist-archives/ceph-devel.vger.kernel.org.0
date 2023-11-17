Return-Path: <ceph-devel+bounces-114-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 803767EED6D
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 09:17:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14448B20A5F
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 08:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350B9D261;
	Fri, 17 Nov 2023 08:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VSHCUQ7g"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591A9B3
	for <ceph-devel@vger.kernel.org>; Fri, 17 Nov 2023 00:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700209055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o3DwGWlIiPwGeoXyjfH+DIkqX6Jx4lhLBBmeIQVzgYs=;
	b=VSHCUQ7gd/Qjt4hvmRtlywNXa82lk6ovSUHh2FupVnB6NDIKAKzPkh2eMHq3RYZN3Nj5+l
	qafAa3ReBXeCF4pT5AUbPXaRjstgg+ZrZFqc9uuGtCFa3Vqmgul8Cn+a0AcO3kjGWKifsS
	IbR46ZuY1/ztAYcGW222oOm+R+hmoxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-V6yL4cN6NeS_TxfSdmQahg-1; Fri, 17 Nov 2023 03:17:31 -0500
X-MC-Unique: V6yL4cN6NeS_TxfSdmQahg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C61FF85A58B;
	Fri, 17 Nov 2023 08:17:30 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.63])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F149D2026D4C;
	Fri, 17 Nov 2023 08:17:26 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: update the oldest_client_tid via the renew caps
Date: Fri, 17 Nov 2023 16:15:07 +0800
Message-ID: <20231117081509.723731-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Xiubo Li <xiubli@redhat.com>

V2:
- a minor fix about incorrect switching oldest_tid to le64 reported by
  kernel test robot <lkp@intel.com>


Xiubo Li (2):
  ceph: rename create_session_open_msg() to create_session_full_msg()
  ceph: update the oldest_client_tid via the renew caps

 fs/ceph/mds_client.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

-- 
2.41.0


