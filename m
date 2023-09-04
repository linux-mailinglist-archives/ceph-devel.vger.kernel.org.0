Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7633B7914BA
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Sep 2023 11:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242037AbjIDJ2k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Sep 2023 05:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjIDJ2j (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Sep 2023 05:28:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98C3197
        for <ceph-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693819669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztBn5l0EKOs6ioQYehB5JAeqTehql/kA2o2vGwsPl08=;
        b=JWIfYctTCcnKgtcAHw/AoM7IGJ4cDsjW0vLI29CUz/YwxXvlkmGXuFD6uZPeXzMFhplelm
        e21MqBZqb4H34tzg+4I9KrfRkpOhDXoBhnsnoS2/ypIfsG3gCN6Kah85kzDwkOjK8X2LvC
        6E0JtPJJ3j83u67y4iYO5ngxb4h47Zs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-Ba8bljZIMReS6fJiv_wSlw-1; Mon, 04 Sep 2023 05:27:47 -0400
X-MC-Unique: Ba8bljZIMReS6fJiv_wSlw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9a65094d873so59583766b.2
        for <ceph-devel@vger.kernel.org>; Mon, 04 Sep 2023 02:27:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693819666; x=1694424466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ztBn5l0EKOs6ioQYehB5JAeqTehql/kA2o2vGwsPl08=;
        b=LIxkvDeHVG3bmO9Ta2+Q773JeCEH6+LqrzN2AeJm/1h7keIFm9kKfR0nCfZupe3l4l
         P6TUrwtYEysPrZdrW+qVy4BEWot7rAw+HEAmVklo+20GUoB7JTeQw7Z7n45YT6vLsRDe
         N38tXqrUQGFDNvZYI6z0/fCOb7lNL2CFGI+1eiXoKGHJYR3mkDjK65X+7Ove+Jt9NNwO
         DrzjmNBMwBTcW7XOw4ZizCXrig7LIntBt4IVAwr56++WoLM8t2F5shTE24lwdvIt4VYC
         NObJwwg6myHQVwyogceWdo9rbwrHWIp2qg920DgeFlwsRxVqnpYO/m2ifCxqHsK4Jw+u
         SXSA==
X-Gm-Message-State: AOJu0Yx0KwnUHkyaDrBVGdeNimKzI/jHZswwMr6HepOjh9zJPVSc12wV
        +I5vL4li7NAzlzCkP1jG9if38YGSX4Bq1NsDxmuzuiUo9xsShEE6Ug0MIZgMFPwbmjw0faWHET1
        VDEbcyymxKxVJyIcNrzfUUK2NicSBKBmXvRVkjA==
X-Received: by 2002:a17:906:2219:b0:9a5:8269:2c94 with SMTP id s25-20020a170906221900b009a582692c94mr7221968ejs.57.1693819666131;
        Mon, 04 Sep 2023 02:27:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHj9cjn+wsxp83rGg8D88ugIasiespjAvJxD2SgzeHqy5J9qaM8uZSw4p64/ia8FhyeCz4wiujFbv31jNo1iAs=
X-Received: by 2002:a17:906:2219:b0:9a5:8269:2c94 with SMTP id
 s25-20020a170906221900b009a582692c94mr7221959ejs.57.1693819665822; Mon, 04
 Sep 2023 02:27:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230619071438.7000-1-xiubli@redhat.com> <20230619071438.7000-2-xiubli@redhat.com>
In-Reply-To: <20230619071438.7000-2-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Mon, 4 Sep 2023 14:57:09 +0530
Message-ID: <CAED=hWBR2CN7YGsuA8-5rJ_QH9B43ARThWbSvWj+_Vuaa8wS2w@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] ceph: add the *_client debug macros support
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Tested-by: Milind Changire <mchangir@redhat.com>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>

On Mon, Jun 19, 2023 at 12:47=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This will help print the fsid and client's global_id in debug logs,
> and also print the function names.
>
> URL: https://tracker.ceph.com/issues/61590
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  include/linux/ceph/ceph_debug.h | 48 ++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_de=
bug.h
> index d5a5da838caf..0b5f210ca977 100644
> --- a/include/linux/ceph/ceph_debug.h
> +++ b/include/linux/ceph/ceph_debug.h
> @@ -19,12 +19,26 @@
>         pr_debug("%.*s %12.12s:%-4d : " fmt,                            \
>                  8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
>                  kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
> +#  define doutc(client, fmt, ...)                                      \
> +       pr_debug("%.*s %12.12s:%-4d : [%pU %lld] " fmt,                 \
> +                8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
> +                kbasename(__FILE__), __LINE__,                         \
> +                &client->fsid, client->monc.auth->global_id,           \
> +                ##__VA_ARGS__)
>  # else
>  /* faux printk call just to see any compiler warnings. */
>  #  define dout(fmt, ...)       do {                            \
>                 if (0)                                          \
>                         printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
>         } while (0)
> +#  define doutc(client, fmt, ...)      do {                    \
> +               if (0)                                          \
> +                       printk(KERN_DEBUG "[%pU %lld] " fmt,    \
> +                       &client->fsid,                          \
> +                       client->monc.auth->global_id,           \
> +                       ##__VA_ARGS__);                         \
> +               } while (0)
> +
>  # endif
>
>  #else
> @@ -33,7 +47,39 @@
>   * or, just wrap pr_debug
>   */
>  # define dout(fmt, ...)        pr_debug(" " fmt, ##__VA_ARGS__)
> -
> +# define doutc(client, fmt, ...)                                       \
> +       pr_debug("[%pU %lld] %s: " fmt, &client->fsid,                  \
> +                client->monc.auth->global_id, __func__,                \
> +                ##__VA_ARGS__)
>  #endif
>
> +# define pr_notice_client(client, fmt, ...)                            \
> +       pr_notice("[%pU %lld] %s: " fmt, &client->fsid,                 \
> +                 client->monc.auth->global_id, __func__,               \
> +                 ##__VA_ARGS__)
> +# define pr_info_client(client, fmt, ...)                              \
> +       pr_info("[%pU %lld] %s: " fmt, &client->fsid,                   \
> +               client->monc.auth->global_id, __func__,                 \
> +               ##__VA_ARGS__)
> +# define pr_warn_client(client, fmt, ...)                              \
> +       pr_warn("[%pU %lld] %s: " fmt, &client->fsid,                   \
> +               client->monc.auth->global_id, __func__,                 \
> +               ##__VA_ARGS__)
> +# define pr_warn_once_client(client, fmt, ...)                         \
> +       pr_warn_once("[%pU %lld] %s: " fmt, &client->fsid,              \
> +                    client->monc.auth->global_id, __func__,            \
> +                    ##__VA_ARGS__)
> +# define pr_err_client(client, fmt, ...)                               \
> +       pr_err("[%pU %lld] %s: " fmt, &client->fsid,                    \
> +              client->monc.auth->global_id, __func__,                  \
> +              ##__VA_ARGS__)
> +# define pr_warn_ratelimited_client(client, fmt, ...)                  \
> +       pr_warn_ratelimited("[%pU %lld] %s: " fmt, &client->fsid,       \
> +                           client->monc.auth->global_id, __func__,     \
> +                           ##__VA_ARGS__)
> +# define pr_err_ratelimited_client(client, fmt, ...)                   \
> +       pr_err_ratelimited("[%pU %lld] %s: " fmt, &client->fsid,        \
> +                          client->monc.auth->global_id, __func__,      \
> +                          ##__VA_ARGS__)
> +
>  #endif
> --
> 2.40.1
>


--=20
Milind

