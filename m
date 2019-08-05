Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5CA816F1
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Aug 2019 12:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfHEKWj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Aug 2019 06:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbfHEKWj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 06:22:39 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C97A20856;
        Mon,  5 Aug 2019 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565000558;
        bh=QIwJS4AirapoblvLiuX9ZJaL4YDP5avqILdt1vthyyM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JSo6z6PLjOLqHmdq6fg4QUCN1tOw6WdsHMuyQMNMC9pu/HrhXpHJV3GkLiF//RaIL
         9tdmKR5CuKlfVBUr9Z2eCnM0qn2lOPRjrYal3orcyeDECxjNx8bhSkCDa0gCwdPT+A
         S3O9PBNN2xBTLhveK2WbIW8ncWG+hrSdsBZtJeC4=
Message-ID: <0bfb5625a441228c32bdc535162678bd1f943e7b.camel@kernel.org>
Subject: Re: [PATCH] ceph: undefine pr_fmt before redefining it
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>
Date:   Mon, 05 Aug 2019 06:22:36 -0400
In-Reply-To: <CAOi1vP-ZYyGGX_gJ1yDhN6BGwFkrrLpsWbikT-J4pA6ZSm_-SQ@mail.gmail.com>
References: <20190802172335.24553-1-jlayton@kernel.org>
         <CAOi1vP-ZYyGGX_gJ1yDhN6BGwFkrrLpsWbikT-J4pA6ZSm_-SQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-08-05 at 11:07 +0200, Ilya Dryomov wrote:
> On Fri, Aug 2, 2019 at 7:23 PM Jeff Layton <jlayton@kernel.org> wrote:
> > The preprocessor throws a warning here in some cases:
> > 
> > In file included from fs/ceph/super.h:5,
> >                  from fs/ceph/io.c:16:
> > ./include/linux/ceph/ceph_debug.h:5: warning: "pr_fmt" redefined
> >     5 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >       |
> > In file included from ./include/linux/kernel.h:15,
> >                  from fs/ceph/io.c:12:
> > ./include/linux/printk.h:288: note: this is the location of the previous definition
> >   288 | #define pr_fmt(fmt) fmt
> >       |
> > 
> > Since we do mean to redefine it, make that explicit by undefining it
> > first.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  include/linux/ceph/ceph_debug.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
> > index d5a5da838caf..fa4a84e0e018 100644
> > --- a/include/linux/ceph/ceph_debug.h
> > +++ b/include/linux/ceph/ceph_debug.h
> > @@ -2,6 +2,7 @@
> >  #ifndef _FS_CEPH_DEBUG_H
> >  #define _FS_CEPH_DEBUG_H
> > 
> > +#undef pr_fmt
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > 
> >  #include <linux/string.h>
> 
> Hi Jeff,
> 
> Looks like fs/ceph/io.c is a new file you are working on?  ceph_debug.h
> should be included at the top of every file.
> 
> Thanks,
> 
>                 Ilya

Yes, io.c is a new file I'm working on, though I had seen something
similar when working on the tracepoints that I posted recently.

If I include ceph_debug.h first though, this does go away though, so
I'll drop this patch then.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

