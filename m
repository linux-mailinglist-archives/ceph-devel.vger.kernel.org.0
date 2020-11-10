Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773A72AD0A6
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 08:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgKJHvK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 02:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgKJHvJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Nov 2020 02:51:09 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EF0C0613CF
        for <ceph-devel@vger.kernel.org>; Mon,  9 Nov 2020 23:51:09 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id s10so12860569ioe.1
        for <ceph-devel@vger.kernel.org>; Mon, 09 Nov 2020 23:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+zvJdlonyBpq+us02PMdGrr9qyTL7HkAN5cNIVMiQsY=;
        b=mSVpgEtMexFFNQ8Thnzd37e8ShEi6J/HMfTPgRdFvg6Q53PPUZbQBBcQKa38YsR/lF
         2Lh5QeWYTPoRO7pE1+pK7PBNik9vlwxejYNUTcSBj7sTXEZ1QE77WhjdQo6Kw5USa1Nr
         IHFaul1BBrbBT7U+rWRRqXJz7qhbowzUq0LU1oemyf1pU5GY6c/Zm9spp+VaR/C/lvPA
         /XNW0tuwWSicnn2Hz8s53Hnw934RuQ83BnAS36mL/n0edbxgJ7vcBb3tf1y8Xi93MASf
         9cQLDxMOZJo7q9JiJ1IbemIqjZ8AP5LCW/1wRBlGl7x3FLuGS9pLQc8RJJO4Gec8z9xK
         whlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+zvJdlonyBpq+us02PMdGrr9qyTL7HkAN5cNIVMiQsY=;
        b=a3IzE93EVvznay/Ye5axYp+6eoWCWkmQ/j1xhS+/fFAmJMD2MJuyoceJzCTgDk4aMl
         lCoVoQiOhF4C/rnapKEASbqHgIwZ9YbI8edu5giDZrmKjo3ZBjyb/rp20NAdCDI5ZIJN
         1+muBeCtYew+VFn+vytofZtHH+qW2BVaSjabW/pFLnoc6fsbLGEP3PYZGSYCO6o9YeD/
         pNbojf3PG8xlVY3otuVSgGT98ubPPGc3i3t6zw1JUOxxKG9oeceqEqXhA3dfuRZhon6h
         aH7OPCJCSK/d63J7WMzxEdQidisrgrLvjwQCYjALeG5AFjOWV5O/yI0Fmx0EK8FHpDVl
         W12g==
X-Gm-Message-State: AOAM532mpKUlaKKEyNwEDYhF7a2INFM57a4l8paLGVy5ugelSdTeVEQt
        YVKAg57t0xsXH+uiWktPl1GZe1Kyqhw37J9Rt5w=
X-Google-Smtp-Source: ABdhPJx3EZyyKx4JWvg7eYuJlrj+QzDK1gV+ZlUVLKJUYRx1cY8/bgEGCCaTLUf8/Ze2XHtckY+XNc/M1mxIskynJ5A=
X-Received: by 2002:a5d:8344:: with SMTP id q4mr12843251ior.182.1604994668948;
 Mon, 09 Nov 2020 23:51:08 -0800 (PST)
MIME-Version: 1.0
References: <20201105023703.735882-1-xiubli@redhat.com> <20201105023703.735882-2-xiubli@redhat.com>
In-Reply-To: <20201105023703.735882-2-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Nov 2020 08:51:09 +0100
Message-ID: <CAOi1vP9r5FMaLsO_xZ6UDnq24aAL-L1cc0CK2do5sR61vfy=Ag@mail.gmail.com>
Subject: Re: [PATCH 1/2] ceph: add status debug file support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 5, 2020 at 3:37 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This will help list some useful client side info, like the client
> entity address/name and bloclisted status, etc.
>
> URL: https://tracker.ceph.com/issues/48057
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/debugfs.c | 22 ++++++++++++++++++++++
>  fs/ceph/super.h   |  1 +
>  2 files changed, 23 insertions(+)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 7a8fbe3e4751..8b6db73c94ad 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -14,6 +14,7 @@
>  #include <linux/ceph/mon_client.h>
>  #include <linux/ceph/auth.h>
>  #include <linux/ceph/debugfs.h>
> +#include <linux/ceph/messenger.h>
>
>  #include "super.h"
>
> @@ -127,6 +128,20 @@ static int mdsc_show(struct seq_file *s, void *p)
>         return 0;
>  }
>
> +static int status_show(struct seq_file *s, void *p)
> +{
> +       struct ceph_fs_client *fsc = s->private;
> +       struct ceph_messenger *msgr = &fsc->client->msgr;
> +       struct ceph_entity_inst *inst = &msgr->inst;
> +
> +       seq_printf(s, "status:\n\n"),

Hi Xiubo,

This header and leading tabs seem rather useless to me.

> +       seq_printf(s, "\tinst_str:\t%s.%lld  %s/%u\n", ENTITY_NAME(inst->name),

                                             ^^ two spaces?

> +                  ceph_pr_addr(&inst->addr), le32_to_cpu(inst->addr.nonce));
> +       seq_printf(s, "\tblocklisted:\t%s\n", fsc->blocklisted ? "true" : "false");

This line is too long.

Thanks,

                Ilya
