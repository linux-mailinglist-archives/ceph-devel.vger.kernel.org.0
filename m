Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C36D34403A
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Mar 2021 12:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhCVLz4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Mar 2021 07:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhCVLzY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 07:55:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DAAB6198D;
        Mon, 22 Mar 2021 11:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616414123;
        bh=0v85DL5QtqqLt3HkM4H53DgFTvHsbxD4SgWtlMf1TCg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=es1f9XY2cDbIoPZINCKR+J9HYlV8G0BuJTcAsbmWnZPr5Zv2aza5SAcqIWGNopFXs
         IFRWJ/ZNUt40GbHZVJYjU8X2R4mLCVks88BhDih8+iuBVLkYreAapepMGYkeCy8p76
         Z4ctJ7Lcl/yBwwRqWBM+TFYjiMw1iiuVNd6zreu1NoDFiu1FRE6fcQyuqiFNHikzKb
         dPhNfDwIKWR58R8rbZsQd7c1HObdAMQceY2dgtzR+mOkOBH4zojFbo9N8+vxc6l7tT
         TyqhlsiLk3WAZBoiwf3nRVPq80FZDX9uq5BZQ2e2LEd0UkGElrRlwjRW/1yQEXMMmW
         xlvQZDdWtMkng==
Message-ID: <5c1461d4f7c03f226ed2458f491885cfe9b44841.camel@kernel.org>
Subject: Re: [PATCH] ceph: send opened files/pinned caps/opened inodes
 metrics to MDS daemon
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 22 Mar 2021 07:55:21 -0400
In-Reply-To: <c9ec3257-6067-68a6-e10c-802141e9227b@redhat.com>
References: <20201126034743.1151342-1-xiubli@redhat.com>
         <c9ec3257-6067-68a6-e10c-802141e9227b@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Oh! I hadn't realized that this patch was still unmerged.

Merged into testing branch. I'd have pulled this into testing a while
ago if I had realized. Let me know if I miss any in the future (or am
missing any now).

Cheers,
Jeff

On Mon, 2021-03-22 at 10:30 +0800, Xiubo Li wrote:
> Hi Jeff,
> 
> Ping.
> 
> The MDS side patch[1] have been merged.
> 
> [1] https://github.com/ceph/ceph/pull/37945
> 
> Thanks
> 
> 
> On 2020/11/26 11:47, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > For the old ceph version, if it received this metric message containing
> > the send opened files/pinned caps/opened inodes metric info, it will
> > just ignore them.
> > 
> > URL: https://tracker.ceph.com/issues/46866
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >   fs/ceph/metric.c | 38 +++++++++++++++++++++++++++++++++++++-
> >   fs/ceph/metric.h | 44 +++++++++++++++++++++++++++++++++++++++++++-
> >   2 files changed, 80 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> > index 5ec94bd4c1de..306bd599d940 100644
> > --- a/fs/ceph/metric.c
> > +++ b/fs/ceph/metric.c
> > @@ -17,6 +17,9 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> >   	struct ceph_metric_write_latency *write;
> >   	struct ceph_metric_metadata_latency *meta;
> >   	struct ceph_metric_dlease *dlease;
> > +	struct ceph_opened_files *files;
> > +	struct ceph_pinned_icaps *icaps;
> > +	struct ceph_opened_inodes *inodes;
> >   	struct ceph_client_metric *m = &mdsc->metric;
> >   	u64 nr_caps = atomic64_read(&m->total_caps);
> >   	struct ceph_msg *msg;
> > @@ -26,7 +29,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> >   	s32 len;
> >   
> > 
> >   	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
> > -	      + sizeof(*meta) + sizeof(*dlease);
> > +	      + sizeof(*meta) + sizeof(*dlease) + sizeof(files) + sizeof(icaps)
> > +	      + sizeof(inodes);
> >   
> > 
> >   	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
> >   	if (!msg) {
> > @@ -95,6 +99,38 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> >   	dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
> >   	items++;
> >   
> > 
> > +	sum = percpu_counter_sum(&m->total_inodes);
> > +
> > +	/* encode the opened files metric */
> > +	files = (struct ceph_opened_files *)(dlease + 1);
> > +	files->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
> > +	files->ver = 1;
> > +	files->compat = 1;
> > +	files->data_len = cpu_to_le32(sizeof(*files) - 10);
> > +	files->opened_files = cpu_to_le64(atomic64_read(&m->opened_files));
> > +	files->total = cpu_to_le64(sum);
> > +	items++;
> > +
> > +	/* encode the pinned icaps metric */
> > +	icaps = (struct ceph_pinned_icaps *)(files + 1);
> > +	icaps->type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
> > +	icaps->ver = 1;
> > +	icaps->compat = 1;
> > +	icaps->data_len = cpu_to_le32(sizeof(*icaps) - 10);
> > +	icaps->pinned_icaps = cpu_to_le64(nr_caps);
> > +	icaps->total = cpu_to_le64(sum);
> > +	items++;
> > +
> > +	/* encode the opened inodes metric */
> > +	inodes = (struct ceph_opened_inodes *)(icaps + 1);
> > +	inodes->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
> > +	inodes->ver = 1;
> > +	inodes->compat = 1;
> > +	inodes->data_len = cpu_to_le32(sizeof(*inodes) - 10);
> > +	inodes->opened_inodes = cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
> > +	inodes->total = cpu_to_le64(sum);
> > +	items++;
> > +
> >   	put_unaligned_le32(items, &head->num);
> >   	msg->front.iov_len = len;
> >   	msg->hdr.version = cpu_to_le16(1);
> > diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> > index af6038ff39d4..4ceb462135d7 100644
> > --- a/fs/ceph/metric.h
> > +++ b/fs/ceph/metric.h
> > @@ -14,8 +14,11 @@ enum ceph_metric_type {
> >   	CLIENT_METRIC_TYPE_WRITE_LATENCY,
> >   	CLIENT_METRIC_TYPE_METADATA_LATENCY,
> >   	CLIENT_METRIC_TYPE_DENTRY_LEASE,
> > +	CLIENT_METRIC_TYPE_OPENED_FILES,
> > +	CLIENT_METRIC_TYPE_PINNED_ICAPS,
> > +	CLIENT_METRIC_TYPE_OPENED_INODES,
> >   
> > 
> > -	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_DENTRY_LEASE,
> > +	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_OPENED_INODES,
> >   };
> >   
> > 
> >   /*
> > @@ -28,6 +31,9 @@ enum ceph_metric_type {
> >   	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
> >   	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
> >   	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
> > +	CLIENT_METRIC_TYPE_OPENED_FILES,	\
> > +	CLIENT_METRIC_TYPE_PINNED_ICAPS,	\
> > +	CLIENT_METRIC_TYPE_OPENED_INODES,	\
> >   						\
> >   	CLIENT_METRIC_TYPE_MAX,			\
> >   }
> > @@ -94,6 +100,42 @@ struct ceph_metric_dlease {
> >   	__le64 total;
> >   } __packed;
> >   
> > 
> > +/* metric opened files header */
> > +struct ceph_opened_files {
> > +	__le32 type;     /* ceph metric type */
> > +
> > +	__u8  ver;
> > +	__u8  compat;
> > +
> > +	__le32 data_len; /* length of sizeof(opened_files + total) */
> > +	__le64 opened_files;
> > +	__le64 total;
> > +} __packed;
> > +
> > +/* metric pinned i_caps header */
> > +struct ceph_pinned_icaps {
> > +	__le32 type;     /* ceph metric type */
> > +
> > +	__u8  ver;
> > +	__u8  compat;
> > +
> > +	__le32 data_len; /* length of sizeof(pinned_icaps + total) */
> > +	__le64 pinned_icaps;
> > +	__le64 total;
> > +} __packed;
> > +
> > +/* metric opened inodes header */
> > +struct ceph_opened_inodes {
> > +	__le32 type;     /* ceph metric type */
> > +
> > +	__u8  ver;
> > +	__u8  compat;
> > +
> > +	__le32 data_len; /* length of sizeof(opened_inodes + total) */
> > +	__le64 opened_inodes;
> > +	__le64 total;
> > +} __packed;
> > +
> >   struct ceph_metric_head {
> >   	__le32 num;	/* the number of metrics that will be sent */
> >   } __packed;
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

