Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5944097A6
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 17:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240645AbhIMPni (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 11:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241248AbhIMPn2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 11:43:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631547732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7HxuHcVmkMZ+aq/OLOtmtM2XtbgwuEMNTZ7dqHupMtc=;
        b=ZmJ1D38XUGmh7gB+R0EBFUq9Zn9HkfLZjIIvfQArKMRqpVGYoNi1MqTXW31UmjUhjiMyiL
        xDgXOU050w7JcLuq21uwZNrx/UJmE4a89meGT+Byg6EaSqTjb1TnpFlP+93AxRlroZbtZI
        UtI1VhXk3IjKItIGNqzcAsJcmZBK0Zk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-DDRS2YBsNSGBGES7SKPdBA-1; Mon, 13 Sep 2021 11:42:10 -0400
X-MC-Unique: DDRS2YBsNSGBGES7SKPdBA-1
Received: by mail-ej1-f69.google.com with SMTP id bi9-20020a170906a24900b005c74b30ff24so3864880ejb.5
        for <ceph-devel@vger.kernel.org>; Mon, 13 Sep 2021 08:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HxuHcVmkMZ+aq/OLOtmtM2XtbgwuEMNTZ7dqHupMtc=;
        b=6OC/Nf3+w5SiFpPjLX1r7ZwFN8TXkC2HkL8mu5ks1L4WWz2LPvUPXdbyHH/Tbh9WXv
         l2Ev7/hnUxU1FL3DBR8x215IrPiaZzIKZ9jae030uxYmTaAo4noODWOSZlyBZ/cZy2It
         1FCV/ELhjnAQ6RKJMch9NCrM+nbB1VjgozjChIbw49hFxw+7kU/4/arFgoGosLuJhdEb
         we+HwB6D9fGmymleMsA+6c6NSrj2UrpGN7y4I9qnjcMaFDHmXMo9ZcVv8E0YBadrrzUY
         oD4hWLetyQ8ZLsAarFVzC6/JSgGBy0SNAU+1VFvEQXQA8hw3KTC/8mbd6Aa5ud52CpBQ
         gJxw==
X-Gm-Message-State: AOAM533EqwJKRzN86fkR96ooPqKDJiyycab3ZUOV+PsFNZ/ozQS68NlS
        LS9HeVc1EcU0nqsqv6Y1Qku/dsePTiGoDmboJ7AUNNRMtmyNeGoU92JK99UC+JWe0M3l9cf70zT
        d46iIKfL91nKkQwzL6hnkTipIdBP321V4S5l8ug==
X-Received: by 2002:aa7:c04e:: with SMTP id k14mr13724004edo.101.1631547729674;
        Mon, 13 Sep 2021 08:42:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwG1nm/wF0fGEvlNGb5iw6CkyjmWCLFdkz+vIv0YK+ZvnD/fd/LSxH+O/EMbW8fIkn6Hs1lKoiR0yZsy2bdJrU=
X-Received: by 2002:aa7:c04e:: with SMTP id k14mr13723984edo.101.1631547729472;
 Mon, 13 Sep 2021 08:42:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131311.1347903-1-vshankar@redhat.com> <22e110d00df3d02157222754f01fc6143cb40764.camel@redhat.com>
 <a79f35e47a105bb24baa666bca8c7cfe956d5076.camel@redhat.com>
In-Reply-To: <a79f35e47a105bb24baa666bca8c7cfe956d5076.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Mon, 13 Sep 2021 21:11:32 +0530
Message-ID: <CACPzV1=SnZhLo7qq2CQ8U9UHVf1ENsPf=EkqDF2qwQsrF9YNkw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] ceph: forward average read/write/metadata latency
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 13, 2021 at 8:51 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 2021-09-13 at 11:13 -0400, Jeff Layton wrote:
> > On Mon, 2021-09-13 at 18:43 +0530, Venky Shankar wrote:
> > > Right now, cumulative read/write/metadata latencies are tracked
> > > and are periodically forwarded to the MDS. These meterics are not
> > > particularly useful. A much more useful metric is the average latency
> > > and standard deviation (stdev) which is what this series of patches
> > > aims to do.
> > >
> > > The userspace (libcephfs+tool) changes are here::
> > >
> > >           https://github.com/ceph/ceph/pull/41397
> > >
> > > The math involved in keeping track of the average latency and stdev
> > > seems incorrect, so, this series fixes that up too (closely mimics
> > > how its done in userspace with some restrictions obviously) as per::
> > >
> > >           NEW_AVG = OLD_AVG + ((latency - OLD_AVG) / total_ops)
> > >           NEW_STDEV = SQRT(((OLD_STDEV + (latency - OLD_AVG)*(latency - NEW_AVG)) / (total_ops - 1)))
> > >
> > > Note that the cumulative latencies are still forwarded to the MDS but
> > > the tool (cephfs-top) ignores it altogether.
> > >
> > > Venky Shankar (4):
> > >   ceph: use "struct ceph_timespec" for r/w/m latencies
> > >   ceph: track average/stdev r/w/m latency
> > >   ceph: include average/stddev r/w/m latency in mds metrics
> > >   ceph: use tracked average r/w/m latencies to display metrics in
> > >     debugfs
> > >
> > >  fs/ceph/debugfs.c | 12 +++----
> > >  fs/ceph/metric.c  | 81 +++++++++++++++++++++++++----------------------
> > >  fs/ceph/metric.h  | 64 +++++++++++++++++++++++--------------
> > >  3 files changed, 90 insertions(+), 67 deletions(-)
> > >
> >
> > This looks reasonably sane. I'll plan to go ahead and pull this into the
> > testing kernels and do some testing with them. If anyone has objections
> > (Xiubo?) let me know and I can take them out.
> >
> > Thanks,
>
> Hmm...I take it back. There are some non-trivial merge conflicts in this
> series vs. the current testing branch. Venky can you rebase this onto
> the ceph-client/testing branch and resubmit?

Sure, will do.

>
> Thanks,
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

