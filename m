Return-Path: <ceph-devel+bounces-80-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A367E93FD
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Nov 2023 02:19:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC63B280AB3
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Nov 2023 01:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0984695;
	Mon, 13 Nov 2023 01:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XvKSR1RN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C704402
	for <ceph-devel@vger.kernel.org>; Mon, 13 Nov 2023 01:19:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574851BF1
	for <ceph-devel@vger.kernel.org>; Sun, 12 Nov 2023 17:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699838356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xjo2r2YSHkp0m+Lqo4k6TfUebu/9KEpCz2AcL74yMTM=;
	b=XvKSR1RNCecxcxDWcsYGMU6aZfnA573GwS99WrrwvuICnSLDSjr8PT4q8eCj8wyLByPnHL
	dgNCH9WM41Q7/2I91NiXiOV3AxIFSaDETMwQsmUWeJFxVLbF7Nr5vFklqXna2VViCRC5Tq
	GXbzgpbHLe0yKWyD+UvEphWsOv+pYoo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-pw5RrddrMPO0974Odm_r3w-1; Sun, 12 Nov 2023 20:19:13 -0500
X-MC-Unique: pw5RrddrMPO0974Odm_r3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C46AC101A529;
	Mon, 13 Nov 2023 01:19:12 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.63])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04132C1596F;
	Mon, 13 Nov 2023 01:19:09 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/5] check the cephx mds auth access in client side
Date: Mon, 13 Nov 2023 09:17:01 +0800
Message-ID: <20231113011706.542551-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Xiubo Li <xiubli@redhat.com>

The code are refered to the userspace libcephfs:
https://github.com/ceph/ceph/pull/48027.


V2:
- Fix memleak for built 'path'.


Xiubo Li (5):
  ceph: save the cap_auths in client when session being opened
  ceph: add ceph_mds_check_access() helper support
  ceph: check the cephx mds auth access for setattr
  ceph: check the cephx mds auth access for open
  ceph: check the cephx mds auth access for async dirop

 fs/ceph/dir.c        |  28 +++++
 fs/ceph/file.c       |  61 +++++++++-
 fs/ceph/inode.c      |  46 ++++++--
 fs/ceph/mds_client.c | 265 ++++++++++++++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h |  24 ++++
 5 files changed, 412 insertions(+), 12 deletions(-)

-- 
2.41.0


