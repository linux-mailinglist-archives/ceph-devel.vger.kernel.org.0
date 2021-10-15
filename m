Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE3342EE69
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Oct 2021 12:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhJOKJA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 15 Oct 2021 06:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237590AbhJOKIl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 15 Oct 2021 06:08:41 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33831C061570
        for <ceph-devel@vger.kernel.org>; Fri, 15 Oct 2021 03:06:27 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id r17so8273554qtx.10
        for <ceph-devel@vger.kernel.org>; Fri, 15 Oct 2021 03:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanderster.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VsHqj2SqoJqQfWZGHVxQnixGTb2psMqZmSy6d8rqTjc=;
        b=G0EfHfYo5rjG2xoxWp4XaQaj6kz1emSfwrCSXPGz4mhnnKc0wmg9TgEN0frtjRJIc+
         xCtmot6qaEWW2k2qn/1zdjc+zT4KNN8LxWPmC6Cqz6RDKnRIJeM8v1GAJjJoF1fpXcD8
         eeGbbD1MY9pjp4M4c97ALffddSJHawpksZ9Es=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VsHqj2SqoJqQfWZGHVxQnixGTb2psMqZmSy6d8rqTjc=;
        b=TpzK29bQVP3uw7zvNTcVZ8lT3OO+BIXR9wydeckoCeCeMmWJz0hgprTQ9LvqN1x69M
         tKHwTrl9MQmQ3JzvuA5PyLjmxH80IMolDXlxtqYrK4wfEbxNgkWcIMTWHRPAlpE38JEc
         OmhPR8XpU+jUVvx6tOAW8CW6aizAmCdPmNR679dFu6xr2lgeRVqzrGOSFpFoJKxQ3+iT
         gRUu4bLqS3DQHtq580Der2Zev+38o2Oc8zvDzM2XhLOYiHdVhVtIWc6wrWj88hcRswq3
         +ger/e44kXEku5Hxz/BN8U1qGdIU/7mdUslnBgnM6dWxKcX1NvKaQ6ExXFIAxlmbXtHn
         YKzg==
X-Gm-Message-State: AOAM5335zceLLOCi3saF8Zr/H/nBwtner7eEtursXYmiCVDAHbhkmghM
        7dsiRVMINiiIoxxi2W9D+5qxxiOxjlBOYOxE
X-Google-Smtp-Source: ABdhPJxxGJoq3d2dYWo6wnIRbm1qbRHZ+3rkWxJ7vt5p19UkTWT3AKmcvWyuylfsc1H+WWy8UgbsGw==
X-Received: by 2002:a05:622a:170b:: with SMTP id h11mr739007qtk.395.1634292386117;
        Fri, 15 Oct 2021 03:06:26 -0700 (PDT)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com. [209.85.219.42])
        by smtp.gmail.com with ESMTPSA id b3sm2442008qkj.76.2021.10.15.03.06.25
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 03:06:25 -0700 (PDT)
Received: by mail-qv1-f42.google.com with SMTP id o13so5391816qvm.4
        for <ceph-devel@vger.kernel.org>; Fri, 15 Oct 2021 03:06:25 -0700 (PDT)
X-Received: by 2002:a05:6214:509a:: with SMTP id kk26mr10086142qvb.65.1634292384942;
 Fri, 15 Oct 2021 03:06:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
In-Reply-To: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
From:   Dan van der Ster <dan@vanderster.com>
Date:   Fri, 15 Oct 2021 12:05:51 +0200
X-Gmail-Original-Message-ID: <CABZ+qqkUKarxmeVC61xa25bNznynp=0aVEsJQfhtH4EcRv9a0A@mail.gmail.com>
Message-ID: <CABZ+qqkUKarxmeVC61xa25bNznynp=0aVEsJQfhtH4EcRv9a0A@mail.gmail.com>
Subject: Re: CephFS optimizated for machine learning workload
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Zheng,

Thanks for this really nice set of PRs -- we will try them at our site
the next weeks and try to come back with practical feedback.
A few questions:

1. How many clients did you scale to, with improvements in the 2nd PR?
2. Do these PRs improve the process of scaling up/down the number of active MDS?

Thanks!

Dan


On Wed, Sep 15, 2021 at 9:21 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
> Following PRs are optimization we (Kuaishou) made for machine learning
> workloads (randomly read billions of small files) .
>
> [1] https://github.com/ceph/ceph/pull/39315
> [2] https://github.com/ceph/ceph/pull/43126
> [3] https://github.com/ceph/ceph/pull/43125
>
> The first PR adds an option that disables dirfrag prefetch. When files
> are accessed randomly, dirfrag prefetch adds lots of useless files to
> cache and causes cache thrash. Performance of MDS can be dropped below
> 100 RPS. When dirfrag prefetch is disabled, MDS sends a getomapval
> request to rados for cache missed lookup.  Single mds can handle about
> 6k cache missed lookup requests per second (all ssd metadata pool).
>
> The second PR optimizes MDS performance for a large number of clients
> and a large number of read-only opened files. It also can greatly
> reduce mds recovery time for read-mostly wordload.
>
> The third PR makes MDS cluster randomly distribute all dirfrags.  MDS
> uses consistent hash to calculate target rank for each dirfrag.
> Compared to dynamic balancer and subtree pin, metadata can be
> distributed among MDSs more evenly. Besides, MDS only migrates single
> dirfrag (instead of big subtree) for load balancing. So MDS has
> shorter pause when doing metadata migration.  The drawbacks of this
> change are:  stat(2) directory can be slow; rename(2) file to
> different directory can be slow. The reason is, with random dirfrag
> distribution, these operations likely involve multiple MDS.
>
> Above three PRs are all merged into an integration branch
> https://github.com/ukernel/ceph/tree/wip-mds-integration.
>
> We (Kuaishou) have run these codes for months, 16 active MDS cluster
> serve billions of small files. In file random read test, single MDS
> can handle about 6k ops,  performance increases linearly with the
> number of active MDS.  In file creation test (mpirun -np 160 -host
> xxx:160 mdtest -F -L -w 4096 -z 2 -b 10 -I 200 -u -d ...), 16 active
> MDS can serve over 100k file creation per second.
>
> Yan, Zheng
