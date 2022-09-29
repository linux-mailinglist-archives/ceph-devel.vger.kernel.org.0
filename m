Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0F85EF417
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Sep 2022 13:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiI2LOg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Sep 2022 07:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiI2LOe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 29 Sep 2022 07:14:34 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4E014A785
        for <ceph-devel@vger.kernel.org>; Thu, 29 Sep 2022 04:14:30 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id u24so1467719edb.11
        for <ceph-devel@vger.kernel.org>; Thu, 29 Sep 2022 04:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=9sB1xwle4tSaMEyl3OmKEfU6szY9DF9KOM6lHAum0F8=;
        b=pjnbXK9mId6ijjGkPWFkpyn7UFMUoCWjuay40wAc3NOKsobJDwhfQ14NnG14LA9aPm
         qa4f43vZPtBdDnKp+6nPeMdh7wE92a5Dd9F/h+TMU+i6r/V5Z/WDetxM3H8Wj22xhu0S
         QeE0eOe0oyonGuyiJqLFBIXPTJK+FX9ppPCdADS84fYkI6FMEGi6pNvosgZXHYZL7dM5
         lesEFLH+XLhuFcK1oLMS9RKC3De3ibuWrXl5NbKOxecihd76YPA7uyEro0P5s69K7Bax
         JvB6uAGyBt4S2GtDo/s72idNzaak9af77XcrnTusduu4DpMq15U7M+G5Lq3tJGpk5uuT
         JhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9sB1xwle4tSaMEyl3OmKEfU6szY9DF9KOM6lHAum0F8=;
        b=sTvDL5N7mZmQsrEVUP3jfkKGIfbwM5IPWkqR3p2+anq4cE+UMAj6M0pTJABxRYONlY
         Sdgk/SdDO83f/Lv/Y0lLrzqm9khGCPsS3J3XhrOEEOqHLf/a6i5fVk1VvhFSqn9oVdK7
         zh+Q7620JVPgy3sMdL197wuZLnxDRwjyr+XSIcCZ4NtPfd7/Pe/Pr9YdAIPICaIqRmE3
         juMDpNnIp4ytkwQON6DplH/eigAxuOsPU2R/ACQZdxJOz8oVhYHG94pOG+LrUAXnFGlt
         dtRhL+MIefZ8eJEiYbdSBqsZ5Lj/VJwJA1zcAKANsbTQWQTNxDqoOL6hRXW0HEEPDdns
         hrlA==
X-Gm-Message-State: ACrzQf0UUNfvdDH4etZGIoiykfoYml1jo5YiiuqqY5s2R3tYolWExmGw
        AmxBAvqcFRpHeMAaUT1/pinXXtYg10ozVO4pvCgb/idC/U0=
X-Google-Smtp-Source: AMsMyM7Mj1PIirh/BZ+FbhBLUDD/X59b7lUcbuv5wHGUAjMzrrr6FVwsohpWdQM2G3srquTpLC/lnHYm3+n9SR92AJM=
X-Received: by 2002:aa7:cad5:0:b0:454:88dc:2c22 with SMTP id
 l21-20020aa7cad5000000b0045488dc2c22mr2791769edt.352.1664450069276; Thu, 29
 Sep 2022 04:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAOi1vP9jCHppG7irvLzQgwBSzhrfgc_ak1t2wc=uTOREHVBROA@mail.gmail.com>
 <CAOi1vP8Zfix48tM1ifAgQo1xK+HGC1Sh8mh+Bc=a7Bbv1QENxA@mail.gmail.com> <20220928002202.GA2357386@onthe.net.au>
In-Reply-To: <20220928002202.GA2357386@onthe.net.au>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 29 Sep 2022 13:14:17 +0200
Message-ID: <CAOi1vP8bk3nj=seT=1jGPzPRVti7j+D1dw_O+zqeUQp9M8T=BA@mail.gmail.com>
Subject: Re: rbd unmap fails with "Device or resource busy"
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     Adam King <adking@redhat.com>,
        Guillaume Abrioux <gabrioux@redhat.com>,
        ceph-devel@vger.kernel.org
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

On Wed, Sep 28, 2022 at 2:22 AM Chris Dunlop <chris@onthe.net.au> wrote:
>
> Hi all,
>
> On Fri, Sep 23, 2022 at 11:47:11AM +0200, Ilya Dryomov wrote:
> > On Fri, Sep 23, 2022 at 5:58 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >> On Wed, Sep 21, 2022 at 12:40:54PM +0200, Ilya Dryomov wrote:
> >>> On Wed, Sep 21, 2022 at 3:36 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >>>> On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >>>>> What can make a "rbd unmap" fail, assuming the device is not
> >>>>> mounted and not (obviously) open by any other processes?
> >>
> >> OK, I'm confident I now understand the cause of this problem. The
> >> particular machine where I'm mounting the rbd snapshots is also
> >> running some containerised ceph services. The ceph containers are
> >> (bind-)mounting the entire host filesystem hierarchy on startup, and
> >> if a ceph container happens to start up whilst a rbd device is
> >> mounted, the container also has the rbd mounted, preventing the host
> >> from unmapping the device even after the host has unmounted it. (More
> >> below.)
> >>
> >> This brings up a couple of issues...
> >>
> >> Why is the ceph container getting access to the entire host
> >> filesystem in the first place?
> >>
> >> Even if I mount an rbd device with the "unbindable" mount option,
> >> which is specifically supposed to prevent bind mounts to that
> >> filesystem, the ceph containers still get the mount - how / why??
> >>
> >> If the ceph containers really do need access to the entire host
> >> filesystem, perhaps it would be better to do a "slave" mount, so
> >> if/when the hosts unmounts a filesystem it's also unmounted in the
> >> container[s].  (Of course this also means any filesystems newly
> >> mounted in the host would also appear in the containers - but that
> >> happens anyway if the container is newly started).
> >
> > Thanks for the great analysis!  I think ceph-volume container does it
> > because of [1].  I'm not sure about "cephadm shell".  There is also
> > node-exporter container that needs access to the host for gathering
> > metrics.
> >
> > [1] https://tracker.ceph.com/issues/52926
>
> I'm guessing ceph-volume may need to see the host mounts so it can
> detect a disk is being used. Could this also be done in the host (like
> issue 52926 says is being done with pv/vg/lv commands), removing the
> need to have the entire host filesystem hierarchy available in the
> container?
>
> Similarly, I would have thought the node-exporter container only needs
> access to ceph-specific files/directories rather than the whole system.
>
> On Tue, Sep 27, 2022 at 12:55:37PM +0200, Ilya Dryomov wrote:
> > On Fri, Sep 23, 2022 at 3:06 PM Guillaume Abrioux <gabrioux@redhat.com> wrote:
> >> On Fri, 23 Sept 2022 at 05:59, Chris Dunlop <chris@onthe.net.au> wrote:
> >>> If the ceph containers really do need access to the entire host
> >>> filesystem, perhaps it would be better to do a "slave" mount,
> >>
> >> Yes, I think a mount with 'slave' propagation should fix your issue.
> >> I plan to do some tests next week and work on a patch.
>
> Thanks Guillaume.
>
> > I wanted to share an observation that there seem to be two cases here:
> > actual containers (e.g. an OSD container) and cephadm shell which is
> > technically also a container but may be regarded by users as a shell
> > ("window") with some binaries and configuration files injected into
> > it.
>
> For my part I don't see or use a cephadm shell as a normal shell with
> additional stuff injected. At the very least the host root filesystem
> location has changed to /rootfs so it's obviously not a standard shell.
>
> In fact I was quite surprised that the rootfs and all the other mounts
> unrelated to ceph were available at all. I'm still not convinced it's a
> good idea.
>
> In my conception a cephadm shell is a mini virtual machine specifically
> for inspecting and managing ceph specific areas *only*.
>
> I guess it's really a difference of philosophy. I only use cephadm shell
> when I'm explicitly needing to so something with ceph, and I drop back
> out of the cephadm shell (and it's associated privleges!) as soon as I'm
> done with that specific task. For everything else I'll be in my
> (non-privileged) host shell. I can imagine (although I must say I'd be
> surprised), that others may use the cephadm shell as a matter of course,
> for managing the whole machine? Then again, given issue 52926 quoted
> above, it sounds like that would be a bad idea if, for instance, the lvm
> commands should NOT be run the container "in order to avoid lvm metadata
> corruption" - i.e. it's not safe to assume a cephadm shell is a normal
> shell.
>
> I would argue the goal should be to remove access to the general host
> filesystem(s) from the ceph containers altogether where possible.
>
> I'll also admit that, generally, it's probably a bad idea to be doing
> things unrelated to ceph on a box hosting ceph. But that's the way this
> particular system has grown and unfortunately it will take quite a bit
> of time, effort, and expense to change this now.
>
> > For the former, a unidirectional propagation such that when something
> > is unmounted on the host it is also unmounted in the container is all
> > that is needed.  However, for the latter, a bidirectional propagation
> > such that when something is mounted in this shell it is also mounted
> > on the host (and therefore in all other windows) seems desirable.
> >
> > What do you think about going with MS_SLAVE for the former and
> > MS_SHARED for the latter?
>
> Personally I would find it surprising and unexpected (i.e. potentially a
> source of trouble) for mount changes done in a container (including a
> "shell" container) to affect the host. But again, that may be that
> difference of philosophy regarding the cephadm shell mentioned above.

Hi Chris,

Right, I see your point, particularly around /rootfs location making it
obvious that it's not a standard shell.  I don't have a strong opinion
here, ultimately the fix is up to Adam and Guillaume (although I would
definitely prefer a set of targeted mounts over a blanket -v /:/rootfs
mount, whether slave or not).

Thanks,

                Ilya
