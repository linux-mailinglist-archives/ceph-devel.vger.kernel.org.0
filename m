Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F8612A5D7
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Dec 2019 04:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfLYDlf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Dec 2019 22:41:35 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25518 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726330AbfLYDlf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 24 Dec 2019 22:41:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577245292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nyph2eX6qkP8oJVK3vwLEGv5e647PQkt9BNwAZUJ1WE=;
        b=d/jM/vVhv9qgBrZSmJ7DLLPcTpwpq0/GSf/VXxrxooXYxfxpudz8imb4XO5g76+sIbDa8y
        IwWAlPvUMZ+oxO6clL6KfgHdOnQIOpBGLJWr+yaLoJSUn2YvBFCSxDEraeRQnuMVN7N1QK
        F4hMVmnjqJGq+ZNSPgQJzqHeWrQOLlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-KV8p5U-AMxijp-Mx3tHCQg-1; Tue, 24 Dec 2019 22:41:31 -0500
X-MC-Unique: KV8p5U-AMxijp-Mx3tHCQg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39F56800EBF;
        Wed, 25 Dec 2019 03:41:30 +0000 (UTC)
Received: from [10.72.12.64] (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 684385C3FD;
        Wed, 25 Dec 2019 03:41:25 +0000 (UTC)
Subject: Re: [PATCH 3/4] ceph: periodically send cap and dentry lease perf
 metrics to MDS
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191224040514.26144-1-xiubli@redhat.com>
 <20191224040514.26144-4-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <87b552f3-2f8c-06f1-a645-aaa2b7b0ef70@redhat.com>
Date:   Wed, 25 Dec 2019 11:41:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191224040514.26144-4-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/24 12:05, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> Currently only the cap and dentry lease perf metrics are support,
> and will send the metrics per 5 seconds.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/mds_client.c         | 79 ++++++++++++++++++++++++++++++++++++
>   include/linux/ceph/ceph_fs.h | 39 ++++++++++++++++++
>   2 files changed, 118 insertions(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index f58b74b2d1ec..5b74202ed68f 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4086,6 +4086,79 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
>   	ceph_force_reconnect(fsc->sb);
>   }
>   
> +/*
> + * called under s_mutex
> + */
> +static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> +				   struct ceph_mds_session *s,
> +				   bool skip_global)
> +{
> +	struct ceph_metric_head *head;
> +	struct ceph_metric_cap *cap;
> +	struct ceph_metric_dentry_lease *lease;
> +	struct ceph_msg *msg;
> +	s32 len = sizeof(*head) + sizeof(*cap);
> +	s32 items = 0;
> +
> +	if (!mdsc || !s)
> +		return false;
> +
> +	if (!skip_global)
> +		len += sizeof(*lease);
> +
> +	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
> +	if (!msg) {
> +		pr_err("send metrics to mds%d, failed to allocate message\n",
> +		       s->s_mds);
> +		return false;
> +	}
> +
> +	head = msg->front.iov_base;
> +
> +	/* encode the cap metric */
> +	cap = (struct ceph_metric_cap *)(head + 1);
> +	cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
> +	cap->ver = 1;
> +	cap->campat = 1;
> +	cap->data_len = cpu_to_le32(sizeof(*cap) - 6);
> +	cap->hit = cpu_to_le64(percpu_counter_sum(&s->i_caps_hit));
> +	cap->mis = cpu_to_le64(percpu_counter_sum(&s->i_caps_mis));
> +	cap->total = cpu_to_le64(s->s_nr_caps);
> +	items++;
> +
> +	dout("cap metric type %d, hit %lld, mis %lld, total %lld",
> +	     cap->type, cap->hit, cap->mis, cap->total);
> +
> +	/* only send the global once */
> +	if (skip_global)
> +		goto skip_global;
> +
> +	/* encode the dentry lease metric */
> +	lease = (struct ceph_metric_dentry_lease *)(cap + 1);
> +	lease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
> +	lease->ver = 1;
> +	lease->campat = 1;
> +	lease->data_len = cpu_to_le32(sizeof(*cap) - 6);
> +	lease->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_hit));
> +	lease->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_mis));
> +	lease->total = cpu_to_le64(atomic64_read(&mdsc->metric.total_dentries));
> +	items++;
> +
> +	dout("dentry lease metric type %d, hit %lld, mis %lld, total %lld",
> +	     lease->type, lease->hit, lease->mis, lease->total);
> +
> +skip_global:
> +	put_unaligned_le32(items, &head->num);
> +	msg->front.iov_len = cpu_to_le32(len);
> +	msg->hdr.version = cpu_to_le16(1);
> +	msg->hdr.compat_version = cpu_to_le16(1);
> +	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
> +	dout("send metrics to mds%d %p\n", s->s_mds, msg);
> +	ceph_con_send(&s->s_con, msg);
> +
> +	return true;
> +}
> +
>   /*
>    * delayed work -- periodically trim expired leases, renew caps with mds
>    */
> @@ -4115,6 +4188,8 @@ static void delayed_work(struct work_struct *work)
>   
>   	for (i = 0; i < mdsc->max_sessions; i++) {
>   		struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
> +		bool g_skip = false;

This should move out of the for loop. Will fix it in next version.

> +
>   		if (!s)
>   			continue;
>   		if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
> @@ -4140,6 +4215,9 @@ static void delayed_work(struct work_struct *work)
>   		mutex_unlock(&mdsc->mutex);
>   
>   		mutex_lock(&s->s_mutex);
> +
> +		g_skip = ceph_mdsc_send_metrics(mdsc, s, g_skip);
> +
>   		if (renew_caps)
>   			send_renew_caps(mdsc, s);
>   		else
> @@ -4147,6 +4225,7 @@ static void delayed_work(struct work_struct *work)
>   		if (s->s_state == CEPH_MDS_SESSION_OPEN ||
>   		    s->s_state == CEPH_MDS_SESSION_HUNG)
>   			ceph_send_cap_releases(mdsc, s);
> +
>   		mutex_unlock(&s->s_mutex);
>   		ceph_put_mds_session(s);
>   
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index cb21c5cf12c3..32758f9a2f1d 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -130,6 +130,7 @@ struct ceph_dir_layout {
>   #define CEPH_MSG_CLIENT_REQUEST         24
>   #define CEPH_MSG_CLIENT_REQUEST_FORWARD 25
>   #define CEPH_MSG_CLIENT_REPLY           26
> +#define CEPH_MSG_CLIENT_METRICS         29
>   #define CEPH_MSG_CLIENT_CAPS            0x310
>   #define CEPH_MSG_CLIENT_LEASE           0x311
>   #define CEPH_MSG_CLIENT_SNAP            0x312
> @@ -752,6 +753,44 @@ struct ceph_mds_lease {
>   } __attribute__ ((packed));
>   /* followed by a __le32+string for dname */
>   
> +enum ceph_metric_type {
> +	CLIENT_METRIC_TYPE_CAP_INFO,
> +	CLIENT_METRIC_TYPE_READ_LATENCY,
> +	CLIENT_METRIC_TYPE_WRITE_LATENCY,
> +	CLIENT_METRIC_TYPE_METADATA_LATENCY,
> +	CLIENT_METRIC_TYPE_DENTRY_LEASE,
> +};
> +
> +/* metric caps header */
> +struct ceph_metric_cap {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  campat;
> +
> +	__le32 data_len; /* length of sizeof(hit + mis + total) */
> +	__le64 hit;
> +	__le64 mis;
> +	__le64 total;
> +} __attribute__ ((packed));
> +
> +/* metric caps header */
> +struct ceph_metric_dentry_lease {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  campat;
> +
> +	__le32 data_len; /* length of sizeof(hit + mis + total) */
> +	__le64 hit;
> +	__le64 mis;
> +	__le64 total;
> +} __attribute__ ((packed));
> +
> +struct ceph_metric_head {
> +	__le32 num;	/* the number of metrics will be sent */
> +} __attribute__ ((packed));
> +
>   /* client reconnect */
>   struct ceph_mds_cap_reconnect {
>   	__le64 cap_id;


