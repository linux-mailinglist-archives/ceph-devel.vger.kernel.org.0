Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E46109DDE
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 13:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbfKZMYd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 07:24:33 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42720 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbfKZMYd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Nov 2019 07:24:33 -0500
Received: by mail-qk1-f195.google.com with SMTP id i3so15844332qkk.9
        for <ceph-devel@vger.kernel.org>; Tue, 26 Nov 2019 04:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=at4j5qBoWb/wUNZ4mBO3aVKSs5pO7Fcpu97Om0CsfKk=;
        b=UgAmWjYjnArNENldbPqwbAlTh86J8LlRanGQPv/6yWD1aYESx93Kpe5ze5QIMBS7P7
         LMCwsh9NZO3aKslY74jS1egVTSI2syhRgMh7sFbbRhNhzmHSL0Jj568diDfAdo1ynuBc
         wUglSKeyxOHeFdiA1n/0EXap/Ro1d33EigzeLZVbWwE+9liYl8UbBFM0JLMxTxuSUGfa
         vGgrisy/Rr/G4fGxAdLmN1g0b0XpJIlfcwRgMeV4nDfCM90RS1fqAbBcwF7eHTAK3549
         f89TriIEmTl3bzgGDfF1Ql0AvOjJzc5R5AkaGzUUkAakqCxvEbc/+cKVkGFFWo7HbIxX
         /ADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=at4j5qBoWb/wUNZ4mBO3aVKSs5pO7Fcpu97Om0CsfKk=;
        b=FzTs1kuZJ4ZwkIWjfY9Hzf17NZK4MLZAKDZ7jnvp3Wb29hfAt5xV9s5bF2PI7IX1sI
         VdesH8EOg+TwNaEyApI/abUmmhHuq7zeg5OBEEUsVJB+wOMCCGS2xGStFsbaqr6It+l8
         qF9t+JwZkcdSEamF5yZ9hMOAeJjCln4UvetU3w0IvyU8SauQGpNG7DFoEEY72IYLj2tK
         a3es+8tEjv+eNYxwuWTl5LVUKFvwR4dPEME/aq5t6dfgXm5KVI41otJ3buZIokdwRZ5T
         fR+hnU6aT+zcpWiG4CWW54VA3/nSI2DpHpkFT5ZqComrAaiovoZwMSakfmHGjWjY3AA8
         IHuA==
X-Gm-Message-State: APjAAAWUV0RZKW86iJMyH0JvAxlW0Ee0SwF2iTHNGdqWNXWHAqGUjv+4
        NzE+rc3XmcTE3n27JXEelO4Hz6ND9f4CugB5sgE=
X-Google-Smtp-Source: APXvYqyh87Sx4LL2XzGvEtFkBhwb8YZtDVkr7fvBlb3O4SbihQV4VtlMyrHbXo44XbRO8bQbFRt8sU9CKTZhZqS9rzE=
X-Received: by 2002:a37:68d5:: with SMTP id d204mr17090225qkc.268.1574771072011;
 Tue, 26 Nov 2019 04:24:32 -0800 (PST)
MIME-Version: 1.0
References: <20191126085114.40326-1-xiubli@redhat.com> <CAAM7YA=SAY-DQ5iUB-837=eC-ERV46_1_6Zi4SLNdD13_x4U4A@mail.gmail.com>
 <b0714ccd-4844-4b3e-24d4-d75e10bb6b08@redhat.com> <62d6459b-f227-64c9-482b-80148bdea696@redhat.com>
 <f215a5ce-f71a-4811-3650-5d62ec00262d@redhat.com>
In-Reply-To: <f215a5ce-f71a-4811-3650-5d62ec00262d@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 26 Nov 2019 20:24:20 +0800
Message-ID: <CAAM7YAnRwKtMKH2=jnaLZovd1+t1pAx1qf0BceUYRS-Mv385VQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: trigger the reclaim work once there has enough
 pending caps
To:     Xiubo Li <xiubli@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 26, 2019 at 7:25 PM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2019/11/26 19:03, Yan, Zheng wrote:
> > On 11/26/19 6:01 PM, Xiubo Li wrote:
> >> On 2019/11/26 17:49, Yan, Zheng wrote:
> >>> On Tue, Nov 26, 2019 at 4:57 PM <xiubli@redhat.com> wrote:
> >>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>
> >>>> The nr in ceph_reclaim_caps_nr() is very possibly larger than 1,
> >>>> so we may miss it and the reclaim work couldn't triggered as expected.
> >>>>
> >>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>>> ---
> >>>>   fs/ceph/mds_client.c | 2 +-
> >>>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >>>> index 08b70b5ee05e..547ffe16f91c 100644
> >>>> --- a/fs/ceph/mds_client.c
> >>>> +++ b/fs/ceph/mds_client.c
> >>>> @@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct
> >>>> ceph_mds_client *mdsc, int nr)
> >>>>          if (!nr)
> >>>>                  return;
> >>>>          val = atomic_add_return(nr, &mdsc->cap_reclaim_pending);
> >>>> -       if (!(val % CEPH_CAPS_PER_RELEASE)) {
> >>>> +       if (val / CEPH_CAPS_PER_RELEASE) {
> >>>> atomic_set(&mdsc->cap_reclaim_pending, 0);
> >>>>                  ceph_queue_cap_reclaim_work(mdsc);
> >>>>          }
> >>> this will call ceph_queue_cap_reclaim_work too frequently
> >>
> >> No it won't, the '/' here equals to '>=' and then the
> >> "mdsc->cap_reclaim_pending" will be reset and it will increase from 0
> >> again.
> >>
> >> It will make sure that only when "mdsc->cap_reclaim_pending >=
> >> CEPH_CAPS_PER_RELEASE" will call the work queue.
> >
> > Work does not get executed immediately. call
> > ceph_queue_cap_reclaim_work() when val == CEPH_CAPS_PER_RELEASE is
> > enough. There is no point to call it too frequently
> >
> >
> Yeah, it true and I am okay with this. Just going through the session
> release related code, and saw the "nr" parameter will be "ctx->used" in
> ceph_reclaim_caps_nr(mdsc, ctx->used), and in case there has many
> sessions with tremendous amount of caps. In corner case that we may
> always miss the condition that the "val == CEPH_CAPS_PER_RELEASE" here.
>

good catch. But the test should be something like

"if ((val % CEPH_CAPS_PER_RELEASE) < nr)"

> IMO, it wants to fire the work queue once "val >=
> CEPH_CAPS_PER_RELEASE", but it is not working like this, the val may
> just skip it without doing any thing.
>
> Thanks
>
>
> >>
> >>>> --
> >>>> 2.21.0
> >>>>
> >>
> >
>
