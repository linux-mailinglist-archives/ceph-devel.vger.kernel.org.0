Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437954311A0
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Oct 2021 09:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhJRH5R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Oct 2021 03:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhJRH5Q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Oct 2021 03:57:16 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DD9C06161C
        for <ceph-devel@vger.kernel.org>; Mon, 18 Oct 2021 00:55:06 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id b15so5399426qkl.10
        for <ceph-devel@vger.kernel.org>; Mon, 18 Oct 2021 00:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanderster.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=klNFey1Rq9VhZ2swCXRJI1ijFnPRe8chJJNf/u+N148=;
        b=UXHnhGgdmV4sT6YHLqUIffH+G2vlVDmKPMfxqsDivvum1v0CQBTCQArD8kL1u6PejM
         A1z6aPhsBQCBlg47OEQqA87pUhV79+3KSBgZZ0FrmdnIBsDVwbJg3CtHa5JL1JGvRHXn
         G6MUy+HFHPycKfLSv0A8syUS7Rp/IEnHxy7Bg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=klNFey1Rq9VhZ2swCXRJI1ijFnPRe8chJJNf/u+N148=;
        b=5UrTyCJmMU2U7nfG/2uQFSHme5i+G1vZkdeEVJURdEox3pbhrNqQU8n6oTsrLUnIEM
         FtwUVrL+s6NE7b7uXGOQnrnhCukmwWonc+9sXM93PSZ0+VHa1D/qrvT7dn1jMN2JBDfp
         ANisqf3qIrrxTy4qJALFmVXvYig6dVAT6q8ULXlMCkSoL98ZwnlDsrBLIrV4fNZpvlma
         7Ea/p2L0TjAz1TkLNtUTmWUgNWKQ5QmueySikUDZcV5vYPpW3UOUNuipRN2YWP1FLueZ
         g8jLpFI9aqSGJD/5puVFL/T99+SDaYQn+/eIDVOYF5QaU5Mtp4N5Wafe65L4jqeMgg7y
         ucyQ==
X-Gm-Message-State: AOAM531D9ylFwVlaIm+HJINUNICtlPI9DiHv/AIPGgeA9elr3KRRLyOI
        VKt7hLB1wKh2jmdgdTHEhPrOSivnTjcJSg==
X-Google-Smtp-Source: ABdhPJysIGnge2rHMNl+pDKAYFSOyjWnQjxvABI3uxVKzGD7VR6lz7Qni0oRfFcH+O/f+s1KHMQOtQ==
X-Received: by 2002:a05:620a:458d:: with SMTP id bp13mr20896133qkb.196.1634543704949;
        Mon, 18 Oct 2021 00:55:04 -0700 (PDT)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com. [209.85.222.179])
        by smtp.gmail.com with ESMTPSA id n2sm3945405qtk.8.2021.10.18.00.55.03
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 00:55:04 -0700 (PDT)
Received: by mail-qk1-f179.google.com with SMTP id p4so14645122qki.3
        for <ceph-devel@vger.kernel.org>; Mon, 18 Oct 2021 00:55:03 -0700 (PDT)
X-Received: by 2002:a37:a082:: with SMTP id j124mr21232062qke.495.1634543703211;
 Mon, 18 Oct 2021 00:55:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
 <CABZ+qqkUKarxmeVC61xa25bNznynp=0aVEsJQfhtH4EcRv9a0A@mail.gmail.com> <CAAM7YAktCSwTORmKwvNBsPskDz8=TRmyDs6qakkmhpahtAs8qA@mail.gmail.com>
In-Reply-To: <CAAM7YAktCSwTORmKwvNBsPskDz8=TRmyDs6qakkmhpahtAs8qA@mail.gmail.com>
From:   Dan van der Ster <dan@vanderster.com>
Date:   Mon, 18 Oct 2021 09:54:27 +0200
X-Gmail-Original-Message-ID: <CABZ+qq=XBFC1tZsurdwqxop3B=z62YjczoAsVg5n2NPR_JB-rQ@mail.gmail.com>
Message-ID: <CABZ+qq=XBFC1tZsurdwqxop3B=z62YjczoAsVg5n2NPR_JB-rQ@mail.gmail.com>
Subject: Re: CephFS optimizated for machine learning workload
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 18, 2021 at 9:23 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
>
>
> On Fri, Oct 15, 2021 at 6:06 PM Dan van der Ster <dan@vanderster.com> wrote:
>>
>> Hi Zheng,
>>
>> Thanks for this really nice set of PRs -- we will try them at our site
>> the next weeks and try to come back with practical feedback.
>> A few questions:
>>
>> 1. How many clients did you scale to, with improvements in the 2nd PR?
>
>
> We have FS clusters with over 10k clients.  If you find CInode::get_caps_{issued,wanted} and/or EOpen::encode use lots of CPU, That PR should help.

That's an impressive number, relevant for our possible future plans.

>
>> 2. Do these PRs improve the process of scaling up/down the number of active MDS?
>
>
> What problem you encountered?  Decreasing active MDS works well (although a little slow) in my local test. migrating big subtree (after increasing active MDS) can cause slow OPS, the 3rd PR solves it.

Stopping has in the past taken ~30mins, with slow requests while the
pinned subtrees are re-imported.

-- dan


>
>>
>>
>> Thanks!
>>
>> Dan
>>
>>
>> On Wed, Sep 15, 2021 at 9:21 AM Yan, Zheng <ukernel@gmail.com> wrote:
>> >
>> > Following PRs are optimization we (Kuaishou) made for machine learning
>> > workloads (randomly read billions of small files) .
>> >
>> > [1] https://github.com/ceph/ceph/pull/39315
>> > [2] https://github.com/ceph/ceph/pull/43126
>> > [3] https://github.com/ceph/ceph/pull/43125
>> >
>> > The first PR adds an option that disables dirfrag prefetch. When files
>> > are accessed randomly, dirfrag prefetch adds lots of useless files to
>> > cache and causes cache thrash. Performance of MDS can be dropped below
>> > 100 RPS. When dirfrag prefetch is disabled, MDS sends a getomapval
>> > request to rados for cache missed lookup.  Single mds can handle about
>> > 6k cache missed lookup requests per second (all ssd metadata pool).
>> >
>> > The second PR optimizes MDS performance for a large number of clients
>> > and a large number of read-only opened files. It also can greatly
>> > reduce mds recovery time for read-mostly wordload.
>> >
>> > The third PR makes MDS cluster randomly distribute all dirfrags.  MDS
>> > uses consistent hash to calculate target rank for each dirfrag.
>> > Compared to dynamic balancer and subtree pin, metadata can be
>> > distributed among MDSs more evenly. Besides, MDS only migrates single
>> > dirfrag (instead of big subtree) for load balancing. So MDS has
>> > shorter pause when doing metadata migration.  The drawbacks of this
>> > change are:  stat(2) directory can be slow; rename(2) file to
>> > different directory can be slow. The reason is, with random dirfrag
>> > distribution, these operations likely involve multiple MDS.
>> >
>> > Above three PRs are all merged into an integration branch
>> > https://github.com/ukernel/ceph/tree/wip-mds-integration.
>> >
>> > We (Kuaishou) have run these codes for months, 16 active MDS cluster
>> > serve billions of small files. In file random read test, single MDS
>> > can handle about 6k ops,  performance increases linearly with the
>> > number of active MDS.  In file creation test (mpirun -np 160 -host
>> > xxx:160 mdtest -F -L -w 4096 -z 2 -b 10 -I 200 -u -d ...), 16 active
>> > MDS can serve over 100k file creation per second.
>> >
>> > Yan, Zheng
