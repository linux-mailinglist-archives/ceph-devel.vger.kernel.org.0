Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9018D45871
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 11:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfFNJTy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Fri, 14 Jun 2019 05:19:54 -0400
Received: from mx-out.tlen.pl ([193.222.135.140]:33410 "EHLO mx-out.tlen.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfFNJTx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 05:19:53 -0400
Received: (wp-smtpd smtp.tlen.pl 6229 invoked from network); 14 Jun 2019 11:19:48 +0200
Received: from 87-207-64-23.dynamic.chello.pl (HELO [10.0.2.15]) (skidoo@o2.pl@[87.207.64.23])
          (envelope-sender <skidoo@tlen.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-SHA encrypted SMTP
          for <ceph-users@lists.ceph.com>; 14 Jun 2019 11:19:48 +0200
Date:   Fri, 14 Jun 2019 11:19:47 +0200
From:   Luk <skidoo@tlen.pl>
Reply-To: =?iso-8859-2?Q?=A3ukasz_Chrustek?= <skidoo@tlen.pl>
Message-ID: <304057881.20190614111947@tlen.pl>
To:     ceph-users@lists.ceph.com, ceph-devel@vger.kernel.org
Subject: problem with degraded PG
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-WP-MailID: 680706a9fb6a7fd803aa5663abee61e3
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000A [kcM0]                               
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

Maybe  somone  was  fighting  with this kind of stuck in ceph already.
This  is  production  cluster,  can't/don't  want to make wrong steps,
please advice, what to do.

After  changing  of  one failed disk (it was osd-7) on our cluster ceph
didn't recover to HEALTH_OK, it stopped in state:

[root@ceph-mon-01 ~]# ceph -s
  cluster:
    id:     b6f23cff-7279-f4b0-ff91-21fadac95bb5
    health: HEALTH_WARN
            noout,noscrub,nodeep-scrub flag(s) set
            Degraded data redundancy: 24761/45994899 objects degraded (0.054%), 8 pgs degraded, 8 pgs undersized
 
  services:
    mon:        3 daemons, quorum ceph-mon-01,ceph-mon-02,ceph-mon-03
    mgr:        ceph-mon-03(active), standbys: ceph-mon-02, ceph-mon-01
    osd:        144 osds: 144 up, 144 in
                flags noout,noscrub,nodeep-scrub
    rbd-mirror: 3 daemons active
    rgw:        6 daemons active
 
  data:
    pools:   18 pools, 2176 pgs
    objects: 15.33M objects, 49.3TiB
    usage:   151TiB used, 252TiB / 403TiB avail
    pgs:     24761/45994899 objects degraded (0.054%)
             2168 active+clean
             8    active+undersized+degraded
 
  io:
    client:   435MiB/s rd, 415MiB/s wr, 7.94kop/s rd, 2.96kop/s wr

Restart of OSD didn't helped, changing choose_total_tries from 50 to 100 didn't help.

I checked one of degraded PG, 10.3c4

[root@ceph-mon-01 ~]# ceph pg dump 2>&1 | grep -w 10.3c4
10.3c4     3593                  0     3593         0       0 14769891858 10076    10076    active+undersized+degraded 2019-06-13 08:19:39.802219  37380'71900564 37380:119411139       [9,109]          9       [9,109]              9  33550'69130424 2019-06-08 02:28:40.508790  33550'69130424 2019-06-08 02:28:40.508790            18 


[root@ceph-mon-01 ~]# ceph pg 10.3c4 query | jq '.["peer_info"][] | {peer: .peer, last_update:.last_update}' 
{
  "peer": "0",
  "last_update": "36847'71412720"
}
{
  "peer": "109",
  "last_update": "37380'71900570"
}
{
  "peer": "117",
  "last_update": "0'0"
}


[root@ceph-mon-01 ~]#   
I have checked space taken for this PG on storage nodes:
here is how to check where is particular OSD (on which physical storage node):
[root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 9 "
|  9  |   stor-a02  | 2063G | 5386G |   52   |  1347k  |   53   |   292k  | exists,up |
[root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 109 "
| 109 |   stor-a01  | 1285G | 4301G |    5   |  31.0k  |    6   |  59.2k  | exists,up |
[root@ceph-mon-01 ~]# watch ceph -s
[root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 117 "
| 117 |   stor-b02  | 1334G | 4252G |   54   |  1216k  |   13   |  27.4k  | exists,up |
[root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 0 "
|  0  |   stor-a01  | 2156G | 5293G |   58   |   387k  |   29   |  30.7k  | exists,up |
[root@ceph-mon-01 ~]# 
and checking sizes on servers:
stor-a01 (this PG shouldn't be on the same host):
[root@stor-a01 /var/lib/ceph/osd/ceph-0/current]# du -sh 10.3c4_*
2.4G    10.3c4_head
0       10.3c4_TEMP
[root@stor-a01 /var/lib/ceph/osd/ceph-109/current]# du -sh 10.3c4_*
14G     10.3c4_head
0       10.3c4_TEMP
[root@stor-a01 /var/lib/ceph/osd/ceph-109/current]#
stor-a02:
[root@stor-a02 /var/lib/ceph/osd/ceph-9/current]# du -sh 10.3c4_*
14G     10.3c4_head
0       10.3c4_TEMP
[root@stor-a02 /var/lib/ceph/osd/ceph-9/current]#     
stor-b02:
[root@stor-b02 /var/lib/ceph/osd/ceph-117/current]# du -sh 10.3c4_*
zsh: no matches found: 10.3c4_*

information about ceph:
[root@ceph-mon-01 ~]# ceph versions
{
    "mon": {
        "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) luminous (stable)": 3
    },
    "mgr": {
        "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) luminous (stable)": 3
    },
    "osd": {
        "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) luminous (stable)": 144
    },
    "mds": {},
    "rbd-mirror": {
        "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) luminous (stable)": 3
    },
    "rgw": {
        "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) luminous (stable)": 6
    },
    "overall": {
        "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) luminous (stable)": 159
    }
}

crushmap: https://pastebin.com/cpC2WmyS
ceph osd tree: https://pastebin.com/XvZ2cNZZ

I'm  cross-posting this do devel because maybe there is some known bug
in  this  particular  version  of  ceph,  and  You  could  point  some
directions to fix this problem.

-- 
Regards
Lukasz

