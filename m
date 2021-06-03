Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AC339A387
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 16:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhFCOo1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 10:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhFCOo0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 10:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C910E613E9;
        Thu,  3 Jun 2021 14:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622731362;
        bh=xUDGvorIDPgQe4gudW25unztRmR25kS2t1ya80A2CXc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ls01OY3BWd7yKTRSGQBp/+XC9bcuIZc1JVJzWiRhPm39MQsHochG06aPooOcsMd9P
         y8stJ34XfYXN0DnyI/1s4IfA+eVAe7v7rNjT22Ko58Rvua9su/RsMWz3jrc6aQ824S
         GdWcmiWE0GErkJDEnXCYai6whmBDwukQn+IbqEeeowx+P7zl2aSO9etcVmKpB9GmHj
         L2FCzebbp1c1Agrgf6pzOgUpTvJRct2YjFqZK163QkF84hmmp+e3I4fXmXf+PmZImf
         mpNtQ/Iz1o0xPYIPTCEb8a6kxWg2sNzEa/1t7/4HgEgbKRZfosbrHOeIcOSBn9maZo
         J5ZeubAClH1sw==
Message-ID: <8a53dc688023bd08b530289fbd4ba502b70f2893.camel@kernel.org>
Subject: Re: [PATCH] ceph: decoding error in ceph_update_snap_realm should
 return -EIO
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Thu, 03 Jun 2021 10:42:40 -0400
In-Reply-To: <CAOi1vP-yTHK_wB_akxJxZ5bzrrOGjby00SbvQSn=6c-hkW7RgQ@mail.gmail.com>
References: <20210603133914.79072-1-jlayton@kernel.org>
         <CAOi1vP_UFhGVP3Nf7chj9J7q12BYdKguPLudddPdJHnd3G_3WQ@mail.gmail.com>
         <cf3be8010edddaf786b761ec98610b0bbe9ccbd3.camel@kernel.org>
         <CAOi1vP-yTHK_wB_akxJxZ5bzrrOGjby00SbvQSn=6c-hkW7RgQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-06-03 at 16:33 +0200, Ilya Dryomov wrote:
> On Thu, Jun 3, 2021 at 4:02 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Thu, 2021-06-03 at 15:57 +0200, Ilya Dryomov wrote:
> > > On Thu, Jun 3, 2021 at 3:39 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > 
> > > > Currently ceph_update_snap_realm returns -EINVAL when it hits a decoding
> > > > error, which is the wrong error code. -EINVAL implies that the user gave
> > > > us a bogus argument to a syscall or something similar. -EIO is more
> > > > descriptive when we hit a decoding error.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/snap.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > > index d07c1c6ac8fb..f8cac2abab3f 100644
> > > > --- a/fs/ceph/snap.c
> > > > +++ b/fs/ceph/snap.c
> > > > @@ -807,7 +807,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> > > >         return 0;
> > > > 
> > > >  bad:
> > > > -       err = -EINVAL;
> > > > +       err = -EIO;
> > > >  fail:
> > > >         if (realm && !IS_ERR(realm))
> > > >                 ceph_put_snap_realm(mdsc, realm);
> > > 
> > > Hi Jeff,
> > > 
> > > Is this error code propagated anywhere important?
> > > 
> > > The vast majority of functions that have something to do with decoding
> > > use EINVAL as a default (usually out-of-bounds) error.  I agree that it
> > > is totally ambiguous, but EIO doesn't seem to be any better to me.  If
> > > there is a desire to separate these errors, I think we need to pick
> > > something much more distinctive.
> > > 
> > 
> > When I see EINVAL, I automatically wonder what bogus argument I passed
> > in somewhere, so I find that particularly deceptive here where the bug
> > is either from the MDS or we had some sort of low-level socket handling
> > problem.
> > 
> > OTOH, you have a good point. The callers universally ignore the error
> > code from this function. Perhaps we ought to just log a pr_warn message
> > or something if the decoding fails here instead?
> 
> There already is one:
> 
>  793 bad:
>  794         err = -EINVAL;
>  795 fail:
>  796         if (realm && !IS_ERR(realm))
>  797                 ceph_put_snap_realm(mdsc, realm);
>  798         if (first_realm)
>  799                 ceph_put_snap_realm(mdsc, first_realm);
>  800         pr_err("update_snap_trace error %d\n", err);
>  801         return err;
> 
> Or do you mean specifically the "bad" label?
> 

Well, if we have a distinctive error code there, then we won't need a
separate pr_err message or anything. I still think that -EINVAL is not
descriptive of the issue though. I suppose if -EIO is too vague, we
could use something like -EILSEQ ?

-- 
Jeff Layton <jlayton@kernel.org>

