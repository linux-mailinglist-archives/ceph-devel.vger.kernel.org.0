Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3DEF453D
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Nov 2019 12:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbfKHLA5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Nov 2019 06:00:57 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35681 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfKHLA5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 Nov 2019 06:00:57 -0500
Received: by mail-io1-f66.google.com with SMTP id x21so5921510iol.2;
        Fri, 08 Nov 2019 03:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hH39muwuJRXPDNu9kTQY7hTmvUS5WmaEQlN9EH3ORjA=;
        b=kA4+dUfOu43O0EDqv91oVu3IAA49D78Xta86kgnUNPoOb32k0VPYznBLuavQo5XcPz
         HKsMgz6ZdQKHuW3gWXXoSTTIDKnxyRoyngsL0Pvyzn1vpU94EI27rITlXKzVVGFKdFgS
         cct4+FgR0/K+UmZfEhwan969tqHK8kB+8+9RCwfiscIuzONBFfmJKkV6Nshj9mXT2LGR
         URzYfeIHwnoV3B90hJxI05CGEbzBojjs607BdR43wtOsSRlru3zbOLmbm/vmtoLzn0SY
         7duj9OHqWwerVxLjkspgp8zfrwdXPY1Fibo6jI6PWhhPLzFzlZPCsYOkH7SCo0ZQ8jLx
         fQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hH39muwuJRXPDNu9kTQY7hTmvUS5WmaEQlN9EH3ORjA=;
        b=RtNtElYd6FtR6QA56/kgEsGX9l33m68uQT2wDRiABFoTukrH6kCgttFzw2Bf8a3Lpb
         40f40OVQfdFobt3TfPOkSbfVS0uasG7GdG3C0sJqLs7Bez8PC0dVnpEWBbvtaY9Yvcnp
         t7kfQTK/vhgw2LqcnyEmVP4/Vad3XTnq4WXJGXOHT5QQDDO3skkLlvtA/wOO4m4oCdwL
         Ohzo0K/pdGyF+2Qm7jaIRKZWL/UJPJ8IvQnr1vtmt89LgpSZZoXz/CNG7gW9FqShZMjv
         y98cTMD8v+dzcEATEzvDITSPv67A51OZNqxSFbub7T89wTGWUE13Bt5CACCQNDLioaRZ
         iFjQ==
X-Gm-Message-State: APjAAAWMfyRRMQk6OxyAyxsZCzgWQhQi1CF89yD0xRyP26flsCpQnvuH
        34cxy1wLxWNQVZ932onBgKSHjeFnufTCPn50BsU=
X-Google-Smtp-Source: APXvYqxauTGfSIZm82+tq7NhjJxQuwnVevU2QPgWPBXjGi/UoCqWZAH1Ghg1vJBVz4dJUFcd6Q0GNVxjMvLV8sFloGs=
X-Received: by 2002:a05:6638:5a:: with SMTP id a26mr10357021jap.76.1573210856539;
 Fri, 08 Nov 2019 03:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20191107223646.416986-1-colin.king@canonical.com>
In-Reply-To: <20191107223646.416986-1-colin.king@canonical.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 8 Nov 2019 12:01:19 +0100
Message-ID: <CAOi1vP_AXiZaRUaKXxBOkoK8bh+V1oh6hxMsobCjbyNq_FGpGQ@mail.gmail.com>
Subject: Re: [PATCH] rdb: fix spelling mistake "requeueing" -> "requeuing"
To:     Colin King <colin.king@canonical.com>
Cc:     Sage Weil <sage@redhat.com>, Alex Elder <elder@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 7, 2019 at 11:36 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a debug message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/block/rbd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 39136675dae5..8e1595d09138 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4230,7 +4230,7 @@ static void rbd_acquire_lock(struct work_struct *work)
>                  * lock owner acked, but resend if we don't see them
>                  * release the lock
>                  */
> -               dout("%s rbd_dev %p requeueing lock_dwork\n", __func__,
> +               dout("%s rbd_dev %p requeuing lock_dwork\n", __func__,
>                      rbd_dev);
>                 mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
>                     msecs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT * MSEC_PER_SEC));

Applied, after fixing the spelling mistake in the title ;)

Thanks,

                Ilya
