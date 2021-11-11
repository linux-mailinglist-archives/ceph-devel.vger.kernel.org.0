Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9337844D22F
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Nov 2021 08:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhKKHF4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Nov 2021 02:05:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhKKHFz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 02:05:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636614186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JYUjO6fb9z4jlFiB9Df3SNSgm18jUQ1yq0OvRVhOK+E=;
        b=CEDzS55NqtAHQ8Yp8BPvcwc2nAUrBgzUX+XtKlO389e/dsX73m1S54NUk8rquGAZXUDM2D
        9qJg5QY8p5RXCT34+IIwR2O3mymPRSlC5UyIxKjq5/vg+G9ZoZNlVuf4H7fp2Fkidjn1wK
        15dYtcW/W4ia9UVFjQCG7HCR4e7J47A=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-ytRpkpfYPW-GhqSaVYdsmg-1; Thu, 11 Nov 2021 02:03:04 -0500
X-MC-Unique: ytRpkpfYPW-GhqSaVYdsmg-1
Received: by mail-lf1-f69.google.com with SMTP id z1-20020a056512308100b003ff78e6402bso2295532lfd.4
        for <ceph-devel@vger.kernel.org>; Wed, 10 Nov 2021 23:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JYUjO6fb9z4jlFiB9Df3SNSgm18jUQ1yq0OvRVhOK+E=;
        b=tINM2leCi10/b4nHE+3gaKfsmVLXv2E2zXnMa4g8tbdgtnhaSRp3wcwXU3Z4OfblUO
         Mz4buMFB9F0yH3NjizAk1XmVKrlJs2s3aRz+5XbvByFyASL40lQG6yuKV1BEQHhJVmU3
         xSC20uwNcy72wsijm4TCnbpr8H00ZiZpULRepu57yBF7GnvAObqFyR+VbSkU4VYtRIVN
         lkR7zT3FUZggSKKZjkucz81CvPkQwGDu0quyaeZDfIHKVi+YnpNpsfjZHchs64FhGM9/
         0E+IzaJDwsc50sAL5JIO3sF52arZzfY6Tl/G5GpZrEeNjni/kw+NviuMo3dluv431lTm
         Tmlg==
X-Gm-Message-State: AOAM533yV/n+vVnb1acPNQ53cKXdxeyk5Qq/2RdhBlCHlkZKotEKdbZn
        IHf3NOtr3WK7jv4IF0wPcgHOxVnuktd7QbfIJ5ot0fLFt9YtH7X9dAI1Dk9SGkjy4VRyZZqSnsq
        b0nEdIoG6QXuEig/cikZPdv1i8JU9cU89AZVB
X-Received: by 2002:a05:6512:39c4:: with SMTP id k4mr3415103lfu.79.1636614183426;
        Wed, 10 Nov 2021 23:03:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzr9li5l51ZMGvsTuM8hTC7pgDZZMKvAN1kdaONy0ub0K3AatqSgqdxDaA36wHze4SQf9tHxFoIgUPDAu8UewY=
X-Received: by 2002:a05:6512:39c4:: with SMTP id k4mr3415089lfu.79.1636614183237;
 Wed, 10 Nov 2021 23:03:03 -0800 (PST)
MIME-Version: 1.0
References: <20211110180021.20876-1-khiremat@redhat.com> <20211110180021.20876-2-khiremat@redhat.com>
 <78ab5165b0db3a343e0457ec44dfdabfd68a538e.camel@kernel.org>
In-Reply-To: <78ab5165b0db3a343e0457ec44dfdabfd68a538e.camel@kernel.org>
From:   Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Date:   Thu, 11 Nov 2021 12:32:52 +0530
Message-ID: <CAPgWtC6cky-js_yX0v5iDHpOiRAwYtbP1QydjQQr8Z5N3Gij7A@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] ceph: Fix incorrect statfs report for small quota
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Venky Shankar <vshankar@redhat.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 11, 2021 at 12:48 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2021-11-10 at 23:30 +0530, khiremat@redhat.com wrote:
> > From: Kotresh HR <khiremat@redhat.com>
> >
> > Problem:
> > The statfs reports incorrect free/available space
> > for quota less then CEPH_BLOCK size (4M).
> >
> > Solution:
> > For quota less than CEPH_BLOCK size, smaller block
> > size of 4K is used. But if quota is less than 4K,
> > it is decided to go with binary use/free of 4K
> > block. For quota size less than 4K size, report the
> > total=used=4K,free=0 when quota is full and
> > total=free=4K,used=0 otherwise.
> >
> > Signed-off-by: Kotresh HR <khiremat@redhat.com>
> > ---
> >  fs/ceph/quota.c | 14 ++++++++++++++
> >  fs/ceph/super.h |  1 +
> >  2 files changed, 15 insertions(+)
> >
> > diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> > index 620c691af40e..24ae13ea2241 100644
> > --- a/fs/ceph/quota.c
> > +++ b/fs/ceph/quota.c
> > @@ -494,10 +494,24 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
> >               if (ci->i_max_bytes) {
> >                       total = ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
> >                       used = ci->i_rbytes >> CEPH_BLOCK_SHIFT;
> > +                     /* For quota size less than 4MB, use 4KB block size */
> > +                     if (!total) {
> > +                             total = ci->i_max_bytes >> CEPH_4K_BLOCK_SHIFT;
> > +                             used = ci->i_rbytes >> CEPH_4K_BLOCK_SHIFT;
> > +                             buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
> > +                     }
> >                       /* It is possible for a quota to be exceeded.
> >                        * Report 'zero' in that case
> >                        */
> >                       free = total > used ? total - used : 0;
> > +                     /* For quota size less than 4KB, report the
> > +                      * total=used=4KB,free=0 when quota is full
> > +                      * and total=free=4KB, used=0 otherwise */
> > +                     if (!total) {
> > +                             total = 1;
> > +                             free = ci->i_max_bytes > ci->i_rbytes ? 1 : 0;
> > +                             buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
> > +                     }
>
> We really ought to have the MDS establish a floor for the quota size.
> <4k quota seems ridiculous.

Yes, I have opened a tracker for the same.
https://tracker.ceph.com/issues/53228
>
>
> >               }
> >               spin_unlock(&ci->i_ceph_lock);
> >               if (total) {
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index ed51e04739c4..387ee33894db 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -32,6 +32,7 @@
> >   * large volume sizes on 32-bit machines. */
> >  #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
> >  #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
> > +#define CEPH_4K_BLOCK_SHIFT 12  /* 4 KB */
> >
> >  #define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blocklisted */
> >  #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
>
> This looks good, Kotresh. Nice work. I'll plan to merge this into
> testing in the near term.
>
> Before we merge this into mainline though, it would be good to have a
> testcase that ensures that this works like we expect with these small
> quotas.
>
> Could you write something for teuthology?

Sure, I will add a teuthology test for this.
>
>
> Thanks,
> --
> Jeff Layton <jlayton@kernel.org>
>
--
Thanks,
Kotresh HR

