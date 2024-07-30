Return-Path: <ceph-devel+bounces-1609-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF119407B2
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 07:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B85A22814FD
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 05:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6AEB167D83;
	Tue, 30 Jul 2024 05:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VnqR+2zv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713C6524C
	for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 05:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722318113; cv=none; b=o0qb4j6USa29+IHcu4iyRVB9boSg4ns3UMtNueW0On+ScJUBIxnmazoMjOzIqE46U2/czo0sQb+v8aJmaS7sNS9ytzcBMXw00dioAe+DVxnbngHKh7LMOCQKUoiWpDMVN2wEu6n5WB2Qq+YrEogdGUe/tlfx0NilxZvuDbwEswA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722318113; c=relaxed/simple;
	bh=qBoLrpLzbIrBEl/leC5Xfd4dOX8cb9e4gLghAe4nGa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EkQPjmPmKC1X4gee5J3h4y1TCBSeWdw+2OEfc1YZHEwp479hRLIx/ZHPMQTUUIt55XeVXnlO74crKfyXvufF53jzCS0LZxNFB3dUzJ7jqpQVMtW2ddwOm7ArMJBuNsS2DgDAF65rcvpemmC3eOgS2zbDTNjTN/qL1/+QXlX07GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VnqR+2zv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722318110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GvmGW+3TivBHm2oVdax1855tcnv4m0ka2Vh9jKAvYv8=;
	b=VnqR+2zvbstLW2y3KKEO420AVy7obP9TKsrM0Wb+i0ehSRT9jyGG22mYHKHhLdeEDNBoiT
	7avCcKlb6TgR1WLldpsU+Ynd+BCaBSQ+42SQxtQVql9fFYrd1DCOzXGLYiarfEraIFwp2d
	QsVJUKgoVpXNyTt6iktA9sF32x1gyDo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-6owvhmrEOfi7SuDQcS8NmQ-1; Tue,
 30 Jul 2024 01:41:47 -0400
X-MC-Unique: 6owvhmrEOfi7SuDQcS8NmQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB9821955D55;
	Tue, 30 Jul 2024 05:41:45 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.98])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 98D3419560AE;
	Tue, 30 Jul 2024 05:41:42 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	vshankar@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: flush all the caps release when syncing the whole filesystem
Date: Tue, 30 Jul 2024 13:41:33 +0800
Message-ID: <20240730054135.640396-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Xiubo Li <xiubli@redhat.com>

V2:
- missed the first patch in V1.

Xiubo Li (2):
  ceph: rename ceph_flush_cap_releases to
    ceph_flush_session_cap_releases
  ceph: flush all the caps release when syncing the whole filesystem

 fs/ceph/caps.c       | 24 +++++++++++++++++++++++-
 fs/ceph/mds_client.c | 11 ++++++-----
 fs/ceph/mds_client.h |  4 ++--
 fs/ceph/super.c      |  1 +
 fs/ceph/super.h      |  1 +
 5 files changed, 33 insertions(+), 8 deletions(-)

-- 
2.43.0


