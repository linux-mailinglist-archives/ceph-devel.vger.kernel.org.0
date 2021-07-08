Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3423BFAAA
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 14:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhGHMw5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Thu, 8 Jul 2021 08:52:57 -0400
Received: from out.roosit.eu ([212.26.193.44]:47916 "EHLO out.roosit.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhGHMw4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 8 Jul 2021 08:52:56 -0400
X-Greylist: delayed 2101 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2021 08:52:55 EDT
Received: from mail01.MAIL.local (mail01.local [192.168.10.41])
        by out.roosit.eu (8.14.7/8.14.7) with ESMTP id 168CF6k8024094
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 8 Jul 2021 14:15:07 +0200
Received: from mail01.MAIL.local (192.168.10.41) by mail01.MAIL.local
 (192.168.10.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 8 Jul 2021
 14:14:54 +0200
Received: from mail01.MAIL.local ([fe80::30f7:1325:5161:6849]) by
 mail01.MAIL.local ([fe80::30f7:1325:5161:6849%6]) with mapi id
 15.01.2044.013; Thu, 8 Jul 2021 14:14:47 +0200
From:   Marc <Marc@f1-outsourcing.eu>
To:     M Ranga Swami Reddy <swamireddy@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.com>
Subject: RE: [ceph-users] Fwd: ceph upgrade from luminous to nautils
Thread-Topic: [ceph-users] Fwd: ceph upgrade from luminous to nautils
Thread-Index: AQHXc97K2bD62MBJiUSgPXOPxg1Wy6s4/IyA
Date:   Thu, 8 Jul 2021 12:14:47 +0000
Message-ID: <eae23af21f1c4160a3d9a31e16fc806d@f1-outsourcing.eu>
References: <CANA9Uk525eNiPwRwj5z9mAmUcGHsZugC1MFOFAQxKR9_VFV0FA@mail.gmail.com>
 <CANA9Uk6h6zVU8GTFyG1-pK27+J-9GAuKMq6wqo4=ySFeG9j9-w@mail.gmail.com>
In-Reply-To: <CANA9Uk6h6zVU8GTFyG1-pK27+J-9GAuKMq6wqo4=ySFeG9j9-w@mail.gmail.com>
Accept-Language: en-001, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.10.233]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I did the same upgrade from Luminous to Nautilus, and still have osd's created with ceph-disk. I am slowly migrating to lvm and encryption.

However I did have some issues with osd's not starting, you have to check run levels and make sure the symlinks are still correct. I also had something that I had to change ownership /dev/sdX before it would start. 

I still have this in my rc.local

chown ceph.ceph /dev/sdb2
chown ceph.ceph /dev/sdc2
chown ceph.ceph /dev/sdd2
chown ceph.ceph /dev/sde2
chown ceph.ceph /dev/sdf2
chown ceph.ceph /dev/sdg2
chown ceph.ceph /dev/sdh2
chown ceph.ceph /dev/sdi2
chown ceph.ceph /dev/sdj2
chown ceph.ceph /dev/sdk2


> -----Original Message-----
> From: M Ranga Swami Reddy <swamireddy@gmail.com>
> Sent: Thursday, 8 July 2021 11:49
> To: ceph-devel <ceph-devel@vger.kernel.org>; ceph-users <ceph-
> users@ceph.com>
> Subject: [ceph-users] Fwd: ceph upgrade from luminous to nautils
> 
> ---------- Forwarded message ---------
> From: M Ranga Swami Reddy <swamireddy@gmail.com>
> Date: Thu, Jul 8, 2021 at 2:30 PM
> Subject: ceph upgrade from luminous to nautils
> To: ceph-devel <ceph-devel@vger.kernel.org>
> 
> 
> Dear All,
> I am using the Ceph with Luminous version with 2000+ OSDs.
> Planning to upgrade the ceph from Luminous to Nautils.
> Currently, all OSDs deployed via ceph-disk.
> Can I proceed with this upgrade?
> is the ceph-disk OSDs will work with ceph-volumes (as ceph-disk
> deprecated
> in memic release)
> 
> Please advise.
> 
> Thanks
> Swami
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io
