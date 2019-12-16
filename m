Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720CE12022C
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2019 11:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfLPKSj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Dec 2019 05:18:39 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40754 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfLPKSj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Dec 2019 05:18:39 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so6300952iop.7;
        Mon, 16 Dec 2019 02:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+GgIS4fK3foXfOkjG5c+itGFh/aaREmMXIf6LbJ6u04=;
        b=ja7PQLeEkiDTk/1HbIvtfrV45H6MjjomZx0HOTpeiNmJ65HbwE+Zk61npRJW33nTxZ
         xS8vBHZEnIzdb0sleNp50EIEktNNQBcay27zCarPFTrEQdT/8AztXXgkHP6wNj7AK5sE
         a3+VT3jVYKqFQnxbrUjd9hHsTBaZY4qdeRNUPn06sgI/96UIX1d2zcdPiJxfrgcSxzmr
         a3sfOxhrhqCcRu1PnHIb6aMgwnFAU6s4nLmh5MCemm6+WRrZwvQRg4efsosJ/IxNjTXV
         NW9f3ySfDnd4etfsr19nhZW7GU1l/w18fjcg1bBNpLdWdJIW/PNJQ8vr/qxiN+NxHXo+
         jMqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+GgIS4fK3foXfOkjG5c+itGFh/aaREmMXIf6LbJ6u04=;
        b=FhpP8WUbjneQ4DErSQ3Beo6VS4nregJMOjstsUC3z71jHoV7iRcoOqeSzCOhD4nCL0
         z3Z3iax2SnixQcYurb1LlhTW4kEL958BLVyAJWTY86wlo8Stomf/HQYLzSY3csxddewY
         j9g+3/jm3jNkMhJGs2HWS+Zel9j19a+JwK/LzvYPWZ4JesjdoDBYH+EoqKRBIS4TitKL
         cE0jSRjA2rhm7jj+pEz4K8INJG6hGC7fcnMWpDFeHtngNLVtM4j/5+J9lE4Su7ls6Y89
         qC6LYBsFh7BEB0/YwT90dFtLJiTzJ+2CUmO1t7Buk+oLIuksQ1Zi3noSnJO4TIu7EYuE
         bfqw==
X-Gm-Message-State: APjAAAXOsjP5TJULrZN3UJZTHb/QdHGZ+MUrzD1ZM3N/3uSeETVqJGR6
        uStgxsPYi915xAmaYwj20qGTxm8xUF4rOH6cDiM=
X-Google-Smtp-Source: APXvYqxoh858PNHZB7uHMCGrVa8cRE8NisYggC+V7jSdmoGFT16dbgpqFxL7ZtIlG1lc+mhAhnDyMuU0vYDhy9Si+XI=
X-Received: by 2002:a05:6602:114:: with SMTP id s20mr18373081iot.131.1576491518443;
 Mon, 16 Dec 2019 02:18:38 -0800 (PST)
MIME-Version: 1.0
References: <20191215163527.25203-1-pakki001@umn.edu>
In-Reply-To: <20191215163527.25203-1-pakki001@umn.edu>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 16 Dec 2019 11:18:30 +0100
Message-ID: <CAOi1vP_dYP05Wj1fpH-U2WLGhOBp3RmFXPvjYmjorx_MLZW6Zg@mail.gmail.com>
Subject: Re: [PATCH] rbd: Avoid calling BUG() when object_map is not empty
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, Sage Weil <sage@redhat.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jens Axboe <axboe@kernel.dk>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Dec 15, 2019 at 5:35 PM Aditya Pakki <pakki001@umn.edu> wrote:
>
> In __rbd_object_map_load, if object_map contains data, return
> error -EINVAL upstream, instead of crashing, via BUG. The patch
> fixes this issue.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/block/rbd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2b184563cd32..6e9a11f32a94 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1892,7 +1892,8 @@ static int __rbd_object_map_load(struct rbd_device *rbd_dev)
>         int num_pages;
>         int ret;
>
> -       rbd_assert(!rbd_dev->object_map && !rbd_dev->object_map_size);
> +       if (rbd_dev->object_map || rbd_dev->object_map_size)
> +               return -EINVAL;
>
>         num_objects = ceph_get_num_objects(&rbd_dev->layout,
>                                            rbd_dev->mapping.size);

Hi Aditya,

Could you explain what issue is being fixed?  Did you hit this assert?
If so, under what circumstances?  The fact that __rbd_object_map_load()
can fail doesn't mean that it shouldn't have asserts...

Thanks,

                Ilya
