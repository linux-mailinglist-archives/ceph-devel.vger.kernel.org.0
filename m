Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF337236D7
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 07:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbjFFFbl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 01:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjFFFbd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 01:31:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93ADB19C
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 22:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686029445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HEyEhQgDNbn3E/7NaesifK+8xcSCLl9EWHOYd6uKSfc=;
        b=OEf42j7H1gpOnSGoAy06n85V7mvACGIkjyOUToBeJ8psAUVXRZUK36llVyiALYN5b8wx0H
        sEk2QGLDk+feaxk9cPDp3bJwUwOugG6dCeJCihby3WziRAZaGAU82FHYDp+9tJwbz/fKdz
        SJk6BW8aUA9mxN3iLvNUhxzZZxgeAgY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-zco0d_JjMpe2NICtSmrWew-1; Tue, 06 Jun 2023 01:30:44 -0400
X-MC-Unique: zco0d_JjMpe2NICtSmrWew-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9744659b7b5so454704966b.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 22:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686029443; x=1688621443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEyEhQgDNbn3E/7NaesifK+8xcSCLl9EWHOYd6uKSfc=;
        b=YfZhFvTcv/FjMZFEE0NFlNHeFjy8ocAQR9XprSRk6+U/kyXtpcmpGxYxToi7f48H7n
         ljHG8v0MDmfnXD7M9Y/F6nclWJUXORNkstKtxgnRWUWyOvvVlUkG4G1ZEYuyM6NSy0NP
         /CBq6cembeNRmeYTm1OdZIVApnUyQfBBPVgpIyNKo7390f75F86pmsU0atbuX7Z+PIr0
         tsV9c7saTqAw36nbaPKcRTxXQeqpos0l0rmNn9VCcink0aDxpMasmfhDfZrLOJuc/1SE
         /RB7WrJcIKs0Jx9AQX+GbG9sTlEkJq8WUz+uoJYcfylYIjFyA7Tg0gsl7ho2VaxeoQEm
         2sqg==
X-Gm-Message-State: AC+VfDx6CGFPxoDhPKWzyR/Q3EfrWWdWjuhVRT9VSTrqn+qOkYYMK+80
        OahiFbCKeILZwCRM9KAQEaDvuxhuEyL1vtQVE8VyRMTMHufQNBMWcbzjoJ134sbPSM6UKaczLKf
        PHamFC7m7uGmudisAm0NIyqgvCKEOUsHkGLC7pQ==
X-Received: by 2002:a17:907:86aa:b0:96f:b8a0:6cfe with SMTP id qa42-20020a17090786aa00b0096fb8a06cfemr1283961ejc.54.1686029443412;
        Mon, 05 Jun 2023 22:30:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6IJdOXd4JMKHtDl6YWTc07g5keiYte7Q5dSCEJPxPQA+oyRiDuFBKir1Z7wn9IgCgthfB/9MqR80s5lz2W1/c=
X-Received: by 2002:a17:907:86aa:b0:96f:b8a0:6cfe with SMTP id
 qa42-20020a17090786aa00b0096fb8a06cfemr1283942ejc.54.1686029443087; Mon, 05
 Jun 2023 22:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230605072109.1027246-1-xiubli@redhat.com> <20230605072109.1027246-2-xiubli@redhat.com>
In-Reply-To: <20230605072109.1027246-2-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 6 Jun 2023 11:00:07 +0530
Message-ID: <CAED=hWBeB4oUHPzyVWSfTBQ81ofg5zTq5SOSEMQQ-=s+G3MueQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] ceph: add a dedicated private data for netfs rreq
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
> We need to save the 'f_ra.ra_pages' to expand the readahead window
> later.
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
>  fs/ceph/addr.c  | 45 ++++++++++++++++++++++++++++++++++-----------
>  fs/ceph/super.h | 13 +++++++++++++
>  2 files changed, 47 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 3b20873733af..93fff1a7373f 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -404,18 +404,28 @@ static int ceph_init_request(struct netfs_io_reques=
t *rreq, struct file *file)
>  {
>         struct inode *inode =3D rreq->inode;
>         int got =3D 0, want =3D CEPH_CAP_FILE_CACHE;
> +       struct ceph_netfs_request_data *priv;
>         int ret =3D 0;
>
>         if (rreq->origin !=3D NETFS_READAHEAD)
>                 return 0;
>
> +       priv =3D kzalloc(sizeof(*priv), GFP_NOFS);
> +       if (!priv)
> +               return -ENOMEM;
> +
>         if (file) {
>                 struct ceph_rw_context *rw_ctx;
>                 struct ceph_file_info *fi =3D file->private_data;
>
> +               priv->file_ra_pages =3D file->f_ra.ra_pages;
> +               priv->file_ra_disabled =3D file->f_mode & FMODE_RANDOM;
> +
>                 rw_ctx =3D ceph_find_rw_context(fi);
> -               if (rw_ctx)
> +               if (rw_ctx) {
> +                       rreq->netfs_priv =3D priv;
>                         return 0;
> +               }
>         }
>
>         /*
> @@ -425,27 +435,40 @@ static int ceph_init_request(struct netfs_io_reques=
t *rreq, struct file *file)
>         ret =3D ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want, true, &g=
ot);
>         if (ret < 0) {
>                 dout("start_read %p, error getting cap\n", inode);
> -               return ret;
> +               goto out;
>         }
>
>         if (!(got & want)) {
>                 dout("start_read %p, no cache cap\n", inode);
> -               return -EACCES;
> +               ret =3D -EACCES;
> +               goto out;
> +       }
> +       if (ret =3D=3D 0) {
> +               ret =3D -EACCES;
> +               goto out;
>         }
> -       if (ret =3D=3D 0)
> -               return -EACCES;
>
> -       rreq->netfs_priv =3D (void *)(uintptr_t)got;
> -       return 0;
> +       priv->caps =3D got;
> +       rreq->netfs_priv =3D priv;
> +
> +out:
> +       if (ret < 0)
> +               kfree(priv);
> +
> +       return ret;
>  }
>
>  static void ceph_netfs_free_request(struct netfs_io_request *rreq)
>  {
> -       struct ceph_inode_info *ci =3D ceph_inode(rreq->inode);
> -       int got =3D (uintptr_t)rreq->netfs_priv;
> +       struct ceph_netfs_request_data *priv =3D rreq->netfs_priv;
> +
> +       if (!priv)
> +               return;
>
> -       if (got)
> -               ceph_put_cap_refs(ci, got);
> +       if (priv->caps)
> +               ceph_put_cap_refs(ceph_inode(rreq->inode), priv->caps);
> +       kfree(priv);
> +       rreq->netfs_priv =3D NULL;
>  }
>
>  const struct netfs_request_ops ceph_netfs_ops =3D {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a226d36b3ecb..3a24b7974d46 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -470,6 +470,19 @@ struct ceph_inode_info {
>  #endif
>  };
>
> +struct ceph_netfs_request_data {
> +       int caps;
> +
> +       /*
> +        * Maximum size of a file readahead request.
> +        * The fadvise could update the bdi's default ra_pages.
> +        */
> +       unsigned int file_ra_pages;
> +
> +       /* Set it if fadvise disables file readahead entirely */
> +       bool file_ra_disabled;
> +};
> +
>  static inline struct ceph_inode_info *
>  ceph_inode(const struct inode *inode)
>  {
> --
> 2.40.1
>


--=20
Milind

