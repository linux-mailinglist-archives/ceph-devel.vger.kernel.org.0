Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1088E69F61C
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Feb 2023 15:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjBVOID (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Feb 2023 09:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBVOIB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Feb 2023 09:08:01 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227751ABC2
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 06:08:00 -0800 (PST)
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DA7283F123
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 14:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677074878;
        bh=omPGwQkUwISWua0S0RW9/Md3NcREOWnebERDqowHPOQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Be3lBijZpHUKAQsmwBxZvLwLEe9hHtIP5OAWLOdsx1TRVwEzTdBLxoGbXr4mpKt1+
         aevY88PR6uo3VapvRLMCSxCxrXCTR0P8+tBXW4ZtcoVXjVFjiWd29/N+rCRho48g39
         ITtBuuL5+Dzt/vLsE5ipkUg2Id4YXVh8ywpjczxYXuhmhWFsXgEv9mD/FHjZ/qDlqP
         YWbe9fTP8Lc3Dq1fMy90YP8f1d2UrsqBM8I/YVnzlgTRTwo847Lmez9bOW4COd3Vov
         vE2q/U48lKia/y1SeJHMM1OlYpABZFX0TNB0NrFUudFqO/ZsZho4uDgSP73JMSjUaI
         Cnn5W/83G6ZgQ==
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-536eace862cso33062007b3.16
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 06:07:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omPGwQkUwISWua0S0RW9/Md3NcREOWnebERDqowHPOQ=;
        b=yyC1XGQidXMrauLqY6gFVDOSvrVd4UFA4sLazkL11N1FIQzVotsEM8E9BQtg6Ty0T4
         5Hn6rJJfV1qeVcsYiXgh2YWulqXserV+X+/NnV/tzppXwggrDkg7lZBFlOD2Pp/X1UQ0
         KHXsvslcIXOWE9Gvip/b+fInVX8e3LPhy7VSUOWIObxGlDZ/ffTxV4s3UFU+sEKuC4C3
         xIpNRFkWP0AoeE/5gnJlS+ysc4SBtNZYthNbkws32Uww0GvFfgQeJDWQfQkEhcVS8KN5
         P4h2mR7c0P9CzqXA0qBOhkIrOxDbCdPoUELK7HHMMy1Hy9ZJsh34B8+nkQYgenscOTuT
         6fbA==
X-Gm-Message-State: AO0yUKW56JoTwTgmYwVuzqSqv8smEmXVqLQCPij32TB77FhrMY4lSAdG
        eZ5Tl1l4XApq7OhMc0tQAxK7etwQ1RSy9/ZalgTFO1lRAwuzYYAYYcXstSgEIsp3Szr8Mmi9pPg
        fatdQjTHht7tke0ozBjuX8T7i+NmOXCDvKC5oEL33zL7LaNFaMMFMhyoCjdqRiQA=
X-Received: by 2002:a81:4fd2:0:b0:527:9c7a:3493 with SMTP id d201-20020a814fd2000000b005279c7a3493mr1359376ywb.373.1677074877768;
        Wed, 22 Feb 2023 06:07:57 -0800 (PST)
X-Google-Smtp-Source: AK7set9SYkY5MjQwP7H28vKxLzeJFRTOb8PrVizHTNHPF/L6Tu/butsCWvP9YiVl+L483ggLfq1A5PRdqAXzAO6atRU=
X-Received: by 2002:a81:4fd2:0:b0:527:9c7a:3493 with SMTP id
 d201-20020a814fd2000000b005279c7a3493mr1359373ywb.373.1677074877507; Wed, 22
 Feb 2023 06:07:57 -0800 (PST)
MIME-Version: 1.0
References: <CAEivzxdru7eW=DZ=UaSuisa5X2_HHtwfT-_q3+-YmpAty+p-dw@mail.gmail.com>
 <CAOi1vP_OHYoSfhJvUk1Nsta=NLLZcyxHLGvjoACTT-VC-e=Y_w@mail.gmail.com>
In-Reply-To: <CAOi1vP_OHYoSfhJvUk1Nsta=NLLZcyxHLGvjoACTT-VC-e=Y_w@mail.gmail.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 22 Feb 2023 15:07:46 +0100
Message-ID: <CAEivzxc4YTt29ZtzGpa3Q9_dnm-mGYa0qE-iEsVedOCfF2WBzA@mail.gmail.com>
Subject: Re: EBLOCKLISTED error after rbd map was interrupted by fatal signal
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 22, 2023 at 2:38 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Wed, Feb 22, 2023 at 1:17 PM Aleksandr Mikhalitsyn
> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >
> > Hi folks,
> >
> > Recently we've met a problem [1] with the kernel ceph client/rbd.
> >
> > Writing to /sys/bus/rbd/add_single_major in some cases can take a lot
> > of time, so on the userspace side
> > we had a timeout and sent a fatal signal to the rbd map process to
> > interrupt the process.
> > And this working perfectly well, but then it's impossible to perform
> > rbd map again cause we are always getting EBLOCKLISTED error.
>
> Hi Aleksandr,

Hi Ilya!

Thanks a lot for such a fast reply.

>
> I'm not sure if there is a causal relationship between "rbd map"
> getting sent a fatal signal by LXC and these EBLOCKLISTED errors.  Are
> you saying that that was confirmed to be the root cause, meaning that
> no such errors were observed after [1] got merged?

AFAIK, no. After [1] was merged we haven't seen any issues with rbd.
I think Stephane will correct me if I'm wrong.

I also can't be fully sure that there is a strict logical relationship
between EBLOCKLISTED error and fatal signal.
After I got a report from LXD folks about this I've tried to analyse
kernel code and find the places where
EBLOCKLISTED (ESHUTDOWN|EBLOCKLISTED|EBLACKLISTED) can be sent to the userspace.
I was surprised that there are no places in the kernel ceph/rbd client
where we can throw this error, it can only
be received from ceph monitor as a reply to a kernel client request.
But we have a lot of checks like this:
if (rc == -EBLOCKLISTED)
      fsc->blocklisted = true;
so, if we receive this error once then it will be saved in struct
ceph_fs_client without any chance to clear it.
Maybe this is the reason why all "rbd map" attempts are failing?..

>
> >
> > We've done some brief analysis of the kernel side.
> >
> > Kernelside call stack:
> > sysfs_write [/sys/bus/rbd/add_single_major]
> > add_single_major_store
> > do_rbd_add
> > rbd_add_acquire_lock
> > rbd_acquire_lock
> > rbd_try_acquire_lock <- EBLOCKLISTED comes from there for 2nd and
> > further attempts
> >
> > Most probably the place at which it was interrupted by a signal:
> > static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
> > {
> > ...
> >
> >         rbd_assert(!rbd_is_lock_owner(rbd_dev));
> >         queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
> >         ret = wait_for_completion_killable_timeout(&rbd_dev->acquire_wait,
> >         ceph_timeout_jiffies(rbd_dev->opts->lock_timeout)); <=== signal arrives
> >
> > As far as I understand, we had been receiving the EBLOCKLISTED errno
> > because ceph_monc_blocklist_add()
> > sent the "osd blocklist add" command to the ceph monitor successfully.
>
> RBD doesn't use ceph_monc_blocklist_add() to blocklist itself.  It's
> there to blocklist some _other_ RBD client that happens to be holding
> the lock and isn't responding to this RBD client's requests to release
> it.

Got it. Thanks for clarifying this.

>
> > We had removed the client from blocklist [2].
>
> This is very dangerous and generally shouldn't ever be done.
> Blocklisting is Ceph's term for fencing.  Manually lifting the fence
> without fully understanding what is going on in the system is a fast
> ticket to data corruption.
>
> I see that [2] does say "Doing this may put data integrity at risk" but
> not nearly as strong as it should.  Also, it's for CephFS, not RBD.
>
> > But we still weren't able to perform the rbd map. It looks like some
> > extra state is saved on the kernel client side and blocks us.
>
> By default, all RBD mappings on the node share the same "RBD client"
> instance.  Once it's blocklisted, all existing mappings mappings are
> affected.  Unfortunately, new mappings don't check for that and just
> attempt to reuse that instance as usual.
>
> This sharing can be disabled by passing "-o noshare" to "rbd map" but
> I would recommend cleaning up existing mappings instead.

So, we need to execute (on a client node):
$ rbd showmapped
and then
$ rbd unmap ...
for each mapping, correct?

>
> Thanks,
>
>                 Ilya
>
> >
> > What do you think about it?
> >
> > Links:
> > [1] https://github.com/lxc/lxd/pull/11213
> > [2] https://docs.ceph.com/en/quincy/cephfs/eviction/#advanced-un-blocklisting-a-client
> >
> > Kind regards,
> > Alex
