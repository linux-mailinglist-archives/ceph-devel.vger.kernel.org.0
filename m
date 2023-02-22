Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B8C69F5CC
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Feb 2023 14:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjBVNio (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Feb 2023 08:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjBVNin (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Feb 2023 08:38:43 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7D23ABE
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 05:38:38 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id ck15so31729443edb.0
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 05:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qSgde1NSMGkdufN8PKDCMx8HNIGd8DvUcodVXxZuTtM=;
        b=Jrd0n3PB3tFdIAVrWs7mvFdiNWP4KmHfo5e8JJYbBWplfpzUd7YQFXuwKvJFz+zWuw
         FjfPnTkUBx2HIn37rC6MvewIobC/XCFHD+ab9tdZF3IHrD6yu09ioycKfMPji5JMvaI5
         9X4jDTPT1zVDrbPc+Cygjd9G//RmZYkWXXx1pfG9vtY3hmrgEnhlyaYzmYIrzlejrMD2
         wZcdgyH2OUzV8BmzejlZJhfvWHGS/4w1XouhKmgpHozr3tWvHBXJDJzDQEpUV5feL7ti
         trZhhO0ZICaXQ44bkj7KK3H7M5DvQu4BIn8yrhiRv8ZU69p1tNB37Q/1yUX7mLGc1VAS
         1Gdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qSgde1NSMGkdufN8PKDCMx8HNIGd8DvUcodVXxZuTtM=;
        b=q7mM9gPkdSj0aK+w74n8+CsMezPkwxGlNHJifVPCtix9kU+e1ScyglfNeEAptjpzeu
         C1swyKEYy0PQHMQZxWYkOL71gnLr5+pQVEN0TSruPw8UQIQUR03lpfipdvUE59PCLlza
         GFiDRRCc09tia9jA+l+v/4iemtLyPtYrdoeT7OJrCaXBuj+Z2IKyKSLroa5wbOvZQwS0
         UWqoapGh6YoF8D4VCom77vihD7Z74JSZ87ThqgU6XiAEx0OXo3VFSkb4ii/KAUqrkS69
         CXwZG5dxz6mAC2G1vyOTReUiyCtFgKLct61MysVXYqmOOSlXjbJud/6CthzuK+7UV7Pe
         o0ig==
X-Gm-Message-State: AO0yUKU++fE0+hxRUdgRvQRf4jG228QYKqHVqAiLswARhLpGOHxvnM7O
        B1iQ2jfDDYXd0mk6N8kL5PD4TwZWlSs3xVdJce4=
X-Google-Smtp-Source: AK7set8Ta6P2yxEE0h8CSegDDaFKFDzhju7Qd8TjefegMLHUlT/sm2fJ51WRdmg6fc7dX4fMi8SvPaZi6v2oCCs0loE=
X-Received: by 2002:a05:6402:35ca:b0:4af:62ad:60b1 with SMTP id
 z10-20020a05640235ca00b004af62ad60b1mr1245681edc.3.1677073116994; Wed, 22 Feb
 2023 05:38:36 -0800 (PST)
MIME-Version: 1.0
References: <CAEivzxdru7eW=DZ=UaSuisa5X2_HHtwfT-_q3+-YmpAty+p-dw@mail.gmail.com>
In-Reply-To: <CAEivzxdru7eW=DZ=UaSuisa5X2_HHtwfT-_q3+-YmpAty+p-dw@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 22 Feb 2023 14:38:24 +0100
Message-ID: <CAOi1vP_OHYoSfhJvUk1Nsta=NLLZcyxHLGvjoACTT-VC-e=Y_w@mail.gmail.com>
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

On Wed, Feb 22, 2023 at 1:17 PM Aleksandr Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> Hi folks,
>
> Recently we've met a problem [1] with the kernel ceph client/rbd.
>
> Writing to /sys/bus/rbd/add_single_major in some cases can take a lot
> of time, so on the userspace side
> we had a timeout and sent a fatal signal to the rbd map process to
> interrupt the process.
> And this working perfectly well, but then it's impossible to perform
> rbd map again cause we are always getting EBLOCKLISTED error.

Hi Aleksandr,

I'm not sure if there is a causal relationship between "rbd map"
getting sent a fatal signal by LXC and these EBLOCKLISTED errors.  Are
you saying that that was confirmed to be the root cause, meaning that
no such errors were observed after [1] got merged?

>
> We've done some brief analysis of the kernel side.
>
> Kernelside call stack:
> sysfs_write [/sys/bus/rbd/add_single_major]
> add_single_major_store
> do_rbd_add
> rbd_add_acquire_lock
> rbd_acquire_lock
> rbd_try_acquire_lock <- EBLOCKLISTED comes from there for 2nd and
> further attempts
>
> Most probably the place at which it was interrupted by a signal:
> static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
> {
> ...
>
>         rbd_assert(!rbd_is_lock_owner(rbd_dev));
>         queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
>         ret = wait_for_completion_killable_timeout(&rbd_dev->acquire_wait,
>         ceph_timeout_jiffies(rbd_dev->opts->lock_timeout)); <=== signal arrives
>
> As far as I understand, we had been receiving the EBLOCKLISTED errno
> because ceph_monc_blocklist_add()
> sent the "osd blocklist add" command to the ceph monitor successfully.

RBD doesn't use ceph_monc_blocklist_add() to blocklist itself.  It's
there to blocklist some _other_ RBD client that happens to be holding
the lock and isn't responding to this RBD client's requests to release
it.

> We had removed the client from blocklist [2].

This is very dangerous and generally shouldn't ever be done.
Blocklisting is Ceph's term for fencing.  Manually lifting the fence
without fully understanding what is going on in the system is a fast
ticket to data corruption.

I see that [2] does say "Doing this may put data integrity at risk" but
not nearly as strong as it should.  Also, it's for CephFS, not RBD.

> But we still weren't able to perform the rbd map. It looks like some
> extra state is saved on the kernel client side and blocks us.

By default, all RBD mappings on the node share the same "RBD client"
instance.  Once it's blocklisted, all existing mappings mappings are
affected.  Unfortunately, new mappings don't check for that and just
attempt to reuse that instance as usual.

This sharing can be disabled by passing "-o noshare" to "rbd map" but
I would recommend cleaning up existing mappings instead.

Thanks,

                Ilya

>
> What do you think about it?
>
> Links:
> [1] https://github.com/lxc/lxd/pull/11213
> [2] https://docs.ceph.com/en/quincy/cephfs/eviction/#advanced-un-blocklisting-a-client
>
> Kind regards,
> Alex
