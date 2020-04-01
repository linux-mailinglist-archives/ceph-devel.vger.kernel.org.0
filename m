Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9843C19AB8E
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Apr 2020 14:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732503AbgDAMUs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Apr 2020 08:20:48 -0400
Received: from mail-yb1-f174.google.com ([209.85.219.174]:44105 "EHLO
        mail-yb1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732169AbgDAMUs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Apr 2020 08:20:48 -0400
Received: by mail-yb1-f174.google.com with SMTP id 11so13074100ybj.11
        for <ceph-devel@vger.kernel.org>; Wed, 01 Apr 2020 05:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kMWxZk3hkomdlMto1ou6SOL8O9wl6axHiLjsMFNpH8M=;
        b=iVlt7/GEcyHPcWf/1H5x0SdmgY7KT5PAq6S3u3kJ/Czw8mVX+KxNcsmkbV/KQ+y4P1
         8bDtBX5vYA1UGkJvrF6IMI6DE/U0cjK1tHbBVtieWI8sM6A4FN3Uhn8SJWlMonSRwEAM
         N4kJCjkJM7tcCfQ7nK0yb8dXvrt6Mwfb5VwD9JO8NGBkR8vsy0J1/JdomVSlD6/USM+D
         1oFhfbQRkNRfxfsZL7fi/lGwg4qIJh4+Z9BDRV+AuqkktrIhAYs4mDKyLFgmZ8vfQ1SG
         d1rWsis9JEWG0fBwJFY44vVEKs1ddUEZ19+yTPOPJLEd1co9tSphC23OnYxapKUd9QBR
         g8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kMWxZk3hkomdlMto1ou6SOL8O9wl6axHiLjsMFNpH8M=;
        b=K6XJIZOMKLMNrZYs1BIyOFquBDoMYqXPfEJailMEbdAQDfKFGE9DsDPl2tIHErJpXk
         sBbVU+LvSW6WyBUGeFvA76LK9UaT+urcYKfoPnpEky1pvzGP4jPms+/oSOB90EeqB1jq
         Es/SATp3/ERybDY9Nr6tZeAzVzq09/8HMMjN46EPBz7Ava43S+hMHsioUXqlUK8NSAxO
         25bYpT8xXrw36OQwmmC0eb3K3X7HMCp47kYtsKa4lOj0FbLySODXOVtJOZt8/8cLIFJg
         wxxruHr9OIWVxVsOtCRL57N6jF9mk7PmZaNCj+KHi+jBOq9D2GH4+6T9mLL87YKJFVmm
         rpEg==
X-Gm-Message-State: ANhLgQ3qbpiR6HsGMKAWVzZkRh/YmW+B7cyg7ExrBCfT7l4LOtC5s108
        wZVxnnZdxXSHUgWYOHeA1ASvTv5N20o5HoG1EaahJFaHPbLDBA==
X-Google-Smtp-Source: ADFU+vuQ3BKtIcsXC2llpptgwxGDyn8Mf01Oi+X/tB4p+ny8zfEq7blyZ1oiFNvI0k69qOCHCmhNCKiFEzPF99Z/UKE=
X-Received: by 2002:a25:b90a:: with SMTP id x10mr26203535ybj.334.1585743647422;
 Wed, 01 Apr 2020 05:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <878sjqc79i.fsf@suse.com> <alpine.DEB.2.21.2003271410190.4773@piezo.novalocal>
 <CAPPYiwpOOAnNwfPiFMx2zxj7Eh0DCUG+zfALp+8sJSLENDN-Og@mail.gmail.com> <CAJE9aOMsBp3xq2Ed1UYyBH0On2uOy1_ED_o4_niKE-Mmb8BcHQ@mail.gmail.com>
In-Reply-To: <CAJE9aOMsBp3xq2Ed1UYyBH0On2uOy1_ED_o4_niKE-Mmb8BcHQ@mail.gmail.com>
From:   Theofilos Mouratidis <mtheofilos@gmail.com>
Date:   Wed, 1 Apr 2020 14:20:36 +0200
Message-ID: <CA+9pRwSBV_1Mn7q0YHB0Qn_8A3bX7TqHfLYmJUypwoduq+3tcQ@mail.gmail.com>
Subject: Re: [ceph-users] Re: v15.2.0 Octopus released
To:     kefu chai <tchaikov@gmail.com>
Cc:     Mazzystr <mazzystr@gmail.com>, ceph-announce@ceph.io,
        ceph-users@ceph.io, dev <dev@ceph.io>,
        The Esoteric Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>, ceph-maintainers@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've been trying to use drivegroups on 15.2.0 to setup osds, but with
no luck, is this implemented?

On Sun, 29 Mar 2020 at 16:01, kefu chai <tchaikov@gmail.com> wrote:
>
> On Sat, Mar 28, 2020 at 1:29 AM Mazzystr <mazzystr@gmail.com> wrote:
> >
> > What about the missing dependencies for octopus on el8?  (looking at yoooou
> > ceph-mgr!)
>
> FWIW, leveldb for el8 is pending on review at
> https://bodhi.fedoraproject.org/updates/FEDORA-EPEL-2020-3171aba6be,
> if you could help test it. that'd be great!
>
> >
> > On Fri, Mar 27, 2020 at 7:15 AM Sage Weil <sage@newdream.net> wrote:
> >
> > > One word of caution: there is one known upgrade issue if you
> > >
> > >  - upgrade from luminous to nautilus, and then
> > >  - run nautilus for a very short period of time (hours), and then
> > >  - upgrade from nautilus to octopus
> > >
> > > that prevents OSDs from starting.  We have a fix that will be in 15.2.1,
> > > but until that is out, I would recommend against the double-upgrade.  If
> > > you have been running nautilus for a while (days) you should be fine.
> > >
> > > sage
> > >
> > >
> > > https://tracker.ceph.com/issues/44770
> > > _______________________________________________
> > > ceph-users mailing list -- ceph-users@ceph.io
> > > To unsubscribe send an email to ceph-users-leave@ceph.io
> > >
> > _______________________________________________
> > ceph-users mailing list -- ceph-users@ceph.io
> > To unsubscribe send an email to ceph-users-leave@ceph.io
>
>
>
> --
> Regards
> Kefu Chai
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io
