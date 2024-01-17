Return-Path: <ceph-devel+bounces-561-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F7982FF8D
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 05:30:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C5C31C23794
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 04:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678A346BB;
	Wed, 17 Jan 2024 04:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z2LTzkj2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AE3611A
	for <ceph-devel@vger.kernel.org>; Wed, 17 Jan 2024 04:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705465810; cv=none; b=E0EcIvIj4LiJYU66j/HjZlMnfVS78DPUy7M+Edn5JHtR++98soQva2/TpPsTo600V8EUGdCs5Lg2/ZJZy/knEvKD1OTqofmPv8Auh1FBuuwXRH4ZIrBpXkg84Dj9bbyKVfig1EXP3g7l4RFzAMz874eALChWoDuPkknR20IFE4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705465810; c=relaxed/simple;
	bh=EVAyM875qSoiLKuNr/Ff+wpX+AXekRS998x8wzKqyXI=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:
	 X-Scanned-By; b=Zj5sqCBsO/XBw1PfDVTkOWN99DkLbWnlvVM+y0qmkwX9M6kpDfZECSxcjivpatg/dN8j19JSwAI92OCv8RyCuUDA3GRuCggtJU2oHz7Gp8OSNzCCt6RY0oTjkE42Kr4Zs3Sst/Xswzj+BAF+8CIJ98ElP5mmUMVyLXBMe/csvVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z2LTzkj2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705465807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mpiECAfsOzsEiROpOCFdWE7QR9fMLSm/9Tel8P+2IhM=;
	b=Z2LTzkj23izKTPrtgl/toOAeR7+KVqGEsWR88vfKGP4MSU1olTgD4hLmA4hIIMdEb/pO5R
	lYbD5DstX9gF1A0Pjm35KcnFBiHqFQ+1CtxpcttndeCHetxvd854toZgrQkuIQNF/+LQjU
	Ne57MAVdY6BRsVfO1XRC3I3B4nmX9hk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-sCVjuX2EMYm2vH3iC_zv-Q-1; Tue, 16 Jan 2024 23:30:05 -0500
X-MC-Unique: sCVjuX2EMYm2vH3iC_zv-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF900800076;
	Wed, 17 Jan 2024 04:30:04 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2B3AB1121306;
	Wed, 17 Jan 2024 04:30:01 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] ceph: fix caps revocation stuck
Date: Wed, 17 Jan 2024 12:27:56 +0800
Message-ID: <20240117042758.700349-1-xiubli@redhat.com>
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
- reuse the cap_wq instead of using the system wq

V2:
- Just remove the "[1/3] ceph: do not break the loop if CEPH_I_FLUSH is
set" patch from V1, which is causing a regression in 
https://tracker.ceph.com/issues/63298


Xiubo Li (2):
  ceph: always queue a writeback when revoking the Fb caps
  ceph: add ceph_cap_unlink_work to fire check_caps() immediately

 fs/ceph/caps.c       | 65 +++++++++++++++++++++++++++-----------------
 fs/ceph/mds_client.c | 48 ++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h |  5 ++++
 3 files changed, 93 insertions(+), 25 deletions(-)

-- 
2.43.0


