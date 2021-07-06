Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61543BDC35
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 19:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhGFRYr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 13:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhGFRYp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 13:24:45 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ED7C061574
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jul 2021 10:22:06 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k16so25956349ios.10
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jul 2021 10:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9fM/ojEAwAZm7vkF16fhBubF991mWTVGuozzRW+2yzk=;
        b=nnW3CLU+iANXDoCRx5ZjTNWxlVGCHLOdMvlwTJkt5aXg3rskw5+FODo5ytAPe4wV58
         LOgGQWUgeV9/ZOSb5EC78NY7ywTtb2gzjEHmmLYKH6ETmKPSoG+NoNOJUGKp6f6gwBIw
         RjXuOlMVxrU6XvSRyGP1uqgXaY1fzJbDNspkNjkA0UcrZqMYPZUo4xIRF8xMP9BvPlFv
         Y4URsnO9xO23oE+gzrjmTT8AC4RBw1wcbHrECeIwlgI6zzKM9luycTTuiHvDTR7a+srU
         eApA3CrILr+ViN8raPtPIqb/oJNG0qEa2qJMtAWTJ/sHdsDpuCKFUvl94TZVlNvK7SVB
         oBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fM/ojEAwAZm7vkF16fhBubF991mWTVGuozzRW+2yzk=;
        b=ATVclvFQKgE5NV2TE6mGmxWQ3XgAP6NljKl3TWU2vDHSnBviWxrN0NlkYC6Z5npB1X
         mBAyWmXsyoIuQyN/X8jj84iae+fPn+dNS8FXD/Q3w4fssFNoyFeQQjc+pyjaNbsEBTHh
         SLkkJjuW1/2XIBPF43O8C59Uic3Mf4IJIK2WRHnfHcIxu8BktBOr9NwMdC/1p5U4VXIF
         X/ihCKAr05V4PKO0/sAX9mmVHrFZaxZlyU3NkWUT6Hx9tXtriCTcbbOwEUo/TXFtxHd3
         m94+3NABx5dBp30bntngGoNvPMW92qQuJGPKh/iIvTL3tNhZNvJhr6S2WCP7QmkzBJsT
         1ZIQ==
X-Gm-Message-State: AOAM532ezslbFCQ+35AI20qgwtEZivh9LU09ikx5WBYFkSpgwppNRV30
        KmxW9KJ+Ga/FKQzczO2Pb7iQllv4F/+w6Gn+Wg2Gqv75Zci4dg==
X-Google-Smtp-Source: ABdhPJw2n5Bz9h7N9XZpNorMRN11mCq636dUjESdFQS3nF7wVQCruMSz1XriBFJ/w1IOLKod0ADnGbZB47as88WyebA=
X-Received: by 2002:a02:9109:: with SMTP id a9mr18010423jag.93.1625592126160;
 Tue, 06 Jul 2021 10:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue> <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
 <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue> <CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
 <21c4b9e08c4d48d6b477fc61d1fccba3@nl.team.blue> <CAOi1vP_fJm5UzSnOmQDKsVHmv-4vebNZTDk7vqLs=bvnf3fwjw@mail.gmail.com>
 <a13af12ab314437bbbffcb23b0513722@nl.team.blue> <CAOi1vP8kiGNaNPw=by=TVfJEV1_X-BNYZuVpO_Kxx5xtf40_6w@mail.gmail.com>
 <391efdae70644b71844fe6fa3dceea13@nl.team.blue> <2d37c87eb42d4bc2a99184f6bffce8a2@nl.team.blue>
 <CAOi1vP-dT=1C2SqcMxAR1NWrcHUE1K-F6M1BpBWb7pVCDhS7Og@mail.gmail.com>
In-Reply-To: <CAOi1vP-dT=1C2SqcMxAR1NWrcHUE1K-F6M1BpBWb7pVCDhS7Og@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 6 Jul 2021 19:21:41 +0200
Message-ID: <CAOi1vP-5AuH0xuZrd2AWOqRgnzHnEToE-dMQp23iOpY-a+VyLA@mail.gmail.com>
Subject: Re: All RBD IO stuck after flapping OSD's
To:     Robin Geuze <robin.geuze@nl.team.blue>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 12:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Jun 29, 2021 at 10:39 AM Robin Geuze <robin.geuze@nl.team.blue> wrote:
> >
> > Hey Ilya,
> >
> > Do you have any idea on the cause of this bug yet? I tried to dig around a bit myself in the source, but the logic around this locking is very complex, so I couldn't figure out where the problem is.
>
> I do.  The proper fix would indeed be large and not backportable but
> I have a workaround in mind that should be simple enough to backport
> all the way to 5.4.  The trick is making sure that the workaround is
> fine from the exclusive lock protocol POV.
>
> I'll try to flesh it out by the end of this week and report back
> early next week.

Hi Robin,

I CCed you on the patches.  They should apply to 5.4 cleanly.  You
mentioned you have a build farm set up, please take them for a spin.

Thanks,

                Ilya
