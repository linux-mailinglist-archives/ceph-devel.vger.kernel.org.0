Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A33F653D10
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Dec 2022 09:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiLVIii (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Dec 2022 03:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLVIie (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 22 Dec 2022 03:38:34 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CEC2036A
        for <ceph-devel@vger.kernel.org>; Thu, 22 Dec 2022 00:38:29 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b69so1954557edf.6
        for <ceph-devel@vger.kernel.org>; Thu, 22 Dec 2022 00:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOyvB+9DMedk5xBkyXY7oPTRPN1ln9kgFydmeUxbnlQ=;
        b=KQpzRO1YAET8R9ofmHKLErpVDhOuLgRjx46JO7fP666/T1uc9D8+mJ/3sx3r+ZmkDr
         +SMwbJn3itSTL4QFLjZv9HQ2NPXlgMLu5GUO1esNc4meECe5A4s9IDJqHhw+3U7EH0UC
         04fe1jnrmC57eiuuzlatslftuRR6Ko+9bc1ZsGEzap7vdZFkp+4zxgkcDu+9r2FhNTyb
         bR/8EH0Ne3AGvMRBQ0OiKSZnpiNTQZxDieXFvBmKQbzQkUllIHlJikyZCXmi60V/xzFv
         JmlJocqWBad/vzBZJFG3c6WPI3+HfI2q1KE1A+mx4wllHp3k0lNkjr6DddIfw4nU3j4L
         3SiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iOyvB+9DMedk5xBkyXY7oPTRPN1ln9kgFydmeUxbnlQ=;
        b=7IvyHXkwH/P8ECBrk/KpzErZe4gr4LRHg9KzkmqPDT3U5dcRIQEblV+WVlrK63CJjK
         HQ814MfUblljbJK8Z1cOHikkY+c0nNdyYzvePDYUOxQ4TRT4P/DFPyb0R+dasniSrEeq
         iG+0gDg7P6RiG7+kmUQiQKoXbRdxcKofAsZLwH6ViWDvOVP9y4gSiVRWpjtGMjgGvQ/b
         Wn7LC78F8Q1LXc78zxxnjZNY5pTLZbsXA6OIj+oIo8Ye032kLDrtKzBRWnO9dzkPApg9
         vJiiC6XaP0HfOm7byQJTayL9M/rd3XKrRppXPLj+R1RrAx4uQ0YoZO79xhU8ABqx5Cou
         fdnQ==
X-Gm-Message-State: AFqh2kqBpARS7zGncaw8jui/TYelFpidx3gj/b+L32njnPACUjPjP4yf
        CfeQv6UopBv/Z6F3A6gjO8hU4e1356D4jJzddxR5YcIZyrk=
X-Google-Smtp-Source: AMrXdXvzp2wquJeUrhdewe6BOxyYHVvZshcHj1T5w327GHDgY/7HTo0fMfY1VvqfTbBT92/jpMoSNFn6Mg5SF96yktg=
X-Received: by 2002:aa7:c658:0:b0:46c:f631:c0e6 with SMTP id
 z24-20020aa7c658000000b0046cf631c0e6mr643648edr.251.1671698308494; Thu, 22
 Dec 2022 00:38:28 -0800 (PST)
MIME-Version: 1.0
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
 <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
 <4c039a76-b638-98b7-1104-e81857df8bcd@redhat.com> <9b714315c8934da38449eb2ce5b85cfc@mpinat.mpg.de>
 <70e8a12c-d94e-7784-c842-cbdd87ff438e@redhat.com> <62582bb6b2124f1a9dd111f29049b25b@mpinat.mpg.de>
 <a6091b92-c216-e525-0bc7-5515225f6dc8@molgen.mpg.de> <a212e2465caf4c7da3aa1fe0e094831f@mpinat.mpg.de>
In-Reply-To: <a212e2465caf4c7da3aa1fe0e094831f@mpinat.mpg.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 22 Dec 2022 09:38:16 +0100
Message-ID: <CAOi1vP-g2no3i91SshzcWb8XY6aup4h_GcO6Le=caM8-XmXGnQ@mail.gmail.com>
Subject: Re: PROBLEM: CephFS write performance drops by 90%
To:     "Roose, Marco" <marco.roose@mpinat.mpg.de>
Cc:     "Menzel, Paul" <pmenzel@molgen.mpg.de>,
        Xiubo Li <xiubli@redhat.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
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

Hi Marco,

Here is the revert on top of 6.1 (currently only build-tested):

https://github.com/ceph/ceph-client/commit/b45280b209388082a0880eb7d348436c=
c0a6ee6d

Also, can you share "ceph report | jq .osdmap" output captured before,
during (in the middle of it going at <10M/s) and after the test?

Thanks,

                Ilya

On Mon, Dec 19, 2022 at 12:59 PM Roose, Marco <marco.roose@mpinat.mpg.de> w=
rote:
>
> [...]
> > Marco, if you have time, it=E2=80=99d be great if you tested Liunx 5.6-=
rc7 and 5.6, where the commit entered Linus=E2=80=99 master branch.
>
> already did it: as expected RC7 is fine 5.6 shows the exact problem
>
> Kind regards,
> Marco Roose
>
> -----Original Message-----
> From: Paul Menzel <pmenzel@molgen.mpg.de>
> Sent: 19 December 2022 12:46
> To: Xiubo Li <xiubli@redhat.com>; Roose, Marco <marco.roose@mpinat.mpg.de=
>
> Cc: Ilya Dryomov <idryomov@gmail.com>; ceph-devel@vger.kernel.org
> Subject: Re: PROBLEM: CephFS write performance drops by 90%
>
> Dear Xiubo,
>
>
> Am 19.12.22 um 11:48 schrieb Roose, Marco:
>
> > my colleague Paul (in CC) tried to revert the commit, but it was'nt
> > possible.
>
> > -----Original Message-----
> > From: Xiubo Li <xiubli@redhat.com>
> > Sent: 19 December 2022 01:16
> > To: Roose, Marco <marco.roose@mpinat.mpg.de>; Ilya Dryomov
> > <idryomov@gmail.com>
> > Cc: Ceph Development <ceph-devel@vger.kernel.org>
> > Subject: Re: PROBLEM: CephFS write performance drops by 90%
>
> [=E2=80=A6]
>
> > Since you are here, could you try to revert this commit and have a try =
?
> >
> > Let's see whether is this commit causing it. I will take a look later
> > this week.
>
> Unfortunately, reverting the commit is not easily possible, as the code w=
as changed afterward too. It=E2=80=99d be great if you provided a git branc=
h with the commit reverted.
>
> Marco, if you have time, it=E2=80=99d be great if you tested Liunx 5.6-rc=
7 and 5.6, where the commit entered Linus=E2=80=99 master branch.
>
>
> Kind regards,
>
> Paul
