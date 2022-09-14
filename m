Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1535B7FB2
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Sep 2022 05:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiINDtP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Sep 2022 23:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiINDtK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Sep 2022 23:49:10 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3A8B6F562
        for <ceph-devel@vger.kernel.org>; Tue, 13 Sep 2022 20:49:04 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 36C0D613C5;
        Wed, 14 Sep 2022 13:49:03 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id bjS4rqvMlpwD; Wed, 14 Sep 2022 13:49:03 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 0EB3760F6F;
        Wed, 14 Sep 2022 13:49:03 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id E96006803C7; Wed, 14 Sep 2022 13:49:02 +1000 (AEST)
Date:   Wed, 14 Sep 2022 13:49:02 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: rbd unmap fails with "Device or resource busy"
Message-ID: <20220914034902.GA691415@onthe.net.au>
References: <20220913012043.GA568834@onthe.net.au>
 <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Illya,

On Tue, Sep 13, 2022 at 01:43:16PM +0200, Ilya Dryomov wrote:
> On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
>> What can make a "rbd unmap" fail, assuming the device is not mounted 
>> and not (obviously) open by any other processes?
>>
>> linux-5.15.58
>> ceph-16.2.9
>>
>> I have multiple XFS on rbd filesystems, and often create rbd snapshots, 
>> map and read-only mount the snapshot, perform some work on the fs, then 
>> unmount and unmap. The unmap regularly (about 1 in 10 times) fails 
>> like:
>>
>> $ sudo rbd unmap /dev/rbd29
>> rbd: sysfs write failed
>> rbd: unmap failed: (16) Device or resource busy
>>
>> I've double checked the device is no longer mounted, and, using "lsof" 
>> etc., nothing has the device open.
>
> One thing that "lsof" is oblivious to is multipath, see
> https://tracker.ceph.com/issues/12763.

The server is not using multipath - e.g. there's no multipathd, and:

$ find /dev/mapper/ -name '*mpath*'

...finds nothing.

>> I've found that waiting "a while", e.g. 5-30 minutes, will usually 
>> allow the "busy" device to be unmapped without the -f flag.
>
> "Device or resource busy" error from "rbd unmap" clearly indicates
> that the block device is still open by something.  In this case -- you
> are mounting a block-level snapshot of an XFS filesystem whose "HEAD"
> is already mounted -- perhaps it could be some background XFS worker
> thread?  I'm not sure if "nouuid" mount option solves all issues there.

Good suggestion, I should have considered that first. I've now tried it 
without the mount at all, i.e. with no XFS or other filesystem:

------------------------------------------------------------------------------
#!/bin/bash
set -e
rbdname=pool/name
for ((i=0; ++i<=50; )); do
   dev=$(rbd map "${rbdname}")
   ts "${i}: ${dev}"
   dd if="${dev}" of=/dev/null bs=1G count=1
   for ((j=0; ++j; )); do
     rbd unmap "${dev}" && break
     sleep 1m
   done
   (( j > 1 )) && echo "$j minutes to unmap"
done
------------------------------------------------------------------------------

This failed at about the same rate, i.e. around 1 in 10. This time it only 
took 2 minutes each time to successfully unmap after the initial unmap 
failed - I'm not sure if this is due to the test change (no mount), or 
related to how busy the machine is otherwise.

The upshot is, it definitely looks like there's something related to the 
underlying rbd that's preventing the unmap.

> Have you encountered this error in other scenarios, i.e. without
> mounting snapshots this way or with ext4 instead of XFS?

I've seen the same issue after unmounting r/w filesystems, but I don't do 
that nearly as often so it hasn't been a pain point. However, per the test 
above, the issue is unrelated to the mount.

Cheers,

Chris
