Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721DB18A017
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 17:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgCRQBG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 12:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgCRQBF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 12:01:05 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE942076C;
        Wed, 18 Mar 2020 16:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584547264;
        bh=wEV6X4xdPP7TA5RiCw5ESx4p4A1w93q73hCpNsIrfmY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=yGLvX5cz7SJ7IlPWI83fBYq8t+KS9EtZNag8VJ7KkHehVQsX3PyS3CAvflgVb2oFD
         5YqdasjYfJAz6MXhfCC5fW16N0ibNgoly8rEg4Fdr+NYZXLV3VallBDb1v2n61OJXu
         l5zHzqxRyHnWeNnimGVG8XQszBOQAiPp9CRptGvk=
Message-ID: <ea5551cf7c7e18b5baf6ec990ae1eddedc62ddce.camel@kernel.org>
Subject: Re: [PATCH v10 0/6] ceph: add perf metrics support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 18 Mar 2020 12:01:02 -0400
In-Reply-To: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
References: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-03-18 at 10:05 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
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
> # cat /sys/kernel/debug/ceph/9a972bfc-68cb-4d52-a610-7cd9a9adbbdd.client52904/metrics
> item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
> -----------------------------------------------------------------------------------
> read          798         32000           4000            196000          560.3
> write         2394        588000          28000           4812000         36673.9
> metadata      7           116000          2000            707000          8282.8
> 
> item          total           miss            hit
> -------------------------------------------------
> d_lease       2               0               0
> caps          2               14              546500
> 
> 
> 

The code all looks reasonable to me.

Ilya mentioned refactoring the set to add the infrastructure up front
first. I too think that would be nice, especially since this will
probably end up being backported to various distros and that would make
that task simpler.

It might also be nice to merge the add in the min/max/stddev support at
the same time you add each latency metric too, rather than adding them
after the fact.

> 
> Xiubo Li (6):
>   ceph: add dentry lease metric support
>   ceph: add caps perf metric for each session
>   ceph: add read/write latency metric support

Can you fold the min/max/stddev changes for read/write into the above
patch? I think that would be cleaner, rather than bolting it on after
the fact.

>   ceph: add metadata perf metric support

Same here. That should just leave us with a 4 patch series, I think.
 
>   ceph: add min/max latency support for read/write/metadata metrics
>   ceph: add standard deviation support for read/write/metadata perf
>     metric
> 
>  fs/ceph/Makefile                |   2 +-
>  fs/ceph/acl.c                   |   2 +-
>  fs/ceph/addr.c                  |  18 ++++
>  fs/ceph/caps.c                  |  19 ++++
>  fs/ceph/debugfs.c               | 116 +++++++++++++++++++++++-
>  fs/ceph/dir.c                   |  17 +++-
>  fs/ceph/file.c                  |  26 ++++++
>  fs/ceph/inode.c                 |   4 +-
>  fs/ceph/mds_client.c            |  21 ++++-
>  fs/ceph/mds_client.h            |   7 +-
>  fs/ceph/metric.c                | 193 ++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/metric.h                |  64 +++++++++++++
>  fs/ceph/super.h                 |   9 +-
>  fs/ceph/xattr.c                 |   4 +-
>  include/linux/ceph/osd_client.h |   1 +
>  net/ceph/osd_client.c           |   2 +
>  16 files changed, 487 insertions(+), 18 deletions(-)
>  create mode 100644 fs/ceph/metric.c
>  create mode 100644 fs/ceph/metric.h
> 



Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

