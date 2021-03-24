Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC52D347BA2
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Mar 2021 16:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236427AbhCXPFL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 11:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236467AbhCXPEx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 11:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42906619B8;
        Wed, 24 Mar 2021 15:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616598293;
        bh=ArGIzMtab2JuU1WpZ1tRZt4GbNDZKMaV+5mtH7nWsNI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pO5YvjqXJZq1h88MbunTszOZEsbDOvzaTZSfY8bZabEEP4asFSsOK8kmC3kEiB511
         eXknzwNXaXkuoD3oMKP/8VoDjo1AjWE3EymSzJnUV9MuepSctns5hlcYtQPPXXk0wu
         vkIzUhj9Tl8VZu74/vfTmMYdRoLvvoqVqMlEf/MDFvo88LnpYllz1UhvZkJcxI1QCk
         mEi0LWgyUgbNg4L4bPraoqf3d8GZdxTcURtBBoSJ15TTmqOwN27rlo5oRI0HRfqPid
         eUxCLklHQI/6ERz+rjyr2hkO54K+tZU+iAUlTbf8Wa41X+H9GP1ck7jOD2LTxhC2b+
         C2LjZKHoN1XtQ==
Message-ID: <f1488afcf8446c4cb7ebf0bad9e21afa5bb9b110.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: send opened files/pinned caps/opened inodes
 metrics to MDS daemon
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 24 Mar 2021 11:04:52 -0400
In-Reply-To: <20210324050825.1650763-1-xiubli@redhat.com>
References: <20210324050825.1650763-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-03-24 at 13:08 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For the old ceph version, if it received this metric info, it will just
> ignore them.
> 
> URL: https://tracker.ceph.com/issues/46866
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V2:
> - fix the crash issue.
> 
> 
>  fs/ceph/metric.c | 38 +++++++++++++++++++++++++++++++++++++-
>  fs/ceph/metric.h | 44 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 5ec94bd4c1de..895eab25d314 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -17,6 +17,9 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	struct ceph_metric_write_latency *write;
>  	struct ceph_metric_metadata_latency *meta;
>  	struct ceph_metric_dlease *dlease;
> +	struct ceph_opened_files *files;
> +	struct ceph_pinned_icaps *icaps;
> +	struct ceph_opened_inodes *inodes;
>  	struct ceph_client_metric *m = &mdsc->metric;
>  	u64 nr_caps = atomic64_read(&m->total_caps);
>  	struct ceph_msg *msg;
> @@ -26,7 +29,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	s32 len;
>  
>  	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
> -	      + sizeof(*meta) + sizeof(*dlease);
> +	      + sizeof(*meta) + sizeof(*dlease) + sizeof(*files)
> +	      + sizeof(*icaps) + sizeof(*inodes);
>  
>  	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
>  	if (!msg) {
> @@ -95,6 +99,38 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>  	dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
>  	items++;
>  
> +	sum = percpu_counter_sum(&m->total_inodes);
> +
> +	/* encode the opened files metric */
> +	files = (struct ceph_opened_files *)(dlease + 1);
> +	files->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
> +	files->ver = 1;
> +	files->compat = 1;
> +	files->data_len = cpu_to_le32(sizeof(*files) - 10);
> +	files->opened_files = cpu_to_le64(atomic64_read(&m->opened_files));
> +	files->total = cpu_to_le64(sum);
> +	items++;
> +
> +	/* encode the pinned icaps metric */
> +	icaps = (struct ceph_pinned_icaps *)(files + 1);
> +	icaps->type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
> +	icaps->ver = 1;
> +	icaps->compat = 1;
> +	icaps->data_len = cpu_to_le32(sizeof(*icaps) - 10);
> +	icaps->pinned_icaps = cpu_to_le64(nr_caps);
> +	icaps->total = cpu_to_le64(sum);
> +	items++;
> +
> +	/* encode the opened inodes metric */
> +	inodes = (struct ceph_opened_inodes *)(icaps + 1);
> +	inodes->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
> +	inodes->ver = 1;
> +	inodes->compat = 1;
> +	inodes->data_len = cpu_to_le32(sizeof(*inodes) - 10);
> +	inodes->opened_inodes = cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
> +	inodes->total = cpu_to_le64(sum);
> +	items++;
> +
>  	put_unaligned_le32(items, &head->num);
>  	msg->front.iov_len = len;
>  	msg->hdr.version = cpu_to_le16(1);
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index af6038ff39d4..4ceb462135d7 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -14,8 +14,11 @@ enum ceph_metric_type {
>  	CLIENT_METRIC_TYPE_WRITE_LATENCY,
>  	CLIENT_METRIC_TYPE_METADATA_LATENCY,
>  	CLIENT_METRIC_TYPE_DENTRY_LEASE,
> +	CLIENT_METRIC_TYPE_OPENED_FILES,
> +	CLIENT_METRIC_TYPE_PINNED_ICAPS,
> +	CLIENT_METRIC_TYPE_OPENED_INODES,
>  
> -	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_DENTRY_LEASE,
> +	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_OPENED_INODES,
>  };
>  
>  /*
> @@ -28,6 +31,9 @@ enum ceph_metric_type {
>  	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
>  	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
>  	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
> +	CLIENT_METRIC_TYPE_OPENED_FILES,	\
> +	CLIENT_METRIC_TYPE_PINNED_ICAPS,	\
> +	CLIENT_METRIC_TYPE_OPENED_INODES,	\
>  						\
>  	CLIENT_METRIC_TYPE_MAX,			\
>  }
> @@ -94,6 +100,42 @@ struct ceph_metric_dlease {
>  	__le64 total;
>  } __packed;
>  
> +/* metric opened files header */
> +struct ceph_opened_files {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  compat;
> +
> +	__le32 data_len; /* length of sizeof(opened_files + total) */
> +	__le64 opened_files;
> +	__le64 total;
> +} __packed;
> +
> +/* metric pinned i_caps header */
> +struct ceph_pinned_icaps {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  compat;
> +
> +	__le32 data_len; /* length of sizeof(pinned_icaps + total) */
> +	__le64 pinned_icaps;
> +	__le64 total;
> +} __packed;
> +
> +/* metric opened inodes header */
> +struct ceph_opened_inodes {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  compat;
> +
> +	__le32 data_len; /* length of sizeof(opened_inodes + total) */
> +	__le64 opened_inodes;
> +	__le64 total;
> +} __packed;
> +
>  struct ceph_metric_head {
>  	__le32 num;	/* the number of metrics that will be sent */
>  } __packed;

Much better. Merged into ceph-client/testing.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

