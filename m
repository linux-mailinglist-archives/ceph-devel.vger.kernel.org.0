Return-Path: <ceph-devel+bounces-68-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C537E653E
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 09:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7480280FD2
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 08:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61381DDB9;
	Thu,  9 Nov 2023 08:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QvZylOG8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD50510A00
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:26:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5C62D50
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 00:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699518386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YL1Cy+6/Q7GjtzPdps233sGrAUekUhw8DZ1XtYpY+u8=;
	b=QvZylOG89dNo9fWLvPqrK76gOjtPA/1VqKrqa1Ozl1zgya3VaI3uLuyxkgp85c2J858qeY
	aQnjGIjd0ne9GEUsQVgTTaeLPZ+Ub3yI8kp9Om8HzrFhM33JYFAq6c2AWGlMyusi2Irp0G
	QhCmqZx++y6kJkhap6VJoDlBtc4gfP0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-WJ9zzdMQN5O96hoQ4ZC4Xg-1; Thu,
 09 Nov 2023 03:26:23 -0500
X-MC-Unique: WJ9zzdMQN5O96hoQ4ZC4Xg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 004D3381A88A;
	Thu,  9 Nov 2023 08:26:23 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 94D292027019;
	Thu,  9 Nov 2023 08:26:18 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/5] check the cephx mds auth access in client side
Date: Thu,  9 Nov 2023 16:24:04 +0800
Message-ID: <20231109082409.417726-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Xiubo Li <xiubli@redhat.com>

The code are refered to the userspace libcephfs:
https://github.com/ceph/ceph/pull/48027.


Xiubo Li (5):
  ceph: save the cap_auths in client when session being opened
  ceph: add ceph_mds_check_access() helper support
  ceph: check the cephx mds auth access for setattr
  ceph: check the cephx mds auth access for open
  ceph: check the cephx mds auth access for async dirop

 fs/ceph/dir.c        |  27 +++++
 fs/ceph/file.c       |  59 +++++++++-
 fs/ceph/inode.c      |  45 ++++++--
 fs/ceph/mds_client.c | 265 ++++++++++++++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h |  24 ++++
 5 files changed, 408 insertions(+), 12 deletions(-)

-- 
2.41.0


