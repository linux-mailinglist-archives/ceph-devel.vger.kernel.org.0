Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DDD2BBDF
	for <lists+ceph-devel@lfdr.de>; Mon, 27 May 2019 23:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfE0V4c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 27 May 2019 17:56:32 -0400
Received: from mx-out.tlen.pl ([193.222.135.158]:51823 "EHLO mx-out.tlen.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfE0V4c (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 May 2019 17:56:32 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2019 17:56:29 EDT
Received: (wp-smtpd smtp.tlen.pl 40698 invoked from network); 27 May 2019 23:49:48 +0200
Received: from 87-207-64-23.dynamic.chello.pl (HELO [10.0.2.15]) (skidoo@o2.pl@[87.207.64.23])
          (envelope-sender <skidoo@tlen.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-SHA encrypted SMTP
          for <ceph-devel@vger.kernel.org>; 27 May 2019 23:49:48 +0200
Date:   Mon, 27 May 2019 23:49:47 +0200
From:   Luk <skidoo@tlen.pl>
Reply-To: =?iso-8859-2?Q?=A3ukasz_Chrustek?= <skidoo@tlen.pl>
Message-ID: <813822170.20190527234947@tlen.pl>
To:     ceph-devel@vger.kernel.org
Subject: Problem with adding new OSDs on new storage nodes
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-WP-MailID: 30c89ffacb922bf4a04508fc637377fb
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000A [gVPU]                               
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

We have six storage nodes, and added three new only-SSD storage.nodes.
I started increasing weight to fill in freshly added OSD on new osd storage nodes, the command was:
ceph osd crush reweight osd.126 0.2
cluster started rebalance:
2019-05-22 11:00:00.000253 mon.ceph-mon-01 mon.0 10.10.8.221:6789/0 4607699 : cluster [INF] overall HEALTH_OK
2019-05-22 12:00:00.000175 mon.ceph-mon-01 mon.0 10.10.8.221:6789/0 4608927 : cluster [INF] overall HEALTH_OK
2019-05-22 13:00:00.000216 mon.ceph-mon-01 mon.0 10.10.8.221:6789/0 4610174 : cluster [INF] overall HEALTH_OK
2019-05-22 13:44:57.353665 mon.ceph-mon-01 mon.0 10.10.8.221:6789/0 4611095 : cluster [WRN] Health check failed: Reduced data availability: 2 pgs peering (PG_AVAILABILITY)
2019-05-22 13:44:58.642328 mon.ceph-mon-01 mon.0 10.10.8.221:6789/0 4611097 : cluster [WRN] Health check failed: 68628/33693246 objects misplaced (0.204%) (OBJECT_MISPLACED)
2019-05-22 13:45:02.696121 mon.ceph-mon-01 mon.0 10.10.8.221:6789/0 4611098 : cluster [INF] Health check cleared: PG_AVAILABILITY (was: Reduced data availability: 5 pgs peering)
2019-05-22 13:45:04.733172 mon.ceph-mon-01 mon.0 10.10.8.221:6789/0 4611099 : cluster [WRN] Health check update: 694611/33693423 objects misplaced (2.062%) (OBJECT_MISPLACED)


By my knowledge, it should fill up about 200GB on osd.126 and stop rebalancing, but in this case disk on ssdstor-a01 was filled over 85% and filling this disk/osd didn't stopped:
[root@ssdstor-a01 ~]# df -h | grep ceph
/dev/sdc1              1.8T  1.6T  237G  88% /var/lib/ceph/osd/ceph-126
/dev/sdd1              1.8T  136G  1.7T   8% /var/lib/ceph/osd/ceph-127
/dev/sde1              1.8T   99G  1.8T   6% /var/lib/ceph/osd/ceph-128
/dev/sdf1              1.8T  121G  1.7T   7% /var/lib/ceph/osd/ceph-129
/dev/sdg1              1.8T   98G  1.8T   6% /var/lib/ceph/osd/ceph-130
/dev/sdh1              1.8T   38G  1.8T   3% /var/lib/ceph/osd/ceph-131
then I changed waight back to 0.1, but cluster seemed to behaved unstable, so I changed on other new osds weight to 0.1 (to spreed load and available disk space among new disks).
then the situation on other osds repeated:
weight for osds 132-137:
-55         0.59995         host ssdstor-b01
 132   ssd   0.09999             osd.132           up  1.00000 1.00000
 133   ssd   0.09999             osd.133           up  1.00000 1.00000
 134   ssd   0.09999             osd.134           up  1.00000 1.00000
 135   ssd   0.09999             osd.135           up  1.00000 1.00000
 136   ssd   0.09999             osd.136           up  1.00000 1.00000
 137   ssd   0.09999             osd.137           up  1.00000 1.00000

and on physical server:
root@ssdstor-b01:~# df -h | grep ceph

/dev/sdc1              1.8T  642G  1.2T  35% /var/lib/ceph/osd/ceph-132
/dev/sdd1              1.8T  342G  1.5T  19% /var/lib/ceph/osd/ceph-133
/dev/sde1              1.8T  285G  1.6T  16% /var/lib/ceph/osd/ceph-134
/dev/sdf1              1.8T  114G  1.7T   7% /var/lib/ceph/osd/ceph-135
/dev/sdg1              1.8T  215G  1.6T  12% /var/lib/ceph/osd/ceph-136
/dev/sdh1              1.8T  101G  1.8T   6% /var/lib/ceph/osd/ceph-137

I was changing weight for osds all evening and at night, and at the end I found the weights, which stabilized replication:
  -54         0.11993         host ssdstor-a01                          
 126   ssd   0.01999             osd.126           up  1.00000 1.00000 
 127   ssd   0.01999             osd.127           up  0.96999 1.00000 
 128   ssd   0.01999             osd.128           up  1.00000 1.00000 
 129   ssd   0.01999             osd.129           up  1.00000 1.00000 
 130   ssd   0.01999             osd.130           up  1.00000 1.00000 
 131   ssd   0.01999             osd.131           up  1.00000 1.00000 
--
 -55         0.26993         host ssdstor-b01                          
 132   ssd   0.01999             osd.132           up  1.00000 1.00000 
 133   ssd   0.04999             osd.133           up  1.00000 1.00000 
 134   ssd   0.04999             osd.134           up  1.00000 1.00000 
 135   ssd   0.04999             osd.135           up  1.00000 1.00000 
 136   ssd   0.04999             osd.136           up  1.00000 1.00000 
 137   ssd   0.04999             osd.137           up  1.00000 1.00000 
--
 -56         0.29993         host ssdstor-c01                          
 138   ssd   0.04999             osd.138           up  1.00000 1.00000 
 139   ssd   0.04999             osd.139           up  1.00000 1.00000 
 140   ssd   0.04999             osd.140           up  1.00000 1.00000 
 141   ssd   0.04999             osd.141           up  1.00000 1.00000 
 142   ssd   0.04999             osd.142           up  1.00000 1.00000 
 143   ssd   0.04999             osd.143           up  1.00000 1.00000 
I also changed reweight on osd.127, to spread data among osds on the same storage node
ceph osd reweight osd.127 0.97 - as You can see in above output.

Version of ceph:

# ceph versions
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

Qustion  is:  is  there  some  problem/bug  with  balancing in crush or I miss some
setting ?

-- 
Regards,
 Lukasz

