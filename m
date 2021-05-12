Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D911437BBA5
	for <lists+ceph-devel@lfdr.de>; Wed, 12 May 2021 13:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhELLTa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 May 2021 07:19:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhELLT2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 May 2021 07:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AE26613CD;
        Wed, 12 May 2021 11:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620818300;
        bh=InzCfsqBc/gUR1py3YtIJ5s1D05QVskjE9Nng11I/rM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QCeSM862His7sd2gXv/Zz6ZxsT43pTEjP5whn1PXKshIGV3NlPSdaXPp9F4m4GD9G
         iTTLirunRIR34i6/GI2N2EAyzZnSQ2/nASTIs4VXtu4l60gPARUbSSRJOE8ST6EI3f
         5bZZtbTG/yb+e5fJt/l37cFvxKwThPv4JnSi0jF0PUoxnzQu5UZ1Tz6vlrB6FNBGnw
         /YovH1c7HGWU64TWJMyAa/JgwqnPEVdv4Yyda2qVSWmA8xHJxSPzzFJUEBdF7UInAb
         IXwUovGf4W0vVP5w81xE7sAWGx6IWpa6O8SOVXOwVw78V7mtf1eKMv1UIBNmj9z0ld
         RzJXgLYk0Xg2g==
Message-ID: <2ac585bf8b29e355eb82e9a8bbba0eea8a19ea66.camel@kernel.org>
Subject: Re: [PATCH 2/2] ceph: simplify the metrics struct
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 12 May 2021 07:18:19 -0400
In-Reply-To: <20210512093443.35128-3-xiubli@redhat.com>
References: <20210512093443.35128-1-xiubli@redhat.com>
         <20210512093443.35128-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-05-12 at 17:34 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/metric.c | 80 ++++++++++++++++++++++++------------------------
>  fs/ceph/metric.h | 73 +++++++++----------------------------------
>  2 files changed, 55 insertions(+), 98 deletions(-)
> 
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index d6c76f1667ed..ba8d86ae9fcf 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -46,10 +46,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  
>  	/* encode the cap metric */
>  	cap = (struct ceph_metric_cap *)(head + 1);
> -	cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
> -	cap->ver = 1;
> -	cap->compat = 1;
> -	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
> +	cap->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
> +	cap->header.ver = 1;
> +	cap->header.compat = 1;
> +	cap->header.data_len = cpu_to_le32(sizeof(*cap) - 10);

This would be a bit clearer:

	cap->header.data_len = cpu_to_le32(sizeof(*cap) - sizeof(struct ceph_metric_header));

At the very least, the "10" should be a named constant of some sort.
 
>  	cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
>  	cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
>  	cap->total = cpu_to_le64(nr_caps);
> @@ -57,10 +57,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  
>  	/* encode the read latency metric */
>  	read = (struct ceph_metric_read_latency *)(cap + 1);
> -	read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
> -	read->ver = 1;
> -	read->compat = 1;
> -	read->data_len = cpu_to_le32(sizeof(*read) - 10);
> +	read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
> +	read->header.ver = 1;
> +	read->header.compat = 1;
> +	read->header.data_len = cpu_to_le32(sizeof(*read) - 10);
>  	sum = m->read_latency_sum;
>  	jiffies_to_timespec64(sum, &ts);
>  	read->sec = cpu_to_le32(ts.tv_sec);
> @@ -69,10 +69,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  
>  	/* encode the write latency metric */
>  	write = (struct ceph_metric_write_latency *)(read + 1);
> -	write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
> -	write->ver = 1;
> -	write->compat = 1;
> -	write->data_len = cpu_to_le32(sizeof(*write) - 10);
> +	write->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
> +	write->header.ver = 1;
> +	write->header.compat = 1;
> +	write->header.data_len = cpu_to_le32(sizeof(*write) - 10);
>  	sum = m->write_latency_sum;
>  	jiffies_to_timespec64(sum, &ts);
>  	write->sec = cpu_to_le32(ts.tv_sec);
> @@ -81,10 +81,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  
>  	/* encode the metadata latency metric */
>  	meta = (struct ceph_metric_metadata_latency *)(write + 1);
> -	meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
> -	meta->ver = 1;
> -	meta->compat = 1;
> -	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
> +	meta->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
> +	meta->header.ver = 1;
> +	meta->header.compat = 1;
> +	meta->header.data_len = cpu_to_le32(sizeof(*meta) - 10);
>  	sum = m->metadata_latency_sum;
>  	jiffies_to_timespec64(sum, &ts);
>  	meta->sec = cpu_to_le32(ts.tv_sec);
> @@ -93,10 +93,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  
>  	/* encode the dentry lease metric */
>  	dlease = (struct ceph_metric_dlease *)(meta + 1);
> -	dlease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
> -	dlease->ver = 1;
> -	dlease->compat = 1;
> -	dlease->data_len = cpu_to_le32(sizeof(*dlease) - 10);
> +	dlease->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
> +	dlease->header.ver = 1;
> +	dlease->header.compat = 1;
> +	dlease->header.data_len = cpu_to_le32(sizeof(*dlease) - 10);
>  	dlease->hit = cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
>  	dlease->mis = cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
>  	dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
> @@ -106,50 +106,50 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  
>  	/* encode the opened files metric */
>  	files = (struct ceph_opened_files *)(dlease + 1);
> -	files->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
> -	files->ver = 1;
> -	files->compat = 1;
> -	files->data_len = cpu_to_le32(sizeof(*files) - 10);
> +	files->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
> +	files->header.ver = 1;
> +	files->header.compat = 1;
> +	files->header.data_len = cpu_to_le32(sizeof(*files) - 10);
>  	files->opened_files = cpu_to_le64(atomic64_read(&m->opened_files));
>  	files->total = cpu_to_le64(sum);
>  	items++;
>  
>  	/* encode the pinned icaps metric */
>  	icaps = (struct ceph_pinned_icaps *)(files + 1);
> -	icaps->type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
> -	icaps->ver = 1;
> -	icaps->compat = 1;
> -	icaps->data_len = cpu_to_le32(sizeof(*icaps) - 10);
> +	icaps->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
> +	icaps->header.ver = 1;
> +	icaps->header.compat = 1;
> +	icaps->header.data_len = cpu_to_le32(sizeof(*icaps) - 10);
>  	icaps->pinned_icaps = cpu_to_le64(nr_caps);
>  	icaps->total = cpu_to_le64(sum);
>  	items++;
>  
>  	/* encode the opened inodes metric */
>  	inodes = (struct ceph_opened_inodes *)(icaps + 1);
> -	inodes->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
> -	inodes->ver = 1;
> -	inodes->compat = 1;
> -	inodes->data_len = cpu_to_le32(sizeof(*inodes) - 10);
> +	inodes->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
> +	inodes->header.ver = 1;
> +	inodes->header.compat = 1;
> +	inodes->header.data_len = cpu_to_le32(sizeof(*inodes) - 10);
>  	inodes->opened_inodes = cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
>  	inodes->total = cpu_to_le64(sum);
>  	items++;
>  
>  	/* encode the read io size metric */
>  	rsize = (struct ceph_read_io_size *)(inodes + 1);
> -	rsize->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_IO_SIZES);
> -	rsize->ver = 1;
> -	rsize->compat = 1;
> -	rsize->data_len = cpu_to_le32(sizeof(*rsize) - 10);
> +	rsize->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_IO_SIZES);
> +	rsize->header.ver = 1;
> +	rsize->header.compat = 1;
> +	rsize->header.data_len = cpu_to_le32(sizeof(*rsize) - 10);
>  	rsize->total_ops = cpu_to_le64(m->total_reads);
>  	rsize->total_size = cpu_to_le64(m->read_size_sum);
>  	items++;
>  

It might be good to reorder these patches to do this struct cleanup
first, so that you don't end up patching code you just added.
 
>  	/* encode the write io size metric */
>  	wsize = (struct ceph_write_io_size *)(rsize + 1);
> -	wsize->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_IO_SIZES);
> -	wsize->ver = 1;
> -	wsize->compat = 1;
> -	wsize->data_len = cpu_to_le32(sizeof(*wsize) - 10);
> +	wsize->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_IO_SIZES);
> +	wsize->header.ver = 1;
> +	wsize->header.compat = 1;
> +	wsize->header.data_len = cpu_to_le32(sizeof(*wsize) - 10);
>  	wsize->total_ops = cpu_to_le64(m->total_writes);
>  	wsize->total_size = cpu_to_le64(m->write_size_sum);
>  	items++;
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 44b0f478b84b..0133955a3c6a 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -42,14 +42,16 @@ enum ceph_metric_type {
>  	CLIENT_METRIC_TYPE_MAX,			\
>  }
>  
> -/* metric caps header */
> -struct ceph_metric_cap {
> +struct ceph_metric_header {
>  	__le32 type;     /* ceph metric type */
> -
>  	__u8  ver;
>  	__u8  compat;
> -
>  	__le32 data_len; /* length of sizeof(hit + mis + total) */
> +} __packed;
> +
> +/* metric caps header */
> +struct ceph_metric_cap {
> +	struct ceph_metric_header header;
>  	__le64 hit;
>  	__le64 mis;
>  	__le64 total;
> @@ -57,48 +59,28 @@ struct ceph_metric_cap {
>  
>  /* metric read latency header */
>  struct ceph_metric_read_latency {
> -	__le32 type;     /* ceph metric type */
> -
> -	__u8  ver;
> -	__u8  compat;
> -
> -	__le32 data_len; /* length of sizeof(sec + nsec) */
> +	struct ceph_metric_header header;
>  	__le32 sec;
>  	__le32 nsec;
>  } __packed;
>  
>  /* metric write latency header */
>  struct ceph_metric_write_latency {
> -	__le32 type;     /* ceph metric type */
> -
> -	__u8  ver;
> -	__u8  compat;
> -
> -	__le32 data_len; /* length of sizeof(sec + nsec) */
> +	struct ceph_metric_header header;
>  	__le32 sec;
>  	__le32 nsec;
>  } __packed;
>  
>  /* metric metadata latency header */
>  struct ceph_metric_metadata_latency {
> -	__le32 type;     /* ceph metric type */
> -
> -	__u8  ver;
> -	__u8  compat;
> -
> -	__le32 data_len; /* length of sizeof(sec + nsec) */
> +	struct ceph_metric_header header;
>  	__le32 sec;
>  	__le32 nsec;
>  } __packed;
>  
>  /* metric dentry lease header */
>  struct ceph_metric_dlease {
> -	__le32 type;     /* ceph metric type */
> -
> -	__u8  ver;
> -	__u8  compat;
> -
> -	__le32 data_len; /* length of sizeof(hit + mis + total) */
> +	struct ceph_metric_header header;
>  	__le64 hit;
>  	__le64 mis;
>  	__le64 total;
> @@ -106,60 +88,35 @@ struct ceph_metric_dlease {
>  
>  /* metric opened files header */
>  struct ceph_opened_files {
> -	__le32 type;     /* ceph metric type */
> -
> -	__u8  ver;
> -	__u8  compat;
> -
> -	__le32 data_len; /* length of sizeof(opened_files + total) */
> +	struct ceph_metric_header header;
>  	__le64 opened_files;
>  	__le64 total;
>  } __packed;
>  
>  /* metric pinned i_caps header */
>  struct ceph_pinned_icaps {
> -	__le32 type;     /* ceph metric type */
> -
> -	__u8  ver;
> -	__u8  compat;
> -
> -	__le32 data_len; /* length of sizeof(pinned_icaps + total) */
> +	struct ceph_metric_header header;
>  	__le64 pinned_icaps;
>  	__le64 total;
>  } __packed;
>  
>  /* metric opened inodes header */
>  struct ceph_opened_inodes {
> -	__le32 type;     /* ceph metric type */
> -
> -	__u8  ver;
> -	__u8  compat;
> -
> -	__le32 data_len; /* length of sizeof(opened_inodes + total) */
> +	struct ceph_metric_header header;
>  	__le64 opened_inodes;
>  	__le64 total;
>  } __packed;
>  
>  /* metric read io size header */
>  struct ceph_read_io_size {
> -	__le32 type;     /* ceph metric type */
> -
> -	__u8  ver;
> -	__u8  compat;
> -
> -	__le32 data_len; /* length of sizeof(opened_inodes + total) */
> +	struct ceph_metric_header header;
>  	__le64 total_ops;
>  	__le64 total_size;
>  } __packed;
>  
>  /* metric write io size header */
>  struct ceph_write_io_size {
> -	__le32 type;     /* ceph metric type */
> -
> -	__u8  ver;
> -	__u8  compat;
> -
> -	__le32 data_len; /* length of sizeof(opened_inodes + total) */
> +	struct ceph_metric_header header;
>  	__le64 total_ops;
>  	__le64 total_size;
>  } __packed;

-- 
Jeff Layton <jlayton@kernel.org>

