Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F14249986
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 11:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHSJkl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 05:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgHSJkk (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 05:40:40 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D803C206FA;
        Wed, 19 Aug 2020 09:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597830040;
        bh=zWlnnmPKekpNj9Y7nF8x2xH0z5eGvfiJTnebm6MK6iE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F1Ozp2FMCiu1nGYJ0WKQtL9pUQLIznu7r34psjTtEfcJa6NbQFH0nrK4XvfeDqivJ
         9CCVmcn1TzRIBgLeNS24FrB5zlUZ1KMQKfkKiRFmvkIQyPIz7v+OzhSEP0YBY5v/2a
         L8q02eB904x3nL8639fpF5sQY9wieu352DVPKO+A=
Date:   Wed, 19 Aug 2020 12:40:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ceph: Delete features that are not used in the kernel
Message-ID: <20200819094037.GT7555@unreal>
References: <20200819075747.917595-1-leon@kernel.org>
 <CAOi1vP-54DybxncMy0tyyy62nsgvQEn0DysbOTpmk_tnxnbv-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP-54DybxncMy0tyyy62nsgvQEn0DysbOTpmk_tnxnbv-g@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 19, 2020 at 10:47:38AM +0200, Ilya Dryomov wrote:
> On Wed, Aug 19, 2020 at 9:57 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > The ceph_features.h has declaration of features that are not in-use
> > in kernel code. This causes to seeing such compilation warnings in
> > almost every kernel compilation.
> >
> > ./include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_UID' defined but not used [-Wunused-const-variable=]
> >    14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
> >       |                        ^~~~~~~~~~~~~
> > ./include/linux/ceph/ceph_features.h:75:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
> >    75 | DEFINE_CEPH_FEATURE( 0, 1, UID)
> >       | ^~~~~~~~~~~~~~~~~~~
> >
> > The upstream kernel indeed doesn't have any use of them, so delete it.
> >
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > I'm sending this as RFC because probably the patch is wrong, but I
> > would like to bring your attention to the existing problem and asking
> > for an acceptable solution.
>
> Hi Leon,
>
> Yes, removing unused feature definitions is wrong.  Annotating them
> as potentially unused would be much better -- I'll send a patch.
>
> I don't think any of us builds with W=1, so these things don't get
> noticed.

Thanks, W=1 is our default compilation level for Mellanox RDMA submissions.

>
> Thanks,
>
>                 Ilya
