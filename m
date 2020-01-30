Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4C814DB00
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 13:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgA3MwX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 07:52:23 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40027 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgA3MwW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jan 2020 07:52:22 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so3831308iop.7;
        Thu, 30 Jan 2020 04:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WWWqqdl6/zFK7VCcqGs7VSKzeXfwiFPT65eOA+JJXKk=;
        b=twe8H9y+mCOg6TGOfiQIftqYD39FkUN+YYK91PDxtj17ajF94Z3zgVLNpUHMzeh68r
         o3vq1prap/dQZg/9D1cNFSRFvTZudwh3u8x0bpCsrswZbhjnVxk5GsflWiQ0LGMhhm27
         3gvOMGq2hdLp2XoFs9VcLX0LBECMYnSM+3tT1Oc3IWsl95uCWUqJ4Rd3PuXhc02QwCgQ
         zqJPfmmZQSMXGND86753npb18I2EgTD7f/RGp2ZSRUOpZjdwQQ4mKShWBA9OwvJm6O+A
         EVybu0s2fbr8KqjM94fvKXC06DNkYB+LJmun8aJI0JAn41KfTHcPFDrfX4ICkyRZW037
         bvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WWWqqdl6/zFK7VCcqGs7VSKzeXfwiFPT65eOA+JJXKk=;
        b=GB8rryzJ7Yau848v1WXVfsvzeHYbfCI8OiArPti/gnlPi/sk/TMHwayy8H4DRMXONT
         pOPuC07Zrk526nKzxHSAq7quEXLKwDXeuIFHePl2cYBTuUydYSxbcVcWMn94J7AA1KI+
         cO81bYIQMeafxNC5181BK6YrnoUxPE+HfezXE5Jc8450TEOeE42Qruqvv5912a2nq7y5
         CtDijfFAA2aGWALghkTdJZhX0BIEIOdsLYdFS9Q6Gat8HHV8YLz7osnw9QuaecUM965G
         +abksj22ezavYb6wH16Db2ci6mreebtBlT6apq/9uAwNNbCtLCdsEfb3bnzUuyQTezVr
         8APQ==
X-Gm-Message-State: APjAAAVtocwuh3nQsh55Se9SroLfHKv9uY4mM1M84enErwIWwPlOIcvf
        404J+F+cA9BWDcVhL7I3NNF16aRLEYXZ0OXX52c=
X-Google-Smtp-Source: APXvYqwLWvk3owCDvlr+AA1Dl8UWosu0KT7f6EU+23kap2Gjhu+X7y/CbfG9Wir0asR8yty0iCS+9l4/Rw3M22bp2V0=
X-Received: by 2002:a5d:9707:: with SMTP id h7mr4159275iol.112.1580388742224;
 Thu, 30 Jan 2020 04:52:22 -0800 (PST)
MIME-Version: 1.0
References: <20200129181253.24999-1-dave@stgolabs.net>
In-Reply-To: <20200129181253.24999-1-dave@stgolabs.net>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 30 Jan 2020 13:52:32 +0100
Message-ID: <CAOi1vP-75uoBBsnX262WoVL_jNreiSgnGmtytDKcsUE==ny2Jw@mail.gmail.com>
Subject: Re: [PATCH] rbd: optimize barrier usage for Rmw atomic bitops
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <dbueso@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 29, 2020 at 7:23 PM Davidlohr Bueso <dave@stgolabs.net> wrote:
>
> For both set and clear_bit, we can avoid the unnecessary barrier
> on non LL/SC architectures, such as x86. Instead, use the
> smp_mb__{before,after}_atomic() calls.
>
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  drivers/block/rbd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2b184563cd32..7bc79b2b8f65 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1371,13 +1371,13 @@ static void rbd_osd_submit(struct ceph_osd_request *osd_req)
>  static void img_request_layered_set(struct rbd_img_request *img_request)
>  {
>         set_bit(IMG_REQ_LAYERED, &img_request->flags);
> -       smp_mb();
> +       smp_mb__after_atomic();
>  }
>
>  static void img_request_layered_clear(struct rbd_img_request *img_request)
>  {
>         clear_bit(IMG_REQ_LAYERED, &img_request->flags);
> -       smp_mb();
> +       smp_mb__after_atomic();
>  }
>
>  static bool img_request_layered_test(struct rbd_img_request *img_request)

Hi Davidlohr,

I don't think these barriers are needed at all.  I'll remove them.

Thanks,

                Ilya
