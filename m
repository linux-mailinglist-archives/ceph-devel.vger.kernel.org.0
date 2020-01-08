Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D70134722
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jan 2020 17:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgAHQFp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 11:05:45 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:48453 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgAHQFo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jan 2020 11:05:44 -0500
Received: from mail-qt1-f180.google.com ([209.85.160.180]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MEUaQ-1iwJWG3s66-00G4ZF; Wed, 08 Jan 2020 17:05:43 +0100
Received: by mail-qt1-f180.google.com with SMTP id w30so1985478qtd.12;
        Wed, 08 Jan 2020 08:05:42 -0800 (PST)
X-Gm-Message-State: APjAAAWlBzYgEylMmXpCYKzZmqEVpUf15RLp/cydgBVsQ16MUfKOntfu
        7tbB/T2R1DyJll8SqQpSg1Js93g/dUOQOyT8OQY=
X-Google-Smtp-Source: APXvYqzqWQEeHE7TaWNtzpBpnp1E3rb+fs8wMFW5zsPq4jwo54iNI9QBbVdA5oc0dSdNHlxIFwVe6vphV190F0C143E=
X-Received: by 2002:ac8:768d:: with SMTP id g13mr4188797qtr.7.1578499541624;
 Wed, 08 Jan 2020 08:05:41 -0800 (PST)
MIME-Version: 1.0
References: <20200107210256.2426176-1-arnd@arndb.de> <CAOi1vP_j1Mhdev5yGqxWVyfCvFMtmFzGw+34TdsJiQ53vWOQpA@mail.gmail.com>
In-Reply-To: <CAOi1vP_j1Mhdev5yGqxWVyfCvFMtmFzGw+34TdsJiQ53vWOQpA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 8 Jan 2020 17:05:25 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0qb3fE1D4o1wYMVVets8CtbTpMRg1hUJF1wW+oC1GJjg@mail.gmail.com>
Message-ID: <CAK8P3a0qb3fE1D4o1wYMVVets8CtbTpMRg1hUJF1wW+oC1GJjg@mail.gmail.com>
Subject: Re: [PATCH] rbd: work around -Wuninitialized warning
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jason Dillaman <dillaman@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:onrL9DaFWfOC/Ad3SvMt2oMgkY5ejSs/ewdb6kHw2Fzj/WdTHGS
 8fUCcYbiNmmFizt4rxo24Za9n0LxNFWFRkAHDheFc00XCaMm4zzNBm61spWfkTrRv+0S1bG
 +eCbzi3OGnch5XvrMgZX5ekH64dADY+iFDGdZvEAb7We2enFWiqN0wq2beCEaz8o9BKXO2D
 exKA4EB9ZtQMHeHYYDJ4Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:quB0CnsP3xg=:Oht/pwgkURotru5YSxY3ge
 aRr5t/bdENbEJxZQx2y2kzCSYUCjB4rVS3dh5X2kMRh9fii/2cpTCBKJTRvP3SQkzBUbVBiBn
 BqxpWP6SweGZ5bDegdlmB+Pmx7s4OptZtmw9PfkHf+fyDbiEL00lfegwxiXlT34vI8ROVTFoo
 2yyBMIQsV9DvzTC6R4KQoAPTIx2EaxQ1h1kbVCcWm/3EzfkRcQUriITMr2T/OvvARlndi0cx2
 Qb68q3vffEoFEQPuknhpkyqdUJz6OaEj5ygyFiEOjeV1M8ABBxh9XOQDratB1fkFtxhWCGUy1
 B19YbUnj8KT4b3PJJsS5PpEI7XMVHCaOMu7VBeGwvHpvJiuvGXOCtYy3Behsgl5awDsLtJNvM
 AXAX3j+ZplNUZH/KqDr04l3ASql6500MrQkfXJjjcjMw1ECix96imJTuMIIZ4Q5BbCQHKJEV/
 d9gW1G5zgWa/K07XgBNXu3sPXDFk9plu9PvfL007Gv0I2y+7EEJf0bem/9S3v5yfVVQzZrCJY
 mETh1MEt7roXcPN5c/TjVw98f1o1/0AHV8WRmvrCnpO2v+9AyEw7hnpB6ArupMNurUd38gFUu
 VG9roqPRPXhSt/sl/NdKm5UBXImqkKA93YERbfSZFQsPIHVwP/2z2Y8lYHeZEz+wGhGDUaVu0
 G49ZO96GhfmLj8EU0gkUe2UUwmB9SH2i+IGUVK4mxwqNohj59pE5lZVTCAari77+x1LaAQBaG
 9vo8bcyPvzr6IttubJCyWBdJsO0N/V2Tk/7bq2bHyxKJ6X83uqgAeActwodjwq0dFLjIHzvHi
 jkbL14qmhPoaqDosnbbviAX1/D2FFPrgettUS/XlS98ViPs6/cSBNUixNSAW9y4eMFw/vKy3r
 MCHgaqCj2WISpbZoYB6w==
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 8, 2020 at 4:31 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Jan 7, 2020 at 10:02 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > gcc -O3 warns about a dummy variable that is passed
> > down into rbd_img_fill_nodata without being initialized:
> >
> > drivers/block/rbd.c: In function 'rbd_img_fill_nodata':
> > drivers/block/rbd.c:2573:13: error: 'dummy' is used uninitialized in this function [-Werror=uninitialized]
> >   fctx->iter = *fctx->pos;
> >
> > Since this is a dummy, I assume the warning is harmless, but
> > it's better to initialize it anyway and avoid the warning.
> >
> > Fixes: mmtom ("init/Kconfig: enable -O3 for all arches")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/block/rbd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 29be02838b67..070edc5983df 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -2664,7 +2664,7 @@ static int rbd_img_fill_nodata(struct rbd_img_request *img_req,
> >                                u64 off, u64 len)
> >  {
> >         struct ceph_file_extent ex = { off, len };
> > -       union rbd_img_fill_iter dummy;
> > +       union rbd_img_fill_iter dummy = {};
> >         struct rbd_img_fill_ctx fctx = {
> >                 .pos_type = OBJ_REQUEST_NODATA,
> >                 .pos = &dummy,
>
> Applied, but slightly confused.  Wasn't selecting -O3/s/etc supposed to
> automatically disable -Wmaybe-uninitialized via Kconfig?

Oh, that's right. I have a couple of patches in my randconfig tree that
completely rework the way that the warning options are handled and
that accidentally ignored CONFIG_CC_DISABLE_WARN_MAYBE_UNINITIALIZED,
so it's won't actually happen on linux-next right now, just on my kernel.

However, given that -O3 did not actually introduce too many false
positives here but did find some actual uninitialized variables, we should
probably have it turned on anyway.

A lot of these false positives seem to happen whenever gcc can partially
understand how a variable is used, but not enough to see that it's ok.
With higher optimization levels, this happens less often than with the
lower levels as it inlines more aggressively and correctly determines
uses to be safe that were false-positives earlier.

I'm fairly sure that the output at -Os still won't be helpful as that would
mostly show up cases that -O2 has found to be safe rather than those
that -O2 decided not to warn about because of lack of information.

      Arnd
