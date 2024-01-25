Return-Path: <ceph-devel+bounces-659-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C30283B743
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 03:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1245281B63
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 02:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F33A1FB2;
	Thu, 25 Jan 2024 02:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FL/k2oHW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BDA1866
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jan 2024 02:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706150510; cv=none; b=EKRIDwvub4nj0oLdB2WGyOIFCUBksCdXhRBHfcXHxc7S3BiQkKR9zzcaBGokP6Ve3e69UDrmPQInr9NZ6gCVLssu3dlLm2Nd9iTXUg8FQCm1XIhVM1R6ulil7LSIKNlqBVu3DKr/sieih7qP0PI13GVEb9f5sUPzg+zolo5UIz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706150510; c=relaxed/simple;
	bh=bAX93tvRqBIkD2k4bbqHHRwSwD8V3rWWB/pdu4ryBoc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OWOaoLeEj8ZAc78ZbcC249vraKZsoU2EFuwtEVEo0CeTh3S4bEqOQ+WOv7neQF6OYeIa+64PHZKF9/ZGZkOSgNp3RV1s5+S4Emc1viYhIcxDyurjiF+vXZ0Xa24qCRvhaaGX0TJxemMhu9NICuCp2fnxxsxR+K2/Y/n8LxxZpc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FL/k2oHW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706150507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TsB6glo6vVbCzNXUkbcm4c8iYtH/CpLyg7FqDPpWips=;
	b=FL/k2oHWlvq9IkTFBc0SvGkM3k+iwVuWP5fmDAylas0Q8eORHZYnmfcOWCRLgEyD4Gy6UW
	4aLYLIJMgD3uaAkOJZiP4sb/zdMulfaOyEJ6jbz8TGR/ZFEJqxAxVaSUs/VReD3nr0j9wC
	54THZdt+Dog31OHrbKg4TH6KzitjB8w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-17PUb6TkP_C8_43MsnASog-1; Wed, 24 Jan 2024 21:41:44 -0500
X-MC-Unique: 17PUb6TkP_C8_43MsnASog-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C25085A5A3;
	Thu, 25 Jan 2024 02:41:43 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.211])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E220C2166B32;
	Thu, 25 Jan 2024 02:41:39 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 0/3] libceph: fix sparse-read failure bug
Date: Thu, 25 Jan 2024 10:39:17 +0800
Message-ID: <20240125023920.1287555-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

V6:
- minor fix from Jeff's comments.

V5:
- remove sr_total_resid and reuse total_resid instead.

V4:
- remove the sr_resid_elen field
- improved the 'read_partial_sparse_msg_data()'

V3:
- rename read_sparse_msg_XX to read_partial_sparse_msg_XX
- fix the sparse-read bug in the messager v1 code.

V2:
- fix the sparse-read bug in the sparse-read code instead


Xiubo Li (3):
  libceph: fail the sparse-read if the data length doesn't match
  libceph: rename read_sparse_msg_XX to read_partial_sparse_msg_XX
  libceph: just wait for more data to be available on the socket

 include/linux/ceph/messenger.h |  2 +-
 net/ceph/messenger_v1.c        | 33 +++++++++++++++++----------------
 net/ceph/messenger_v2.c        |  4 ++--
 net/ceph/osd_client.c          | 20 ++++++++++++--------
 4 files changed, 32 insertions(+), 27 deletions(-)

-- 
2.43.0


