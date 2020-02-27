Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26EF17188B
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2020 14:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgB0NTv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Feb 2020 08:19:51 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729088AbgB0NTu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 08:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582809588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q6kfrKIiBfsEpcILpJLblnD+aI+WssrkgNvCgsmki2U=;
        b=Cr7dUq+p6HIP/POn9O/25SjmfNCO5quOY1oxtPQslBHwdo1Pn8ocRuuc8/Vt6/eeb8HvH4
        fu+fxhf5vMGPkYNUjZGEU7u+ClefYEdKpcZ+9q1fXso/U7qfPTg7kQ2bYY6iIliHzCcAgL
        oTJ9HkEKwgscQWDEya1Anob9ZHBdh28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-rt9hJpm8OE2ZL4f_9tTsYA-1; Thu, 27 Feb 2020 08:19:46 -0500
X-MC-Unique: rt9hJpm8OE2ZL4f_9tTsYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3F8F477;
        Thu, 27 Feb 2020 13:19:44 +0000 (UTC)
Received: from [10.72.13.181] (ovpn-13-181.pek2.redhat.com [10.72.13.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0355019C58;
        Thu, 27 Feb 2020 13:19:36 +0000 (UTC)
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200216064945.61726-1-xiubli@redhat.com>
 <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
 <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com>
 <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
 <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com>
 <CA+2bHPZmjvbtFBNzviR6uYsM=bF92qC-Xkgm2uucBe6KJHjJbg@mail.gmail.com>
 <CAOi1vP9GEt89=RWbwPJ+X172DJL7=R49iBxWfOerARch-VYJDg@mail.gmail.com>
 <cdc79a1163b506813b1adfdc8b2387f9bb9c0609.camel@kernel.org>
 <CA+2bHPb=9Z0nM_innY2bkcuCiKG9BVevonzxktWgzLPe=K8y1w@mail.gmail.com>
 <83d4aa168fbc9e0c2e1d7b1337e5ecd74d1a0fae.camel@kernel.org>
 <CAOi1vP_rf7e_6NHM3=YaukaLfRs=niTb0EdKGaxGnhtooEWV+A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <bfee5f56-d348-62e5-b403-82a315037f6e@redhat.com>
Date:   Thu, 27 Feb 2020 21:19:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_rf7e_6NHM3=YaukaLfRs=niTb0EdKGaxGnhtooEWV+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/20 11:43, Ilya Dryomov wrote:
> On Thu, Feb 20, 2020 at 12:49 AM Jeff Layton <jlayton@kernel.org> wrote:
>> On Wed, 2020-02-19 at 14:49 -0800, Patrick Donnelly wrote:
>>> Responding to you and Ilya both:
>>>
>>> On Wed, Feb 19, 2020 at 1:21 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>> On Wed, 2020-02-19 at 21:42 +0100, Ilya Dryomov wrote:
>>>>> On Wed, Feb 19, 2020 at 8:22 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
>>>>>> On Tue, Feb 18, 2020 at 6:59 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>>>>>>>> Yeah, I've mostly done this using DROP rules when I needed to test things.
>>>>>>>> But, I think I was probably just guilty of speculating out loud here.
>>>>>>> I'm not sure what exactly Xiubo meant by "fulfilling" iptables rules
>>>>>>> in libceph, but I will say that any kind of iptables manipulation from
>>>>>>> within libceph is probably out of the question.
>>>>>> I think we're getting confused about two thoughts on iptables: (1) to
>>>>>> use iptables to effectively partition the mount instead of this new
>>>>>> halt option; (2) use iptables in concert with halt to prevent FIN
>>>>>> packets from being sent when the sockets are closed. I think we all
>>>>>> agree (2) is not going to happen.
>>>>> Right.
>>>>>
>>>>>>>> I think doing this by just closing down the sockets is probably fine. I
>>>>>>>> wouldn't pursue anything relating to to iptables here, unless we have
>>>>>>>> some larger reason to go that route.
>>>>>>> IMO investing into a set of iptables and tc helpers for teuthology
>>>>>>> makes a _lot_ of sense.  It isn't exactly the same as a cable pull,
>>>>>>> but it's probably the next best thing.  First, it will be external to
>>>>>>> the system under test.  Second, it can be made selective -- you can
>>>>>>> cut a single session or all of them, simulate packet loss and latency
>>>>>>> issues, etc.  Third, it can be used for recovery and failover/fencing
>>>>>>> testing -- what happens when these packets get delivered two minutes
>>>>>>> later?  None of this is possible with something that just attempts to
>>>>>>> wedge the mount and acts as a point of no return.
>>>>>> This sounds attractive but it does require each mount to have its own
>>>>>> IP address? Or are there options? Maybe the kernel driver could mark
>>>>>> the connection with a mount ID we could do filtering on it? From a
>>>>>> quick Google, maybe [1] could be used for this purpose. I wonder
>>>>>> however if the kernel driver would have to do that marking of the
>>>>>> connection... and then we have iptables dependencies in the driver
>>>>>> again which we don't want to do.
>>>>> As I said yesterday, I think it should be doable with no kernel
>>>>> changes -- either with IP aliases or with the help of some virtual
>>>>> interface.  Exactly how, I'm not sure because I use VMs for my tests
>>>>> and haven't had to touch iptables in a while, but I would be surprised
>>>>> to learn otherwise given the myriad of options out there.
>>>>>
>>>> ...and really, doing this sort of testing with the kernel client outside
>>>> of a vm is sort of a mess anyway, IMO.
>>> Testing often involves making a mess :) I disagree in principle that
>>> having a mechanism for stopping a netfs mount without pulling the plug
>>> (virtually or otherwise) is unnecessary.
>>>
>> Ok, here are some more concerns:
>>
>> I'm not clear on what value this new mount option really adds. Once you
>> do this, the client is hosed, so this is really only useful for testing
>> the MDS. If your goal is to test the MDS with dying clients, then why
>> not use a synthetic userland client to take state and do whatever you
>> want?
>>
>> It could be I'm missing some value in using a kclient for this. If you
>> did want to do this after all, then why are you keeping the mount around
>> at all? It's useless after the remount, so you might as well just umount
>> it.
>>
>> If you really want to make it just shut down the sockets, then you could
>> add a new flag to umount2/sys_umount (UMOUNT_KILL or something) that
>> would kill off the mount w/o talking to the MDS. That seems like a much
>> cleaner interface than doing this.
>>
>>>> That said, I think we might need a way to match up a superblock with the
>>>> sockets associated with it -- so mon, osd and mds socket info,
>>>> basically. That could be a very simple thing in debugfs though, in the
>>>> existing directory hierarchy there. With that info, you could reasonably
>>>> do something with iptables like we're suggesting.
>>> That's certainly useful information to expose but I don't see how that
>>> would help with constructing iptable rules. The kernel may reconnect
>>> to any Ceph service at any time, especially during potential network
>>> disruption (like an iptables rule dropping packets). Any rules you
>>> construct for those connections would no longer apply. You cannot
>>> construct rules that broadly apply to e.g. the entire ceph cluster as
>>> a destination because it would interfere with other kernel client
>>> mounts. I believe this is why Ilya is suggesting the use of virtual ip
>>> addresses as a unique source address for each mount.
>>>
>> Sorry, braino -- sunrpc clients keep their source ports in most cases
>> (for legacy reasons). I don't think libceph msgr does though. You're
>> right that a debugfs info file won't really help.
>>
>> You could roll some sort of deep packet inspection to discern this but
>> that's more difficult. I wonder if you could do it with BPF these days
>> though...
>>
>>>>>>  From my perspective, this halt patch looks pretty simple and doesn't
>>>>>> appear to be a huge maintenance burden. Is it really so objectionable?
>>>>> Well, this patch is simple only because it isn't even remotely
>>>>> equivalent to a cable pull.  I mean, it aborts in-flight requests
>>>>> with EIO, closes sockets, etc.  Has it been tested against the test
>>>>> cases that currently cold reset the node through the BMC?
>>> Of course not, this is the initial work soliciting feedback on the concept.
>>>
>> Yep. Don't get discouraged, I think we can do something to better
>> accommodate testing, but I don't think this is the correct direction for
>> it.
>>
>>>>> If it has been tested and the current semantics are sufficient,
>>>>> are you sure they will remain so in the future?  What happens when
>>>>> a new test gets added that needs a harder shutdown?  We won't be
>>>>> able to reuse existing "umount -f" infrastructure anymore...  What
>>>>> if a new test needs to _actually_ kill the client?
>>>>>
>>>>> And then a debugging knob that permanently wedges the client sure
>>>>> can't be a mount option for all the obvious reasons.  This bit is easy
>>>>> to fix, but the fact that it is submitted as a mount option makes me
>>>>> suspect that the whole thing hasn't been thought through very well.
>>> Or, Xiubo needs advice on a better way to do it. In the tracker ticket
>>> I suggested a sysfs control file. Would that be appropriate?
>>>
>> I'm not a fan of adding fault injection code to the client. I'd prefer
>> doing this via some other mechanism. If you really do want something
>> like this in the kernel, then you may want to consider something like
>> BPF.
>>
>>>> Agreed on all points. This sort of fault injection is really best done
>>>> via other means. Otherwise, it's really hard to know whether it'll
>>>> behave the way you expect in other situations.
>>>>
>>>> I'll add too that I think experience shows that these sorts of
>>>> interfaces end up bitrotted because they're too specialized to use
>>>> outside of anything but very specific environments. We need to think
>>>> larger than just teuthology's needs here.
>>> I doubt they'd become bitrotted with regular use in teuthology.
>>>
>> Well, certainly some uses of them might not, but interfaces like this
>> need to be generically useful across a range of environments. I'm not
>> terribly interested in plumbing something in that is _only_ used for
>> teuthology, even as important as that use-case is.
>>
>>> I get that you both see VMs or virtual interfaces would obviate this
>>> PR. VMs are not an option in teuthology. We can try to spend some time
>>> on seeing if something like a bridged virtual network will work. Will
>>> the kernel driver operate in the network namespace of the container
>>> that mounts the volume?
>>>
>> That, I'm not sure about. I'm not sure if the sockets end up inheriting
>> the net namespace of the mounting process. It'd be good to investigate
>> this. You may be able to just get crafty with the unshare command to
>> test it out.
> It will -- I added that several years ago when docker started gaining
> popularity.
>
> This is why I keep mentioning virtual interfaces.  One thing that
> will most likely work without any hiccups is a veth pair with one
> interface in the namespace and one in the host plus a simple iptables
> masquerading rule to NAT between the veth network and the world.
> For cutting all sessions, you won't even need to touch iptables any
> further: just down either end of the veth pair.
>
> Doing it from the container would obviously work too, but further
> iptables manipulation might be trickier because of more parts involved:
> additional interfaces, bridge, iptables rules installed by the
> container runtime, etc.

Hi Ilya, Jeff, Patrick

Thanks for your advice and great idea of this.

I started it with ceph-fuse, and the patch is ready, please see 
https://github.com/ceph/ceph/pull/33576.

Thanks
BRs
Xiubo


> Thanks,
>
>                  Ilya
>

