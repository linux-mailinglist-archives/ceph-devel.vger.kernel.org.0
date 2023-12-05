Return-Path: <ceph-devel+bounces-189-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D83498043DD
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 02:17:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AEBE281441
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 01:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472FF1110;
	Tue,  5 Dec 2023 01:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HAcf4r6E"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BB9C9
	for <ceph-devel@vger.kernel.org>; Mon,  4 Dec 2023 17:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701739022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lN5ajAvFyHn5QyRfisHjFAFkUY6K/VdOA0va1v1dme8=;
	b=HAcf4r6EWszPmY7cTDWRch7f497cepZKTLX1yNQ5QimAPNeShdG9Yz/WeMlEQK31IqtiIz
	Ft6Flq3OaIr5Kph0InT2cC+JU7bCJ5M2bPJ7bGZUimn8G+QTxGu75yRs6y8NsP6HvFI2Ls
	Jb8N/3GAX4EK4gPVMndSeSpbi8/Q1ZA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-0NBQfmNyN2isBj3oQMWTRw-1; Mon,
 04 Dec 2023 20:16:58 -0500
X-MC-Unique: 0NBQfmNyN2isBj3oQMWTRw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D59E3813F2E;
	Tue,  5 Dec 2023 01:16:58 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.113.153])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B920492BE8;
	Tue,  5 Dec 2023 01:16:55 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/6] ceph: check the cephx mds auth access in client side
Date: Tue,  5 Dec 2023 09:14:33 +0800
Message-ID: <20231205011439.84238-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Xiubo Li <xiubli@redhat.com>

The code are refered to the userspace libcephfs:
https://github.com/ceph/ceph/pull/48027.


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
 fs/ceph/file.c       |  61 +++++++++-
 fs/ceph/inode.c      |  46 ++++++--
 fs/ceph/mds_client.c | 265 ++++++++++++++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h |  28 ++++-
 5 files changed, 415 insertions(+), 13 deletions(-)

-- 
2.41.0


