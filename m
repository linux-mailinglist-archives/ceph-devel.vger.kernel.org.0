Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A16C24F7
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Sep 2019 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732276AbfI3QNz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 30 Sep 2019 12:13:55 -0400
Received: from mail03.roosit.eu ([212.19.193.213]:34770 "EHLO mail03.roosit.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732047AbfI3QNy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 12:13:54 -0400
Received: from sx.f1-outsourcing.eu (host-213.189.39.136.telnetsolutions.pl [213.189.39.136] (may be forged))
        by mail03.roosit.eu (8.14.7/8.14.7) with ESMTP id x8UGDi1F001048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 30 Sep 2019 18:13:45 +0200
Received: from sx.f1-outsourcing.eu (localhost.localdomain [127.0.0.1])
        by sx.f1-outsourcing.eu (8.13.8/8.13.8) with ESMTP id x8UGDh2S024053;
        Mon, 30 Sep 2019 18:13:43 +0200
Date:   Mon, 30 Sep 2019 18:13:42 +0200
From:   "Marc Roos" <M.Roos@f1-outsourcing.eu>
To:     "alexander.v.litvak" <alexander.v.litvak@gmail.com>,
        ceph-users <ceph-users@lists.ceph.com>
cc:     ceph-devel <ceph-devel@vger.kernel.org>
Message-ID: <"H000007100150ea4.1569860022.sx.f1-outsourcing.eu*"@MHS>
In-Reply-To: <qmq36f$5pap$1@blaine.gmane.org>
Subject: RE: [ceph-users] Commit and Apply latency on nautilus
x-scalix-Hops: 1
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


What parameters are you exactly using? I want to do a similar test on 
luminous, before I upgrade to Nautilus. I have quite a lot (74+)

type_instance=Osd.opBeforeDequeueOpLat
type_instance=Osd.opBeforeQueueOpLat
type_instance=Osd.opLatency
type_instance=Osd.opPrepareLatency
type_instance=Osd.opProcessLatency
type_instance=Osd.opRLatency
type_instance=Osd.opRPrepareLatency
type_instance=Osd.opRProcessLatency
type_instance=Osd.opRwLatency
type_instance=Osd.opRwPrepareLatency
type_instance=Osd.opRwProcessLatency
type_instance=Osd.opWLatency
type_instance=Osd.opWPrepareLatency
type_instance=Osd.opWProcessLatency
type_instance=Osd.subopLatency
type_instance=Osd.subopWLatency
...
...





-----Original Message-----
From: Alex Litvak [mailto:alexander.v.litvak@gmail.com] 
Sent: zondag 29 september 2019 13:06
To: ceph-users@lists.ceph.com
Cc: ceph-devel@vger.kernel.org
Subject: [ceph-users] Commit and Apply latency on nautilus

Hello everyone,

I am running a number of parallel benchmark tests against the cluster 
that should be ready to go to production.
I enabled prometheus to monitor various information and while cluster 
stays healthy through the tests with no errors or slow requests,
I noticed an apply / commit latency jumping between 40 - 600 ms on 
multiple SSDs.  At the same time op_read and op_write are on average 
below 0.25 ms in the worth case scenario.

I am running nautilus 14.2.2, all bluestore, no separate NVME devices 
for WAL/DB, 6 SSDs per node(Dell PowerEdge R440) with all drives Seagate 
Nytro 1551, osd spread across 6 nodes, running in 
containers.  Each node has plenty of RAM with utilization ~ 25 GB during 
the benchmark runs.

Here are benchmarks being run from 6 client systems in parallel, 
repeating the test for each block size in <4k,16k,128k,4M>.

On rbd mapped partition local to each client:

fio --name=randrw --ioengine=libaio --iodepth=4 --rw=randrw 
--bs=<4k,16k,128k,4M> --direct=1 --size=2G --numjobs=8 --runtime=300 
--group_reporting --time_based --rwmixread=70

On mounted cephfs volume with each client storing test file(s) in own 
sub-directory:

fio --name=randrw --ioengine=libaio --iodepth=4 --rw=randrw 
--bs=<4k,16k,128k,4M> --direct=1 --size=2G --numjobs=8 --runtime=300 
--group_reporting --time_based --rwmixread=70

dbench -t 30 30

Could you please let me know if huge jump in applied and committed 
latency is justified in my case and whether I can do anything to improve 
/ fix it.  Below is some additional cluster info.

Thank you,

root@storage2n2-la:~# podman exec -it ceph-mon-storage2n2-la ceph osd df
ID CLASS WEIGHT  REWEIGHT SIZE    RAW USE DATA    OMAP    META     AVAIL 
  %USE VAR  PGS STATUS
  6   ssd 1.74609  1.00000 1.7 TiB  93 GiB  92 GiB 240 MiB  784 MiB 1.7 
TiB 5.21 0.90  44     up
12   ssd 1.74609  1.00000 1.7 TiB  98 GiB  97 GiB 118 MiB  906 MiB 1.7 
TiB 5.47 0.95  40     up
18   ssd 1.74609  1.00000 1.7 TiB 102 GiB 101 GiB 123 MiB  901 MiB 1.6 
TiB 5.73 0.99  47     up
24   ssd 3.49219  1.00000 3.5 TiB 222 GiB 221 GiB 134 MiB  890 MiB 3.3 
TiB 6.20 1.07  96     up
30   ssd 3.49219  1.00000 3.5 TiB 213 GiB 212 GiB 151 MiB  873 MiB 3.3 
TiB 5.95 1.03  93     up
35   ssd 3.49219  1.00000 3.5 TiB 203 GiB 202 GiB 301 MiB  723 MiB 3.3 
TiB 5.67 0.98 100     up
  5   ssd 1.74609  1.00000 1.7 TiB 103 GiB 102 GiB 123 MiB  901 MiB 1.6 
TiB 5.78 1.00  49     up
11   ssd 1.74609  1.00000 1.7 TiB 109 GiB 108 GiB  63 MiB  961 MiB 1.6 
TiB 6.09 1.05  46     up
17   ssd 1.74609  1.00000 1.7 TiB 104 GiB 103 GiB 205 MiB  819 MiB 1.6 
TiB 5.81 1.01  50     up
23   ssd 3.49219  1.00000 3.5 TiB 210 GiB 209 GiB 168 MiB  856 MiB 3.3 
TiB 5.86 1.01  86     up
29   ssd 3.49219  1.00000 3.5 TiB 204 GiB 203 GiB 272 MiB  752 MiB 3.3 
TiB 5.69 0.98  92     up
34   ssd 3.49219  1.00000 3.5 TiB 198 GiB 197 GiB 295 MiB  729 MiB 3.3 
TiB 5.54 0.96  85     up
  4   ssd 1.74609  1.00000 1.7 TiB 119 GiB 118 GiB  16 KiB 1024 MiB 1.6 
TiB 6.67 1.15  50     up
10   ssd 1.74609  1.00000 1.7 TiB  95 GiB  94 GiB 183 MiB  841 MiB 1.7 
TiB 5.31 0.92  46     up
16   ssd 1.74609  1.00000 1.7 TiB 102 GiB 101 GiB 122 MiB  902 MiB 1.6 
TiB 5.72 0.99  50     up
22   ssd 3.49219  1.00000 3.5 TiB 218 GiB 217 GiB 109 MiB  915 MiB 3.3 
TiB 6.11 1.06  91     up
28   ssd 3.49219  1.00000 3.5 TiB 198 GiB 197 GiB 343 MiB  681 MiB 3.3 
TiB 5.54 0.96  95     up
33   ssd 3.49219  1.00000 3.5 TiB 198 GiB 196 GiB 297 MiB 1019 MiB 3.3 
TiB 5.53 0.96  85     up
  1   ssd 1.74609  1.00000 1.7 TiB 101 GiB 100 GiB 222 MiB  802 MiB 1.6 
TiB 5.63 0.97  49     up
  7   ssd 1.74609  1.00000 1.7 TiB 102 GiB 101 GiB 153 MiB  871 MiB 1.6 
TiB 5.69 0.99  46     up
13   ssd 1.74609  1.00000 1.7 TiB 106 GiB 105 GiB  67 MiB  957 MiB 1.6 
TiB 5.96 1.03  42     up
19   ssd 3.49219  1.00000 3.5 TiB 206 GiB 205 GiB 179 MiB  845 MiB 3.3 
TiB 5.77 1.00  83     up
25   ssd 3.49219  1.00000 3.5 TiB 195 GiB 194 GiB 352 MiB  672 MiB 3.3 
TiB 5.45 0.94  97     up
31   ssd 3.49219  1.00000 3.5 TiB 201 GiB 200 GiB 305 MiB  719 MiB 3.3 
TiB 5.62 0.97  90     up
  0   ssd 1.74609  1.00000 1.7 TiB 110 GiB 109 GiB  29 MiB  995 MiB 1.6 
TiB 6.14 1.06  43     up
  3   ssd 1.74609  1.00000 1.7 TiB 109 GiB 108 GiB  28 MiB  996 MiB 1.6 
TiB 6.07 1.05  41     up
  9   ssd 1.74609  1.00000 1.7 TiB 103 GiB 102 GiB 149 MiB  875 MiB 1.6 
TiB 5.76 1.00  52     up
15   ssd 3.49219  1.00000 3.5 TiB 209 GiB 208 GiB 253 MiB  771 MiB 3.3 
TiB 5.83 1.01  98     up
21   ssd 3.49219  1.00000 3.5 TiB 199 GiB 198 GiB 302 MiB  722 MiB 3.3 
TiB 5.56 0.96  90     up
27   ssd 3.49219  1.00000 3.5 TiB 208 GiB 207 GiB 226 MiB  798 MiB 3.3 
TiB 5.81 1.00  95     up
  2   ssd 1.74609  1.00000 1.7 TiB  96 GiB  95 GiB 158 MiB  866 MiB 1.7 
TiB 5.35 0.93  45     up
  8   ssd 1.74609  1.00000 1.7 TiB 106 GiB 105 GiB 132 MiB  892 MiB 1.6 
TiB 5.91 1.02  50     up
14   ssd 1.74609  1.00000 1.7 TiB  96 GiB  95 GiB 180 MiB  844 MiB 1.7 
TiB 5.35 0.92  46     up
20   ssd 3.49219  1.00000 3.5 TiB 221 GiB 220 GiB 156 MiB  868 MiB 3.3 
TiB 6.18 1.07 101     up
26   ssd 3.49219  1.00000 3.5 TiB 206 GiB 205 GiB 332 MiB  692 MiB 3.3 
TiB 5.76 1.00  92     up
32   ssd 3.49219  1.00000 3.5 TiB 221 GiB 220 GiB  88 MiB  936 MiB 3.3 
TiB 6.18 1.07  91     up
                     TOTAL  94 TiB 5.5 TiB 5.4 TiB 6.4 GiB   30 GiB  89 
TiB 5.78
MIN/MAX VAR: 0.90/1.15  STDDEV: 0.30


root@storage2n2-la:~# podman exec -it ceph-mon-storage2n2-la ceph -s
   cluster:
     id:     9b4468b7-5bf2-4964-8aec-4b2f4bee87ad
     health: HEALTH_OK

   services:
     mon: 3 daemons, quorum storage2n1-la,storage2n2-la,storage2n3-la 
(age 9w)
     mgr: storage2n2-la(active, since 9w), standbys: storage2n1-la, 
storage2n3-la
     mds: cephfs:1 {0=storage2n6-la=up:active} 1 up:standby-replay 1 
up:standby
     osd: 36 osds: 36 up (since 9w), 36 in (since 9w)

   data:
     pools:   3 pools, 832 pgs
     objects: 4.18M objects, 1.8 TiB
     usage:   5.5 TiB used, 89 TiB / 94 TiB avail
     pgs:     832 active+clean

   io:
     client:   852 B/s rd, 15 KiB/s wr, 4 op/s rd, 2 op/s wr





_______________________________________________
ceph-users mailing list
ceph-users@lists.ceph.com
http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com


