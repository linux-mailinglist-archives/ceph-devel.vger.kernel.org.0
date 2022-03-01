Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B08A4C9111
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 18:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiCARDF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 12:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbiCARDE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 12:03:04 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9F6C47
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 09:02:21 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id d11so17221988vsm.5
        for <ceph-devel@vger.kernel.org>; Tue, 01 Mar 2022 09:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+CWb9LWdCinoPsqYIJGKxEddczgmtLnwwgPlIQFKUA=;
        b=BUmNuVs7NG98QyC0ra3ytlEM48XyOEn6W3Fw3tnfSVBqHAsgpmgFhxPlGdcuQONUIb
         MzAqJfcScNX/beNtbfcBiK4DMsXSLQV4mNJyqUCCm7mLBKx4HqSlwOJu19XGOIWggKYC
         v9CmMQt8pMBnNAR/2XgtsC6tHHkqqEjSdZoikfqBYB6f9BSTNFo23fLywTcdrAbTZyNx
         n1iK6xOxx2bHOLBz/X/AcR0Gl4YhAxX1zQYcNmwlFHYBlU0UT4naarISQtgMuPn+81dB
         Um3+nYRqNTyV8hM5W1Ih0o9jNfnZaiprKlrBWeEra7f30FWo/8518Yue/40Sj0ds1PFu
         vShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+CWb9LWdCinoPsqYIJGKxEddczgmtLnwwgPlIQFKUA=;
        b=OUAhK6aaJ3aWhWfLhprGfiOHWgMLQThZ9KU3jbmXfU3Xi/1QshTU1x9Ol4v3EBGEIm
         AIePTbFXdwfxBI3/hZ3AsMLCfRT5HDlVg2uK7l/5IqGHiTmt260pz33IbOjzCLnzlvHm
         Trnx4ivf9VfqL/is5g9G3yiBJnNAV7byITNDzZRvXmgVy4+Ua+Y3Wp1fj1hS1GlYWA4V
         9vw4hM+U82awDwruc6n8nEYhTPYKtIQbdwmlcnHpG5sg9+PW2GNRHDVTNjHpHYgyiaab
         Lr5+rrU+lLXGR8ynilU/nCsiPoAh3UKzvaD74v53Lh560UqXdtSS9rk3HzuA4Es9oyIb
         2SKA==
X-Gm-Message-State: AOAM5302dUmIJxYOE1NbM3a6eWM6pjTmxCAVOp7uwGaNKwt4r2/EFmAY
        zaTgRhGoK9tAwMf6Zp/fMmDaFsMA9yOGi2LNOYqu9aJmE8I=
X-Google-Smtp-Source: ABdhPJwakTsBy6vtANMsAb1J7dI9+Xz5VWTjj/2IlBpvRK6Tw2M1ZYNXG6vPIS47vbA62h95jdrp9+6RxbYTpZKHNSw=
X-Received: by 2002:a05:6102:37b:b0:31b:fc56:c7cb with SMTP id
 f27-20020a056102037b00b0031bfc56c7cbmr11599796vsa.57.1646154140488; Tue, 01
 Mar 2022 09:02:20 -0800 (PST)
MIME-Version: 1.0
References: <20220209153849.496639-1-vshankar@redhat.com>
In-Reply-To: <20220209153849.496639-1-vshankar@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 1 Mar 2022 18:02:45 +0100
Message-ID: <CAOi1vP8C7q97mKFcCAb-_BAJfAg85P2mW+dmRzhw376K_v7riA@mail.gmail.com>
Subject: Re: [PATCH] ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>, Xiubo Li <xiubli@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 9, 2022 at 7:55 PM Venky Shankar <vshankar@redhat.com> wrote:
>
> Latencies are of type ktime_t, coverting from jiffies is incorrect.
> Also, switch to "struct ceph_timespec" for r/w/m latencies.
>
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/metric.c | 20 ++++++++++----------
>  fs/ceph/metric.h | 11 ++++-------
>  2 files changed, 14 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 0fcba68f9a99..a9cd23561a0d 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -8,6 +8,13 @@
>  #include "metric.h"
>  #include "mds_client.h"
>
> +static void to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)

Hi Venky,

I think ktime_to_ceph_timespec() would be a much better name.

> +{
> +       struct timespec64 t = ktime_to_timespec64(val);
> +       ts->tv_sec = cpu_to_le32(t.tv_sec);
> +       ts->tv_nsec = cpu_to_le32(t.tv_nsec);

ceph_encode_timespec64() does this with appropriate casts, let's use
it.

Thanks,

                Ilya
