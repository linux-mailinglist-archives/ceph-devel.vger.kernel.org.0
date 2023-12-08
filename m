Return-Path: <ceph-devel+bounces-260-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4209E809AFF
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 05:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 742921C20C84
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 04:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9639D4A32;
	Fri,  8 Dec 2023 04:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OXrPNL/C"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B5AD54
	for <ceph-devel@vger.kernel.org>; Thu,  7 Dec 2023 20:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702010041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x7uEQe3UR5HfByN0z9lwtkkgYvLVpgEimrIjZW88iSc=;
	b=OXrPNL/CYkFgSIg6wsE0e5yYfJei8kFyL/Hn/ipfcUhRzgoeqd2Gsvc1/prfcGU08R7VJe
	u9i9FsS9fz+3yEdTyPUG1PrdL+pJeJwB/D8fl3pIYbzP46RoDcWN2qYkcABlX6+DJZAQH+
	GKxhQ87Mye7TGWninXMYy5oDVY+ph0Y=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-Oo1eOqc2NgymAv0es2UQqw-1; Thu,
 07 Dec 2023 23:33:59 -0500
X-MC-Unique: Oo1eOqc2NgymAv0es2UQqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36EC529AC01F;
	Fri,  8 Dec 2023 04:33:59 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.27])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F40F2166AE2;
	Fri,  8 Dec 2023 04:33:55 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] libceph: fix sparse-read failure bug
Date: Fri,  8 Dec 2023 12:33:03 +0800
Message-ID: <20231208043305.91249-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>


Xiubo Li (2):
  libceph: fail the sparse-read if there still has data in socket
  libceph: just wait for more data to be available on the socket

 net/ceph/messenger_v1.c | 18 ++++++++++--------
 net/ceph/osd_client.c   |  4 +++-
 2 files changed, 13 insertions(+), 9 deletions(-)

-- 
2.43.0


