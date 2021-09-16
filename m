Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C6E40D235
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Sep 2021 06:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhIPEHU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Sep 2021 00:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhIPEHT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 Sep 2021 00:07:19 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E15C061574
        for <ceph-devel@vger.kernel.org>; Wed, 15 Sep 2021 21:05:59 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h17so11541566edj.6
        for <ceph-devel@vger.kernel.org>; Wed, 15 Sep 2021 21:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2xJBJ5g4qxKJdadex4VrdcZ5Beao/K8rxEnlk1EEPU=;
        b=M39WfhKUOXBGOBNiu7zxsA3fcaNQyS5chfaaptblA4LOmbYyFHUgVMplZ7fVcsO9+X
         vc2KCjZGMXjmMLM2OT+io8OXj3Sf9Nr455ckzmt5dq15PAd7jKhBk37l7Q+g4a03vxv3
         T3nnXYkHJQaCS/VNfcfN1jWNxtByDD4HFMudc5xNN5xNPZ9/6AW7tJPmQkFrn6s7tQW7
         jSXIIqhHZURHD4yBtoyTUcJnLePTARdERFWdgxCVG2OlBQEBYzurjPSGLceI4+06z+eb
         93cirA3tszyofsnHBEgRpHhTdiSWwDgxBnpqp14YL0Ho6xSgNjK18+xrkDCMDQ6BGEL5
         6e6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2xJBJ5g4qxKJdadex4VrdcZ5Beao/K8rxEnlk1EEPU=;
        b=z7r7flxVik0k+C8nXDdmV8v4wQdBZ8Sk0Xi/P8AwxebNnYeBET85u05KGDwz+QBrfR
         5mr9gaPjFALXYa9W0lVO6p6Y+4fBpekAVWEAnUpgRW4Moqqr4E5Od75Hreq5/U3YN2st
         LeorZ66dhdCxLNNy4BmNFwm28vYyDLnUmeq2z+xhM4WrbrFhFmS982A9P8a8KoOYfTH+
         pb1pu8GQj5HeApFQYjre+OoBV1qCuvIwu5ItbfRWc4LKckGnrWRdC7W8llNj7qNVUSSW
         rtCSG0+K3FIy6JiIi29Pr9wtRG6qRvcpoIx/n5VUWzpBlX9TF4xcthIivxqxk/TGqce6
         u67Q==
X-Gm-Message-State: AOAM533Q1KHANpbZ/GnjvjWMwXk4eYUdKUsKmKOwuJzWPSQMNTrsEgRT
        cqIz/BMGDaP2PNIHNvvmgOOpTsgxnWrGzEc4Euqc6/pTgqkXuQ==
X-Google-Smtp-Source: ABdhPJyruLTW/XwQsroDFhNU/GFnG1ixfC/PMR3NgZJaoBMfhaOLHWuQ0Uow+dBcyozSYre/9tMfEmdTvGmbAe7uh3E=
X-Received: by 2002:a05:6402:646:: with SMTP id u6mr3946053edx.127.1631765158188;
 Wed, 15 Sep 2021 21:05:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
 <95d4b624-2114-832f-ed80-f7f0e7d35a3c@redhat.com>
In-Reply-To: <95d4b624-2114-832f-ed80-f7f0e7d35a3c@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 16 Sep 2021 12:05:44 +0800
Message-ID: <CAAM7YAm9DLgu0mCD=tFkQkDfmcm9bkdV7Dp_V8g_UZz19TPCXA@mail.gmail.com>
Subject: Re: CephFS optimizated for machine learning workload
To:     Mark Nelson <mnelson@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 15, 2021 at 8:36 PM Mark Nelson <mnelson@redhat.com> wrote:
>
> Hi Zheng,
>
>
> This looks great!  Have you noticed any slow performance during
> directory splitting?  One of the things I was playing around with last
> year was pre-fragmenting directories based on a user supplied hint that
> the directory would be big (falling back to normal behavior if it grows
> beyond the hint size).  That way you can create the dirfrags upfront and
> do the migration before they ever have any associated files.  Do you
> think that might be worth trying again given your PRs below?
>

These PRs do not change directory splitting logic. It's unlikely they
will improve performance number of mdtest hard test.  But these PRs
remove overhead of journaling  subtreemap and distribute metadata more
evenly.  They should improve performance number of mdtest easy test.
So I think it's worth a retest.

Yan, Zheng

>
> Mark
>
>
> On 9/15/21 2:21 AM, Yan, Zheng wrote:
> > Following PRs are optimization we (Kuaishou) made for machine learning
> > workloads (randomly read billions of small files) .
> >
> > [1] https://github.com/ceph/ceph/pull/39315
> > [2] https://github.com/ceph/ceph/pull/43126
> > [3] https://github.com/ceph/ceph/pull/43125
> >
> > The first PR adds an option that disables dirfrag prefetch. When files
> > are accessed randomly, dirfrag prefetch adds lots of useless files to
> > cache and causes cache thrash. Performance of MDS can be dropped below
> > 100 RPS. When dirfrag prefetch is disabled, MDS sends a getomapval
> > request to rados for cache missed lookup.  Single mds can handle about
> > 6k cache missed lookup requests per second (all ssd metadata pool).
> >
> > The second PR optimizes MDS performance for a large number of clients
> > and a large number of read-only opened files. It also can greatly
> > reduce mds recovery time for read-mostly wordload.
> >
> > The third PR makes MDS cluster randomly distribute all dirfrags.  MDS
> > uses consistent hash to calculate target rank for each dirfrag.
> > Compared to dynamic balancer and subtree pin, metadata can be
> > distributed among MDSs more evenly. Besides, MDS only migrates single
> > dirfrag (instead of big subtree) for load balancing. So MDS has
> > shorter pause when doing metadata migration.  The drawbacks of this
> > change are:  stat(2) directory can be slow; rename(2) file to
> > different directory can be slow. The reason is, with random dirfrag
> > distribution, these operations likely involve multiple MDS.
> >
> > Above three PRs are all merged into an integration branch
> > https://github.com/ukernel/ceph/tree/wip-mds-integration.
> >
> > We (Kuaishou) have run these codes for months, 16 active MDS cluster
> > serve billions of small files. In file random read test, single MDS
> > can handle about 6k ops,  performance increases linearly with the
> > number of active MDS.  In file creation test (mpirun -np 160 -host
> > xxx:160 mdtest -F -L -w 4096 -z 2 -b 10 -I 200 -u -d ...), 16 active
> > MDS can serve over 100k file creation per second.
> >
> > Yan, Zheng
> >
>
