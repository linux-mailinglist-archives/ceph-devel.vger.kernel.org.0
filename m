Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8454C20F55B
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jun 2020 15:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387880AbgF3NCt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jun 2020 09:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387492AbgF3NCs (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Jun 2020 09:02:48 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6101D2068F;
        Tue, 30 Jun 2020 13:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593522168;
        bh=jx4u9yo220ZRd1o/ymYQUxWPM0vG6BmbcbFqoR+Mfus=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nNRjeHWj2BSjK36C4EUb2JfKYW3zu7eGBgxsX/jkjK1RNLS0/wSi67F9lkyqYHBjF
         +PX3MTwya6x/8OYYnAgS0YjDmyrzVj7VNugpAul/NisTZxed1Bv7BQB1YQ8gg9zyws
         9Ak6RG8s8XijncpyMO9XhYgcXklTo/4iG7XwUUHU=
Message-ID: <ace7fb8b8caf88dd9dcdb9341fa6d3f396a42222.camel@kernel.org>
Subject: Re: [PATCH v5 0/5] ceph: periodically send perf metrics to ceph
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 30 Jun 2020 09:02:46 -0400
In-Reply-To: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
References: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-06-30 at 03:52 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This series is based the previous patches of the metrics in kceph[1]
> and mds daemons record and forward client side metrics to manager[2][3].
> 
> This will send the caps/read/write/metadata metrics to any available
> MDS only once per second, which will be the same as the userland client.
> We could disable it via the disable_send_metrics module parameter.
> 
> In mdsc->metric we have two new members:
> 'metric.mds': save the available and valid MDS rank number to send the
>               metrics to.
> 'metric.mds_cnt: how many MDSs support the metric collection feature.
> 
> Only when '!disable_send_metric && metric.mds_cnt > 0' will the workqueue
> job keep alive.
> 
> 
> And will also send the metric flags to MDS, currently it supports the
> cap, read latency, write latency and metadata latency.
> 
> Also have pushed this series to github [4].
> 
> [1] https://patchwork.kernel.org/project/ceph-devel/list/?series=238907 [Merged]
> [2] https://github.com/ceph/ceph/pull/26004 [Merged]
> [3] https://github.com/ceph/ceph/pull/35608 [Merged]
> [4] https://github.com/lxbsz/ceph-client/commits/perf_metric5
> 
> Changes in V5:
> - rename enable_send_metrics --> disable_send_metrics
> - switch back to a single workqueue job.
> - 'list' --> 'metric_wakeup'
> 
> Changes in V4:
> - WARN_ON --> WARN_ON_ONCE
> - do not send metrics when no mds suppor the metric collection.
> - add global total_caps in mdsc->metric
> - add the delayed work for each session and choose one to send the metrics to get rid of the mdsc->mutex lock
> 
> Changed in V3:
> - fold "check the METRIC_COLLECT feature before sending metrics" into previous one
> - use `enable_send_metrics` on/off switch instead
> 
> Changed in V2:
> - split the patches into small ones as possible.
> - check the METRIC_COLLECT feature before sending metrics
> - switch to WARN_ON and bubble up errnos to the callers
> 
> 
> 
> 
> Xiubo Li (5):
>   ceph: add check_session_state helper and make it global
>   ceph: add global total_caps to count the mdsc's total caps number
>   ceph: periodically send perf metrics to ceph
>   ceph: switch to WARN_ON_ONCE and bubble up errnos to the callers
>   ceph: send client provided metric flags in client metadata
> 
>  fs/ceph/caps.c               |   2 +
>  fs/ceph/debugfs.c            |  14 +---
>  fs/ceph/mds_client.c         | 166 ++++++++++++++++++++++++++++++++++---------
>  fs/ceph/mds_client.h         |   7 +-
>  fs/ceph/metric.c             | 158 ++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/metric.h             |  96 +++++++++++++++++++++++++
>  fs/ceph/super.c              |  42 +++++++++++
>  fs/ceph/super.h              |   2 +
>  include/linux/ceph/ceph_fs.h |   1 +
>  9 files changed, 442 insertions(+), 46 deletions(-)
> 

Hi Xiubo,

I'm going to go ahead and merge patches 1,2 and 4 out of this series.
They look like they should stand just fine on their own, and we can
focus on the last two stats patches in the series that way.

Let me know if you'd rather I not.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

