Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82DA51652AC
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 23:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBSWuI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 17:50:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727740AbgBSWuI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Feb 2020 17:50:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582152607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ylncKthfKqGxMTFAdccA9Z7CN7O4wzT9OZTdAiHK8Ok=;
        b=QV5FuqgfokIheOLkTS4mP2JS+NVMnZd6qZOo7r80nawvU1nmUjRJpiNxFxYoUYY+kvuIK+
        n2ulJJI/5uoBrAWQZG31OiDFuFcTDNrp442obkamXlXAZGNh7ucRSJASB6LNRT8DoGHpGY
        AeYZ1mc+viwfTMkLsyIDpZmUBeWu3bw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-TN4_OuxrPVOSws46DhTmwA-1; Wed, 19 Feb 2020 17:50:05 -0500
X-MC-Unique: TN4_OuxrPVOSws46DhTmwA-1
Received: by mail-io1-f72.google.com with SMTP id r62so1246984ior.21
        for <ceph-devel@vger.kernel.org>; Wed, 19 Feb 2020 14:50:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ylncKthfKqGxMTFAdccA9Z7CN7O4wzT9OZTdAiHK8Ok=;
        b=Tzn2wHE9fxfCAMOXe7udafhM/2YzcMb11qIVpB1CPNSaZDBiR9WqKziA++++B0nxLP
         J/CVCqr/Na/xrtCouVLUTtYdjuvxtIeEbGYBn9oBs5FcCR6pac/dWpcClLauMp0daH0U
         e8uGwzSCc9WFw2mskUm/9HY0pV0OBr/n6TSiUBE3GUjNnaSatdldgUYj2/b0RMnMvrNd
         Ct9CuH094Fibi5ykfUjRMPjklv0Ssq0cPXbhwGlJccDaG+cAHJHc9oetT6wEOl43L+yq
         eUgfam5rcZ4G3s4OChbNzG/O7+iPcyNUQyRw2uUxjblmRsOY/c34OaXg/n/QPxZAf7jk
         SGEg==
X-Gm-Message-State: APjAAAV6n1wtDuPmuoES/fZG+vrm59vHeBIqNby/8PJ9ebjoFiGZj7b9
        M+I+EPIgz6YQGzNynmHvKZv35T720thN12FGsDzH/GrlCPZ2U8D4HBrBSTT4efeebmZ3xFclkD3
        NlCHuuRs0RNsN30LKExhMwVGZNJj8wiEtyr7lag==
X-Received: by 2002:a02:cc7a:: with SMTP id j26mr23302099jaq.79.1582152604401;
        Wed, 19 Feb 2020 14:50:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvGx7c12JW3XafMG/1EX5T6FAtfqxvByS+eYDVmroH5xHwtU4BUn81L3HD6cL5wFed1YuuS0mc+OK63+SuEDs=
X-Received: by 2002:a02:cc7a:: with SMTP id j26mr23302084jaq.79.1582152604075;
 Wed, 19 Feb 2020 14:50:04 -0800 (PST)
MIME-Version: 1.0
References: <20200216064945.61726-1-xiubli@redhat.com> <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
 <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com> <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
 <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com>
 <CA+2bHPZmjvbtFBNzviR6uYsM=bF92qC-Xkgm2uucBe6KJHjJbg@mail.gmail.com>
 <CAOi1vP9GEt89=RWbwPJ+X172DJL7=R49iBxWfOerARch-VYJDg@mail.gmail.com> <cdc79a1163b506813b1adfdc8b2387f9bb9c0609.camel@kernel.org>
In-Reply-To: <cdc79a1163b506813b1adfdc8b2387f9bb9c0609.camel@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 19 Feb 2020 14:49:37 -0800
Message-ID: <CA+2bHPb=9Z0nM_innY2bkcuCiKG9BVevonzxktWgzLPe=K8y1w@mail.gmail.com>
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Responding to you and Ilya both:

On Wed, Feb 19, 2020 at 1:21 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-02-19 at 21:42 +0100, Ilya Dryomov wrote:
> > On Wed, Feb 19, 2020 at 8:22 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> > > On Tue, Feb 18, 2020 at 6:59 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > > > Yeah, I've mostly done this using DROP rules when I needed to test things.
> > > > > But, I think I was probably just guilty of speculating out loud here.
> > > >
> > > > I'm not sure what exactly Xiubo meant by "fulfilling" iptables rules
> > > > in libceph, but I will say that any kind of iptables manipulation from
> > > > within libceph is probably out of the question.
> > >
> > > I think we're getting confused about two thoughts on iptables: (1) to
> > > use iptables to effectively partition the mount instead of this new
> > > halt option; (2) use iptables in concert with halt to prevent FIN
> > > packets from being sent when the sockets are closed. I think we all
> > > agree (2) is not going to happen.
> >
> > Right.
> >
> > > > > I think doing this by just closing down the sockets is probably fine. I
> > > > > wouldn't pursue anything relating to to iptables here, unless we have
> > > > > some larger reason to go that route.
> > > >
> > > > IMO investing into a set of iptables and tc helpers for teuthology
> > > > makes a _lot_ of sense.  It isn't exactly the same as a cable pull,
> > > > but it's probably the next best thing.  First, it will be external to
> > > > the system under test.  Second, it can be made selective -- you can
> > > > cut a single session or all of them, simulate packet loss and latency
> > > > issues, etc.  Third, it can be used for recovery and failover/fencing
> > > > testing -- what happens when these packets get delivered two minutes
> > > > later?  None of this is possible with something that just attempts to
> > > > wedge the mount and acts as a point of no return.
> > >
> > > This sounds attractive but it does require each mount to have its own
> > > IP address? Or are there options? Maybe the kernel driver could mark
> > > the connection with a mount ID we could do filtering on it? From a
> > > quick Google, maybe [1] could be used for this purpose. I wonder
> > > however if the kernel driver would have to do that marking of the
> > > connection... and then we have iptables dependencies in the driver
> > > again which we don't want to do.
> >
> > As I said yesterday, I think it should be doable with no kernel
> > changes -- either with IP aliases or with the help of some virtual
> > interface.  Exactly how, I'm not sure because I use VMs for my tests
> > and haven't had to touch iptables in a while, but I would be surprised
> > to learn otherwise given the myriad of options out there.
> >
>
> ...and really, doing this sort of testing with the kernel client outside
> of a vm is sort of a mess anyway, IMO.

Testing often involves making a mess :) I disagree in principle that
having a mechanism for stopping a netfs mount without pulling the plug
(virtually or otherwise) is unnecessary.

> That said, I think we might need a way to match up a superblock with the
> sockets associated with it -- so mon, osd and mds socket info,
> basically. That could be a very simple thing in debugfs though, in the
> existing directory hierarchy there. With that info, you could reasonably
> do something with iptables like we're suggesting.

That's certainly useful information to expose but I don't see how that
would help with constructing iptable rules. The kernel may reconnect
to any Ceph service at any time, especially during potential network
disruption (like an iptables rule dropping packets). Any rules you
construct for those connections would no longer apply. You cannot
construct rules that broadly apply to e.g. the entire ceph cluster as
a destination because it would interfere with other kernel client
mounts. I believe this is why Ilya is suggesting the use of virtual ip
addresses as a unique source address for each mount.

> > > From my perspective, this halt patch looks pretty simple and doesn't
> > > appear to be a huge maintenance burden. Is it really so objectionable?
> >
> > Well, this patch is simple only because it isn't even remotely
> > equivalent to a cable pull.  I mean, it aborts in-flight requests
> > with EIO, closes sockets, etc.  Has it been tested against the test
> > cases that currently cold reset the node through the BMC?

Of course not, this is the initial work soliciting feedback on the concept.

> > If it has been tested and the current semantics are sufficient,
> > are you sure they will remain so in the future?  What happens when
> > a new test gets added that needs a harder shutdown?  We won't be
> > able to reuse existing "umount -f" infrastructure anymore...  What
> > if a new test needs to _actually_ kill the client?
> >
> > And then a debugging knob that permanently wedges the client sure
> > can't be a mount option for all the obvious reasons.  This bit is easy
> > to fix, but the fact that it is submitted as a mount option makes me
> > suspect that the whole thing hasn't been thought through very well.

Or, Xiubo needs advice on a better way to do it. In the tracker ticket
I suggested a sysfs control file. Would that be appropriate?

> Agreed on all points. This sort of fault injection is really best done
> via other means. Otherwise, it's really hard to know whether it'll
> behave the way you expect in other situations.
>
> I'll add too that I think experience shows that these sorts of
> interfaces end up bitrotted because they're too specialized to use
> outside of anything but very specific environments. We need to think
> larger than just teuthology's needs here.

I doubt they'd become bitrotted with regular use in teuthology.

I get that you both see VMs or virtual interfaces would obviate this
PR. VMs are not an option in teuthology. We can try to spend some time
on seeing if something like a bridged virtual network will work. Will
the kernel driver operate in the network namespace of the container
that mounts the volume?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

