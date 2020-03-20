Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212EA18CD82
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Mar 2020 13:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgCTMKG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Mar 2020 08:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgCTMKF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 08:10:05 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796AE20732;
        Fri, 20 Mar 2020 12:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584706205;
        bh=V1k6qhAVvzqk7qI1wWiqPrg1NDOX5mVESL5a40sW/ec=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QJ8LH1cXHxqGAjESJHX/es33tPDeeqdekUJuBYsHA35en7DVRVIPaX8ceu5elB3iF
         DgRmzec1LbrhOFR/G3KiJ1u+uqgXjNBGppAoA7pCDxaexmZDJvZbIicstiGzsij0yQ
         P1PKM31SFn35r6kOTGlr1fwEb4w7odNrj+CV6IpQ=
Message-ID: <3616dfb1ee735e59e2c3a087bc0acf98e021d1c3.camel@kernel.org>
Subject: Re: [PATCH v13 0/4] ceph: add perf metrics support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 20 Mar 2020 08:10:03 -0400
In-Reply-To: <1584675902-16493-1-git-send-email-xiubli@redhat.com>
References: <1584675902-16493-1-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-03-19 at 23:44 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> # cat /sys/kernel/debug/ceph/9a972bfc-68cb-4d52-a610-7cd9a9adbbdd.client52904/metrics
> item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
> -----------------------------------------------------------------------------------
> read          21979       2093            765             248778          2771
> write         1129        45184           30252           368629          20437
> metadata      3           6462            1674            14260           6811
> 
> item          total           miss            hit
> -------------------------------------------------
> d_lease       2               0               1
> caps          2               4               24248
> 
> 
> Chnaged in V13:
> - [3/4] and [4/4] switch jiffies to ktime_t for the start/end time stamp, which
>   will make it much preciser, such as when the IO latency(end - start) < 1ms and
>   if the HZ==1000, then we will always get end == start in jiffies, and the min
>   will always be 0, actually it should be in range (0, 1000)us.
> - [3/4] since by using ktime helpers we are calculating the stdev in nanosecond,
>   then switch to us, so to compute the reminder make no sense any more, remove it
>   from stdev.
> 
> Changed in V12:
> - [3/4] and [4/4] switch atomic64_t type to u64 for lat sum and total numbers
> 
> Changed in V11:
> - [3/4] and [4/4] fold the min/max/stdev factors
> 
> Changed in V10:
> - rebase to the latest testing branch
> - merge all the metric related patches into one
> - [1/6] move metric helpers into a new file metric.c
> - [2/6] move metric helpers into metric.c
> - [3/6] merge the read/write patches into a signal patch and move metric helpers to metric.c
> - [4/6] move metric helpers to metric.c
> - [5/6] min/max latency support
> - [6/6] standard deviation support
> 
> Changed in V9:
> - add an r_ended field to the mds request struct and use that to calculate the metric
> - fix some commit comments
> 
> Xiubo Li (4):
>   ceph: add dentry lease metric support
>   ceph: add caps perf metric for each superblock
>   ceph: add read/write latency metric support
>   ceph: add metadata perf metric support
> 
>  fs/ceph/Makefile                |   2 +-
>  fs/ceph/acl.c                   |   2 +-
>  fs/ceph/addr.c                  |  20 ++++++
>  fs/ceph/caps.c                  |  19 ++++++
>  fs/ceph/debugfs.c               | 100 +++++++++++++++++++++++++--
>  fs/ceph/dir.c                   |  17 ++++-
>  fs/ceph/file.c                  |  30 ++++++++
>  fs/ceph/inode.c                 |   4 +-
>  fs/ceph/mds_client.c            |  23 ++++++-
>  fs/ceph/mds_client.h            |   7 ++
>  fs/ceph/metric.c                | 148 ++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/metric.h                |  62 +++++++++++++++++
>  fs/ceph/super.h                 |   9 ++-
>  fs/ceph/xattr.c                 |   4 +-
>  include/linux/ceph/osd_client.h |   3 +
>  net/ceph/osd_client.c           |   3 +
>  16 files changed, 436 insertions(+), 17 deletions(-)
>  create mode 100644 fs/ceph/metric.c
>  create mode 100644 fs/ceph/metric.h
> 

Thanks Xiubo,

I think this looks good now. I'm going to do a bit of testing and merge
it later today.

Thanks again!
-- 
Jeff Layton <jlayton@kernel.org>

