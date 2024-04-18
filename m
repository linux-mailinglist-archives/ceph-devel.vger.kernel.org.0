Return-Path: <ceph-devel+bounces-1094-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70DBA8A9CF1
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 16:25:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4AA3B235F3
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 14:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF7716D9BD;
	Thu, 18 Apr 2024 14:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XqbQd5lK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFD716D9DA
	for <ceph-devel@vger.kernel.org>; Thu, 18 Apr 2024 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450157; cv=none; b=MdZTbrBgEorVNt81QaQdE0REaZAwoRoge0mSgYmhpg2teHS0zkpukStosNVfJVrXnqS9UH8KPDvrvqStzT0+ObF+8/zQen8Q+Xkg5WVyRkiO3Pap6NRL0aWQQiLi5dx0qS6GbgQ5fR8O/xVGbox2ty+WpnuU1bfOz/AqQM3LUV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450157; c=relaxed/simple;
	bh=02BQaJ7JZJRj4SWYubyS+pkib5qxgDOHaGx2r+Jjl24=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UKmTEVL2PYS3Q1Cho4vOZmOhyGhQ++GQ1E+EPKmipqKkf/xwFOkmRdWDJcZ+tt8H85zeyKmfjU7hL4pW/j6UvwN2LKVadW2tbrmk1/Mx2ZPXZcxx3zk4BmSh2BN8jaM0vVcJ+3/rbRIlsLucENMAvw+Q6LeuIv3vhkedwpT85ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XqbQd5lK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713450155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vPgQ2YzVjG1FuGlrLopjutvA9pWielZqlJp/kourKqM=;
	b=XqbQd5lK5x8IWZjxvDOou+MAv4E/tLEinB9++Bk1AY5scLVfNkxkbGLhhk4qHEvOsih5Zc
	vV5JVrXmBWt8tsaxpr0vR6p0B/W6OMEVPMn0C/YhgEH/9I2GvsT9NFd3tE8yytwWZn66VJ
	tv1ZB5yumEmJi1o5vLfe+nExOwo2j3o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-tf4LFzHFMR2pFqQ6p6Oc4w-1; Thu, 18 Apr 2024 10:22:33 -0400
X-MC-Unique: tf4LFzHFMR2pFqQ6p6Oc4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45BA08ABE1B;
	Thu, 18 Apr 2024 14:22:33 +0000 (UTC)
Received: from li-25d5c94c-2c69-11b2-a85c-c76ff7643ea0.ibm.com.com (unknown [10.72.116.7])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCCAC43FAC;
	Thu, 18 Apr 2024 14:22:30 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 0/6] ceph: check the cephx mds auth access in client side
Date: Thu, 18 Apr 2024 22:20:13 +0800
Message-ID: <20240418142019.133191-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Xiubo Li <xiubli@redhat.com>

V5:
 - fix incorrect git_t parsing, it should be int32_t.

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


