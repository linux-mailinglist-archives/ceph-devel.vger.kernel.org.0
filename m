Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A028D4B0359
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Feb 2022 03:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiBJC3W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Feb 2022 21:29:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiBJC3V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Feb 2022 21:29:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AD7A236B5
        for <ceph-devel@vger.kernel.org>; Wed,  9 Feb 2022 18:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644460163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUvg6+c3n7yWqmCLKHNgJtKa7EWBszJsOMYs5kqgaBs=;
        b=a+wtOjWyBwKcQ5uDFmJ00ES99MtMic5qHU02xYWLFxZzgDB1Rq0EeWeHjMluYY1JN50coN
        M236dJB4ybqMLOeYr/e/ejROxjkNEYN0rbdJRub/u4MPMf0iymhOHbClHErRw1N/3SHtvt
        VNMw5PswADIxfRrzO52V5hujMn6Q4A4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-UEahNEanPXGdZQ_CsZoLsQ-1; Wed, 09 Feb 2022 21:29:22 -0500
X-MC-Unique: UEahNEanPXGdZQ_CsZoLsQ-1
Received: by mail-pl1-f199.google.com with SMTP id q4-20020a170902f78400b0014d57696618so466957pln.20
        for <ceph-devel@vger.kernel.org>; Wed, 09 Feb 2022 18:29:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SUvg6+c3n7yWqmCLKHNgJtKa7EWBszJsOMYs5kqgaBs=;
        b=xuJJAJ7kKrHaw1/0rFsc4IXRkpQfbS4XNSlG2WSL0ZCaGJDiZsrOQPaZoaj1tgPmtG
         2YQq/lxzkA5P1ElmMwrnmJ09m1xSh40Rsd8zR37nA+Hqu01eIDMiZ6fmJveiB2uXqGom
         jm5Va7KH57g6386d00FQH0oDbdE/wV9j8UOG1Xwqe4mo0Cas+MKjffiAWIhwtX25qtN3
         6bdEeKSByJ2hSwQQEV+UgSFJfCMP88TeAS6zBfsQfGQEHo3YIzzBBvTFNLcH5cjlIDfi
         NxFlurB4OJPhlyirZlpv1DXdhHS3DwVuzdTYxI+ptQCCgAMP193k29kS7tjhGbAgBTUI
         L7lw==
X-Gm-Message-State: AOAM531OZit8XaFGfbg/HjG4ZjjLOEvzgUuHah8yWwLer6Yt/a/50BLn
        uUg0HWRW/aTKCtBdnKy8D2G/BiAYdi+Qp6jGXoOQWCPRNqfrwt1nC8z6DpJ2kcKEGTGGfJN8Jcn
        dr2RSwWEc5dssDT5WFKwXPToc9wkNsLX5AQvIQ7fkpalJoGNOwvdV4ywGiFf6aX/u+CpbtDY=
X-Received: by 2002:a17:902:c94a:: with SMTP id i10mr4467601pla.137.1644460160219;
        Wed, 09 Feb 2022 18:29:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyADjx4DPa8V4EWHX57YBxYeXe8hzBwlNq4Wj1fOqQnNcg2+DUTlP9BXd69A+TtnKwAbSotHg==
X-Received: by 2002:a17:902:c94a:: with SMTP id i10mr4467579pla.137.1644460159881;
        Wed, 09 Feb 2022 18:29:19 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm122911pja.36.2022.02.09.18.29.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 18:29:19 -0800 (PST)
Subject: Re: [PATCH] ceph: use ktime_to_timespec64() rather than
 jiffies_to_timespec64()
To:     Venky Shankar <vshankar@redhat.com>, jlayton@redhat.com
Cc:     ceph-devel@vger.kernel.org
References: <20220209153849.496639-1-vshankar@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b2e075eb-967a-fd1a-97e2-acd20ab4f7e2@redhat.com>
Date:   Thu, 10 Feb 2022 10:29:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220209153849.496639-1-vshankar@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/9/22 11:38 PM, Venky Shankar wrote:
> Latencies are of type ktime_t, coverting from jiffies is incorrect.
> Also, switch to "struct ceph_timespec" for r/w/m latencies.
>
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>   fs/ceph/metric.c | 20 ++++++++++----------
>   fs/ceph/metric.h | 11 ++++-------
>   2 files changed, 14 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 0fcba68f9a99..a9cd23561a0d 100644
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
> @@ -63,9 +69,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>   	read->header.compat = 1;
>   	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
>   	sum = m->metric[METRIC_READ].latency_sum;
> -	jiffies_to_timespec64(sum, &ts);
> -	read->sec = cpu_to_le32(ts.tv_sec);
> -	read->nsec = cpu_to_le32(ts.tv_nsec);
> +	to_ceph_timespec(&read->lat, sum);
>   	items++;
>   
>   	/* encode the write latency metric */
> @@ -75,9 +79,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>   	write->header.compat = 1;
>   	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
>   	sum = m->metric[METRIC_WRITE].latency_sum;
> -	jiffies_to_timespec64(sum, &ts);
> -	write->sec = cpu_to_le32(ts.tv_sec);
> -	write->nsec = cpu_to_le32(ts.tv_nsec);
> +	to_ceph_timespec(&write->lat, sum);
>   	items++;
>   
>   	/* encode the metadata latency metric */
> @@ -87,9 +89,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>   	meta->header.compat = 1;
>   	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
>   	sum = m->metric[METRIC_METADATA].latency_sum;
> -	jiffies_to_timespec64(sum, &ts);
> -	meta->sec = cpu_to_le32(ts.tv_sec);
> -	meta->nsec = cpu_to_le32(ts.tv_nsec);
> +	to_ceph_timespec(&meta->lat, sum);
>   	items++;
>   
>   	/* encode the dentry lease metric */
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index bb45608181e7..5b2bb2897056 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -2,7 +2,7 @@
>   #ifndef _FS_CEPH_MDS_METRIC_H
>   #define _FS_CEPH_MDS_METRIC_H
>   
> -#include <linux/types.h>
> +#include <linux/ceph/types.h>
>   #include <linux/percpu_counter.h>
>   #include <linux/ktime.h>
>   
> @@ -60,22 +60,19 @@ struct ceph_metric_cap {
>   /* metric read latency header */
>   struct ceph_metric_read_latency {
>   	struct ceph_metric_header header;
> -	__le32 sec;
> -	__le32 nsec;
> +	struct ceph_timespec lat;
>   } __packed;
>   
>   /* metric write latency header */
>   struct ceph_metric_write_latency {
>   	struct ceph_metric_header header;
> -	__le32 sec;
> -	__le32 nsec;
> +	struct ceph_timespec lat;
>   } __packed;
>   
>   /* metric metadata latency header */
>   struct ceph_metric_metadata_latency {
>   	struct ceph_metric_header header;
> -	__le32 sec;
> -	__le32 nsec;
> +	struct ceph_timespec lat;
>   } __packed;
>   
>   /* metric dentry lease header */

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


