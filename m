Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9C739A4B1
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 17:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFCPjK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 11:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCPjI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Jun 2021 11:39:08 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED077C061756
        for <ceph-devel@vger.kernel.org>; Thu,  3 Jun 2021 08:37:23 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id i13so241454ilk.3
        for <ceph-devel@vger.kernel.org>; Thu, 03 Jun 2021 08:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cGDEFuAPZRnQLcM0Fs5Ee9R0uwGueX8Ps7pyiK4LRRo=;
        b=fIHiQMRANzOMpGRDF4UjmE4VsXO2Y4QOUe3ujDwkzDYZNOIKI8XUiUgrKKVis3KuyO
         0QCWvANfMq/4wh1+u4n2Z+Px9HvBKZQ7QsLEWBiyTNDmoCHEXuZRNKDizqdZfBnPvWia
         N3zaBUjB2D69YPHRy+JWZhkbR8u58AHeRj7P/uF8i4c9I5qBS9ZOFANnYDgNuflzNx7n
         zf870ajLxIBabAbhToqSGmk7UVzXuTKOffTDAOE1oFZq/cf5OOY1kkTXhaFBp8tBsnBw
         FjibByjakV7TcRuuPxf/2iBrjnXsoeh40phP5spGJ77fazE2NqrkWMdqDCSHfpqCpYMw
         +A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cGDEFuAPZRnQLcM0Fs5Ee9R0uwGueX8Ps7pyiK4LRRo=;
        b=bSrsXBIJI9i/FXycaNCtrUWOsxvFUqauRhYJERLzYXmIfJzrl8/yVW7fWw4bN5RI5P
         /4oWO2XEIKwIVCPnA69OZZgBHf32u065448BCUy9wn/zt/dsyVDSi8VrjNICeXvWfF0v
         3uUqv5ntR2wEHun1vAxCZDCbgNP4OjWWAWliYMuqvpZ4dEYi0n5XmdH9IiQEAHsRn2Ux
         mXxRoo0zjv8nJVQ871+MHHTcA82WxAGCrPcdpJVd91Bwioq8uZg3TqHJCZ2ZQULKllFy
         1ESgBK4K6aXO8NXi9TVM9a4d8v+EslAvmx5ht6cPuQL6PGWDkaxxSFSiJYS8xXEr/DbX
         /+hw==
X-Gm-Message-State: AOAM532TyONr+VsIW8QUFxqDGr0Q3l6qBlw9x1Yzaos3xE7NY/3+HkNX
        vJjWEpLKtsDBgEq6sOvIlbB+pOQwkKx9ooHksNOvR7UD6Ods5w==
X-Google-Smtp-Source: ABdhPJyKwMCmyJbu4LaxHW2t08ydGMPepaCxunzkKm4stSjrFTgdSvKfYG80Hgdc7LBm9GaFlWmGotT6HCKpXWPkkmQ=
X-Received: by 2002:a92:c26f:: with SMTP id h15mr375602ild.281.1622734643201;
 Thu, 03 Jun 2021 08:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210603133914.79072-1-jlayton@kernel.org> <CAOi1vP_UFhGVP3Nf7chj9J7q12BYdKguPLudddPdJHnd3G_3WQ@mail.gmail.com>
 <cf3be8010edddaf786b761ec98610b0bbe9ccbd3.camel@kernel.org>
 <CAOi1vP-yTHK_wB_akxJxZ5bzrrOGjby00SbvQSn=6c-hkW7RgQ@mail.gmail.com>
 <8a53dc688023bd08b530289fbd4ba502b70f2893.camel@kernel.org>
 <CAOi1vP_kmfVPXNVAip0c99bLBKAC2cCKDPsP3W6=wj4+Vm_osA@mail.gmail.com> <d187d44acaf8ed5ee9d706e9147090ba88ba6759.camel@kernel.org>
In-Reply-To: <d187d44acaf8ed5ee9d706e9147090ba88ba6759.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 3 Jun 2021 17:37:26 +0200
Message-ID: <CAOi1vP-T661YaUL5z1v-xYwXGqZ5BR6qjBjhLD-b3ROzbraWYw@mail.gmail.com>
Subject: Re: [PATCH] ceph: decoding error in ceph_update_snap_realm should
 return -EIO
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 3, 2021 at 5:20 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2021-06-03 at 17:19 +0200, Ilya Dryomov wrote:
> > On Thu, Jun 3, 2021 at 4:42 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > On Thu, 2021-06-03 at 16:33 +0200, Ilya Dryomov wrote:
> > > > On Thu, Jun 3, 2021 at 4:02 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > >
> > > > > On Thu, 2021-06-03 at 15:57 +0200, Ilya Dryomov wrote:
> > > > > > On Thu, Jun 3, 2021 at 3:39 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > > >
> > > > > > > Currently ceph_update_snap_realm returns -EINVAL when it hits a decoding
> > > > > > > error, which is the wrong error code. -EINVAL implies that the user gave
> > > > > > > us a bogus argument to a syscall or something similar. -EIO is more
> > > > > > > descriptive when we hit a decoding error.
> > > > > > >
> > > > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > > > ---
> > > > > > >  fs/ceph/snap.c | 2 +-
> > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > > > > > index d07c1c6ac8fb..f8cac2abab3f 100644
> > > > > > > --- a/fs/ceph/snap.c
> > > > > > > +++ b/fs/ceph/snap.c
> > > > > > > @@ -807,7 +807,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> > > > > > >         return 0;
> > > > > > >
> > > > > > >  bad:
> > > > > > > -       err = -EINVAL;
> > > > > > > +       err = -EIO;
> > > > > > >  fail:
> > > > > > >         if (realm && !IS_ERR(realm))
> > > > > > >                 ceph_put_snap_realm(mdsc, realm);
> > > > > >
> > > > > > Hi Jeff,
> > > > > >
> > > > > > Is this error code propagated anywhere important?
> > > > > >
> > > > > > The vast majority of functions that have something to do with decoding
> > > > > > use EINVAL as a default (usually out-of-bounds) error.  I agree that it
> > > > > > is totally ambiguous, but EIO doesn't seem to be any better to me.  If
> > > > > > there is a desire to separate these errors, I think we need to pick
> > > > > > something much more distinctive.
> > > > > >
> > > > >
> > > > > When I see EINVAL, I automatically wonder what bogus argument I passed
> > > > > in somewhere, so I find that particularly deceptive here where the bug
> > > > > is either from the MDS or we had some sort of low-level socket handling
> > > > > problem.
> > > > >
> > > > > OTOH, you have a good point. The callers universally ignore the error
> > > > > code from this function. Perhaps we ought to just log a pr_warn message
> > > > > or something if the decoding fails here instead?
> > > >
> > > > There already is one:
> > > >
> > > >  793 bad:
> > > >  794         err = -EINVAL;
> > > >  795 fail:
> > > >  796         if (realm && !IS_ERR(realm))
> > > >  797                 ceph_put_snap_realm(mdsc, realm);
> > > >  798         if (first_realm)
> > > >  799                 ceph_put_snap_realm(mdsc, first_realm);
> > > >  800         pr_err("update_snap_trace error %d\n", err);
> > > >  801         return err;
> > > >
> > > > Or do you mean specifically the "bad" label?
> > > >
> > >
> > > Well, if we have a distinctive error code there, then we won't need a
> > > separate pr_err message or anything. I still think that -EINVAL is not
> > > descriptive of the issue though. I suppose if -EIO is too vague, we
> > > could use something like -EILSEQ ?
> >
> > In a sense it is an invalid argument because the buffer passed to the
> > decoding function is too short.  This is what would lead to EINVAL here
> > and in many other decoding-related functions.
> >
> > EINVAL is the standard error code for "buffer/message too short" in
> > many other APIs.  EILSEQ is certainly more distinctive, but I'm not
> > sure it is the "right" error code for this kind of error.
> >
>
> The issue is that almost everywhere else, decoding routines use -EIO for
> this. This function is a special snowflake. Why? I don't see any
> justification for it.

Ah, indeed I see that there is precedent for using EIO for this in
fs/ceph (although this particular EINVAL goes back to 2009).  I just
wanted to keep things consistent with libceph and rbd where it is
mostly EINVAL.

Sorry for the noise.

Thanks,

                Ilya
