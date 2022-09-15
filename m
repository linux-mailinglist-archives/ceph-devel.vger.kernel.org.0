Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95155B965B
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Sep 2022 10:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIOI3Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Sep 2022 04:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiIOI3Z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Sep 2022 04:29:25 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 936E895E56
        for <ceph-devel@vger.kernel.org>; Thu, 15 Sep 2022 01:29:22 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 6DC8F612EC;
        Thu, 15 Sep 2022 18:29:20 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id WRtXWib_Ckvi; Thu, 15 Sep 2022 18:29:20 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 2F00A61287;
        Thu, 15 Sep 2022 18:29:20 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 143206803C9; Thu, 15 Sep 2022 18:29:20 +1000 (AEST)
Date:   Thu, 15 Sep 2022 18:29:20 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: rbd unmap fails with "Device or resource busy"
Message-ID: <20220915082920.GA881573@onthe.net.au>
References: <20220913012043.GA568834@onthe.net.au>
 <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
 <20220914034902.GA691415@onthe.net.au>
 <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 14, 2022 at 10:41:05AM +0200, Ilya Dryomov wrote:
> On Wed, Sep 14, 2022 at 5:49 AM Chris Dunlop <chris@onthe.net.au> wrote:
>> On Tue, Sep 13, 2022 at 01:43:16PM +0200, Ilya Dryomov wrote:
>>> On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
>>>> What can make a "rbd unmap" fail, assuming the device is not mounted
>>>> and not (obviously) open by any other processes?
>>>>
>>>> linux-5.15.58
>>>> ceph-16.2.9
>>>>
>>>> I have multiple XFS on rbd filesystems, and often create rbd snapshots,
>>>> map and read-only mount the snapshot, perform some work on the fs, then
>>>> unmount and unmap. The unmap regularly (about 1 in 10 times) fails
>>>> like:
>>>>
>>>> $ sudo rbd unmap /dev/rbd29
>>>> rbd: sysfs write failed
>>>> rbd: unmap failed: (16) Device or resource busy

tl;dr problem solved: there WAS a process holding the rbd device open.

The culprit was a 'pvs' command being run periodically by 'ceph-volume'. 
When the 'rbd unmap' was tried run at the same time the 'pvs' command 
was running, the unmap would fail.

It turns out the 'dd' command in my test script was only instrumental in 
as much as it made the test run long enough that it would intersect with 
the periodic 'pvs'. I had been thinking the 'dd' was causing the rbd 
data to be buffered in the kernel and perhaps the buffered which would 
sometimes not be cleared immediately, causing the rbd unmap to fail.

The conflicting 'pvs' command was a bit tricky to catch because it was 
only running for a very short time, so the 'pvs' would be gone by the 
time I'd run 'lsof'. The key to finding the prolem was to look through 
the processes as quickly as possible upon an unmap failure, e.g.:

----------------------------------------------------------------------
if ! rbd device unmap "${dev}"; then
   while read -r p; do
     p=${p#/proc/}; p=${p%%/*}
     (( p == prevp )) && continue
     prevp=$p

     printf '%(%F %T)T %d\t%s\n' -1 "${p}" "$(tr '\0' ' ' < /proc/${p}/cmdline)"

     pp=$(awk '$1=="PPid:"{print $2}' /proc/${p}/status)
     printf '+ %d\t%s\n' "${pp}" "$(tr '\0' ' ' < /proc/${pp}/cmdline)"

     ppp=$(awk '$1=="PPid:"{print $2}' /proc/${pp}/status)
     printf '+ %d\t%s\n' "${ppp}" "$(tr '\0' ' ' < /proc/${ppp}/cmdline)"
   done < <(
     find /proc/[0-9]*/fd -lname "${dev}" 2> /dev/null
   )
fi
----------------------------------------------------------------------

Note that 'pvs' normally does NOT scan rbd devices: you have to 
explicitly add "rbd" to the lvm.conf element for "List of additional 
acceptable block device types", e.g.:

/etc/lvm/lvm.conf
--
devices {
         types = [ "rbd", 1024 ]
}
--

I'd previously enabled the rbd scanning when testing some lvm-on-rbd 
stuff.

After removing rbd from the lvm.conf I was able to run through my unmap 
test 150 times without a single unmap failure.

>> ---------------------------------------------------------------------
>> #!/bin/bash
>> set -e
>> rbdname=pool/name
>> for ((i=0; ++i<=50; )); do
>>    dev=$(rbd map "${rbdname}")
>>    ts "${i}: ${dev}"
>>    dd if="${dev}" of=/dev/null bs=1G count=1
>>    for ((j=0; ++j; )); do
>>      rbd unmap "${dev}" && break
>>      sleep 1m
>>    done
>>    (( j > 1 )) && echo "$j minutes to unmap"
>> done
>> ---------------------------------------------------------------------
>>
>> This failed at about the same rate, i.e. around 1 in 10. This time it 
>> only took 2 minutes each time to successfully unmap after the initial 
>> unmap failed - I'm not sure if this is due to the test change (no 
>> mount), or related to how busy the machine is otherwise.
>
> I would suggest repeating this test with "sleep 1s" to get a better 
> idea of how long it really takes.

With "sleep 1s" it was generally successful the 2nd time around. I'm a 
bit puzzled at this because I'm certain, before I started scripting this 
test, I was doing many unmap attempts before finally successfully 
unmapping. I was convinced it was a matter of waiting for "something" to 
time out before the device was released, and in the meantime 'lsof' 
wasn't showing anything with the device open. It's implausible I was 
running into the 'pvs' command each of those times so what was actually 
going on there is a bit of a mystery.

> I don't think so.  To confirm, now that there is no filesystem in the
> mix, replace "rbd unmap" with "rbd unmap -o force".  If that fixes the
> issue, RBD is very unlikely to have anything to do with it because all
> "force" does is it overrides the "is this device still open" check
> at the very top of "rbd unmap" handler in the kernel.

I'd already confirmed "-o force" (or --force) would remove the device 
but I was concerned that could possibly cause data corruption if/when 
using a writable rbd so I wanted to get to the bottom of the problem.

> systemd-udevd may open block devices behind your back.  "rbd unmap"
> command actually does a retry internally to work around that:

Huh, interesting.

> Perhaps it is hitting "udevadm settle" timeout on your system?
> "strace -f" might be useful here.

A good suggestion although using 'strace' wasn't necessary in the end.


Thanks for your help!

Chris
