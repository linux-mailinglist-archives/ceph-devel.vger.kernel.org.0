Return-Path: <ceph-devel+bounces-40-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F637E1847
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 02:19:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE9681C20A6D
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 01:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C79C39F;
	Mon,  6 Nov 2023 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iOsgzLfx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E89395
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 01:19:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03002DD
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 17:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699233545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BN3mmFAmRRFFijIT25Dg96CYyVgZThSrNYpWZgBgEqY=;
	b=iOsgzLfx/DMs8w9J/uz9J85Zl28IM+zTkZ5d9Z9F1TyZIUEHFVtBVLBl28UgvcY4DRwSfk
	OTK4kGtoUcElz5fO6UH67qqitwWkenQFsnZtLgRvG8fGUWRFbgPMf1wHXskqYT7tTVzJ2W
	zW3bok5lDf8UpRgUG6ATGF52VQ0H0Ro=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-G9WPbMfxPwKajkmV-sCLlQ-1; Sun,
 05 Nov 2023 20:19:01 -0500
X-MC-Unique: G9WPbMfxPwKajkmV-sCLlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85EBA29AB3E9;
	Mon,  6 Nov 2023 01:19:01 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.124])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC5301121307;
	Mon,  6 Nov 2023 01:18:58 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] libceph: sparse-read misc fixes
Date: Mon,  6 Nov 2023 09:16:42 +0800
Message-ID: <20231106011644.248119-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

From: Xiubo Li <xiubli@redhat.com>

V3:
- Remove the WARN_ON_ONCE().
- Return -EREMOTEIO when the datalen and extents mismatch.

V2:
- Remove [1/3] patch from V1.

Xiubo Li (2):
  libceph: save and covert sr_datalen to host-endian
  libceph: check the data length when sparse-read finishes

 include/linux/ceph/osd_client.h |  3 ++-
 net/ceph/osd_client.c           | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.39.1


