Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD0F5ED1D0
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Sep 2022 02:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbiI1AWo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Sep 2022 20:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiI1AWN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Sep 2022 20:22:13 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 894B510D67B
        for <ceph-devel@vger.kernel.org>; Tue, 27 Sep 2022 17:22:05 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id C8C9B61327;
        Wed, 28 Sep 2022 10:22:03 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id c9FqSwpmudd0; Wed, 28 Sep 2022 10:22:03 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 60D1C612BC;
        Wed, 28 Sep 2022 10:22:03 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 04D1F6803CB; Wed, 28 Sep 2022 10:22:02 +1000 (AEST)
Date:   Wed, 28 Sep 2022 10:22:02 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Adam King <adking@redhat.com>,
        Guillaume Abrioux <gabrioux@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: Re: rbd unmap fails with "Device or resource busy"
Message-ID: <20220928002202.GA2357386@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP9jCHppG7irvLzQgwBSzhrfgc_ak1t2wc=uTOREHVBROA@mail.gmail.com>
 <CAOi1vP8Zfix48tM1ifAgQo1xK+HGC1Sh8mh+Bc=a7Bbv1QENxA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,

On Fri, Sep 23, 2022 at 11:47:11AM +0200, Ilya Dryomov wrote:
> On Fri, Sep 23, 2022 at 5:58 AM Chris Dunlop <chris@onthe.net.au> wrote:
>> On Wed, Sep 21, 2022 at 12:40:54PM +0200, Ilya Dryomov wrote:
>>> On Wed, Sep 21, 2022 at 3:36 AM Chris Dunlop <chris@onthe.net.au> wrote:
>>>> On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
>>>>> What can make a "rbd unmap" fail, assuming the device is not 
>>>>> mounted and not (obviously) open by any other processes?
>>
>> OK, I'm confident I now understand the cause of this problem. The 
>> particular machine where I'm mounting the rbd snapshots is also 
>> running some containerised ceph services. The ceph containers are 
>> (bind-)mounting the entire host filesystem hierarchy on startup, and 
>> if a ceph container happens to start up whilst a rbd device is 
>> mounted, the container also has the rbd mounted, preventing the host 
>> from unmapping the device even after the host has unmounted it. (More 
>> below.)
>>
>> This brings up a couple of issues...
>>
>> Why is the ceph container getting access to the entire host 
>> filesystem in the first place?
>>
>> Even if I mount an rbd device with the "unbindable" mount option, 
>> which is specifically supposed to prevent bind mounts to that 
>> filesystem, the ceph containers still get the mount - how / why??
>>
>> If the ceph containers really do need access to the entire host 
>> filesystem, perhaps it would be better to do a "slave" mount, so 
>> if/when the hosts unmounts a filesystem it's also unmounted in the 
>> container[s].  (Of course this also means any filesystems newly 
>> mounted in the host would also appear in the containers - but that 
>> happens anyway if the container is newly started).
>
> Thanks for the great analysis!  I think ceph-volume container does it 
> because of [1].  I'm not sure about "cephadm shell".  There is also
> node-exporter container that needs access to the host for gathering 
> metrics.
>
> [1] https://tracker.ceph.com/issues/52926

I'm guessing ceph-volume may need to see the host mounts so it can 
detect a disk is being used. Could this also be done in the host (like 
issue 52926 says is being done with pv/vg/lv commands), removing the 
need to have the entire host filesystem hierarchy available in the 
container?

Similarly, I would have thought the node-exporter container only needs 
access to ceph-specific files/directories rather than the whole system.

On Tue, Sep 27, 2022 at 12:55:37PM +0200, Ilya Dryomov wrote:
> On Fri, Sep 23, 2022 at 3:06 PM Guillaume Abrioux <gabrioux@redhat.com> wrote:
>> On Fri, 23 Sept 2022 at 05:59, Chris Dunlop <chris@onthe.net.au> wrote:
>>> If the ceph containers really do need access to the entire host 
>>> filesystem, perhaps it would be better to do a "slave" mount,
>>
>> Yes, I think a mount with 'slave' propagation should fix your issue.  
>> I plan to do some tests next week and work on a patch.

Thanks Guillaume.

> I wanted to share an observation that there seem to be two cases here: 
> actual containers (e.g. an OSD container) and cephadm shell which is 
> technically also a container but may be regarded by users as a shell 
> ("window") with some binaries and configuration files injected into 
> it.

For my part I don't see or use a cephadm shell as a normal shell with 
additional stuff injected. At the very least the host root filesystem 
location has changed to /rootfs so it's obviously not a standard shell.

In fact I was quite surprised that the rootfs and all the other mounts 
unrelated to ceph were available at all. I'm still not convinced it's a 
good idea.

In my conception a cephadm shell is a mini virtual machine specifically 
for inspecting and managing ceph specific areas *only*.

I guess it's really a difference of philosophy. I only use cephadm shell 
when I'm explicitly needing to so something with ceph, and I drop back 
out of the cephadm shell (and it's associated privleges!) as soon as I'm 
done with that specific task. For everything else I'll be in my 
(non-privileged) host shell. I can imagine (although I must say I'd be 
surprised), that others may use the cephadm shell as a matter of course, 
for managing the whole machine? Then again, given issue 52926 quoted 
above, it sounds like that would be a bad idea if, for instance, the lvm 
commands should NOT be run the container "in order to avoid lvm metadata 
corruption" - i.e. it's not safe to assume a cephadm shell is a normal 
shell.

I would argue the goal should be to remove access to the general host 
filesystem(s) from the ceph containers altogether where possible.

I'll also admit that, generally, it's probably a bad idea to be doing 
things unrelated to ceph on a box hosting ceph. But that's the way this 
particular system has grown and unfortunately it will take quite a bit 
of time, effort, and expense to change this now.

> For the former, a unidirectional propagation such that when something 
> is unmounted on the host it is also unmounted in the container is all 
> that is needed.  However, for the latter, a bidirectional propagation 
> such that when something is mounted in this shell it is also mounted 
> on the host (and therefore in all other windows) seems desirable.
>
> What do you think about going with MS_SLAVE for the former and 
> MS_SHARED for the latter?

Personally I would find it surprising and unexpected (i.e. potentially a 
source of trouble) for mount changes done in a container (including a 
"shell" container) to affect the host. But again, that may be that 
difference of philosophy regarding the cephadm shell mentioned above.

Chris
