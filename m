Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB234249FFC
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 15:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgHSNbc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 09:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSNbb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 09:31:31 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D906EC061757;
        Wed, 19 Aug 2020 06:31:30 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p18so16807796ilm.7;
        Wed, 19 Aug 2020 06:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xNC4GKfsuKlJo0ks5R+TsYe4+mdZTlxFml84dsSDHJQ=;
        b=cfoIfyx6enVwfWDmiGYu6QjfbD6WVn2eGI4+aZCeopXX1+JKfqndvVG7gPeQs4tF+F
         tfwhfh9mDJQ9NoFGAy+gt1lCxtconWYL59nhnG/G8ReS6i4XO3CoaBz/ujP6eLntseyP
         WtkAi/ktHxOt4fxkZPJpFsgiR9AszU+inztq6xcPa4l8MFTCd0/SCCBq7RTrgNinbZB8
         hEFK+aiBK1A9bxEpktQRGI0kUcJAk1eXTEBC6zcUkjrgc4qXigxdfxO9Rez9BYullpkG
         tQCdVXZs6GZPMSpqOD+3unPgC/4KE9ZQecnr3kLGh1AbFXzX0EREfvlS6I3IyMQZ0rDz
         NV0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xNC4GKfsuKlJo0ks5R+TsYe4+mdZTlxFml84dsSDHJQ=;
        b=LPoH0SW+q+BMmOvYgokbutu0/leQayegXMbwBIHXwPJ1cMQpPvDPQWdEtFBJyX4VF5
         zHp28mX2UBlvLCjHGEwGrEf3ujQxLbw2WonVm2oD++j6HyZREJB1BuyL64AXF3ohcReo
         Szi30OOiYdYoGxQdc2Ky+HcxE+Wh/aANJEekQiB1vqo92HTkiREnnXdJf6p/RRVStBrX
         D6cvyM1s16qG/nz2r6REe9LEWncm/rGtDChBiy/APFpqziwYLix0DGD6WlMF1hQyGYa+
         VXrt2L+sWfJI3/LiCp8h2wqd/BbzKkYQRHpxNDPEcParRwfZm3Q8B2zJ9Cu4IiT/WvLo
         5FKw==
X-Gm-Message-State: AOAM532EkFcr0iG3ACdJMFIrBfXknWh8IJhF+wb5YhfGjs1BlNkZHK3Q
        TQ1tpYaJTdOXsxESDMpNGyHsUXXuLq9PN8DGSW/hZUO869Y=
X-Google-Smtp-Source: ABdhPJwR0uelb6urwPYdblGyI9fRE67CRkVaGotlD9OECGbk6LbgsY6y5Oqd1MAB36NxYnaDH7p0e7NLwMinePQ46DU=
X-Received: by 2002:a92:b712:: with SMTP id k18mr19074264ili.220.1597843890308;
 Wed, 19 Aug 2020 06:31:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200819085304.43653-1-linmiaohe@huawei.com> <1968d5b6-3543-a213-4118-9c36f9a48343@kernel.dk>
In-Reply-To: <1968d5b6-3543-a213-4118-9c36f9a48343@kernel.dk>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Aug 2020 15:31:37 +0200
Message-ID: <CAOi1vP85Jkc51LStsg9Mz0Q0W-s17LcOmvavc=k_X9KF9ML_2A@mail.gmail.com>
Subject: Re: [PATCH] rbd: Convert to use the preferred fallthrough macro
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 19, 2020 at 3:03 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/19/20 1:53 AM, Miaohe Lin wrote:
> > Convert the uses of fallthrough comments to fallthrough macro.
>
> Applied, thanks.

Hi Jens,

This has already been folded into another patch in ceph-client.git.
Please drop it.

Thanks,

                Ilya
