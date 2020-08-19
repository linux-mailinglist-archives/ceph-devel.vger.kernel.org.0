Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFDA249883
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 10:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgHSIrd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 04:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbgHSIrc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 04:47:32 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34FAC061757;
        Wed, 19 Aug 2020 01:47:31 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id a5so23841226ioa.13;
        Wed, 19 Aug 2020 01:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2lLTCczrQh62kbn0LV4P/GWYE36PPuwRyteP+zzX8wk=;
        b=McYBa+sSZfjCaQIc93lGAw+k/ndlaabNewGv30b6LXpCync6L5z8r9ImHnUSlpklJy
         NUUMOYznxFZuN5sVFdbCVfqA375t/McRjJkBEDG/XkTT92S2PoI7L3zjHiQr0xYAiHND
         8z7RRZPlHzwhEdBfgm90GckDUuywceWVq/U1xlvWjgQHTVHlgBoilk85pN3rf3FTOYGv
         etpvUCxjmmda7BvZedieH1C/IIAPNaIA9Nkvv8Px0VGJzKIisEEILwE3C1t4VrjPaGnM
         x7LqUElinnzm31XGUH6cV/3dAqzHH4mjFFjnjxxWMJBOEOF72jnH5WiHPHAiRP+f8TzK
         8YXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2lLTCczrQh62kbn0LV4P/GWYE36PPuwRyteP+zzX8wk=;
        b=sO6iBK9Ur6eNbbgaB3/8nLTT4XbSVtmYak5/HbmUI1+ksOpI+rIIoJouD+RsOGXXVN
         LG8PuMzmH9Jq/hNniMg/GoiCMA2nVznxgE8z67xhZ9TiXeLUNTkTtW/YsxvsWQmfK515
         CSU6h5GuKwt5r9zmFJWYR/qFnEtEvGBFQhR2HC1WjjJCw0cbe2SuxHRRtM7GLQYptkdO
         U5f2Ig44QLzyPV1Kct+iFqBS2anAoTZQctYbgIe/lJLo0R/h9M4ENqPR1yPi/PdMw2eY
         oweZhzjgb2k2Rek/UWgosImydLdXYalhpIo5kD6Zg+pu0p/c+NmC/K0rO26GbWB7P1mo
         93jg==
X-Gm-Message-State: AOAM5317Y3pEJKziE5Lb5m0wa6ldWZoYHmjRLGX8x4cbuuo1M4WY3Scg
        UU7pIcJHXyWlBz3PE5PhrzqA9IkDFe1uivj0MW9C7imd4Ic=
X-Google-Smtp-Source: ABdhPJxbARu2oDv7gtMAcmoO6et/ys63EyOqykbjAxHUUc1m4TcHwBMrqiCVyDECRdnHffOMPGZupite8FjNHspI1Gg=
X-Received: by 2002:a05:6638:12c4:: with SMTP id v4mr21973953jas.11.1597826850919;
 Wed, 19 Aug 2020 01:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200819075747.917595-1-leon@kernel.org>
In-Reply-To: <20200819075747.917595-1-leon@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Aug 2020 10:47:38 +0200
Message-ID: <CAOi1vP-54DybxncMy0tyyy62nsgvQEn0DysbOTpmk_tnxnbv-g@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: Delete features that are not used in the kernel
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 19, 2020 at 9:57 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> The ceph_features.h has declaration of features that are not in-use
> in kernel code. This causes to seeing such compilation warnings in
> almost every kernel compilation.
>
> ./include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_UID' defined but not used [-Wunused-const-variable=]
>    14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
>       |                        ^~~~~~~~~~~~~
> ./include/linux/ceph/ceph_features.h:75:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
>    75 | DEFINE_CEPH_FEATURE( 0, 1, UID)
>       | ^~~~~~~~~~~~~~~~~~~
>
> The upstream kernel indeed doesn't have any use of them, so delete it.
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> I'm sending this as RFC because probably the patch is wrong, but I
> would like to bring your attention to the existing problem and asking
> for an acceptable solution.

Hi Leon,

Yes, removing unused feature definitions is wrong.  Annotating them
as potentially unused would be much better -- I'll send a patch.

I don't think any of us builds with W=1, so these things don't get
noticed.

Thanks,

                Ilya
