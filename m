Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4064313C0
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Oct 2021 11:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhJRJpB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Oct 2021 05:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbhJRJo7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Oct 2021 05:44:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE71C06161C
        for <ceph-devel@vger.kernel.org>; Mon, 18 Oct 2021 02:42:48 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id d3so68354648edp.3
        for <ceph-devel@vger.kernel.org>; Mon, 18 Oct 2021 02:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OjiXBBApG7c5Q3akgFCyrp1JjpGFVAaRS269MbkygVU=;
        b=KusacoEeVn9utjKmRI7DFB2DgyX3xQPjTc4HHpg+5Cvk8dcCQcGAOL8vwiAouZHz9l
         jJkqD2gnOP3rRXUIooHQ/iLBSIFSyaiKi0NfIm4yFnU976qlnvZ1gc2cEvRcACsML7zT
         i9mR3IWDB8or3oZx9vba3j05GXExf+V3ab0bgoMEpOyONc5sBgCshbfF7duiJUP8BGtU
         19ek1hIesOoTzvONmQL4/tzyTCAUC0rWR9jRH0UXRKCyTkmP+FT/nrim2toUKyNjWbfF
         ZsBEc5eSdmhs4s2yeEExt/lpXrrIaga/70ku2YMKlLeYf2GEap1cp045tUYJ4gERoLxX
         FI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OjiXBBApG7c5Q3akgFCyrp1JjpGFVAaRS269MbkygVU=;
        b=ak9ntAoDITlnfk2nap92YK4eK8yRI951jUpnH3LW36u/FE7aZHApygxkBVHw73c47l
         AYE459fOHxbXMCMFYBsyBZKWuYgqGEVkH7inoBi+ZiQtlD9tbJgCDJgWsttFPl1PzvNB
         CHJmTG7bZLFjClqBwL5/k3dcSR9UD5IA6Zq5SRbOmD2c+bEJntNMsXLYEZhP6huzi1tz
         orhA56DGgYG8yvke83rcJfP+Tz/gzI+QpuZHYl+ijBKeRMW+Un/xi2jpo9MOGmhIsAVk
         knxtV0RsEUXQPk6P/I3LxIoLQo5PZbciuNkMDZlsoTrDutjUEt/No/GQViUOPqLhk0Mv
         7BFQ==
X-Gm-Message-State: AOAM532cCP+aw/c0KSzfNHMhySLeJxAu4RYA1H2c8i/QK7SFyj75xy4m
        9K8JHrHD3cA5/yppyhakjZabyKL1+51kTkqhWzWH2LP1890=
X-Google-Smtp-Source: ABdhPJx55kAL6XtR1fJlvfMqZ/UX/rCK92UPkTIaeHK85AO0wZdVo7S+OhZUA/0XhZTAzNTYyTpdm3TmCdymkPGQvdI=
X-Received: by 2002:a17:907:1b1f:: with SMTP id mp31mr28725621ejc.319.1634550166559;
 Mon, 18 Oct 2021 02:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
 <CABZ+qqkUKarxmeVC61xa25bNznynp=0aVEsJQfhtH4EcRv9a0A@mail.gmail.com>
 <CAAM7YAktCSwTORmKwvNBsPskDz8=TRmyDs6qakkmhpahtAs8qA@mail.gmail.com> <CABZ+qq=XBFC1tZsurdwqxop3B=z62YjczoAsVg5n2NPR_JB-rQ@mail.gmail.com>
In-Reply-To: <CABZ+qq=XBFC1tZsurdwqxop3B=z62YjczoAsVg5n2NPR_JB-rQ@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 18 Oct 2021 17:42:35 +0800
Message-ID: <CAAM7YA=Z8+CrpYhqPFMxtPzuLog1MaqXrmAsfSya1UHs3ri1MQ@mail.gmail.com>
Subject: Re: CephFS optimizated for machine learning workload
To:     Dan van der Ster <dan@vanderster.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 18, 2021 at 3:55 PM Dan van der Ster <dan@vanderster.com> wrote:
>
> On Mon, Oct 18, 2021 at 9:23 AM Yan, Zheng <ukernel@gmail.com> wrote:
> >
> >
> >
> > On Fri, Oct 15, 2021 at 6:06 PM Dan van der Ster <dan@vanderster.com> wrote:
> >>
> >> Hi Zheng,
> >>
> >> Thanks for this really nice set of PRs -- we will try them at our site
> >> the next weeks and try to come back with practical feedback.
> >> A few questions:
> >>
> >> 1. How many clients did you scale to, with improvements in the 2nd PR?
> >
> >
> > We have FS clusters with over 10k clients.  If you find CInode::get_caps_{issued,wanted} and/or EOpen::encode use lots of CPU, That PR should help.
>
> That's an impressive number, relevant for our possible future plans.
>
> >
> >> 2. Do these PRs improve the process of scaling up/down the number of active MDS?
> >
> >
> > What problem you encountered?  Decreasing active MDS works well (although a little slow) in my local test. migrating big subtree (after increasing active MDS) can cause slow OPS, the 3rd PR solves it.
>
> Stopping has in the past taken ~30mins, with slow requests while the
> pinned subtrees are re-imported.

This case should be improved by the 3rd PR. subtree migrations are
smoother and smoother.

>
>
> -- dan
>
>
> >
> >>
> >>
> >> Thanks!
> >>
> >> Dan
> >>
> >>
> >> On Wed, Sep 15, 2021 at 9:21 AM Yan, Zheng <ukernel@gmail.com> wrote:
> >> >
> >> > Following PRs are optimization we (Kuaishou) made for machine learning
> >> > workloads (randomly read billions of small files) .
> >> >
> >> > [1] https://github.com/ceph/ceph/pull/39315
> >> > [2] https://github.com/ceph/ceph/pull/43126
> >> > [3] https://github.com/ceph/ceph/pull/43125
> >> >
> >> > The first PR adds an option that disables dirfrag prefetch. When files
> >> > are accessed randomly, dirfrag prefetch adds lots of useless files to
> >> > cache and causes cache thrash. Performance of MDS can be dropped below
> >> > 100 RPS. When dirfrag prefetch is disabled, MDS sends a getomapval
> >> > request to rados for cache missed lookup.  Single mds can handle about
> >> > 6k cache missed lookup requests per second (all ssd metadata pool).
> >> >
> >> > The second PR optimizes MDS performance for a large number of clients
> >> > and a large number of read-only opened files. It also can greatly
> >> > reduce mds recovery time for read-mostly wordload.
> >> >
> >> > The third PR makes MDS cluster randomly distribute all dirfrags.  MDS
> >> > uses consistent hash to calculate target rank for each dirfrag.
> >> > Compared to dynamic balancer and subtree pin, metadata can be
> >> > distributed among MDSs more evenly. Besides, MDS only migrates single
> >> > dirfrag (instead of big subtree) for load balancing. So MDS has
> >> > shorter pause when doing metadata migration.  The drawbacks of this
> >> > change are:  stat(2) directory can be slow; rename(2) file to
> >> > different directory can be slow. The reason is, with random dirfrag
> >> > distribution, these operations likely involve multiple MDS.
> >> >
> >> > Above three PRs are all merged into an integration branch
> >> > https://github.com/ukernel/ceph/tree/wip-mds-integration.
> >> >
> >> > We (Kuaishou) have run these codes for months, 16 active MDS cluster
> >> > serve billions of small files. In file random read test, single MDS
> >> > can handle about 6k ops,  performance increases linearly with the
> >> > number of active MDS.  In file creation test (mpirun -np 160 -host
> >> > xxx:160 mdtest -F -L -w 4096 -z 2 -b 10 -I 200 -u -d ...), 16 active
> >> > MDS can serve over 100k file creation per second.
> >> >
> >> > Yan, Zheng
