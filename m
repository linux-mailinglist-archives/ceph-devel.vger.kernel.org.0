Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93190D5760
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2019 20:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbfJMSh4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Oct 2019 14:37:56 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:41721 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfJMSh4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 13 Oct 2019 14:37:56 -0400
Received: by mail-qk1-f171.google.com with SMTP id p10so13791927qkg.8
        for <ceph-devel@vger.kernel.org>; Sun, 13 Oct 2019 11:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5BRnO+ki3v+6HxkMZ0q7MNwk19LXxIgJAQXWK/Qhc2A=;
        b=tixgLC4BtuhtdA5FZG4kC4XQeieDRmajKgv7INuitHUdGDpQKe4sUW7/J0TvVML1QZ
         AGbobgcqi0mZ2lgb77zP/hBMwGqMNbTXhUNp//47y3YQvmsjJRlEUWwCvL0fXlmPz8E9
         jduFbY+GR7rLYlVluONTzHdOYKNPNtCoCoyHB0X/JdGkNU+ZuRXjQQZO0Dnev+72zQfE
         z+eAeeYENBV2zOFE4zRG3dUJlMCGLvvchUzUaKtWI29wOHPcS2W9aGW1+ZOFv4fQbaMy
         xv7dvRLlctFJDQ+mVV3czPGPZ92cetOko1RRsprPb/gKwQ07MrJCeW83ZaUlx1jdeY3m
         64MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5BRnO+ki3v+6HxkMZ0q7MNwk19LXxIgJAQXWK/Qhc2A=;
        b=g2TVDksg+7rE35ELjmYMKs36/VU5v9e9uFEmTKB68tjPyFBbi+m2ntx+rvmD/dnZPP
         9pI8aGol0j112z5SBDRcQox1UGO+pH8T2adcYjK/h/NNTfT6DMLLm5F86Qmk44ptVXHF
         1DeLBz8T6F6NROHGfAdOcJX4BBIC8e3wg1L049qhrDTqwQ4rziOXXCRQM44J2Zo4o/hs
         vZ10MpAl/YHbrp1fSXMZIa/rgI8ooo7g9xhk7v4tICGf6EAmRw6UBBsJWZBPViBOALpM
         l2VVHMCz+Ii2iRssTL5pmqa9MNNK4zT13sXAdIQa64BZduxGhb9cPvWtCdbdMi62Szus
         Ja+A==
X-Gm-Message-State: APjAAAVCy0P8Hn90dapx0twZB8Ykf8Px8U8OyAozVnVMakXhZ0bztsgC
        UjDnh6+VqBFGYEZA4blFrx2s6PF9q/8RnBJDckA+hA==
X-Google-Smtp-Source: APXvYqw7jXIQYKK/aGMv40vfNJ3T4g9NOiZpSgQjqcMJbOwDfvR8ZdoEsoVCY+7CS/KbV6BtgbDPT5xg4T1z3LiCJMs=
X-Received: by 2002:ae9:e511:: with SMTP id w17mr24316623qkf.379.1570991874675;
 Sun, 13 Oct 2019 11:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFpQuOjeGkD_+0LNTeLystCKJ6WqA7A3X4vNgu8n+L8KWw@mail.gmail.com>
 <e9890c9feabe863dacf702327fd219f3a76fac57.camel@kernel.org>
 <CAANLjFpvyTiSanWVOdHvaLjP_oqyPikKeDJ9oMqUq=1SS7GX-w@mail.gmail.com> <78d8aae33c9d4ccccf32698285c91664965afbcd.camel@kernel.org>
In-Reply-To: <78d8aae33c9d4ccccf32698285c91664965afbcd.camel@kernel.org>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Sun, 13 Oct 2019 11:37:43 -0700
Message-ID: <CAANLjFot-VP0dUz7Czw6C=NvP8cXOK--Kt8Gd8HecMLHp1CPYA@mail.gmail.com>
Subject: Re: Hung CephFS client
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Oct 13, 2019 at 4:19 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Sat, 2019-10-12 at 11:20 -0700, Robert LeBlanc wrote:
> > $ uname -a
> > Linux sun-gpu225 4.4.0-142-generic #168~14.04.1-Ubuntu SMP Sat Jan 19
> > 11:26:28 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
> >
>
> That's pretty old. I'm not sure how aggressively Canonical backports
> ceph patches.

Just trying to understand if this may be fixed in a newer version, but
we also have to balance NVidia drivers as well.

> > This was the best stack trace we could get. /proc was not helpful:
> > root@sun-gpu225:/proc/77292# cat stack
> >
> >
> >
> > [<ffffffffffffffff>] 0xffffffffffffffff
> >
>
> A stack trace like the above generally means that the task is running in
> userland. The earlier stack trace you sent might just indicate that it
> was in the process of spinning on a lock when you grabbed the trace, but
> isn't actually stuck in the kernel.

I tried catting it multiple times, but it was always that.

> > We did not get messages of hung tasks from the kernel. This container
> > was running for 9 days when the jobs should have completed in a matter
> > of hours. They were not able to stop the container, but it still was
> > using CPU. So it smells like uninterruptable sleep, but still using
> > CPU which based on the trace looks like it's stuck in spinlock.
> >
>
> That could be anything then, including userland bugs. What state was the
> process in (maybe grab /proc/<pid>/status if this happens again?).

We still have this box up. Here is the output of status:
root@sun-gpu225:/proc/77292# cat status
Name:   offline_percept
State:  R (running)
Tgid:   77292
Ngid:   77986
Pid:    77292
PPid:   168913
TracerPid:      20719
Uid:    1000    1000    1000    1000
Gid:    1000    1000    1000    1000
FDSize: 256
Groups: 27 999
NStgid: 77292   2830
NSpid:  77292   2830
NSpgid: 169001  8
NSsid:  168913  1
VmPeak: 1094897144 kB
VmSize: 1094639324 kB
VmLck:         0 kB
VmPin:         0 kB
VmHWM:   3512696 kB
VmRSS:   3121848 kB
VmData: 19331276 kB
VmStk:       144 kB
VmExe:       184 kB
VmLib:   1060628 kB
VmPTE:      8992 kB
VmPMD:        88 kB
VmSwap:        0 kB
HugetlbPages:          0 kB
Threads:        1
SigQ:   3/3090620
SigPnd: 0000000000040100
ShdPnd: 0000000000000001
SigBlk: 0000000000001000
SigIgn: 0000000001001000
SigCgt: 00000001800044e8
CapInh: 00000000a80425fb
CapPrm: 0000000000000000
CapEff: 0000000000000000
CapBnd: 00000000a80425fb
CapAmb: 0000000000000000
Seccomp:        0
Speculation_Store_Bypass:       thread vulnerable
Cpus_allowed:
00000000,00000000,00000000,00000000,00000000,00000000,ffffffff
Cpus_allowed_list:      0-31
Mems_allowed:   00000000,00000003
Mems_allowed_list:      0-1
voluntary_ctxt_switches:        6499
nonvoluntary_ctxt_switches:     28044102

> > Do you want me to get something more specific? Just tell me how.
> >
>
> If you really think tasks are getting hung in the kernel, then you can
> crash the box and get a vmcore if you have kdump set up. With that we
> can analyze it and determine what it's doing.
>
> If you suspect ceph is involved then you might want to turn up dynamic
> debugging in the kernel and see what it's doing.

I looked in /sys/kernel/debug/ceph/, but wasn't sure how to up the
debugging that would be beneficial.

We don't have a crash kernel loaded, so that won't be an option in this case.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
