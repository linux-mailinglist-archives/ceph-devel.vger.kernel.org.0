Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9114539A34A
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 16:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhFCOf0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 10:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhFCOfZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Jun 2021 10:35:25 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C40FC06174A
        for <ceph-devel@vger.kernel.org>; Thu,  3 Jun 2021 07:33:27 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id q7so6539743iob.4
        for <ceph-devel@vger.kernel.org>; Thu, 03 Jun 2021 07:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dFptkZZ+BOtwzWCaoguP20DTS+q15N56bnFN2qFhZyY=;
        b=tjnux/8mt2n4ruB5iD37MKB0glG+OZnBvtSveUPC7CjC7wc8L8Tc493oS3jjKmoKE/
         iEacGBlU0+p0YpFwT3YYWMd7/NGd7FQC+iEQ6BJJ5fT5nn1q+7Cvg+SwzuY29OOdHZ+u
         a6rTvah6Dftv3DmHt+fgQziU8ErzrkrcT+N6XcRiUQhVLBoQfc1W6hZ+uLzZdHxJfCIx
         UNbyOWaOGMOFcD2UzEjyoAbDck8yf+LviGcsx+E6R9dLGVP9rb/jLxGxw2DhGLF80k1q
         aHPbzz0DVfq+Yo64svYPSinZtY4LiP8poczFJtpzQdXa/aemMP5VKx9XACsfatIB8WUj
         LsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dFptkZZ+BOtwzWCaoguP20DTS+q15N56bnFN2qFhZyY=;
        b=W1mkpiDzT0idmOxePOqbUMyTLKz4OpSz8dBQnSgVXQ7UVbnRRwK77nmNMfPvD+i9pS
         MxzK+WckQZcHfrVdDKrgCOK68RAMWx5W0t64sZrrqisDHPHirlrs1fwzcjby3VwcgM3U
         ofMIIp7nbqNBvQbhQpLtzzG4uqFDSUHZZWjuElIkFetCCAVOYpXvv6rRyMZJb85NTu5a
         wIB17cPboi9ofPu/IKY442aAVP9r+H5zFurYtIsXtNh+mZtJUCLaRi9TRFp/2zT+Y2fI
         CGAXV7ZWwPFbpNNZ1d+JCr2p5HYi65ibFmRizgoodVIlWrPAC31upI+DHlBB1ivHZNmD
         71Qg==
X-Gm-Message-State: AOAM532rOSeEZm20km28PkukTB/zWWrXiXDCIIFqY49tyc9pz1xMS4DF
        IOsF35ZKfrf7lOT3yzRGPqxllMKsY7TofDj/Uzs=
X-Google-Smtp-Source: ABdhPJzK9T4r+NIZiU2D7euUB5Xhb40eDBk2tB7JNcXJszNclGM/tUFpOSYw0Vit2wrez8kQY2k9ZGwgGYMx2j06b0A=
X-Received: by 2002:a05:6602:4c:: with SMTP id z12mr30107849ioz.191.1622730806871;
 Thu, 03 Jun 2021 07:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210603133914.79072-1-jlayton@kernel.org> <CAOi1vP_UFhGVP3Nf7chj9J7q12BYdKguPLudddPdJHnd3G_3WQ@mail.gmail.com>
 <cf3be8010edddaf786b761ec98610b0bbe9ccbd3.camel@kernel.org>
In-Reply-To: <cf3be8010edddaf786b761ec98610b0bbe9ccbd3.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 3 Jun 2021 16:33:29 +0200
Message-ID: <CAOi1vP-yTHK_wB_akxJxZ5bzrrOGjby00SbvQSn=6c-hkW7RgQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: decoding error in ceph_update_snap_realm should
 return -EIO
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 3, 2021 at 4:02 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2021-06-03 at 15:57 +0200, Ilya Dryomov wrote:
> > On Thu, Jun 3, 2021 at 3:39 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > Currently ceph_update_snap_realm returns -EINVAL when it hits a decoding
> > > error, which is the wrong error code. -EINVAL implies that the user gave
> > > us a bogus argument to a syscall or something similar. -EIO is more
> > > descriptive when we hit a decoding error.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/snap.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > index d07c1c6ac8fb..f8cac2abab3f 100644
> > > --- a/fs/ceph/snap.c
> > > +++ b/fs/ceph/snap.c
> > > @@ -807,7 +807,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> > >         return 0;
> > >
> > >  bad:
> > > -       err = -EINVAL;
> > > +       err = -EIO;
> > >  fail:
> > >         if (realm && !IS_ERR(realm))
> > >                 ceph_put_snap_realm(mdsc, realm);
> >
> > Hi Jeff,
> >
> > Is this error code propagated anywhere important?
> >
> > The vast majority of functions that have something to do with decoding
> > use EINVAL as a default (usually out-of-bounds) error.  I agree that it
> > is totally ambiguous, but EIO doesn't seem to be any better to me.  If
> > there is a desire to separate these errors, I think we need to pick
> > something much more distinctive.
> >
>
> When I see EINVAL, I automatically wonder what bogus argument I passed
> in somewhere, so I find that particularly deceptive here where the bug
> is either from the MDS or we had some sort of low-level socket handling
> problem.
>
> OTOH, you have a good point. The callers universally ignore the error
> code from this function. Perhaps we ought to just log a pr_warn message
> or something if the decoding fails here instead?

There already is one:

 793 bad:
 794         err = -EINVAL;
 795 fail:
 796         if (realm && !IS_ERR(realm))
 797                 ceph_put_snap_realm(mdsc, realm);
 798         if (first_realm)
 799                 ceph_put_snap_realm(mdsc, first_realm);
 800         pr_err("update_snap_trace error %d\n", err);
 801         return err;

Or do you mean specifically the "bad" label?

Thanks,

                Ilya
