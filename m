Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928CF7236B3
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 07:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjFFFNO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 01:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjFFFNM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 01:13:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9CB10C4
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 22:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686028343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aHWuDHPcb+CURgwg+AxyCKtXBjgnmHqau+Ztc7w6EXM=;
        b=M3oGIHaKpYXJb6445VruKra6MmaktQpbpFXKdCaTQUf198X8AWBhQOuJPK/AYUPcbHK0dH
        mPHweVpBJ3HWUyMLjCKTiovpmVCuQ6lL8viFbXStDJmCBHo2Z6kKxgwoKWvCrZy6ZOA/Lo
        lvIDfN4FG1XqfQwEsPkIvG24rNoVMUw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-ERbyBAztMpKT0J4BFnBRZQ-1; Tue, 06 Jun 2023 01:12:22 -0400
X-MC-Unique: ERbyBAztMpKT0J4BFnBRZQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a34a0b75eso386923066b.1
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 22:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686028341; x=1688620341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aHWuDHPcb+CURgwg+AxyCKtXBjgnmHqau+Ztc7w6EXM=;
        b=LOZJ96aq7eRf+D5vxFwd8I3muDHOjMnHFo6KYmwdRsNkkVoY4kDFAZVSMYayXMOvUn
         +MJdIWfC5CUnJaNwmVlwWQ+AljYN32gXfTEIWJ9y20lyW/jA0XQ0lnV8VTFjI+PHohGr
         aOHyn9aoT6aJflR1ub6oCWlltqzQz+1jKQwLDVobNLh8Bt8tMxrbtgdQjPMauXzUIaX2
         9I3+iJIfJiy/PQokZC30vrWkX0Cx2ljJ7ckLZnOM7uywbuyAjuAf1ZgiHW+P0Mawcyun
         oEavCIPsFM3AiAc4gnyTlB6p8G2brQueQsCL3VOt/rZPnK9EYHBMai3vdJq8fKhxD6lf
         ks6w==
X-Gm-Message-State: AC+VfDzwiwYQFATT+hjdTCNNprSkmXFhzBdOJzyPO1M/ell8W3xq2HDz
        DtylNzkPqR3GeIJBIask+vrGUxtqMAMdzYVjMfBUTd51wHKqpCBQBDb/nu61buLXFcV+IdVuGhn
        L7T87nA5VDezXdsdufRi3VOJFKRLeb11V8U9zTZiqKfh52A==
X-Received: by 2002:a17:907:97cd:b0:96f:6c70:c012 with SMTP id js13-20020a17090797cd00b0096f6c70c012mr1175665ejc.45.1686028341199;
        Mon, 05 Jun 2023 22:12:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ55mv66aU924++9o1qjWfijZypI/AGA/rvoms9sZk0xJgvRDqhICR4VDQ2aMdDto/qV7h0A2rQZZFp4ERMSu0E=
X-Received: by 2002:a17:907:97cd:b0:96f:6c70:c012 with SMTP id
 js13-20020a17090797cd00b0096f6c70c012mr1175650ejc.45.1686028340911; Mon, 05
 Jun 2023 22:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230605072109.1027246-1-xiubli@redhat.com> <20230605072109.1027246-3-xiubli@redhat.com>
In-Reply-To: <20230605072109.1027246-3-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 6 Jun 2023 10:41:45 +0530
Message-ID: <CAED=hWBxUHR=SC3fwHPcmDKhhKjBrHeVDZ_JnfdAY=f-ip7Msg@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ceph: fix blindly expanding the readahead windows
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>


On Mon, Jun 5, 2023 at 12:53=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Blindly expanding the readahead windows will cause unneccessary
> pagecache thrashing and also will introduce the network workload.
> We should disable expanding the windows if the readahead is disabled
> and also shouldn't expand the windows too much.
>
> Expanding forward firstly instead of expanding backward for possible
> sequential reads.
>
> Bound `rreq->len` to the actual file size to restore the previous page
> cache usage.
>
> The posix_fadvise may change the maximum size of a file readahead.
>
> Cc: stable@vger.kernel.org
> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
> URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.=
scut.edu.cn
> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
> Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Reviewed-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Tested-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 40 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 93fff1a7373f..0c4fb3d23078 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -188,16 +188,42 @@ static void ceph_netfs_expand_readahead(struct netf=
s_io_request *rreq)
>         struct inode *inode =3D rreq->inode;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_file_layout *lo =3D &ci->i_layout;
> +       unsigned long max_pages =3D inode->i_sb->s_bdi->ra_pages;
> +       loff_t end =3D rreq->start + rreq->len, new_end;
> +       struct ceph_netfs_request_data *priv =3D rreq->netfs_priv;
> +       unsigned long max_len;
>         u32 blockoff;
> -       u64 blockno;
>
> -       /* Expand the start downward */
> -       blockno =3D div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> -       rreq->start =3D blockno * lo->stripe_unit;
> -       rreq->len +=3D blockoff;
> +       if (priv) {
> +               /* Readahead is disabled by posix_fadvise POSIX_FADV_RAND=
OM */
> +               if (priv->file_ra_disabled)
> +                       max_pages =3D 0;
> +               else
> +                       max_pages =3D priv->file_ra_pages;
> +
> +       }
> +
> +       /* Readahead is disabled */
> +       if (!max_pages)
> +               return;
>
> -       /* Now, round up the length to the next block */
> -       rreq->len =3D roundup(rreq->len, lo->stripe_unit);
> +       max_len =3D max_pages << PAGE_SHIFT;
> +
> +       /*
> +        * Try to expand the length forward by rounding up it to the next
> +        * block, but do not exceed the file size, unless the original
> +        * request already exceeds it.
> +        */
> +       new_end =3D min(round_up(end, lo->stripe_unit), rreq->i_size);
> +       if (new_end > end && new_end <=3D rreq->start + max_len)
> +               rreq->len =3D new_end - rreq->start;
> +
> +       /* Try to expand the start downward */
> +       div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> +       if (rreq->len + blockoff <=3D max_len) {
> +               rreq->start -=3D blockoff;
> +               rreq->len +=3D blockoff;
> +       }
>  }
>
>  static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
> --
> 2.40.1
>


--=20
Milind

