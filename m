Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63095453E8E
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Nov 2021 03:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhKQCvA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Nov 2021 21:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhKQCvA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Nov 2021 21:51:00 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BB5C061570
        for <ceph-devel@vger.kernel.org>; Tue, 16 Nov 2021 18:48:02 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y13so3764091edd.13
        for <ceph-devel@vger.kernel.org>; Tue, 16 Nov 2021 18:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29WgsW7aFwgwnZPOK+oDcaJ+ePA2H6wBfd8K7h3nDyw=;
        b=h5UqLC3O/fw6H5Hin4rJZj6HpkBoY9xfBVjpPor0qVxv9pSZ51+W4UF1m6uXMOHB9B
         M3jzsdlRrFzN3O4VE1ait3SHwNuCzoPjknwz7Vqw2RxTXxFUIZ6LfBaVqNt8ZnxFLRp6
         IvMDIFPHU+7v7b9ktuE3DXmH6wQPWWkchR6B+VsCSF9qqm1uiPb1IvxSDq08+PJkcqQQ
         UZmmFpuwN9CHoVYE4DYaEaTjQM9lSfHJMS4hD+68KJ3Th8vVoYK+sJHOdRJP4DcdiU0A
         6gWmK8n4Lcn7WhXrE+26dKsf3A1/ax9q30RyweNx+zIYLVNczif9n3fWGhGvNs3G27yK
         zMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29WgsW7aFwgwnZPOK+oDcaJ+ePA2H6wBfd8K7h3nDyw=;
        b=KDxw0bs0iKZ46DVAMSrHFbj2pDZrD/1iKiqogXY4rOyjpLcWutL5ZWXWqldUJahsDE
         gcJeTLhWj4ptfikLJ53FO4zwIDQTcERqNo8AwTNJ07zCS9/xtuv+t3aeXxQ4ihnNfSZJ
         yBNj8nIKZWjkhuG+MMiQpBX7R4iflRv7xgif0i8Rh5je3ci4g8Hg6d+vW9J1Zy7Uhv7T
         Qr9L+26nHvvV3+ciwj+fktznkxU0tUlDHHvG4dz0MBbogjE4f+ePgMlPsKnwz15kO5QW
         7dt2oAKUl0GFcOvt4fQ4nZ9UE7gkFTEMfSXIARBbWsgr5XkUQmehg1tpwG3hh1SHUY0T
         wv6g==
X-Gm-Message-State: AOAM530KgisWu4J7TRthalKoS7t87w5QLca+6uJcRMD0PwH1IS7Q14Tj
        zEo//L19dZZ3YaaJFL76V815bWAtLLIcQzPL/Y8=
X-Google-Smtp-Source: ABdhPJyuSIm65hhITkKYm9jWx5eZqcLiViPRSgXu4hy3of3TQ/FyaJnaCgDcEwh+lAPtCq0CV4WqTgyn71bC/WMLCRw=
X-Received: by 2002:a17:906:1c56:: with SMTP id l22mr16665053ejg.208.1637117280863;
 Tue, 16 Nov 2021 18:48:00 -0800 (PST)
MIME-Version: 1.0
References: <20211116092002.99439-1-xiubli@redhat.com> <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
In-Reply-To: <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 17 Nov 2021 10:47:49 +0800
Message-ID: <CAAM7YAm6iovKdptjiZhgjm8kwrOeUyBYG3z82+Updrkrd-QMOA@mail.gmail.com>
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't change
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Nov 17, 2021 at 4:13 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > In case truncating a file to a smaller sizeA, the sizeA will be kept
> > in truncate_size. And if truncate the file to a bigger sizeB, the
> > MDS will only increase the truncate_seq, but still using the sizeA as
> > the truncate_size.
> >
>
> Do you mean "kept in ci->i_truncate_size" ? If so, is this really the
> correct fix? I'll note this in the sources:
>
>         u32 i_truncate_seq;        /* last truncate to smaller size */
>         u64 i_truncate_size;       /*  and the size we last truncated down to */
>
> Maybe the MDS ought not bump the truncate_seq unless it was truncating
> to a smaller size? If not, then that comment seems wrong at least.
>

mds does not change truncate_{seq,size} when truncating file to bigger size

>
> > So when filling the inode it will truncate the pagecache by using
> > truncate_sizeA again, which makes no sense and will trim the inocent
> > pages.
> >
>
> Is there a reproducer for this? It would be nice to put something in
> xfstests for it if so.
>
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/inode.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 1b4ce453d397..b4f784684e64 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
> >                        * don't hold those caps, then we need to check whether
> >                        * the file is either opened or mmaped
> >                        */
> > -                     if ((issued & (CEPH_CAP_FILE_CACHE|
> > +                     if (ci->i_truncate_size != truncate_size &&
> > +                         ((issued & (CEPH_CAP_FILE_CACHE|
> >                                      CEPH_CAP_FILE_BUFFER)) ||
> >                           mapping_mapped(inode->i_mapping) ||
> > -                         __ceph_is_file_opened(ci)) {
> > +                         __ceph_is_file_opened(ci))) {
> >                               ci->i_truncate_pending++;
> >                               queue_trunc = 1;
> >                       }
>
> --
> Jeff Layton <jlayton@kernel.org>
