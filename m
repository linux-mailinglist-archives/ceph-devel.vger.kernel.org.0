Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DDC14BE60
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2020 18:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgA1RP7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jan 2020 12:15:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36860 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725881AbgA1RP7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 12:15:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580231758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b9v4LRJ0X/zwC21iWprb3Pdxwg0r6oKyP3zn7Ik5Yc0=;
        b=hbp5RFMu/wwZhMGh2JnqrgZsf8QjUlyrYoYZJsnws/eqS+PNuRdUoDtRZmbsqmtalEL5wo
        8O72cxZrrxSdsDF8Xv6Y/5+0TCxnt7E75cgqxdnpDzTHIQjUlv9uOuFZfT5JvS+mwJcvhB
        vbyRop33wv3a44Bg5F2DhvPUuXie4z0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-0zvPVJxbOtiOXjEviZFC4w-1; Tue, 28 Jan 2020 12:15:42 -0500
X-MC-Unique: 0zvPVJxbOtiOXjEviZFC4w-1
Received: by mail-qv1-f69.google.com with SMTP id g15so9100398qvq.20
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jan 2020 09:15:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b9v4LRJ0X/zwC21iWprb3Pdxwg0r6oKyP3zn7Ik5Yc0=;
        b=a+C1mlA1wovza5EQjlamgiftIstBsrpGknxiMzNqsb5zv8v3E0NjQKi6nrTmpRCFfe
         Iw+mLxCMT1knMeD5PoKfNd5m9NYqMYLfcHSppaBVB9+2xJ7yQf4JUHqWY9/WVBM8ibQB
         WLLQccdUsQswmsxkOq7GUhSFP87Q38GF6CXwwa3mIlwApIncIIMf8bVdjhuoSZE7B0hc
         WNDa8rQFu6jEGtlBf4NMwWWXoa6LyGqknK32aEdJ3IKI/KFgO9kcoAFdhs0lJhIc4oJC
         F62/USx8jdtlrlYJXmd2Wr0ZayGplhqrq8JnLp2CN0GGRkg0zWVgO+7fgkfw+QuGA8uP
         GpLA==
X-Gm-Message-State: APjAAAVJpBJqkk25TR1Yxni2nnrOTRMdEQeUsIpVsyEMn1rB98Qt0CBq
        jZdvWNGWhsJ+60jIBhE1aI23lnoo0uBOsEgQ3IdgFY/u1ObqkUiucVfxTwrquTXbRqP1ltXia/n
        PL3Bp2JYKIdRDLEtXVZNvl4VE83+GzybURa5ayw==
X-Received: by 2002:a37:4702:: with SMTP id u2mr23056581qka.106.1580231741093;
        Tue, 28 Jan 2020 09:15:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqy12xK45XJ/S4v6FPIdibaw9orglTewXlm78OCE6+UYg4+e2OiLJb6k3g612FKAJA/XsK5i84ONxj8wE79oTsw=
X-Received: by 2002:a37:4702:: with SMTP id u2mr23056525qka.106.1580231740587;
 Tue, 28 Jan 2020 09:15:40 -0800 (PST)
MIME-Version: 1.0
References: <20200127164321.17468-1-lhenriques@suse.com> <CAOi1vP9RBBX9RtnZExk_9JX9-H-8B_2R6TQ6-iR3sRw047PfoQ@mail.gmail.com>
 <20200127185203.GC22545@suse.com>
In-Reply-To: <20200127185203.GC22545@suse.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 28 Jan 2020 18:15:29 +0100
Message-ID: <CAJ4mKGYFg-phv1D=D9UxZPOB4FYN04Y=SYEr4AgQVzdWKGLCgw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] parallel 'copy-from' Ops in copy_file_range
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 27, 2020 at 7:52 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Mon, Jan 27, 2020 at 07:16:17PM +0100, Ilya Dryomov wrote:
> > On Mon, Jan 27, 2020 at 5:43 PM Luis Henriques <lhenriques@suse.com> wr=
ote:
> > >
> > > Hi,
> > >
> > > As discussed here[1] I'm sending an RFC patchset that does the
> > > parallelization of the requests sent to the OSDs during a copy_file_r=
ange
> > > syscall in CephFS.
> > >
> > >   [1] https://lore.kernel.org/lkml/20200108100353.23770-1-lhenriques@=
suse.com/
> > >
> > > I've also some performance numbers that I wanted to share. Here's a
> > > description of the very simple tests I've run:
> > >
> > >  - create a file with 200 objects in it
> > >    * i.e. tests with different object sizes mean different file sizes
> > >  - drop all caches and umount the filesystem
> > >  - Measure:
> > >    * mount filesystem
> > >    * full file copy (with copy_file_range)
> > >    * umount filesystem
> > >
> > > Tests were repeated several times and the average value was used for
> > > comparison.
> > >
> > >   DISCLAIMER:
> > >   These numbers are only indicative, and different clusters and clien=
t
> > >   configs will for sure show different performance!  More rigorous te=
sts
> > >   would be require to validate these results.
> > >
> > > Having as baseline a full read+write (basically, a copy_file_range
> > > operation within a filesystem mounted without the 'copyfrom' option),
> > > here's some values for different object sizes:
> > >
> > >                           8M      4M      1M      65k
> > > read+write              100%    100%    100%     100%
> > > sequential               51%     52%     83%    >100%
> > > parallel (throttle=3D1)    51%     52%     83%    >100%
> > > parallel (throttle=3D0)    17%     17%     83%    >100%
> > >
> > > Notes:
> > >
> > > - 'parallel (throttle=3D0)' was a test where *all* the requests (i.e.=
 200
> > >   requests to copy the 200 objects in the file) were sent to the OSDs=
 and
> > >   the wait for requests completion is done at the end only.
> > >
> > > - 'parallel (throttle=3D1)' was just a control test, where the wait f=
or
> > >   completion is done immediately after a request is sent.  It was exp=
ected
> > >   to be very similar to the non-optimized ('sequential') tests.
> > >
> > > - These tests were executed on a cluster with 40 OSDs, spread across =
5
> > >   (bare-metal) nodes.
> > >
> > > - The tests with object size of 65k show that copy_file_range definit=
ely
> > >   doesn't scale to files with small object sizes.  '> 100%' actually =
means
> > >   more than 10x slower.
> > >
> > > Measuring the mount+copy+umount masks the actual difference between
> > > different throttle values due to the time spent in mount+umount.  Thu=
s,
> > > there was no real difference between throttle=3D0 (send all and wait)=
 and
> > > throttle=3D20 (send 20, wait, send 20, ...).  But here's what I obser=
ved
> > > when measuring only the copy operation (4M object size):
> > >
> > > read+write              100%
> > > parallel (throttle=3D1)    56%
> > > parallel (throttle=3D5)    23%
> > > parallel (throttle=3D10)   14%
> > > parallel (throttle=3D20)    9%
> > > parallel (throttle=3D5)     5%
> >
> > Was this supposed to be throttle=3D50?
>
> Ups, no it should be throttle=3D0 (i.e. no throttle).
>
> > >
> > > Anyway, I'll still need to revisit patch 0003 as it doesn't follow th=
e
> > > suggestion done by Jeff to *not* add another knob to fine-tune the
> > > throttle value -- this patch adds a kernel parameter for a knob that =
I
> > > wanted to use in my testing to observe different values of this throt=
tle
> > > limit.
> > >
> > > The goal is to probably to drop this patch and do the throttling in p=
atch
> > > 0002.  I just need to come up with a decent heuristic.  Jeff's sugges=
tion
> > > was to use rsize/wsize, which are set to 64M by default IIRC.  Someho=
w I
> > > feel that it should be related to the number of OSDs in the cluster
> > > instead, but I'm not sure how.  And testing these sort of heuristics =
would
> > > require different clusters, which isn't particularly easy to get.  An=
yway,
> > > comments are welcome!
> >
> > I agree with Jeff, this throttle is certainly not worth a module
> > parameter (or a mount option).  I would start with something like
> > C * (wsize / object size) and pick C between 1 and 4.
>
> Sure, I also agree with not adding the new parameter or mount option.
> It's just tricky to pick (and test!) the best formula to use.  From your
> proposal the throttle value would be by default between 16 and 64; those
> probably work fine in some situations (for example, in the cluster I used
> for running my tests).  But for a really big cluster, with hundreds of
> OSDs, it's difficult to say.

We don't really need a single client to be capable of spraying the
entire cluster in a single operation =E2=80=94 as the wsize is already an
effective control over how parallel a single write is allowed to be, I
think we're okay using it as the basis for copy_file_range as well
without worrying about scaling it up!.
-Greg

>
> Anyway, I'll come up with a proposal for the next revision.  And thanks a
> lot for your feedback.
>
> Cheers,
> --
> Lu=C3=ADs
>

