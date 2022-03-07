Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FF14CFFA7
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Mar 2022 14:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbiCGNKh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Mar 2022 08:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbiCGNKh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Mar 2022 08:10:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A02375BD2F
        for <ceph-devel@vger.kernel.org>; Mon,  7 Mar 2022 05:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646658581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V2O5paFuaBqtJVBaVSmAQnDhCtVmHo9PUZY6YWUPikg=;
        b=UDnuZ0OImW8t+hvkTpgs8IFszxHXT3vcUvRbl0FWaizGdQfKefO3sRhBDrxP0MYfApWK0/
        HwWXuism9W3tKulqXJB6GMF4F/ed8SwF2UPyjzxjqImwIkmmGVUQl/PAMb9d7dEDvlkmQ2
        x+hujHbyne41cFd4CHi/IWpBlg+UeKE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-ZETiZnQIN6W_lI4t0LPqdA-1; Mon, 07 Mar 2022 08:09:40 -0500
X-MC-Unique: ZETiZnQIN6W_lI4t0LPqdA-1
Received: by mail-qk1-f197.google.com with SMTP id a66-20020ae9e845000000b0067b308a9f56so2098114qkg.21
        for <ceph-devel@vger.kernel.org>; Mon, 07 Mar 2022 05:09:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=V2O5paFuaBqtJVBaVSmAQnDhCtVmHo9PUZY6YWUPikg=;
        b=Llvyeca30k0MHod7FYzWJMvP50tptNWDIT4xFVui322X8Y+iAXhcstCfZYNXzjx0V+
         pattBFzpqEi+ZI1FzQY2VOMl0OVwgQiHZZQqV6hvVP/JjNbiJE9o5vMdrQWbTS6Nunoa
         dq3Ynur6PJjRFxVcOcl4lAoLCO1MwcTW2cgABf85lutFgFU/J+ceyj6yV7K0fwomdM2f
         JBUtM/8GY1LXPvahhk7BqoCSgAMb9aQZO0Jwx5mqIH2miLSrhHuVEIboKijLPq+cana4
         L5ZjHSA3LDaP887Cu0l7edmtinGKZaDKlbP2mDtygeJllHNEHwgrbhyNBmwNftDYSDY8
         RtnA==
X-Gm-Message-State: AOAM532YobQjS6T6lBi6LacqvjTWmph9KsfIQ+6XQuvRwEg44ef2LcNR
        LQ8BNMMKA05Ohen8GR0Njf8v5QrOCl7/mqhbc/FrAt1o8bpMvCt6/s1BpJOfUIRjUcxFimHAqGc
        gy/IzgMTehPiFBfJ6uEn5dQ==
X-Received: by 2002:a05:620a:13a7:b0:648:aa98:b0bd with SMTP id m7-20020a05620a13a700b00648aa98b0bdmr6790057qki.660.1646658580058;
        Mon, 07 Mar 2022 05:09:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxjn6zfrID5HuNlTi57ptIbe/NpjG8u5t5YeBzONb6IYelnPE0JVBA6B7Q7Po4xX2tc5yl7ww==
X-Received: by 2002:a05:620a:13a7:b0:648:aa98:b0bd with SMTP id m7-20020a05620a13a700b00648aa98b0bdmr6790037qki.660.1646658579809;
        Mon, 07 Mar 2022 05:09:39 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id h19-20020a05620a245300b0047c5aec8cabsm6449007qkn.123.2022.03.07.05.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 05:09:39 -0800 (PST)
Message-ID: <b7b5b74e4c13833ebf1062c7e3f5ae4b8f3c595f.camel@redhat.com>
Subject: Re: [PATCH v2] ceph: use ktime_to_timespec64() rather than
 jiffies_to_timespec64()
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Date:   Mon, 07 Mar 2022 08:09:38 -0500
In-Reply-To: <CACPzV1kc1pHSDFcRjz0gjyRnYQWhX9GtUap0OYjfLRLcHuvw1w@mail.gmail.com>
References: <20220307125235.440185-1-vshankar@redhat.com>
         <CACPzV1kc1pHSDFcRjz0gjyRnYQWhX9GtUap0OYjfLRLcHuvw1w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-03-07 at 18:29 +0530, Venky Shankar wrote:
> commit 73807b6905efa04cc01cd1223d5cc6ab57170f9e would also need a similar fix.
> 
> I'll send those...
> 

Ideally, send them as a set, and tell us which patches you want dropped
from testing before we merge them.

> On Mon, Mar 7, 2022 at 6:22 PM Venky Shankar <vshankar@redhat.com> wrote:
> > 
> > Latencies are of type ktime_t, coverting from jiffies is incorrect.
> > Also, switch to "struct ceph_timespec" for r/w/m latencies.
> > 
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> > 
> > v2:
> >   - rename to_ceph_timespec() to ktime_to_ceph_timespec()
> >   - use ceph_encode_timespec64() helper
> > 
> >  fs/ceph/metric.c | 19 +++++++++----------
> >  fs/ceph/metric.h | 11 ++++-------
> >  2 files changed, 13 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> > index 0fcba68f9a99..454d2c93208e 100644
> > --- a/fs/ceph/metric.c
> > +++ b/fs/ceph/metric.c
> > @@ -8,6 +8,12 @@
> >  #include "metric.h"
> >  #include "mds_client.h"
> > 
> > +static void ktime_to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
> > +{
> > +       struct timespec64 t = ktime_to_timespec64(val);
> > +       ceph_encode_timespec64(ts, &t);
> > +}
> > +
> >  static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> >                                    struct ceph_mds_session *s)
> >  {
> > @@ -26,7 +32,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> >         u64 nr_caps = atomic64_read(&m->total_caps);
> >         u32 header_len = sizeof(struct ceph_metric_header);
> >         struct ceph_msg *msg;
> > -       struct timespec64 ts;
> >         s64 sum;
> >         s32 items = 0;
> >         s32 len;
> > @@ -63,9 +68,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> >         read->header.compat = 1;
> >         read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
> >         sum = m->metric[METRIC_READ].latency_sum;
> > -       jiffies_to_timespec64(sum, &ts);
> > -       read->sec = cpu_to_le32(ts.tv_sec);
> > -       read->nsec = cpu_to_le32(ts.tv_nsec);
> > +       ktime_to_ceph_timespec(&read->lat, sum);
> >         items++;
> > 
> >         /* encode the write latency metric */
> > @@ -75,9 +78,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> >         write->header.compat = 1;
> >         write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
> >         sum = m->metric[METRIC_WRITE].latency_sum;
> > -       jiffies_to_timespec64(sum, &ts);
> > -       write->sec = cpu_to_le32(ts.tv_sec);
> > -       write->nsec = cpu_to_le32(ts.tv_nsec);
> > +       ktime_to_ceph_timespec(&write->lat, sum);
> >         items++;
> > 
> >         /* encode the metadata latency metric */
> > @@ -87,9 +88,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> >         meta->header.compat = 1;
> >         meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
> >         sum = m->metric[METRIC_METADATA].latency_sum;
> > -       jiffies_to_timespec64(sum, &ts);
> > -       meta->sec = cpu_to_le32(ts.tv_sec);
> > -       meta->nsec = cpu_to_le32(ts.tv_nsec);
> > +       ktime_to_ceph_timespec(&meta->lat, sum);
> >         items++;
> > 
> >         /* encode the dentry lease metric */
> > diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> > index bb45608181e7..5b2bb2897056 100644
> > --- a/fs/ceph/metric.h
> > +++ b/fs/ceph/metric.h
> > @@ -2,7 +2,7 @@
> >  #ifndef _FS_CEPH_MDS_METRIC_H
> >  #define _FS_CEPH_MDS_METRIC_H
> > 
> > -#include <linux/types.h>
> > +#include <linux/ceph/types.h>
> >  #include <linux/percpu_counter.h>
> >  #include <linux/ktime.h>
> > 
> > @@ -60,22 +60,19 @@ struct ceph_metric_cap {
> >  /* metric read latency header */
> >  struct ceph_metric_read_latency {
> >         struct ceph_metric_header header;
> > -       __le32 sec;
> > -       __le32 nsec;
> > +       struct ceph_timespec lat;
> >  } __packed;
> > 
> >  /* metric write latency header */
> >  struct ceph_metric_write_latency {
> >         struct ceph_metric_header header;
> > -       __le32 sec;
> > -       __le32 nsec;
> > +       struct ceph_timespec lat;
> >  } __packed;
> > 
> >  /* metric metadata latency header */
> >  struct ceph_metric_metadata_latency {
> >         struct ceph_metric_header header;
> > -       __le32 sec;
> > -       __le32 nsec;
> > +       struct ceph_timespec lat;
> >  } __packed;
> > 
> >  /* metric dentry lease header */
> > --
> > 2.27.0
> > 
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

