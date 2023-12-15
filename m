Return-Path: <ceph-devel+bounces-351-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3351F813EAA
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Dec 2023 01:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0D8B283EB7
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Dec 2023 00:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF89520F9;
	Fri, 15 Dec 2023 00:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a72Ynns4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0778120E0
	for <ceph-devel@vger.kernel.org>; Fri, 15 Dec 2023 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702599767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YkCz4T4gddafyKxXOXPJssh+f2o3bPCJZrT1xGXyt/A=;
	b=a72Ynns4ngQF3yrKUzz3S+2n5FL7yTYAu9Fu/dy0+x5MLzhzTJXN97Xxsznxtm+qzra37W
	Op8w32vkmx5KjvLtCWPApGrtjCbwiBokJ9rODyfxtE4UPthzBWob1X2/9vg4gmqKIl4vpp
	G4hVaZ0PtpSfrCjpjY5kDTC/mKCzuc0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-ZJnWVMFPMkOM3YEj93XX2A-1; Thu, 14 Dec 2023 19:22:44 -0500
X-MC-Unique: ZJnWVMFPMkOM3YEj93XX2A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 626AE85A58B;
	Fri, 15 Dec 2023 00:22:44 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.113.27])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 617BE492BC6;
	Fri, 15 Dec 2023 00:22:40 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/3] libceph: fix sparse-read failure bug
Date: Fri, 15 Dec 2023 08:20:31 +0800
Message-ID: <20231215002034.205780-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Xiubo Li <xiubli@redhat.com>

The debug logs:

2725523 <7>[ 8771.114348] libceph:  [0] got 1 extents
2725524 <7>[ 8771.114353] libceph:  [0] ext 0 off 0x66000 len 0x4000
2725525 <7>[ 8771.114370] libceph:  prep_next_sparse_read: [0] completed extent array len 1 cursor->resid 0
2725526 <7>[ 8771.114374] libceph:  read_partial have 0, left 21, con->v1.in_base_pos 53
2725527 <7>[ 8771.114379] libceph:  read_partial have 14, left 7, con->v1.in_base_pos 67         ====> there were still 7 bytes not received
2725528 <7>[ 8771.114382] libceph:  read_partial return 0
2725529 <7>[ 8771.114384] libceph:  try_read done on 0000000094d53202 ret 0
2725530 <7>[ 8771.114387] libceph:  try_write start 0000000094d53202 state 12
2725531 <7>[ 8771.114389] libceph:  try_write out_kvec_bytes 0
2725532 <7>[ 8771.114391] libceph:  try_write nothing else to write.
2725533 <7>[ 8771.114393] libceph:  try_write done on 0000000094d53202 ret 0
2725534 <7>[ 8771.114396] libceph:  put_osd 000000009b11f20c 5 -> 4
2725535 <7>[ 8771.114450] libceph:  ceph_sock_data_ready 0000000094d53202 state = 12, queueing work
2725536 <7>[ 8771.114454] libceph:  get_osd 000000009b11f20c 4 -> 5
2725537 <7>[ 8771.114457] libceph:  queue_con_delay 0000000094d53202 0
2725538 <7>[ 8771.114651] libceph:  try_read start 0000000094d53202 state 12
2725539 <7>[ 8771.114655] libceph:  try_read tag 7 in_base_pos 67
2725540 <7>[ 8771.114657] libceph:  read_partial_message con 0000000094d53202 msg 0000000060b8a473
2725541 <7>[ 8771.114660] libceph:  read_partial return 1
2725542 <7>[ 8771.114663] libceph:  read_partial have 14, left 7, con->v1.in_base_pos 67         ====> the rest 7 bytes came
2725543 <7>[ 8771.114669] libceph:  read_partial return 1
2725544 <7>[ 8771.114671] libceph:  read_partial_message got msg 0000000060b8a473 164 (4271800174) + 0 (0) + 16408 (2739232014)
2725545 <7>[ 8771.114677] libceph:  ===== 0000000060b8a473 73 from osd0 43=osd_opreply len 164+0+16408 (4271800174 0 2739232014) =====
2725546 <7>[ 8771.114683] libceph:  handle_reply msg 0000000060b8a473 tid 99
2725547 <7>[ 8771.114687] libceph:  handle_reply req 000000006ba179f6 tid 99 flags 0x400015 pgid 3.2b epoch 53 attempt 0 v 0'0 uv 5984
2725548 <7>[ 8771.114693] libceph:   req 000000006ba179f6 tid 99 op 0 rval 0 len 16408
2725549 <7>[ 8771.114697] libceph:  handle_reply req 000000006ba179f6 tid 99 result 0 data_len 16408
2725550 <7>[ 8771.114701] libceph:  finish_request req 000000006ba179f6 tid 99                   ====> the request was successfully finished



V3:
- rename read_sparse_msg_XX to read_partial_sparse_msg_XX
- fix the sparse-read bug in the messager v1 code.

V2:
- fix the sparse-read bug in the sparse-read code instead


Xiubo Li (3):
  libceph: fail the sparse-read if there still has data in socket
  libceph: rename read_sparse_msg_XX to read_partial_sparse_msg_XX
  libceph: just wait for more data to be available on the socket

 include/linux/ceph/messenger.h |  2 ++
 net/ceph/messenger.c           |  1 +
 net/ceph/messenger_v1.c        | 29 ++++++++++++++++++++---------
 net/ceph/osd_client.c          |  5 ++++-
 4 files changed, 27 insertions(+), 10 deletions(-)

-- 
2.43.0


