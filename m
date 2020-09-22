Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1E52748F4
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Sep 2020 21:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgIVTST convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 22 Sep 2020 15:18:19 -0400
Received: from out.roosit.eu ([212.26.193.44]:45594 "EHLO out.roosit.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgIVTSS (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 22 Sep 2020 15:18:18 -0400
Received: from sx.f1-outsourcing.eu (host-213.189.39.136.telnetsolutions.pl [213.189.39.136])
        by out.roosit.eu (8.14.7/8.14.7) with ESMTP id 08MJHt0D117025
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 22 Sep 2020 21:17:56 +0200
Received: from sx.f1-outsourcing.eu (localhost.localdomain [127.0.0.1])
        by sx.f1-outsourcing.eu (8.13.8/8.13.8) with ESMTP id 08MJHsdF030051;
        Tue, 22 Sep 2020 21:17:54 +0200
Date:   Tue, 22 Sep 2020 21:17:54 +0200
From:   "Marc Roos" <M.Roos@f1-outsourcing.eu>
To:     response <response@ifastnet.com>, tri <tri@postix.net>
cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>,
        "icepic.dz" <icepic.dz@gmail.com>
Message-ID: <"H00000710017cef1.1600802274.sx.f1-outsourcing.eu*"@MHS>
Subject: RE: [ceph-users] Re: Understanding what ceph-volume does, with bootstrap-osd/ceph.keyring, tmpfs
x-scalix-Hops: 1
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

 
At least ceph thought you the essence of doing first proper testing ;) 
Because if you test your use case you either get a positive or negative 
result and not a problem. 
However I do have to admit that ceph could be more transparent with 
publishing testing and performance results. I have already discussed 
this with them on such a ceph day. It does not make sense to have to do 
everything yourself eg the luks overhead and putting the db/wal on ssd, 
rbd performance on hdds etc. Those can quickly show if ceph can be a 
candidate or not.


-----Original Message-----
From: Kevin Myers [mailto:response@ifastnet.com] 
Cc: Janne Johansson; Marc Roos; ceph-devel; ceph-users
Subject: Re: [ceph-users] Re: Understanding what ceph-volume does, with 
bootstrap-osd/ceph.keyring, tmpfs

Tbh ceph caused us more problems than it tried to fix ymmv good luck


> On 22 Sep 2020, at 13:04, tri@postix.net wrote:
> 
> ﻿The key is stored in the ceph cluster config db. It can be retrieved 

> by
> 
> KEY=`/usr/bin/ceph --cluster ceph --name 
> client.osd-lockbox.${OSD_FSID} --keyring $OSD_PATH/lockbox.keyring 
> config-key get dm-crypt/osd/$OSD_FSID/luks`
> 
> September 22, 2020 2:25 AM, "Janne Johansson" <icepic.dz@gmail.com> 
wrote:
> 
>> Den mån 21 sep. 2020 kl 16:15 skrev Marc Roos 
<M.Roos@f1-outsourcing.eu>:
>> 
>>> When I create a new encrypted osd with ceph volume[1]
>>> 
>>> Q4: Where is this luks passphrase stored?
>> 
>> I think the OSD asks the mon for it after auth:ing, so "in the mon 
DBs"
>> somewhere.
>> 
>> --
>> May the most significant bit of your life be positive.
>> _______________________________________________
>> ceph-users mailing list -- ceph-users@ceph.io To unsubscribe send an 
>> email to ceph-users-leave@ceph.io
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io To unsubscribe send an 
> email to ceph-users-leave@ceph.io



