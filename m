Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948106385E
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jul 2019 17:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfGIPJu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Jul 2019 11:09:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45196 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfGIPJu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Jul 2019 11:09:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id j19so21906656qtr.12
        for <ceph-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ChKdXHcqUyUc9cqSfW10KcqwIJYHkk84ynCNa/vVx3M=;
        b=ahsuanZtvozV5NQOj/16zHsuJNdh06mVV+0I6TiW7bRCCNCEj4b8YKBzuO0AK4o8cD
         Rr5zHzJn6SW13xOCd0GwAdE0QbeBQa1I2iGZxcVTiXc1sKt8zeEED9MCbTZGzYUO68Ic
         UbRrqfzVyc4cdu3BxzztEaMRp5ALdIPhO8IuSNjNQTvCLG4er1xx4hRf4DM7RSmqmtnq
         xWiOSaq0YQXQ9UoeAKKX8aKaj0bJPhHtxOXkSys4sS9/3dtweSciyvoEoURgQxg2t76G
         6dqRL9yC7PiGzO2f3L1nMxTjXZfaqKbcVXJzgFThOfY/W7MeFLsQN7FDzKI3tZt7bkuT
         tAdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ChKdXHcqUyUc9cqSfW10KcqwIJYHkk84ynCNa/vVx3M=;
        b=ZeCpL5wBQWRiGeV/FTbWmbXKBTgvaPVAy74j8kFZ21J0/Phx1hi/gm6N/aUz/qneKX
         eE+woDWUDwaM3tX0X6Q1f9OHVsU6qD/kdTm7WTQeIYPIQr3OOSY7ffUW7n/rJ0vmp915
         9rtr3ooytptH75r1fIJ60OQg6feKPor7diIQcitweRBi4R8sfRxbhzUqTB2fcp8xNogJ
         KQSdBlmeqhn25r3jkC+gvBmFfATeZO8nJTZkQXIbrW9tBEUW2UWtJwaGUcN71RWDGzGf
         vB3YHAVa47MP40M0idOiOGFtLBTCEnsg1k8XfeivefaIOkuPi5SFdDygoOYUIdfZM5Aa
         Ga2A==
X-Gm-Message-State: APjAAAXYi41mUjQg+j05rmtZuMeSi5gC6NveJHfdRHJkdf7pe+TaiKOS
        l7f5VSvktjnjlF6P9Bwej28nZcdf3m7m8clQl4IRPQ5iiHI=
X-Google-Smtp-Source: APXvYqwGTWL5KXXMHp6q6oc5axHyDqi1QqU9f9sBWp25l0ozFFPVHRvsj9bKW0RdAiaUqvwV27SIT7gK5G4sJwvXVlo=
X-Received: by 2002:a0c:f945:: with SMTP id i5mr19311866qvo.33.1562684988784;
 Tue, 09 Jul 2019 08:09:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190703124442.6614-1-zyan@redhat.com> <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
 <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com> <a51ccdea2d6cc43ae5dde5c0f150fc754d10158c.camel@redhat.com>
 <CAAM7YAmPrUvP=cnSG33utodvoveuaL5wJCBGrncXbrbEj8bCPg@mail.gmail.com>
 <ec097fd85e1890d904f1dd542b70649b917d4118.camel@redhat.com>
 <CAAM7YA=4=mC1kOVyWbuZ94xzJTb2M63f72MeyT1EdZxfTtRt+Q@mail.gmail.com>
 <f38b809b01839e3719acebaa3d5d3280eec71b81.camel@redhat.com>
 <CAAM7YAk8iEfWDg_ZvJNSkkMQr2ZFxMieZ_oUEZGYwteeH8GpOw@mail.gmail.com>
 <bd9569f6d4c91e3fdda1e86b10372150d0c606fa.camel@redhat.com>
 <CAAM7YAkR5cjLQc4uS-Nsq7vchV76w7WwQqWXsxuJfnDeJswOrA@mail.gmail.com>
 <f9aba1c6bb58f6cd4d9bce8012be78dadfb5d7bb.camel@redhat.com>
 <CAAM7YAn2tNxwyk1+p9kJppNb8RC4UER3B+BLfD1HBeAMVFDF1g@mail.gmail.com>
 <8f530be7babafdd280586a1529a7ee5eafaaccfd.camel@redhat.com>
 <CAAM7YA=GWm41zCUmj_aUjQ6xuT0C_QCkSfrUJNcdO53daXO4KQ@mail.gmail.com>
 <0109e8b80ef562095be8b1b4afe0076319dfc531.camel@redhat.com>
 <CAAM7YAk+5NJyEP-kJiC-oQjg8fsfMcS+UKdPH9enbF_en_4htw@mail.gmail.com> <b7d47dab403000a8ce2d296e3f13f63f3914147e.camel@redhat.com>
In-Reply-To: <b7d47dab403000a8ce2d296e3f13f63f3914147e.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 9 Jul 2019 23:09:36 +0800
Message-ID: <CAAM7YA=s4TgoYghaaaOHpbYcGL_VTN3CsRq6y8XSL7qtX6TPZA@mail.gmail.com>
Subject: Re: [PATCH 0/9] ceph: auto reconnect after blacklisted
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 9, 2019 at 10:17 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Tue, 2019-07-09 at 21:31 +0800, Yan, Zheng wrote:
> > On Tue, Jul 9, 2019 at 6:18 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Tue, 2019-07-09 at 10:14 +0800, Yan, Zheng wrote:
> > > > On Mon, Jul 8, 2019 at 9:45 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > On Mon, 2019-07-08 at 19:55 +0800, Yan, Zheng wrote:
> > > > > > On Mon, Jul 8, 2019 at 7:43 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > On Mon, 2019-07-08 at 19:34 +0800, Yan, Zheng wrote:
> > > > > > > > On Mon, Jul 8, 2019 at 6:59 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > On Mon, 2019-07-08 at 16:43 +0800, Yan, Zheng wrote:
> > > > > > > > > > On Fri, Jul 5, 2019 at 9:22 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > > > On Fri, 2019-07-05 at 19:26 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > On Fri, Jul 5, 2019 at 6:16 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > > > > > On Fri, 2019-07-05 at 09:17 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > > > On Thu, Jul 4, 2019 at 10:30 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > > > > > > > On Thu, 2019-07-04 at 09:30 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > > > > > On 7/4/19 12:01 AM, Jeff Layton wrote:
> > > > > > > > > > > > > > > > > On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > > > > > > > This series add support for auto reconnect after blacklisted.
> > > > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > > > > > > > > > > > > > > > > Clean mode is enabled by default. In this mode, client drops dirty date
> > > > > > > > > > > > > > > > > > and dirty metadata, All writable file handles are invalidated. Read-only
> > > > > > > > > > > > > > > > > > file handles continue to work and caches are dropped if necessary.
> > > > > > > > > > > > > > > > > > If an inode contains any lost file lock, read and write are not allowed.
> > > > > > > > > > > > > > > > > > until all lost file locks are released.
> > > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > > Just giving this a quick glance:
> > > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > > Based on the last email discussion about this, I thought that you were
> > > > > > > > > > > > > > > > > going to provide a mount option that someone could enable that would
> > > > > > > > > > > > > > > > > basically allow the client to "soldier on" in the face of being
> > > > > > > > > > > > > > > > > blacklisted and then unblacklisted, without needing to remount anything.
> > > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > > This set seems to keep the force_reconnect option (patch #7) though, so
> > > > > > > > > > > > > > > > > I'm quite confused at this point. What exactly is the goal of here?
> > > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > because auto reconnect can be disabled, force_reconnect is the manual
> > > > > > > > > > > > > > > > way to fix blacklistd mount.
> > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Why not instead allow remounting with a different recover_session= mode?
> > > > > > > > > > > > > > > Then you wouldn't need this option that's only valid during a remount.
> > > > > > > > > > > > > > > That seems like a more natural way to use a new mount option.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > you mean something like 'recover_session=now' for remount?
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > > No, I meant something like:
> > > > > > > > > > > > >
> > > > > > > > > > > > >     -o remount,recover_session=brute
> > > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > This is confusing. user may just want to change auto reconnect mode
> > > > > > > > > > > > for backlist event in the future, does not want to force reconnect.
> > > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Why do we need to allow the admin to manually force a reconnect? If you
> > > > > > > > > > > (hypothetically) change the mode to "brute" then it should do it on its
> > > > > > > > > > > own when it detects that it's in this situation, no?
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > First, auto reconnect is limited to once every 30 seconds. Second,
> > > > > > > > > > client may fail to detect that itself is blacklisted. So I think we
> > > > > > > > > > still need a way to force client to reconnect
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > How does it detect that it has been blacklisted? Does it do that by
> > > > > > > > > looking at the OSD maps? I'd like to better understand how the client
> > > > > > > > > would recognize this automatically and why it might miss it.
> > > > > > > > >
> > > > > > > >
> > > > > > > > By checking osd request reply and session reject message from mds.
> > > > > > > >
> > > > > > >
> > > > > > > Ok, so is the issue is that the client may become blacklisted and
> > > > > > > unblacklisted before it sends anything to either server?
> > > > > > >
> > > > > >
> > > > > > No. The issue is that old version mds does not send session reject
> > > > > > message or no 'error_str=blacklisted' in session reject message.
> > > > >
> > > > > Is that the only way to detect that this has happened? What if we were
> > > > > to simply force a reconnect on any remount? Would that break anything?
> > > > >
> > > >
> > > > why?  reconnect causes all sorts of integrity issues
> > > >
> > >
> > > Care to elaborate?
> > >
> > > My understanding was that the fact that the MDS journaled everything
> > > meant that the client would be able to reclaim all of its state if the
> > > MDS crashed and restarted, or we had a momentary loss of connection. Is
> > > that not the case?
> > >
> > > Either way, remounts should be _very_ rare events, almost always
> > > performed manually by an administrator. I suggested this under the
> > > assumption that an immediate reconnection might just be a small blip in
> > > performance. If there are data integrity issues when this occurs then
> > > that seems like a bigger problem.
> >
> > If reconnect means 're-open mds sessions',  mds lose track of caps and
> > file locks after reconnect.  It's similar to the situation that client
> > get blacklisted.
> >
>
> I don't have a great grasp of the way state recovery works with cephfs,
> so please bear with me here...
>
> Suppose I have a client with a bunch of caps and file locks, and the MDS
> crashes and is restarted. Will the client be able to reclaim those
> caps/locks in some fashion? If so, how is that different from the
> situation where the client reconnects its session spuriously?
>

client can only reclaim caps/locks when mds is in reconnect state.
'rre-open sessions' is likely to happen when mds is active.

> I'm quite leery of giving admins a knob that may cause data integrity
> problems. No other network filesystem requires something like this
> force_reconnect button, so I'm rather interested to see if we can come
> up with a more conventional way to achieve what you want.


> --
> Jeff Layton <jlayton@redhat.com>
>
