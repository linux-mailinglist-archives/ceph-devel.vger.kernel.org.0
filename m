Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E0FD5F4A
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2019 11:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731125AbfJNJtQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Oct 2019 05:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbfJNJtQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 05:49:16 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0251207FF;
        Mon, 14 Oct 2019 09:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571046555;
        bh=vCu29IIe+a46pLXgxs4tzKDN6FjcyctMy5akY/4HL+M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kWmzmPbJdvv9xNyLJ2oOUUYY1xw5TZ5UMVx4jp1JRF7wO/twUA+dcnSPMsPFynb7z
         O0pyUXzEbKb1vLkC5sMSxIHGCGe+LPUUtjWgreBQqqlh8/Z8kbM/1Oyun6ox+abGYN
         mNYryeCt29JDF4PuUtEh3gJ79afpwD0qYzmEJo+0=
Message-ID: <95f300bcb6886fbe16cfd306d0021e451279d793.camel@kernel.org>
Subject: Re: Hung CephFS client
From:   Jeff Layton <jlayton@kernel.org>
To:     Robert LeBlanc <robert@leblancnet.us>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Date:   Mon, 14 Oct 2019 05:49:13 -0400
In-Reply-To: <CAANLjFot-VP0dUz7Czw6C=NvP8cXOK--Kt8Gd8HecMLHp1CPYA@mail.gmail.com>
References: <CAANLjFpQuOjeGkD_+0LNTeLystCKJ6WqA7A3X4vNgu8n+L8KWw@mail.gmail.com>
         <e9890c9feabe863dacf702327fd219f3a76fac57.camel@kernel.org>
         <CAANLjFpvyTiSanWVOdHvaLjP_oqyPikKeDJ9oMqUq=1SS7GX-w@mail.gmail.com>
         <78d8aae33c9d4ccccf32698285c91664965afbcd.camel@kernel.org>
         <CAANLjFot-VP0dUz7Czw6C=NvP8cXOK--Kt8Gd8HecMLHp1CPYA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2019-10-13 at 11:37 -0700, Robert LeBlanc wrote:
> On Sun, Oct 13, 2019 at 4:19 AM Jeff Layton <jlayton@kernel.org> wrote:
> > On Sat, 2019-10-12 at 11:20 -0700, Robert LeBlanc wrote:
> > > $ uname -a
> > > Linux sun-gpu225 4.4.0-142-generic #168~14.04.1-Ubuntu SMP Sat Jan 19
> > > 11:26:28 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
> > > 
> > 
> > That's pretty old. I'm not sure how aggressively Canonical backports
> > ceph patches.
> 
> Just trying to understand if this may be fixed in a newer version, but
> we also have to balance NVidia drivers as well.

Hard to say at this point. The stack frames you captured earlier don't
make a lot of sense. How did you get those anyway? Some sysrq activity?

In any case, I think we shouldn't assume that the problem is ceph
related just yet. It may very well be, but it's not clear so far.

> > > This was the best stack trace we could get. /proc was not helpful:
> > > root@sun-gpu225:/proc/77292# cat stack
> > > 
> > > 
> > > 
> > > [<ffffffffffffffff>] 0xffffffffffffffff
> > > 
> > 
> > A stack trace like the above generally means that the task is running in
> > userland. The earlier stack trace you sent might just indicate that it
> > was in the process of spinning on a lock when you grabbed the trace, but
> > isn't actually stuck in the kernel.
> 
> I tried catting it multiple times, but it was always that.
> 

Ok, so it sounds like it's spending a lot of its time in userspace.

> > > We did not get messages of hung tasks from the kernel. This container
> > > was running for 9 days when the jobs should have completed in a matter
> > > of hours. They were not able to stop the container, but it still was
> > > using CPU. So it smells like uninterruptable sleep, but still using
> > > CPU which based on the trace looks like it's stuck in spinlock.
> > > 
> > 
> > That could be anything then, including userland bugs. What state was the
> > process in (maybe grab /proc/<pid>/status if this happens again?).
> 
> We still have this box up. Here is the output of status:
> root@sun-gpu225:/proc/77292# cat status
> Name:   offline_percept
> State:  R (running)
> Tgid:   77292
> Ngid:   77986
> Pid:    77292
> PPid:   168913
> TracerPid:      20719
> Uid:    1000    1000    1000    1000
> Gid:    1000    1000    1000    1000
> FDSize: 256
> Groups: 27 999
> NStgid: 77292   2830
> NSpid:  77292   2830
> NSpgid: 169001  8
> NSsid:  168913  1
> VmPeak: 1094897144 kB
> VmSize: 1094639324 kB
> VmLck:         0 kB
> VmPin:         0 kB
> VmHWM:   3512696 kB
> VmRSS:   3121848 kB
> VmData: 19331276 kB
> VmStk:       144 kB
> VmExe:       184 kB
> VmLib:   1060628 kB
> VmPTE:      8992 kB
> VmPMD:        88 kB
> VmSwap:        0 kB
> HugetlbPages:          0 kB
> Threads:        1
> SigQ:   3/3090620
> SigPnd: 0000000000040100
> ShdPnd: 0000000000000001
> SigBlk: 0000000000001000
> SigIgn: 0000000001001000
> SigCgt: 00000001800044e8
> CapInh: 00000000a80425fb
> CapPrm: 0000000000000000
> CapEff: 0000000000000000
> CapBnd: 00000000a80425fb
> CapAmb: 0000000000000000
> Seccomp:        0
> Speculation_Store_Bypass:       thread vulnerable
> Cpus_allowed:
> 00000000,00000000,00000000,00000000,00000000,00000000,ffffffff
> Cpus_allowed_list:      0-31
> Mems_allowed:   00000000,00000003
> Mems_allowed_list:      0-1
> voluntary_ctxt_switches:        6499
> nonvoluntary_ctxt_switches:     28044102
> 

It's in running state, so it's not sleeping at the time you gathered
this. What you may want to do is strace the task and see what it's
doing. Is it doing syscalls and rapidly returning from them or just
spinning in userland? If it's doing syscalls, is it getting unexpected
errors that are causing it to loop? etc...

> > > Do you want me to get something more specific? Just tell me how.
> > > 
> > 
> > If you really think tasks are getting hung in the kernel, then you can
> > crash the box and get a vmcore if you have kdump set up. With that we
> > can analyze it and determine what it's doing.
> > 
> > If you suspect ceph is involved then you might want to turn up dynamic
> > debugging in the kernel and see what it's doing.
> 
> I looked in /sys/kernel/debug/ceph/, but wasn't sure how to up the
> debugging that would be beneficial.
> 

See here:

https://docs.ceph.com/docs/master/cephfs/troubleshooting/#dynamic-debugging

...but I wouldn't turn that up yet, until you have a clearer idea of
what the task is doing.

> We don't have a crash kernel loaded, so that won't be an option in this case.
> 

Ok. It's a good thing to have if you ever need to track down kernel
crashes or hangs. You may want to consider enabling it in the future.

-- 
Jeff Layton <jlayton@kernel.org>

