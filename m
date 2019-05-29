Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D869D2E571
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 21:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfE2Tfz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 15:35:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:40174 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbfE2Tfz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 May 2019 15:35:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A37F1AB9D
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 19:35:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 29 May 2019 21:35:54 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     ceph-devel@vger.kernel.org
Subject: messenger: performance drop, v2 vs v1
Message-ID: <e201d78b90c3fa4c794787685520cedd@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,

I did a quick protocol performance comparison using fio_ceph_messenger
engine having `37c70bd1a75f ("Merge pull request #28099 from 
tchaikov/wip-blobhash")`
as a master.  I use default fio job and config:

   src/test/fio/ceph-messenger.fio

      iodepth=128

   src/test/fio/ceph-messenger.conf

      [global]
      ms_type=async+posix
      ms_crc_data=false
      ms_crc_header=false
      ms_dispatch_throttle_bytes=0
      debug_ms=0/0


Results:

   protocol v1:

     4k  IOPS=116k, BW=454MiB/s, Lat=1100.75usec
     8k  IOPS=104k, BW=816MiB/s, Lat=1224.83usec
    16k  IOPS=93.7k, BW=1463MiB/s, Lat=1366.15usec
    32k  IOPS=81.5k, BW=2548MiB/s, Lat=1568.80usec
    64k  IOPS=69.8k, BW=4366MiB/s, Lat=1831.76usec
   128k  IOPS=47.8k, BW=5973MiB/s, Lat=2677.71usec
   256k  IOPS=23.7k, BW=5917MiB/s, Lat=5406.42usec
   512k  IOPS=11.8k, BW=5912MiB/s, Lat=10823.24usec
     1m  IOPS=5792, BW=5793MiB/s, Lat=22092.82usec


   protocol v2:

     4k  IOPS=95.5k, BW=373MiB/s, Lat=1340.09usec
     8k  IOPS=85.3k, BW=666MiB/s, Lat=1499.54usec
    16k  IOPS=75.8k, BW=1184MiB/s, Lat=1688.65usec
    32k  IOPS=61.6k, BW=1924MiB/s, Lat=2078.29usec
    64k  IOPS=53.6k, BW=3349MiB/s, Lat=2388.17usec
   128k  IOPS=32.5k, BW=4059MiB/s, Lat=3940.99usec
   256k  IOPS=17.5k, BW=4376MiB/s, Lat=7310.90usec
   512k  IOPS=8718, BW=4359MiB/s, Lat=14679.53usec
     1m  IOPS=3785, BW=3785MiB/s, Lat=33811.59usec


    IOPS percentage change:

           v1                v2            % change

     4k  IOPS=116k        IOPS=95.5k         -17%
     8k  IOPS=104k        IOPS=85.3k         -17%
    16k  IOPS=93.7k       IOPS=75.8k         -19%
    32k  IOPS=81.5k       IOPS=61.6k         -24%
    64k  IOPS=69.8k       IOPS=53.6k         -23%
   128k  IOPS=47.8k       IOPS=32.5k         -32%
   256k  IOPS=23.7k       IOPS=17.5k         -26%
   512k  IOPS=11.8k       IOPS=8718          -25%
     1m  IOPS=5792        IOPS=3785          -35%


Is that expected? Does anyone have similar numbers?


PS. Am I mistaken or 'ms_msgr2_encrypt_messages' and
     'ms_msgr2_sign_messages' options are not used at all?

--
Roman

