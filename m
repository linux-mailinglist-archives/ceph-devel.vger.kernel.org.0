Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D67216502B
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 21:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgBSUlr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 15:41:47 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:38482 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgBSUlr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Feb 2020 15:41:47 -0500
Received: by mail-io1-f65.google.com with SMTP id s24so2105361iog.5
        for <ceph-devel@vger.kernel.org>; Wed, 19 Feb 2020 12:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zOMIfrMxZDmq9IrQO68Z6e4FoOMVtU1Y6Ci3cg0eK+8=;
        b=g/3vOmjmsa+9AYwXbZ4U7P7oCe5DO0iHN9YvvP+mAt/63XFyUuHnXFelFJvDWj5leI
         7k9Z1qyrNea6brzDstITpJb3pZp8spRomwIhTGEA29HaS3SalcZ6XOCtD8p4/8fVsU6l
         Urn3pLuhbLAcU1Z6W2ox3ENyz3cvVKtsoD5S35ycjjOoT9AL9vlgHIdeiXmgvxHiMzz8
         o+euLaHx9o2dLhJFN7mWOpQNFUZDpV/GFp/9DwwS9opCflyPLruhHa/gCvQ0I0bI+csY
         AbCOEcjhcD34lmSK7/vUcnUEg0RxHbfC7KEkQ5bhqWPGXfqYmrUor87invCdWMeGI46Y
         C4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOMIfrMxZDmq9IrQO68Z6e4FoOMVtU1Y6Ci3cg0eK+8=;
        b=G5G8YGL7/Tiyt23Dq9/0CTJH1qpUtiqIAfwIOyW+J8BgzSZef1hcXgJYLKVlJrDNCl
         EiCC/2DF4Yotyu7nTRWt3ylWkWFAjAnW61n472Bd5xTfzxrpyra0X2vlyVLfoQcivGCZ
         +WlDOhdGbAZ65IJpjy4GRfKcoPk5ka97FPhfD03p5TBGVxvM8aA6Hnh2mqhXKaEsz2OE
         ad/0+Fs0s6QynsYgy7pb6WD6585PxadG0mwNK/18urUZyMbeWRVGyKDEocDcuzaYPMNi
         j1nQ67YL/yk8KaR827UX2cpREhY2K9KfUw3CSMNPNrAmi1FFdqflfkfHtux/6Rr5+KNJ
         HD/Q==
X-Gm-Message-State: APjAAAXr0mDc7GdBXGa6moTMS04eETeqlgb4FCbkkWhLs7c3p0VrJ3nO
        emrs2FLLRPEAtclktW0vBYmw8MfRnI22/90pirXpZAJHQTA=
X-Google-Smtp-Source: APXvYqzgDP2F/TK4uTK57A56k2jPKzROrtGIHx2rqNNjqtJ4IpZ/bJTZiNTNB88gi/j8u9P6zPRZQWmt02K+SAlIMgY=
X-Received: by 2002:a02:a14f:: with SMTP id m15mr22570818jah.16.1582144905396;
 Wed, 19 Feb 2020 12:41:45 -0800 (PST)
MIME-Version: 1.0
References: <20200216064945.61726-1-xiubli@redhat.com> <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
 <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com> <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
 <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com> <CA+2bHPZmjvbtFBNzviR6uYsM=bF92qC-Xkgm2uucBe6KJHjJbg@mail.gmail.com>
In-Reply-To: <CA+2bHPZmjvbtFBNzviR6uYsM=bF92qC-Xkgm2uucBe6KJHjJbg@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Feb 2020 21:42:11 +0100
Message-ID: <CAOi1vP9GEt89=RWbwPJ+X172DJL7=R49iBxWfOerARch-VYJDg@mail.gmail.com>
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 19, 2020 at 8:22 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
>
> On Tue, Feb 18, 2020 at 6:59 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > Yeah, I've mostly done this using DROP rules when I needed to test things.
> > > But, I think I was probably just guilty of speculating out loud here.
> >
> > I'm not sure what exactly Xiubo meant by "fulfilling" iptables rules
> > in libceph, but I will say that any kind of iptables manipulation from
> > within libceph is probably out of the question.
>
> I think we're getting confused about two thoughts on iptables: (1) to
> use iptables to effectively partition the mount instead of this new
> halt option; (2) use iptables in concert with halt to prevent FIN
> packets from being sent when the sockets are closed. I think we all
> agree (2) is not going to happen.

Right.

>
> > > I think doing this by just closing down the sockets is probably fine. I
> > > wouldn't pursue anything relating to to iptables here, unless we have
> > > some larger reason to go that route.
> >
> > IMO investing into a set of iptables and tc helpers for teuthology
> > makes a _lot_ of sense.  It isn't exactly the same as a cable pull,
> > but it's probably the next best thing.  First, it will be external to
> > the system under test.  Second, it can be made selective -- you can
> > cut a single session or all of them, simulate packet loss and latency
> > issues, etc.  Third, it can be used for recovery and failover/fencing
> > testing -- what happens when these packets get delivered two minutes
> > later?  None of this is possible with something that just attempts to
> > wedge the mount and acts as a point of no return.
>
> This sounds attractive but it does require each mount to have its own
> IP address? Or are there options? Maybe the kernel driver could mark
> the connection with a mount ID we could do filtering on it? From a
> quick Google, maybe [1] could be used for this purpose. I wonder
> however if the kernel driver would have to do that marking of the
> connection... and then we have iptables dependencies in the driver
> again which we don't want to do.

As I said yesterday, I think it should be doable with no kernel
changes -- either with IP aliases or with the help of some virtual
interface.  Exactly how, I'm not sure because I use VMs for my tests
and haven't had to touch iptables in a while, but I would be surprised
to learn otherwise given the myriad of options out there.

>
> From my perspective, this halt patch looks pretty simple and doesn't
> appear to be a huge maintenance burden. Is it really so objectionable?

Well, this patch is simple only because it isn't even remotely
equivalent to a cable pull.  I mean, it aborts in-flight requests
with EIO, closes sockets, etc.  Has it been tested against the test
cases that currently cold reset the node through the BMC?

If it has been tested and the current semantics are sufficient,
are you sure they will remain so in the future?  What happens when
a new test gets added that needs a harder shutdown?  We won't be
able to reuse existing "umount -f" infrastructure anymore...  What
if a new test needs to _actually_ kill the client?

And then a debugging knob that permanently wedges the client sure
can't be a mount option for all the obvious reasons.  This bit is easy
to fix, but the fact that it is submitted as a mount option makes me
suspect that the whole thing hasn't been thought through very well.

Thanks,

                Ilya
