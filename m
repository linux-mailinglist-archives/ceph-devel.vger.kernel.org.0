Return-Path: <ceph-devel+bounces-3-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 272DD7D46CA
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Oct 2023 07:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6641281844
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Oct 2023 05:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A20538B;
	Tue, 24 Oct 2023 05:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gqTGRbl7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFAD1FA5
	for <ceph-devel@vger.kernel.org>; Tue, 24 Oct 2023 05:03:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A22B0
	for <ceph-devel@vger.kernel.org>; Mon, 23 Oct 2023 22:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698123778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4lDphwt+kgR6foo+A4epmAtB8tccqF/OoeLGJCDGylk=;
	b=gqTGRbl7M/Wx/n3yDYobAnenQ9LbFaP7KqNsIndNyVyLeVMEOxy+0TmwmCRH+0UU2Yp78U
	Oga40qjOm4QylpRJYV071O2eOUArAbMvj8y/ECAPY+/DJKchwQWO1FatdSoLuJVtyraAfw
	0Y0J5X0HIQNWwJP6V/wqQkqs+BNESBU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-_VdfSLfhNi2kBhJeXv8dkQ-1; Tue, 24 Oct 2023 01:02:57 -0400
X-MC-Unique: _VdfSLfhNi2kBhJeXv8dkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC566811E97;
	Tue, 24 Oct 2023 05:02:56 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.168])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 14EEF25C2;
	Tue, 24 Oct 2023 05:02:53 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/3] libceph: sparse-read misc fixes
Date: Tue, 24 Oct 2023 13:00:36 +0800
Message-ID: <20231024050039.231143-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Xiubo Li <xiubli@redhat.com>

One bug fix and one improvment for the sparse-read.


Xiubo Li (3):
  libceph: do not decrease the data length more than once
  libceph: save and covert sr_datalen to host-endian
  libceph: check the data length when finishes

 include/linux/ceph/osd_client.h |  3 ++-
 net/ceph/messenger_v2.c         |  1 -
 net/ceph/osd_client.c           | 16 +++++++++++++++-
 3 files changed, 17 insertions(+), 3 deletions(-)

-- 
2.39.1


