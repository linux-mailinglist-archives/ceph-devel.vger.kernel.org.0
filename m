Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DC33054B5
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Jan 2021 08:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S317633AbhA0A1z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Jan 2021 19:27:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389819AbhAZS2U (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 13:28:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611685601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2fOOzn8pPhlTKm9KikLbj00xwMG7fV3rZ/r/LGxiqKA=;
        b=hSre74JkMfd0Sx4gXbng9qChYauO1R70p51b0TiTTYb/fCbuqsSeFnRuxMrc10PjqD4mfZ
        ORI1o5JGcW/4ElnzmHwrvBLvRA15ghjTgK4Ngp4w0Vn1eaTD56rIMYxKBv5nQ14nPHLEod
        z02EYt7tLfba218wn0OvxV4gJFoW59Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-guOrxxTtNpiAqPPGH5X88w-1; Tue, 26 Jan 2021 13:26:37 -0500
X-MC-Unique: guOrxxTtNpiAqPPGH5X88w-1
Received: by mail-ed1-f69.google.com with SMTP id a26so9871076edx.8
        for <ceph-devel@vger.kernel.org>; Tue, 26 Jan 2021 10:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2fOOzn8pPhlTKm9KikLbj00xwMG7fV3rZ/r/LGxiqKA=;
        b=WAcVyOiejfz9pZnWo/aoK0R1keHKtfcj8JBLij6K7yTpajPLeBKXs3pWTsJYjCLP6+
         HOL1fO2OHLT3MamteZtmL4+bUwaUWj3+eWPH/EhS8UgPDAAYdJpbGX89ex96horYR+2v
         4jg5w0O/6Z9QnNOl1iJHNO/BXQmO3mnZgdfaS+4CKFk9ld2j0IW+FPDvHVtopQQMiJIt
         YkMCF4xhRhtFxsthU9CQ0H0DtNOGZkcMv9Urul+f85tYOvgxd7rApk2stT+WuSew8+8W
         gL0FOWGjKjVOO+FmHAdf4Ehij1nGt8TFYBJQQbSCu0WdxFHd9CmZ3OM7+/msC2D8bvXO
         iwNw==
X-Gm-Message-State: AOAM5308EZLEOFwbwyvqLVq8HtEmsmUzt4qGEZ48JDREDjNr7EBAlK9y
        iM3g4Ri2YXRQtaTQVsL/69X6yox601h5I2L8o5FXU2wrBqyE5kmyqf2b6AGS9O1MjkfgeXA7VxY
        r791sEz6gR3Ls2qsAeWpPvILxxxJZF3WTOr7Y/Q==
X-Received: by 2002:a17:906:409:: with SMTP id d9mr4137074eja.70.1611685595820;
        Tue, 26 Jan 2021 10:26:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyEFq3YOlGW6iMDijn0AhVKCr8FbAfIU0rqEW4JxM7phQSOhY8lxoG5RgplzfjnQ6XssK0VTMbS4BNxu0SuS8k=
X-Received: by 2002:a17:906:409:: with SMTP id d9mr4137063eja.70.1611685595666;
 Tue, 26 Jan 2021 10:26:35 -0800 (PST)
MIME-Version: 1.0
References: <161161025063.2537118.2009249444682241405.stgit@warthog.procyon.org.uk>
 <161161064956.2537118.3354798147866150631.stgit@warthog.procyon.org.uk> <20210126013611.GI308988@casper.infradead.org>
In-Reply-To: <20210126013611.GI308988@casper.infradead.org>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 26 Jan 2021 13:25:59 -0500
Message-ID: <CALF+zO=4kyvR+9T48ZF6Cu-izLkbs-1m3S_ebDNWv-zuC5GSRA@mail.gmail.com>
Subject: Re: [PATCH 32/32] NFS: Convert readpage to readahead and use
 netfs_readahead for fscache
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

On Mon, Jan 25, 2021 at 8:37 PM Matthew Wilcox <willy@infradead.org> wrote:
>
>
> For Subject: s/readpage/readpages/
>
Fixed

> On Mon, Jan 25, 2021 at 09:37:29PM +0000, David Howells wrote:
> > +int __nfs_readahead_from_fscache(struct nfs_readdesc *desc,
> > +                              struct readahead_control *rac)
>
> I thought you wanted it called ractl instead of rac?  That's what I've
> been using in new code.
>
Fixed

> > -     dfprintk(FSCACHE, "NFS: nfs_getpages_from_fscache (0x%p/%u/0x%p)\n",
> > -              nfs_i_fscache(inode), npages, inode);
> > +     dfprintk(FSCACHE, "NFS: nfs_readahead_from_fscache (0x%p/0x%p)\n",
> > +              nfs_i_fscache(inode), inode);
>
> We do have readahead_count() if this is useful information to be logging.
>
Right, I used it elsewhere so I'll add here as well.

> > +static inline int nfs_readahead_from_fscache(struct nfs_readdesc *desc,
> > +                                          struct readahead_control *rac)
> >  {
> > -     if (NFS_I(inode)->fscache)
> > -             return __nfs_readpages_from_fscache(ctx, inode, mapping, pages,
> > -                                                 nr_pages);
> > +     if (NFS_I(rac->mapping->host)->fscache)
> > +             return __nfs_readahead_from_fscache(desc, rac);
> >       return -ENOBUFS;
> >  }
>
> Not entirely sure that it's worth having the two functions separated any more.
>
Yeah it's questionable so I'll collapse.  I'll also do that with
nfs_readpage_from_fscache().

> >       /* attempt to read as many of the pages as possible from the cache
> >        * - this returns -ENOBUFS immediately if the cookie is negative
> >        */
> > -     ret = nfs_readpages_from_fscache(desc.ctx, inode, mapping,
> > -                                      pages, &nr_pages);
> > +     ret = nfs_readahead_from_fscache(&desc, rac);
> >       if (ret == 0)
> >               goto read_complete; /* all pages were read */
> >
> >       nfs_pageio_init_read(&desc.pgio, inode, false,
> >                            &nfs_async_read_completion_ops);
> >
> > -     ret = read_cache_pages(mapping, pages, readpage_async_filler, &desc);
> > +     while ((page = readahead_page(rac))) {
> > +             ret = readpage_async_filler(&desc, page);
> > +             put_page(page);
> > +     }
>
> I thought with the new API we didn't need to do this kind of thing
> any more?  ie no matter whether fscache is configured in or not, it'll
> submit the I/Os.
>

We don't. This patchset was only intended as a stepping stone to get the
netfs API accepted with minimal invasiveness in NFS.

I have another patch which will unconditionally call netfs API but I
didn't post it. Since I'm not an NFS maintainer, and maintainer's didn't
weigh in on the approach, I opted to go with the least invasive approach.

There's an NFS "remote bakeathon" coming up at the end of Feb.
That would probably be a good time to get further testing on NFS
unconditionally calling the netfs API, and we should be able to
cover things like any performance concerns, etc.

