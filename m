Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A4A4EEA99
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 11:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbiDAJnI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Apr 2022 05:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344694AbiDAJm4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Apr 2022 05:42:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56FD517DB
        for <ceph-devel@vger.kernel.org>; Fri,  1 Apr 2022 02:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F77B6167F
        for <ceph-devel@vger.kernel.org>; Fri,  1 Apr 2022 09:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFE6C2BBE4;
        Fri,  1 Apr 2022 09:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648806065;
        bh=nzzSJbs0AJVGlJAyewX3fdTI5GYLm1fhQc1OM5WVzt4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c6NPVqxK9CrP3pZ391ZeCc4p0+Zlzz1jkv7usx7h1JtMbtS7Ahfk6owYIfE0kuucz
         J0qsXfZ7187VehfTxbGcUauTwzGzaw4aTHrg3r5T2wWx6DX2z7EwQhrQ8YqrgaPKcj
         G39WEtv3OKsnjUOYSAx6DPXspMEkWa2R06N9quhGegLX6Pe1fq1RC3Hsa54z95F/nV
         zd9PnW2lSla5UEQ+BZfLDDoq81sokgweDwYq5ptZwXq9ueQ+erIswDOaQwdQ424OJh
         GPqW0sjuJWzrUUzUPVI4UCYdZaWkl+8WiUEluOs6xz32fNcZCHfPqBNKDTWPeoMU0U
         +n/23PB4DANlg==
Message-ID: <8930cbb4a6c5a9858a9e215d6103af293eef192b.camel@kernel.org>
Subject: Re: [PATCH 2/3] ceph: only send the metrices supported by the MDS
 for old cephs
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 01 Apr 2022 05:41:03 -0400
In-Reply-To: <47218d30-4f8b-d31d-d18a-a1d2b8192bb4@redhat.com>
References: <20220331065241.27370-1-xiubli@redhat.com>
         <20220331065241.27370-3-xiubli@redhat.com>
         <756cb0c834b8cc4005291132066d411f35d88274.camel@kernel.org>
         <47218d30-4f8b-d31d-d18a-a1d2b8192bb4@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-04-01 at 09:18 +0800, Xiubo Li wrote:
> On 3/31/22 8:11 PM, Jeff Layton wrote:
> > On Thu, 2022-03-31 at 14:52 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > For some old ceph versions when receives unknown metrics it will
> > > abort the MDS daemons. This will only send the metrics which are
> > > supported by MDSes.
> > > 
> > > Defautly the MDS won't fill the s_metrics in the MClientSession
> > > reply message, so with this patch will only force sending the
> > > metrics to MDS since Quincy version, which is safe to receive
> > > unknown metrics.
> > > 
> > > Next we will add one module option to force enable sending the
> > > metrics if users think that is safe.
> > > 
> > 
> > Is this really a problem we need to work around in the client?
> > 
> > This is an MDS bug and the patches to fix that abort are being
> > backported (or already have been). I think we shouldn't do this at all
> > and instead insist that this be fixed in the MDS.
> 
> Yes, though we have fixed that early in MDS there still have some use 
> cases which haven't backported yet.
> 
> Such as in the tracker#54411 we hit when upgrading from old ceph to new 
> ones when the new client will reconnect to the old ceph during the 
> upgrading, the mgr has two client instances which will reconnect to the 
> old ceph, and we cannot disable sending the metrics through the options, 
> because the mgr won't load them from ceph.conf for some reasons on purpose.
> 
> I am afraid there will have similar issue or strange use cases we 
> couldn't figure out like the tracker#54411. Such as when upgrading if 
> the kclients are upgraded first or a little early than ceph ?
> 
> Last week one guy pinged about the similar issue in Wechat in their own 
> upgrading test case they hit the metric crash.
> 
> As a workaround it's always better to crash the MDSes ?
> 

We already have a kernel module option that disables sending metrics if
it's enabled. Why not just use that to disable metrics when dealing with
these problematic MDS versions that apparently can't be fixed?

Adding all of this complexity to avoid sending something to the MDS
because it might fall over really just seems like we're fixing this in
the wrong place.

If we were to take this, at what point can we drop this workaround? We
really don't want to carry this in perpetuity.

> > > URL: https://tracker.ceph.com/issues/54411
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/mds_client.c |  19 +++-
> > >   fs/ceph/mds_client.h |   1 +
> > >   fs/ceph/metric.c     | 206 ++++++++++++++++++++++++-------------------
> > >   3 files changed, 131 insertions(+), 95 deletions(-)
> > > 
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index f476c65fb985..65980ce97620 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -3422,7 +3422,7 @@ static void handle_session(struct ceph_mds_session *session,
> > >   	void *end = p + msg->front.iov_len;
> > >   	struct ceph_mds_session_head *h;
> > >   	u32 op;
> > > -	u64 seq, features = 0;
> > > +	u64 seq, features = 0, metrics = 0;
> > >   	int wake = 0;
> > >   	bool blocklisted = false;
> > >   
> > > @@ -3452,11 +3452,21 @@ static void handle_session(struct ceph_mds_session *session,
> > >   		}
> > >   	}
> > >   
> > > +	/* version >= 4, metric bits */
> > > +	if (msg_version >= 4) {
> > > +		u32 len;
> > > +		/* struct_v, struct_compat, and len */
> > > +		ceph_decode_skip_n(&p, end, 2 + sizeof(u32), bad);
> > > +		ceph_decode_32_safe(&p, end, len, bad);
> > > +		if (len) {
> > > +			ceph_decode_64_safe(&p, end, metrics, bad);
> > > +			p += len - sizeof(metrics);
> > > +		}
> > > +	}
> > > +
> > > +	/* version >= 5, flags   */
> > >   	if (msg_version >= 5) {
> > >   		u32 flags;
> > > -		/* version >= 4, struct_v, struct_cv, len, metric_spec */
> > > -	        ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 2, bad);
> > > -		/* version >= 5, flags   */
> > >                   ceph_decode_32_safe(&p, end, flags, bad);
> > >   		if (flags & CEPH_SESSION_BLOCKLISTED) {
> > >   		        pr_warn("mds%d session blocklisted\n", session->s_mds);
> > > @@ -3490,6 +3500,7 @@ static void handle_session(struct ceph_mds_session *session,
> > >   			pr_info("mds%d reconnect success\n", session->s_mds);
> > >   		session->s_state = CEPH_MDS_SESSION_OPEN;
> > >   		session->s_features = features;
> > > +		session->s_metrics = metrics;
> > >   		renewed_caps(mdsc, session, 0);
> > >   		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features))
> > >   			metric_schedule_delayed(&mdsc->metric);
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index 32107c26f50d..0f2061f5388d 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -188,6 +188,7 @@ struct ceph_mds_session {
> > >   	int               s_state;
> > >   	unsigned long     s_ttl;      /* time until mds kills us */
> > >   	unsigned long	  s_features;
> > > +	unsigned long	  s_metrics;
> > >   	u64               s_seq;      /* incoming msg seq # */
> > >   	struct mutex      s_mutex;    /* serialize session messages */
> > >   
> > > diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> > > index c47347d2e84e..f01c1f4e6b89 100644
> > > --- a/fs/ceph/metric.c
> > > +++ b/fs/ceph/metric.c
> > > @@ -31,6 +31,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> > >   	struct ceph_client_metric *m = &mdsc->metric;
> > >   	u64 nr_caps = atomic64_read(&m->total_caps);
> > >   	u32 header_len = sizeof(struct ceph_metric_header);
> > > +	bool force = test_bit(CEPHFS_FEATURE_QUINCY, &s->s_features);
> > I don't necessarily have a problem with adding extra CEPHFS_FEATURE_*
> > enum values for different releases, as they're nice for documentation
> > purposes. In the actual client code however, we should ensure that we
> > only test for the _actual_ feature flag, and not the one corresponding
> > to a particular release.
> 
> Yeah, sounds good.
> 
> -- Xiubo
> 
> > 
> > >   	struct ceph_msg *msg;
> > >   	s64 sum;
> > >   	s32 items = 0;
> > > @@ -51,117 +52,140 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> > >   	head = msg->front.iov_base;
> > >   
> > >   	/* encode the cap metric */
> > > -	cap = (struct ceph_metric_cap *)(head + 1);
> > > -	cap->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
> > > -	cap->header.ver = 1;
> > > -	cap->header.compat = 1;
> > > -	cap->header.data_len = cpu_to_le32(sizeof(*cap) - header_len);
> > > -	cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
> > > -	cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
> > > -	cap->total = cpu_to_le64(nr_caps);
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_CAP_INFO, &s->s_metrics)) {
> > > +		cap = (struct ceph_metric_cap *)(head + 1);
> > > +		cap->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
> > > +		cap->header.ver = 1;
> > > +		cap->header.compat = 1;
> > > +		cap->header.data_len = cpu_to_le32(sizeof(*cap) - header_len);
> > > +		cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
> > > +		cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
> > > +		cap->total = cpu_to_le64(nr_caps);
> > > +		items++;
> > > +	}
> > >   
> > >   	/* encode the read latency metric */
> > > -	read = (struct ceph_metric_read_latency *)(cap + 1);
> > > -	read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
> > > -	read->header.ver = 2;
> > > -	read->header.compat = 1;
> > > -	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
> > > -	sum = m->metric[METRIC_READ].latency_sum;
> > > -	ktime_to_ceph_timespec(&read->lat, sum);
> > > -	ktime_to_ceph_timespec(&read->avg, m->metric[METRIC_READ].latency_avg);
> > > -	read->sq_sum = cpu_to_le64(m->metric[METRIC_READ].latency_sq_sum);
> > > -	read->count = cpu_to_le64(m->metric[METRIC_READ].total);
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_READ_LATENCY, &s->s_metrics)) {
> > > +		read = (struct ceph_metric_read_latency *)(cap + 1);
> > > +		read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
> > > +		read->header.ver = 2;
> > > +		read->header.compat = 1;
> > > +		read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
> > > +		sum = m->metric[METRIC_READ].latency_sum;
> > > +		ktime_to_ceph_timespec(&read->lat, sum);
> > > +		ktime_to_ceph_timespec(&read->avg, m->metric[METRIC_READ].latency_avg);
> > > +		read->sq_sum = cpu_to_le64(m->metric[METRIC_READ].latency_sq_sum);
> > > +		read->count = cpu_to_le64(m->metric[METRIC_READ].total);
> > > +		items++;
> > > +	}
> > >   
> > >   	/* encode the write latency metric */
> > > -	write = (struct ceph_metric_write_latency *)(read + 1);
> > > -	write->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
> > > -	write->header.ver = 2;
> > > -	write->header.compat = 1;
> > > -	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
> > > -	sum = m->metric[METRIC_WRITE].latency_sum;
> > > -	ktime_to_ceph_timespec(&write->lat, sum);
> > > -	ktime_to_ceph_timespec(&write->avg, m->metric[METRIC_WRITE].latency_avg);
> > > -	write->sq_sum = cpu_to_le64(m->metric[METRIC_WRITE].latency_sq_sum);
> > > -	write->count = cpu_to_le64(m->metric[METRIC_WRITE].total);
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_WRITE_LATENCY, &s->s_metrics)) {
> > > +		write = (struct ceph_metric_write_latency *)(read + 1);
> > > +		write->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
> > > +		write->header.ver = 2;
> > > +		write->header.compat = 1;
> > > +		write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
> > > +		sum = m->metric[METRIC_WRITE].latency_sum;
> > > +		ktime_to_ceph_timespec(&write->lat, sum);
> > > +		ktime_to_ceph_timespec(&write->avg, m->metric[METRIC_WRITE].latency_avg);
> > > +		write->sq_sum = cpu_to_le64(m->metric[METRIC_WRITE].latency_sq_sum);
> > > +		write->count = cpu_to_le64(m->metric[METRIC_WRITE].total);
> > > +		items++;
> > > +	}
> > >   
> > >   	/* encode the metadata latency metric */
> > > -	meta = (struct ceph_metric_metadata_latency *)(write + 1);
> > > -	meta->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
> > > -	meta->header.ver = 2;
> > > -	meta->header.compat = 1;
> > > -	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
> > > -	sum = m->metric[METRIC_METADATA].latency_sum;
> > > -	ktime_to_ceph_timespec(&meta->lat, sum);
> > > -	ktime_to_ceph_timespec(&meta->avg, m->metric[METRIC_METADATA].latency_avg);
> > > -	meta->sq_sum = cpu_to_le64(m->metric[METRIC_METADATA].latency_sq_sum);
> > > -	meta->count = cpu_to_le64(m->metric[METRIC_METADATA].total);
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_METADATA_LATENCY, &s->s_metrics)) {
> > > +		meta = (struct ceph_metric_metadata_latency *)(write + 1);
> > > +		meta->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
> > > +		meta->header.ver = 2;
> > > +		meta->header.compat = 1;
> > > +		meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
> > > +		sum = m->metric[METRIC_METADATA].latency_sum;
> > > +		ktime_to_ceph_timespec(&meta->lat, sum);
> > > +		ktime_to_ceph_timespec(&meta->avg, m->metric[METRIC_METADATA].latency_avg);
> > > +		meta->sq_sum = cpu_to_le64(m->metric[METRIC_METADATA].latency_sq_sum);
> > > +		meta->count = cpu_to_le64(m->metric[METRIC_METADATA].total);
> > > +		items++;
> > > +	}
> > >   
> > >   	/* encode the dentry lease metric */
> > > -	dlease = (struct ceph_metric_dlease *)(meta + 1);
> > > -	dlease->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
> > > -	dlease->header.ver = 1;
> > > -	dlease->header.compat = 1;
> > > -	dlease->header.data_len = cpu_to_le32(sizeof(*dlease) - header_len);
> > > -	dlease->hit = cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
> > > -	dlease->mis = cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
> > > -	dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_DENTRY_LEASE, &s->s_metrics)) {
> > > +		dlease = (struct ceph_metric_dlease *)(meta + 1);
> > > +		dlease->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
> > > +		dlease->header.ver = 1;
> > > +		dlease->header.compat = 1;
> > > +		dlease->header.data_len = cpu_to_le32(sizeof(*dlease) - header_len);
> > > +		dlease->hit = cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
> > > +		dlease->mis = cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
> > > +		dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
> > > +		items++;
> > > +	}
> > >   
> > >   	sum = percpu_counter_sum(&m->total_inodes);
> > >   
> > >   	/* encode the opened files metric */
> > > -	files = (struct ceph_opened_files *)(dlease + 1);
> > > -	files->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
> > > -	files->header.ver = 1;
> > > -	files->header.compat = 1;
> > > -	files->header.data_len = cpu_to_le32(sizeof(*files) - header_len);
> > > -	files->opened_files = cpu_to_le64(atomic64_read(&m->opened_files));
> > > -	files->total = cpu_to_le64(sum);
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_OPENED_FILES, &s->s_metrics)) {
> > > +		files = (struct ceph_opened_files *)(dlease + 1);
> > > +		files->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
> > > +		files->header.ver = 1;
> > > +		files->header.compat = 1;
> > > +		files->header.data_len = cpu_to_le32(sizeof(*files) - header_len);
> > > +		files->opened_files = cpu_to_le64(atomic64_read(&m->opened_files));
> > > +		files->total = cpu_to_le64(sum);
> > > +		items++;
> > > +	}
> > >   
> > >   	/* encode the pinned icaps metric */
> > > -	icaps = (struct ceph_pinned_icaps *)(files + 1);
> > > -	icaps->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
> > > -	icaps->header.ver = 1;
> > > -	icaps->header.compat = 1;
> > > -	icaps->header.data_len = cpu_to_le32(sizeof(*icaps) - header_len);
> > > -	icaps->pinned_icaps = cpu_to_le64(nr_caps);
> > > -	icaps->total = cpu_to_le64(sum);
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_PINNED_ICAPS, &s->s_metrics)) {
> > > +		icaps = (struct ceph_pinned_icaps *)(files + 1);
> > > +		icaps->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
> > > +		icaps->header.ver = 1;
> > > +		icaps->header.compat = 1;
> > > +		icaps->header.data_len = cpu_to_le32(sizeof(*icaps) - header_len);
> > > +		icaps->pinned_icaps = cpu_to_le64(nr_caps);
> > > +		icaps->total = cpu_to_le64(sum);
> > > +		items++;
> > > +	}
> > >   
> > >   	/* encode the opened inodes metric */
> > > -	inodes = (struct ceph_opened_inodes *)(icaps + 1);
> > > -	inodes->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
> > > -	inodes->header.ver = 1;
> > > -	inodes->header.compat = 1;
> > > -	inodes->header.data_len = cpu_to_le32(sizeof(*inodes) - header_len);
> > > -	inodes->opened_inodes = cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
> > > -	inodes->total = cpu_to_le64(sum);
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_OPENED_INODES, &s->s_metrics)) {
> > > +		inodes = (struct ceph_opened_inodes *)(icaps + 1);
> > > +		inodes->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
> > > +		inodes->header.ver = 1;
> > > +		inodes->header.compat = 1;
> > > +		inodes->header.data_len = cpu_to_le32(sizeof(*inodes) - header_len);
> > > +		inodes->opened_inodes = cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
> > > +		inodes->total = cpu_to_le64(sum);
> > > +		items++;
> > > +	}
> > >   
> > >   	/* encode the read io size metric */
> > > -	rsize = (struct ceph_read_io_size *)(inodes + 1);
> > > -	rsize->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_IO_SIZES);
> > > -	rsize->header.ver = 1;
> > > -	rsize->header.compat = 1;
> > > -	rsize->header.data_len = cpu_to_le32(sizeof(*rsize) - header_len);
> > > -	rsize->total_ops = cpu_to_le64(m->metric[METRIC_READ].total);
> > > -	rsize->total_size = cpu_to_le64(m->metric[METRIC_READ].size_sum);
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_READ_IO_SIZES, &s->s_metrics)) {
> > > +		rsize = (struct ceph_read_io_size *)(inodes + 1);
> > > +		rsize->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_IO_SIZES);
> > > +		rsize->header.ver = 1;
> > > +		rsize->header.compat = 1;
> > > +		rsize->header.data_len = cpu_to_le32(sizeof(*rsize) - header_len);
> > > +		rsize->total_ops = cpu_to_le64(m->metric[METRIC_READ].total);
> > > +		rsize->total_size = cpu_to_le64(m->metric[METRIC_READ].size_sum);
> > > +		items++;
> > > +	}
> > >   
> > >   	/* encode the write io size metric */
> > > -	wsize = (struct ceph_write_io_size *)(rsize + 1);
> > > -	wsize->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_IO_SIZES);
> > > -	wsize->header.ver = 1;
> > > -	wsize->header.compat = 1;
> > > -	wsize->header.data_len = cpu_to_le32(sizeof(*wsize) - header_len);
> > > -	wsize->total_ops = cpu_to_le64(m->metric[METRIC_WRITE].total);
> > > -	wsize->total_size = cpu_to_le64(m->metric[METRIC_WRITE].size_sum);
> > > -	items++;
> > > +	if (force || test_bit(CLIENT_METRIC_TYPE_WRITE_IO_SIZES, &s->s_metrics)) {
> > > +		wsize = (struct ceph_write_io_size *)(rsize + 1);
> > > +		wsize->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_IO_SIZES);
> > > +		wsize->header.ver = 1;
> > > +		wsize->header.compat = 1;
> > > +		wsize->header.data_len = cpu_to_le32(sizeof(*wsize) - header_len);
> > > +		wsize->total_ops = cpu_to_le64(m->metric[METRIC_WRITE].total);
> > > +		wsize->total_size = cpu_to_le64(m->metric[METRIC_WRITE].size_sum);
> > > +		items++;
> > > +	}
> > > +
> > > +	if (!items)
> > > +		return true;
> > >   
> > >   	put_unaligned_le32(items, &head->num);
> > >   	msg->front.iov_len = len;
> 

-- 
Jeff Layton <jlayton@kernel.org>
