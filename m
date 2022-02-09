Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD194AF5CE
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Feb 2022 16:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbiBIPyC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Feb 2022 10:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbiBIPyB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Feb 2022 10:54:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 696B0C0613CA
        for <ceph-devel@vger.kernel.org>; Wed,  9 Feb 2022 07:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644422043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=53Ry4hgEFWffDBWiqbQfZFkq/A/olc8LadbKGZybHnM=;
        b=RKZLewlCk0WGdIZ9F4RQYmOxnNAni1y9gTXVQ41q345wOivaWgfJp2Rtusn25yVEWJ2jO2
        ftRrDOrMN1IX9qX4SlzSof3KhqN5KPQWlhvbyj2XSaSzvvGoA63u9zOKW9FclrKt+tRt+2
        iXoS6wf6eQMtJiVVAfpKQc1CmIwYxNY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-v_Km-rszPaas4LyHMLeWdw-1; Wed, 09 Feb 2022 10:54:02 -0500
X-MC-Unique: v_Km-rszPaas4LyHMLeWdw-1
Received: by mail-qt1-f200.google.com with SMTP id e28-20020ac8415c000000b002c5e43ca6b7so2038274qtm.9
        for <ceph-devel@vger.kernel.org>; Wed, 09 Feb 2022 07:54:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=53Ry4hgEFWffDBWiqbQfZFkq/A/olc8LadbKGZybHnM=;
        b=1f+Pd8vps8kA4oGoE5BsEmx7mHE9mX9YFqtX5fO4ug7VdAfWf2pGmaj1XAQHYBlAQM
         QLOH1Q1Ospv4Yz4uhOm90t5p/rX+fwfCuolpHHRfwie+QlZN3/cgVCYvpwi4XssHZD6L
         hLGKSMaSHbxSyUDh2YfJylbKMm67lNKZMXchlQJlwxkMoD1kxmyyAcRFi+Dy0MrPXY0n
         Sfhgt6zU23ihPaL6kC2zwJq6iF13HtoQW0sbzldbHiqMT68f8+EeTdh8f8Pr+tNAJlni
         KljYx0vP55TDTEoI2EJhQaHp99qiJ/bgeaxReCNJ8UO7WoAhng5cF6ClApNTzYRawBeH
         fNlA==
X-Gm-Message-State: AOAM533Fs4JxMH8kx0rUEc+z9Dt8nIPtV9QfJlh63ITjMy96iT71HUCI
        fnxX4n5J+JvHiFAqnbf/Pt31lRCRXPnFCeQYg/oeKh2u+6/4lQsYyedCo32zPrIPiBeDeQHfnFJ
        vmltI70P+g21bsfBmyZUVVA==
X-Received: by 2002:a05:622a:508:: with SMTP id l8mr1778169qtx.420.1644422041630;
        Wed, 09 Feb 2022 07:54:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxhORkombYVJMAr+1gl3z00VKOXNEktxMRuX8L+R4BJZukjX0jUjEhmI7YpZNbXOGc2NNuWdA==
X-Received: by 2002:a05:622a:508:: with SMTP id l8mr1778155qtx.420.1644422041417;
        Wed, 09 Feb 2022 07:54:01 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 139sm8358519qkf.32.2022.02.09.07.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 07:54:00 -0800 (PST)
Message-ID: <bec3d0774632d438288557af2184b8754031fcac.camel@redhat.com>
Subject: Re: [PATCH] ceph: use ktime_to_timespec64() rather than
 jiffies_to_timespec64()
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Wed, 09 Feb 2022 10:53:59 -0500
In-Reply-To: <20220209153849.496639-1-vshankar@redhat.com>
References: <20220209153849.496639-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-02-09 at 21:08 +0530, Venky Shankar wrote:
> Latencies are of type ktime_t, coverting from jiffies is incorrect.
> Also, switch to "struct ceph_timespec" for r/w/m latencies.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/metric.c | 20 ++++++++++----------
>  fs/ceph/metric.h | 11 ++++-------
>  2 files changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 0fcba68f9a99..a9cd23561a0d 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -8,6 +8,13 @@
>  #include "metric.h"
>  #include "mds_client.h"
>  
> +static void to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
> +{
> +	struct timespec64 t = ktime_to_timespec64(val);
> +	ts->tv_sec = cpu_to_le32(t.tv_sec);
> +	ts->tv_nsec = cpu_to_le32(t.tv_nsec);
> +}
> +
>  static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  				   struct ceph_mds_session *s)
>  {
> @@ -26,7 +33,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	u64 nr_caps = atomic64_read(&m->total_caps);
>  	u32 header_len = sizeof(struct ceph_metric_header);
>  	struct ceph_msg *msg;
> -	struct timespec64 ts;
>  	s64 sum;
>  	s32 items = 0;
>  	s32 len;
> @@ -63,9 +69,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	read->header.compat = 1;
>  	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
>  	sum = m->metric[METRIC_READ].latency_sum;
> -	jiffies_to_timespec64(sum, &ts);
> -	read->sec = cpu_to_le32(ts.tv_sec);
> -	read->nsec = cpu_to_le32(ts.tv_nsec);
> +	to_ceph_timespec(&read->lat, sum);
>  	items++;
>  
>  	/* encode the write latency metric */
> @@ -75,9 +79,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	write->header.compat = 1;
>  	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
>  	sum = m->metric[METRIC_WRITE].latency_sum;
> -	jiffies_to_timespec64(sum, &ts);
> -	write->sec = cpu_to_le32(ts.tv_sec);
> -	write->nsec = cpu_to_le32(ts.tv_nsec);
> +	to_ceph_timespec(&write->lat, sum);
>  	items++;
>  
>  	/* encode the metadata latency metric */
> @@ -87,9 +89,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	meta->header.compat = 1;
>  	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
>  	sum = m->metric[METRIC_METADATA].latency_sum;
> -	jiffies_to_timespec64(sum, &ts);
> -	meta->sec = cpu_to_le32(ts.tv_sec);
> -	meta->nsec = cpu_to_le32(ts.tv_nsec);
> +	to_ceph_timespec(&meta->lat, sum);
>  	items++;
>  
>  	/* encode the dentry lease metric */
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index bb45608181e7..5b2bb2897056 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -2,7 +2,7 @@
>  #ifndef _FS_CEPH_MDS_METRIC_H
>  #define _FS_CEPH_MDS_METRIC_H
>  
> -#include <linux/types.h>
> +#include <linux/ceph/types.h>
>  #include <linux/percpu_counter.h>
>  #include <linux/ktime.h>
>  
> @@ -60,22 +60,19 @@ struct ceph_metric_cap {
>  /* metric read latency header */
>  struct ceph_metric_read_latency {
>  	struct ceph_metric_header header;
> -	__le32 sec;
> -	__le32 nsec;
> +	struct ceph_timespec lat;
>  } __packed;
>  
>  /* metric write latency header */
>  struct ceph_metric_write_latency {
>  	struct ceph_metric_header header;
> -	__le32 sec;
> -	__le32 nsec;
> +	struct ceph_timespec lat;
>  } __packed;
>  
>  /* metric metadata latency header */
>  struct ceph_metric_metadata_latency {
>  	struct ceph_metric_header header;
> -	__le32 sec;
> -	__le32 nsec;
> +	struct ceph_timespec lat;
>  } __packed;
>  
>  /* metric dentry lease header */

Looks correct. Merged into testing branch. Thanks, Venky!

-- 
Jeff Layton <jlayton@redhat.com>

