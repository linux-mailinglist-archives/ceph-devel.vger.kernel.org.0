Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB5231DB8B
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Feb 2021 15:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhBQOhu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Feb 2021 09:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbhBQOhs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 Feb 2021 09:37:48 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679B1C061786
        for <ceph-devel@vger.kernel.org>; Wed, 17 Feb 2021 06:37:08 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id 80so3159823oty.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Feb 2021 06:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=omnibond-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KRNZjZzTqfrWLRx1QJmelJFfxfPUcehdqwqj+L7mkPQ=;
        b=R8hCb4eKqdCpoFdkYTrVn7FoN33zUtyi/ljWByVLrm0nNn3tup4D+Hft33LDzdElis
         n16SrG3viJflBxrjVIN2QmmXO/BgPFSDWJe1ljVa2OopffyUF0+G8Fh9aoQpou3/MlTR
         6lOKbNE6+B3j4d5dwhv33gPtGhtt8L27dc4EMEm0vGnJ/TAunXib+QvZcOCi9i0mwM86
         k3prqX0Oe/sUpTqzEgE3HcERBdh4YwNsSjrGveT+xsSircuhGURdlWmXiZnYI5Mz2W8Z
         jNhEhauvpFlyX/F69JD4IZFRmykIsAN3vuO7r6enaGZ5EvFYprDuRwGgQKV+8pJmk5aD
         UJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KRNZjZzTqfrWLRx1QJmelJFfxfPUcehdqwqj+L7mkPQ=;
        b=exFXFp4Iz0XeDacYGSm59LZ9nai3TpkfNbaydSdd+0T4lNvquWhRjJ7voqlQXu/7iT
         Xl7y1X6z5YoDIu0BUYhuL1DluhIxoYZcGIyfMy8+gCu7nLFVXJVNzMcmZTerab9RVMht
         TbEIqoY02X5hqyDPatEImOZoxV24kBoSJHSW4szXcMzes2f4KnI4TduNXL8p5zBiMSnh
         nBU8W9G9t+qslCf5AHug8aptD4h3sBn02XoAwUiGKDvZC0K6jtjd7K4q4+bBBsYuTQM9
         qOOfU+8y4aFpk3CztIKFK3cQHk2aoLbm5lWcbtBY0NdMifIxheqJ3LzrhLnDAZIroD7i
         plzQ==
X-Gm-Message-State: AOAM533TKwICZABXSsh6cRZ7dX583b0YVl3rmqWvXrEvvJ5i6W2XKlhc
        wqpN5xL/zPJM+l3Zt9hcmhFXKJxoVWrMTFr8IciPSA==
X-Google-Smtp-Source: ABdhPJy4hyW/PUrDPGqVg3UI4ZfJfCb8Vr2cdTNl0Mc8udn+hWDu9ZRGdP0xDV4oyRaIVmDhAucDgP/5yXuHdlUvdPs=
X-Received: by 2002:a05:6830:2424:: with SMTP id k4mr7412732ots.352.1613572627726;
 Wed, 17 Feb 2021 06:37:07 -0800 (PST)
MIME-Version: 1.0
References: <161340385320.1303470.2392622971006879777.stgit@warthog.procyon.org.uk>
 <161340389201.1303470.14353807284546854878.stgit@warthog.procyon.org.uk>
 <20210216103215.GB27714@lst.de> <20210216132251.GI2858050@casper.infradead.org>
In-Reply-To: <20210216132251.GI2858050@casper.infradead.org>
From:   Mike Marshall <hubcap@omnibond.com>
Date:   Wed, 17 Feb 2021 09:36:56 -0500
Message-ID: <CAOg9mSQYBjnMsDj5pMd6MOGTY5w_ZR=pw7VRYKfP5ZwmHBj2=Q@mail.gmail.com>
Subject: Re: [PATCH 03/33] mm: Implement readahead_control pageset expansion
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-mm <linux-mm@kvack.org>, linux-cachefs@redhat.com,
        linux-afs@lists.infradead.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        ceph-devel <ceph-devel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I plan to try and use readahead_expand in Orangefs...

-Mike

On Tue, Feb 16, 2021 at 8:28 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Feb 16, 2021 at 11:32:15AM +0100, Christoph Hellwig wrote:
> > On Mon, Feb 15, 2021 at 03:44:52PM +0000, David Howells wrote:
> > > Provide a function, readahead_expand(), that expands the set of pages
> > > specified by a readahead_control object to encompass a revised area with a
> > > proposed size and length.
> > >
> > > The proposed area must include all of the old area and may be expanded yet
> > > more by this function so that the edges align on (transparent huge) page
> > > boundaries as allocated.
> > >
> > > The expansion will be cut short if a page already exists in either of the
> > > areas being expanded into.  Note that any expansion made in such a case is
> > > not rolled back.
> > >
> > > This will be used by fscache so that reads can be expanded to cache granule
> > > boundaries, thereby allowing whole granules to be stored in the cache, but
> > > there are other potential users also.
> >
> > So looking at linux-next this seems to have a user, but that user is
> > dead wood given that nothing implements ->expand_readahead.
> >
> > Looking at the code structure I think netfs_readahead and
> > netfs_rreq_expand is a complete mess and needs to be turned upside
> > down, that is instead of calling back from netfs_readahead to the
> > calling file system, split it into a few helpers called by the
> > caller.
>
> That's funny, we modelled it after iomap.
>
> > But even after this can't we just expose the cache granule boundary
> > to the VM so that the read-ahead request gets setup correctly from
> > the very beginning?
>
> The intent is that this be usable by filesystems which want to (for
> example) compress variable sized blocks.  So they won't know which pages
> they want to readahead until they're in their iomap actor routine,
> see that the extent they're in is compressed, and find out how large
> the extent is.
