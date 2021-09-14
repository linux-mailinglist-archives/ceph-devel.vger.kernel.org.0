Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D70A40AFFC
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 15:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbhINN6h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 09:58:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233883AbhINN62 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631627829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4WlF2SxkxYNL4JYKZsv059j7ibFQnZl4i+b0C5215WQ=;
        b=JAV0R+vsXAzDlIAGBiCl776XUiOLJowPl0oFhidz3FJJFwAzU/MrNy5BkmxWrGOZ8XOZ/A
        xOxUy8vrHGxjBgKNQZhKe0oeUi6yi2V5aLcSPMTc/EDe0RrtWjHlWXByxIN+DyrcrIuMjI
        qm+BpPEEdVeWMm4tISVrIhtd7/kgEvg=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-jNNRyTNjMiKsrxofKflGkw-1; Tue, 14 Sep 2021 09:57:09 -0400
X-MC-Unique: jNNRyTNjMiKsrxofKflGkw-1
Received: by mail-pg1-f199.google.com with SMTP id w5-20020a654105000000b002692534afceso9428957pgp.8
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4WlF2SxkxYNL4JYKZsv059j7ibFQnZl4i+b0C5215WQ=;
        b=OKDvDQt/7EuAhBoeCbA0OfFZNluzyaw9L3rPJJni5ptXJ05JVUW2SYazZgJVsKVTyt
         1t3BlhUr8R4Mpf6mOYVP3zGS5oNX57HGBT67/QifguBZQJc/X7R3dfZdUxVGpo4amdR1
         Qw6fmulrkX9qW23HgD2ZxmfwiO0ksOYWJaDz+JXmlRh1dfYeIYl3xDSjpctTOo5n9doG
         VPtIb/l7uBGDfyuipKy1sK2uYc3lRuygV87rgKwrex/ER4bFmjshKwkKMoOYBuEiaZUJ
         v/pyP1qRYeiIItUQDOtKbo5b/Jtv1y3LmE8iUyQNFc1AvB3L9LxuXf2pdm2h7SlDQSb7
         oLTA==
X-Gm-Message-State: AOAM533c66Y57YEwW7ZHL82ITxQUIqElTKt10bEYXO2nOCg1dpUo96C3
        o4DyRCBNU7kbl3YkKLbJujiZr7sla/DB9C51DW7D/o3ci6OrEx4Wugj3h7shDA8sPwOEYxFYTV3
        HhyCN7muvUBguCu//z+BAKYVGuTsO7nBngIdij9R4/TNeyMJeNkxW0BXHlOmAOBCNu5p+w+g=
X-Received: by 2002:a63:185b:: with SMTP id 27mr15670116pgy.0.1631627827633;
        Tue, 14 Sep 2021 06:57:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8DaZq8XqvKK9Y2ZtsydevKNVrAxWHyTailHO/GfR2KqxeL/bfuMjVsSoE+2/WhBv6vXnPIg==
X-Received: by 2002:a63:185b:: with SMTP id 27mr15670089pgy.0.1631627827186;
        Tue, 14 Sep 2021 06:57:07 -0700 (PDT)
Received: from [10.72.12.89] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z131sm10803501pfc.159.2021.09.14.06.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 06:57:06 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] ceph: include average/stddev r/w/m latency in mds
 metrics
To:     Venky Shankar <vshankar@redhat.com>, jlayton@redhat.com,
        pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
References: <20210914084902.1618064-1-vshankar@redhat.com>
 <20210914084902.1618064-4-vshankar@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <845ba820-8c83-d2f0-bbbd-83f23a88f978@redhat.com>
Date:   Tue, 14 Sep 2021 21:57:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210914084902.1618064-4-vshankar@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/14/21 4:49 PM, Venky Shankar wrote:
> The use of `jiffies_to_timespec64()` seems incorrect too, switch
> that to `ktime_to_timespec64()`.

I think this has been missed after I switched the jeffies to ktime for 
the r_start and r_end in my previous patch set.

This LGTM :-)

> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>   fs/ceph/metric.c | 35 +++++++++++++++++++----------------
>   fs/ceph/metric.h | 48 +++++++++++++++++++++++++++++++++---------------
>   2 files changed, 52 insertions(+), 31 deletions(-)
>
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 6b774b1a88ce..78a50bb7bd0f 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -8,6 +8,13 @@
>   #include "metric.h"
>   #include "mds_client.h"
>   
> +static void to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
> +{
> +	struct timespec64 t = ktime_to_timespec64(val);
> +	ts->tv_sec = cpu_to_le32(t.tv_sec);
> +	ts->tv_nsec = cpu_to_le32(t.tv_nsec);
> +}
> +
>   static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>   				   struct ceph_mds_session *s)
>   {
> @@ -26,7 +33,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>   	u64 nr_caps = atomic64_read(&m->total_caps);
>   	u32 header_len = sizeof(struct ceph_metric_header);
>   	struct ceph_msg *msg;
> -	struct timespec64 ts;
>   	s64 sum;
>   	s32 items = 0;
>   	s32 len;
> @@ -59,37 +65,34 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>   	/* encode the read latency metric */
>   	read = (struct ceph_metric_read_latency *)(cap + 1);
>   	read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
> -	read->header.ver = 1;
> +	read->header.ver = 2;
>   	read->header.compat = 1;
>   	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
> -	sum = m->read_latency_sum;
> -	jiffies_to_timespec64(sum, &ts);
> -	read->lat.tv_sec = cpu_to_le32(ts.tv_sec);
> -	read->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
> +	to_ceph_timespec(&read->lat, m->read_latency_sum);
> +	to_ceph_timespec(&read->avg, m->avg_read_latency);
> +	to_ceph_timespec(&read->stdev, m->read_latency_stdev);
>   	items++;
>   
>   	/* encode the write latency metric */
>   	write = (struct ceph_metric_write_latency *)(read + 1);
>   	write->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
> -	write->header.ver = 1;
> +	write->header.ver = 2;
>   	write->header.compat = 1;
>   	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
> -	sum = m->write_latency_sum;
> -	jiffies_to_timespec64(sum, &ts);
> -	write->lat.tv_sec = cpu_to_le32(ts.tv_sec);
> -	write->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
> +	to_ceph_timespec(&write->lat, m->write_latency_sum);
> +	to_ceph_timespec(&write->avg, m->avg_write_latency);
> +	to_ceph_timespec(&write->stdev, m->write_latency_stdev);
>   	items++;
>   
>   	/* encode the metadata latency metric */
>   	meta = (struct ceph_metric_metadata_latency *)(write + 1);
>   	meta->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
> -	meta->header.ver = 1;
> +	meta->header.ver = 2;
>   	meta->header.compat = 1;
>   	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
> -	sum = m->metadata_latency_sum;
> -	jiffies_to_timespec64(sum, &ts);
> -	meta->lat.tv_sec = cpu_to_le32(ts.tv_sec);
> -	meta->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
> +	to_ceph_timespec(&meta->lat, m->metadata_latency_sum);
> +	to_ceph_timespec(&meta->avg, m->avg_metadata_latency);
> +	to_ceph_timespec(&meta->stdev, m->metadata_latency_stdev);
>   	items++;
>   
>   	/* encode the dentry lease metric */
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index a5da21b8f8ed..2dd506dedebf 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -19,27 +19,39 @@ enum ceph_metric_type {
>   	CLIENT_METRIC_TYPE_OPENED_INODES,
>   	CLIENT_METRIC_TYPE_READ_IO_SIZES,
>   	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,
> -
> -	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_WRITE_IO_SIZES,
> +	CLIENT_METRIC_TYPE_AVG_READ_LATENCY,
> +	CLIENT_METRIC_TYPE_STDEV_READ_LATENCY,
> +	CLIENT_METRIC_TYPE_AVG_WRITE_LATENCY,
> +	CLIENT_METRIC_TYPE_STDEV_WRITE_LATENCY,
> +	CLIENT_METRIC_TYPE_AVG_METADATA_LATENCY,
> +	CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY,
> +
> +	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY,
>   };
>   
>   /*
>    * This will always have the highest metric bit value
>    * as the last element of the array.
>    */
> -#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	\
> -	CLIENT_METRIC_TYPE_CAP_INFO,		\
> -	CLIENT_METRIC_TYPE_READ_LATENCY,	\
> -	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
> -	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
> -	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
> -	CLIENT_METRIC_TYPE_OPENED_FILES,	\
> -	CLIENT_METRIC_TYPE_PINNED_ICAPS,	\
> -	CLIENT_METRIC_TYPE_OPENED_INODES,	\
> -	CLIENT_METRIC_TYPE_READ_IO_SIZES,	\
> -	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,	\
> -						\
> -	CLIENT_METRIC_TYPE_MAX,			\
> +#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	    \
> +	CLIENT_METRIC_TYPE_CAP_INFO,		    \
> +	CLIENT_METRIC_TYPE_READ_LATENCY,	    \
> +	CLIENT_METRIC_TYPE_WRITE_LATENCY,	    \
> +	CLIENT_METRIC_TYPE_METADATA_LATENCY,	    \
> +	CLIENT_METRIC_TYPE_DENTRY_LEASE,	    \
> +	CLIENT_METRIC_TYPE_OPENED_FILES,	    \
> +	CLIENT_METRIC_TYPE_PINNED_ICAPS,	    \
> +	CLIENT_METRIC_TYPE_OPENED_INODES,	    \
> +	CLIENT_METRIC_TYPE_READ_IO_SIZES,	    \
> +	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,	    \
> +	CLIENT_METRIC_TYPE_AVG_READ_LATENCY,	    \
> +	CLIENT_METRIC_TYPE_STDEV_READ_LATENCY,	    \
> +	CLIENT_METRIC_TYPE_AVG_WRITE_LATENCY,	    \
> +	CLIENT_METRIC_TYPE_STDEV_WRITE_LATENCY,	    \
> +	CLIENT_METRIC_TYPE_AVG_METADATA_LATENCY,    \
> +	CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY,  \
> +						    \
> +	CLIENT_METRIC_TYPE_MAX,			    \
>   }
>   
>   struct ceph_metric_header {
> @@ -61,18 +73,24 @@ struct ceph_metric_cap {
>   struct ceph_metric_read_latency {
>   	struct ceph_metric_header header;
>   	struct ceph_timespec lat;
> +	struct ceph_timespec avg;
> +	struct ceph_timespec stdev;
>   } __packed;
>   
>   /* metric write latency header */
>   struct ceph_metric_write_latency {
>   	struct ceph_metric_header header;
>   	struct ceph_timespec lat;
> +	struct ceph_timespec avg;
> +	struct ceph_timespec stdev;
>   } __packed;
>   
>   /* metric metadata latency header */
>   struct ceph_metric_metadata_latency {
>   	struct ceph_metric_header header;
>   	struct ceph_timespec lat;
> +	struct ceph_timespec avg;
> +	struct ceph_timespec stdev;
>   } __packed;
>   
>   /* metric dentry lease header */

