Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED58C30BE53
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 13:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhBBMgg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 07:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhBBMgT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Feb 2021 07:36:19 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2744DC061573;
        Tue,  2 Feb 2021 04:35:39 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id u20so6960773iot.9;
        Tue, 02 Feb 2021 04:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pk+wpqbCAe4I46yOh6S+R7rrTPaxklQnaM5Nq4w5vlM=;
        b=qom9KtqXuEGXqsp6PCWauy/cZbndP8+XZfRL6igySi+vVDRU++z9x+7njiZxlHN2Tt
         v7J8qdUhgD7UKQqnkxTXx8Apv2wvm7XJz06otiiu6uTj8Gl2K7GXXD//zpNrBqAqQ/1N
         O/EU0aC0HMB0+QEK/KuyOkmirtD6fGM164Sec0f24zU8JiWjpZ+mhTeez+qZAIHbg4um
         OCiJ8WK6w/4Fz/OEldDWR1W9EkFrb4xfkJ5iXcKKL875IGpGKNGsNKHjKMYbTrxIlYW8
         L81EaHtAbEfJ5mQPeZH/91hnxj5X68Vg3E+G5DvrUkA/XPIT/GAF6h6Qkkmu4/rTsEBT
         58Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pk+wpqbCAe4I46yOh6S+R7rrTPaxklQnaM5Nq4w5vlM=;
        b=MW48y9f1H8IwlDlFjOv4H5OFWySBi4DnDFPtNWr+G+/HpVsRK4YLEXLvGy91FX0J3i
         DPI8v0OP4itlZL4XdehP4blFqYm317V+ttH8K02sKvL43ZBXxvu8PHIyr+5jr32oxFTH
         9+p9wUT3GPBv3ADRHFcEIlplSEpKjUMCLZhzfRBCt7kMnl+ivaozbPclReHZxUXbZLPo
         NjtT3QoUAz9LmW/WH3WB2O9XYIHoqf5cHZVA3ExZFpCUj9/mR/8v1/b1q02bEexzUbEt
         /ESNE7wsDUopb1It1Bw+EuBaC5bpk0dzO0X5FSJry9/srZ/izsU3nzAcUtzmfi7rZvcp
         9ecQ==
X-Gm-Message-State: AOAM530mpqwocWOR8X+xSURfCSwvF7DBnXyLUTZuMQ8+R4ZVqAx+ihqE
        3otB1uP8LItun/RgSxHYQrHR2zzcvCTqlsY4hK4=
X-Google-Smtp-Source: ABdhPJzI80HZKkno6cMLw6Xpih+WJv/HHTAfdPNg6yhoZLoV3SRngH2WGJAsTajy5F9JpJaupCOpnDHDQVoFUggYq+g=
X-Received: by 2002:a02:c724:: with SMTP id h4mr10803895jao.69.1612269338483;
 Tue, 02 Feb 2021 04:35:38 -0800 (PST)
MIME-Version: 1.0
References: <YBjne8A1gn0mvQtT@mwanda>
In-Reply-To: <YBjne8A1gn0mvQtT@mwanda>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 2 Feb 2021 13:35:35 +0100
Message-ID: <CAOi1vP_GSHBFwDeuAatpTbuJM90ootzZ31-oK1FKKM93JOmf_g@mail.gmail.com>
Subject: Re: [PATCH] ceph: Fix an Oops in error handling
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 2, 2021 at 6:47 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The "req" pointer is an error pointer and not NULL so this check needs
> to be fixed.
>
> Fixes: 1cf7fdf52d5a ("ceph: convert readpage to fscache read helper")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/ceph/addr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 5eec6f66fe52..fb0238a4d34f 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -273,7 +273,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
>         if (err)
>                 iput(inode);
>  out:
> -       if (req)
> +       if (!IS_ERR_OR_NULL(req))
>                 ceph_osdc_put_request(req);
>         if (err)
>                 netfs_subreq_terminated(subreq, err);

Hi Dan,

I think a better fix would be to set req to NULL in the offending
IS_ERR branch since ceph_osdc_new_request() never returns NULL or
use two separate goto labels.

While at it, the initialization of req and the check on req before
calling ceph_osdc_put_request() are redundant.

Thanks,

                Ilya
