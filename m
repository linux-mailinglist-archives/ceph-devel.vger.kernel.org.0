Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C99C40C076
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Sep 2021 09:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhIOH1C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Sep 2021 03:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhIOH1B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 Sep 2021 03:27:01 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98B6C061574
        for <ceph-devel@vger.kernel.org>; Wed, 15 Sep 2021 00:25:42 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id jg16so4136590ejc.1
        for <ceph-devel@vger.kernel.org>; Wed, 15 Sep 2021 00:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=g1PcXUqejyZX+Nf8ZsiYkJ1LV449dfc/Wl/QD/0vsC8=;
        b=ZtvF0JXk779dhalyl4nfVz0+KUeI++YOtiWNeQHmxIXXNA/AxjGSMdPu0UizGoQ+t9
         Mb1QvvYvibyySTWZNdKGFv2kVwWgDuutyd2X/falswS4E2MQ9xfnh17+xzLYfBbr2DFE
         6kqg0p4jbAvNptgisXUpcO6wt4Mg3K4Gk40rGEbE/2gE29dgaDZP76F390Xo6mM3AjgP
         ks7Xz+uOYsTs4GH8+WDaen3O+vXgxBarJhNjr78iQL7y6Kfm8nBDOQgwWZuVn0B8JXZV
         vp6L1hkJadXkxtk7/8enPw88oPpY7G/pMJ2xk+3lq8x3kn5iCdfEK4IkIySjmlEup1lX
         /3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=g1PcXUqejyZX+Nf8ZsiYkJ1LV449dfc/Wl/QD/0vsC8=;
        b=UKr5JzAi1nMOREqnU8Ff0M63EI+OJL6PNFpMxLGNFxqM8Jx2PDjJ0I7ZtxALgEqLP+
         JSPXGSeBaGwIG9htstcgTtEVkB3C7e9BWGJcV7XbZ8SsP3T9x+gPzomzzozIwyz4FJDc
         OJJUN9ff1ITVehcYRkr/lO1YOtNFmv9x7Ds7eqjjDQWrg60B+06o88wHGCobjm0Bu0SB
         38aZ8p/iFRObZ6qx55kPDhoe6QDSuzSviEfI3CcDBMAJPE1lfSuwYzCh32TV9BoF/4+O
         mXLiD7ZKXA/RcI4qj9YerSxvuS+A1wPaPh7OrKaILC8WTvGmRdP7TbWZPkT/0J3OVYa3
         tXmw==
X-Gm-Message-State: AOAM531e/My3Ecl+luYwTdKj1nAJQNRLOPs0j46oRPUvlBO0EW2HskX6
        ExO3RkFA3/KnKeKghpugFA7DH9i0ayEEMU5anL0X2yXoGsDGeA==
X-Google-Smtp-Source: ABdhPJzV/CbzYkqm/r7gwG490FXEwPAQ3PFCPGAswJi2ycEMBMOwRCkfuIafJcMfkxttFvepOtiFsUa7GjiNQyWP4BY=
X-Received: by 2002:a17:906:700f:: with SMTP id n15mr23407647ejj.319.1631690741343;
 Wed, 15 Sep 2021 00:25:41 -0700 (PDT)
MIME-Version: 1.0
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 15 Sep 2021 15:25:29 +0800
Message-ID: <CAAM7YA=ARpUBEB8SRJB4ixqtsoyDF8DyDeAWqWSK4e=JTybrPg@mail.gmail.com>
Subject: CephFS optimizated for machine learning workload
To:     dev <dev@ceph.io>, ceph-users <ceph-users@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Following PRs are optimization we (Kuaishou) made for machine learning
workloads (randomly read billions of small files) .

[1] https://github.com/ceph/ceph/pull/39315
[2] https://github.com/ceph/ceph/pull/43126
[3] https://github.com/ceph/ceph/pull/43125

The first PR adds an option that disables dirfrag prefetch. When files
are accessed randomly, dirfrag prefetch adds lots of useless files to
cache and causes cache thrash. Performance of MDS can be dropped below
100 RPS. When dirfrag prefetch is disabled, MDS sends a getomapval
request to rados for cache missed lookup.  Single mds can handle about
6k cache missed lookup requests per second (all ssd metadata pool).

The second PR optimizes MDS performance for a large number of clients
and a large number of read-only opened files. It also can greatly
reduce mds recovery time for read-mostly wordload.

The third PR makes MDS cluster randomly distribute all dirfrags.  MDS
uses consistent hash to calculate target rank for each dirfrag.
Compared to dynamic balancer and subtree pin, metadata can be
distributed among MDSs more evenly. Besides, MDS only migrates single
dirfrag (instead of big subtree) for load balancing. So MDS has
shorter pause when doing metadata migration.  The drawbacks of this
change are:  stat(2) directory can be slow; rename(2) file to
different directory can be slow. The reason is, with random dirfrag
distribution, these operations likely involve multiple MDS.

Above three PRs are all merged into an integration branch
https://github.com/ukernel/ceph/tree/wip-mds-integration.

We (Kuaishou) have run these codes for months, 16 active MDS cluster
serve billions of small files. In file random read test, single MDS
can handle about 6k ops,  performance increases linearly with the
number of active MDS.  In file creation test (mpirun -np 160 -host
xxx:160 mdtest -F -L -w 4096 -z 2 -b 10 -I 200 -u -d ...), 16 active
MDS can serve over 100k file creation per second.

Yan, Zheng
