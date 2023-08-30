Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E4A78DC2C
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Aug 2023 20:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbjH3Snw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Aug 2023 14:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243205AbjH3KU2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Aug 2023 06:20:28 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEED61B3;
        Wed, 30 Aug 2023 03:20:24 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6bd045336c6so3982962a34.2;
        Wed, 30 Aug 2023 03:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693390824; x=1693995624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F51SfreO0jWbIY43S7+9QFdz1WAt6ScuHJAkz6g7Suo=;
        b=LZNqhMUqlNSiYwAmmSGWblaM6/8uCK+rE6rSytHXwztbpfD9kTPSrDlTw4xsSR6hVk
         WI57DeQkbWJ4bR6SOdD2a7GhLkLYt9SNnSHfKc3Yip+YIWU053F/a9UmJZOWVqNm59Ia
         B15zRsMA7Avi2xLLIurYBltGwYXxgLWF0up6hRxDU9fqwtd45uNGpFyKrwmgYO2NsQIM
         HP0H2CeBF21KKiM+djuXCNxoYkOim2zGYTGxpHnaD0hDyNodmVrr2KVA05XQUdXGyshC
         rT8ezOv/nUItvoraDlS+cEK97CokPumVhscEp+dtadU+ppVIfswlJsGp1/IRZIUtJvC8
         p8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693390824; x=1693995624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F51SfreO0jWbIY43S7+9QFdz1WAt6ScuHJAkz6g7Suo=;
        b=h1FH6ASFwFF4Rz3gpwc9+GnMK1JT+BFwKKyOMvcgQKDlrotzSlOfmJimBPHFJhbBi1
         E3LCP96wylV8UnVpR/86JxnnDFZJ8aj0sy57gjCwc2t/po6ZmBDTPz5h1Oz9sCBwxBUz
         WGEMVg2/+dhBG42AyiN9osLVkrytx5OhLPJQOA68nCtwpq+frMXwSVEZiGgY480PAZou
         X0JGHzgM+rq3NV+rnesk+Mw0RADEUOWbyC5q3XmgSBIVTxbea1nlJr01JVoRcdlSch5d
         X1mHphevqT+oV+vFNce70smtTBUErozYTXZSLIwvECzNUaN/jIA042I5Vgv5uIRQNVYa
         gkaA==
X-Gm-Message-State: AOJu0YwBuVvFznRmeCn4hUjNDDW6g1al3ktXvp7aS9WpF0eqkhuL+euE
        TuXeskfgqZyRr/ROTriii6DbywAEET07K9FXKquvjmlytBc=
X-Google-Smtp-Source: AGHT+IEZmTz1Epp/lp6jTqZhUbFio8EtJ3Ayua/+HEmyHeBgl9z5Z89TB/tCMkqXbVT3i8j0GGo440Y7DG733z+BmqA=
X-Received: by 2002:a05:6870:c18d:b0:1ad:5317:1f7d with SMTP id
 h13-20020a056870c18d00b001ad53171f7dmr1955877oad.39.1693390824174; Wed, 30
 Aug 2023 03:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230830085929.527853-1-ruanjinjie@huawei.com>
In-Reply-To: <20230830085929.527853-1-ruanjinjie@huawei.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 30 Aug 2023 12:20:11 +0200
Message-ID: <CAOi1vP-N2ech4FOALrPfW5t3sOCLAqfGKaCvygJzDZWx26_rtQ@mail.gmail.com>
Subject: Re: [PATCH -next] rbd: Use list_for_each_entry() helper
To:     Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 30, 2023 at 10:59=E2=80=AFAM Jinjie Ruan <ruanjinjie@huawei.com=
> wrote:
>
> Convert list_for_each() to list_for_each_entry() so that the tmp
> list_head pointer and list_entry() call are no longer needed, which
> can reduce a few lines of code. No functional changed.
>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  drivers/block/rbd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2328cc05be36..3de11f077144 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -7199,7 +7199,6 @@ static void rbd_dev_remove_parent(struct rbd_device=
 *rbd_dev)
>  static ssize_t do_rbd_remove(const char *buf, size_t count)
>  {
>         struct rbd_device *rbd_dev =3D NULL;
> -       struct list_head *tmp;
>         int dev_id;
>         char opt_buf[6];
>         bool force =3D false;
> @@ -7226,8 +7225,7 @@ static ssize_t do_rbd_remove(const char *buf, size_=
t count)
>
>         ret =3D -ENOENT;
>         spin_lock(&rbd_dev_list_lock);
> -       list_for_each(tmp, &rbd_dev_list) {
> -               rbd_dev =3D list_entry(tmp, struct rbd_device, node);
> +       list_for_each_entry(rbd_dev, &rbd_dev_list, node) {
>                 if (rbd_dev->dev_id =3D=3D dev_id) {
>                         ret =3D 0;
>                         break;
> --
> 2.34.1
>

Applied.

Thanks,

                Ilya
