Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD26C1628F8
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 15:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgBRO6v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 09:58:51 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:36408 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgBRO6v (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 09:58:51 -0500
Received: by mail-il1-f196.google.com with SMTP id b15so17558704iln.3
        for <ceph-devel@vger.kernel.org>; Tue, 18 Feb 2020 06:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e/knFV9YzRKvOUTq9lpqYBR648gfD1c8/eaCSzoqg94=;
        b=VmML1NVr1Qv4fI2UiXv4qqqMLB+0skmay0o1Q3TvKTj/yn4KzcCe0TAO25IrD3fe3h
         E13Ou3rBqcpZMv8MjIJ31V+2TkNEzzo0IZ6D9CpdpeszIver7bBGlsQ4xYIGAJJIhz28
         kv+RTNCilmR/Kj1Snu8GXtL4MydpGSShcyGuXaLZHTI3E4RhAUKN6Fua6dZEC++kaBGj
         Q8DDT04qY3wyoKL36zm5unhBX4ya8OECgaMOB/8sLPLzFIa1AQx08fGYI/5q/8dM5Rgf
         loo0kLBYB7sM+zzfVoiNjCGBJ1/VdSToHjzJ/I2r4Qhqms2Y0RF5K+2MZ6wamJbUtJbA
         ycxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e/knFV9YzRKvOUTq9lpqYBR648gfD1c8/eaCSzoqg94=;
        b=QRxLmlxyJkCG5SjKSW6g9K51G1/TfyVmNtx1j0zZgkiuLljq41WcvKc0/qf71teWTw
         j/1ZDF/fZkGr55v14dsPhidsnFjnDBPm+KQGdmJ4HMl6fxgPoY86nqfcX/8zdIIcq0En
         l1ewtKi/epJ2PnEhKVFmhCOSpzdteWz9fX7CT1AQUpJCy/OeN3Q1PhLAIlOdulON/iXu
         xvsOs/ISH0gjj02ydTos6dWFizuq0bE6bPAE/Xa6uuikILHvEiAxzbxE9I0epyrtouWR
         YginjWPP50OJebfoept84FE21k5bVjkOUbU8yAYe4LA1ebLbCA27D4ozSnrPy8+VfvmG
         akEQ==
X-Gm-Message-State: APjAAAUHdXdvTWZw8XBk94t3Emv4VUaFKhuyHn5q+Se1r3oQWUY+w73s
        o7KownTRrRNJdNGH0CaLgpmAsUxgbAzipAlCCSE=
X-Google-Smtp-Source: APXvYqx8WZEgx98EiyIuvKtiVtQpmOQFa+6kPGAe08LzI3unGFkld2vAcVVZHEDwKI3QjxCQIDaZjSGcrQabva4pc84=
X-Received: by 2002:a92:b749:: with SMTP id c9mr19254806ilm.143.1582037930298;
 Tue, 18 Feb 2020 06:58:50 -0800 (PST)
MIME-Version: 1.0
References: <20200216064945.61726-1-xiubli@redhat.com> <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
 <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com> <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
In-Reply-To: <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 18 Feb 2020 15:59:15 +0100
Message-ID: <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com>
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

On Tue, Feb 18, 2020 at 1:01 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-02-18 at 15:19 +0800, Xiubo Li wrote:
> > On 2020/2/17 21:04, Jeff Layton wrote:
> > > On Sun, 2020-02-16 at 01:49 -0500, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > >
> > > > This will simulate pulling the power cable situation, which will
> > > > do:
> > > >
> > > > - abort all the inflight osd/mds requests and fail them with -EIO.
> > > > - reject any new coming osd/mds requests with -EIO.
> > > > - close all the mds connections directly without doing any clean up
> > > >    and disable mds sessions recovery routine.
> > > > - close all the osd connections directly without doing any clean up.
> > > > - set the msgr as stopped.
> > > >
> > > > URL: https://tracker.ceph.com/issues/44044
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > There is no explanation of how to actually _use_ this feature? I assume
> > > you have to remount the fs with "-o remount,halt" ? Is it possible to
> > > reenable the mount as well?  If not, why keep the mount around? Maybe we
> > > should consider wiring this in to a new umount2() flag instead?
> > >
> > > This needs much better documentation.
> > >
> > > In the past, I've generally done this using iptables. Granted that that
> > > is difficult with a clustered fs like ceph (given that you potentially
> > > have to set rules for a lot of addresses), but I wonder whether a scheme
> > > like that might be more viable in the long run.
> > >
> > How about fulfilling the DROP iptable rules in libceph ? Could you
> > foresee any problem ? This seems the one approach could simulate pulling
> > the power cable.
> >
>
> Yeah, I've mostly done this using DROP rules when I needed to test things.
> But, I think I was probably just guilty of speculating out loud here.

I'm not sure what exactly Xiubo meant by "fulfilling" iptables rules
in libceph, but I will say that any kind of iptables manipulation from
within libceph is probably out of the question.

>
> I think doing this by just closing down the sockets is probably fine. I
> wouldn't pursue anything relating to to iptables here, unless we have
> some larger reason to go that route.

IMO investing into a set of iptables and tc helpers for teuthology
makes a _lot_ of sense.  It isn't exactly the same as a cable pull,
but it's probably the next best thing.  First, it will be external to
the system under test.  Second, it can be made selective -- you can
cut a single session or all of them, simulate packet loss and latency
issues, etc.  Third, it can be used for recovery and failover/fencing
testing -- what happens when these packets get delivered two minutes
later?  None of this is possible with something that just attempts to
wedge the mount and acts as a point of no return.

Thanks,

                Ilya
