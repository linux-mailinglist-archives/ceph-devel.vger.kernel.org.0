Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876AA49CFF0
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 17:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243242AbiAZQq2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jan 2022 11:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbiAZQq0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jan 2022 11:46:26 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DF2C06161C
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 08:46:26 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id b16so43933755uaq.4
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 08:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r6yV64GSkRKUOiGI9vVTf1LEBEgmtsIiXrWasYNlIVk=;
        b=SdcmEgoK3u8KKNNKn+U08/WXhtHR6ompSkyABbHX/iFssC4T+uQ9YuZwhywMpb3T4C
         Mor5vsrz0LVA4q0dS4yL3VX+bQ0m/TmNON5QPI7NJwNX2Qu6GxmdoBpgm7pIcWK5YEBQ
         z05PhRh/6niI+/VKqFFxKoYpMK3qIK9a+gAw8oRWae936/REVNy2raqhyxXZbb4A74nq
         syT3AxpAxu+KaarRd3Uz+l6CJh4mpKzs8Rlxj0kmZJz+c+K8WrGfxZ32saUDAe0O0YXO
         r1w+1tMpS1HqTblSfVc+Ly357zrw5puy1DPTyL0GYeYoJ0cT42rPSck2mjRmVVbr9QGR
         jBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r6yV64GSkRKUOiGI9vVTf1LEBEgmtsIiXrWasYNlIVk=;
        b=SMrt1+SWMK5A4qV+Lk9qx8ramk3Q1qMaX42xUgf5gFFbb6SN5344zI7Zzkb17HTK9b
         MSAqHNNzry2pflD+i7zMsPaxfk7rILWH/411NWp6cqH1JQMjHHFoTAIQrHMFv9RVzk7m
         HArSaOK21EfUa3qMCPe4TeKgMRoMuI01CF+W6oHFKVIdgXvAWjfgHTCOazSaVA3voF/d
         uqqIUuxO5PILxz28BMbRyo/euuA6oSeiWjV8bQvtOIb2Ee1EzHjGuYBYJhhFX5NbInaQ
         /1lNJHfSNb4JEvepMqw3Q/kygL91EwLvWu81WWWtdMI/M1dr8NfWqAN6qB5vYOazTfGB
         nlDg==
X-Gm-Message-State: AOAM5331Yxvcd1SpHaYn5bUkPXKnHDm7NwSNS08EL2kohFUysTq2cQXY
        Ps/JGn+KJFu0nqgKVL+g3rr0S/L5rQ8fI4Z3CgjGWhjkuMY=
X-Google-Smtp-Source: ABdhPJyjoPgM+d9vuFFWHiXb5/G2U8g6yqmh1LrogK53a5N4gh1gu8vpuZhDQzXNJJ3KuAt5e6uR1hPE0q6g8NyMCuw=
X-Received: by 2002:a67:fad4:: with SMTP id g20mr10169239vsq.65.1643215585440;
 Wed, 26 Jan 2022 08:46:25 -0800 (PST)
MIME-Version: 1.0
References: <20220125211022.114286-1-jlayton@kernel.org> <CAOi1vP-W=k=dAmMoXCfQ4McyyP-boRYCdUF6HthCNyfgbOzNWw@mail.gmail.com>
 <eb79dcdabcc2b90ffbcf3b0b3cce29ed6fdd7480.camel@kernel.org>
In-Reply-To: <eb79dcdabcc2b90ffbcf3b0b3cce29ed6fdd7480.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 26 Jan 2022 17:46:34 +0100
Message-ID: <CAOi1vP_crgq=KXBt2oaptzE8=vBi58J3jm_AYEXihBW_jv_Dig@mail.gmail.com>
Subject: Re: [PATCH] ceph: set pool_ns in new inode layout for async creates
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan van der Ster <dan@vanderster.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 26, 2022 at 5:34 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2022-01-26 at 17:23 +0100, Ilya Dryomov wrote:
> > On Tue, Jan 25, 2022 at 10:10 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > Dan reported that he was unable to write to files that had been
> > > asynchronously created when the client's OSD caps are restricted to a
> > > particular namespace.
> > >
> > > The issue is that the layout for the new inode is only partially being
> > > filled. Ensure that we populate the pool_ns_data and pool_ns_len in the
> > > iinfo before calling ceph_fill_inode.
> > >
> > > Reported-by: Dan van der Ster <dan@vanderster.com>
> > > Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/file.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index cbe4d5a5cde5..efea321ff643 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -599,6 +599,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> > >         struct ceph_inode_info *ci = ceph_inode(dir);
> > >         struct inode *inode;
> > >         struct timespec64 now;
> > > +       struct ceph_string *pool_ns;
> > >         struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
> > >         struct ceph_vino vino = { .ino = req->r_deleg_ino,
> > >                                   .snap = CEPH_NOSNAP };
> > > @@ -648,11 +649,17 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> > >         in.max_size = cpu_to_le64(lo->stripe_unit);
> > >
> > >         ceph_file_layout_to_legacy(lo, &in.layout);
> > > +       pool_ns = ceph_try_get_string(lo->pool_ns);
> > > +       if (pool_ns) {
> > > +               iinfo.pool_ns_len = pool_ns->len;
> > > +               iinfo.pool_ns_data = pool_ns->str;
> > > +       }
> >
> > Considering that we have a reference from try_prep_async_create(), do
> > we actually need to bother with ceph_try_get_string() here?
> >
>
> Technically, no. We could just do a rcu_dereference_protected there
> since we know that lo is private and can't change. Want me to send a v2?

Yeah, let's not do the reference dance when it isn't needed.

I'd probably use rcu_dereference_raw() to avoid having to think about
omitted READ_ONCE (even if the reasoning is trivial), but up to you.

Thanks,

                Ilya
