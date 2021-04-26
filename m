Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC51336BB4D
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Apr 2021 23:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbhDZVkT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Apr 2021 17:40:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234229AbhDZVkS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 17:40:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619473176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NHuvsACEl1CI5awLj29+rd0noL/P2DJNg9HAwjCVAH0=;
        b=TbrJNG41Ppct9fyCdJon5s/Zabvkc5nMdZfvdT4V6km6vuR02ufoEYp7MO3AwDYCYzSJpw
        FVC7WuaTrYr3UQIxAgF1mCEX2ySn/zQBEMpd+ZoOu4B16PBudNjNu8JaYoQnEwo2jU4G8q
        9aV1D4hGqwIHpLRGsQknGP7id3dJ8Vk=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-FadNCdo_O_ivCxl_WRr-gw-1; Mon, 26 Apr 2021 17:39:34 -0400
X-MC-Unique: FadNCdo_O_ivCxl_WRr-gw-1
Received: by mail-yb1-f198.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so23434392ybn.21
        for <ceph-devel@vger.kernel.org>; Mon, 26 Apr 2021 14:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHuvsACEl1CI5awLj29+rd0noL/P2DJNg9HAwjCVAH0=;
        b=oDKs8hF3INoVnzEh+CXuC0cv2ng2hV8b5i+c7muxCrzqgX/47Owh6fcvKBHZT8ca4M
         C1KcpYaA+Uz4kaJLAIzJTABhsUCr4UliiSvo+8qU9ZaXd3kJ+qZ/KJ/imsWepeO5MmPj
         T+UYSiJYRtXPkVG5A1oH+zpxxFAS3sYgC/wJNRtDGVsMBMB4vWyQiSSAZ6n0TPRr4j/7
         jQOk1riIvnykCCLsYR9Trbv+v3HQ5aFymFSo/zoPtYDb2EYhYpfdn9owEONT8YQGhp8g
         rG8aCzBexAhiyqIPCA6TJAtOR9pgCda2tZnnIR2KWTXzIA++YzuOHcgIh5gGu1bUtA0o
         W0Ow==
X-Gm-Message-State: AOAM533syWoXf/sUGVaRF/S5BijpfcZfJbfOLfoNZAL/R2Gr406z+roE
        9PxNPsJBtr3xi2LOKVBbAXiXNP+OAf8w8BdaR5jy4MC4HPy/875d/MhSmVQt4qySkPIDQYarDpi
        TDwHR2hcs4gNtlJjIvWr7dM+jy0ng79hdR+wnsA==
X-Received: by 2002:a25:570b:: with SMTP id l11mr29088367ybb.335.1619473173579;
        Mon, 26 Apr 2021 14:39:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/wXyKLI4TMmIO0Z2ws4xZcCt+U06V+2s2ssmR8wS8k2UbBaQ4UBIARhy5tO0ovMMwmoBxnLEWETwJaLxTado=
X-Received: by 2002:a25:570b:: with SMTP id l11mr29088337ybb.335.1619473173244;
 Mon, 26 Apr 2021 14:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <161918446704.3145707.14418606303992174310.stgit@warthog.procyon.org.uk>
 <161918448151.3145707.11541538916600921083.stgit@warthog.procyon.org.uk> <3545034.1619392490@warthog.procyon.org.uk>
In-Reply-To: <3545034.1619392490@warthog.procyon.org.uk>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Mon, 26 Apr 2021 17:38:57 -0400
Message-ID: <CALF+zOk84B5xFZ6kFMOQb8KYkxZgMFmSBboEfsgSFNL_N5uCyA@mail.gmail.com>
Subject: Re: [PATCH] iov_iter: Four fixes for ITER_XARRAY
To:     David Howells <dhowells@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-cachefs <linux-cachefs@redhat.com>,
        linux-afs@lists.infradead.org,
        linux-nfs <linux-nfs@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Apr 25, 2021 at 7:15 PM David Howells <dhowells@redhat.com> wrote:
>
> Hi Al,
>
> I think this patch should include all the fixes necessary.  I could merge
> it in, but I think it might be better to tag it on the end as an additional
> patch.
>
> David
> ---
> iov_iter: Four fixes for ITER_XARRAY
>
> Fix four things[1] in the patch that adds ITER_XARRAY[2]:
>
>  (1) Remove the address_space struct predeclaration.  This is a holdover
>      from when it was ITER_MAPPING.
>
>  (2) Fix _copy_mc_to_iter() so that the xarray segment updates count and
>      iov_offset in the iterator before returning.
>
>  (3) Fix iov_iter_alignment() to not loop in the xarray case.  Because the
>      middle pages are all whole pages, only the end pages need be
>      considered - and this can be reduced to just looking at the start
>      position in the xarray and the iteration size.
>
>  (4) Fix iov_iter_advance() to limit the size of the advance to no more
>      than the remaining iteration size.
>
> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Link: https://lore.kernel.org/r/YIVrJT8GwLI0Wlgx@zeniv-ca.linux.org.uk [1]
> Link: https://lore.kernel.org/r/161918448151.3145707.11541538916600921083.stgit@warthog.procyon.org.uk [2]
> ---
>  include/linux/uio.h |    1 -
>  lib/iov_iter.c      |    5 +++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 5f5ffc45d4aa..d3ec87706d75 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -10,7 +10,6 @@
>  #include <uapi/linux/uio.h>
>
>  struct page;
> -struct address_space;
>  struct pipe_inode_info;
>
>  struct kvec {
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 44fa726a8323..61228a6c69f8 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -791,6 +791,8 @@ size_t _copy_mc_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
>                         curr_addr = (unsigned long) from;
>                         bytes = curr_addr - s_addr - rem;
>                         rcu_read_unlock();
> +                       i->iov_offset += bytes;
> +                       i->count -= bytes;
>                         return bytes;
>                 }
>                 })
> @@ -1147,6 +1149,7 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
>                 return;
>         }
>         if (unlikely(iov_iter_is_xarray(i))) {
> +               size = min(size, i->count);
>                 i->iov_offset += size;
>                 i->count -= size;
>                 return;
> @@ -1346,6 +1349,8 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
>                         return size | i->iov_offset;
>                 return size;
>         }
> +       if (unlikely(iov_iter_is_xarray(i)))
> +               return (i->xarray_start + i->iov_offset) | i->count;
>         iterate_all_kinds(i, size, v,
>                 (res |= (unsigned long)v.iov_base | v.iov_len, 0),
>                 res |= v.bv_offset | v.bv_len,
>

You can add
Tested-by: Dave Wysochanski <dwysocha@redhat.com>

I added this patch on top of your v7 series then added my current
NFS patches to use netfs lib.
I ran xfstests with fscache enabled on NFS versions (3, 4.0, 4.1, 4.2),
as well as connectathon and some unit tests.

