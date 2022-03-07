Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA6E4CFF5B
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Mar 2022 13:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbiCGNAu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Mar 2022 08:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242684AbiCGNAt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Mar 2022 08:00:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D5336C93A
        for <ceph-devel@vger.kernel.org>; Mon,  7 Mar 2022 04:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646657994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ggK//DZw1jKW15d+NGmGp8UMRCEXu03+ByqSUzFfOJ8=;
        b=GjvXfVdzAN3zNOw/weT6JBSshW1QIfiGZwU81CP2nIfCmrAoo4uGzU4uUqP2dkYcZf66M7
        J+gdUsSIjIC81D7pqInIzZAnSIDHDDv0S5qDAjjxWOa9T9StHH05nIcAEiSiGPJnm5sRut
        sNq9fLnGBhYHD1Z+qVvzbMe48wGY8xE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-E340iJxgOTGC5TKDFfWDvw-1; Mon, 07 Mar 2022 07:59:52 -0500
X-MC-Unique: E340iJxgOTGC5TKDFfWDvw-1
Received: by mail-lj1-f197.google.com with SMTP id l16-20020a2e8350000000b00247d76267c2so3432554ljh.12
        for <ceph-devel@vger.kernel.org>; Mon, 07 Mar 2022 04:59:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ggK//DZw1jKW15d+NGmGp8UMRCEXu03+ByqSUzFfOJ8=;
        b=ZfH9EVdGxpeNbnl/NkF9CLC5+D0YpWmHkkq/CZiyE++r7nkVxyBUXdX7EAQqtQsuKF
         7td2xpZ7t8vLXUdwfUikuRH52Nju3pPyLP+Qv379Jo80OXxKFEfv2BUiOPBCLjst86fd
         VgpeOwn2yAK56Ug2De1FZdrslqJtjNYkDbWdye9jntQf+RcNj40cD892ROwMissc4tfO
         ZeYxBZBbsLkwPs3YtWQ9Gkz7nROg8VdEnIWn5WQJw7H5ruHJVZHdAVEi/GM3/Ud+Lc/b
         defZa5BSreaia/WSHqdm/+J5hmSv7QeIA4mdkN2pwdVOLZECwsqtgOWQdkEw+a4BdsKw
         00BA==
X-Gm-Message-State: AOAM533wjOBxSheHg6gKJaF5B8H8qcPCyiUPo/YMWTDPUFvQLIu6Za7D
        O9mwhqO0DqFIHf4CcMmUj/uInDQ2PcUyEZEK6O72HuC5P+lRfBFxFq9N3Ijw3zkfl8yO/mcGWbs
        ScFpaj+i0WS7rJRJHJlrfUPGp6S6BmLtYM+vlPQ==
X-Received: by 2002:a05:651c:227:b0:247:e301:88e8 with SMTP id z7-20020a05651c022700b00247e30188e8mr4098508ljn.310.1646657991362;
        Mon, 07 Mar 2022 04:59:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxmIS88pqUk916mau2SvtM46oT4Y9rMFtoz3JYTy0gTTq4P4PPtuOArq42PWvKNn2Zv0RzcENuu4NnVkgb28U=
X-Received: by 2002:a05:651c:227:b0:247:e301:88e8 with SMTP id
 z7-20020a05651c022700b00247e30188e8mr4098492ljn.310.1646657991153; Mon, 07
 Mar 2022 04:59:51 -0800 (PST)
MIME-Version: 1.0
References: <20220307125235.440185-1-vshankar@redhat.com>
In-Reply-To: <20220307125235.440185-1-vshankar@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Mon, 7 Mar 2022 18:29:14 +0530
Message-ID: <CACPzV1kc1pHSDFcRjz0gjyRnYQWhX9GtUap0OYjfLRLcHuvw1w@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
To:     Jeff Layton <jlayton@redhat.com>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
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

commit 73807b6905efa04cc01cd1223d5cc6ab57170f9e would also need a similar fix.

I'll send those...

On Mon, Mar 7, 2022 at 6:22 PM Venky Shankar <vshankar@redhat.com> wrote:
>
> Latencies are of type ktime_t, coverting from jiffies is incorrect.
> Also, switch to "struct ceph_timespec" for r/w/m latencies.
>
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>
> v2:
>   - rename to_ceph_timespec() to ktime_to_ceph_timespec()
>   - use ceph_encode_timespec64() helper
>
>  fs/ceph/metric.c | 19 +++++++++----------
>  fs/ceph/metric.h | 11 ++++-------
>  2 files changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 0fcba68f9a99..454d2c93208e 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -8,6 +8,12 @@
>  #include "metric.h"
>  #include "mds_client.h"
>
> +static void ktime_to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
> +{
> +       struct timespec64 t = ktime_to_timespec64(val);
> +       ceph_encode_timespec64(ts, &t);
> +}
> +
>  static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>                                    struct ceph_mds_session *s)
>  {
> @@ -26,7 +32,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>         u64 nr_caps = atomic64_read(&m->total_caps);
>         u32 header_len = sizeof(struct ceph_metric_header);
>         struct ceph_msg *msg;
> -       struct timespec64 ts;
>         s64 sum;
>         s32 items = 0;
>         s32 len;
> @@ -63,9 +68,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>         read->header.compat = 1;
>         read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
>         sum = m->metric[METRIC_READ].latency_sum;
> -       jiffies_to_timespec64(sum, &ts);
> -       read->sec = cpu_to_le32(ts.tv_sec);
> -       read->nsec = cpu_to_le32(ts.tv_nsec);
> +       ktime_to_ceph_timespec(&read->lat, sum);
>         items++;
>
>         /* encode the write latency metric */
> @@ -75,9 +78,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>         write->header.compat = 1;
>         write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
>         sum = m->metric[METRIC_WRITE].latency_sum;
> -       jiffies_to_timespec64(sum, &ts);
> -       write->sec = cpu_to_le32(ts.tv_sec);
> -       write->nsec = cpu_to_le32(ts.tv_nsec);
> +       ktime_to_ceph_timespec(&write->lat, sum);
>         items++;
>
>         /* encode the metadata latency metric */
> @@ -87,9 +88,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>         meta->header.compat = 1;
>         meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
>         sum = m->metric[METRIC_METADATA].latency_sum;
> -       jiffies_to_timespec64(sum, &ts);
> -       meta->sec = cpu_to_le32(ts.tv_sec);
> -       meta->nsec = cpu_to_le32(ts.tv_nsec);
> +       ktime_to_ceph_timespec(&meta->lat, sum);
>         items++;
>
>         /* encode the dentry lease metric */
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
>         struct ceph_metric_header header;
> -       __le32 sec;
> -       __le32 nsec;
> +       struct ceph_timespec lat;
>  } __packed;
>
>  /* metric write latency header */
>  struct ceph_metric_write_latency {
>         struct ceph_metric_header header;
> -       __le32 sec;
> -       __le32 nsec;
> +       struct ceph_timespec lat;
>  } __packed;
>
>  /* metric metadata latency header */
>  struct ceph_metric_metadata_latency {
>         struct ceph_metric_header header;
> -       __le32 sec;
> -       __le32 nsec;
> +       struct ceph_timespec lat;
>  } __packed;
>
>  /* metric dentry lease header */
> --
> 2.27.0
>


-- 
Cheers,
Venky

