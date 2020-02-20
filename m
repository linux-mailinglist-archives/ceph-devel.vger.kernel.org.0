Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC771655C7
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Feb 2020 04:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgBTDmt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 22:42:49 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40011 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgBTDms (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Feb 2020 22:42:48 -0500
Received: by mail-io1-f67.google.com with SMTP id x1so3085422iop.7
        for <ceph-devel@vger.kernel.org>; Wed, 19 Feb 2020 19:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3hmDa7RSzzxaVnUd+q6lTgjiAlZzNdaAaESJ/ndTcMs=;
        b=L4ar8/bLfxm4SoBHZ3jvKbYOvnn8cSzJSAwSlZhhvrt35w+ryhRsowd0xkNt20s7V8
         6VAkbnlL3PWb0T7ZFsFrrZiqdEeYo+Sa/rryUgDMZrV4eD22tti0ROkQl3/HkigH3tiB
         S6sK+l6OVJ9cdfZqmh4z/GJDizuxleNI+UOBZNL7TeVGoW078udKvBqXIK64vhvfFJax
         rJQf7/Icn8OSYHxgShNVo/BBaKYS8YUzMdV6mnG6eK7jd9ytQFJSUcrf+1ps+01FOua9
         hQyQqtkoT1WDbFlP37+Gz15IjW6Rq3sXtkG8zCM/67xOL16Ud+h07BphhGGVxd9ipFWa
         bJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3hmDa7RSzzxaVnUd+q6lTgjiAlZzNdaAaESJ/ndTcMs=;
        b=lAYcBcgx0QdcNQFXcu7fbGoPwKoFFizX40I/Xipig7bonIFvSTl1Uw3yjvZO9E8/3v
         v+7dFXdnXIhVipzhxPvEtthsCVJzZpdobxCkKtsOillBZTE7hoWwmy+WWKzj9NvtThZZ
         tfgrYWa0oqAng9afAlygFKGH1/dz84TvREvoFv4+Y5NHhjO/U29vAzsZvkuB0hpOrHqG
         LbyuXG+DKpscfUXVZisFVAYnKyMgp8oD6utjdSGGJ1+V1MgtR7OHm/4l7o5w0KgscgHx
         pDxhH6RlJW9boXr77QnCnR/OvSLlVjbZ9aWfy7RLk/EtRLEoCYS4BDc1QesOD8iiDaGB
         h4qg==
X-Gm-Message-State: APjAAAU3ft5wiKNHLNnrjwsgx+aEkuEnkK3IoGZeZZs571LgZlLNCk/p
        ddMjNbigoxx0ttHhs0SGfKBjCpxspHYP5D+l1vU=
X-Google-Smtp-Source: APXvYqwG0AW3A93WsoNkoYNxictLDrxB75gugqlw3GcBZE6Px9kk1+/BVnUhNPPSlx4x4k5RBi5XojtZd7/BU4q8Ntg=
X-Received: by 2002:a02:334f:: with SMTP id k15mr7931133jak.96.1582170167732;
 Wed, 19 Feb 2020 19:42:47 -0800 (PST)
MIME-Version: 1.0
References: <20200216064945.61726-1-xiubli@redhat.com> <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
 <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com> <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
 <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com>
 <CA+2bHPZmjvbtFBNzviR6uYsM=bF92qC-Xkgm2uucBe6KJHjJbg@mail.gmail.com>
 <CAOi1vP9GEt89=RWbwPJ+X172DJL7=R49iBxWfOerARch-VYJDg@mail.gmail.com>
 <cdc79a1163b506813b1adfdc8b2387f9bb9c0609.camel@kernel.org>
 <CA+2bHPb=9Z0nM_innY2bkcuCiKG9BVevonzxktWgzLPe=K8y1w@mail.gmail.com> <83d4aa168fbc9e0c2e1d7b1337e5ecd74d1a0fae.camel@kernel.org>
In-Reply-To: <83d4aa168fbc9e0c2e1d7b1337e5ecd74d1a0fae.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 20 Feb 2020 04:43:13 +0100
Message-ID: <CAOi1vP_rf7e_6NHM3=YaukaLfRs=niTb0EdKGaxGnhtooEWV+A@mail.gmail.com>
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 20, 2020 at 12:49 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-02-19 at 14:49 -0800, Patrick Donnelly wrote:
> > Responding to you and Ilya both:
> >
> > On Wed, Feb 19, 2020 at 1:21 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Wed, 2020-02-19 at 21:42 +0100, Ilya Dryomov wrote:
> > > > On Wed, Feb 19, 2020 at 8:22 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> > > > > On Tue, Feb 18, 2020 at 6:59 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > > > > > Yeah, I've mostly done this using DROP rules when I needed to test things.
> > > > > > > But, I think I was probably just guilty of speculating out loud here.
> > > > > >
> > > > > > I'm not sure what exactly Xiubo meant by "fulfilling" iptables rules
> > > > > > in libceph, but I will say that any kind of iptables manipulation from
> > > > > > within libceph is probably out of the question.
> > > > >
> > > > > I think we're getting confused about two thoughts on iptables: (1) to
> > > > > use iptables to effectively partition the mount instead of this new
> > > > > halt option; (2) use iptables in concert with halt to prevent FIN
> > > > > packets from being sent when the sockets are closed. I think we all
> > > > > agree (2) is not going to happen.
> > > >
> > > > Right.
> > > >
> > > > > > > I think doing this by just closing down the sockets is probably fine. I
> > > > > > > wouldn't pursue anything relating to to iptables here, unless we have
> > > > > > > some larger reason to go that route.
> > > > > >
> > > > > > IMO investing into a set of iptables and tc helpers for teuthology
> > > > > > makes a _lot_ of sense.  It isn't exactly the same as a cable pull,
> > > > > > but it's probably the next best thing.  First, it will be external to
> > > > > > the system under test.  Second, it can be made selective -- you can
> > > > > > cut a single session or all of them, simulate packet loss and latency
> > > > > > issues, etc.  Third, it can be used for recovery and failover/fencing
> > > > > > testing -- what happens when these packets get delivered two minutes
> > > > > > later?  None of this is possible with something that just attempts to
> > > > > > wedge the mount and acts as a point of no return.
> > > > >
> > > > > This sounds attractive but it does require each mount to have its own
> > > > > IP address? Or are there options? Maybe the kernel driver could mark
> > > > > the connection with a mount ID we could do filtering on it? From a
> > > > > quick Google, maybe [1] could be used for this purpose. I wonder
> > > > > however if the kernel driver would have to do that marking of the
> > > > > connection... and then we have iptables dependencies in the driver
> > > > > again which we don't want to do.
> > > >
> > > > As I said yesterday, I think it should be doable with no kernel
> > > > changes -- either with IP aliases or with the help of some virtual
> > > > interface.  Exactly how, I'm not sure because I use VMs for my tests
> > > > and haven't had to touch iptables in a while, but I would be surprised
> > > > to learn otherwise given the myriad of options out there.
> > > >
> > >
> > > ...and really, doing this sort of testing with the kernel client outside
> > > of a vm is sort of a mess anyway, IMO.
> >
> > Testing often involves making a mess :) I disagree in principle that
> > having a mechanism for stopping a netfs mount without pulling the plug
> > (virtually or otherwise) is unnecessary.
> >
>
> Ok, here are some more concerns:
>
> I'm not clear on what value this new mount option really adds. Once you
> do this, the client is hosed, so this is really only useful for testing
> the MDS. If your goal is to test the MDS with dying clients, then why
> not use a synthetic userland client to take state and do whatever you
> want?
>
> It could be I'm missing some value in using a kclient for this. If you
> did want to do this after all, then why are you keeping the mount around
> at all? It's useless after the remount, so you might as well just umount
> it.
>
> If you really want to make it just shut down the sockets, then you could
> add a new flag to umount2/sys_umount (UMOUNT_KILL or something) that
> would kill off the mount w/o talking to the MDS. That seems like a much
> cleaner interface than doing this.
>
> > > That said, I think we might need a way to match up a superblock with the
> > > sockets associated with it -- so mon, osd and mds socket info,
> > > basically. That could be a very simple thing in debugfs though, in the
> > > existing directory hierarchy there. With that info, you could reasonably
> > > do something with iptables like we're suggesting.
> >
> > That's certainly useful information to expose but I don't see how that
> > would help with constructing iptable rules. The kernel may reconnect
> > to any Ceph service at any time, especially during potential network
> > disruption (like an iptables rule dropping packets). Any rules you
> > construct for those connections would no longer apply. You cannot
> > construct rules that broadly apply to e.g. the entire ceph cluster as
> > a destination because it would interfere with other kernel client
> > mounts. I believe this is why Ilya is suggesting the use of virtual ip
> > addresses as a unique source address for each mount.
> >
>
> Sorry, braino -- sunrpc clients keep their source ports in most cases
> (for legacy reasons). I don't think libceph msgr does though. You're
> right that a debugfs info file won't really help.
>
> You could roll some sort of deep packet inspection to discern this but
> that's more difficult. I wonder if you could do it with BPF these days
> though...
>
> > > > > From my perspective, this halt patch looks pretty simple and doesn't
> > > > > appear to be a huge maintenance burden. Is it really so objectionable?
> > > >
> > > > Well, this patch is simple only because it isn't even remotely
> > > > equivalent to a cable pull.  I mean, it aborts in-flight requests
> > > > with EIO, closes sockets, etc.  Has it been tested against the test
> > > > cases that currently cold reset the node through the BMC?
> >
> > Of course not, this is the initial work soliciting feedback on the concept.
> >
>
> Yep. Don't get discouraged, I think we can do something to better
> accommodate testing, but I don't think this is the correct direction for
> it.
>
> > > > If it has been tested and the current semantics are sufficient,
> > > > are you sure they will remain so in the future?  What happens when
> > > > a new test gets added that needs a harder shutdown?  We won't be
> > > > able to reuse existing "umount -f" infrastructure anymore...  What
> > > > if a new test needs to _actually_ kill the client?
> > > >
> > > > And then a debugging knob that permanently wedges the client sure
> > > > can't be a mount option for all the obvious reasons.  This bit is easy
> > > > to fix, but the fact that it is submitted as a mount option makes me
> > > > suspect that the whole thing hasn't been thought through very well.
> >
> > Or, Xiubo needs advice on a better way to do it. In the tracker ticket
> > I suggested a sysfs control file. Would that be appropriate?
> >
>
> I'm not a fan of adding fault injection code to the client. I'd prefer
> doing this via some other mechanism. If you really do want something
> like this in the kernel, then you may want to consider something like
> BPF.
>
> > > Agreed on all points. This sort of fault injection is really best done
> > > via other means. Otherwise, it's really hard to know whether it'll
> > > behave the way you expect in other situations.
> > >
> > > I'll add too that I think experience shows that these sorts of
> > > interfaces end up bitrotted because they're too specialized to use
> > > outside of anything but very specific environments. We need to think
> > > larger than just teuthology's needs here.
> >
> > I doubt they'd become bitrotted with regular use in teuthology.
> >
>
> Well, certainly some uses of them might not, but interfaces like this
> need to be generically useful across a range of environments. I'm not
> terribly interested in plumbing something in that is _only_ used for
> teuthology, even as important as that use-case is.
>
> > I get that you both see VMs or virtual interfaces would obviate this
> > PR. VMs are not an option in teuthology. We can try to spend some time
> > on seeing if something like a bridged virtual network will work. Will
> > the kernel driver operate in the network namespace of the container
> > that mounts the volume?
> >
>
> That, I'm not sure about. I'm not sure if the sockets end up inheriting
> the net namespace of the mounting process. It'd be good to investigate
> this. You may be able to just get crafty with the unshare command to
> test it out.

It will -- I added that several years ago when docker started gaining
popularity.

This is why I keep mentioning virtual interfaces.  One thing that
will most likely work without any hiccups is a veth pair with one
interface in the namespace and one in the host plus a simple iptables
masquerading rule to NAT between the veth network and the world.
For cutting all sessions, you won't even need to touch iptables any
further: just down either end of the veth pair.

Doing it from the container would obviously work too, but further
iptables manipulation might be trickier because of more parts involved:
additional interfaces, bridge, iptables rules installed by the
container runtime, etc.

Thanks,

                Ilya
