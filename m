Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3EB30428B
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Jan 2021 16:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406294AbhAZP20 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Jan 2021 10:28:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406267AbhAZP1D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 10:27:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611674737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VJe0QMue+MrGLDqG9YMY3B8wc1OhQAcndv4QLZtzS5Q=;
        b=bFDm6NZ5Fei3JnwaZJmRmNtrsYlO9ule4Ts3/vKgV1Lm/k05TCtB5ps/MFPrL+0Zqaumdy
        3XfDMXTz0v0K3nMgt1weK+f07DlfrcDi0QVygSMVzYq0E/KMi+9lc7YIzx8s3siX3Kkkp1
        l0AF4oBpJtk1gZJ7mN8aQM4kPg0SGEg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-yhmfrq-FPqiVHiV542evlQ-1; Tue, 26 Jan 2021 10:25:33 -0500
X-MC-Unique: yhmfrq-FPqiVHiV542evlQ-1
Received: by mail-ed1-f72.google.com with SMTP id w4so9526324edu.0
        for <ceph-devel@vger.kernel.org>; Tue, 26 Jan 2021 07:25:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VJe0QMue+MrGLDqG9YMY3B8wc1OhQAcndv4QLZtzS5Q=;
        b=iOdbKd1+d+DpglYCZxLYPkFdAUmZj20+GQTcl0iOF4yNbh2ewyQEyRFuo81ntU4F6S
         ceOfdXpA7fnHmq5TF9OViC7iCYQDKPmP+H6igTOs8+Z+oZEItLbOfp3ycw7GDu5TP5hU
         agdLiUFbjT44KKXegsF9+o2lCXl40oH91F/voBONTJiuPtzqxsz3z8W/0GjDcrYJFSFX
         JTbDWDmxChfwS98o21KCVHcTCvx1ZIV+pRsEFw2Lgx+0fJ0zoAA1Zt+SoUlnHou9/wOg
         4spLgZpwJ48uzch5LdFl5EICcu1N5I69kJLFN6uhiryVtm3xqbPAsBtWDjkj3u8Pro+T
         LNhQ==
X-Gm-Message-State: AOAM530bOBTUe+UaML2JcZN3z+Y41MY1JQoGD1FrM3jnnYq4lb4QXE2b
        lAO+MXi1P3mBVwz5l+bhQWsHtjybSaT0IEvkN2SevQVw0Dmi8UFdYNG8OTenxUkcDsTSchHI876
        TCjyoBa3DTUKh1RtKcRv6F1irQOlLgYNlnHw2Gg==
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr5114900edc.344.1611674731921;
        Tue, 26 Jan 2021 07:25:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlAcqaq8CqekYAOTl5XTKJw4byUxjRunvP1wQKBAqraCVAKiDEx3Vt3nz1iiXtLgQBV8BZqw1Aaq6eAK2Q72M=
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr5114888edc.344.1611674731765;
 Tue, 26 Jan 2021 07:25:31 -0800 (PST)
MIME-Version: 1.0
References: <161161025063.2537118.2009249444682241405.stgit@warthog.procyon.org.uk>
 <161161057357.2537118.6542184374596533032.stgit@warthog.procyon.org.uk> <20210126040540.GK308988@casper.infradead.org>
In-Reply-To: <20210126040540.GK308988@casper.infradead.org>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 26 Jan 2021 10:24:55 -0500
Message-ID: <CALF+zOn80NoeaBW8i9djC8qBCEng7riaHgz77uhxipaZ+RJ5ew@mail.gmail.com>
Subject: Re: [PATCH 27/32] NFS: Refactor nfs_readpage() and
 nfs_readpage_async() to use nfs_readdesc
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Howells <dhowells@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs <linux-nfs@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 25, 2021 at 11:06 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Jan 25, 2021 at 09:36:13PM +0000, David Howells wrote:
> > +int nfs_readpage_async(void *data, struct inode *inode,
> >                      struct page *page)
> >  {
> > +     struct nfs_readdesc *desc = (struct nfs_readdesc *)data;
>
> You don't need a cast to cast from void.
>
Right, fixing.

> > @@ -440,17 +439,16 @@ int nfs_readpages(struct file *filp, struct address_space *mapping,
> >       if (ret == 0)
> >               goto read_complete; /* all pages were read */
> >
> > -     desc.pgio = &pgio;
> > -     nfs_pageio_init_read(&pgio, inode, false,
> > +     nfs_pageio_init_read(&desc.pgio, inode, false,
>
> I like what you've done here, embedding the pgio in the desc.
>
Thanks for the review!

