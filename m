Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0468018B391
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 13:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgCSMiL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 08:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgCSMiL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 08:38:11 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF5B2071C;
        Thu, 19 Mar 2020 12:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584621489;
        bh=YVTmX19JNU5vrkaSYVkzUBL7bebpJtsMffr91YNyaUE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iNY5z6wn5yMO3XHz109XtmCrYWH2mjZDT8YqtXHaciw7e3Rd/j7dnCIEP8f1DrRRg
         nzzmRmhOaWrggT0JtH7Nc1F9//gIZLVqocHz77Z2XUM5fjBDbZwrHsG9DDloWI0VeG
         NbzaW23Y16eW9fFdK20xUFQBoJoDg5zUEn86sgtw=
Message-ID: <f093e7c9769f6c4accedb7fa6d7ac8d9c3e62418.camel@kernel.org>
Subject: Re: [PATCH v11 3/4] ceph: add read/write latency metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 19 Mar 2020 08:38:07 -0400
In-Reply-To: <1584597626-11127-4-git-send-email-xiubli@redhat.com>
References: <1584597626-11127-1-git-send-email-xiubli@redhat.com>
         <1584597626-11127-4-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-03-19 at 02:00 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Calculate the latency for OSD read requests. Add a new r_end_stamp
> field to struct ceph_osd_request that will hold the time of that
> the reply was received. Use that to calculate the RTT for each call,
> and divide the sum of those by number of calls to get averate RTT.
> 
> Keep a tally of RTT for OSD writes and number of calls to track average
> latency of OSD writes.
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c                  |  18 +++++++
>  fs/ceph/debugfs.c               |  61 +++++++++++++++++++++-
>  fs/ceph/file.c                  |  26 ++++++++++
>  fs/ceph/metric.c                | 109 ++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/metric.h                |  23 +++++++++
>  include/linux/ceph/osd_client.h |   1 +
>  net/ceph/osd_client.c           |   2 +
>  7 files changed, 239 insertions(+), 1 deletion(-)
> 

[...]

> +static inline void __update_avg_and_sq(atomic64_t *totalp, atomic64_t *lat_sump,
> +				       struct percpu_counter *sq_sump,
> +				       spinlock_t *lockp, unsigned long lat)
> +{
> +	s64 total, avg, sq, lsum;
> +
> +	spin_lock(lockp);
> +	total = atomic64_inc_return(totalp);
> +	lsum = atomic64_add_return(lat, lat_sump);
> +	spin_unlock(lockp);
> +
> +	if (unlikely(total == 1))
> +		return;
> +
> +	/* the sq is (lat - old_avg) * (lat - new_avg) */
> +	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
> +	sq = lat - avg;
> +	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
> +	sq = sq * (lat - avg);
> +	percpu_counter_add(sq_sump, sq);
> +}
> +
> +void ceph_update_read_latency(struct ceph_client_metric *m,
> +			      unsigned long r_start,
> +			      unsigned long r_end,
> +			      int rc)
> +{
> +	unsigned long lat = r_end - r_start;
> +
> +	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
> +		return;
> +
> +	__update_min_latency(&m->read_latency_min, lat);
> +	__update_max_latency(&m->read_latency_max, lat);
> +	__update_avg_and_sq(&m->total_reads, &m->read_latency_sum,
> +			    &m->read_latency_sq_sum,
> +			    &m->read_latency_lock,
> +			    lat);
> +

Thanks for refactoring the set, Xiubo.

This makes something very evident though. __update_avg_and_sq takes a
spinlock and we have to hit it every time we update the other values, so
there really is no reason to use atomic or percpu values for any of
this.

I think it would be best to just make all of these be normal variables,
and simply take the spinlock when you fetch or update them.

Thoughts?
-- 
Jeff Layton <jlayton@kernel.org>

