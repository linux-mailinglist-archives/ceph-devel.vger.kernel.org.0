Return-Path: <ceph-devel+bounces-896-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D609085F97E
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Feb 2024 14:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C8C0B25B55
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Feb 2024 13:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF9F131E5C;
	Thu, 22 Feb 2024 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y9aSIfK0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083355FB91
	for <ceph-devel@vger.kernel.org>; Thu, 22 Feb 2024 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708608070; cv=none; b=Vd9Yn6b1COJnbXOdNF1BLncb9KyFmgKKfVPsagV70xO3B3kbRqUvie3FKKN3OXBQnq1bptHQlVnoiloOkIWco4j9oLq3Jz0wNtHuBfeLCfMWLY0yKIXlquOrI7dbu5TpPOh8h8vkbWovzspClY21SuHGmfdDGmUC/ynY+t6y86g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708608070; c=relaxed/simple;
	bh=5cjQHJdm/qwg3/REJEvc50FDvBkI6MGY/N5C2C8kDBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hSDip1wkSceJ58bY7odMPC9lMAwAPcQ5g1w5L8Fg3hovchOqUOUPJsWExo99d8SJ6I/M2cutupRTJiZG+zAqvEW9NLRNKU5/Ny9Z8qxHmuPmWmDvuNM+n8HdRvVOuUFOOFFJp1qro6k/kOwFD0S4YsRxHmJhkEtwTXY3wcoPauA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y9aSIfK0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708608067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V20siHi8GAWruRnv3Q4Wvd9ckMFTmiXcZJcLWblK0tw=;
	b=Y9aSIfK0nJEj2hNHx80n2CEDq5J3zVExnpnpo3AIiQIswxzp4xAhqlIB8jtnB2eKrzXCNP
	Uuati0MeQ38GLuWlLcfixDD/1oZ3NhFP+LuKFcEr5CuKpMOOzCGqIavbAbORqiO1LVHHkP
	9amWg8gIsCafAFhZXoZdD5/oxnMNJco=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-14-9v2kSvoNNpGc1BUPSN9p-A-1; Thu,
 22 Feb 2024 08:21:06 -0500
X-MC-Unique: 9v2kSvoNNpGc1BUPSN9p-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E87A1C04197;
	Thu, 22 Feb 2024 13:21:06 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.112])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 61C378CED;
	Thu, 22 Feb 2024 13:21:03 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: skip copying the data extends the file EOF
Date: Thu, 22 Feb 2024 21:18:58 +0800
Message-ID: <20240222131900.179717-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Xiubo Li <xiubli@redhat.com>

V2:
- append a new patch to improve the getattr code


Xiubo Li (2):
  ceph: skip copying the data extends the file EOF
  ceph: set the correct mask for getattr reqeust for read

 fs/ceph/file.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

-- 
2.43.0


