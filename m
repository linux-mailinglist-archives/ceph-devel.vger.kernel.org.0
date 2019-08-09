Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28891872FD
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2019 09:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405691AbfHIHbz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Aug 2019 03:31:55 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34364 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfHIHbz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Aug 2019 03:31:55 -0400
Received: by mail-ot1-f68.google.com with SMTP id n5so129207117otk.1
        for <ceph-devel@vger.kernel.org>; Fri, 09 Aug 2019 00:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zwdlLfMc/yiQyysjoYkXxWUDuGMgwibfGXKfndYMVao=;
        b=bFluIBHu042bBPL/WFX41hYwvytCgiYjmNcSRW8cs76RHCzC+0+9rbk5Pfbppc1bee
         hi1nV9xzZSG/2gBgvkZlD7eSkFyDTd5zYq1nsz5kAQS0bM2UPvBfPiUGntZ8aqK3fTix
         DYEngFsgcgve3Vgb7xzT+QlULFC+Hhe2pvOUOsSKWIkh4jGYbcxFr3jYjHNFXHZ6Yya8
         Df3fM7wIjqKNjEo7Yxk+l8oEjhfF8SREi6wNl9XBnwmdOjfZoml0ZoHo1c30mHSgLAXu
         EmTxbP9gcCdayQvaYrTU4eXJwJwfTYpnBxmcAA/CWCQ2+JSMNB7YasR5tQKJyTnlt3Ax
         rkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zwdlLfMc/yiQyysjoYkXxWUDuGMgwibfGXKfndYMVao=;
        b=DrxoB1+8r/dtf8TNP+Q/OuQZdg9fcLQbA3dVzX52XOgPtcmUObDqgfdItBjQVUqjj6
         Cj4lJr/HlZXbaEumXfZN3adf7/kymaADFMVkuAkR7EP93BiFpp+SH78ZHx6BmPfMi9Td
         Oz6DCnxNdDpUtld0ini1O0mtr0NMvcKjnceMIcaNcjASddQGnm7OzN8odTWwFQTZX1gT
         e/IS+hYkt4o19jjB7K/ghWy4TLTJ1popm0ZlRFA4xsqzst53lwUvGEouwf2MhAU/vooN
         bwkHBJe5WY5S4A3TwDMRu4ye3G/mbZnjPN+7ayWy5eEO7m1OHY2oMUjN3sMR/R48Ry9n
         wqNg==
X-Gm-Message-State: APjAAAWUPHaBaNEBFKdTFfDUuo5g9/fM/AwBsYaBCoip+8HwFgZPEFgn
        Li6gRWAcloPk80pTtFdBiv4cvkVlQf8cIHL2u9nFygcE
X-Google-Smtp-Source: APXvYqwLHxKex7IGaJLJZHN+/SbOxnEOxr3SsFm44foCJ7MlV/w4gvucV6gCbRyIUoUdSjuL3sLX5U6SFfqXTjyozjU=
X-Received: by 2002:a5d:9550:: with SMTP id a16mr19461483ios.106.1565335914724;
 Fri, 09 Aug 2019 00:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <1565334327-7454-1-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1565334327-7454-1-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 9 Aug 2019 09:34:51 +0200
Message-ID: <CAOi1vP9p8YHykG3dmUa=VekcTSd+3hOei4N+JDcMDSoqvV10aQ@mail.gmail.com>
Subject: Re: [PATCH] rbd: fix response length parameter for rbd_obj_method_sync()
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Aug 9, 2019 at 9:05 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> Response will be an encoded string, which includes a length.
> So we need to allocate more buf of sizeof (__le32) in reply
> buffer, and pass the reply buffer size as a parameter in
> rbd_obj_method_sync function.
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>  drivers/block/rbd.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 3327192..db55ece 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -5661,14 +5661,17 @@ static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
>         void *reply_buf;
>         int ret;
>         void *p;
> +       size_t size;
>
> -       reply_buf = kzalloc(RBD_OBJ_PREFIX_LEN_MAX, GFP_KERNEL);
> +       /* Response will be an encoded string, which includes a length */
> +       size = sizeof (__le32) + RBD_OBJ_PREFIX_LEN_MAX;
> +       reply_buf = kzalloc(size, GFP_KERNEL);
>         if (!reply_buf)
>                 return -ENOMEM;
>
>         ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
>                                   &rbd_dev->header_oloc, "get_object_prefix",
> -                                 NULL, 0, reply_buf, RBD_OBJ_PREFIX_LEN_MAX);
> +                                 NULL, 0, reply_buf, size);
>         dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
>         if (ret < 0)
>                 goto out;
> @@ -6697,7 +6700,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
>
>         ret = rbd_obj_method_sync(rbd_dev, &oid, &rbd_dev->header_oloc,
>                                   "get_id", NULL, 0,
> -                                 response, RBD_IMAGE_ID_LEN_MAX);
> +                                 response, size);
>         dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
>         if (ret == -ENOENT) {
>                 image_id = kstrdup("", GFP_KERNEL);

Hi Dongsheng,

AFAIR RBD_OBJ_PREFIX_LEN_MAX and RBD_IMAGE_ID_LEN_MAX are arbitrary
constants with enough slack for length, etc.  We shouldn't ever see
object prefixes or image ids that are longer than 62 bytes.

Thanks,

                Ilya
