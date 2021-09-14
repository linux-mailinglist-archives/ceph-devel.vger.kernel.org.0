Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9232140B01D
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 16:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhINOCz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 10:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233338AbhINOCx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 10:02:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631628096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wRxXxniwPVJ8OOU0DXEzb1THmKfl7MOLwn75VIr+DkQ=;
        b=R+XNvUzpP+Xr0v47fNP9e9cy1K0QagNRLUv3t38biePIZw9a6zSyD8POq9LAywMxC2YFqr
        kaqbK9ABi2h8Yh8K4ZdFMKSijzl51yGGRN6INiToovGwinjjIc9aHGF7zGnuvSI46O/a+6
        EVPX/wQTKR1jP7rukbhyTTkCHqQFT7k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-owNz_klzMMaorEEXHAX8Qg-1; Tue, 14 Sep 2021 10:01:34 -0400
X-MC-Unique: owNz_klzMMaorEEXHAX8Qg-1
Received: by mail-ej1-f70.google.com with SMTP id ne21-20020a1709077b95b029057eb61c6fdfso5408812ejc.22
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 07:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wRxXxniwPVJ8OOU0DXEzb1THmKfl7MOLwn75VIr+DkQ=;
        b=eg5B5RPbSNewXr0WLMqtcprCSjiHDltkNp7tcfmhIUmQMQnvpnKyUO0OFw34+y6hAl
         zUhz7fJQqA90gqN7GN23WiV4VLFaJRg5ezInzmqcc+5tBXK79vbn2ZLFj9NfwpGTBh2z
         weZqJtml3UVebIFiskXlWSSkAEP7ESTU40XGeP27qEb1kXzUw2m3pbt+hs/lSjSSUugA
         8PSoJH4/VuA9PFERuh1AmkFWsXjlj9ZTTt9xYgxrk37aAMpy/r8Snlpeit1ZyTRb0qKR
         13gd69nDe51wpM8jBRfPXkDJGlVXO7NFKbK0jjtijb6/qyZvq9nxVNYoNWIO3JlZVHjY
         GX8g==
X-Gm-Message-State: AOAM532gDLClVbSRBLZt5VRi9zHQVMUs57zM/NCQKCQ1RW5V/QGmZWyb
        9Pv5d9ubmAvX/bJjFgAZ2aNrmqBN6xsPCRzXoAZqKMDgIb7/DX8Fkc6y6vq7DmRq8PKD5FXOKTH
        wHhmoZWc30fP7BLEk9Zf62m8rVeb/Wb44Bk+vJA==
X-Received: by 2002:a05:6402:4247:: with SMTP id g7mr19671575edb.287.1631628093100;
        Tue, 14 Sep 2021 07:01:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEKg3DyJuFHiPCu8jZUA8g9lSmIPHMuJ0rRYssHn2FlVIKrZ4hYoY48iMqgcj40s64kMTy40rx98xRdMJheLc=
X-Received: by 2002:a05:6402:4247:: with SMTP id g7mr19671536edb.287.1631628092671;
 Tue, 14 Sep 2021 07:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210914084902.1618064-1-vshankar@redhat.com> <20210914084902.1618064-3-vshankar@redhat.com>
 <15cd06ae-fe96-c376-854d-738d4a2e70bf@redhat.com> <CACPzV1=A4CYvvrkBM1KKMrzYHJFyrMshQ_Qg9F=tXGQdfERK7g@mail.gmail.com>
 <537fc647-249b-d4e8-2139-90cda31b634c@redhat.com> <02fe4258-a0c5-0d79-7331-b61a7266b5fd@redhat.com>
In-Reply-To: <02fe4258-a0c5-0d79-7331-b61a7266b5fd@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Tue, 14 Sep 2021 19:30:55 +0530
Message-ID: <CACPzV1kYU7fknFmiTqns1iHFEOiKhGYCbcjeCq5wdsb7JT81_A@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ceph: track average/stdev r/w/m latency
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 14, 2021 at 7:22 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 9/14/21 9:45 PM, Xiubo Li wrote:
> >
> > On 9/14/21 9:30 PM, Venky Shankar wrote:
> >> On Tue, Sep 14, 2021 at 6:39 PM Xiubo Li <xiubli@redhat.com> wrote:
> >>>
> >>> On 9/14/21 4:49 PM, Venky Shankar wrote:
> [...]
> > In user space this is very easy to do, but not in kernel space,
> > especially there has no float computing.
> >
> As I remembered this is main reason why I was planing to send the raw
> metrics to MDS and let the MDS do the computing.
>
> So if possible why not just send the raw data to MDS and let the MDS to
> do the stdev computing ?

Since metrics are sent each second (I suppose) and there can be N
operations done within that second, what raw data (say for avg/stdev
calculation) would the client send to the MDS?

>
>
> > Currently the kclient is doing the avg computing by:
> >
> > avg(n) = (avg(n-1) + latency(n)) / (n), IMO this should be closer to
> > the real avg(n) = sum(latency(n), latency(n-1), ..., latency(1)) / n.
> >
> > Because it's hard to record all the latency values, this is also many
> > other user space tools doing to count the avg.
> >
> >
> >>> Though current stdev computing method is not exactly the same the math
> >>> formula does, but it's closer to it, because the kernel couldn't record
> >>> all the latency value and do it whenever needed, which will occupy a
> >>> large amount of memories and cpu resources.
> >> The approach is to calculate the running variance, I.e., compute the
> >> variance as  data (latency) arrive one at a time.
> >>
> >>>
> >>>>    }
> >>>>
> >>>>    void ceph_update_read_metrics(struct ceph_client_metric *m,
> >>>> @@ -343,23 +352,18 @@ void ceph_update_read_metrics(struct
> >>>> ceph_client_metric *m,
> >>>>                              unsigned int size, int rc)
> >>>>    {
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
> >>>> +                      &m->read_latency_max,
> >>>> &m->read_latency_stdev, lat);
> >>>>        spin_unlock(&m->read_metric_lock);
> >>>>    }
> >>>>
> >>>> @@ -368,23 +372,18 @@ void ceph_update_write_metrics(struct
> >>>> ceph_client_metric *m,
> >>>>                               unsigned int size, int rc)
> >>>>    {
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
> >>>> +                      &m->write_latency_max,
> >>>> &m->write_latency_stdev, lat);
> >>>>        spin_unlock(&m->write_metric_lock);
> >>>>    }
> >>>>
> >>>> @@ -393,18 +392,13 @@ void ceph_update_metadata_metrics(struct
> >>>> ceph_client_metric *m,
> >>>>                                  int rc)
> >>>>    {
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
> >>>> +                      &m->avg_metadata_latency,
> >>>> &m->metadata_latency_min,
> >>>> +                      &m->metadata_latency_max,
> >>>> &m->metadata_latency_stdev, lat);
> >>>>        spin_unlock(&m->metadata_metric_lock);
> >>>>    }
> >>>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> >>>> index 103ed736f9d2..a5da21b8f8ed 100644
> >>>> --- a/fs/ceph/metric.h
> >>>> +++ b/fs/ceph/metric.h
> >>>> @@ -138,7 +138,8 @@ struct ceph_client_metric {
> >>>>        u64 read_size_min;
> >>>>        u64 read_size_max;
> >>>>        ktime_t read_latency_sum;
> >>>> -     ktime_t read_latency_sq_sum;
> >>>> +     ktime_t avg_read_latency;
> >>>> +     ktime_t read_latency_stdev;
> >>>>        ktime_t read_latency_min;
> >>>>        ktime_t read_latency_max;
> >>>>
> >>>> @@ -148,14 +149,16 @@ struct ceph_client_metric {
> >>>>        u64 write_size_min;
> >>>>        u64 write_size_max;
> >>>>        ktime_t write_latency_sum;
> >>>> -     ktime_t write_latency_sq_sum;
> >>>> +     ktime_t avg_write_latency;
> >>>> +     ktime_t write_latency_stdev;
> >>>>        ktime_t write_latency_min;
> >>>>        ktime_t write_latency_max;
> >>>>
> >>>>        spinlock_t metadata_metric_lock;
> >>>>        u64 total_metadatas;
> >>>>        ktime_t metadata_latency_sum;
> >>>> -     ktime_t metadata_latency_sq_sum;
> >>>> +     ktime_t avg_metadata_latency;
> >>>> +     ktime_t metadata_latency_stdev;
> >>>>        ktime_t metadata_latency_min;
> >>>>        ktime_t metadata_latency_max;
> >>>>
> >>
>


-- 
Cheers,
Venky

