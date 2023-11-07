Return-Path: <ceph-devel+bounces-62-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8817E3359
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 03:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20F5DB20B28
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 02:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9277715BD;
	Tue,  7 Nov 2023 02:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UqQlfBFL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E445620FB
	for <ceph-devel@vger.kernel.org>; Tue,  7 Nov 2023 02:56:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B543111C
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 18:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699325803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qjzIbEqOaZZS41oxTtFkDXCIHELu+9FcmtLcrtPCrGs=;
	b=UqQlfBFLNqZ685IDR2475MJGx77Yu2yMJm/+ZbunA3BrGRqmVYVGAhlON96LQfXd2BjLIj
	JtP4E+ORa8TEGMgzEnii+U++74gy1jLFxhI/Y9Gt7mh59AipHXSHWMGccM/RXRnpZw/nBn
	VXW1S9G/pGvW7faZqAAHs+dxKxNbxx4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-fKvKDNJZMsqqkYgqGUtIdw-1; Mon, 06 Nov 2023 21:56:42 -0500
X-MC-Unique: fKvKDNJZMsqqkYgqGUtIdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B596821935;
	Tue,  7 Nov 2023 02:56:42 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AD45C1596F;
	Tue,  7 Nov 2023 02:56:36 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] ceph: allocate a smaller extent map if possible
Date: Tue,  7 Nov 2023 10:54:21 +0800
Message-ID: <20231107025423.302404-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Xiubo Li <xiubli@redhat.com>

For fscrypt case mostly we can predict the max count of the extent
map, so try to allocate a smaller size instead.


Xiubo Li (2):
  libceph: specify the sparse read extent count
  ceph: try to allocate a smaller extent map for sparse read

 fs/ceph/addr.c                  |  4 +++-
 fs/ceph/file.c                  |  8 ++++++--
 fs/ceph/super.h                 | 14 ++++++++++++++
 include/linux/ceph/osd_client.h |  6 ++++--
 4 files changed, 27 insertions(+), 5 deletions(-)

-- 
2.41.0


