Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BED1788A9
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfG2Jn3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:29 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22496 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfG2Jn2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:28 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S2;
        Mon, 29 Jul 2019 17:42:59 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 00/15] rbd journaling feature
Date:   Mon, 29 Jul 2019 09:42:42 +0000
Message-Id: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWrW3tw4fuF1xGF1DtF48Xrb_yoWrJr4DpF
        43Gw13XrWUZr17Aws7Ja18Jry5ZrW8ArWUWr1DGrn7Kw15AFy2qr1UtryrJry7JryxGr1U
        Jr1UJw1UGw1UAFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JbSxhLUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiWwMBelf4pRYZaAAAsO
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya, Jason and all:
      	As new exclusive-lock is merged, I think we can start this work now.
This is V3, which is rebased against 5.3-rc1.

Testing:
	kernel branch: https://github.com/yangdongsheng/linux/tree/krbd_journaling_v3
	ceph qa branch: https://github.com/yangdongsheng/ceph/tree/krbd_mirror_qa

	(1). A new test added: workunits/rbd/kernel_journal.sh: to test the journal replaying in krbd.
	(2). A new test added: qa/suites/krbd/mirror/, this test krbd journaling with rbd-mirror daemon.

Performance:
        compared with librbd journaling, preformance of krbd journaling looks reasonable.
        -------------------------------------------------------------------------------------
        (1) rbd bench with journaling disabled:         |       IOPS: 114
        -------------------------------------------------------------------------------------
        (2) rbd bench with journaling enabled:          |       IOPS: 55
        -------------------------------------------------------------------------------------
        (3) fio krbd with journaling disabled:          |       IOPS: 118
        -------------------------------------------------------------------------------------
        (4) fio krbd with journaling enabled:           |       IOPS: 57
        -------------------------------------------------------------------------------------

TODO:
	(1). there are some TODOs in comments, such as supporting rbd_journal_max_concurrent_object_sets.
	(2). add debugfs for generic journaling.

	I would like to put this TODO work in next cycle, but focus on making  the current work ready to go.

Changelog:
	-V2
		1. support large event (> 4M)
		2. fix bug in replay in different clients appending
		3. rebase against 5.3-rc1
		4. refactor journaler appending into state machine
        -V1
                1. add test case in qa
                2. address all memleak found in kmemleak
                3. several bug fixes
                4. performance improvement.
        -RFC
                1. error out if there is some unsupported event type in replaying
                2. just one memory copy from bio to msg.
                3. use async IO in journal appending.
                4. no mutex around IO.

Any comments are welcome!!

Dongsheng Yang (15):
  libceph: introduce ceph_extract_encoded_string_kvmalloc
  libceph: introduce a new parameter of workqueue in ceph_osdc_watch()
  libceph: support op append
  libceph: add prefix and suffix in ceph_osd_req_op.extent
  libceph: introduce cls_journaler_client
  libceph: introduce generic journaling
  libceph: journaling: introduce api to replay uncommitted journal
    events
  libceph: journaling: introduce api for journal appending
  libceph: journaling: trim object set when we found there is no client
    refer it
  rbd: introduce completion for each img_request
  rbd: introduce IMG_REQ_NOLOCK flag for image request state
  rbd: introduce rbd_journal_allocate_tag to allocate journal tag for
    rbd client
  rbd: append journal event in image request state machine
  rbd: replay events in journal
  rbd: add support for feature of RBD_FEATURE_JOURNALING

 drivers/block/rbd.c                       |  600 +++++++-
 include/linux/ceph/cls_journaler_client.h |   94 ++
 include/linux/ceph/decode.h               |   21 +-
 include/linux/ceph/journaler.h            |  184 +++
 include/linux/ceph/osd_client.h           |   19 +
 net/ceph/Makefile                         |    3 +-
 net/ceph/cls_journaler_client.c           |  558 ++++++++
 net/ceph/journaler.c                      | 2231 +++++++++++++++++++++++++++++
 net/ceph/osd_client.c                     |   61 +-
 9 files changed, 3759 insertions(+), 12 deletions(-)
 create mode 100644 include/linux/ceph/cls_journaler_client.h
 create mode 100644 include/linux/ceph/journaler.h
 create mode 100644 net/ceph/cls_journaler_client.c
 create mode 100644 net/ceph/journaler.c

-- 
1.8.3.1


