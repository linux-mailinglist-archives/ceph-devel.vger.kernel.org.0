Return-Path: <ceph-devel+bounces-25-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AAC07DDA65
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Nov 2023 01:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 455F8281847
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Nov 2023 00:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E82062B;
	Wed,  1 Nov 2023 00:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2r3WPJt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4485A7E9
	for <ceph-devel@vger.kernel.org>; Wed,  1 Nov 2023 00:52:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD3CED
	for <ceph-devel@vger.kernel.org>; Tue, 31 Oct 2023 17:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698799964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Aq/8m8/vrNrV7w5xqzboZmGC8YqQ2yTVvMuOsSJDTSM=;
	b=F2r3WPJtYymQVz1yc2K/GgBvMDgwgO8Q1liLnvNWJSgC9Qp3Tp8skhFiGILgjHow/0GAfg
	O1ItNyF/ROWsZo2EIxSNOZmhD9f5W3W1De8b6Dy+dvXw2gaxd5EtBkKWoH6zkFefSAiN6M
	ddflhku0INcERX8yVtKVbEZeFVQ+SYM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-262-A1zzqiupNOeC8QK1ED6YAg-1; Tue,
 31 Oct 2023 20:52:39 -0400
X-MC-Unique: A1zzqiupNOeC8QK1ED6YAg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A8643804514;
	Wed,  1 Nov 2023 00:52:39 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.128])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D634F2166B27;
	Wed,  1 Nov 2023 00:52:36 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] libceph: sparse-read misc fixes
Date: Wed,  1 Nov 2023 08:50:31 +0800
Message-ID: <20231101005033.21995-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

V2:
- Remove [1/3] patch from V1.

Xiubo Li (2):
  libceph: save and covert sr_datalen to host-endian
  libceph: check the data length when finishes

 include/linux/ceph/osd_client.h |  3 ++-
 net/ceph/osd_client.c           | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

-- 
2.41.0


