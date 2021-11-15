Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CA044FE67
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Nov 2021 06:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhKOFdp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 15 Nov 2021 00:33:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhKOFdo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 00:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636954248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ikaUbdue4qBV0eVuxYsZLS3KYL3roZ/bICoiexPtLYg=;
        b=iPImQKXweeSmHzh+V7mH58UywLvGTfpMLMcyg5CI0WHUKZrheiDyOyFknzRP0dn9nwbsGg
        QdyYBoU9IzWgqlNH6wzcNu7WcWWGHxhi6XwnFS2tN6m69EZaKtdSsTrcK2qy3GA8nb2RiL
        8gLq5U9VJK5GfLgDMqfqcLJa9KdKV0k=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-c6RQi8lEMMKuMcjzpmoO1g-1; Mon, 15 Nov 2021 00:30:45 -0500
X-MC-Unique: c6RQi8lEMMKuMcjzpmoO1g-1
Received: by mail-lf1-f72.google.com with SMTP id u20-20020a056512129400b0040373ffc60bso6224240lfs.15
        for <ceph-devel@vger.kernel.org>; Sun, 14 Nov 2021 21:30:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ikaUbdue4qBV0eVuxYsZLS3KYL3roZ/bICoiexPtLYg=;
        b=SWK5CAOPOSpCa+Dw40iJVzwHpLbLDxww66pWv6YKsTsX9F14Mp9lgQ6Fn5or4VGnkQ
         +7CtGpD6F25pZdwvDhIDoMtmgHneH4Mt09o4+Dfddw0n9SwT7Q8gLlmZ8C9Mll+u3zhF
         gWiUAbObr7uxkwAu2B36WqECxNTU4xpKzmvK04svpjDCv5XcTvYpGgFmqWcQXZyE9dFD
         gvEE/tNXTmsh6kEMBt3E1YFaSWXK9a55vCo/+yfBpXcXKOx2M9aH4/QcB33bS+GLmT76
         CGO48ylP+WRoCfigIeCIg7tma7DOTQ0xYNI2Zy/iYg5/fZ/r3CWSN5sw/+vT4PQgWiUp
         fvvA==
X-Gm-Message-State: AOAM532zC29Sr6RkLVoNKLRRs72XhBRa0bDvhVJxEqFArF8ZEIQxfYHu
        YToENTk6w5deN0jvqZeBw/W7yQTyrUFajDSoVu+eGlsMAwx7E7t12bKsgF637SqjSwW5tdSIpoL
        cFDCbS7mEvs4MUt4wUizS9fGkym3/Whi8amDT
X-Received: by 2002:a2e:bd08:: with SMTP id n8mr36221838ljq.160.1636954243819;
        Sun, 14 Nov 2021 21:30:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx75CiJcoCfZv7hOu4DBxXT5bPou0g+laer929Y4+hR202nzwQCTp7MEjZ+KDXhnrqbXPfP0d0F4XWbdstJyPQ=
X-Received: by 2002:a2e:bd08:: with SMTP id n8mr36221819ljq.160.1636954243609;
 Sun, 14 Nov 2021 21:30:43 -0800 (PST)
MIME-Version: 1.0
References: <20211110180021.20876-1-khiremat@redhat.com> <20211110180021.20876-2-khiremat@redhat.com>
 <2bbf6340-0814-bbfa-0d35-2e1d1fff23de@redhat.com>
In-Reply-To: <2bbf6340-0814-bbfa-0d35-2e1d1fff23de@redhat.com>
From:   Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Date:   Mon, 15 Nov 2021 11:00:32 +0530
Message-ID: <CAPgWtC4jv86+hjrBXfDpMm4r0b08sNspCKVsN994qwmHjQx1Ww@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] ceph: Fix incorrect statfs report for small quota
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Nov 15, 2021 at 8:24 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/11/21 2:00 AM, khiremat@redhat.com wrote:
> > From: Kotresh HR <khiremat@redhat.com>
> >
> > Problem:
> > The statfs reports incorrect free/available space
> > for quota less then CEPH_BLOCK size (4M).
>
> s/then/than/
>
>
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
> >   fs/ceph/quota.c | 14 ++++++++++++++
> >   fs/ceph/super.h |  1 +
> >   2 files changed, 15 insertions(+)
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
>
> The 'buf->f_frsize' has already been assigned above, this could be removed.
>
If the quota size is less than 4KB, the above assignment is not hit.
This is required.

> Thanks
>
> -- Xiubo
>
> > +                     }
> >               }
> >               spin_unlock(&ci->i_ceph_lock);
> >               if (total) {
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index ed51e04739c4..387ee33894db 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -32,6 +32,7 @@
> >    * large volume sizes on 32-bit machines. */
> >   #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
> >   #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
> > +#define CEPH_4K_BLOCK_SHIFT 12  /* 4 KB */
> >
> >   #define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blocklisted */
> >   #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
>


-- 
Thanks and Regards,
Kotresh H R

