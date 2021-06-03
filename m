Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4BC39A2B2
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 16:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhFCODs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 10:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhFCODr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 10:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E357661208;
        Thu,  3 Jun 2021 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622728923;
        bh=9jtBX1sfKjqnY9Tw8IpHmWEeJyPBCgedLVvLdYJ7xPs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cga74oYDJbNRQ9zP7pS+DGp0mc9I7PlpwNl9oF1zXqtxA8AALXHM4nonILrXZjcv1
         v+ZOXuQappqsefwBOSUSHnd/1zdkaJbhCGk6Ind2lQ+VtRPS9V537f9N4Qsp7BrhVG
         wAyLZh8KUnd8rEb9/PODObcW2J9hsT0u0qZSFFE0IcmRArH7cu4Aci0ntDibiKfgdX
         uNUKIl7c/HQjFSkBNaUQMgtl18bPeI5vQUMnvNAXCwQWEdJFqI8r6IczqDw0BU6WoU
         HqYqJszVdLG9oqSeYhS0JHkdzQRt9xpCdKe83M4ebcYh3x5H8d4eULcFEK8lY1KmXP
         iWwL3rJDVI76A==
Message-ID: <cf3be8010edddaf786b761ec98610b0bbe9ccbd3.camel@kernel.org>
Subject: Re: [PATCH] ceph: decoding error in ceph_update_snap_realm should
 return -EIO
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Thu, 03 Jun 2021 10:02:01 -0400
In-Reply-To: <CAOi1vP_UFhGVP3Nf7chj9J7q12BYdKguPLudddPdJHnd3G_3WQ@mail.gmail.com>
References: <20210603133914.79072-1-jlayton@kernel.org>
         <CAOi1vP_UFhGVP3Nf7chj9J7q12BYdKguPLudddPdJHnd3G_3WQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-06-03 at 15:57 +0200, Ilya Dryomov wrote:
> On Thu, Jun 3, 2021 at 3:39 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > Currently ceph_update_snap_realm returns -EINVAL when it hits a decoding
> > error, which is the wrong error code. -EINVAL implies that the user gave
> > us a bogus argument to a syscall or something similar. -EIO is more
> > descriptive when we hit a decoding error.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/snap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index d07c1c6ac8fb..f8cac2abab3f 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -807,7 +807,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> >         return 0;
> > 
> >  bad:
> > -       err = -EINVAL;
> > +       err = -EIO;
> >  fail:
> >         if (realm && !IS_ERR(realm))
> >                 ceph_put_snap_realm(mdsc, realm);
> 
> Hi Jeff,
> 
> Is this error code propagated anywhere important?
> 
> The vast majority of functions that have something to do with decoding
> use EINVAL as a default (usually out-of-bounds) error.  I agree that it
> is totally ambiguous, but EIO doesn't seem to be any better to me.  If
> there is a desire to separate these errors, I think we need to pick
> something much more distinctive.
> 

When I see EINVAL, I automatically wonder what bogus argument I passed
in somewhere, so I find that particularly deceptive here where the bug
is either from the MDS or we had some sort of low-level socket handling
problem.

OTOH, you have a good point. The callers universally ignore the error
code from this function. Perhaps we ought to just log a pr_warn message
or something if the decoding fails here instead?
-- 
Jeff Layton <jlayton@kernel.org>

