Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4911439A468
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 17:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhFCPWZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 11:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhFCPWY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 11:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8247613EE;
        Thu,  3 Jun 2021 15:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622733640;
        bh=Dp58gXOiV8+BTqbvHpbBx8vdbpgMlREDzgunWsuUMtA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UjQ0NkjVLLmaCZVy07Anbr80lcPU9xlf54kClELIo0HHpGxEZKK+AO03CyGcPMD63
         dgUKviykgxVGhgdYljUmA7csnuSRuSTUM6EigLyX8cqVuiucrji4uvp0aSpvoVp6G5
         AvZ3v6E5r41ZJjaO4VlyCSmyJeBmchRghcyc6NoSlFT7EaICm1OXSpA0P+2Dr6WM03
         Fo3q2zSwYVjo89lqoYjhMsnS/O9of9a3yPechQTT9sTTmIVlJvQi2Wm+rPuQDgYCqm
         Z8KLmymUX51R71rDyURgHHZqUAvwVx5ItxmBUKPmOeVERhs4Frwuqdc5h3Ljt7JBVt
         ke9YsvnoFwN7A==
Message-ID: <d187d44acaf8ed5ee9d706e9147090ba88ba6759.camel@kernel.org>
Subject: Re: [PATCH] ceph: decoding error in ceph_update_snap_realm should
 return -EIO
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Thu, 03 Jun 2021 11:20:38 -0400
In-Reply-To: <CAOi1vP_kmfVPXNVAip0c99bLBKAC2cCKDPsP3W6=wj4+Vm_osA@mail.gmail.com>
References: <20210603133914.79072-1-jlayton@kernel.org>
         <CAOi1vP_UFhGVP3Nf7chj9J7q12BYdKguPLudddPdJHnd3G_3WQ@mail.gmail.com>
         <cf3be8010edddaf786b761ec98610b0bbe9ccbd3.camel@kernel.org>
         <CAOi1vP-yTHK_wB_akxJxZ5bzrrOGjby00SbvQSn=6c-hkW7RgQ@mail.gmail.com>
         <8a53dc688023bd08b530289fbd4ba502b70f2893.camel@kernel.org>
         <CAOi1vP_kmfVPXNVAip0c99bLBKAC2cCKDPsP3W6=wj4+Vm_osA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-06-03 at 17:19 +0200, Ilya Dryomov wrote:
> On Thu, Jun 3, 2021 at 4:42 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Thu, 2021-06-03 at 16:33 +0200, Ilya Dryomov wrote:
> > > On Thu, Jun 3, 2021 at 4:02 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > 
> > > > On Thu, 2021-06-03 at 15:57 +0200, Ilya Dryomov wrote:
> > > > > On Thu, Jun 3, 2021 at 3:39 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > > 
> > > > > > Currently ceph_update_snap_realm returns -EINVAL when it hits a decoding
> > > > > > error, which is the wrong error code. -EINVAL implies that the user gave
> > > > > > us a bogus argument to a syscall or something similar. -EIO is more
> > > > > > descriptive when we hit a decoding error.
> > > > > > 
> > > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > > ---
> > > > > >  fs/ceph/snap.c | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > > > > index d07c1c6ac8fb..f8cac2abab3f 100644
> > > > > > --- a/fs/ceph/snap.c
> > > > > > +++ b/fs/ceph/snap.c
> > > > > > @@ -807,7 +807,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> > > > > >         return 0;
> > > > > > 
> > > > > >  bad:
> > > > > > -       err = -EINVAL;
> > > > > > +       err = -EIO;
> > > > > >  fail:
> > > > > >         if (realm && !IS_ERR(realm))
> > > > > >                 ceph_put_snap_realm(mdsc, realm);
> > > > > 
> > > > > Hi Jeff,
> > > > > 
> > > > > Is this error code propagated anywhere important?
> > > > > 
> > > > > The vast majority of functions that have something to do with decoding
> > > > > use EINVAL as a default (usually out-of-bounds) error.  I agree that it
> > > > > is totally ambiguous, but EIO doesn't seem to be any better to me.  If
> > > > > there is a desire to separate these errors, I think we need to pick
> > > > > something much more distinctive.
> > > > > 
> > > > 
> > > > When I see EINVAL, I automatically wonder what bogus argument I passed
> > > > in somewhere, so I find that particularly deceptive here where the bug
> > > > is either from the MDS or we had some sort of low-level socket handling
> > > > problem.
> > > > 
> > > > OTOH, you have a good point. The callers universally ignore the error
> > > > code from this function. Perhaps we ought to just log a pr_warn message
> > > > or something if the decoding fails here instead?
> > > 
> > > There already is one:
> > > 
> > >  793 bad:
> > >  794         err = -EINVAL;
> > >  795 fail:
> > >  796         if (realm && !IS_ERR(realm))
> > >  797                 ceph_put_snap_realm(mdsc, realm);
> > >  798         if (first_realm)
> > >  799                 ceph_put_snap_realm(mdsc, first_realm);
> > >  800         pr_err("update_snap_trace error %d\n", err);
> > >  801         return err;
> > > 
> > > Or do you mean specifically the "bad" label?
> > > 
> > 
> > Well, if we have a distinctive error code there, then we won't need a
> > separate pr_err message or anything. I still think that -EINVAL is not
> > descriptive of the issue though. I suppose if -EIO is too vague, we
> > could use something like -EILSEQ ?
> 
> In a sense it is an invalid argument because the buffer passed to the
> decoding function is too short.  This is what would lead to EINVAL here
> and in many other decoding-related functions.
> 
> EINVAL is the standard error code for "buffer/message too short" in
> many other APIs.  EILSEQ is certainly more distinctive, but I'm not
> sure it is the "right" error code for this kind of error.
> 

The issue is that almost everywhere else, decoding routines use -EIO for
this. This function is a special snowflake. Why? I don't see any
justification for it.

-- 
Jeff Layton <jlayton@kernel.org>

