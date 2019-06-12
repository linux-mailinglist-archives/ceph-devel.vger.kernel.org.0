Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A8842990
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jun 2019 16:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437924AbfFLOle (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jun 2019 10:41:34 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43958 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfFLOle (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Jun 2019 10:41:34 -0400
Received: by mail-qt1-f193.google.com with SMTP id z24so5544439qtj.10
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jun 2019 07:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZBr/8I/5prS9BeqFNtNTZpJh/jcbJfaIM56pWmc4q4w=;
        b=gEn7fhVnGZj0Jr4cviLm6cX/elrgiQKomCltc9ZJqIDy4pPYma51AxI0fMwasClPKL
         1Sz1ex+EAYTpPo2w8ccoSB01eylImNctuGMZFqZyLMyqGfzu2t6yiOoMRzFeK3KOvUbZ
         hvogbOyfKdwBZmV93bUQueVvTdbdGuZMvmZh8bVp806YMZBTRcG5k+LKEdtkx9C4xLLB
         e8QtFSIGU5Ud5mk/H4dkXkdG7rBbDEsDvvh0gVQzDSnnw/Hrxhg2OCbY8UrdrWnhXqTx
         1oxDuxtUkq23pk68WeeyRAbmgCx0Stp4B5dnWLIhHtqdmztMOPzZ7zHEUpqs8ljQmIWR
         xt5Q==
X-Gm-Message-State: APjAAAWB1Lur6Xjx9pde56t/oYPObIoUAN2YzJntxQXjqbI/rEvl1oO3
        WZDDfxZaQfRXJjF1sjRGCN4WhNQ8l2XwwiZfE/wq6A==
X-Google-Smtp-Source: APXvYqzrdSBl8blV9rcFS0XYU5ukAKnbL4opDcIsA5tHOYfOAEfbMHHa4jlWTfcM/SeCRLeExB6bvAtQhacSZiQdWvU=
X-Received: by 2002:ac8:3971:: with SMTP id t46mr51692186qtb.164.1560350493677;
 Wed, 12 Jun 2019 07:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190607184749.8333-1-jlayton@kernel.org> <CAAM7YAkicqxUg1V-L=GWpJHt-QfnAC2q65KmS_zUG0=bG0jv9Q@mail.gmail.com>
In-Reply-To: <CAAM7YAkicqxUg1V-L=GWpJHt-QfnAC2q65KmS_zUG0=bG0jv9Q@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 12 Jun 2019 07:41:07 -0700
Message-ID: <CA+2bHPYfY2Zur0ts1B9B20ugtHPvdm8oStKir9LRrLoicHLAMQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix getxattr return values for vxattrs
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Zheng Yan <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io,
        Tomas Petr <tpetr@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 6:52 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Sat, Jun 8, 2019 at 2:47 AM Jeff Layton <jlayton@kernel.org> wrote:
> >
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

So the trick here is we need the user buffer to be large enough to
hold the NUL byte so we can use snprintf in the kernel. So I think if
the buffer is not large enough, return ERANGE or size+1 (NUL byte) if
value==NULL. If the buffer is large enough (size+1), then we return
size and not size+1.

Sound reasonable?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
