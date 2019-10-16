Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B67D86D1
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Oct 2019 05:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732623AbfJPDjI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Oct 2019 23:39:08 -0400
Received: from mail-il1-f180.google.com ([209.85.166.180]:43030 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfJPDjH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Oct 2019 23:39:07 -0400
Received: by mail-il1-f180.google.com with SMTP id t5so1081028ilh.10
        for <ceph-devel@vger.kernel.org>; Tue, 15 Oct 2019 20:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m/n3I/sX2+DF/3q3GmrZdrPIEXDOHy8NC3qSmb+inKg=;
        b=ccDm0tWxTJFw6tJRHTOHQnWTADq5ujIg3iWAU2ro9mXoY0c+37c8zJqDb1pEAAvTB4
         OcbJavBB7IHdTMoRGqYEKGyuJU+/b78+S6eeyZAVNVxNd3ehywlL9qeW1vOLInVMPr3r
         xT0Zkhgu03fwRYPY7hPZXIFWirDox7Y/kakXVopNjMXoTWbcll1YeWMaa6mGsbqFzUlW
         dVY76IJ/wy4huhtdTodBuRcaKHL3kKkSgngTk+LCRsVpIM8RfsoGWunHXm9jNxjz9ff1
         TdzGxBxf42s1Nj5eso+qHbR0TzOoWM991F0LiELgcqltQbGwm8BGfS2Rd45chmrOJigs
         Cg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m/n3I/sX2+DF/3q3GmrZdrPIEXDOHy8NC3qSmb+inKg=;
        b=Let6NY9qXYUYvt+qS2oi79I2P0XNM3y9jgJTtVwdczUBmLdqWyKi7xUddpyO5dqjNf
         OQXc65llpy4u0ym9i3bwjfT4uu1KWfGl15Rdtqq4PoAkOHRYsLk7foD8AiNJtX6K/A3t
         x2gXijmdsD4szo086pm8t0nNv4vU/Eg3in0pY+kOhMlJG/3Ukmji0UgXBifNbyI895xi
         2YULw3l7F8NFtTO/pw9Ot+/Q/TUvwPumgRllkMLvHWzLeC75L2jG7k3Oas+PZpZPZF+B
         j2fHxq48ZE79hzm4m3d+vnAKf32IGnd74s8NexhGF1xLdHfb9sddYyTcww9d3LgXy97q
         bd7Q==
X-Gm-Message-State: APjAAAWERY8Go8UVaUUV9KKXvb23FiR1klx/atCrhPUi/ZIcXnVUi9jM
        g0X2GYL21hGR66qlp+U5fTHRuFduqzswDNDWEUs=
X-Google-Smtp-Source: APXvYqzG/OzlQfFJ+M5Rmd4g8D256HWdr7Wucqza65g1Ew8XG/C55mRON/qNJ6mH+RAmyCJzgiOg0tf2rJ1ZcmGRoGo=
X-Received: by 2002:a92:b314:: with SMTP id p20mr9719512ilh.80.1571197146346;
 Tue, 15 Oct 2019 20:39:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
 <CALZt5jz3F45NJZpPwAzcegtVcf6556z07MCTJx2Q0e4q8Jb5wg@mail.gmail.com> <CAFwUJS3SQGF=Ni-Ws-e9vaM5a0xoh=O5_t3KPa5QKR2rm7UeOw@mail.gmail.com>
In-Reply-To: <CAFwUJS3SQGF=Ni-Ws-e9vaM5a0xoh=O5_t3KPa5QKR2rm7UeOw@mail.gmail.com>
From:   "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>
Date:   Wed, 16 Oct 2019 11:38:55 +0800
Message-ID: <CAMrPN_+0Pf8pZ3nJoA=rEdbDOi-1yfXi2ntYjpaUmNvzJGrBYw@mail.gmail.com>
Subject: Re: local mode -- a new tier mode
To:     Sam Just <sjust@redhat.com>
Cc:     Ning Yao <zay11022@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thank you. I look forward to hearing from you.

On Wed, 16 Oct 2019 at 04:24, Sam Just <sjust@redhat.com> wrote:
>
> This is quite interesting.  I'll have a closer look this week and get
> back to you with questions!
> -Sam
>
> On Tue, Oct 15, 2019 at 5:15 AM Ning Yao <zay11022@gmail.com> wrote:
> >
> > Honggang(Joseph) Yang <eagle.rtlinux@gmail.com> =E4=BA=8E2019=E5=B9=B41=
0=E6=9C=8812=E6=97=A5=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=8812:04=E5=86=99=E9=
=81=93=EF=BC=9A
> >>
> >> Hi,
> >>
> >> We implemented a new cache tier mode - local mode. In this mode, an
> >> osd is configured to manage two data devices, one is fast device, one
> >> is slow device. Hot objects are promoted from slow device to fast
> >> device, and demoted from fast device to slow device when they become
> >> cold.
> >>
> >>
> >
> > I'm quite interesting about this and seems quite promising. But it seem=
s objects level tier seems still not efficient enough in the small write sc=
enario (4k ~ 8k based on your fio test result), right?
> > Now, in bluestore, it is possbile to implement a fine-grain local tier.=
 it seems bluestore_pextent_t may be allocated from different devices and s=
trategies like extent level hitset to evaluate whether some extents need to=
 demote to slow devices. A promotion or demotion may submit a read with wri=
te operations in a transactions, and finished with a onode or blobs flushed=
 into rocksdb.
> >
> >> The introduction of tier local mode in detail is
> >> https://tracker.ceph.com/issues/42286
> >>
> >> tier local mode: https://github.com/yanghonggang/ceph/commits/wip-tier=
-new
> >>
> >> This work is based on ceph v12.2.5. I'm glad to port it to master
> >> branch if needed.
> >>
> >> Any advice and suggestions will be greatly appreciated.
> >>
> >> thx,
> >>
> >> Yang Honggang
> >> _______________________________________________
> >> Dev mailing list -- dev@ceph.io
> >> To unsubscribe send an email to dev-leave@ceph.io
> >
> > _______________________________________________
> > Dev mailing list -- dev@ceph.io
> > To unsubscribe send an email to dev-leave@ceph.io
>
