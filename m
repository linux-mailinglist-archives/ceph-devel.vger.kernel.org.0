Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37FF6550F4
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Dec 2022 14:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbiLWNXO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 23 Dec 2022 08:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbiLWNWy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 23 Dec 2022 08:22:54 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E649140804
        for <ceph-devel@vger.kernel.org>; Fri, 23 Dec 2022 05:22:52 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ud5so12051376ejc.4
        for <ceph-devel@vger.kernel.org>; Fri, 23 Dec 2022 05:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CmLmxvY2a5wo/mUUl1+JDl+VpR85lJREslvQRjVvYPI=;
        b=FUyzXZq6IscLjJYGmHP7um3usw1ox/fQfnlq3Vm4EEgOPpcbYCVftLguUAOcIrH2qa
         59BJIMLkGOQS8v5pAS3AogZIBrVCBqewykThcomhgwcmomfuUlH2RqtIW9xQQ8NC1I8n
         QXu2pg+kJnFlr1kEJttSr+kY2vZ8jfTnsmUVEdbgjAkhFebXoQqFZpaZlr/EFQ06zWOP
         3TyxCGFYE/wnZ7RQZjb6quSe+aULh84IEcNV5By+fXW/HxSnr7nqfzfNz12G8/lEu+FB
         yREPi4RK4C+k582oqMGeZettrNClFPbOkvZjiCCZHgGg55PA52oOZSCWZnxk8OQMK2R1
         nQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CmLmxvY2a5wo/mUUl1+JDl+VpR85lJREslvQRjVvYPI=;
        b=BZNu+Y4Q95OxjRsrSD0QFSlQWG5gciLqXat689KUQIgHGA6b4olfVgQ4b+T8PyHYH/
         lQMQax0jg84+UmaZxPHgpvOQczuq3847siOBXppyfs79xkA7/4ZnQjpXKNfpTM1SKy8M
         Tqb9bzadI76Ewpd5+i9u7jkSRWwODobPyWagXxCOsdBU/DO0sNje0SYYyw137pCarWOH
         jy71b6d9G3+O11NX8zeGIVBWicaCrMhZJGMj5IYGbYhypWd0cryXwajA2ESOpmn62tRE
         P4bELn5o1hY2tIoD2O1GCVebnsk57Ize5vRCns0HHFFacC/zR32mkt2ivHdXz6ND0D/H
         TJwg==
X-Gm-Message-State: AFqh2kpl1gqvSecS5sv5ccIucMUMkXA2Z1wvDsCx3BZahr9rOn0XqE7C
        0HbAf/LORRg7Oeygb7jx9733CX39PUXcqlPrMLI=
X-Google-Smtp-Source: AMrXdXvVvdWq4da3eQlzKoV9dM2NEZ724J6MPOO6JcHuaCdn59zh5NEwNzjU1QD3d5NA8II963PrSS6RGu2lTsEXOWg=
X-Received: by 2002:a17:906:708f:b0:7c4:e857:e0b8 with SMTP id
 b15-20020a170906708f00b007c4e857e0b8mr685848ejk.603.1671801771231; Fri, 23
 Dec 2022 05:22:51 -0800 (PST)
MIME-Version: 1.0
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
 <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
 <4c039a76-b638-98b7-1104-e81857df8bcd@redhat.com> <9b714315c8934da38449eb2ce5b85cfc@mpinat.mpg.de>
 <70e8a12c-d94e-7784-c842-cbdd87ff438e@redhat.com> <62582bb6b2124f1a9dd111f29049b25b@mpinat.mpg.de>
 <a6091b92-c216-e525-0bc7-5515225f6dc8@molgen.mpg.de> <a212e2465caf4c7da3aa1fe0e094831f@mpinat.mpg.de>
 <CAOi1vP-g2no3i91SshzcWb8XY6aup4h_GcO6Le=caM8-XmXGnQ@mail.gmail.com>
 <f3e2a67f41bb49bc8e131ce2f0bf5816@mpinat.mpg.de> <CAOi1vP8G2UgBXvNVv4hjaMcAsjSDC-KBeRpXYhsdTaYcnF0c2Q@mail.gmail.com>
 <ef6bb3f4-528b-17e9-4f4c-8b5bcb5936f2@molgen.mpg.de>
In-Reply-To: <ef6bb3f4-528b-17e9-4f4c-8b5bcb5936f2@molgen.mpg.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 23 Dec 2022 14:22:39 +0100
Message-ID: <CAOi1vP_K2YBX9+JffMUHCuXsynGfTqJYh+FRUsYY4UrePrK9fQ@mail.gmail.com>
Subject: Re: PROBLEM: CephFS write performance drops by 90%
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Marco Roose <marco.roose@mpinat.mpg.de>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Dec 23, 2022 at 9:06 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Ilya,
>
>
> Am 22.12.22 um 16:25 schrieb Ilya Dryomov:
> > On Thu, Dec 22, 2022 at 3:41 PM Roose, Marco <marco.roose@mpinat.mpg.de=
> wrote:
>
> >> thanks for providing the revert. Using that commit all is fine:
> >>
> >> ~# uname -a
> >> Linux S1020-CephTest 6.1.0+ #1 SMP PREEMPT_DYNAMIC Thu Dec 22 14:30:22=
 CET
> >> 2022 x86_64 x86_64 x86_64 GNU/Linux
> >>
> >> ~# rsync -ah --progress /root/test-file_1000MB /mnt/ceph/test-file_100=
0MB
> >> sending incremental file list
> >> test-file_1000MB
> >>            1.00G 100%   90.53MB/s    0:00:10 (xfr#1, to-chk=3D0/1)
> >>
> >> I attach some ceph reports taking before, during and after an rsync on=
 a bad
> >> kernel (5.6.0) for debugging.
> >
> > I see two CephFS data pools and one of them is nearfull:
> >
> >      "pool": 10,
> >      "pool_name": "cephfs_data",
> >      "create_time": "2020-11-22T08:19:53.701636+0100",
> >      "flags": 1,
> >      "flags_names": "hashpspool",
> >
> >      "pool": 11,
> >      "pool_name": "cephfs_data_ec",
> >      "create_time": "2020-11-22T08:22:01.779715+0100",
> >      "flags": 2053,
> >      "flags_names": "hashpspool,ec_overwrites,nearfull",
> >
> > How is this CephFS filesystem is configured?  If you end up writing to
> > cephfs_data_ec pool there, the slowness is expected.  nearfull makes
> > the client revert to synchronous writes so that it can properly return
> > ENOSPC error when nearfull develops into full.  That is the whole point
> > of the commit that you landed upon when bisecting so of course
> > reverting it helps:
> >
> > -   if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > +   if ((map_flags & CEPH_OSDMAP_NEARFULL) ||
> > +       (pool_flags & CEPH_POOL_FLAG_NEARFULL))
> >              iocb->ki_flags |=3D IOCB_DSYNC;
>
> Well, that effect is not documented in the commit message, and for the
> user it=E2=80=99s a regression, that the existing (for the user working)
> configuration performs worse after updating the Linux kernel. That
> violates Linux=E2=80=99 no-regression policy, and at least needs to be be=
tter
> documented and explained.

Hi Paul,

This isn't a regression -- CephFS has always behaved this way.  In
fact, these states (nearfull and full) used to be global meaning that
filling up some random pool, completely unrelated to CephFS, still
lead to synchronous behavior!

This was fixed in the Mimic release.  These states became per-pool
and the global CEPH_OSDMAP_NEARFULL and CEPH_OSDMAP_FULL flags were
deprecated.  The referenced commit just caught the kernel client up
with that OSD-side change -- which is a definite improvement.

Unfortunately this catch up was almost two years late (Mimic went out
in 2018).  The users shouldn't have noticed: our expectation was that
the global flags would continue to be set for older clients to ensure
that such clients could revert to synchronous writes as before.
However, as noted in the commit message, the deprecation change turned
out to be backwards incompatible by mistake and the net effect was that
the global flags just stopped being set.  As a result, for a Mimic (or
later) cluster + any kernel client combination, synchronous behavior
just vanished and _this_ was a regression.  After a while Yanhu noticed
and reported it.

So the commit in question actually fixes a regression, not introduces
one.  You just happened to ran into a case of a nearfull pool with
a newer cluster and an older kernel client.  Had global -> per-pool
flags change in Mimic been backwards compatible as intended, you would
have encountered a performance drop immediately after cephfs_data_ec
pool had exceeded nearfull watermark.

The reason for the synchronous behavior is that, thanks to an advanced
caps system [1], CephFS clients can buffer pretty large amounts of data
as well as carry out many metadata operations locally.  If the pool is
nearing capacity, determining whether there is enough space left for
all that data is tricky.  Switching to performing writes synchronously
allows the client to generate ENOSPC error in a timely manner.

[1] https://www.youtube.com/watch?v=3DVgNI5RQJGp0

Hope this explanation helps!

                Ilya
