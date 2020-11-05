Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1302A7EAC
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Nov 2020 13:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbgKEMew (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Nov 2020 07:34:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgKEMew (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 07:34:52 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B4BE20756;
        Thu,  5 Nov 2020 12:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604579691;
        bh=jjGBaiMwobGYILNyrLKgrkfOoPFK7Qclun6x3ohT5tI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rdgK3RjJrbCKEFwCOI+82pWhyNcGk4scmhJC5EwTFh56kbGMQeHRoZwkv72Z7P0rw
         SUR3fNp6CXQI3Ihd7YrhwE00NxNZqXGA9sGUKH8f47QBvA2GfktHpinHE5J4C3xhZr
         I2GDAco/RuyB54Bxzhofyels+YWrIvmlkAWa+DhE=
Message-ID: <02e17f5aa26ea24139ab673db034c4de5782dfcc.camel@kernel.org>
Subject: Re: [PATCH] ceph: send dentry lease metrics to MDS daemon
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 05 Nov 2020 07:34:49 -0500
In-Reply-To: <20201021045024.44437-1-xiubli@redhat.com>
References: <20201021045024.44437-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-10-21 at 00:50 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For the old ceph version, if it received this one metric message
> containing the dentry lease metric info, it will just ignore it.
> 
> URL: https://tracker.ceph.com/issues/43423
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/metric.c | 18 +++++++++++++++---
>  fs/ceph/metric.h | 14 ++++++++++++++
>  2 files changed, 29 insertions(+), 3 deletions(-)
> 

Sorry for the long delay -- this one fell through the cracks somehow...

> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index fee4c4778313..06729cbfabee 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -16,6 +16,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	struct ceph_metric_read_latency *read;
>  	struct ceph_metric_write_latency *write;
>  	struct ceph_metric_metadata_latency *meta;
> +	struct ceph_metric_dlease *dlease;
>  	struct ceph_client_metric *m = &mdsc->metric;
>  	u64 nr_caps = atomic64_read(&m->total_caps);
>  	struct ceph_msg *msg;
> @@ -25,7 +26,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	s32 len;
>  
> 
> 
> 
> 
> 
> 
> 
>  	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
> -	      + sizeof(*meta);
> +	      + sizeof(*meta) + sizeof(*dlease);
>  
> 
> 
> 
> 
> 
> 
> 
>  	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
>  	if (!msg) {
> @@ -42,8 +43,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	cap->ver = 1;
>  	cap->compat = 1;
>  	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
> -	cap->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_hit));
> -	cap->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_mis));
> +	cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
> +	cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
>  	cap->total = cpu_to_le64(nr_caps);
>  	items++;
>  
> 
> 
> 
> 
> 
> 
> 
> @@ -83,6 +84,17 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	meta->nsec = cpu_to_le32(ts.tv_nsec);
>  	items++;
>  
> 
> 
> 
> 
> 
> 
> 
> +	/* encode the dentry lease metric */
> +	dlease = (struct ceph_metric_dlease *)(meta + 1);
> +	dlease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
> +	dlease->ver = 1;
> +	dlease->compat = 1;
> +	dlease->data_len = cpu_to_le32(sizeof(*dlease) - 10);
> +	dlease->hit = cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
> +	dlease->mis = cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
> +	dlease->total = atomic64_read(&m->total_dentries),

dlease->total needs to be wrapped in cpu_to_le64().

> +	items++;
> +
>  	put_unaligned_le32(items, &head->num);
>  	msg->front.iov_len = len;
>  	msg->hdr.version = cpu_to_le16(1);
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 710f3f1dceab..af6038ff39d4 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -27,6 +27,7 @@ enum ceph_metric_type {
>  	CLIENT_METRIC_TYPE_READ_LATENCY,	\
>  	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
>  	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
> +	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
>  						\
>  	CLIENT_METRIC_TYPE_MAX,			\
>  }
> @@ -80,6 +81,19 @@ struct ceph_metric_metadata_latency {
>  	__le32 nsec;
>  } __packed;
>  
> 
> 
> 
> +/* metric dentry lease header */
> +struct ceph_metric_dlease {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  compat;
> +
> +	__le32 data_len; /* length of sizeof(hit + mis + total) */
> +	__le64 hit;
> +	__le64 mis;
> +	__le64 total;
> +} __packed;
> +
>  struct ceph_metric_head {
>  	__le32 num;	/* the number of metrics that will be sent */
>  } __packed;

-- 
Jeff Layton <jlayton@kernel.org>

