Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390E140C061
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Sep 2021 09:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhIOHW5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Sep 2021 03:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236634AbhIOHWz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 Sep 2021 03:22:55 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBAFC061574
        for <ceph-devel@vger.kernel.org>; Wed, 15 Sep 2021 00:21:36 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id h9so4072091ejs.4
        for <ceph-devel@vger.kernel.org>; Wed, 15 Sep 2021 00:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=g1PcXUqejyZX+Nf8ZsiYkJ1LV449dfc/Wl/QD/0vsC8=;
        b=jXOEuzRBIvW9trJEixRSd8c/nOVLCX1u63ZDKLE8vTnAeu/Ghy/TaGkdbTPQHy4Thz
         84UjF0eQ4j0NnF3hRU206BuxeRs8l+3d69P+KOjQl7oHCqYBzTvgGSOF6gHzDOh4I7+R
         3XFo6isqsl1NqSnKCw0KH8YUXdRze4YuHY4qoUBu230y7Wwkuj387H+SFKkf5eDqOWDk
         h5B0OLsTWCK4KHW3qgYs9lW78UfwsrAmZaRuEg/SIJKg1vVxVUtave4/41KyOzCvME4q
         rwSeeIw/6i3T1jF3KOPYmA3eCNAhhS0Gu8/IwFQvhGuXOkvx/L2VZ+pm8KzjjPCgDQgB
         vCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=g1PcXUqejyZX+Nf8ZsiYkJ1LV449dfc/Wl/QD/0vsC8=;
        b=fetMlMU2hSt56i1iPWcajnzDX0dXnJeZC6CqyxEVgDg2M1CNfLI2CxeDG6n/jCkP8Q
         YtrvAMBKmy3hz5T73NshYdK92YYLQlVy/Juzd9Nch99UQ5y56e3oBi8l+YS3Og/dPghv
         xZaShYVcUrSGAAW9ws1AQeYc3Ecgua3mmbtbqs1BlG3f38BdAGzD2ME5eik5I1uzceLH
         W6giTEj/cjVdBgrbxEiLE9jWFjsIIM2xT4nwsG4GGxX45Xlo2OuCMVLtDIo+Vq7KxDxV
         XHZo1LxfWJp0gqmRagMdVBlhU4Sne78hxPqO5dFdDxTdQZfVMAWU1slVFDP9jKzv1qpN
         vVmA==
X-Gm-Message-State: AOAM530BuIdfRmCtJ9kCDdHn9a9vpJwv5ZvDPCm8eVYXUem+HCe+G13h
        DMUYf0s0Dvr4MpwWJiVzFKee5oUd5YSp8bAMq8ofIbaGqaU=
X-Google-Smtp-Source: ABdhPJxRv82B+Z1TnK99wlgOqibExKdeOi3KcHYmqL+HFwaLhSzM+zt6v4BJ0EzyF4uXwwCvsgc+GRH5krC4vK87OhM=
X-Received: by 2002:a17:906:76cf:: with SMTP id q15mr17130494ejn.141.1631690494667;
 Wed, 15 Sep 2021 00:21:34 -0700 (PDT)
MIME-Version: 1.0
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 15 Sep 2021 15:21:23 +0800
Message-ID: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
Subject: CephFS optimizated for machine learning workload
To:     ceph-devel <ceph-devel@vger.kernel.org>
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
