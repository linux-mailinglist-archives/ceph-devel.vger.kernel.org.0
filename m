Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C23F357F
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Nov 2019 18:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbfKGRPf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Nov 2019 12:15:35 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:41573 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729171AbfKGRPe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Nov 2019 12:15:34 -0500
Received: by mail-io1-f65.google.com with SMTP id r144so3115826iod.8
        for <ceph-devel@vger.kernel.org>; Thu, 07 Nov 2019 09:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H+dSAGvb/N2yHxFifQIewvD9r6/Nro96buYHc+TkZgU=;
        b=HNEgpRrYRI4ULbux/ytKnBPHX5pi8XCcir1xyIk0DfKv8Cpao8rcnEfpJ9uDRSU4UF
         dt7bYN8YG2BFXq636+T8e4weSfQdyg1KdPAPaOOI9TE+LUffHmZfIZU2MWGmMbIGpK8z
         SPK5rbS+wq9gJ0lWTWVAa9HQE1KF6577JZqm/5l5cj3vdzM1a4k+9246cHD+91+l5JMk
         X0KyEh6K7d103rzQijvLVMcImgzwojvh11MjL89/5irFLY1eQ/MMMBP5olSHrI3+PXq1
         IFqAVpRjZfpQQDvKSUP3H1M1jJXfD6lbLramP9WBHwPMJKepTHU375b8SYSfGdSTbyQt
         pw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H+dSAGvb/N2yHxFifQIewvD9r6/Nro96buYHc+TkZgU=;
        b=Rujr8uTudw5PtgHtFxKjkhe8+vwp0xyORZ2cGcPy3Ak6U4huhsjQiBmJjyt2EmL2Pw
         rGkaRBdphT2hPYSqn3CxKPhx9TeRacwn2d5TIbFe+giUhYrNDfe3hxU7Zwds48yZaf8q
         meNeN9RV89F490Mmw0KshYPYyCfPwQDbFQAOWpaloArT6DjbSpzM8zKSpCCnHHAWmbsy
         EeUQSaF1iklyGFKRupeZ59OCgrbjJ0a6eiOZv9DT8B+vDTjS8s2WSm4+JCHNqc6OJ7Zg
         Zh5nE9GDb3fD18V2epJ4NNuaa4dTlYe2t79f3gIbS8F6RVwS+XQff58YJ1zMlpATMYq6
         llnQ==
X-Gm-Message-State: APjAAAVhgH/Sy+xTzcuR+WtyXPrVwsw4muJ8ESOKnJNXNcnqUBFiURjb
        kXr5zkU8bHXe1fBTd/lDQ6KvUDJb+riwmZve1dA=
X-Google-Smtp-Source: APXvYqwNImVcuZn78Co6P0e11ZbOLbDm2oafboPzAG8vAP12A0NcjZU4Wvj9OoulReatRGfmVldSWBb41uUlb3PXcEQ=
X-Received: by 2002:a6b:ed1a:: with SMTP id n26mr4773795iog.112.1573146932239;
 Thu, 07 Nov 2019 09:15:32 -0800 (PST)
MIME-Version: 1.0
References: <20191107140451.44991-1-jlayton@kernel.org> <20191107143932.65798-1-jlayton@kernel.org>
In-Reply-To: <20191107143932.65798-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 7 Nov 2019 18:15:54 +0100
Message-ID: <CAOi1vP_HQpkCMXbSp75Xs3hUE2aR028GyHe94oVLpumTi8zLxw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: return -EINVAL if given fsc mount option on
 kernel w/o support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 7, 2019 at 3:39 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> If someone requests fscache on the mount, and the kernel doesn't
> support it, it should fail the mount.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/super.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> I sent a previous version of this patch, but it was based on top of the
> mount API rework. I think we're better off reordering this patch before
> that though, for easier backports.
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index edfd643a8205..e75b6b82267d 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -268,6 +268,7 @@ static int parse_fsopt_token(char *c, void *private)
>                 }
>                 break;
>         case Opt_fscache_uniq:
> +#ifdef CONFIG_CEPH_FSCACHE
>                 kfree(fsopt->fscache_uniq);
>                 fsopt->fscache_uniq = kstrndup(argstr[0].from,
>                                                argstr[0].to-argstr[0].from,
> @@ -276,7 +277,10 @@ static int parse_fsopt_token(char *c, void *private)
>                         return -ENOMEM;
>                 fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
>                 break;
> -               /* misc */
> +#else
> +               pr_err("ceph: fscache support is disabled\n");
> +               return -EINVAL;
> +#endif
>         case Opt_wsize:
>                 if (intval < (int)PAGE_SIZE || intval > CEPH_MAX_WRITE_SIZE)
>                         return -EINVAL;
> @@ -353,10 +357,15 @@ static int parse_fsopt_token(char *c, void *private)
>                 fsopt->flags &= ~CEPH_MOUNT_OPT_INO32;
>                 break;
>         case Opt_fscache:
> +#ifdef CONFIG_CEPH_FSCACHE
>                 fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
>                 kfree(fsopt->fscache_uniq);
>                 fsopt->fscache_uniq = NULL;
>                 break;
> +#else
> +               pr_err("ceph: fscache support is disabled\n");
> +               return -EINVAL;
> +#endif
>         case Opt_nofscache:
>                 fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
>                 kfree(fsopt->fscache_uniq);

Applied with a small change: pr_err provides "ceph: " prefix, so
I dropped it.

Thanks,

                Ilya
