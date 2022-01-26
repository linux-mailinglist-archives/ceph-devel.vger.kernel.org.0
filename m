Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216E949CFF8
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 17:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243278AbiAZQrt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jan 2022 11:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243231AbiAZQrr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jan 2022 11:47:47 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369F5C06161C
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 08:47:47 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id e17so5103747uad.9
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 08:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q26c38Dv9iOVKeh+Y5RxXhJixncp+pZfXURkksHkiJU=;
        b=lxAiklQIa0NNx951i9WYbAyTzS4ffIHsm/koewJlR6Q0ehnpuRV6hyTkFArfTkM0dp
         UdQiXtVvkD99UkHPoDQHIOelaNvJJiXzgsoNz+04eEaExXu/4904BMyT2GqUa3qdqr0Z
         n6LIp3eqCMI6yLnOadJYkkfi6uFa2q/U6tyZQsLl68lwcpO3piM5PhVFjfHlfkfFQLph
         NGOjALw36FVIYktxx8VHjIWTF5k36deqjBKR9Y0y4yLjHZ+ZWNjj1YNEih4mKY5HQINd
         LjmTkSx7vkgd2EYLxRPB6ttBdMufwzLld+057qZuQrn9LCQwfAuTeAAtOvsJSgU00Zwe
         C8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q26c38Dv9iOVKeh+Y5RxXhJixncp+pZfXURkksHkiJU=;
        b=3zqXkQrU653gctRZF12Qrhn1AY5kVVO6Bic6F+n7Ey2zeJIvN3hG6iLBoxQ1MEmP5z
         NetDdfhkhOcrOTW0Rb+9XmF6juEgAimny4sZedrACl2EhHyIqMBBEV3V4LEJyB8KBh3D
         69+c3P89DhBG/8hVfGt+zXHG5u6PLXwYEeogGd5IoQvxGp0cOo8rh7KuWnmNobIbni4C
         dVQbqeSEIMz+ZOn5tTKBKWOY5bJTPKNiSrcFMk+u1LJFapr9CnZStYhQ16+xvC5y/hMe
         xQtLxd9y4x+rRPX2kSc5/Z+E9SfjY2QA57BHL754VZDsRmfGsnMYeJSWuQTKJWuuzFEd
         xgeQ==
X-Gm-Message-State: AOAM531D3ZKjaqww1q/JMyrjQtaR6Wj6UM8u3P6aNKLCI3wwe51jeipH
        aE7GGPtr/nK8/3skc9Qe/ReFdGWSHDkIs29bDIE=
X-Google-Smtp-Source: ABdhPJwgScICo/chdEw8GTXqiGyfg1z/905ltk+ApKxKr+LxfFmV0MYyoXVTYDi+O1nWyqgwQ6T97j3weYncP4IeJfo=
X-Received: by 2002:a67:fc47:: with SMTP id p7mr4474656vsq.14.1643215666359;
 Wed, 26 Jan 2022 08:47:46 -0800 (PST)
MIME-Version: 1.0
References: <20220125210842.114067-1-jlayton@kernel.org> <CAOi1vP8zhO4omTv2eVb43KbsqL4iqxi9FW55K7cXi8ue-NuUKQ@mail.gmail.com>
 <b886282e58dfcda09e4d9336c60b2732c4c9764c.camel@kernel.org>
In-Reply-To: <b886282e58dfcda09e4d9336c60b2732c4c9764c.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 26 Jan 2022 17:47:55 +0100
Message-ID: <CAOi1vP_ga=gwP5W1__6+cBMOgSNJU5o+8Z9sY0Z5Dmfs_DzU-A@mail.gmail.com>
Subject: Re: [PATCH] ceph: properly put ceph_string reference after async
 create attempt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 26, 2022 at 5:25 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2022-01-26 at 17:22 +0100, Ilya Dryomov wrote:
> > On Tue, Jan 25, 2022 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > The reference acquired by try_prep_async_create is currently leaked.
> > > Ensure we put it.
> > >
> > > Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/file.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index ea1e9ac6c465..cbe4d5a5cde5 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -766,8 +766,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> > >                                 restore_deleg_ino(dir, req->r_deleg_ino);
> > >                                 ceph_mdsc_put_request(req);
> > >                                 try_async = false;
> > > +                               ceph_put_string(rcu_dereference_raw(lo.pool_ns));
> > >                                 goto retry;
> > >                         }
> > > +                       ceph_put_string(rcu_dereference_raw(lo.pool_ns));
> > >                         goto out_req;
> > >                 }
> > >         }
> > > --
> > > 2.34.1
> > >
> >
> > Hi Jeff,
> >
> > Where is the try_prep_async_create() reference put in case of success?
> > It doesn't look like ceph_finish_async_create() actually consumes it.
> >
>
> The second call above puts it in the case of success, or in the case of
> any error that isn't -EJUKEBOX.

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
