Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5349A69FA4C
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Feb 2023 18:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjBVRlx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Feb 2023 12:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjBVRlw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Feb 2023 12:41:52 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8B539CCD
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 09:41:48 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id s26so33629031edw.11
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 09:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R67bwddOFdlc4hs2STflyR0Jb6ZaqgrPY57Hfo/bYM0=;
        b=DHj5KPVcyIlSG0RYqZN1h2R0vBKEY555Av8TVZoLXjlJKq9wfKq5It6onBWwQSzhvN
         DPrXS9FT4iZTnU7hUvY1pah3vWgcjjsSQ/liYNDcYGe7ewrbA3tQjF6JKIcChrNPta5S
         oEs8ET1fBsHuOI7Tdg7fJBCQ36lYBYhEfryUUk4k+O14uhN+cEp1iCvXNjp05CZb1Jef
         xMR1ovSoBZ3RfHyEIqnSLYf2dhkPzkz8jDZgPjhOmqUKwo2MX4D52C9qvAJynoDN4YQd
         ZLuNqfcz6JsZBReFSsaNmhD16d/AUqICjKoFjy44tc++QFC1TXjh8NVO/dtsjrfPdzLp
         8WdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R67bwddOFdlc4hs2STflyR0Jb6ZaqgrPY57Hfo/bYM0=;
        b=ZyyczihbDojkXtbd2EXvNfTCFy4EGp3YrlH6jG1ey4+wAUVtsoqEb/mBhknaRQV2F4
         73B8MEJRZb5ucJFNhGL/1owk185Ez5Me3AE23aZnGcP76kaAKv9BKkr5SabdwdpRd4gH
         gqL1cg1BNOgUeulrhGHUNVcZafu4clmZdDrR76ZkWZDWj690Db1FNpaRh4WSa37t7esR
         6VNIKM6ysmsyUbTWhc3SkNSs2rgbfFWhfXmz5GQagZLFh8EZ5qfDN4J3lU/bXvDVJ2Ae
         x+Go/gdjc6pI3YQAlEopwJL/bpJtIFLYIr1Fhyfdqw9eYrs4WTR/Hij6/U2laJsrOAql
         ZoaA==
X-Gm-Message-State: AO0yUKWtEAB3Fj780yjn/ws3vN6O/dc4Js2VWJNhjUyQMdVdEmAEQiZg
        nM7uR1hE+KFJdoV/v0jO3mJM/EEGE5qgj6CePMW3ighmjZI=
X-Google-Smtp-Source: AK7set9S/qLtV8vwzI2J4c+LIHsoyCvj+JXmobByKy1IbAjVGplkyX5Ks94Hw2nFYl8WaVdihTjkgu9YEoU5h6rmhes=
X-Received: by 2002:a17:906:b201:b0:8e7:916f:d53 with SMTP id
 p1-20020a170906b20100b008e7916f0d53mr1273655ejz.11.1677087707123; Wed, 22 Feb
 2023 09:41:47 -0800 (PST)
MIME-Version: 1.0
References: <CAEivzxdru7eW=DZ=UaSuisa5X2_HHtwfT-_q3+-YmpAty+p-dw@mail.gmail.com>
 <CAOi1vP_OHYoSfhJvUk1Nsta=NLLZcyxHLGvjoACTT-VC-e=Y_w@mail.gmail.com> <CAEivzxc4YTt29ZtzGpa3Q9_dnm-mGYa0qE-iEsVedOCfF2WBzA@mail.gmail.com>
In-Reply-To: <CAEivzxc4YTt29ZtzGpa3Q9_dnm-mGYa0qE-iEsVedOCfF2WBzA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 22 Feb 2023 18:41:35 +0100
Message-ID: <CAOi1vP-U0GKENogq3QF3x=zo14fCPUdk=yU5sHzPK99KKXH4Kw@mail.gmail.com>
Subject: Re: EBLOCKLISTED error after rbd map was interrupted by fatal signal
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     ceph-devel@vger.kernel.org,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 22, 2023 at 3:07 PM Aleksandr Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> On Wed, Feb 22, 2023 at 2:38 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Wed, Feb 22, 2023 at 1:17 PM Aleksandr Mikhalitsyn
> > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > >
> > > Hi folks,
> > >
> > > Recently we've met a problem [1] with the kernel ceph client/rbd.
> > >
> > > Writing to /sys/bus/rbd/add_single_major in some cases can take a lot
> > > of time, so on the userspace side
> > > we had a timeout and sent a fatal signal to the rbd map process to
> > > interrupt the process.
> > > And this working perfectly well, but then it's impossible to perform
> > > rbd map again cause we are always getting EBLOCKLISTED error.
> >
> > Hi Aleksandr,
>
> Hi Ilya!
>
> Thanks a lot for such a fast reply.
>
> >
> > I'm not sure if there is a causal relationship between "rbd map"
> > getting sent a fatal signal by LXC and these EBLOCKLISTED errors.  Are
> > you saying that that was confirmed to be the root cause, meaning that
> > no such errors were observed after [1] got merged?
>
> AFAIK, no. After [1] was merged we haven't seen any issues with rbd.
> I think Stephane will correct me if I'm wrong.
>
> I also can't be fully sure that there is a strict logical relationship
> between EBLOCKLISTED error and fatal signal.
> After I got a report from LXD folks about this I've tried to analyse
> kernel code and find the places where
> EBLOCKLISTED (ESHUTDOWN|EBLOCKLISTED|EBLACKLISTED) can be sent to the userspace.
> I was surprised that there are no places in the kernel ceph/rbd client
> where we can throw this error, it can only
> be received from ceph monitor as a reply to a kernel client request.
> But we have a lot of checks like this:
> if (rc == -EBLOCKLISTED)
>       fsc->blocklisted = true;
> so, if we receive this error once then it will be saved in struct
> ceph_fs_client without any chance to clear it.

This is CephFS code, not RBD.

> Maybe this is the reason why all "rbd map" attempts are failing?..

As explained, "rbd map" attempts are failing because of RBD client
instance sharing (or rather the way it's implemented in that "rbd map"
doesn't check whether the existing instance is blocklisted).

>
> >
> > >
> > > We've done some brief analysis of the kernel side.
> > >
> > > Kernelside call stack:
> > > sysfs_write [/sys/bus/rbd/add_single_major]
> > > add_single_major_store
> > > do_rbd_add
> > > rbd_add_acquire_lock
> > > rbd_acquire_lock
> > > rbd_try_acquire_lock <- EBLOCKLISTED comes from there for 2nd and
> > > further attempts
> > >
> > > Most probably the place at which it was interrupted by a signal:
> > > static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
> > > {
> > > ...
> > >
> > >         rbd_assert(!rbd_is_lock_owner(rbd_dev));
> > >         queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
> > >         ret = wait_for_completion_killable_timeout(&rbd_dev->acquire_wait,
> > >         ceph_timeout_jiffies(rbd_dev->opts->lock_timeout)); <=== signal arrives
> > >
> > > As far as I understand, we had been receiving the EBLOCKLISTED errno
> > > because ceph_monc_blocklist_add()
> > > sent the "osd blocklist add" command to the ceph monitor successfully.
> >
> > RBD doesn't use ceph_monc_blocklist_add() to blocklist itself.  It's
> > there to blocklist some _other_ RBD client that happens to be holding
> > the lock and isn't responding to this RBD client's requests to release
> > it.
>
> Got it. Thanks for clarifying this.
>
> >
> > > We had removed the client from blocklist [2].
> >
> > This is very dangerous and generally shouldn't ever be done.
> > Blocklisting is Ceph's term for fencing.  Manually lifting the fence
> > without fully understanding what is going on in the system is a fast
> > ticket to data corruption.
> >
> > I see that [2] does say "Doing this may put data integrity at risk" but
> > not nearly as strong as it should.  Also, it's for CephFS, not RBD.
> >
> > > But we still weren't able to perform the rbd map. It looks like some
> > > extra state is saved on the kernel client side and blocks us.
> >
> > By default, all RBD mappings on the node share the same "RBD client"
> > instance.  Once it's blocklisted, all existing mappings mappings are
> > affected.  Unfortunately, new mappings don't check for that and just
> > attempt to reuse that instance as usual.
> >
> > This sharing can be disabled by passing "-o noshare" to "rbd map" but
> > I would recommend cleaning up existing mappings instead.
>
> So, we need to execute (on a client node):
> $ rbd showmapped
> and then
> $ rbd unmap ...
> for each mapping, correct?

More or less, but note that in case of a filesystem mounted on top of
any of these mappings, you would need to unmount it first.

Thanks,

                Ilya

>
> >
> > Thanks,
> >
> >                 Ilya
> >
> > >
> > > What do you think about it?
> > >
> > > Links:
> > > [1] https://github.com/lxc/lxd/pull/11213
> > > [2] https://docs.ceph.com/en/quincy/cephfs/eviction/#advanced-un-blocklisting-a-client
> > >
> > > Kind regards,
> > > Alex
