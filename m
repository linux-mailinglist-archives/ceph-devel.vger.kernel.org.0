Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2126F9F353
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Aug 2019 21:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbfH0TeG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Aug 2019 15:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfH0TeG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 15:34:06 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CEEE5AFF8
        for <ceph-devel@vger.kernel.org>; Tue, 27 Aug 2019 19:34:06 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id z2so204866ede.2
        for <ceph-devel@vger.kernel.org>; Tue, 27 Aug 2019 12:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=04dcZZdWoCGdkgLdE91CfzDKZ1kX3c5kXpENUrikuRU=;
        b=dANrFpK+pIUeXD+0bqCOVQitGn374k9R6EIP4qA3Sq0/DxbzXl7x03AmKwCkJw/x5G
         Hga33A7cq9J8EBT+lXWsqkHxwLretPzKbrex/X1fk+OBifBuORTbzQrzOkdAEemc3c46
         rLI8aXQHIsZmAqeWcC1R7k0n+LqBk2idLqvlCESaiHIRYPiBfFMh6V3FHg8eA+ZbnflD
         vfo1yLL10xauNGKNqDnBKli5TR/YIaZfdH4h2m8bVVOc4U3bcH+IN0U6yx8EGZCN3s3W
         xuCF6G8ZbapwCHzMuCkWKba6l+YLmCVNeKLYuBXjB1bZTWT7HSZqWVaYcAlxy52s3Pkc
         214A==
X-Gm-Message-State: APjAAAVi/8ORBtFI05GbK4awJsUKthaNNjWDbkuGXnR8N/FB5EsXqg3i
        iVOLqteTtfVkWtprswFXWY5idtuiuZiETI79epdSY0HIrLLadb2DwrPIJFAFD3mUZpNLt8V2GYA
        Anmc5X7Iax9MdTmeveJ0WaN7GmHDWRqGcO1D94A==
X-Received: by 2002:a17:906:70c3:: with SMTP id g3mr22340661ejk.195.1566934444888;
        Tue, 27 Aug 2019 12:34:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxxGEf1mLDpP6mDQ/EXw4olXpMPBsBMksW+eyk2d6hiJHSwfp5r/ADiXRpV+587/KykREPES2ip4qW5yqi3N94=
X-Received: by 2002:a17:906:70c3:: with SMTP id g3mr22340649ejk.195.1566934444621;
 Tue, 27 Aug 2019 12:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190827185705.19016-1-idryomov@gmail.com>
In-Reply-To: <20190827185705.19016-1-idryomov@gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Tue, 27 Aug 2019 15:33:52 -0400
Message-ID: <CA+aFP1DPe=s-_Y=3tEbxG5zYjtjeEWS7WN=gDJU5GH-jQgRkjg@mail.gmail.com>
Subject: Re: [PATCH] rbd: restore zeroing past the overlap when reading from parent
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Aug 27, 2019 at 2:54 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> The parent image is read only up to the overlap point, the rest of
> the buffer should be zeroed.  This snuck in because as it turns out
> the overlap test case has not been triggering this code path for
> a while now.
>
> Fixes: a9b67e69949d ("rbd: replace obj_req->tried_parent with obj_req->read_state")
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  drivers/block/rbd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 58d9f17363d7..13f42f5b06cc 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -3038,6 +3038,17 @@ static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
>                 }
>                 return true;
>         case RBD_OBJ_READ_PARENT:
> +               /*
> +                * The parent image is read only up to the overlap -- zero-fill
> +                * from the overlap to the end of the request.
> +                */
> +               if (!*result) {
> +                       u32 obj_overlap = rbd_obj_img_extents_bytes(obj_req);
> +
> +                       if (obj_overlap < obj_req->ex.oe_len)
> +                               rbd_obj_zero_range(obj_req, obj_overlap,
> +                                           obj_req->ex.oe_len - obj_overlap);
> +               }
>                 return true;
>         default:
>                 BUG();
> --
> 2.19.2
>

Reviewed-by: Jason Dillaman <dillaman@redhat.com>


--
Jason
