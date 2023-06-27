Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C261A740190
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jun 2023 18:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbjF0Qo3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 12:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjF0Qo2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 12:44:28 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC12AB4
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 09:44:27 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9920b4d8a89so131595366b.3
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 09:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687884266; x=1690476266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Klq/f3S4N8sJDpb7NkrVzTgErechuk35oCDp1VbUhtU=;
        b=Un61z1Us4xDOmCtOT4ui9qV/4IA8rJZckJPZ7mchiuUMAJLa+ajtcQrg5NcWq6b/oq
         bNMV2q+hj+2PPbq/ueP19H50rawlYQkTLSXG8Kkn9N5MFsOh+J6EGR4H/GjvfAS1qFnh
         ezqbVyLFwOL4AA9W8/Xbs2Iu9a3Ms69M5iRV7+6PmAUvQwTeB20XnN/29LE+l45zR6Ea
         WsnzJiS4B/xedSfP5jQ1xlsN4bDAgxN+5OD/l2HQyQ5pEmn2H4IV7kYD8f6AWrv8KeKh
         Sfl80pvITfEXK3H+buOS3TlGDE2tU/mQvD/w5L41y3RSJ+sg+GtQ1wabyVK3RQt6j+WS
         UnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687884266; x=1690476266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Klq/f3S4N8sJDpb7NkrVzTgErechuk35oCDp1VbUhtU=;
        b=WGdSqCcoeBS0AfkQOl9FQbIjjAk4k4aZVc7D3/l7lry3+VgpPOwHEwW6OtqypUlaT0
         ADS45TveVaTTSkbwk0RNBQX5EXb/3a+/U09m1VLhJOQEQDxb4BAnTSODWyOBBNgB3F2l
         e+hDW0WzHiRo7k2yiUmmzjnZbuqbCOx8K2ZF1JsUfXLRdi2BXJoi1IT70WL/uETufBoN
         /CjF7or5RP/3H5Dm6cYHklfDZOhMpSAQ4DDs2xc885tSMZF/BMZgf7iFM55+K0bqzp8J
         BV0qAkcu3g/KUC25MBCmUNZT793gtrUm2Rk0Y/xm6D4+d+Nw/Ws9y9Zgo3ve5AQJwl4C
         i+uQ==
X-Gm-Message-State: AC+VfDzBNy8l7kql8r9QrIQ6cpTH8ZqOi07mqE4KusepIpCl3Jg3bxUm
        OUmWk8zwBwuP891tfqjF1mhhBcw9uDuBurPP7oXuzbyLpNA=
X-Google-Smtp-Source: ACHHUZ7SKYlPbflAXMpaFnlC7awS6VurTv9PqAwubZmEwrgz3Dia7jBJGttO9UFYbnfj9KN26s7QISLOfnBOjtXgvP8=
X-Received: by 2002:a17:906:ee82:b0:988:f307:aea3 with SMTP id
 wt2-20020a170906ee8200b00988f307aea3mr19918923ejb.9.1687884266029; Tue, 27
 Jun 2023 09:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <3130627.1687863588@warthog.procyon.org.uk> <3200800.1687876037@warthog.procyon.org.uk>
In-Reply-To: <3200800.1687876037@warthog.procyon.org.uk>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 27 Jun 2023 18:44:14 +0200
Message-ID: <CAOi1vP--tS_t4rR=BTQoFMUa9sfuTueBBFrV20XJz-Dcyk0R5A@mail.gmail.com>
Subject: Re: Ceph patches for the merge window?
To:     David Howells <dhowells@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 27, 2023 at 4:28=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Looking at "ceph: add a dedicated private data for netfs rreq" you might =
find
> the attached patch useful.  It's in my list of netfs patches to push once=
 I
> get away from splice.
>
> David
> ---
> netfs: Allow the netfs to make the io (sub)request alloc larger
>
> Allow the network filesystem to specify extra space to be allocated on th=
e
> end of the io (sub)request.  This allows cifs, for example, to use this
> space rather than allocating its own cifs_readdata struct.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>  fs/netfs/objects.c    |    7 +++++--
>  include/linux/netfs.h |    2 ++
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
> index e41f9fc9bdd2..2f1865ff7cce 100644
> --- a/fs/netfs/objects.c
> +++ b/fs/netfs/objects.c
> @@ -22,7 +22,8 @@ struct netfs_io_request *netfs_alloc_request(struct add=
ress_space *mapping,
>         struct netfs_io_request *rreq;
>         int ret;
>
> -       rreq =3D kzalloc(sizeof(struct netfs_io_request), GFP_KERNEL);
> +       rreq =3D kzalloc(ctx->ops->io_request_size ?: sizeof(struct netfs=
_io_request),
> +                      GFP_KERNEL);
>         if (!rreq)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -116,7 +117,9 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(st=
ruct netfs_io_request *rreq
>  {
>         struct netfs_io_subrequest *subreq;
>
> -       subreq =3D kzalloc(sizeof(struct netfs_io_subrequest), GFP_KERNEL=
);
> +       subreq =3D kzalloc(rreq->netfs_ops->io_subrequest_size ?:
> +                        sizeof(struct netfs_io_subrequest),
> +                        GFP_KERNEL);
>         if (subreq) {
>                 INIT_LIST_HEAD(&subreq->rreq_link);
>                 refcount_set(&subreq->ref, 2);
> diff --git a/include/linux/netfs.h b/include/linux/netfs.h
> index b76a1548d311..442b88e39945 100644
> --- a/include/linux/netfs.h
> +++ b/include/linux/netfs.h
> @@ -214,6 +214,8 @@ struct netfs_io_request {
>   * Operations the network filesystem can/must provide to the helpers.
>   */
>  struct netfs_request_ops {
> +       unsigned int    io_request_size;        /* Alloc size for netfs_i=
o_request struct */
> +       unsigned int    io_subrequest_size;     /* Alloc size for netfs_i=
o_subrequest struct */

Yup, definitely a case for a future improvement to get rid of an extra
allocation.  I would suggest adding helpers for casting to and from the
private area for both netfs_io_request and netfs_io_subrequest to the
framework, see blk_mq_rq_to/from_pdu() for an example.

Thanks,

                Ilya
