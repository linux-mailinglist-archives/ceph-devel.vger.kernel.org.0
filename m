Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59B072F7A9
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jun 2023 10:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243352AbjFNIV1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jun 2023 04:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243288AbjFNIV0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Jun 2023 04:21:26 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ADB198D
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jun 2023 01:21:25 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-977e0fbd742so57827166b.2
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jun 2023 01:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686730884; x=1689322884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7dlMvdm7TMOCPC5i0PnenMN5fYf0W7nC/40VDMmExkw=;
        b=my1O4SKh2wDCZ6Z7XDa/oIlmmw8+gZbLPWB2Wg61A90gC6llY0HHsZm3Uzjm5/ftSs
         aXDjk5jeWK9Zq6YxAQSO0qebpU6yC28xC/OcDI15x6vXFG131w+EYgiTMH9eK0w3ROyO
         j8GR1jAxyl7q0LupRcRwJnUmQOWzxrCMza1G8w0n0w4q2gOylgi8AAS2QjFgb5nAUMPK
         FcNO3A69T6pIyrLIO06tQ9dttQt18gPwJtrpPGvKpOij9jlsApaVmKfSphyCukC8Z/91
         4ulzLs655mCwRJd6orSJErGK62Kae25EBcIEU/RpdlXpTUP6ERSDCBqzuhk7sZLHyI7H
         ikSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686730884; x=1689322884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7dlMvdm7TMOCPC5i0PnenMN5fYf0W7nC/40VDMmExkw=;
        b=gNIlgW7VTpJXLshj1vodsfqarBf028SRENmJXLrRzn+nh3o17UmdWQ47GH7YaZIis+
         +LvZ+tVIHoZItXAnTIMuPzquTLABnzhC2hMyyqL/LMmsr9KOKcq6lK0catvKpfuL7rXj
         WOP4BGdjIW0zpX0x2ooUulNZrfg8PvBDsJa+LbpmSaeKH+lxHHD5/CdOtAOJaNAAShGN
         dT8af9MtPKaOgafEVhQHltbB3ySkudMmi2IaevteK8BRWMcjqa+MkFxHfCzzsUZSXR0h
         DnNrjf1bcGf5dFshNSqOf4Q7QZ5CBOeD19UCRkr98aPNph/MtELVQ2NxL1tVCFDamlzK
         AX9Q==
X-Gm-Message-State: AC+VfDx5nr+Y6G3tOIcBrDqP+dFjnd+6i/54ZroaT5NnIlceh+AG8/ta
        qa9XTeAunKjqNTWR9M4LzBN2/lx/qLpwMvo34/A=
X-Google-Smtp-Source: ACHHUZ49LAjRkaNUr/LMZzdwufZnyQpsyG4YsYq41ocWiod6KwO6DTxSDgSKsWiJs//E9jl7TDh2UXTvYgLTACepIOA=
X-Received: by 2002:a17:906:fe03:b0:974:1eb9:f750 with SMTP id
 wy3-20020a170906fe0300b009741eb9f750mr13173365ejb.36.1686730883439; Wed, 14
 Jun 2023 01:21:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230614013025.291314-1-xiubli@redhat.com> <20230614013025.291314-2-xiubli@redhat.com>
In-Reply-To: <20230614013025.291314-2-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 14 Jun 2023 10:21:11 +0200
Message-ID: <CAOi1vP-zgScbF0uoshqtgMToCZ8bkSaa6B2FYs0qvVrEKMDKaA@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] ceph: add the *_client debug macros support
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 14, 2023 at 3:33=E2=80=AFAM <xiubli@redhat.com> wrote:
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
>  include/linux/ceph/ceph_debug.h | 44 ++++++++++++++++++++++++++++++++-
>  1 file changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_de=
bug.h
> index d5a5da838caf..26b9212bf359 100644
> --- a/include/linux/ceph/ceph_debug.h
> +++ b/include/linux/ceph/ceph_debug.h
> @@ -19,12 +19,22 @@
>         pr_debug("%.*s %12.12s:%-4d : " fmt,                            \
>                  8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
>                  kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
> +#  define dout_client(client, fmt, ...)                                 =
       \
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
> +#  define dout_client(client, fmt, ...)        do {                    \
> +               if (0)                                          \
> +                       printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
> +       } while (0)
>  # endif
>
>  #else
> @@ -33,7 +43,39 @@
>   * or, just wrap pr_debug
>   */
>  # define dout(fmt, ...)        pr_debug(" " fmt, ##__VA_ARGS__)
> -
> +# define dout_client(client, fmt, ...)                                 \
> +       pr_debug("[%pU %lld] %s: " fmt, &client->fsid,                  \
> +                client->monc.auth->global_id, __func__,                \
> +                ##__VA_ARGS__)
>  #endif
>
> +# define pr_notice_client(client, fmt, ...)                            \
> +       pr_notice("[%pU %lld] %s: " fmt, &client->fsid,                 \
> +                 client->monc.auth->global_id, __func__,               \
> +                 ##__VA_ARGS__)

Hi Xiubo,

We definitely don't want the framework to include function names in
user-facing messages (i.e. in pr_* messages).  In the example that
spawned this series ("ceph: mds3 session blocklisted"), it's really
irrelevant to the user which function happens to detect blocklisting.

It's a bit less clear-cut for dout() messages, but honestly I don't
think it's needed there either.  I know that we include it manually in
many places but most of the time it's actually redundant.

Thanks,

                Ilya
