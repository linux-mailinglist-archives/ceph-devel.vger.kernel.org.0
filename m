Return-Path: <ceph-devel+bounces-100-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC997EDBD2
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 08:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE65A280F87
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 07:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7CFDF64;
	Thu, 16 Nov 2023 07:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NGFbm0cm"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B510192
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 23:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700118948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3DNhAhS9eQim3O5AVW8ux0k5bewZs6inNT2UtxZCFms=;
	b=NGFbm0cmWv432AQDCPsPkJoFTlrmxZGhW7hlY0kHQzZjqgidu935qqvZ3KuaEjQHXSGXTv
	gxYQ2PfkaGzYl0lFS5DWwURVzLPwZxvgJvaUi6mD43D7pE9fLUS5vY1oiMR6rk5Utqq9VS
	loCPu84ICrt4NN8RgQ8YzoFNWqaljuI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-zIkGRcjsPMiZA1IwLC3KXg-1; Thu,
 16 Nov 2023 02:15:44 -0500
X-MC-Unique: zIkGRcjsPMiZA1IwLC3KXg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C6A6383DC60;
	Thu, 16 Nov 2023 07:15:44 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.63])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D7FE2492BFD;
	Thu, 16 Nov 2023 07:15:41 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	idryomov@gmail.com,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] ceph: update the oldest_client_tid via the renew caps
Date: Thu, 16 Nov 2023 15:13:36 +0800
Message-ID: <20231116071338.678918-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

From: Xiubo Li <xiubli@redhat.com>

This is the kclient fixes after https://tracker.ceph.com/issues/63364.


Xiubo Li (2):
  ceph: rename create_session_open_msg() to create_session_full_msg()
  ceph: update the oldest_client_tid via the renew caps

 fs/ceph/mds_client.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

-- 
2.41.0


