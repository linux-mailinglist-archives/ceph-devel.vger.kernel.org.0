Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F8B229996
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 15:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732429AbgGVNxU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 09:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgGVNxU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Jul 2020 09:53:20 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F63EC0619DC
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jul 2020 06:53:20 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z6so2623749iow.6
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jul 2020 06:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WXfB9fihm8MRBI0lJn/D4tqkHUhe9Xwa8dn/2oU1SL0=;
        b=anlPnvZkn87gGzoU9V0giT04JWjVYGHSI4Cl/l+TxK0Enl1lsguX0+a8+c5MH4Gtm2
         TXxbHkYDz0fbXQ0iNgksSsNzhumhckzG3pHZLkbCf56jr2KL8FPxAeVVOQhWoyDCu/kt
         inSOQ8a41sImOyK1NRND2+0S4GE5pGzdDquQJPpaz4fjDrzadxZgBt/6bjbWQzgZODE/
         xRrhv1WoiFHWoQtKPs3toWMdQ4J7AS481uQky09aOX5f1ltLqLZZmY8/qpuCrVBcbgvy
         It71Nf8knAV+wv/+RBSwH5hofyBYNxKsforc9kYFzkTqN6c71mufkb7X0mOPmb982Dde
         AWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WXfB9fihm8MRBI0lJn/D4tqkHUhe9Xwa8dn/2oU1SL0=;
        b=DaBg6iQuXaCddoRwDPONK9pja7ftrcqDVp8wawWhWI+E9R61DvkfKbLNfr5N4h80oJ
         CbVDVqlwZ6gITga8ugSuu2vSeROAYfQGMegkTWaXNLPhwByC9KuiblqZHDwIRBtxXnkg
         g3z+lfDlQaRBkl1u/EeX0YFur5flwcAm9H9lu2h4b+2j0AeArxaGYLxo22snIMUYnENa
         IsQewWIBglXkUQTpYqRdvGxjOqmzxJT8dcPe2kscvP4jpuhr6K2ZUHAcvLoSNW/Hhd4D
         wUKFGBxNNPe7Bk7JDDj10BLpxxfb8klzv8mGhYqA+x+zwNu10HtY5g8Ln25ydMSmyFJA
         ZCvA==
X-Gm-Message-State: AOAM531dsT6ndmgIv/4EC3wFQUk8R6AdVSD9dhJlRaYmQjoxdYBuwb1/
        8XONGIuhzjaLmpI/8Hb2j6b91e/+gaaauW8dFc0=
X-Google-Smtp-Source: ABdhPJxOgKfzRpXjbdmqO3KCOexXckcQV7tPDjCorLmyvNJqGtA/hwTUFk+IbKrPaPnxmsjqNwuFi9WDKsRDhN/NdzA=
X-Received: by 2002:a02:ce4b:: with SMTP id y11mr6131828jar.144.1595425999441;
 Wed, 22 Jul 2020 06:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200722134604.3026-1-jiayang5@huawei.com>
In-Reply-To: <20200722134604.3026-1-jiayang5@huawei.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 22 Jul 2020 15:53:16 +0200
Message-ID: <CAOi1vP9kMKVTr4K0WzEpr1cjvguuH-gOy8vnOrMm3ELdiBfk_A@mail.gmail.com>
Subject: Re: [PATCH V2] fs:ceph: Remove unused variables in ceph_mdsmap_decode()
To:     Jia Yang <jiayang5@huawei.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 22, 2020 at 3:39 PM Jia Yang <jiayang5@huawei.com> wrote:
>
> Fix build warnings:
>
> fs/ceph/mdsmap.c: In function =E2=80=98ceph_mdsmap_decode=E2=80=99:
> fs/ceph/mdsmap.c:192:7: warning:
> variable =E2=80=98info_cv=E2=80=99 set but not used [-Wunused-but-set-var=
iable]
> fs/ceph/mdsmap.c:177:7: warning:
> variable =E2=80=98state_seq=E2=80=99 set but not used [-Wunused-but-set-v=
ariable]
> fs/ceph/mdsmap.c:123:15: warning:
> variable =E2=80=98mdsmap_cv=E2=80=99 set but not used [-Wunused-but-set-v=
ariable]
>
> Use ceph_decode_skip_* instead of ceph_decode_*, because p is
> increased in ceph_decode_*.
>
> Signed-off-by: Jia Yang <jiayang5@huawei.com>
> ---
>  fs/ceph/mdsmap.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 889627817e52..7455ba83822a 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -120,7 +120,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
>         const void *start =3D *p;
>         int i, j, n;
>         int err;
> -       u8 mdsmap_v, mdsmap_cv;
> +       u8 mdsmap_v;
>         u16 mdsmap_ev;
>
>         m =3D kzalloc(sizeof(*m), GFP_NOFS);
> @@ -129,7 +129,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
>
>         ceph_decode_need(p, end, 1 + 1, bad);
>         mdsmap_v =3D ceph_decode_8(p);
> -       mdsmap_cv =3D ceph_decode_8(p);
> +       ceph_decode_skip_8(p, end, bad);

Hi Jia,

The bounds are already checked in ceph_decode_need(), so using
ceph_decode_skip_*() is unnecessary.  Just increment the position
with *p +=3D 1, staying consistent with ceph_decode_8(), which does
not bounds check.

>         if (mdsmap_v >=3D 4) {
>                u32 mdsmap_len;
>                ceph_decode_32_safe(p, end, mdsmap_len, bad);
> @@ -174,7 +174,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
>                 u64 global_id;
>                 u32 namelen;
>                 s32 mds, inc, state;
> -               u64 state_seq;
>                 u8 info_v;
>                 void *info_end =3D NULL;
>                 struct ceph_entity_addr addr;
> @@ -189,9 +188,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
>                 info_v=3D ceph_decode_8(p);
>                 if (info_v >=3D 4) {
>                         u32 info_len;
> -                       u8 info_cv;
>                         ceph_decode_need(p, end, 1 + sizeof(u32), bad);
> -                       info_cv =3D ceph_decode_8(p);
> +                       ceph_decode_skip_8(p, end, bad);

Ditto.

>                         info_len =3D ceph_decode_32(p);
>                         info_end =3D *p + info_len;
>                         if (info_end > end)
> @@ -210,7 +208,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
>                 mds =3D ceph_decode_32(p);
>                 inc =3D ceph_decode_32(p);
>                 state =3D ceph_decode_32(p);
> -               state_seq =3D ceph_decode_64(p);
> +               ceph_decode_skip_64(p, end, bad);

Ditto.

Thanks,

                Ilya
