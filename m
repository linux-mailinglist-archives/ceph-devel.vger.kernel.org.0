Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682B51B2772
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgDUNS7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:18:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:49992 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDUNS6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:18:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C3D45ABF6;
        Tue, 21 Apr 2020 13:18:55 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 00/16] libceph: messenger: send/recv data at one go
Date:   Tue, 21 Apr 2020 15:18:34 +0200
Message-Id: <20200421131850.443228-1-rpenyaev@suse.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi folks,

While experimenting with messenger code in userspace [1] I noticed
that send and receive socket calls always operate with 4k, even bvec
length is larger (for example when bvec is contructed from bio, where
multi-page is used for big IOs). This is an attempt to speed up send
and receive for large IO.

First 3 patches are cleanups. I remove unused code and get rid of
ceph_osd_data structure. I found that ceph_osd_data duplicates
ceph_msg_data and it seems unified API looks better for similar
things.

In the following patches ceph_msg_data_cursor is switched to iov_iter,
which seems is more suitable for such kind of things (when we
basically do socket IO). This gives us the possibility to use the
whole iov_iter for sendmsg() and recvmsg() calls instead of iterating
page by page. sendpage() call also benefits from this, because now if
bvec is constructed from multi-page, then we can 0-copy the whole
bvec in one go.

I also allowed myself to get rid of ->last_piece and ->need_crc
members and ceph_msg_data_next() call. Now CRC is calculated not on
page basis, but according to the size of processed chunk.  I found
ceph_msg_data_next() is a bit redundant, since we always can set the
next cursor chunk on cursor init or on advance.

How I tested the performance? I used rbd.fio load on 1 OSD in memory
with the following fio configuration:

  direct=1
  time_based=1
  runtime=10
  ioengine=io_uring
  size=256m

  rw=rand{read|write}
  numjobs=32
  iodepth=32

  [job1]
  filename=/dev/rbd0

RBD device is mapped with 'nocrc' option set.  For writes OSD completes
requests immediately, without touching the memory simulating null block
device, that's why write throughput in my results is much higher than
for reads.

I tested on loopback interface only, in Vm, have not yet setup the
cluster on real machines, so sendpage() on a big multi-page shows
indeed good results, as expected. But I found an interesting comment
in drivers/infiniband/sw/siw/siw_qp_tc.c:siw_tcp_sendpages(), which
says:

 "Using sendpage to push page by page appears to be less efficient
  than using sendmsg, even if data are copied.
 
  A general performance limitation might be the extra four bytes
  trailer checksum segment to be pushed after user data."

I could not prove or disprove since have tested on loopback interface
only.  So it might be that sendmsg() in on go is faster than
sendpage() for bvecs with many segments.

Here is the output of the rbd fio load for various block sizes:

==== WRITE ===

current master, rw=randwrite, numjobs=32 iodepth=32

  4k  IOPS=92.7k, BW=362MiB/s, Lat=11033.30usec
  8k  IOPS=85.6k, BW=669MiB/s, Lat=11956.74usec
 16k  IOPS=76.8k, BW=1200MiB/s, Lat=13318.24usec
 32k  IOPS=56.7k, BW=1770MiB/s, Lat=18056.92usec
 64k  IOPS=34.0k, BW=2186MiB/s, Lat=29.23msec
128k  IOPS=21.8k, BW=2720MiB/s, Lat=46.96msec
256k  IOPS=14.4k, BW=3596MiB/s, Lat=71.03msec
512k  IOPS=8726, BW=4363MiB/s, Lat=116.34msec
  1m  IOPS=4799, BW=4799MiB/s, Lat=211.15msec

this patchset,  rw=randwrite, numjobs=32 iodepth=32

  4k  IOPS=94.7k, BW=370MiB/s, Lat=10802.43usec
  8k  IOPS=91.2k, BW=712MiB/s, Lat=11221.00usec
 16k  IOPS=80.4k, BW=1257MiB/s, Lat=12715.56usec
 32k  IOPS=61.2k, BW=1912MiB/s, Lat=16721.33usec
 64k  IOPS=40.9k, BW=2554MiB/s, Lat=24993.31usec
128k  IOPS=25.7k, BW=3216MiB/s, Lat=39.72msec
256k  IOPS=17.3k, BW=4318MiB/s, Lat=59.15msec
512k  IOPS=11.1k, BW=5559MiB/s, Lat=91.39msec
  1m  IOPS=6696, BW=6696MiB/s, Lat=151.25msec


=== READ ===

current master, rw=randread, numjobs=32 iodepth=32

  4k  IOPS=62.5k, BW=244MiB/s, Lat=16.38msec
  8k  IOPS=55.5k, BW=433MiB/s, Lat=18.44msec
 16k  IOPS=40.6k, BW=635MiB/s, Lat=25.18msec
 32k  IOPS=24.6k, BW=768MiB/s, Lat=41.61msec
 64k  IOPS=14.8k, BW=925MiB/s, Lat=69.06msec
128k  IOPS=8687, BW=1086MiB/s, Lat=117.59msec
256k  IOPS=4733, BW=1183MiB/s, Lat=214.76msec
512k  IOPS=3156, BW=1578MiB/s, Lat=320.54msec
  1m  IOPS=1901, BW=1901MiB/s, Lat=528.22msec

this patchset,  rw=randread, numjobs=32 iodepth=32

  4k  IOPS=62.6k, BW=244MiB/s, Lat=16342.89usec
  8k  IOPS=55.5k, BW=434MiB/s, Lat=18.42msec
 16k  IOPS=43.2k, BW=675MiB/s, Lat=23.68msec
 32k  IOPS=28.4k, BW=887MiB/s, Lat=36.04msec
 64k  IOPS=20.2k, BW=1263MiB/s, Lat=50.54msec
128k  IOPS=11.7k, BW=1465MiB/s, Lat=87.01msec
256k  IOPS=6813, BW=1703MiB/s, Lat=149.30msec
512k  IOPS=5363, BW=2682MiB/s, Lat=189.37msec
  1m  IOPS=2220, BW=2221MiB/s, Lat=453.92msec


Results for small blocks are not interesting, since there should not
be any difference. But starting from 32k block benefits of doing IO
for the whole message at once starts to prevail.

I'm open to test any other loads, I just usually stick to fio rbd,
since it is pretty simple and pumps the IOs quite well.

[1] https://github.com/rouming/pech

Roman Penyaev (16):
  libceph: remove unused ceph_pagelist_cursor
  libceph: extend ceph_msg_data API in order to switch on it
  libceph,rbd,cephfs: switch from ceph_osd_data to ceph_msg_data
  libceph: remove ceph_osd_data completely
  libceph: remove unused last_piece out parameter from
    ceph_msg_data_next()
  libceph: switch data cursor from page to iov_iter for messenger
  libceph: use new tcp_sendiov() instead of tcp_sendmsg() for messenger
  libceph: remove unused tcp wrappers, now iov_iter is used for
    messenger
  libceph: no need for cursor->need_crc for messenger
  libceph: remove ->last_piece member for message data cursor
  libceph: remove not necessary checks on doing advance on bio and bvecs
    cursor
  libceph: switch bvecs cursor to iov_iter for messenger
  libceph: switch bio cursor to iov_iter for messenger
  libceph: switch pages cursor to iov_iter for messenger
  libceph: switch pageslist cursor to iov_iter for messenger
  libceph: remove ceph_msg_data_*_next() from messenger

 drivers/block/rbd.c             |   4 +-
 fs/ceph/addr.c                  |  10 +-
 fs/ceph/file.c                  |   4 +-
 include/linux/ceph/messenger.h  |  42 ++-
 include/linux/ceph/osd_client.h |  58 +---
 include/linux/ceph/pagelist.h   |  12 -
 net/ceph/messenger.c            | 558 +++++++++++++++-----------------
 net/ceph/osd_client.c           | 251 ++++----------
 net/ceph/pagelist.c             |  38 ---
 9 files changed, 390 insertions(+), 587 deletions(-)

-- 
2.24.1

