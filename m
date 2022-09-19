Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52E45BC395
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Sep 2022 09:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiISHn1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Sep 2022 03:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiISHnZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Sep 2022 03:43:25 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7442F175BF
        for <ceph-devel@vger.kernel.org>; Mon, 19 Sep 2022 00:43:24 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id CA2F0612FA;
        Mon, 19 Sep 2022 17:43:21 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id kictQAj5dwVI; Mon, 19 Sep 2022 17:43:21 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 95E37612EC;
        Mon, 19 Sep 2022 17:43:21 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 753596803C7; Mon, 19 Sep 2022 17:43:21 +1000 (AEST)
Date:   Mon, 19 Sep 2022 17:43:21 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: rbd unmap fails with "Device or resource busy"
Message-ID: <20220919074321.GA1363634@onthe.net.au>
References: <20220913012043.GA568834@onthe.net.au>
 <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
 <20220914034902.GA691415@onthe.net.au>
 <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
 <20220915082920.GA881573@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220915082920.GA881573@onthe.net.au>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 15, 2022 at 06:29:20PM +1000, Chris Dunlop wrote:
> On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
>> What can make a "rbd unmap" fail, assuming the device is not mounted 
>> and not (obviously) open by any other processes?
>>
>> linux-5.15.58
>> ceph-16.2.9
>>
>> I have multiple XFS on rbd filesystems, and often create rbd 
>> snapshots, map and read-only mount the snapshot, perform some work on 
>> the fs, then unmount and unmap. The unmap regularly (about 1 in 10 
>> times) fails like:
>>
>> $ sudo rbd unmap /dev/rbd29
>> rbd: sysfs write failed
>> rbd: unmap failed: (16) Device or resource busy
>
> tl;dr problem solved: there WAS a process holding the rbd device open.

Sigh. It turns out the problem is NOT solved.

I've stopped 'pvs' from scanning the rbd devices. This was sufficient to 
allow my minimal test script to work without unmap failures, but my full 
production process is still suffering from the unmap failures.

I now have 51 rbd devices which I haven't been able to unmap for the 
last three days (in contrast to my earlier statement where I said I'd 
always been able to unmap eventually, generally after 30 minutes or so).  
That's out of maybe 80-90 mapped rbds over that time.

I've no idea why the unmap failures are so common this time, and why, 
this time, I haven't been able to unmap them in 3 days.

I had been trying an unmap of one specific rbd (randomly selected) every 
second for 3 hours whilst simultaneously, in a tight loop, looking for 
any other processes that have the device open. The unmaps continued to 
fail and I haven't caught any other process with the device open.

I also tried a back-off strategy by linearly increasing a sleep between 
unmap attempts.  By the time the sleep was up to 4 hours I have up, with 
unmaps of that device still failing. Unmap attempts at random times 
since then on that particular device and all the other of the 51 
un-unmappable device continue to fail.

I'm sure I can unmap the devices using '--force' but at this point I'd 
rather try to work out WHY the unmap is failing: it seems to be pointing 
to /something/ going wrong, somewhere. Given no user processes can be 
seen to have the device open, it seems that "something" might be in the 
kernel somewhere.

I'm trying to put together a test using a cut down version of the 
production process to see if I can make the unmap failures happen a 
little more repeatably.

I'm open to suggestions as to what I can look at.

E.g. maybe there's some way of using ebpf or similar to look at the 
'rbd_dev->open_count' in the live kernel?

And/or maybe there's some way, again using ebpf or similar, to record 
sufficient info (e.g. a stack trace?) from rbd_open() and rbd_release() 
to try to identify something that's opening the device and not releasing 
it?

If anyone knows how that could be done that would be great, otherwise 
it's going to take me a bit of time to try to work out how that might be 
done.

Chris
