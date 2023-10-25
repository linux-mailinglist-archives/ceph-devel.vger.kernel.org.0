Return-Path: <ceph-devel+bounces-8-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7817D618F
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Oct 2023 08:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 581001C20A97
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Oct 2023 06:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82027156CC;
	Wed, 25 Oct 2023 06:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EE3FG1vM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873D3111AB
	for <ceph-devel@vger.kernel.org>; Wed, 25 Oct 2023 06:22:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B63BD
	for <ceph-devel@vger.kernel.org>; Tue, 24 Oct 2023 23:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698214937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wprXvWLzeGw+4p+suz5mk6xu/QTSDEcSQ/Ci0v0bIjw=;
	b=EE3FG1vME9Cdme1Cs//H3zuCWxLfseCx+HUm1ydjm2xKsjPu1/pkqJALS3u9D0LUFoo6E2
	LL+HzB9V+sf6I3O24abN2f0vztWmfOp9rYlHtBhMLRM16muL0IFGSjvzYE8gyfv6BQ5vpG
	trYYgDTjnZGgqfUDnOnKrkt4vthz7Fk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-Iv2xkpP2Nci8SLLWseTPJQ-1; Wed, 25 Oct 2023 02:22:15 -0400
X-MC-Unique: Iv2xkpP2Nci8SLLWseTPJQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2B03185A784;
	Wed, 25 Oct 2023 06:22:14 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.168])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E4358C0A;
	Wed, 25 Oct 2023 06:22:11 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: fix caps revocation stuck
Date: Wed, 25 Oct 2023 14:19:50 +0800
Message-ID: <20231025061952.288730-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Xiubo Li <xiubli@redhat.com>

Just remove the "[1/3] ceph: do not break the loop if CEPH_I_FLUSH is
set" patch from V1, which is causing a regression in 
https://tracker.ceph.com/issues/63298


Xiubo Li (2):
  ceph: always queue a writeback when revoking the Fb caps
  ceph: add ceph_cap_unlink_work to fire check caps immediately

 fs/ceph/caps.c       | 65 +++++++++++++++++++++++++++-----------------
 fs/ceph/mds_client.c | 34 +++++++++++++++++++++++
 fs/ceph/mds_client.h |  4 +++
 3 files changed, 78 insertions(+), 25 deletions(-)

-- 
2.39.1


