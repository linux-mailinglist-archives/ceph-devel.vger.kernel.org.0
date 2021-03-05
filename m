Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6632ECC0
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Mar 2021 15:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhCEOHl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Mar 2021 09:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhCEOHT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Mar 2021 09:07:19 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D52CC061574;
        Fri,  5 Mar 2021 06:07:19 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id o11so2146434iob.1;
        Fri, 05 Mar 2021 06:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UODsAGsV/T+lomB07oDuRKsrOCpZBxRJM1Y3c8KG2Jw=;
        b=q2LfV+yiXkB3d1c+Y7ylK+4p4h22FSUF1MWWKd+Vplm7kfp3Gdn1Aiybuox8gV/dPJ
         JfFzlrgm1en745SzsCylqBGn38Z12L63Fxu7Y3HTT58zRiR5uOC5btka+JlDnk/AKwoi
         RI7ZUNFE8M9zHW8dZbFHLPkovmUUEu/74Y7ZPgjCloD6Hs4/F717u1Rtk2I267xYPKDK
         FURPxO/YdGp6x5kDq8f0KZvN0qGBhPsY68mG5tZMZ5sqddJKX3BA+Ruf1YLgjjVc1ALu
         R5UIm5WcaYUrMrekrcmQDcnJwY2wl+jjouXtGRz6wXU2xWeRAORxy54XnIspZPZJoWWU
         bPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UODsAGsV/T+lomB07oDuRKsrOCpZBxRJM1Y3c8KG2Jw=;
        b=NR1Q+VNaOgq/i66e+ancVgTnPsq3nGXv/bXR0y07m5aAvivn5gNRQIzsfhaLU/kmtj
         Eq8Qf2wxfp+yhMSQMyUN8maLFFkE6vk6R+y/LlmQVzAoGL4e1Yhb9czH9RBiq/aAeeoQ
         IoYSvSPGyyojgt30i9j7Q5C8x05iWOvCoubju4bZAprW7Yf/wC5yrCsskI9BA6VWSQLk
         37HHXvGL975ECvIDunyl+PO8A+sWyJYW/vJZiWVV3F8ZZdGcKMZhrdfAUrSStnKwA9VF
         w7/dfOIpLQgjSSNt8nIiJi7ia8oEAFMlJdR5020zMq3mX98+mC+96wA8p4/XCY7vsaGm
         iubQ==
X-Gm-Message-State: AOAM531UISRC3/DmsDWHmWTH15C3Bq4qBMcesSPBqHQyRNrPu00+4ySX
        AQyuP8zQlZNKgL6AC163h9TKxeSYAv8v4aFcKiuW2McGI/M=
X-Google-Smtp-Source: ABdhPJwGYDO38Ll6XtOXwqXQbE22dTy5p4sIkZv5Sjg3pt8l0RcuNOQUMuDli4y2Ti+TEhQHlDw5+FG+D+HSz1idYwk=
X-Received: by 2002:a5d:8149:: with SMTP id f9mr8410386ioo.191.1614953238616;
 Fri, 05 Mar 2021 06:07:18 -0800 (PST)
MIME-Version: 1.0
References: <20210305095923.GA142236@embeddedor>
In-Reply-To: <20210305095923.GA142236@embeddedor>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 5 Mar 2021 15:07:08 +0100
Message-ID: <CAOi1vP8UFriFYzzkHs9HQFw=AjJyLayaMfZ2LGJuCoie+FeYaQ@mail.gmail.com>
Subject: Re: [PATCH RESEND][next] ceph: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Mar 5, 2021 at 10:59 AM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
> of warnings by explicitly adding a break and a goto statements instead
> of just letting the code fall through to the next case.
>
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  fs/ceph/dir.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 83d9358854fb..3e575656713e 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -631,10 +631,12 @@ static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int whence)
>         switch (whence) {
>         case SEEK_CUR:
>                 offset += file->f_pos;
> +               break;
>         case SEEK_SET:
>                 break;
>         case SEEK_END:
>                 retval = -EOPNOTSUPP;
> +               goto out;
>         default:
>                 goto out;
>         }
> --
> 2.27.0
>

Applied.

Thanks,

                Ilya
