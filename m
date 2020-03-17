Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7488A188921
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Mar 2020 16:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgCQP0K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Mar 2020 11:26:10 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51366 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726019AbgCQP0J (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 11:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584458768;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=SaqqGlq6hvAJ+BtAdh3RNRkm5LrTdKt2AcCfcwi7CcI=;
        b=bTKOtY8LQsGtPfkmfcJCfRP+QTMJhBeCz97zsB6uIcrBDRaZIYfTOOvEqZ06AdaAmj97NG
        eLGi2KyaFgS6lgcyLLrD5G7K7QUC50FpdCLCVpSNAuy5Vw8jJKsq6SWWA+PTwcsds5z3My
        ETvj8BZk3zOQuVa4KZToCopXvAMd2cw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-i4ppsuJMNUmWIkWOR1nFYA-1; Tue, 17 Mar 2020 11:26:06 -0400
X-MC-Unique: i4ppsuJMNUmWIkWOR1nFYA-1
Received: by mail-wm1-f70.google.com with SMTP id n188so7293042wmf.0
        for <ceph-devel@vger.kernel.org>; Tue, 17 Mar 2020 08:26:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=SaqqGlq6hvAJ+BtAdh3RNRkm5LrTdKt2AcCfcwi7CcI=;
        b=jAwRtvMo0SzMl/E7aNp54Xs9qBR3QKbW7AJl5vHEwRCC/IcoMoRolUbcpSQmHe5GXP
         JAInziQfs+uJcAJhadBYN1TPgU6qABj8tiTDK1LVe7BjMjt4Ch8Dt+oylNNC4BN35AZW
         n3dgLIuCzZBcYkZKZQXtpXy0A4a6XSAZO9bAHlJ4PfjdSTEihQ/l0ok6oAlwJqTVlXcN
         3AYTcfzXiJOfxQqDIt7bMpsV8AUSNVJnWqVDjHY5z3c+32tEOQEQe3fdl10iQK9wDMR7
         TRWa60xON1B5Xu2jUd5eHzsPMYKtWHnL75Q+YyzLhg31QCrP4smb4SH/FcQsaTqH7aPl
         ccGg==
X-Gm-Message-State: ANhLgQ2T9YbvxEQlSVMhGb9CkzyS27dp1hwtSc4IlCjNrhub330jqCQ+
        3jyBuexmRWnBPx9h/T5OCHv5a/YVohqMVpFAdffdx5VnbTwj9UK4H9ceZkgIefGazcTA9/UpXAP
        UwhorQQtd3Bn41/b4Gmch8OUCYHTJvHZciXSKoQ==
X-Received: by 2002:a7b:c20c:: with SMTP id x12mr5979183wmi.80.1584458765162;
        Tue, 17 Mar 2020 08:26:05 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vviMxASJwZbJTydFNdj4VGJ1MPC7FT9khY07OTApSF1VvQvlBRw9aENEHot8jgt+rFAh1lkMWrs0SW4G4BOFEE=
X-Received: by 2002:a7b:c20c:: with SMTP id x12mr5979163wmi.80.1584458764904;
 Tue, 17 Mar 2020 08:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200317144847.10913-1-idryomov@gmail.com>
In-Reply-To: <20200317144847.10913-1-idryomov@gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Tue, 17 Mar 2020 11:25:53 -0400
Message-ID: <CA+aFP1C_M8AorihGCj16jVE7UY-z9LSnMmQ2r_o52QcN4JW3-Q@mail.gmail.com>
Subject: Re: [PATCH] rbd: don't mess with a page vector in rbd_notify_op_lock()
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 17, 2020 at 10:50 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> rbd_notify_op_lock() isn't interested in a notify reply.  Instead of
> accepting that page vector just to free it, have watch-notify code take
> care of it.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  drivers/block/rbd.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index f44ce9ccadd6..acafdae16be2 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -3754,11 +3754,7 @@ static int __rbd_notify_op_lock(struct rbd_device *rbd_dev,
>  static void rbd_notify_op_lock(struct rbd_device *rbd_dev,
>                                enum rbd_notify_op notify_op)
>  {
> -       struct page **reply_pages;
> -       size_t reply_len;
> -
> -       __rbd_notify_op_lock(rbd_dev, notify_op, &reply_pages, &reply_len);
> -       ceph_release_page_vector(reply_pages, calc_pages_for(0, reply_len));
> +       __rbd_notify_op_lock(rbd_dev, notify_op, NULL, NULL);
>  }
>
>  static void rbd_notify_acquired_lock(struct work_struct *work)
> --
> 2.19.2
>

Reviewed-by: Jason Dillaman <dillaman@redhat.com>

-- 
Jason

