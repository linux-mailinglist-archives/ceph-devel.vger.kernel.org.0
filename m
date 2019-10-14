Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31345D5D84
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2019 10:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbfJNIbT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Oct 2019 04:31:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36252 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfJNIbT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Oct 2019 04:31:19 -0400
Received: by mail-io1-f68.google.com with SMTP id b136so36163522iof.3
        for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2019 01:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=azsZXARfixAM2vB+B1zZ6jLe/lbaS82bs185fvI73TM=;
        b=VDz3DUvwX4ILcusFeRl7KZIrYFw7iTqOvLiPZYDPfHYnnLIvncBTg0AqYWlW+xkHQa
         8rCrwZN60Y73z7zbAuazEQmi1BEwNAiapAHLiRKPGomAx4rIMsPy0kexK5pPOYGmukCW
         TJdJNDW10SRVoDBncddyOvO816rhaRj9XP9axJuS5hzB7KXGx3KyaGgFFL0eMOQEpIvP
         gUxm0OKAgHjrtkXn4N7fQNv0K0F7WdVxSW8ra7xkcJtMm+YwBUNpxkaRtld8JVofKM9T
         S5ONlu9bOF48uhGgWm7YDc3xks4BHt0nTB5D+MMtCWrwI4LqdgNeG8Iaa76t4ZRF8UJW
         +Tjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=azsZXARfixAM2vB+B1zZ6jLe/lbaS82bs185fvI73TM=;
        b=qwTeZ+KYd93uZIWTEwQzKETXs6tVzD7O9vQORtpvYYq13ExqdqpjGq07sDRSIv/vmJ
         lPLevE59ZHHuLcBsqkkFHNyeYfyYXfiG5MICu0KvYYlGby1/AddXMHFd9JX4PaLiHFxi
         cnJ30jIGxUHsIpVBnT2PHYB7xDq8Bxv55G4nqtlJnbVGTLh8wL3ld02TD9UY7l0RvBvu
         WCDCIymuz9ohM67RvrSr97joMbsV6ScfH7JsAWqD8NSfXA9mC6KxoYMbZlm7MSMedwUJ
         2qPeCR4zDLD5/dHLrjP8XIhHKkOwLUDNyH5qfRVpCZTohqeU8Cn/v3kWJUDPjwZs932m
         YEiw==
X-Gm-Message-State: APjAAAWWW2RtWCVw17PDqBoIJkqRJ1EKwCwx9bHWFizb+LFPurWgh4cU
        w8eFFhZ8cATPsAeAewZkzPQnU6w9Zby3JyoPXr6HC92C
X-Google-Smtp-Source: APXvYqzM0OmqxJfo8/UF8uRoySQpPRsFt6NHU+kAcJ6TuVZyfoL4vnusFHdBXGaZFtXX0MpiqtNrHgpv1RexEa0Lfy0=
X-Received: by 2002:a5d:8894:: with SMTP id d20mr15382969ioo.80.1571041878754;
 Mon, 14 Oct 2019 01:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
 <6ca5062a-911e-e68f-7d16-8495044b4049@petasan.org>
In-Reply-To: <6ca5062a-911e-e68f-7d16-8495044b4049@petasan.org>
From:   "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>
Date:   Mon, 14 Oct 2019 16:31:07 +0800
Message-ID: <CAMrPN_+fgY=aRJbRPrbg-7D_kjbTuAsVaWj=WiWr+Hg4gfSD9w@mail.gmail.com>
Subject: Re: local mode -- a new tier mode
To:     Maged Mokhtar <mmokhtar@petasan.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 12 Oct 2019 at 04:58, Maged Mokhtar <mmokhtar@petasan.org> wrote:
>
> Looks quite interesting, i do however think local caching is better done
> at the block level (bcache, dm-cache, dm-writecache) rather than in
> Ceph. In theory they can deal with a smaller granularity than a Ceph
> object + go through the kernel block layer which is more optimized than
> a Ceph OSD.
>
yes, fine granularity and low migration cost.

But, based on local mode tier, we can implement more flexible
migration strategies.
Take cephfs as an example, there are a lot of files stored in the system, but
we only need to edit some of them in a certain period of time. We can migrate
the data part of the related files to SSD before the editing process
through the hint
operation. This ensures that the most important data is in SSD, while
other files
still stay on HDD.

It is not easy to do this kind of work based on block level cache
implementation, because they
don't know the up layer logical objects.

> Your results do show favorable comparison with bcache, it will be good
> to try to know why this is the case (at least at a high level), i know
> cache testing/simulation is not easy to compare two caching methods, but
> i think it is important to know why local Ceph caching would be better.
>
> It will also be interesting to compare it with dm-writecache, which is
> optimized for writes (using pmem or ssd devices) which is in many cases
> the main performance bottleneck as reads can be cached in memory
> (assuming you have enough ram).
>
> So i think more tests need to be done, which for caching is not a simple
> matter. I believe fio does have a random_distribution=zipf:[theta]

I made a comparison with CAS:
https://tracker.ceph.com/issues/42286?next_issue_id=42285#I-also-compared-local-mode-tier-with-intel-CAS

> parameter trying to simulate semi real io, as pure serial or pure random
> io is not suitable for testing cache.
>
As for local's performance, it's highly related to how to figure out hot object.
Now I reuse pool tier's hitset to do this work.
If the migration overhead can be compensated by subsequent read and
write hits, performance is not a problem.

> /Maged
>
> On 11/10/2019 18:04, Honggang(Joseph) Yang wrote:
> > Hi,
> >
> > We implemented a new cache tier mode - local mode. In this mode, an
> > osd is configured to manage two data devices, one is fast device, one
> > is slow device. Hot objects are promoted from slow device to fast
> > device, and demoted from fast device to slow device when they become
> > cold.
> >
> > The introduction of tier local mode in detail is
> > https://tracker.ceph.com/issues/42286
> >
> > tier local mode: https://github.com/yanghonggang/ceph/commits/wip-tier-new
> >
> > This work is based on ceph v12.2.5. I'm glad to port it to master
> > branch if needed.
> >
> > Any advice and suggestions will be greatly appreciated.
> >
> > thx,
> >
> > Yang Honggang
> > _______________________________________________
> > Dev mailing list -- dev@ceph.io
> > To unsubscribe send an email to dev-leave@ceph.io
>
