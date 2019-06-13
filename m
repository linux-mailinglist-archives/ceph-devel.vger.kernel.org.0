Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A69A43A9D
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jun 2019 17:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbfFMPWj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jun 2019 11:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731977AbfFMMi7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 08:38:59 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6478A2147A;
        Thu, 13 Jun 2019 12:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560429538;
        bh=TiXX+FKv53ELhw6tDUtRlWqoRYNrqWWKQV2wi+5bKMA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bzq2oTZTSY1Uo9OGBXyJbv9/1/k3orEMjkiqOu9AEICLIpE6ui86qZIUgf4DPB0zg
         9trzWrP1dCsBUoXh5eI8KOWpyfNs3GlYlJX4rUN0XE5U+udJ1vNj/rpGslUnndUwX3
         77+nnMGnDwATnkimmKrK98XYqA2Jj96qTWencatk=
Message-ID: <1ca046046309c7601a4c746c55ed1666c55a2108.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix getxattr return values for vxattrs
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io,
        tpetr@redhat.com, Patrick Donnelly <pdonnell@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 13 Jun 2019 08:38:56 -0400
In-Reply-To: <CAAM7YAkicqxUg1V-L=GWpJHt-QfnAC2q65KmS_zUG0=bG0jv9Q@mail.gmail.com>
References: <20190607184749.8333-1-jlayton@kernel.org>
         <CAAM7YAkicqxUg1V-L=GWpJHt-QfnAC2q65KmS_zUG0=bG0jv9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-06-12 at 21:51 +0800, Yan, Zheng wrote:
> On Sat, Jun 8, 2019 at 2:47 AM Jeff Layton <jlayton@kernel.org> wrote:
> > We have several virtual xattrs in cephfs which return various values as
> > strings. xattrs don't necessarily return strings however, so we need to
> > include the terminating NULL byte when we return the length.
> > 
> > Furthermore, the getxattr manpage says that we should return -ERANGE if
> > the buffer is too small to hold the resulting value. Let's start doing
> > that here as well.
> > 
> > URL: https://bugzilla.redhat.com/show_bug.cgi?id=1717454
> > Reported-by: Tomas Petr <tpetr@redhat.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/xattr.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > index 6621d27e64f5..2a61e02e7166 100644
> > --- a/fs/ceph/xattr.c
> > +++ b/fs/ceph/xattr.c
> > @@ -803,8 +803,15 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
> >                 if (err)
> >                         return err;
> >                 err = -ENODATA;
> > -               if (!(vxattr->exists_cb && !vxattr->exists_cb(ci)))
> > -                       err = vxattr->getxattr_cb(ci, value, size);
> > +               if (!(vxattr->exists_cb && !vxattr->exists_cb(ci))) {
> > +                       /*
> > +                        * getxattr_cb returns strlen(value), xattr length must
> > +                        * include the NULL.
> > +                        */
> > +                       err = vxattr->getxattr_cb(ci, value, size) + 1;
> 
> This confuses getfattr. also causes failures of our test cases.
> 
> run getfattr without the patch, we get:
> [root@kvm2-alpha ceph]# getfattr -n ceph.dir.entries .
> # file: .
> ceph.dir.entries="1"
> 
> 
> with the patch, we get
> [root@kvm1-alpha ceph]# getfattr -n ceph.dir.entries .
> # file: .
> ceph.dir.entries=0sMQA=
> 
> 

(cc'ing Andreas...)

I have to wonder if this is a bug in getfattr. If I do this, then it
works:

    $ getfattr -e text -n ceph.dir.entries .
    # file: .
    ceph.dir.entries="1"

...which makes me think that we're running afoul of
well_enough_printable() in getfattr command.

When I set a "user." xattr to a (short) string, it doesn't include the
null terminator. security.selinux however, does include the NULL
terminating byte in the returned length. I guess though, that it's
returning long enough strings that well_enough_printable returns true.

Andreas, we have a number of "virtual" xattrs in cephfs. When we're
returning xattr values that are strings, should the returned length
include the NULL terminating byte?

> > +                       if (size && size < err)
> > +                               err = -ERANGE;
> > +               }
> >                 return err;
> >         }
> > 
> > --
> > 2.21.0
> > _______________________________________________
> > Dev mailing list -- dev@ceph.io
> > To unsubscribe send an email to dev-leave@ceph.io

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

