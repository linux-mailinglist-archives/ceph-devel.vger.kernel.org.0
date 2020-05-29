Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9331E86D6
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 20:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgE2Sir (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 14:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgE2Siq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 14:38:46 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6CCC03E969
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 11:38:46 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d7so409375ioq.5
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 11:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pdq8okIuNqPFpfD90Zvl5K4Pa3HLtCn6Zsn/lmeN/5A=;
        b=H1leDEqS9ynO6EMJhHAdHMR0cNIcAZo03xH35BlkwyUlDt8xSI1tdHJMVcW3OBhwBn
         HS7ZZG5p/lbDpsyoJm7mCdh/qbMVuQDJsjuK7gFVTKzFSzqQsOxyLNla4D0Z5jWM8l5a
         JQVBGLcRs7naXmLcWS0Og5jxA9TR5b497iqgCZxB4Wci9VDT/FYeF0GkwEHGZO+zuopG
         PVsMGzZddxwu5TZaSUXvHOysba/3LFw5GQmP3xfCsMDf+YJmxnLmNvuT1iAHYzO4nSYL
         4Li4A0X1PmqleVEXnhdtH03joyLmY/ZIjOM0lKfmTp5e6d2rmLrdy9DdrQ78bYml9Pkt
         77PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pdq8okIuNqPFpfD90Zvl5K4Pa3HLtCn6Zsn/lmeN/5A=;
        b=FOCvA/9cFRMgKeEv4yF3lQJImYKviR1mmcbtXnqA7A5GOiInI/NqlKyskWD/q7VGqQ
         ArGMzp14kojNLiz51PAybrmlWf5RPbp+S+xSckfQ7UwdX27VgFzUYG750D82kR0yWQ4e
         AcrGEpqIGHvTFSvHsdzDLXURXExykqNqqHAFoTUdm66dxsnIo/xxNILCbu8WkKbrZS6w
         TA75RugS/Q1cv+u2Ldr23THwi1xrtg0fjWMtYYBT5gQwKYW1yp+JM1C+ObgNxiDay0kC
         Y5UmypTd91NAgbWHu7YdPQJ0LGRZ3qwjCcMrpmK32wis3juQCeKayn4AakbIAKEjjods
         khgQ==
X-Gm-Message-State: AOAM533TY/GbuKF6nvti/LRPNrA7rjSn1epHj8h2NOnjzH2g2xGa13zF
        nyYS2KQHoL8+sj6+/AnFHPSjHYru57mgUv7WjUjTkynWXd0=
X-Google-Smtp-Source: ABdhPJzdeiv1x5qVILELUCxW50uoFe9lghPSq/pj4scSNAejtaINAG4FYu3jlYNhPMmFyqCZYJiIMZ43isSIktyTdho=
X-Received: by 2002:a6b:6307:: with SMTP id p7mr7700337iog.200.1590777526255;
 Fri, 29 May 2020 11:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200529151952.15184-1-idryomov@gmail.com> <20200529151952.15184-4-idryomov@gmail.com>
 <adbdcc0f39b050252241c7afab17e7a4a6ba5a43.camel@kernel.org>
In-Reply-To: <adbdcc0f39b050252241c7afab17e7a4a6ba5a43.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 29 May 2020 20:38:51 +0200
Message-ID: <CAOi1vP-UPktbA7gcx0tQvN9wi1L2DB1zHyb212x5kbErkchR=Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] libceph: crush_location infrastructure
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 29, 2020 at 7:27 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-05-29 at 17:19 +0200, Ilya Dryomov wrote:
> > Allow expressing client's location in terms of CRUSH hierarchy as
> > a set of (bucket type name, bucket name) pairs.  The userspace syntax
> > "crush_location = key1=value1 key2=value2" is incompatible with mount
> > options and needed adaptation:
> >
> > - ':' separator
> > - one key:value pair per crush_location option
> > - crush_location options are combined together
> >
> > So for:
> >
> >   crush_location = host=foo rack=bar
> >
> > one would write:
> >
> >   crush_location=host:foo,crush_location=rack:bar
> >
> > As in userspace, "multipath" locations are supported, so indicating
> > locality for parallel hierarchies is possible:
> >
> >   crush_location=rack:foo1,crush_location=rack:foo2,crush_location=datacenter:bar
> >
>
> Blech, that syntax is hideous. It's also problematic in that the options
> are additive -- you can't override an option that was given earlier
> (e.g. in fstab), or in a shell script.
>
> Is it not possible to do something with a single crush_location= option?
> Maybe:
>
>     crush_location=rack:foo1/rack:foo2/datacenter:bar
>
> It's still ugly with the embedded '=' signs, but it would at least make
> it so that the options aren't additive.

I suppose we could do something like that at the cost of more
parsing boilerplate, but I'm not sure additive options are that
hideous.  I don't think additive options are unprecedented and
more importantly I think many simple boolean and integer options
are not properly overridable even in major filesystems.

What embedded '=' signs are you referring to?  I see ':' and '/'
in your suggested syntax.

Thanks,

                Ilya
