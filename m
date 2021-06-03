Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400D539A465
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 17:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhFCPWI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 11:22:08 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:43881 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhFCPWE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Jun 2021 11:22:04 -0400
Received: by mail-io1-f54.google.com with SMTP id k16so6651077ios.10
        for <ceph-devel@vger.kernel.org>; Thu, 03 Jun 2021 08:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kaGUdgVz0yLtTiE3c7CT0OZCJ67ypnVXLX8x9RbCQXM=;
        b=apt79RidJh33QK1GWs9Qva/qpCTN36i3MYp7abj6kIfusF419tr6/4b7ul6OqaJ5/f
         peH+hBpH3yXtnB4qcqeig834Bz1qVkikXqz30I9LaP8oko8FZcWCZhO64th1cWSjzt+Z
         BndiKxfGTsvJb4nGub/NLlEcfm5RTkHGLtpAw1RFa9ldyJOjpHbqKCzR3bmhBPGsBGhC
         /ZIYpW2Uu8IOfXhE6lAuYoMP5dsNbTBx5OdFYUVnw79iqSTqJIvckeX3Ma14CBgVgvrk
         MAGEirjK3afGzpihVkUpBqUtTAu/bLbuz5Bf/qDwZYurZHPuGAe+BkpN6Vnt/fXQHvmf
         H/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kaGUdgVz0yLtTiE3c7CT0OZCJ67ypnVXLX8x9RbCQXM=;
        b=rW0wpLSvF5+4GwvYg7oTFqjJeXhKHMGedTj2W4VqnfKbSfslvccCJufVh3TdQDYHC0
         gIdiIrMogN7D9T7z8tTwS6WFmcr/Ly2SZQtioMAiel9vGslhQvl/juo6+l3xfu/ZddjC
         VH9tYVJwmSBOIOvSohIvhfDTkxE+rWZGWzGNSsSTpaELEQevtihRv6/xnLMo0WVD3Mu3
         W8QHnTww/ziyfvDUTfa5MxGkOia/vkClTJbyLBzI5L0Z+Wh19LCiGViabDmxAkjltmGA
         Mb7f+OoHxO5f7lBiO3gQgtef7jIapkFgyLMresgrbVRjQUBDTfls5+CX984WMz/B5Jmc
         nqtQ==
X-Gm-Message-State: AOAM530qcjtiRbQ2jHqg5TnM35vxs37GtuPROdZyeyBk47h7lOozXqtd
        lJ9tDa6efM2N5PJDH5TfXfo7gGdAqhXFegEnZGc=
X-Google-Smtp-Source: ABdhPJw2VhuQ2S3c+kS18nYVShHtwUGoSlH5aFNSLSD+dHLCCln4gBce4Nd23Jk2anAVyRdnxBIy1tcI80uhknLzKaU=
X-Received: by 2002:a6b:f314:: with SMTP id m20mr81153ioh.7.1622733558855;
 Thu, 03 Jun 2021 08:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210603133914.79072-1-jlayton@kernel.org> <CAOi1vP_UFhGVP3Nf7chj9J7q12BYdKguPLudddPdJHnd3G_3WQ@mail.gmail.com>
 <cf3be8010edddaf786b761ec98610b0bbe9ccbd3.camel@kernel.org>
 <CAOi1vP-yTHK_wB_akxJxZ5bzrrOGjby00SbvQSn=6c-hkW7RgQ@mail.gmail.com> <8a53dc688023bd08b530289fbd4ba502b70f2893.camel@kernel.org>
In-Reply-To: <8a53dc688023bd08b530289fbd4ba502b70f2893.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 3 Jun 2021 17:19:21 +0200
Message-ID: <CAOi1vP_kmfVPXNVAip0c99bLBKAC2cCKDPsP3W6=wj4+Vm_osA@mail.gmail.com>
Subject: Re: [PATCH] ceph: decoding error in ceph_update_snap_realm should
 return -EIO
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 3, 2021 at 4:42 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2021-06-03 at 16:33 +0200, Ilya Dryomov wrote:
> > On Thu, Jun 3, 2021 at 4:02 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > On Thu, 2021-06-03 at 15:57 +0200, Ilya Dryomov wrote:
> > > > On Thu, Jun 3, 2021 at 3:39 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > >
> > > > > Currently ceph_update_snap_realm returns -EINVAL when it hits a decoding
> > > > > error, which is the wrong error code. -EINVAL implies that the user gave
> > > > > us a bogus argument to a syscall or something similar. -EIO is more
> > > > > descriptive when we hit a decoding error.
> > > > >
> > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > ---
> > > > >  fs/ceph/snap.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > > > index d07c1c6ac8fb..f8cac2abab3f 100644
> > > > > --- a/fs/ceph/snap.c
> > > > > +++ b/fs/ceph/snap.c
> > > > > @@ -807,7 +807,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> > > > >         return 0;
> > > > >
> > > > >  bad:
> > > > > -       err = -EINVAL;
> > > > > +       err = -EIO;
> > > > >  fail:
> > > > >         if (realm && !IS_ERR(realm))
> > > > >                 ceph_put_snap_realm(mdsc, realm);
> > > >
> > > > Hi Jeff,
> > > >
> > > > Is this error code propagated anywhere important?
> > > >
> > > > The vast majority of functions that have something to do with decoding
> > > > use EINVAL as a default (usually out-of-bounds) error.  I agree that it
> > > > is totally ambiguous, but EIO doesn't seem to be any better to me.  If
> > > > there is a desire to separate these errors, I think we need to pick
> > > > something much more distinctive.
> > > >
> > >
> > > When I see EINVAL, I automatically wonder what bogus argument I passed
> > > in somewhere, so I find that particularly deceptive here where the bug
> > > is either from the MDS or we had some sort of low-level socket handling
> > > problem.
> > >
> > > OTOH, you have a good point. The callers universally ignore the error
> > > code from this function. Perhaps we ought to just log a pr_warn message
> > > or something if the decoding fails here instead?
> >
> > There already is one:
> >
> >  793 bad:
> >  794         err = -EINVAL;
> >  795 fail:
> >  796         if (realm && !IS_ERR(realm))
> >  797                 ceph_put_snap_realm(mdsc, realm);
> >  798         if (first_realm)
> >  799                 ceph_put_snap_realm(mdsc, first_realm);
> >  800         pr_err("update_snap_trace error %d\n", err);
> >  801         return err;
> >
> > Or do you mean specifically the "bad" label?
> >
>
> Well, if we have a distinctive error code there, then we won't need a
> separate pr_err message or anything. I still think that -EINVAL is not
> descriptive of the issue though. I suppose if -EIO is too vague, we
> could use something like -EILSEQ ?

In a sense it is an invalid argument because the buffer passed to the
decoding function is too short.  This is what would lead to EINVAL here
and in many other decoding-related functions.

EINVAL is the standard error code for "buffer/message too short" in
many other APIs.  EILSEQ is certainly more distinctive, but I'm not
sure it is the "right" error code for this kind of error.

Thanks,

                Ilya
