Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B19A162A28
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 17:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgBRQNr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 11:13:47 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:35815 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgBRQNr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 11:13:47 -0500
Received: by mail-il1-f196.google.com with SMTP id g12so17812845ild.2
        for <ceph-devel@vger.kernel.org>; Tue, 18 Feb 2020 08:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oJVD0nd8sZGxLIsZnpiTq67wcX0kjPgnXuSMOdU2WfI=;
        b=pvGLQQHmcCvIZ5mJQGX1eq6ElEypxyUv/8sXq2hYMgRXq0mz82v3GLftmSyxulNFZo
         tyJOiVI9kmgibX+opq1Hv/Oc53XzzZsLGJwj+l6nfdEHco4e03NaIkV9YJJAotkPwcBv
         O57Qmj0CTcO58NI+k4vmTjJz4kTcD2X97CZWykUJkye/jK0/7xgLeE6jTjAMbaOyKWk8
         U/0py9QO3yfQ8V0hEcNQUzhvUKqorQw1qvP8V1nMtCr0XRd38dDrlDs5RA3KAslTH/44
         m1CVBOlRIxEk4wDp9EMYkaQf+iPPZsdbdotm21kqd9UzsgYwDF0EHjU25Uivdjbl81zV
         I5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oJVD0nd8sZGxLIsZnpiTq67wcX0kjPgnXuSMOdU2WfI=;
        b=YtWEYmEtk5VaRR3//OjRRHfjunkdEdr/rLd/XtgN6IObKHuA6m1PoSlFXzXpcvnZfE
         rcIz1QPeAj8EFslLN+f188mukWxx1tar1A8+X6FH5pyh1UInGBa+YaqnaSN33L0Eo2nX
         8RQkdcbQzAsRik3gR/nxlr7GwC7HPmgO7s94Ln82qyiofZ3VLszSkBoYJRyM/jzvW9jL
         wY+pBP+pJQVblZ4WKCEJJ0sJpz0I8YGlwsEvBn2CP6NqYV8VE14Zv1chJZ6gnXTbueZH
         8t1IQnZCwMa4S6p125gK2wuwpKQ3HqlIu+0UQ65BccxHLibPP1LHUu2e52Z+E5aRF0r+
         1uEw==
X-Gm-Message-State: APjAAAXE8ygnefOaYTn/9yf5G4qRYuFhu/DktkeiJ07I5+otW+7J9r97
        ufAl/IXxxJJyVCioXBjRnHsOi8Ppmd3iVDHv17QrYsouQhE=
X-Google-Smtp-Source: APXvYqyP8+ad5paE6SW3WBHO76jqRPZId2LzDztV8Ro2h50i28dAPcN6z/fVCSZZEMIvTNXZd606YlU7m4ytIKh8HDk=
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr19247834ilq.282.1582042426440;
 Tue, 18 Feb 2020 08:13:46 -0800 (PST)
MIME-Version: 1.0
References: <20200216064945.61726-1-xiubli@redhat.com> <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
 <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com> <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
 <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com> <d54188d2df1733bee17ad91b66c9439ee87b56e1.camel@kernel.org>
In-Reply-To: <d54188d2df1733bee17ad91b66c9439ee87b56e1.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 18 Feb 2020 17:14:11 +0100
Message-ID: <CAOi1vP8WVv45PT72obbHm_AXxRFo_1B3v6E3H3PwJDRgHoDudA@mail.gmail.com>
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 18, 2020 at 4:25 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-02-18 at 15:59 +0100, Ilya Dryomov wrote:
> > On Tue, Feb 18, 2020 at 1:01 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Tue, 2020-02-18 at 15:19 +0800, Xiubo Li wrote:
> > > > On 2020/2/17 21:04, Jeff Layton wrote:
> > > > > On Sun, 2020-02-16 at 01:49 -0500, xiubli@redhat.com wrote:
> > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > >
> > > > > > This will simulate pulling the power cable situation, which will
> > > > > > do:
> > > > > >
> > > > > > - abort all the inflight osd/mds requests and fail them with -EIO.
> > > > > > - reject any new coming osd/mds requests with -EIO.
> > > > > > - close all the mds connections directly without doing any clean up
> > > > > >    and disable mds sessions recovery routine.
> > > > > > - close all the osd connections directly without doing any clean up.
> > > > > > - set the msgr as stopped.
> > > > > >
> > > > > > URL: https://tracker.ceph.com/issues/44044
> > > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > There is no explanation of how to actually _use_ this feature? I assume
> > > > > you have to remount the fs with "-o remount,halt" ? Is it possible to
> > > > > reenable the mount as well?  If not, why keep the mount around? Maybe we
> > > > > should consider wiring this in to a new umount2() flag instead?
> > > > >
> > > > > This needs much better documentation.
> > > > >
> > > > > In the past, I've generally done this using iptables. Granted that that
> > > > > is difficult with a clustered fs like ceph (given that you potentially
> > > > > have to set rules for a lot of addresses), but I wonder whether a scheme
> > > > > like that might be more viable in the long run.
> > > > >
> > > > How about fulfilling the DROP iptable rules in libceph ? Could you
> > > > foresee any problem ? This seems the one approach could simulate pulling
> > > > the power cable.
> > > >
> > >
> > > Yeah, I've mostly done this using DROP rules when I needed to test things.
> > > But, I think I was probably just guilty of speculating out loud here.
> >
> > I'm not sure what exactly Xiubo meant by "fulfilling" iptables rules
> > in libceph, but I will say that any kind of iptables manipulation from
> > within libceph is probably out of the question.
> >
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
> >
>
> That's a great point and does sound tremendously more useful than just
> "halting" a mount like this.
>
> That said, one of the stated goals in the tracker bug is:
>
> "It'd be better if we had a way to shutdown the cephfs mount without any
> kind of cleanup. This would allow us to have kernel clients all on the
> same node and selectively "kill" them."
>
> That latter point sounds rather hard to fulfill with iptables rules.

I think it should be doable, either with IP aliases (harder on the
iptables side since it doesn't recognize them as interfaces for -i/-o),
or with one of the virtual interfaces (easier on the iptables side
since they show up as actual interfaces).

Thanks,

                Ilya
