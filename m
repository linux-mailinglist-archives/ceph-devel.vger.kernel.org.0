Return-Path: <ceph-devel+bounces-979-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04BD487F49E
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 01:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 349A31C21744
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 00:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF05137B;
	Tue, 19 Mar 2024 00:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RFczlTZU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF54368
	for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 00:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710808341; cv=none; b=glsHW/87P/Ml84AgHzfrVl70/6gvNRB6ILbFmYwEZFQD/BjI2AwvX+xlv6sFgvZ3bai9RereSXLhXEsf5lmvAycQn9sBVeKJgxA42oAJO3J9E4/wSSeWiUoieBUZ1Ze/jODsCdLdan+nQ9x1f0IH6VnYgEvLd9waTHAazXJP8fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710808341; c=relaxed/simple;
	bh=DtBuuifnsq70jPwETsqS0EZVREUGE89hDsbjtZKPYFI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i7KkS0IxfVPNe2sKYEhuyN+CW/SdmtxD1evOvr8cjWjCGfqPMc7bYBhmMxYVHRbqsxMDGrb2x8ruCqxtASBxwhGa30ol6JL/jC1lglqd3/CRVdjaG43YUILrIVJpiuv7Hd+CUxsL0j4Tpjr2b3rWhFZUgLGEh5ZmH6RnY2J3OqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RFczlTZU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710808339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kZrljg9NNxIfXrMQZLZW2VpwtqGXW050a0xVYe4KzAI=;
	b=RFczlTZUlt+sdsxnRP4ORSuHaUxbVOY7SH2Dzye0OOfs9XJeVTshDjaTAe+YiSk2/20sIc
	51CztzePY2mereZabXiN1F5vLne+hXySS0a7bz/Q1m1spZG4L+7C2pubCCsctYqbeP7qjH
	aV/GcBEonkV1sBSZ6xQsQZ0se8p038g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-i221jEuhMyq-sr-ivoh3Tg-1; Mon, 18 Mar 2024 20:32:15 -0400
X-MC-Unique: i221jEuhMyq-sr-ivoh3Tg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA95B101A56C;
	Tue, 19 Mar 2024 00:32:14 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.45])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49D58492BD3;
	Tue, 19 Mar 2024 00:32:10 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	frankhsiao@qnap.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] ceph: skip copying the data extends the file EOF
Date: Tue, 19 Mar 2024 08:29:23 +0800
Message-ID: <20240319002925.1228063-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Xiubo Li <xiubli@redhat.com>

V3:
- Fixed incorrectly handling the left bug reported by Ilya.

V2:
- append a new patch to improve the getattr code


Xiubo Li (2):
  ceph: skip copying the data extends the file EOF
  ceph: set the correct mask for getattr reqeust for read

 fs/ceph/file.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

-- 
2.43.0


