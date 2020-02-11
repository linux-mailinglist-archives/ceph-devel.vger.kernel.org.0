Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9BA1587F4
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 02:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgBKBaV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 20:30:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40070 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727599AbgBKBaU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 10 Feb 2020 20:30:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581384619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3b00HGQnk4Hu6we7P+VDGRssd92/PTzL1qPbydpEIk=;
        b=N5UXyTDsqqiLBcyvmad/ZwC8umXE65nsa3VexjoH/NEirW3ZxLxCWQwi7GDZMlc7Fp5Xh5
        C7LBT5or/diSss/xTHE2/S5SpDAw/8LGvvt6cU19a/BOIDFKEWvexpxWmwE4+RdtmIAzu8
        PDyxs8L5SqSpDqHwRcG1WpaI0eRz/Nw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-1BL_W2v-O-yFkKrKln4D9g-1; Mon, 10 Feb 2020 20:30:14 -0500
X-MC-Unique: 1BL_W2v-O-yFkKrKln4D9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CF1518A6EC1;
        Tue, 11 Feb 2020 01:30:13 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F340289F27;
        Tue, 11 Feb 2020 01:30:04 +0000 (UTC)
Subject: Re: [PATCH v6 6/9] ceph: periodically send perf metrics to ceph
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200210053407.37237-1-xiubli@redhat.com>
 <20200210053407.37237-7-xiubli@redhat.com>
 <CAOi1vP87a3JYZ2DjZX2U7LV+=SQtpc=tqDzdR4JgJD740FfYvg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c40d9b66-73d7-a44b-0435-aba6350d2149@redhat.com>
Date:   Tue, 11 Feb 2020 09:29:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP87a3JYZ2DjZX2U7LV+=SQtpc=tqDzdR4JgJD740FfYvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/10 23:34, Ilya Dryomov wrote:
> On Mon, Feb 10, 2020 at 6:34 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Add metric_send_interval module parameter support, the default valume
>> is 0, means disabled. If none zero it will enable the transmission of
>> the metrics to the ceph cluster periodically per metric_send_interval
>> seconds.
>>
>> This will send the caps, dentry lease and read/write/metadata perf
>> metrics to any available MDS only once per metric_send_interval
>> seconds.
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         | 235 +++++++++++++++++++++++++++++++----
>>   fs/ceph/mds_client.h         |   2 +
>>   fs/ceph/metric.h             |  76 +++++++++++
>>   fs/ceph/super.c              |   4 +
>>   fs/ceph/super.h              |   1 +
>>   include/linux/ceph/ceph_fs.h |   1 +
>>   6 files changed, 294 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index d414eded6810..f9a6f95c7941 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4085,16 +4085,167 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
>>          ceph_force_reconnect(fsc->sb);
>>   }
>>
>> -/*
>> - * delayed work -- periodically trim expired leases, renew caps with mds
>> - */
>> +static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>> +                                  struct ceph_mds_session *s,
>> +                                  u64 nr_caps)
>> +{
>> +       struct ceph_metric_head *head;
>> +       struct ceph_metric_cap *cap;
>> +       struct ceph_metric_dentry_lease *lease;
>> +       struct ceph_metric_read_latency *read;
>> +       struct ceph_metric_write_latency *write;
>> +       struct ceph_metric_metadata_latency *meta;
>> +       struct ceph_msg *msg;
>> +       struct timespec64 ts;
>> +       s64 sum, total;
>> +       s32 items = 0;
>> +       s32 len;
>> +
>> +       if (!mdsc || !s)
>> +               return false;
>> +
>> +       len = sizeof(*head) + sizeof(*cap) + sizeof(*lease) + sizeof(*read)
>> +             + sizeof(*write) + sizeof(*meta);
>> +
>> +       msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
>> +       if (!msg) {
>> +               pr_err("send metrics to mds%d, failed to allocate message\n",
>> +                      s->s_mds);
>> +               return false;
>> +       }
>> +
>> +       head = msg->front.iov_base;
>> +
>> +       /* encode the cap metric */
>> +       cap = (struct ceph_metric_cap *)(head + 1);
>> +       cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
>> +       cap->ver = 1;
>> +       cap->compat = 1;
>> +       cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
>> +       cap->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_hit));
>> +       cap->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_mis));
>> +       cap->total = cpu_to_le64(nr_caps);
>> +       items++;
>> +
>> +       dout("cap metric hit %lld, mis %lld, total caps %lld",
>> +            le64_to_cpu(cap->hit), le64_to_cpu(cap->mis),
>> +            le64_to_cpu(cap->total));
>> +
>> +       /* encode the read latency metric */
>> +       read = (struct ceph_metric_read_latency *)(cap + 1);
>> +       read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
>> +       read->ver = 1;
>> +       read->compat = 1;
>> +       read->data_len = cpu_to_le32(sizeof(*read) - 10);
>> +       total = percpu_counter_sum(&mdsc->metric.total_reads),
>> +       sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
>> +       jiffies_to_timespec64(sum, &ts);
>> +       read->sec = cpu_to_le32(ts.tv_sec);
>> +       read->nsec = cpu_to_le32(ts.tv_nsec);
>> +       items++;
>> +       dout("read latency metric total %lld, sum lat %lld", total, sum);
>> +
>> +       /* encode the write latency metric */
>> +       write = (struct ceph_metric_write_latency *)(read + 1);
>> +       write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
>> +       write->ver = 1;
>> +       write->compat = 1;
>> +       write->data_len = cpu_to_le32(sizeof(*write) - 10);
>> +       total = percpu_counter_sum(&mdsc->metric.total_writes),
>> +       sum = percpu_counter_sum(&mdsc->metric.write_latency_sum);
>> +       jiffies_to_timespec64(sum, &ts);
>> +       write->sec = cpu_to_le32(ts.tv_sec);
>> +       write->nsec = cpu_to_le32(ts.tv_nsec);
>> +       items++;
>> +       dout("write latency metric total %lld, sum lat %lld", total, sum);
>> +
>> +       /* encode the metadata latency metric */
>> +       meta = (struct ceph_metric_metadata_latency *)(write + 1);
>> +       meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
>> +       meta->ver = 1;
>> +       meta->compat = 1;
>> +       meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
>> +       total = percpu_counter_sum(&mdsc->metric.total_metadatas),
>> +       sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
>> +       jiffies_to_timespec64(sum, &ts);
>> +       meta->sec = cpu_to_le32(ts.tv_sec);
>> +       meta->nsec = cpu_to_le32(ts.tv_nsec);
>> +       items++;
>> +       dout("metadata latency metric total %lld, sum lat %lld", total, sum);
>> +
>> +       /* encode the dentry lease metric */
>> +       lease = (struct ceph_metric_dentry_lease *)(meta + 1);
>> +       lease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
>> +       lease->ver = 1;
>> +       lease->compat = 1;
>> +       lease->data_len = cpu_to_le32(sizeof(*lease) - 10);
>> +       lease->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_hit));
>> +       lease->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_mis));
>> +       lease->total = cpu_to_le64(atomic64_read(&mdsc->metric.total_dentries));
>> +       items++;
>> +       dout("dentry lease metric hit %lld, mis %lld, total dentries %lld",
>> +            le64_to_cpu(lease->hit), le64_to_cpu(lease->mis),
>> +            le64_to_cpu(lease->total));
>> +
>> +       put_unaligned_le32(items, &head->num);
>> +       msg->front.iov_len = cpu_to_le32(len);
>> +       msg->hdr.version = cpu_to_le16(1);
>> +       msg->hdr.compat_version = cpu_to_le16(1);
>> +       msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
>> +       dout("send metrics to mds%d %p\n", s->s_mds, msg);
>> +       ceph_con_send(&s->s_con, msg);
>> +
>> +       return true;
>> +}
>> +
>> +#define CEPH_WORK_DELAY_DEF 5
>> +static void __schedule_delayed(struct delayed_work *work, int delay)
>> +{
>> +       unsigned int hz = round_jiffies_relative(HZ * delay);
>> +
>> +       schedule_delayed_work(work, hz);
>> +}
>> +
>>   static void schedule_delayed(struct ceph_mds_client *mdsc)
>>   {
>> -       int delay = 5;
>> -       unsigned hz = round_jiffies_relative(HZ * delay);
>> -       schedule_delayed_work(&mdsc->delayed_work, hz);
>> +       __schedule_delayed(&mdsc->delayed_work, CEPH_WORK_DELAY_DEF);
>> +}
>> +
>> +static void metric_schedule_delayed(struct ceph_mds_client *mdsc)
>> +{
>> +       /* delay CEPH_WORK_DELAY_DEF seconds when idle */
>> +       int delay = metric_send_interval ? : CEPH_WORK_DELAY_DEF;
>> +
>> +       __schedule_delayed(&mdsc->metric_delayed_work, delay);
>> +}
>> +
>> +static bool check_session_state(struct ceph_mds_client *mdsc,
>> +                               struct ceph_mds_session *s)
>> +{
>> +       if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
>> +               dout("resending session close request for mds%d\n",
>> +                               s->s_mds);
>> +               request_close_session(mdsc, s);
>> +               return false;
>> +       }
>> +       if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
>> +               if (s->s_state == CEPH_MDS_SESSION_OPEN) {
>> +                       s->s_state = CEPH_MDS_SESSION_HUNG;
>> +                       pr_info("mds%d hung\n", s->s_mds);
>> +               }
>> +       }
>> +       if (s->s_state == CEPH_MDS_SESSION_NEW ||
>> +           s->s_state == CEPH_MDS_SESSION_RESTARTING ||
>> +           s->s_state == CEPH_MDS_SESSION_REJECTED)
>> +               /* this mds is failed or recovering, just wait */
>> +               return false;
>> +
>> +       return true;
>>   }
>>
>> +/*
>> + * delayed work -- periodically trim expired leases, renew caps with mds
>> + */
>>   static void delayed_work(struct work_struct *work)
>>   {
>>          int i;
>> @@ -4116,23 +4267,8 @@ static void delayed_work(struct work_struct *work)
>>                  struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
>>                  if (!s)
>>                          continue;
>> -               if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
>> -                       dout("resending session close request for mds%d\n",
>> -                            s->s_mds);
>> -                       request_close_session(mdsc, s);
>> -                       ceph_put_mds_session(s);
>> -                       continue;
>> -               }
>> -               if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
>> -                       if (s->s_state == CEPH_MDS_SESSION_OPEN) {
>> -                               s->s_state = CEPH_MDS_SESSION_HUNG;
>> -                               pr_info("mds%d hung\n", s->s_mds);
>> -                       }
>> -               }
>> -               if (s->s_state == CEPH_MDS_SESSION_NEW ||
>> -                   s->s_state == CEPH_MDS_SESSION_RESTARTING ||
>> -                   s->s_state == CEPH_MDS_SESSION_REJECTED) {
>> -                       /* this mds is failed or recovering, just wait */
>> +
>> +               if (!check_session_state(mdsc, s)) {
>>                          ceph_put_mds_session(s);
>>                          continue;
>>                  }
>> @@ -4164,8 +4300,53 @@ static void delayed_work(struct work_struct *work)
>>          schedule_delayed(mdsc);
>>   }
>>
>> -static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>> +static void metric_delayed_work(struct work_struct *work)
>> +{
>> +       struct ceph_mds_client *mdsc =
>> +               container_of(work, struct ceph_mds_client, metric_delayed_work.work);
>> +       struct ceph_mds_session *s;
>> +       u64 nr_caps = 0;
>> +       bool ret;
>> +       int i;
>> +
>> +       if (!metric_send_interval)
>> +               goto idle;
>> +
>> +       dout("mdsc metric_delayed_work\n");
>> +
>> +       mutex_lock(&mdsc->mutex);
>> +       for (i = 0; i < mdsc->max_sessions; i++) {
>> +               s = __ceph_lookup_mds_session(mdsc, i);
>> +               if (!s)
>> +                       continue;
>> +               nr_caps += s->s_nr_caps;
>> +               ceph_put_mds_session(s);
>> +       }
>> +
>> +       for (i = 0; i < mdsc->max_sessions; i++) {
>> +               s = __ceph_lookup_mds_session(mdsc, i);
>> +               if (!s)
>> +                       continue;
>> +               if (!check_session_state(mdsc, s)) {
>> +                       ceph_put_mds_session(s);
>> +                       continue;
>> +               }
>> +
>> +               /* Only send the metric once in any available session */
>> +               ret = ceph_mdsc_send_metrics(mdsc, s, nr_caps);
>> +               ceph_put_mds_session(s);
>> +               if (ret)
>> +                       break;
>> +       }
>> +       mutex_unlock(&mdsc->mutex);
>> +
>> +idle:
>> +       metric_schedule_delayed(mdsc);
> Looks like this will schedule metric_delayed_work() every 5 seconds
> even if metric_send_interval = 0 (i.e. sending is disabled).  What is
> the reason for that?

Hi Ilya,

Before I folded the metric_delayed_work() into delayed_work(). But for 
the this version since the interval is settable, so it hard to calculate 
the next schedule delay for that.

When it is idle just looping every 5 seconds, I thought though this is 
not a very graceful approach it won't introduce too much overload. If we 
do not like this, let's switch it to a completion.

Thanks,


> Thanks,
>
>                  Ilya
>

