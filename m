Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E503B8280
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 14:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhF3MzC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 08:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbhF3MzB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Jun 2021 08:55:01 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413ECC061756
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 05:52:32 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id s11so1441343ilt.8
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 05:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7M3XkswHn7Py5Yj8aUqAKPNFc/6EbRTEIWeRSWblSzY=;
        b=eubTQKbb2X6mNveKgdpj2vxbEb3XbJxhxv/DTNkXwNedqR2jerKg+A6Sd/fg6x6FTu
         b/jhbBIhX6a/UL2tk4G51m/YsnJ90G9oIBdvVORQcnqaLAJ9cD2xvdO/2J7I8ntV1eIr
         BQzIOiMOpLhwtLVyQOY3fp5g2yvjarXHJw9Kx6a4uW2mi5GQKXQp7l+eLt90d7DCKlra
         YyeWL+LzSjsw9yF9sSZ2i2RAPxCNucI+R5FUwUxPqlL31cjgaHYtaLGepSmDnq+YrUN8
         5NWo/dpc3j6z2uwIT++eFS8igfhD2Tnt7C4Zzsy9+W8d+OjHxHBlxp2c+tOKFEE1FOJG
         R8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7M3XkswHn7Py5Yj8aUqAKPNFc/6EbRTEIWeRSWblSzY=;
        b=TytpO7KIJNZOAh7wxuzN/KSIxe5ESiXLQ5OSKUCgrxulIpC+j7LG7KvNkgL8YEod6V
         5OdTcGDoPaF/sCbDUuFe1lAMEsyyJUuW4glQ0hUdpdOUywUIBtcEENSfHwlbDW0OE4RU
         eDSgqdIZX3k+EZmShSR4RLAWAhAaTyhHIfZR3nSpNQZEklxk5sxKaf9UFyilIqIIDHXi
         QAYghk4sqK7MPjgJuTt4T5p539EbfB1gxz1xNxIcUAwcIAuofKUhdW2eajG9U/tK84yB
         3cZilzOkK+wO65EA7rhs5r3iQWzKhzZ+2kPa8OrW78Xx9e38QUCZl70df1kEnm/3fJaW
         Dqsw==
X-Gm-Message-State: AOAM531WTMDgI9FzccIg3MsAYnsFgVAh+XSrpXd7BbMporXLsFbAOhyJ
        bk9fCSzjLDSKkdybJK1KMq/WWdGWXAyWuIjRXE0=
X-Google-Smtp-Source: ABdhPJyXw8owDl/CzJK6godLsKlAB91uPjsT1bhLISfYZhEEJ4pvjDSqNcwX/0+mxovtH59wgDZcWMNM+Jj++gNkdS0=
X-Received: by 2002:a05:6e02:50e:: with SMTP id d14mr3907661ils.281.1625057551791;
 Wed, 30 Jun 2021 05:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210629044241.30359-1-xiubli@redhat.com> <20210629044241.30359-6-xiubli@redhat.com>
 <d98d4f50cdad747313e6d9a8a42691962fdcd0ae.camel@kernel.org>
 <d91f6786-24fd-e3a9-4fe8-d55821382940@redhat.com> <7d4b7f733b07efff86caa69e290104e5855ba074.camel@kernel.org>
In-Reply-To: <7d4b7f733b07efff86caa69e290104e5855ba074.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 30 Jun 2021 14:52:12 +0200
Message-ID: <CAOi1vP_CR96Nw6J-JTiL7z_zaAXCeYp-hvoqAYb80Av4P1Jhqg@mail.gmail.com>
Subject: Re: [PATCH 5/5] ceph: fix ceph feature bits
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 30, 2021 at 2:05 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2021-06-30 at 08:52 +0800, Xiubo Li wrote:
> > On 6/29/21 11:38 PM, Jeff Layton wrote:
> > > On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > >
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > ---
> > > >   fs/ceph/mds_client.h | 4 ++++
> > > >   1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > > index 79d5b8ed62bf..b18eded84ede 100644
> > > > --- a/fs/ceph/mds_client.h
> > > > +++ b/fs/ceph/mds_client.h
> > > > @@ -27,7 +27,9 @@ enum ceph_feature_type {
> > > >           CEPHFS_FEATURE_RECLAIM_CLIENT,
> > > >           CEPHFS_FEATURE_LAZY_CAP_WANTED,
> > > >           CEPHFS_FEATURE_MULTI_RECONNECT,
> > > > + CEPHFS_FEATURE_NAUTILUS,
> > > >           CEPHFS_FEATURE_DELEG_INO,
> > > > + CEPHFS_FEATURE_OCTOPUS,
> > > >           CEPHFS_FEATURE_METRIC_COLLECT,
> > > >
> > > >           CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> > > > @@ -43,7 +45,9 @@ enum ceph_feature_type {
> > > >           CEPHFS_FEATURE_REPLY_ENCODING,          \
> > > >           CEPHFS_FEATURE_LAZY_CAP_WANTED,         \
> > > >           CEPHFS_FEATURE_MULTI_RECONNECT,         \
> > > > + CEPHFS_FEATURE_NAUTILUS,                \
> > > >           CEPHFS_FEATURE_DELEG_INO,               \
> > > > + CEPHFS_FEATURE_OCTOPUS,                 \
> > > >           CEPHFS_FEATURE_METRIC_COLLECT,          \
> > > >                                                   \
> > > >           CEPHFS_FEATURE_MAX,                     \
> > > Do we need this? I thought we had decided to deprecate the whole concept
> > > of release-based feature flags.
> >
> > This was inconsistent with the MDS side, that means if the MDS only
> > support CEPHFS_FEATURE_DELEG_INO at most in lower version of ceph
> > cluster, then the kclients will try to send the metric messages to
> > MDSes, which could crash the MDS daemons.
> >
> > For the ceph version feature flags they are redundant since we can check
> > this from the con's, since pacific the MDS code stopped updating it. I
> > assume we should deprecate it since Pacific ?
> >
>
> I believe so. Basically the version-based features aren't terribly
> useful. Mostly we want to check feature flags for specific features
> themselves. Since there are no other occurrences of
> CEPHFS_FEATURE_NAUTILUS or CEPHFS_FEATURE_OCTOPUS symbols, it's probably
> best not to define them at all.

Not only that but this patch as is would break CEPHFS_FEATURE_DELEG_INO
and CEPHFS_FEATURE_METRIC_COLLECT checks in the kernel because their bit
numbers would change...

Thanks,

                Ilya
