Return-Path: <ceph-devel+bounces-583-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B989C831710
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 11:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87D1B2825C1
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 10:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD9723754;
	Thu, 18 Jan 2024 10:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jGB5uJ4p"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DE122F06
	for <ceph-devel@vger.kernel.org>; Thu, 18 Jan 2024 10:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575183; cv=none; b=mkdp9lf2XjMd1dOfZnPBbozlLHHwJNbQYVRVy5KO95FKt0MtxkIaETSz0bYLvGv4WrASt7LDqYkC9Xc/HGd99O30HM2ZU0oGdilLcIGwLXvQYB3K3PH69ida918vxKtHECjRB33iSqGsohg5RsKI782h2MJLHSoiaQQlrD9FFWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575183; c=relaxed/simple;
	bh=+SI0MRBzli8T4RWKhAZOPuSKfe5HColSClqpVtA1JBA=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:
	 X-Scanned-By; b=QzNQBpvz/0/oNhenx2ehDAGn+NitggTkLHtsLugddUMxodN7rNSQUuwWbMk/Q6PmaGRt4ankkkZmx4igSlrfFmf9/4ujy3g4iaYkFPwz1Bp2ZQEn0uqEPSyomyZorZocnL/rpOa4XkN6nczD/Xu1iIAdkzXkLSZgHCQWwMNyw44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jGB5uJ4p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705575181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sU1WD+pwyioqlaa5B0k8K7CYtmPdJKi/gMkZA2Fli0k=;
	b=jGB5uJ4pCJC9TLdGf1tKgP15UnHzjKDbzI56q9tTZxQ5PHNIhVT0MrVaqQGlg95iml5QR+
	cTAffXKQKNVB9tdZqCAj/AGQZt7Z05J0qQs8W8Aj7mH7dAuw8fDUrNENjNRXDfDcSZc+8a
	KUpmz8lpogq0bzJ+Bl/Q9SfpjJ7pFqc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-SvqRwUvgMN6EPhN9azZomw-1; Thu, 18 Jan 2024 05:52:59 -0500
X-MC-Unique: SvqRwUvgMN6EPhN9azZomw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12EA9108BD46;
	Thu, 18 Jan 2024 10:52:59 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD9682166B33;
	Thu, 18 Jan 2024 10:52:55 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/3] libceph: fix sparse-read failure bug
Date: Thu, 18 Jan 2024 18:50:44 +0800
Message-ID: <20240118105047.792879-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

V4:
- remove the sr_resid_elen field
- improved the 'read_partial_sparse_msg_data()'

V3:
- rename read_sparse_msg_XX to read_partial_sparse_msg_XX
- fix the sparse-read bug in the messager v1 code.

V2:
- fix the sparse-read bug in the sparse-read code instead


Xiubo Li (3):
  libceph: fail the sparse-read if there still has data in socket
  libceph: rename read_sparse_msg_XX to read_partial_sparse_msg_XX
  libceph: just wait for more data to be available on the socket

 include/linux/ceph/messenger.h |  1 +
 net/ceph/messenger_v1.c        | 40 +++++++++++++++++++++-------------
 net/ceph/osd_client.c          |  9 ++++++++
 3 files changed, 35 insertions(+), 15 deletions(-)

-- 
2.43.0


