Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E0E6ED4E9
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Apr 2023 20:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjDXS4J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Apr 2023 14:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjDXS4E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Apr 2023 14:56:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33AC901D
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 11:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682362512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cC2m6cj4by0ic+ocHcPEbRFoxwEEiKQQoS0Ge1Avf1U=;
        b=gFj4rK1Xegkc8Db8mLMvKEN/VbuN1kMSBnStUUm+Ed1c+hk0DY0CrAAjYBv4njZvz+JAOP
        ygNED1Z1rq8fdSaBcLeUkex/Gge0uZ1nm5qzlhiN1EARPorjTYA5MnV0I/dbqh3y5at1Sp
        ie34g/zV+YhXh65VbkeYu2dHFGdvtqQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-xX8cvsv2PH6qdXNPtjePJQ-1; Mon, 24 Apr 2023 14:55:09 -0400
X-MC-Unique: xX8cvsv2PH6qdXNPtjePJQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2473548e65fso4718572a91.3
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 11:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682362508; x=1684954508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cC2m6cj4by0ic+ocHcPEbRFoxwEEiKQQoS0Ge1Avf1U=;
        b=dAanXrG4DjNgUO+ng903QKdRlKb45izAE12HIzv3vWM/42g5HRTkVLdfC1jGB/dR8h
         N3gonMER2uopFqNJsHtZu/J/KDgbuIjH/jSu8A+2F1vkfH/IWjLVaSxpAF3K0n4dvdMA
         ww1X7wqv2vV8MnDApY8J4MJ9kbHFjrVXzGiykz83nrotyH/NUJ+xwA6HmP9t8btrnj7z
         /UTPNDilPSBVDUOdtoVLObvAdkWjvspulU/pXIu2KG+rKrkBvT4byNZS8plG9m3mgd53
         ZLzGW9Z8aur4q1aQbrhUQYF6aj3vDgFypooVyAR2oI9OjRPFwDf+pr+67pDeTQ/Xons7
         c9/g==
X-Gm-Message-State: AAQBX9cqfs61pAe+ynnMKJ7bJVY2zvPpSbw8Px5Va5A9xrJomAupQKz/
        ERAUWXOJWUBRsyuYI6V3CZ+YFw0/4WvfiVvtdu3VnAmWfI9q0UgMML5RIFjj95QKwu58TTq2FWy
        W3xhBU6ld2Cups36o/KqEIW5Om7Ai8m0x6YWSsg==
X-Received: by 2002:a17:90b:3a8d:b0:23e:f855:79ed with SMTP id om13-20020a17090b3a8d00b0023ef85579edmr14646828pjb.28.1682362508594;
        Mon, 24 Apr 2023 11:55:08 -0700 (PDT)
X-Google-Smtp-Source: AKy350bw6UUmfa7x2kgzI/S3M36kQcMIx/LORGs9afdrTUJulizrDq8UK+lWvA5A9k5nXONeKEERR5M4Fbn0vBOkkLM=
X-Received: by 2002:a17:90b:3a8d:b0:23e:f855:79ed with SMTP id
 om13-20020a17090b3a8d00b0023ef85579edmr14646811pjb.28.1682362508271; Mon, 24
 Apr 2023 11:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230424054926.26927-1-hch@lst.de> <20230424054926.26927-6-hch@lst.de>
In-Reply-To: <20230424054926.26927-6-hch@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 24 Apr 2023 20:54:56 +0200
Message-ID: <CAHc6FU7tuLJk1JEHdmK7VmEuvuG2sMg1=D9qYJAuhn2ES4NFAA@mail.gmail.com>
Subject: Re: [Cluster-devel] [PATCH 05/17] filemap: update ki_pos in generic_perform_write
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 24, 2023 at 8:22=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
> All callers of generic_perform_write need to updated ki_pos, move it into
> common code.

We've actually got a similar situation with
iomap_file_buffered_write() and its callers. Would it make sense to
fix that up as well?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/ceph/file.c | 2 --
>  fs/ext4/file.c | 9 +++------
>  fs/f2fs/file.c | 1 -
>  fs/nfs/file.c  | 1 -
>  mm/filemap.c   | 8 ++++----
>  5 files changed, 7 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index f4d8bf7dec88a8..feeb9882ef635a 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1894,8 +1894,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
>                  * can not run at the same time
>                  */
>                 written =3D generic_perform_write(iocb, from);
> -               if (likely(written >=3D 0))
> -                       iocb->ki_pos =3D pos + written;
>                 ceph_end_io_write(inode);
>         }
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 0b8b4499e5ca18..1026acaf1235a0 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -291,12 +291,9 @@ static ssize_t ext4_buffered_write_iter(struct kiocb=
 *iocb,
>
>  out:
>         inode_unlock(inode);
> -       if (likely(ret > 0)) {
> -               iocb->ki_pos +=3D ret;
> -               ret =3D generic_write_sync(iocb, ret);
> -       }
> -
> -       return ret;
> +       if (unlikely(ret <=3D 0))
> +               return ret;
> +       return generic_write_sync(iocb, ret);
>  }
>
>  static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t o=
ffset,
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index f4ab23efcf85f8..5a9ae054b6da7d 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -4511,7 +4511,6 @@ static ssize_t f2fs_buffered_write_iter(struct kioc=
b *iocb,
>         current->backing_dev_info =3D NULL;
>
>         if (ret > 0) {
> -               iocb->ki_pos +=3D ret;
>                 f2fs_update_iostat(F2FS_I_SB(inode), inode,
>                                                 APP_BUFFERED_IO, ret);
>         }
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 893625eacab9fa..abdae2b29369be 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -666,7 +666,6 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov=
_iter *from)
>                 goto out;
>
>         written =3D result;
> -       iocb->ki_pos +=3D written;
>         nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, written);
>
>         if (mntflags & NFS_MOUNT_WRITE_EAGER) {
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 2723104cc06a12..0110bde3708b3f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3960,7 +3960,10 @@ ssize_t generic_perform_write(struct kiocb *iocb, =
struct iov_iter *i)
>                 balance_dirty_pages_ratelimited(mapping);
>         } while (iov_iter_count(i));
>
> -       return written ? written : status;
> +       if (!written)
> +               return status;
> +       iocb->ki_pos +=3D written;

Could be turned into:
iocb->ki_pos =3D pos;

> +       return written;
>  }
>  EXPORT_SYMBOL(generic_perform_write);
>
> @@ -4039,7 +4042,6 @@ ssize_t __generic_file_write_iter(struct kiocb *ioc=
b, struct iov_iter *from)
>                 endbyte =3D pos + status - 1;
>                 err =3D filemap_write_and_wait_range(mapping, pos, endbyt=
e);
>                 if (err =3D=3D 0) {
> -                       iocb->ki_pos =3D endbyte + 1;
>                         written +=3D status;
>                         invalidate_mapping_pages(mapping,
>                                                  pos >> PAGE_SHIFT,
> @@ -4052,8 +4054,6 @@ ssize_t __generic_file_write_iter(struct kiocb *ioc=
b, struct iov_iter *from)
>                 }
>         } else {
>                 written =3D generic_perform_write(iocb, from);
> -               if (likely(written > 0))
> -                       iocb->ki_pos +=3D written;
>         }
>  out:
>         current->backing_dev_info =3D NULL;
> --
> 2.39.2
>

Thanks,
Andreas

