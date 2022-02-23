Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF5C4C1118
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 12:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236519AbiBWLQv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Feb 2022 06:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238399AbiBWLQu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Feb 2022 06:16:50 -0500
X-Greylist: delayed 326 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Feb 2022 03:16:22 PST
Received: from 1.mo301.mail-out.ovh.net (1.mo301.mail-out.ovh.net [137.74.110.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512348EB74
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 03:16:22 -0800 (PST)
Received: from DAGFR5EX1.OVH.local (unknown [51.255.55.251])
        by mo301.mail-out.ovh.net (Postfix) with ESMTPS id 711888B9A0;
        Wed, 23 Feb 2022 12:10:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ovhcloud.com;
        s=mailout; t=1645614654;
        bh=9Yqa9HlzREnoF9BGIlvexbdc9LXQVtnd7rWIsVTTpVU=;
        h=From:To:Subject:Date:From;
        b=o/jmkxOEA1PHvoZXDZuDLYbDb6hFvASb3J3JdQ9+SIhExA2fJZvXvOiSWljPjVJ9A
         YpXnNHtmVlPqQdOiAACIpo4+usfMJiJ1FZbeVXbK6lCvBEgggliy3FU8qgCI7dm5tx
         G2j1KzVCBq0T3pc5919NZuIA6kX/p34xzNHNTEn8=
Received: from DAGFR5EX1.OVH.local (172.16.2.14) by DAGFR5EX1.OVH.local
 (172.16.2.14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Wed, 23 Feb
 2022 12:10:36 +0100
Received: from DAGFR5EX1.OVH.local ([fe80::5db2:3b17:f01b:563]) by
 DAGFR5EX1.OVH.local ([fe80::5db2:3b17:f01b:563%9]) with mapi id
 15.02.0986.015; Wed, 23 Feb 2022 12:10:36 +0100
From:   Bartosz Rabiega <bartosz.rabiega@ovhcloud.com>
To:     dev <dev@ceph.io>, ceph-devel <ceph-devel@vger.kernel.org>
Subject: Benching ceph for high speed RBD
Thread-Topic: Benching ceph for high speed RBD
Thread-Index: AQHYKKV9OXzrB6o4jEqreqsypK/B7g==
Date:   Wed, 23 Feb 2022 11:10:35 +0000
Message-ID: <d55c21fb8ba54ee1b8b1e60ccc0bb21b@ovhcloud.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [109.190.254.30]
x-ovh-corplimit-skip: true
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Ovh-Tracer-Id: 1602718518934756937
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrledtgddvgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvufhtfffkihgtgfggsehtqhhjtddttdehnecuhfhrohhmpeeurghrthhoshiiucftrggsihgvghgruceosggrrhhtohhsiidrrhgrsghivghgrgesohhvhhgtlhhouhgurdgtohhmqeenucggtffrrghtthgvrhhnpedvtdeuhffhjeduudeftddthfefudeviedvgeelgeejkeevkefgudfhiedtudetvdenucffohhmrghinheptggvphhhrdgtohhmpdhgihhthhhusgdrtghomhenucfkpheptddrtddrtddrtddpuddtledrudeltddrvdehgedrfedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopefftefihffthefgigdurdfqggfjrdhlohgtrghlpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegsrghrthhoshiirdhrrggsihgvghgrsehovhhhtghlohhuugdrtghomhdpnhgspghrtghpthhtohepuddprhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello cephers,

I've recently been doing some intensive performance benchmarks of different=
 ceph versions.
I'm trying to figure out perf numbers which can be achieved for high speed =
ceph setup for RBD (3x replica).
From what I can see there is a significant perf drop on 16.2.x series (4k w=
rites).
I can't find any clear reason for such behavior.

Hardware setup
--------------
3x backend servers
CPU: 2x AMD EPYC 7402 24-Core (48c+48t)
Storage: 24x NVMe
Network: 40gbps
OS: Ubuntu Focal
Kernel: 5.15.0-18-generic

4x client servers
CPU: 2x AMD EPYC 7402 24-Core (48c+48t)
Network: 40gbps
OS: Ubuntu Focal
Kernel: 5.11.0-37-generic

Software config
---------------
72 OSDs in total (24 OSDs per host)
1 OSD per NVMe drive
Each OSD runs in LXD container
Scrub disabled
Deep-scrub disabled
Ceph balancer off
1 pool 'rbd':
- 1024 PG
- PG autoscaler off

Test environment
----------------
- 128 rbd images (default features, size 128GB)
- All the images are fully written before any tests are done! (4194909 obje=
cts allocated)
- client version ceph 16.2.7 vanilla eu.ceph.com
- Each client runs fio with rbd engine (librbd) against 32 rbd images (4x32=
 in total)


Tests
----------------
qd - queue depth (number of IOs issued simultaneously to single RBD image)

IOPS tests
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
- random IO 4k, 4qd
- random IO 4k, 64qd

Write			4k 4qd	4k 64qd
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
14.2.16			69630	132093
14.2.22			97491	156288
15.2.14			77586	93003
*15.2.14 =96 canonical	110424	168943
16.2.0			70526	85827
16.2.2			69897	85231
16.2.4			64713	84046
16.2.5			62099	85053
16.2.6			68394	83070
16.2.7			66974	78601

	=09
Read			4k 4qd	4k 64qd
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
14.2.16			692848	816109
14.2.22			693027	830485
15.2.14			676784	702233
*15.2.14 =96 canonical	749404	792385
16.2.0			610798	636195
16.2.2			606924	637611
16.2.4			611093	630590
16.2.5			603162	632599
16.2.6			603013	627246
16.2.7			-	-

* Very oddly the best perf was achieved with build Ceph 15.2.14 from canoni=
cal 15.2.14-0ubuntu0.20.04.2
14.2.22 performs very well
15.2.14 from canonical is the best in terms of writes.
16.2.x series writes are quite poor comparing to other versions.

BW tests
=3D=3D=3D=3D=3D=3D=3D=3D
- sequential IO 64k, 64qd

These results are mostly the same for all ceph versions.
Writes ~4.2 GB/s
Reads ~12 GB/s

Seems that results here are limited by network bandwitdh.


Questions
---------
Is there any reason for the performance drop in 16.x series?
I'm looking for some help/recommendations to get as much IOPS as possible (=
especially for writes, as reads are good enough)

We've been trying to find out what makes the difference in canonical builds=
. A few leads indicates that
extraopts +=3D -DCMAKE_BUILD_TYPE=3DRelWithDebInfo was not set for builds f=
rom ceph foundation=20
https://github.com/ceph/ceph/blob/master/do_cmake.sh#L86
How to check this, would someone be able to take a look there?

BR
Bartosz Rabiega

