Return-Path: <ceph-devel+bounces-914-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0119F8689E5
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 08:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 934661F21ED3
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 07:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7085465C;
	Tue, 27 Feb 2024 07:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TRHRL+61"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A3854BC4
	for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 07:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709019297; cv=none; b=gZH4KyDLleJ4qEHJ4dxP/DjVmy6nuqF8bgEXqaUqGVc3ZR3/dQt8eJQhffFWXPzYka15I7eqgJaTIgKws14HxKZjuEQ6062kRu/2/igejQM8yosyPZm1CMsOO6BFx/MBrdEpdvGefjDdgOSE4GUxSnf+VcdEu/mfRsJ2LxeqW/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709019297; c=relaxed/simple;
	bh=X2knU1ZeAEByvWQ3NyN/PSbbBZtbSz7eG7sqH20//cM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fOfuPgNDG6dNnvwM5w3sLSyJxW5C5HaiwRobROtIejSYSU7PnelDOE6tOJAvU8nMNjJ1qXsSU59EActXA4tZn+/YQq0+2CE/PNfayJ8ftZ+Sf16XtDdUuxHR9zE6b5V54gYVrXvW2WvBaX+UI43KebqDoYlJLUaGSB340UY4RBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TRHRL+61; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709019295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EJG8HwJl5st2SgkE2EUzhWwZxPmcCRb95iGxe8V2jA4=;
	b=TRHRL+61V5ebRlc7FlvhXBjB4SyNsqaSWcWURJOvBPr/aItHGBt1OIS6NRb6l2qCixo7SY
	bEcAM2f3EJ4WINrqktFWLmEz2Xg4rTs6QTJl7bT9GC9Cvj722FrUcGFIaPaTVCEfoX38ip
	BScbfl+SOIjs9zBjkmwJqkgcVFzK4Hc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-MOreexgnPK2aCEvY7uRO_g-1; Tue, 27 Feb 2024 02:34:51 -0500
X-MC-Unique: MOreexgnPK2aCEvY7uRO_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F28910B0705;
	Tue, 27 Feb 2024 07:34:51 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.214])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D7502166B5E;
	Tue, 27 Feb 2024 07:34:48 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/6] ceph: check the cephx mds auth access in client side
Date: Tue, 27 Feb 2024 15:26:59 +0800
Message-ID: <20240227072705.593676-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

The code are refered to the userspace libcephfs:
https://github.com/ceph/ceph/pull/48027.


V4:
- Fix https://tracker.ceph.com/issues/64172
- Improve the comments and code in ceph_mds_auth_match() to make it
  to be more readable.

V3:
- Fix https://tracker.ceph.com/issues/63141.

V2:
- Fix memleak for built 'path'.


Xiubo Li (6):
  ceph: save the cap_auths in client when session being opened
  ceph: add ceph_mds_check_access() helper support
  ceph: check the cephx mds auth access for setattr
  ceph: check the cephx mds auth access for open
  ceph: check the cephx mds auth access for async dirop
  ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit

 fs/ceph/dir.c        |  28 +++++
 fs/ceph/file.c       |  66 ++++++++++-
 fs/ceph/inode.c      |  46 ++++++--
 fs/ceph/mds_client.c | 270 ++++++++++++++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h |  28 ++++-
 5 files changed, 425 insertions(+), 13 deletions(-)

-- 
2.43.0


