Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A68863F1D
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2019 04:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfGJCID (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Jul 2019 22:08:03 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34458 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfGJCID (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Jul 2019 22:08:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id k10so819905qtq.1
        for <ceph-devel@vger.kernel.org>; Tue, 09 Jul 2019 19:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jwm1Q/a/kw4Hd3kAlmR7P6yRAzMOQYT4xYrApIP5Df8=;
        b=UcQ2Gy/c4YBxqVT25g6pA2EzEXEvEtR+q2+ng7r35FP0SDSGzVQKvzclT3xYTsBfXU
         0tx+jYKWFdkuvl0jdqJsnKhJeg3zIinzRBgWgm2I9etU11WUAStxm8ypwLqGGsBuX8vm
         2w3yqBPbVJj/cW2HdBWKXyY8jEJVamcm/GAGZWIUbUR+s/3kLgHpQYxg8TqiQluDPGS/
         r1j+SXWJqt+U7vpBohuYRE8KfnnzhMU+4GiknwExeSS1v7DP/pCG7ULo1Nz+gx39eA3P
         O4e1H0ASzxUPCScmk22U/UTws2NNiLwYfO5AH+iP/ASZbPAdSHl81WNBFQTLqRr5Rq1W
         m2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jwm1Q/a/kw4Hd3kAlmR7P6yRAzMOQYT4xYrApIP5Df8=;
        b=kLB1Q2MZFsfpvpMBjnR5FDh4PvmvcAP4aOAjCPyiedx+eBCNmSgbqH/yv0lIgj4jP/
         QX23NNfaBeRkbzvXw2VpVr6yFFL08O3jq15+Sx6jeeBETstji9C1HoyWZqPd3oYa1UrY
         rqGlBiNF/HpNzHwXtwnYpRH+7pWHH5WeiquC+s+HLG7HaZutEOks33hdWPRmSiDgQ6GZ
         j7UCZKEFa6fDLYliXwq+U5ajzsP18svXOxSV7C3eomdydFLqgNYItfp8KCPSttF3zFu0
         kGaUeUmNHVXif1kKCahkBQBCPSOAklKPk0JDER59qrNKA43bkiytzCke9iAINw4BCJRF
         peUQ==
X-Gm-Message-State: APjAAAXv4X/67/+Z3ts1lDDyGGeGT+HeuZmkCGFoxfoZ7PCAhU62jmtk
        gcpZJdLXy+ARl/h+oEGBPnbRFanbeH1Q5ieFObwV8rbsQIkLNA==
X-Google-Smtp-Source: APXvYqxNp2smPzDdINk4qxFXdn86he4vaba6TmYswYhzzW0Tn8/DNDdY1Z4ELV9EiBAm96GQc1D3OdDAyHq5Nwp+LxM=
X-Received: by 2002:ac8:30d2:: with SMTP id w18mr21527925qta.296.1562724481927;
 Tue, 09 Jul 2019 19:08:01 -0700 (PDT)
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
Date:   Wed, 10 Jul 2019 10:07:50 +0800
Message-ID: <CAAM7YAnA5XKVA=KL-0rEuFDysOZK3wxkKjPHbJRshDJbosjz9A@mail.gmail.com>
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
> I'm quite leery of giving admins a knob that may cause data integrity
> problems. No other network filesystem requires something like this
> force_reconnect button, so I'm rather interested to see if we can come
> up with a more conventional way to achieve what you want.

I guess other network filesystems have loosy cache consistency. In
multiple client case, they don't guarantee the order of flushing dirty
data/metadata.  Cephfs can do the same (client retry flush dirty
data/metadata after reconnect) by disabling blacklist_on_eviction.

> --
> Jeff Layton <jlayton@redhat.com>
>
