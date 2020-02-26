Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A074717008E
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2020 14:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgBZN4n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Feb 2020 08:56:43 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45506 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgBZN4n (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Feb 2020 08:56:43 -0500
Received: by mail-io1-f68.google.com with SMTP id w9so3374067iob.12;
        Wed, 26 Feb 2020 05:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QGW8A6NvrrWP1yUYNzkuM9Y6DPoFVb9Z8KwBG+QV5Lo=;
        b=Vk6w/5mZAyodQkBHzCqY//wn5JgAJqdcOqxWE9FGbVPOxKDaMY3/jEssR4cW31l0kZ
         xnSN3PAOStFfPDzSdOz52NHgqlKbdpw6BQpfgi6JeNU6q+vZzJ9Tkr3nMUTOnPY+/1dR
         SDqZyhx4MtnDSJCwCK4wjBlwI3mj9X5Irm0grREPAE/kYvgtr7NQS4zRSu/B3vUB+wmc
         L4AIsB6ZODPjVNKF22GGbz7urvzlxneuNfVLJ3Fwy1LZq7kBc5la7CvkLe15B77Zp6OV
         Y3oi37jhW7MaO1mVwTS3F7Qk3yPKqwfhnYExvZ33NuK5eMZN/W8k8E6K/iSRrtjJOrOG
         2qpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QGW8A6NvrrWP1yUYNzkuM9Y6DPoFVb9Z8KwBG+QV5Lo=;
        b=ogkcCq+dfz8zw160hdav5kQ6Ksgnn7oW7xiBpgYgWchm2gmTNBsFSPTUv/yXHvN4Zx
         MDt6XnZSc2Aa4bGFH7911NQjjiB4nDiuFjO6CErrFitc88nBFx2fnmZRmIvBPJaJpm6j
         ECmdCD0+Qd+Hpea9KaDw5hTYYVfjT4A/+gcs6MaHLtVGo1OEJMKRfUCsJdS6Rr44pzf2
         D7hG448xuEKll4nNO7cu2cmjS4RUT91+hHfHTvOVd5g24LvoW57VBdzCdJXzGn77GYNj
         1mF9Cm/u+WyEy8rc3PsAuRVr44LU1x6Wg6hi5KXEJQ0/H0IgEX61RJdnGjb1zmJj113W
         tIww==
X-Gm-Message-State: APjAAAXQGfkPkCLsaOVhnb5QbQqWm8Q65tCNqFULKEsIpa6Rfm3HRNBy
        5eHlE362AmgFvP0wvDn708XW08BG0kvIjrDA1Ck=
X-Google-Smtp-Source: APXvYqxl/5VcAXUhdrkabxgQPYn31aLYDntHGf7KR5UdfdynKmNGYN/1+c2QyFktCrtJTpnXFdx12LFcqWkv43QtPYE=
X-Received: by 2002:a5d:9707:: with SMTP id h7mr4749293iol.112.1582725402510;
 Wed, 26 Feb 2020 05:56:42 -0800 (PST)
MIME-Version: 1.0
References: <20200225234836.GA31741@embeddedor>
In-Reply-To: <20200225234836.GA31741@embeddedor>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 26 Feb 2020 14:56:34 +0100
Message-ID: <CAOi1vP_2+G+0=-a0uqLMYisp+EtHhiVrkWFLFch5JygYVNWvdA@mail.gmail.com>
Subject: Re: [PATCH][next] block: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Sage Weil <sage@redhat.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        linux-ntfs-dev@lists.sourceforge.net,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 26, 2020 at 12:45 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
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
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  block/partitions/ldm.h             | 2 +-
>  drivers/block/drbd/drbd_int.h      | 2 +-
>  drivers/block/drbd/drbd_protocol.h | 8 ++++----

For rbd

>  drivers/block/rbd_types.h          | 2 +-

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
