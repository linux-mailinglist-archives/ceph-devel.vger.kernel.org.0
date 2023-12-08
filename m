Return-Path: <ceph-devel+bounces-270-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6DE580A83A
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 17:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04F4E1C209E6
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 16:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A74C3714B;
	Fri,  8 Dec 2023 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hhtdRAbz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5811989
	for <ceph-devel@vger.kernel.org>; Fri,  8 Dec 2023 08:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702051704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6Gw7Bb5wCFOEwzkRsKwek6hA+qy6HPnPOzIuNUiZWiE=;
	b=hhtdRAbziNfQmI8K9A6QM27uf+VwkxFLS6lIgK0cOijqVyo9MlnftHD1vF1r5zr4sE6v0U
	u4Nq4mFJU+niEp4bsck64kgURcwmBCCRGeaRdZcR37HAgeuUciTrleMbk1VEAmyGeBwBi0
	6ka8TIjI2RiUpi8dXL6g0Z3qfdJiuCA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686--YzEYdXwNPe3Y0ySpit2eg-1; Fri,
 08 Dec 2023 11:08:18 -0500
X-MC-Unique: -YzEYdXwNPe3Y0ySpit2eg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82CBC1C060C9;
	Fri,  8 Dec 2023 16:08:18 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.27])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 69FE38CD0;
	Fri,  8 Dec 2023 16:08:14 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] libceph: fix sparse-read failure bug
Date: Sat,  9 Dec 2023 00:05:59 +0800
Message-ID: <20231208160601.124892-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Xiubo Li <xiubli@redhat.com>

The debug logs:

7271665 <7>[120727.292870] libceph:  get_reply tid 5526 000000002bfe53c9
7271666 <7>[120727.292875] libceph:  get_osd 000000009e8420b7 4 -> 5
7271667 <7>[120727.292882] libceph:  prep_next_sparse_read: [2] starting new sparse read req. srlen=0x7000
7271668 <7>[120727.292887] libceph:  prep_next_sparse_read: [2] new sparse read op at idx 0 0x60000~0x7000
7271669 <7>[120727.292894] libceph:  [2] got 1 extents
7271670 <7>[120727.292900] libceph:  [2] ext 0 off 0x60000 len 0x4000
7271671 <7>[120727.292912] libceph:  prep_next_sparse_read: [2] completed extent array len 1 cursor->resid 12288
7271672 <7>[120727.292917] libceph:  read_partial left: 21, have: 0, con->v1.in_base_pos: 53
7271673 <7>[120727.292923] libceph:  read_partial left: 7, have: 14, con->v1.in_base_pos: 67     ====> there were 7 bytes not received
7271674 <7>[120727.292928] libceph:  read_partial return 0
7271675 <7>[120727.292931] libceph:  try_read done on 00000000ddd953f1 ret 0
7271676 <7>[120727.292935] libceph:  try_write start 00000000ddd953f1 state 12
7271677 <7>[120727.292939] libceph:  try_write out_kvec_bytes 0
7271678 <7>[120727.292943] libceph:  try_write nothing else to write.
7271679 <7>[120727.292948] libceph:  try_write done on 00000000ddd953f1 ret 0
7271680 <7>[120727.292955] libceph:  put_osd 000000009e8420b7 5 -> 4
7271681 <7>[120727.293021] libceph:  ceph_sock_data_ready 00000000ddd953f1 state = 12, queueing work
7271682 <7>[120727.293029] libceph:  get_osd 000000009e8420b7 4 -> 5
7271683 <7>[120727.293041] libceph:  queue_con_delay 00000000ddd953f1 0
7271684 <7>[120727.293134] libceph:  try_read start 00000000ddd953f1 state 12
7271685 <7>[120727.293141] libceph:  try_read tag 7 in_base_pos 67
7271686 <7>[120727.293145] libceph:  read_partial_message con 00000000ddd953f1 msg 000000002bfe53c9
7271687 <7>[120727.293150] libceph:  read_partial return 1
7271688 <7>[120727.293154] libceph:  read_partial left: 7, have: 14, con->v1.in_base_pos: 67     ====> the left 7 bytes came
7271689 <7>[120727.293189] libceph:  read_partial return 1
7271690 <7>[120727.293193] libceph:  read_partial_message got msg 000000002bfe53c9 164 (216900879) + 0 (0) + 16408 (1227708997)
7271691 <7>[120727.293203] libceph:  ===== 000000002bfe53c9 3092 from osd2 43=osd_opreply len 164+0+16408 (216900879 0 1227708997) =====
7271692 <7>[120727.293211] libceph:  handle_reply msg 000000002bfe53c9 tid 5526                  ====> the req was successfully finished
7271693 <7>[120727.293217] libceph:  handle_reply req 00000000b7727657 tid 5526 flags 0x400015 pgid 3.55 epoch 52 attempt 0 v 0'0 uv 2275
7271694 <7>[120727.293225] libceph:   req 00000000b7727657 tid 5526 op 0 rval 0 len 16408
7271695 <7>[120727.293231] libceph:  handle_reply req 00000000b7727657 tid 5526 result 0 data_len 16408
7271696 <7>[120727.293236] libceph:  finish_request req 00000000b7727657 tid 5526
7271697 <7>[120727.293241] libceph:  unlink_request osd 000000009e8420b7 osd2 req 00000000b7727657 tid 5526



V2:
- fix the sparse-read bug in the sparse-read code instead

Xiubo Li (2):
  libceph: fail the sparse-read if there still has data in socket
  libceph: just wait for more data to be available on the socket

 include/linux/ceph/osd_client.h |  1 +
 net/ceph/osd_client.c           | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.43.0


