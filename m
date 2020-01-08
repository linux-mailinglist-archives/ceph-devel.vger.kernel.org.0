Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B316F13463D
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jan 2020 16:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgAHPbs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 10:31:48 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45768 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgAHPbs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jan 2020 10:31:48 -0500
Received: by mail-io1-f66.google.com with SMTP id i11so3570410ioi.12;
        Wed, 08 Jan 2020 07:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X7o/cbIbWQtFq2kL2V0bbwvA4L0Ugp+mDyf5FeCjV9Y=;
        b=pzH6zeJaZTB+65guQIjtWt9OrS+TW0egL1dGYCFmTIHGpenTiH806NyUQYIC79mO49
         C8Fa9hJUcTGI4ZtrRFkjTnG0RBBe2RMBrvyAFbxlFlbLZ7Xpltr5VOXhbU8ITg7lH62Z
         OUGs7mIljKQ+eW/ya9De02u7zuWf9FZvGvZT78FHAUWNVwELEFCSzNtZwShhQunJPI+E
         7mXgOQ/k50NurhHMFU661OVKF/nFoybb2MJlyXCb7NtMl674a6Bht+abPya5Yf/p0d1M
         iKH2WYcrDnD4veK9QnQi4Dp9tZbx/ujf4vIk9+J/FzDFCcuoN6FN948J4T7SHp1pKVwX
         r7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X7o/cbIbWQtFq2kL2V0bbwvA4L0Ugp+mDyf5FeCjV9Y=;
        b=sqFxfBR4zQ8IixfwGJWUNTRERgJBMu1+NfJN1L6DrCPO92mA4JtHRAnfaDJp21CL/q
         nYsqMl+nYnEG/nqCWwEbh1WAjbkpC4NzYa9RskS8CDTr1Nh7mLXZGtN43xyNeCrirgdt
         HNMiFCkV/bHOTB2MqfaYtwf4mEdTCr88bem8HccvaLrw7TiCTWBegSvNzonS43wJjhlH
         8Oi6XGN1NpqN+cbhXL8D4TU0gJFwjAUXomq32ytOpWhcobvp5ryLNsPbJzbFY83uINDT
         Ford0Kre4lhHod3YdnIckyBy0b0vrWUb6l3q3XxhXf7Op2FVsH4PWXwqz0aG8pSS1Apn
         wOtg==
X-Gm-Message-State: APjAAAWujnN4Hzsj+nmYsYAAKUw3PR3SE/3AkLl/EEA+rpDla9dLm5t9
        IaFf+SEfYsO9PDadjaHzUB2u7L45U1jyxXSveBM=
X-Google-Smtp-Source: APXvYqysDvAgpDgc999+aM9DXdNxlGSltgKcUBQi08cAjKgH4hCse5laLHXcIpWa76h+Wts3egveXx+XtlDD8dK4JTQ=
X-Received: by 2002:a5e:8d14:: with SMTP id m20mr3593782ioj.282.1578497507212;
 Wed, 08 Jan 2020 07:31:47 -0800 (PST)
MIME-Version: 1.0
References: <20200107210256.2426176-1-arnd@arndb.de>
In-Reply-To: <20200107210256.2426176-1-arnd@arndb.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 8 Jan 2020 16:31:36 +0100
Message-ID: <CAOi1vP_j1Mhdev5yGqxWVyfCvFMtmFzGw+34TdsJiQ53vWOQpA@mail.gmail.com>
Subject: Re: [PATCH] rbd: work around -Wuninitialized warning
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Sage Weil <sage@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jason Dillaman <dillaman@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 7, 2020 at 10:02 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> gcc -O3 warns about a dummy variable that is passed
> down into rbd_img_fill_nodata without being initialized:
>
> drivers/block/rbd.c: In function 'rbd_img_fill_nodata':
> drivers/block/rbd.c:2573:13: error: 'dummy' is used uninitialized in this function [-Werror=uninitialized]
>   fctx->iter = *fctx->pos;
>
> Since this is a dummy, I assume the warning is harmless, but
> it's better to initialize it anyway and avoid the warning.
>
> Fixes: mmtom ("init/Kconfig: enable -O3 for all arches")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/block/rbd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 29be02838b67..070edc5983df 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -2664,7 +2664,7 @@ static int rbd_img_fill_nodata(struct rbd_img_request *img_req,
>                                u64 off, u64 len)
>  {
>         struct ceph_file_extent ex = { off, len };
> -       union rbd_img_fill_iter dummy;
> +       union rbd_img_fill_iter dummy = {};
>         struct rbd_img_fill_ctx fctx = {
>                 .pos_type = OBJ_REQUEST_NODATA,
>                 .pos = &dummy,

Applied, but slightly confused.  Wasn't selecting -O3/s/etc supposed to
automatically disable -Wmaybe-uninitialized via Kconfig?

Thanks,

                Ilya
