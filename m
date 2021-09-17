Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D66040F473
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Sep 2021 10:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhIQI5v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Sep 2021 04:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbhIQI5u (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Sep 2021 04:57:50 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8C7C061766
        for <ceph-devel@vger.kernel.org>; Fri, 17 Sep 2021 01:56:27 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g8so27361999edt.7
        for <ceph-devel@vger.kernel.org>; Fri, 17 Sep 2021 01:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J8TP8PiU3GCbf9/HqAk1Gy/RdefRSdNGtrbHFX9kudE=;
        b=IqUAnw8KsJ8Tw4ZDRSlp48Xtl1zFAaSMSen3hLSyB66HbAapdQZoQKGIjx58BRdkBw
         9mpYxRPUiKaoAegJKV3XQF4MZ6DEiLOC7+twpCRvaD91GO/o35MOf3X5p+NqQhvt4/bJ
         jHeZUEBsXdAQ3jnUwAGgLAvRneVb47ngeH/tftKSPmJR19HlYuK85iFGb5RE6ooOFjEb
         pBkDL9wTa0dExlOYw8Yx0Lb1Y1Mts2Sc3/dD8PRW8PlqU/2zxn8ILVhDNBGuEG3k/Ruj
         yNpjDK8gQs3l7FQziS0bTX6GCsV9q15srkpnTmdVL/9PcLAKlBMWDMNbXB471LyWJJRJ
         EWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8TP8PiU3GCbf9/HqAk1Gy/RdefRSdNGtrbHFX9kudE=;
        b=x3MVAuyZlySj2mdpi6HEIjSJVCDX5t453Ovsg0nhkqpwBbsujqjvQxw0sAH+aB1D+Z
         4azArvKb/qNWj9Vb1bkbRjPiT1+KosBbNeRnt4DzmLMEuoUJFvtgXpvo3FegGGfY/1I8
         CtYEdEHVPqe+QYHj0eSJUaEFOBGz5qnuJbxHHvBrwOGSXc/vwHGjZb7MT0x+nATB4PtI
         +PZOAMPhRZJ6QdzcQu43D8k7Ee/IydNl2dWtw+1IuRewNW4nxxbodO5OZJ8QGvKK3Cy5
         7oOcm+6mj+4U4lU93OQMV10/PdIg7QYBo5cHRYAENcd++aVoLYlFWIgxFG3ijGYqm8A9
         lPMA==
X-Gm-Message-State: AOAM532mn+Q8657vR3kjduFCCtkl4CT+ujSD2tQBqauRxfwGyleV5OVb
        yR5RWPJKqlTd0G9/Rp/93RaiMif5/pVnVOQU8m8=
X-Google-Smtp-Source: ABdhPJy+mdPjuG/IpcjuSHkCobmGtbq6T/3AjR4I3Wq3gRSBuxYgIRdEXHxIm48rhdBcnF9C0xoXT5QeVBvftUL9FYI=
X-Received: by 2002:aa7:c5d2:: with SMTP id h18mr11271193eds.218.1631868985870;
 Fri, 17 Sep 2021 01:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
 <95d4b624-2114-832f-ed80-f7f0e7d35a3c@redhat.com> <CAAM7YAm9DLgu0mCD=tFkQkDfmcm9bkdV7Dp_V8g_UZz19TPCXA@mail.gmail.com>
 <3bf21091-19bd-121c-05e1-9ce3ee7c7009@gmail.com>
In-Reply-To: <3bf21091-19bd-121c-05e1-9ce3ee7c7009@gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 17 Sep 2021 16:56:14 +0800
Message-ID: <CAAM7YA=-8jn0mGciWVYA_uHTHe4E-+5hRHCSMeZMiz_SwT6E4Q@mail.gmail.com>
Subject: Re: CephFS optimizated for machine learning workload
To:     Mark Nelson <mark.a.nelson@gmail.com>
Cc:     Mark Nelson <mnelson@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        "ceph-users@ceph.io" <ceph-users@ceph.io>,
        "dev@ceph.io" <dev@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 17, 2021 at 12:14 AM Mark Nelson <mark.a.nelson@gmail.com> wrote:
>
>
>
> On 9/15/21 11:05 PM, Yan, Zheng wrote:
> > On Wed, Sep 15, 2021 at 8:36 PM Mark Nelson <mnelson@redhat.com> wrote:
> >>
> >> Hi Zheng,
> >>
> >>
> >> This looks great!  Have you noticed any slow performance during
> >> directory splitting?  One of the things I was playing around with last
> >> year was pre-fragmenting directories based on a user supplied hint that
> >> the directory would be big (falling back to normal behavior if it grows
> >> beyond the hint size).  That way you can create the dirfrags upfront and
> >> do the migration before they ever have any associated files.  Do you
> >> think that might be worth trying again given your PRs below?
> >>
> >
> > These PRs do not change directory splitting logic. It's unlikely they
> > will improve performance number of mdtest hard test.  But these PRs
> > remove overhead of journaling  subtreemap and distribute metadata more
> > evenly.  They should improve performance number of mdtest easy test.
> > So I think it's worth a retest.
> >
> > Yan, Zheng
>
>
> I was mostly thinking about:
>
> [3] https://github.com/ceph/ceph/pull/43125
>
> Shouldn't this allow workloads like mdtest hard where you have many
> clients performing file writes/reads/deletes inside a single directory
> (that is split into dirfrags randomly distributed across MDSes) to
> parallelize some of the work? (minus whatever needs to be synchronized
> on the authoritative mds)
>

The tiggers for dirfrags migration in this PR are mkdir and dirfrag
fetch.  Dirfrag first need to be split, then get migrated. I don't
hnow how long these events happen in mdtest hard and how the pause of
split/migration affect the test result.



> We discussed some of this in the performance standup today.  From what
> I've seen the real meat of the problem still rests in the distributed
> cache, locking, and cap revocation,

For performance of single thread or single MDS, yes. The purpose of PR
43125 is distribute metadata more evenly and improve aggregate
performance.

Yan, Zheng

> but it seems like anything we can do
> to reduce the overhead of dirfrag migration is a win.
>



> Mark
>
>
>
>
> >
> >>
> >> Mark
> >>
> >>
> >> On 9/15/21 2:21 AM, Yan, Zheng wrote:
> >>> Following PRs are optimization we (Kuaishou) made for machine learning
> >>> workloads (randomly read billions of small files) .
> >>>
> >>> [1] https://github.com/ceph/ceph/pull/39315
> >>> [2] https://github.com/ceph/ceph/pull/43126
> >>> [3] https://github.com/ceph/ceph/pull/43125
> >>>
> >>> The first PR adds an option that disables dirfrag prefetch. When files
> >>> are accessed randomly, dirfrag prefetch adds lots of useless files to
> >>> cache and causes cache thrash. Performance of MDS can be dropped below
> >>> 100 RPS. When dirfrag prefetch is disabled, MDS sends a getomapval
> >>> request to rados for cache missed lookup.  Single mds can handle about
> >>> 6k cache missed lookup requests per second (all ssd metadata pool).
> >>>
> >>> The second PR optimizes MDS performance for a large number of clients
> >>> and a large number of read-only opened files. It also can greatly
> >>> reduce mds recovery time for read-mostly wordload.
> >>>
> >>> The third PR makes MDS cluster randomly distribute all dirfrags.  MDS
> >>> uses consistent hash to calculate target rank for each dirfrag.
> >>> Compared to dynamic balancer and subtree pin, metadata can be
> >>> distributed among MDSs more evenly. Besides, MDS only migrates single
> >>> dirfrag (instead of big subtree) for load balancing. So MDS has
> >>> shorter pause when doing metadata migration.  The drawbacks of this
> >>> change are:  stat(2) directory can be slow; rename(2) file to
> >>> different directory can be slow. The reason is, with random dirfrag
> >>> distribution, these operations likely involve multiple MDS.
> >>>
> >>> Above three PRs are all merged into an integration branch
> >>> https://github.com/ukernel/ceph/tree/wip-mds-integration.
> >>>
> >>> We (Kuaishou) have run these codes for months, 16 active MDS cluster
> >>> serve billions of small files. In file random read test, single MDS
> >>> can handle about 6k ops,  performance increases linearly with the
> >>> number of active MDS.  In file creation test (mpirun -np 160 -host
> >>> xxx:160 mdtest -F -L -w 4096 -z 2 -b 10 -I 200 -u -d ...), 16 active
> >>> MDS can serve over 100k file creation per second.
> >>>
> >>> Yan, Zheng
> >>>
> >>
