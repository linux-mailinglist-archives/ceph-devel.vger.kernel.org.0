Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465E3BDA87
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 11:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbfIYJJP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 05:09:15 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:21294 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbfIYJIl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 05:08:41 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD3dl9YLotdHDhSAg--.166S2;
        Wed, 25 Sep 2019 17:07:36 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v4 00/12] rbd journaling feature
Date:   Wed, 25 Sep 2019 09:07:22 +0000
Message-Id: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: u+CowAD3dl9YLotdHDhSAg--.166S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUPoGQUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbifxg7elrpOUem0wAAse
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya, Jason and all:
	This is V4 fro krbd journaling feature. Please help to review. thanx

	kernel branch: https://github.com/yangdongsheng/linux/tree/krbd_journaling_v4
	ceph qa branch: https://github.com/yangdongsheng/ceph/tree/krbd_mirror_qa

Changelog:
	- from v3:
		1 Fix multi-events for single write problem. And I added a test case
		    in rbd_mirror.sh for it: https://github.com/yangdongsheng/ceph/commit/cb1f2d10d7c206afbd05718868401e6c2ee13e0c#diff-64d0a5a0c5330ed542d2b395a20b0a97R31
		2 Add zeroout event support. And I added a test case in rbd_mirror.sh:
		    https://github.com/yangdongsheng/ceph/commit/20ead333371603000747e17b9f528fe2584d4034#diff-64d0a5a0c5330ed542d2b395a20b0a97R43
		3 Fix call chain problem found in iozone testing.
		4 coding-style. fixed some coding-style problem. In addition, I tried clang-format
		  to do a double check.

Dongsheng Yang (12):
  libceph: introduce ceph_extract_encoded_string_kvmalloc
  libceph: introduce a new parameter of workqueue in ceph_osdc_watch()
  libceph: support op append
  libceph: add prefix and suffix in ceph_osd_req_op.extent
  libceph: introduce cls_journal_client
  libceph: introduce generic journaler module
  rbd: introduce completion for each img_request
  rbd: introduce IMG_REQ_NOLOCK flag for image request state
  rbd: introduce rbd_journal_allocate_tag to allocate journal tag for
    rbd client
  rbd: append journal event in image request state machine
  rbd: replay events in journal
  rbd: add support for feature of RBD_FEATURE_JOURNALING

 drivers/block/rbd.c                     |  698 +++++++++-
 include/linux/ceph/cls_journal_client.h |   84 ++
 include/linux/ceph/decode.h             |   21 +-
 include/linux/ceph/journaler.h          |  182 +++
 include/linux/ceph/osd_client.h         |   21 +
 net/ceph/Makefile                       |    3 +-
 net/ceph/cls_journal_client.c           |  527 ++++++++
 net/ceph/journaler.c                    | 2205 +++++++++++++++++++++++++++++++
 net/ceph/osd_client.c                   |   61 +-
 9 files changed, 3790 insertions(+), 12 deletions(-)
 create mode 100644 include/linux/ceph/cls_journal_client.h
 create mode 100644 include/linux/ceph/journaler.h
 create mode 100644 net/ceph/cls_journal_client.c
 create mode 100644 net/ceph/journaler.c

-- 
1.8.3.1


