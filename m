Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DA5414EE0
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Sep 2021 19:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhIVRMt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Sep 2021 13:12:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31365 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236698AbhIVRMt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 13:12:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632330678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7y1ggRCgahOcI6Q9pWVUY6wWSC2ibpaKf2GmuAArndA=;
        b=Ee4/IYjJ7+R2mDKeUpl1AzkVf+3B4S3owq62GhxWtSOjxIhqGkIvsJt0WJLR7ZKgssoVBY
        y6nI9kHQQ1/7tjktGC0GKqIF9IRs/5kBpqMbMWXsrIArZyjBcM5YUg/1gOGn7/ifgGz2Z/
        8pecOOkf1sP5cYmJ9N0lEYXBi3FSpxM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-sEtBlB9rPeGVnj4JtqJYdw-1; Wed, 22 Sep 2021 13:11:15 -0400
X-MC-Unique: sEtBlB9rPeGVnj4JtqJYdw-1
Received: by mail-lf1-f72.google.com with SMTP id bp11-20020a056512158b00b003fc7d722819so3472561lfb.7
        for <ceph-devel@vger.kernel.org>; Wed, 22 Sep 2021 10:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7y1ggRCgahOcI6Q9pWVUY6wWSC2ibpaKf2GmuAArndA=;
        b=V/l490oW+CF+FdXp0ZeP9mTa0sGG8p8nUKJtbr/HRtN5bOHkXFQLXZG6WzM6Emutws
         Z/k9Sz46pGodcKAvH32rafMIOkFqO9TZVmk3vfky1C1SXP9cIotGs126u2LX6NEvvmJN
         QT7OG+0yUvJs9AkstYvZxOWXvk3LyuHxRct0dYOMFRzw3+5zGjDkYSnAR1bnap/BHVkB
         cUzs2KvjEEFZK939GG7MsQhj7SMuVAva5K1FS4XRS4KNBYjf6ZmxwPJ4B0TP0tcc0ol2
         NbRx4Nsrjcza+byF2+fLx4qOGUc9/CF0WxGouvfyNA8sDt8Jxzl2igTh/HhhwbPH6ZVS
         6jwQ==
X-Gm-Message-State: AOAM532INfXUrvYl7+P3izwmza3JtNhaqUyyZMBHeqqJKuhXlDTGGZ7n
        OgA+q1kjfOkEaKOBkk5Mdrw/BgYIsdO8gv0HDDLwmm5JbmAD9nL69t6m0OIepbTvBcXpsyER453
        df1gH0W47DG5zm4LWd5ABks8496WbolLhiBtDsw==
X-Received: by 2002:a05:6512:3191:: with SMTP id i17mr64920lfe.381.1632330673719;
        Wed, 22 Sep 2021 10:11:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqzTCx2SDjhLmsq/MBIK74ZV1GaiUwp9mBwj6jQrwoo00/miK/ZOPS/bVBD6YU328vccJSVIClZ48f2fg1MmU=
X-Received: by 2002:a05:6512:3191:: with SMTP id i17mr64896lfe.381.1632330673427;
 Wed, 22 Sep 2021 10:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210921130750.31820-1-vshankar@redhat.com> <20210921130750.31820-3-vshankar@redhat.com>
 <495168ef5d8e3b18f85048a2d61e988ba44a6228.camel@redhat.com>
 <CACPzV1mA45ByOwdcBQXH0ugq50wzTMuK=WXiP--UG5_mam2ztw@mail.gmail.com>
 <CACPzV1=avKH1TA7EJMRe_ivXxzMWn4ZaVMQVb3Nf6ZbdBa10-A@mail.gmail.com> <ba1d57df-f977-4319-a857-c629ea47a818@redhat.com>
In-Reply-To: <ba1d57df-f977-4319-a857-c629ea47a818@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 22 Sep 2021 22:40:36 +0530
Message-ID: <CACPzV1kBMyM_ME_+btupKF5v+z1VS+kCzbG=0jkJh6j=Lk9GTg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ceph: track average/stdev r/w/m latency
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 22, 2021 at 8:04 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 9/22/21 9:44 PM, Venky Shankar wrote:
> > On Wed, Sep 22, 2021 at 6:03 PM Venky Shankar <vshankar@redhat.com> wrote:
> >> On Wed, Sep 22, 2021 at 5:47 PM Jeff Layton <jlayton@redhat.com> wrote:
> >>> On Tue, 2021-09-21 at 18:37 +0530, Venky Shankar wrote:
> >>>> Update the math involved to closely mimic how its done in
> >>>> user land. This does not make a lot of difference to the
> >>>> execution speed.
> >>>>
> >>>> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> >>>> ---
> >>>>   fs/ceph/metric.c | 63 +++++++++++++++++++++---------------------------
> >>>>   fs/ceph/metric.h |  3 +++
> >>>>   2 files changed, 31 insertions(+), 35 deletions(-)
> >>>>
> >>>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> >>>> index 226dc38e2909..ca758bff69ca 100644
> >>>> --- a/fs/ceph/metric.c
> >>>> +++ b/fs/ceph/metric.c
> >>>> @@ -245,6 +245,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
> >>>>
> >>>>        spin_lock_init(&m->read_metric_lock);
> >>>>        m->read_latency_sq_sum = 0;
> >>>> +     m->avg_read_latency = 0;
> >>>>        m->read_latency_min = KTIME_MAX;
> >>>>        m->read_latency_max = 0;
> >>>>        m->total_reads = 0;
> >>>> @@ -255,6 +256,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
> >>>>
> >>>>        spin_lock_init(&m->write_metric_lock);
> >>>>        m->write_latency_sq_sum = 0;
> >>>> +     m->avg_write_latency = 0;
> >>>>        m->write_latency_min = KTIME_MAX;
> >>>>        m->write_latency_max = 0;
> >>>>        m->total_writes = 0;
> >>>> @@ -265,6 +267,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
> >>>>
> >>>>        spin_lock_init(&m->metadata_metric_lock);
> >>>>        m->metadata_latency_sq_sum = 0;
> >>>> +     m->avg_metadata_latency = 0;
> >>>>        m->metadata_latency_min = KTIME_MAX;
> >>>>        m->metadata_latency_max = 0;
> >>>>        m->total_metadatas = 0;
> >>>> @@ -322,20 +325,25 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
> >>>>                max = new;                      \
> >>>>   }
> >>>>
> >>>> -static inline void __update_stdev(ktime_t total, ktime_t lsum,
> >>>> -                               ktime_t *sq_sump, ktime_t lat)
> >>>> +static inline void __update_latency(ktime_t *ctotal, ktime_t *lsum,
> >>>> +                                 ktime_t *lavg, ktime_t *min, ktime_t *max,
> >>>> +                                 ktime_t *sum_sq, ktime_t lat)
> >>>>   {
> >>>> -     ktime_t avg, sq;
> >>>> +     ktime_t total, avg;
> >>>>
> >>>> -     if (unlikely(total == 1))
> >>>> -             return;
> >>>> +     total = ++(*ctotal);
> >>>> +     *lsum += lat;
> >>>> +
> >>>> +     METRIC_UPDATE_MIN_MAX(*min, *max, lat);
> >>>>
> >>>> -     /* the sq is (lat - old_avg) * (lat - new_avg) */
> >>>> -     avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
> >>>> -     sq = lat - avg;
> >>>> -     avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
> >>>> -     sq = sq * (lat - avg);
> >>>> -     *sq_sump += sq;
> >>>> +     if (unlikely(total == 1)) {
> >>>> +             *lavg = lat;
> >>>> +             *sum_sq = 0;
> >>>> +     } else {
> >>>> +             avg = *lavg + div64_s64(lat - *lavg, total);
> >>>> +             *sum_sq += (lat - *lavg)*(lat - avg);
> >>>> +             *lavg = avg;
> >>>> +     }
> >>>>   }
> >>>>
> >>>>   void ceph_update_read_metrics(struct ceph_client_metric *m,
> >>>> @@ -343,23 +351,18 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
> >>>>                              unsigned int size, int rc)
> >>>>   {
> >>>>        ktime_t lat = ktime_sub(r_end, r_start);
> >>>> -     ktime_t total;
> >>>>
> >>>>        if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
> >>>>                return;
> >>>>
> >>>>        spin_lock(&m->read_metric_lock);
> >>>> -     total = ++m->total_reads;
> >>>>        m->read_size_sum += size;
> >>>> -     m->read_latency_sum += lat;
> >>>>        METRIC_UPDATE_MIN_MAX(m->read_size_min,
> >>>>                              m->read_size_max,
> >>>>                              size);
> >>>> -     METRIC_UPDATE_MIN_MAX(m->read_latency_min,
> >>>> -                           m->read_latency_max,
> >>>> -                           lat);
> >>>> -     __update_stdev(total, m->read_latency_sum,
> >>>> -                    &m->read_latency_sq_sum, lat);
> >>>> +     __update_latency(&m->total_reads, &m->read_latency_sum,
> >>>> +                      &m->avg_read_latency, &m->read_latency_min,
> >>>> +                      &m->read_latency_max, &m->read_latency_sq_sum, lat);
> >>> Do we really need to calculate the std deviation on every update? We
> >>> have to figure that in most cases, this stuff will be collected but only
> >>> seldom viewed.
> >>>
> >>> ISTM that we ought to collect just the bare minimum of info on each
> >>> update, and save the more expensive calculations for the tool presenting
> >>> this info.
> >> Yeh, that's probably the plan we want going forward when introducing
> >> new metrics.
> >>
> >> FWIW, we could start doing it with this itself. It's just that the
> >> user land PRs are approved and those do the way it is done here.
> >>
> >> I'm ok with moving math crunching to the tool and it should not be a
> >> major change to this patchset.
> > So, I kind of recall why we did it this way -- metrics exchange
> > between MDS and ceph-mgr is restricted to std::pair<uint64_t,
> > uint64_t>.
>
> Before I pushed one patch to improve this and switched it to a list or
> something else, but revert it dues to some reason.

Right. I do not recall the issue, but I think it's worth making it
customizable for future use-cases.

>
>
> > That would probably need to be expanded to carry variable
> > sized objects. I remember seeing a PR that does something like that.
> > Need to dig it up...
> >
> > The other way would be to exchange the necessary information needed
> > for the calculation as a separate types but that's not really clean
> > and results in unnecessary bloating.
> >
> >>>>        spin_unlock(&m->read_metric_lock);
> >>>>   }
> >>>>
> >>>> @@ -368,23 +371,18 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
> >>>>                               unsigned int size, int rc)
> >>>>   {
> >>>>        ktime_t lat = ktime_sub(r_end, r_start);
> >>>> -     ktime_t total;
> >>>>
> >>>>        if (unlikely(rc && rc != -ETIMEDOUT))
> >>>>                return;
> >>>>
> >>>>        spin_lock(&m->write_metric_lock);
> >>>> -     total = ++m->total_writes;
> >>>>        m->write_size_sum += size;
> >>>> -     m->write_latency_sum += lat;
> >>>>        METRIC_UPDATE_MIN_MAX(m->write_size_min,
> >>>>                              m->write_size_max,
> >>>>                              size);
> >>>> -     METRIC_UPDATE_MIN_MAX(m->write_latency_min,
> >>>> -                           m->write_latency_max,
> >>>> -                           lat);
> >>>> -     __update_stdev(total, m->write_latency_sum,
> >>>> -                    &m->write_latency_sq_sum, lat);
> >>>> +     __update_latency(&m->total_writes, &m->write_latency_sum,
> >>>> +                      &m->avg_write_latency, &m->write_latency_min,
> >>>> +                      &m->write_latency_max, &m->write_latency_sq_sum, lat);
> >>>>        spin_unlock(&m->write_metric_lock);
> >>>>   }
> >>>>
> >>>> @@ -393,18 +391,13 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
> >>>>                                  int rc)
> >>>>   {
> >>>>        ktime_t lat = ktime_sub(r_end, r_start);
> >>>> -     ktime_t total;
> >>>>
> >>>>        if (unlikely(rc && rc != -ENOENT))
> >>>>                return;
> >>>>
> >>>>        spin_lock(&m->metadata_metric_lock);
> >>>> -     total = ++m->total_metadatas;
> >>>> -     m->metadata_latency_sum += lat;
> >>>> -     METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
> >>>> -                           m->metadata_latency_max,
> >>>> -                           lat);
> >>>> -     __update_stdev(total, m->metadata_latency_sum,
> >>>> -                    &m->metadata_latency_sq_sum, lat);
> >>>> +     __update_latency(&m->total_metadatas, &m->metadata_latency_sum,
> >>>> +                      &m->avg_metadata_latency, &m->metadata_latency_min,
> >>>> +                      &m->metadata_latency_max, &m->metadata_latency_sq_sum, lat);
> >>>>        spin_unlock(&m->metadata_metric_lock);
> >>>>   }
> >>>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> >>>> index 103ed736f9d2..0af02e212033 100644
> >>>> --- a/fs/ceph/metric.h
> >>>> +++ b/fs/ceph/metric.h
> >>>> @@ -138,6 +138,7 @@ struct ceph_client_metric {
> >>>>        u64 read_size_min;
> >>>>        u64 read_size_max;
> >>>>        ktime_t read_latency_sum;
> >>>> +     ktime_t avg_read_latency;
> >>>>        ktime_t read_latency_sq_sum;
> >>>>        ktime_t read_latency_min;
> >>>>        ktime_t read_latency_max;
> >>>> @@ -148,6 +149,7 @@ struct ceph_client_metric {
> >>>>        u64 write_size_min;
> >>>>        u64 write_size_max;
> >>>>        ktime_t write_latency_sum;
> >>>> +     ktime_t avg_write_latency;
> >>>>        ktime_t write_latency_sq_sum;
> >>>>        ktime_t write_latency_min;
> >>>>        ktime_t write_latency_max;
> >>>> @@ -155,6 +157,7 @@ struct ceph_client_metric {
> >>>>        spinlock_t metadata_metric_lock;
> >>>>        u64 total_metadatas;
> >>>>        ktime_t metadata_latency_sum;
> >>>> +     ktime_t avg_metadata_latency;
> >>>>        ktime_t metadata_latency_sq_sum;
> >>>>        ktime_t metadata_latency_min;
> >>>>        ktime_t metadata_latency_max;
> >>> --
> >>> Jeff Layton <jlayton@redhat.com>
> >>>
> >>
> >> --
> >> Cheers,
> >> Venky
> >
> >
>


-- 
Cheers,
Venky

