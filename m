Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CEE4CFFBC
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Mar 2022 14:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbiCGNQc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Mar 2022 08:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbiCGNQc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Mar 2022 08:16:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99B9D8BE17
        for <ceph-devel@vger.kernel.org>; Mon,  7 Mar 2022 05:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646658936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t4s3hybaRu8/ccJd01AmZoy8SN9QzXliHZjMk3zeNIA=;
        b=WUWxIdTUv8RsGc2x7aIQI99UcqgaaQmf4CuV6/VmCaF+EmAYmlaXkBKmNK9MD1wYeIW2E1
        ohxe4HlQ2DITH9kJB9sUSL0g5mvg7KH334vtl/5N9uABpYQ2nVPjN79kHm4mCVbiJs66CW
        fn7kdyW0UuBCUJPjdp5j8uI9sBgWmzQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-u3yiFkGuNlmL2U9JdBYw_g-1; Mon, 07 Mar 2022 08:15:35 -0500
X-MC-Unique: u3yiFkGuNlmL2U9JdBYw_g-1
Received: by mail-lj1-f198.google.com with SMTP id h18-20020a2e3a12000000b00247e2a0e909so2039906lja.7
        for <ceph-devel@vger.kernel.org>; Mon, 07 Mar 2022 05:15:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4s3hybaRu8/ccJd01AmZoy8SN9QzXliHZjMk3zeNIA=;
        b=oEvOXoZQPOvGrDvW+ZpdEJ7X9SuuwRLO4wXIN0pn0NIjA8AEzkJHqAsQ9bs0IeEMN8
         gDkB8B/GjJwOWk25FrGrApso1AV91U2V830UmY7vQclKcER2kO4ldvZBKYnxXIdmD1yo
         wZaFydCuJPqa/jNEJSiS0ldWURpb5EGM4ulxHFuAmXFRNlc+ngcaHolTIzeIHqS+2Eij
         SUkLyAhGWqi8TPw/rZPLkHhH3Q2shXaA95WdU/gyePOJ/8P+IwMeL/RaE6yIaahKk2lH
         1zemjOdwVV88D/YjI9T0s9Y12OYBWUZflL5zjSdRF+VyF84WBEwAnnrRP2y3Pl6HL+bQ
         4SbQ==
X-Gm-Message-State: AOAM531zgY9eLDkIgZtZ6w8d3ZY/gfJDdP8IwaDmlT5pqfG8tVy/+H4m
        sKKjcEor92G8B1EeqCjSxs1BTx5WOYrCJpo3UmgmEC3TBEU+aVteU44dGUWUQ1mczGqYJ2Xhb+H
        D/z1ReQzQt8GiGIued1tN6klskeBmOas1OWN4gg==
X-Received: by 2002:a05:6512:39ce:b0:448:36de:d2ea with SMTP id k14-20020a05651239ce00b0044836ded2eamr936390lfu.499.1646658933537;
        Mon, 07 Mar 2022 05:15:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxccqGvX8gOB7DCM9bq8+40jl1Tukr0NP5KpqmrDyvBRnp5Cx/iSb2ADK1JOxUrXImuPL7oK3LSJBImrKiu8Fg=
X-Received: by 2002:a05:6512:39ce:b0:448:36de:d2ea with SMTP id
 k14-20020a05651239ce00b0044836ded2eamr936371lfu.499.1646658933256; Mon, 07
 Mar 2022 05:15:33 -0800 (PST)
MIME-Version: 1.0
References: <20220307125235.440185-1-vshankar@redhat.com> <CACPzV1kc1pHSDFcRjz0gjyRnYQWhX9GtUap0OYjfLRLcHuvw1w@mail.gmail.com>
 <b7b5b74e4c13833ebf1062c7e3f5ae4b8f3c595f.camel@redhat.com>
In-Reply-To: <b7b5b74e4c13833ebf1062c7e3f5ae4b8f3c595f.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Mon, 7 Mar 2022 18:44:56 +0530
Message-ID: <CACPzV1=dO7T=CW1Ggv8Tro3Pq=_XoREWVJfCfHdSxXF_a5=GTA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Mar 7, 2022 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 2022-03-07 at 18:29 +0530, Venky Shankar wrote:
> > commit 73807b6905efa04cc01cd1223d5cc6ab57170f9e would also need a similar fix.
> >
> > I'll send those...
> >
>
> Ideally, send them as a set, and tell us which patches you want dropped
> from testing before we merge them.

Sure, works for me.

This change can be ignored.

>
> > On Mon, Mar 7, 2022 at 6:22 PM Venky Shankar <vshankar@redhat.com> wrote:
> > >
> > > Latencies are of type ktime_t, coverting from jiffies is incorrect.
> > > Also, switch to "struct ceph_timespec" for r/w/m latencies.
> > >
> > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > ---
> > >
> > > v2:
> > >   - rename to_ceph_timespec() to ktime_to_ceph_timespec()
> > >   - use ceph_encode_timespec64() helper
> > >
> > >  fs/ceph/metric.c | 19 +++++++++----------
> > >  fs/ceph/metric.h | 11 ++++-------
> > >  2 files changed, 13 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> > > index 0fcba68f9a99..454d2c93208e 100644
> > > --- a/fs/ceph/metric.c
> > > +++ b/fs/ceph/metric.c
> > > @@ -8,6 +8,12 @@
> > >  #include "metric.h"
> > >  #include "mds_client.h"
> > >
> > > +static void ktime_to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
> > > +{
> > > +       struct timespec64 t = ktime_to_timespec64(val);
> > > +       ceph_encode_timespec64(ts, &t);
> > > +}
> > > +
> > >  static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> > >                                    struct ceph_mds_session *s)
> > >  {
> > > @@ -26,7 +32,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> > >         u64 nr_caps = atomic64_read(&m->total_caps);
> > >         u32 header_len = sizeof(struct ceph_metric_header);
> > >         struct ceph_msg *msg;
> > > -       struct timespec64 ts;
> > >         s64 sum;
> > >         s32 items = 0;
> > >         s32 len;
> > > @@ -63,9 +68,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> > >         read->header.compat = 1;
> > >         read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
> > >         sum = m->metric[METRIC_READ].latency_sum;
> > > -       jiffies_to_timespec64(sum, &ts);
> > > -       read->sec = cpu_to_le32(ts.tv_sec);
> > > -       read->nsec = cpu_to_le32(ts.tv_nsec);
> > > +       ktime_to_ceph_timespec(&read->lat, sum);
> > >         items++;
> > >
> > >         /* encode the write latency metric */
> > > @@ -75,9 +78,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> > >         write->header.compat = 1;
> > >         write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
> > >         sum = m->metric[METRIC_WRITE].latency_sum;
> > > -       jiffies_to_timespec64(sum, &ts);
> > > -       write->sec = cpu_to_le32(ts.tv_sec);
> > > -       write->nsec = cpu_to_le32(ts.tv_nsec);
> > > +       ktime_to_ceph_timespec(&write->lat, sum);
> > >         items++;
> > >
> > >         /* encode the metadata latency metric */
> > > @@ -87,9 +88,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> > >         meta->header.compat = 1;
> > >         meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
> > >         sum = m->metric[METRIC_METADATA].latency_sum;
> > > -       jiffies_to_timespec64(sum, &ts);
> > > -       meta->sec = cpu_to_le32(ts.tv_sec);
> > > -       meta->nsec = cpu_to_le32(ts.tv_nsec);
> > > +       ktime_to_ceph_timespec(&meta->lat, sum);
> > >         items++;
> > >
> > >         /* encode the dentry lease metric */
> > > diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> > > index bb45608181e7..5b2bb2897056 100644
> > > --- a/fs/ceph/metric.h
> > > +++ b/fs/ceph/metric.h
> > > @@ -2,7 +2,7 @@
> > >  #ifndef _FS_CEPH_MDS_METRIC_H
> > >  #define _FS_CEPH_MDS_METRIC_H
> > >
> > > -#include <linux/types.h>
> > > +#include <linux/ceph/types.h>
> > >  #include <linux/percpu_counter.h>
> > >  #include <linux/ktime.h>
> > >
> > > @@ -60,22 +60,19 @@ struct ceph_metric_cap {
> > >  /* metric read latency header */
> > >  struct ceph_metric_read_latency {
> > >         struct ceph_metric_header header;
> > > -       __le32 sec;
> > > -       __le32 nsec;
> > > +       struct ceph_timespec lat;
> > >  } __packed;
> > >
> > >  /* metric write latency header */
> > >  struct ceph_metric_write_latency {
> > >         struct ceph_metric_header header;
> > > -       __le32 sec;
> > > -       __le32 nsec;
> > > +       struct ceph_timespec lat;
> > >  } __packed;
> > >
> > >  /* metric metadata latency header */
> > >  struct ceph_metric_metadata_latency {
> > >         struct ceph_metric_header header;
> > > -       __le32 sec;
> > > -       __le32 nsec;
> > > +       struct ceph_timespec lat;
> > >  } __packed;
> > >
> > >  /* metric dentry lease header */
> > > --
> > > 2.27.0
> > >
> >
> >
>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

