Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2C61CA579
	for <lists+ceph-devel@lfdr.de>; Fri,  8 May 2020 09:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgEHHyK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 May 2020 03:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgEHHyJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 May 2020 03:54:09 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE08EC05BD43;
        Fri,  8 May 2020 00:54:09 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k18so965536ion.0;
        Fri, 08 May 2020 00:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sH1/EwEHGHbP5BYtym63KlE+5F5oheVphD+4Sqk6xQQ=;
        b=EVTnPH8joPJaveY1ikXPkz7L1es/ikQpHM8yiA7JgNcKq8z4jpk+gZpWBjqb/k3Rdx
         AhFT7r6Vecr3bB/axM3bH7dX8O+4u/ZnHAei0ImYdpstW96irI684wTQnV81XFLKhwU7
         y+4I8cYyavVP24x4Niyx2Bzb/f1+2U5E+CDBWy1TqaWOcP/SwpuTkpGesVc9Pt+uZFau
         GX8CiUIbG6NJfGmnpF04gkjlfMlleX+PRJFC5bO4V7k7kf2q3lDQ9auMiSk7wGD/cbPb
         erdiYjNs3Myemd5B++MawugL7mWQ9rSYtRYjuH5wX2RUZ2qoA54VGKcmXyxTdFq8RlcH
         sPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sH1/EwEHGHbP5BYtym63KlE+5F5oheVphD+4Sqk6xQQ=;
        b=k8tJxvSSrIlTiWBFDK69bsiht1olhbXulfkRSBRSbIDU1FOzY6KaYNGcC4hqE6AsSs
         q2V1QrbBU+s2zxnb2it+a5tPVrvQf435T7ls1AOyIVWgpeUR2UQesReCq5ibOYPKPHf9
         jxM66zv3ckQpJWJFeKbDCCNQ93rDb2+O4qPGvvt8xW6ytg80AYDcClXsEGGqKtZ+DJvb
         468HZcUuM5m8oViLP9xY5DxtsN7z86egswrx+TY8RW1j/PIFyIf5Zq9xCSd6deMfo6vC
         LDl3iDz1N5fL8ddJGkiX6//VocSxs2vlvQxWxqtMIy/3uZexh0BWyOaIzc76BkuCXaXu
         RKGg==
X-Gm-Message-State: AGi0PuZZwWE96gj2mim8drTE0KS50cAY2cJAFLyUr3OFR3LfFd/yrMph
        O3ZD/VuFM9aXH4ixhAOeQqtKq2wrQ2UlbPWIY0w=
X-Google-Smtp-Source: APiQypKJurGCBU0LVQvLyoL70z019mfp9z4r2YrgH+FWJYsAFv1TCyRjsO0Wub9HSfW/8oD1WnmSxjiZIN4J+xiGl/c=
X-Received: by 2002:a02:3f44:: with SMTP id c4mr1322316jaf.144.1588924449157;
 Fri, 08 May 2020 00:54:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200507191932.GA15991@embeddedor>
In-Reply-To: <20200507191932.GA15991@embeddedor>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 8 May 2020 09:54:12 +0200
Message-ID: <CAOi1vP9GfENfy_D_iOeUrweUk2CTcz+2GXGg3M6y+bvQs_zqMw@mail.gmail.com>
Subject: Re: [PATCH] rbd: Replace zero-length array with flexible-array
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sage Weil <sage@redhat.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 7, 2020 at 9:15 PM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
>
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
>
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
>
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
>
> sizeof(flexible-array-member) triggers a warning because flexible array
> members have incomplete type[1]. There are some instances of code in
> which the sizeof operator is being incorrectly/erroneously applied to
> zero-length arrays and the result is zero. Such instances may be hiding
> some bugs. So, this work (flexible-array member conversions) will also
> help to get completely rid of those sorts of issues.
>
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/block/rbd_types.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/rbd_types.h b/drivers/block/rbd_types.h
> index ac98ab6ccd3b..a600e0eb6b6f 100644
> --- a/drivers/block/rbd_types.h
> +++ b/drivers/block/rbd_types.h
> @@ -93,7 +93,7 @@ struct rbd_image_header_ondisk {
>         __le32 snap_count;
>         __le32 reserved;
>         __le64 snap_names_len;
> -       struct rbd_image_snap_ondisk snaps[0];
> +       struct rbd_image_snap_ondisk snaps[];
>  } __attribute__((packed));
>
>
>

Applied (folded into libceph patch).

Thanks,

                Ilya
