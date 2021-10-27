Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69D643C919
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Oct 2021 14:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbhJ0MDB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 08:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233751AbhJ0MDA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 08:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635336033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3O47PaZqThUT0SxV62zMQ4NcbQLtYN5EqCax7qGe9+c=;
        b=NAugH6pkZv14JesZPMmKs6Yl0rDbERO4qoIYreSJ+pGvMglEf1DuM74bplXE2r5r7Eguvs
        2HYIBwkZ3yTGkaCF5v7Z30u6suXDt0I2umW4dmCvVW9xlrQyMG8IWM1ljBn7zM5plmHn6k
        rF74Mlw5BnpU87BXxcsMjFvhMII4V80=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-CbouWtMdP_20RDFX3fCsbw-1; Wed, 27 Oct 2021 08:00:31 -0400
X-MC-Unique: CbouWtMdP_20RDFX3fCsbw-1
Received: by mail-pg1-f199.google.com with SMTP id r25-20020a63a019000000b002a20656994dso1501236pge.3
        for <ceph-devel@vger.kernel.org>; Wed, 27 Oct 2021 05:00:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3O47PaZqThUT0SxV62zMQ4NcbQLtYN5EqCax7qGe9+c=;
        b=39yppkh0IUR7vV3rA89McQHjEjBzj4f27T1V7YybjyInLL7IWbFPxMf45Rmhm3eeqq
         raCz7aYsjl9hh5pi0F0hyJ6uiAJCV/FVhFu1hALAicFYoMJRuO+4G4TqCMohz13LAI16
         xSmQLM72l+JlzrHu/+HdBUOksFGkVoRO7e8mXs9j0BSoFTmLobtfQZc6BST1t2ZpJw4O
         QncozrQnBZ1HG2BffMNidfwZ+WTpf57U3GdsR76R59VYE1pZ/fs5UXvZ9GPw0vry61+y
         +Bi5QOu9m33+2ygziofb9niO5OscqASZ8GE3z1RXfgysHgqK68epQipvwbOhtOW3q4Ik
         c4Sw==
X-Gm-Message-State: AOAM530Cq9stWtmmtrjPSOlBIK2sHwZ6TeQ3Q07XZyalDNa33GSQ8wvR
        hV7N1JvyprNGVhbBuz/QDjHg3tNLjFFEpw8IV/YISxM8tsFSo7F6uTp/nmPOSSIJ+wc4Gc0K+H5
        HYR631G0iURy4pWS7ZUBewg==
X-Received: by 2002:a63:8f02:: with SMTP id n2mr23578670pgd.270.1635336030349;
        Wed, 27 Oct 2021 05:00:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOtqMaeoBbvchWH6gJbv+gfPIZXo5Dk9mPEUP/xy4R4exsjh5v/D8SGwkOGteViuhGnk4LpQ==
X-Received: by 2002:a63:8f02:: with SMTP id n2mr23578638pgd.270.1635336030026;
        Wed, 27 Oct 2021 05:00:30 -0700 (PDT)
Received: from [10.72.12.93] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h1sm28283462pfi.168.2021.10.27.05.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 05:00:29 -0700 (PDT)
Subject: Re: [PATCH] ceph: split 'metric' debugfs file into several files
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1ac925e3-5596-dcf4-317e-1408c764350f@redhat.com>
 <20211027100130.15227-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <19b30242-15ed-876c-02cb-7d0e2d18ad8d@redhat.com>
Date:   Wed, 27 Oct 2021 20:00:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211027100130.15227-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/27/21 6:01 PM, Luís Henriques wrote:
> Currently, all the metrics are grouped together in a single file, making
> it difficult to process this file from scripts.  Furthermore, as new
> metrics are added, processing this file will become even more challenging.
>
> This patch turns the 'metric' file into a directory that will contain
> several files, one for each metric.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Here's a patch that does just what I proposed.  It simply turns the metric
> file into a directory.  Not sure this is the best option, but here it is
> for discussion.
>
> Cheers,
> --
> Luís
>
>   fs/ceph/debugfs.c | 81 ++++++++++++++++++++++++++++++++---------------
>   fs/ceph/super.h   |  2 +-
>   2 files changed, 57 insertions(+), 26 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 38b78b45811f..55426514491b 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -146,26 +146,30 @@ static int mdsc_show(struct seq_file *s, void *p)
>   		   name, total, avg, _min, max, sum);			\
>   }
>   
> -static int metric_show(struct seq_file *s, void *p)
> +static int metrics_file_show(struct seq_file *s, void *p)
>   {
>   	struct ceph_fs_client *fsc = s->private;
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> -	struct ceph_client_metric *m = &mdsc->metric;
> -	int nr_caps = 0;
> -	s64 total, sum, avg, min, max, sq;
> -	u64 sum_sz, avg_sz, min_sz, max_sz;
> +	struct ceph_client_metric *m = &fsc->mdsc->metric;
>   
> -	sum = percpu_counter_sum(&m->total_inodes);
>   	seq_printf(s, "item                               total\n");
>   	seq_printf(s, "------------------------------------------\n");
> -	seq_printf(s, "%-35s%lld / %lld\n", "opened files  / total inodes",
> -		   atomic64_read(&m->opened_files), sum);
> -	seq_printf(s, "%-35s%lld / %lld\n", "pinned i_caps / total inodes",
> -		   atomic64_read(&m->total_caps), sum);
> -	seq_printf(s, "%-35s%lld / %lld\n", "opened inodes / total inodes",
> -		   percpu_counter_sum(&m->opened_inodes), sum);
> -
> -	seq_printf(s, "\n");
> +	seq_printf(s, "%-35s%lld\n", "total inodes",
> +		   percpu_counter_sum(&m->total_inodes));
> +	seq_printf(s, "%-35s%lld\n", "opened files",
> +		   atomic64_read(&m->opened_files));
> +	seq_printf(s, "%-35s%lld\n", "pinned i_caps",
> +		   atomic64_read(&m->total_caps));
> +	seq_printf(s, "%-35s%lld\n", "opened inodes",
> +		   percpu_counter_sum(&m->opened_inodes));
> +	return 0;
> +}
> +
> +static int metrics_latency_show(struct seq_file *s, void *p)
> +{
> +	struct ceph_fs_client *fsc = s->private;
> +	struct ceph_client_metric *m = &fsc->mdsc->metric;
> +	s64 total, sum, avg, min, max, sq;
> +
>   	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
>   	seq_printf(s, "-----------------------------------------------------------------------------------\n");
>   
> @@ -199,7 +203,16 @@ static int metric_show(struct seq_file *s, void *p)
>   	spin_unlock(&m->metadata_metric_lock);
>   	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
>   
> -	seq_printf(s, "\n");
> +	return 0;
> +}
> +
> +static int metrics_size_show(struct seq_file *s, void *p)
> +{
> +	struct ceph_fs_client *fsc = s->private;
> +	struct ceph_client_metric *m = &fsc->mdsc->metric;
> +	s64 total;
> +	u64 sum_sz, avg_sz, min_sz, max_sz;
> +
>   	seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
>   	seq_printf(s, "----------------------------------------------------------------------------------------\n");
>   
> @@ -221,7 +234,15 @@ static int metric_show(struct seq_file *s, void *p)
>   	spin_unlock(&m->write_metric_lock);
>   	CEPH_SZ_METRIC_SHOW("write", total, avg_sz, min_sz, max_sz, sum_sz);
>   
> -	seq_printf(s, "\n");
> +	return 0;
> +}
> +
> +static int metrics_caps_show(struct seq_file *s, void *p)
> +{
> +	struct ceph_fs_client *fsc = s->private;
> +	struct ceph_client_metric *m = &fsc->mdsc->metric;
> +	int nr_caps = 0;
> +
>   	seq_printf(s, "item          total           miss            hit\n");
>   	seq_printf(s, "-------------------------------------------------\n");
>   
> @@ -350,8 +371,11 @@ DEFINE_SHOW_ATTRIBUTE(mdsmap);
>   DEFINE_SHOW_ATTRIBUTE(mdsc);
>   DEFINE_SHOW_ATTRIBUTE(caps);
>   DEFINE_SHOW_ATTRIBUTE(mds_sessions);
> -DEFINE_SHOW_ATTRIBUTE(metric);
>   DEFINE_SHOW_ATTRIBUTE(status);
> +DEFINE_SHOW_ATTRIBUTE(metrics_file);
> +DEFINE_SHOW_ATTRIBUTE(metrics_latency);
> +DEFINE_SHOW_ATTRIBUTE(metrics_size);
> +DEFINE_SHOW_ATTRIBUTE(metrics_caps);
>   
>   
>   /*
> @@ -385,8 +409,9 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>   	debugfs_remove(fsc->debugfs_mdsmap);
>   	debugfs_remove(fsc->debugfs_mds_sessions);
>   	debugfs_remove(fsc->debugfs_caps);
> -	debugfs_remove(fsc->debugfs_metric);
> +	debugfs_remove(fsc->debugfs_status);
>   	debugfs_remove(fsc->debugfs_mdsc);
> +	debugfs_remove_recursive(fsc->debugfs_metrics_dir);
>   }
>   
>   void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
> @@ -426,12 +451,6 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>   						fsc,
>   						&mdsc_fops);
>   
> -	fsc->debugfs_metric = debugfs_create_file("metrics",
> -						  0400,
> -						  fsc->client->debugfs_dir,
> -						  fsc,
> -						  &metric_fops);
> -
>   	fsc->debugfs_caps = debugfs_create_file("caps",
>   						0400,
>   						fsc->client->debugfs_dir,
> @@ -443,6 +462,18 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>   						  fsc->client->debugfs_dir,
>   						  fsc,
>   						  &status_fops);
> +
> +	fsc->debugfs_metrics_dir = debugfs_create_dir("metrics",
> +						      fsc->client->debugfs_dir);
> +
> +	debugfs_create_file("file", 0400, fsc->debugfs_metrics_dir, fsc,
> +			    &metrics_file_fops);
> +	debugfs_create_file("latency", 0400, fsc->debugfs_metrics_dir, fsc,
> +			    &metrics_latency_fops);
> +	debugfs_create_file("size", 0400, fsc->debugfs_metrics_dir, fsc,
> +			    &metrics_size_fops);
> +	debugfs_create_file("caps", 0400, fsc->debugfs_metrics_dir, fsc,
> +			    &metrics_caps_fops);
>   }
>   
>   
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 14f951cd5b61..795b077143d6 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -128,9 +128,9 @@ struct ceph_fs_client {
>   	struct dentry *debugfs_congestion_kb;
>   	struct dentry *debugfs_bdi;
>   	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
> -	struct dentry *debugfs_metric;
>   	struct dentry *debugfs_status;
>   	struct dentry *debugfs_mds_sessions;
> +	struct dentry *debugfs_metrics_dir;
>   #endif
>   
>   #ifdef CONFIG_CEPH_FSCACHE
>
LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


