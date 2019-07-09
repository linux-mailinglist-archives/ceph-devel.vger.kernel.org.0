Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C34F9636FA
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jul 2019 15:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfGINba (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Jul 2019 09:31:30 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36986 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfGINba (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Jul 2019 09:31:30 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so15998910qkl.4
        for <ceph-devel@vger.kernel.org>; Tue, 09 Jul 2019 06:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qDw3BNVuwlKLUo9LHfvzgOy6yUhO5VOjhYG+wHfxa70=;
        b=I4DAxOpdUKU3R3m5NeoW7oYRTwIKH868FyQYIsbtVOW7/l/jE70fXUrtQV5xb7SHc6
         2bREVqOEC+zxTMb9EddqzdMgdrfGtaa7PXW3jYkp9PX922EaRfoXiwujjKQjASvWssgk
         st0wKh32wibORV0No2V3hz5pZiKXjAXRPE/qyuX4O6FRz7B2AwEHRJBOSSNxdOO0efHX
         oVv6Sq0+fRvOwT8Pg7uMBrgjI47aKyo/fq0ZkU7iEx9pHFAcr/5/8mo39az3er3n5CUN
         9beY2oPjFxrAGqqREj0Wiy0ecF2m8QPC/B/k0bjgP9uxONlhgf0oI2Q1y4Mja7f/qMRg
         pCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qDw3BNVuwlKLUo9LHfvzgOy6yUhO5VOjhYG+wHfxa70=;
        b=GR3xTuFgqrmH3ZjR0jvo4g26wmbznoqR+RbSHTNFzVFVqAL8lgw4pt/CZf3HzAWaR8
         nj0KDZHdLzvVQx6rjiUAbAOHJhSG9w7EgSrBpJ0hXom52GI1DtMRTFM2tuVWsT6ePxXA
         yOCUQUasI6pMbUMqahLopEFla0+8aRZuQItwPeJRKdO1+BgdFvx/8UUQkvd/Pm8FNhex
         pAXWK7zdGzkq4u2vYVc2HQkQwk2qh/gZCsKr7mSilG7xh6EetbGSGzNUznVrvNpmhkqI
         +8GMWY3kbaTZi0ISVdwVQPM5pMNTRDkpLAkaMG+P61HePPc286rTRRwv2Cbl5a6HqJvy
         3ASw==
X-Gm-Message-State: APjAAAW4KkshYYbgkD97uIu7YZizCfF0wrpulmLDsrB7dFwsKTX2kD2t
        +MBvtbu0DG45EmLIeV4y4QNd0mEUNcbV9mKtQjRPbBN2ik4=
X-Google-Smtp-Source: APXvYqzJFzf4bHnO3PZYpdY7dlIx3Yenass4Tv5ygY4XzShiqZXYfU07qhL41GxXSHbM6lpRfkL4OeqLm8Wfra+0E0A=
X-Received: by 2002:a05:620a:15f0:: with SMTP id p16mr18498040qkm.141.1562679088591;
 Tue, 09 Jul 2019 06:31:28 -0700 (PDT)
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
 <CAAM7YA=GWm41zCUmj_aUjQ6xuT0C_QCkSfrUJNcdO53daXO4KQ@mail.gmail.com> <0109e8b80ef562095be8b1b4afe0076319dfc531.camel@redhat.com>
In-Reply-To: <0109e8b80ef562095be8b1b4afe0076319dfc531.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 9 Jul 2019 21:31:16 +0800
Message-ID: <CAAM7YAk+5NJyEP-kJiC-oQjg8fsfMcS+UKdPH9enbF_en_4htw@mail.gmail.com>
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

On Tue, Jul 9, 2019 at 6:18 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Tue, 2019-07-09 at 10:14 +0800, Yan, Zheng wrote:
> > On Mon, Jul 8, 2019 at 9:45 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Mon, 2019-07-08 at 19:55 +0800, Yan, Zheng wrote:
> > > > On Mon, Jul 8, 2019 at 7:43 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > On Mon, 2019-07-08 at 19:34 +0800, Yan, Zheng wrote:
> > > > > > On Mon, Jul 8, 2019 at 6:59 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > On Mon, 2019-07-08 at 16:43 +0800, Yan, Zheng wrote:
> > > > > > > > On Fri, Jul 5, 2019 at 9:22 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > On Fri, 2019-07-05 at 19:26 +0800, Yan, Zheng wrote:
> > > > > > > > > > On Fri, Jul 5, 2019 at 6:16 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > > > On Fri, 2019-07-05 at 09:17 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > On Thu, Jul 4, 2019 at 10:30 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > > > > > On Thu, 2019-07-04 at 09:30 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > > > On 7/4/19 12:01 AM, Jeff Layton wrote:
> > > > > > > > > > > > > > > On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > > > > > This series add support for auto reconnect after blacklisted.
> > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > > > > > > > > > > > > > > Clean mode is enabled by default. In this mode, client drops dirty date
> > > > > > > > > > > > > > > > and dirty metadata, All writable file handles are invalidated. Read-only
> > > > > > > > > > > > > > > > file handles continue to work and caches are dropped if necessary.
> > > > > > > > > > > > > > > > If an inode contains any lost file lock, read and write are not allowed.
> > > > > > > > > > > > > > > > until all lost file locks are released.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Just giving this a quick glance:
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Based on the last email discussion about this, I thought that you were
> > > > > > > > > > > > > > > going to provide a mount option that someone could enable that would
> > > > > > > > > > > > > > > basically allow the client to "soldier on" in the face of being
> > > > > > > > > > > > > > > blacklisted and then unblacklisted, without needing to remount anything.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > This set seems to keep the force_reconnect option (patch #7) though, so
> > > > > > > > > > > > > > > I'm quite confused at this point. What exactly is the goal of here?
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > because auto reconnect can be disabled, force_reconnect is the manual
> > > > > > > > > > > > > > way to fix blacklistd mount.
> > > > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > > Why not instead allow remounting with a different recover_session= mode?
> > > > > > > > > > > > > Then you wouldn't need this option that's only valid during a remount.
> > > > > > > > > > > > > That seems like a more natural way to use a new mount option.
> > > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > you mean something like 'recover_session=now' for remount?
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > No, I meant something like:
> > > > > > > > > > >
> > > > > > > > > > >     -o remount,recover_session=brute
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > This is confusing. user may just want to change auto reconnect mode
> > > > > > > > > > for backlist event in the future, does not want to force reconnect.
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Why do we need to allow the admin to manually force a reconnect? If you
> > > > > > > > > (hypothetically) change the mode to "brute" then it should do it on its
> > > > > > > > > own when it detects that it's in this situation, no?
> > > > > > > > >
> > > > > > > >
> > > > > > > > First, auto reconnect is limited to once every 30 seconds. Second,
> > > > > > > > client may fail to detect that itself is blacklisted. So I think we
> > > > > > > > still need a way to force client to reconnect
> > > > > > > >
> > > > > > >
> > > > > > > How does it detect that it has been blacklisted? Does it do that by
> > > > > > > looking at the OSD maps? I'd like to better understand how the client
> > > > > > > would recognize this automatically and why it might miss it.
> > > > > > >
> > > > > >
> > > > > > By checking osd request reply and session reject message from mds.
> > > > > >
> > > > >
> > > > > Ok, so is the issue is that the client may become blacklisted and
> > > > > unblacklisted before it sends anything to either server?
> > > > >
> > > >
> > > > No. The issue is that old version mds does not send session reject
> > > > message or no 'error_str=blacklisted' in session reject message.
> > >
> > > Is that the only way to detect that this has happened? What if we were
> > > to simply force a reconnect on any remount? Would that break anything?
> > >
> >
> > why?  reconnect causes all sorts of integrity issues
> >
>
> Care to elaborate?
>
> My understanding was that the fact that the MDS journaled everything
> meant that the client would be able to reclaim all of its state if the
> MDS crashed and restarted, or we had a momentary loss of connection. Is
> that not the case?
>
> Either way, remounts should be _very_ rare events, almost always
> performed manually by an administrator. I suggested this under the
> assumption that an immediate reconnection might just be a small blip in
> performance. If there are data integrity issues when this occurs then
> that seems like a bigger problem.

If reconnect means 're-open mds sessions',  mds lose track of caps and
file locks after reconnect.  It's similar to the situation that client
get blacklisted.

> --
> Jeff Layton <jlayton@redhat.com>
>
