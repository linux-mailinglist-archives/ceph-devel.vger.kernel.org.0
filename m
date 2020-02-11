Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30E815965A
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 18:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgBKRmi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 12:42:38 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:36050 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728797AbgBKRmi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Feb 2020 12:42:38 -0500
Received: by mail-il1-f195.google.com with SMTP id b15so4186202iln.3
        for <ceph-devel@vger.kernel.org>; Tue, 11 Feb 2020 09:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1QWN/S2/7FBll97NOaUG7L1b+S+l5z19lHJNxjIVauk=;
        b=OAEEe3YZih+Bbyny8VmSfp55Xt1x1pYJij6HpAPPDQygMpAHEXckUHjcKvaoA/y/0i
         Xealg32V7AZOEaHnQE5jPJAER2DEKDwaR01XXxe0AKUphzHgqx6Xb/ZRAgfw4QTKy1so
         1AHNh00TXenthGSNb/bdzX6z1wrc8cnnlelRUoQF2Xm65cuA90cGqDah1OiPyXGa8k1j
         8NGinF8v2Oi1EXp1RLxQS+ljOeM4wX40qC7ni5zZHDImmo/Gaq35agPC9wW6lxT0F1Mg
         nbZQaEw2e4JG18ZhfjBNO8xc8mei1LC2a+xGapzNvRORIY6B5WH4G7rpW/CMhz588kcz
         fcwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1QWN/S2/7FBll97NOaUG7L1b+S+l5z19lHJNxjIVauk=;
        b=bkl9MDe0D3V5WhToeved+TmKopyw8uSmMr6J8OVKk/ISGUQqr0QHkNNw2OuhBz1ir5
         XG2dQ4XQw9Z2jmNLH1oGZA/HS7++mYddxnDOeId829kPo5HpwdSkwGz/OQfiBDs1zaGX
         8yTRROVJq5yfNIEP9zHGLiZyXBxEG1gxGco8tORk2WTVcbbbwMKiM6STBzFClIETOE3G
         5RvBWRvQqypYAkIQFuHyMMHq11A297RQ/RSi+yyl4CDoD2bOT7RibDW9AwL79d2oXtZb
         cNIwuXRZCOVHWO3MqN2dUCFdzg9c3rBqSk9fMEkOOOtBbDjGmsZcuh78CEa1xH4Ddka3
         jkqQ==
X-Gm-Message-State: APjAAAUZ/T/jkj5QoKXdIkIqn2nWx5VPfTj+nJzJWOa4oh1M0qn39yBf
        XSbonmJ9MZtUdMhTihXlemrVW9WPLU2bv37i89Y=
X-Google-Smtp-Source: APXvYqz3Tno6N1ikB3boWBInSd/m14BaJO2kbuy7a6dlU+wEZx2CiO7wQy+a43YjlIiZV5Hxk/okDmy7Iz15K6ldJpg=
X-Received: by 2002:a92:3991:: with SMTP id h17mr7770130ilf.131.1581442955847;
 Tue, 11 Feb 2020 09:42:35 -0800 (PST)
MIME-Version: 1.0
References: <20200210053407.37237-1-xiubli@redhat.com> <20200210053407.37237-7-xiubli@redhat.com>
 <CAOi1vP87a3JYZ2DjZX2U7LV+=SQtpc=tqDzdR4JgJD740FfYvg@mail.gmail.com> <c40d9b66-73d7-a44b-0435-aba6350d2149@redhat.com>
In-Reply-To: <c40d9b66-73d7-a44b-0435-aba6350d2149@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 11 Feb 2020 18:42:54 +0100
Message-ID: <CAOi1vP-4Cd0Ap=RZnZ6evuZj5xT8_B+02HnCDdm25BuG64Qn6Q@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] ceph: periodically send perf metrics to ceph
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 11, 2020 at 2:30 AM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/2/10 23:34, Ilya Dryomov wrote:
> > On Mon, Feb 10, 2020 at 6:34 AM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> Add metric_send_interval module parameter support, the default valume
> >> is 0, means disabled. If none zero it will enable the transmission of
> >> the metrics to the ceph cluster periodically per metric_send_interval
> >> seconds.
> >>
> >> This will send the caps, dentry lease and read/write/metadata perf
> >> metrics to any available MDS only once per metric_send_interval
> >> seconds.
> >>
> >> URL: https://tracker.ceph.com/issues/43215
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/mds_client.c         | 235 +++++++++++++++++++++++++++++++----
> >>   fs/ceph/mds_client.h         |   2 +
> >>   fs/ceph/metric.h             |  76 +++++++++++
> >>   fs/ceph/super.c              |   4 +
> >>   fs/ceph/super.h              |   1 +
> >>   include/linux/ceph/ceph_fs.h |   1 +
> >>   6 files changed, 294 insertions(+), 25 deletions(-)
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index d414eded6810..f9a6f95c7941 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -4085,16 +4085,167 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
> >>          ceph_force_reconnect(fsc->sb);
> >>   }
> >>
> >> -/*
> >> - * delayed work -- periodically trim expired leases, renew caps with mds
> >> - */
> >> +static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> >> +                                  struct ceph_mds_session *s,
> >> +                                  u64 nr_caps)
> >> +{
> >> +       struct ceph_metric_head *head;
> >> +       struct ceph_metric_cap *cap;
> >> +       struct ceph_metric_dentry_lease *lease;
> >> +       struct ceph_metric_read_latency *read;
> >> +       struct ceph_metric_write_latency *write;
> >> +       struct ceph_metric_metadata_latency *meta;
> >> +       struct ceph_msg *msg;
> >> +       struct timespec64 ts;
> >> +       s64 sum, total;
> >> +       s32 items = 0;
> >> +       s32 len;
> >> +
> >> +       if (!mdsc || !s)
> >> +               return false;
> >> +
> >> +       len = sizeof(*head) + sizeof(*cap) + sizeof(*lease) + sizeof(*read)
> >> +             + sizeof(*write) + sizeof(*meta);
> >> +
> >> +       msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
> >> +       if (!msg) {
> >> +               pr_err("send metrics to mds%d, failed to allocate message\n",
> >> +                      s->s_mds);
> >> +               return false;
> >> +       }
> >> +
> >> +       head = msg->front.iov_base;
> >> +
> >> +       /* encode the cap metric */
> >> +       cap = (struct ceph_metric_cap *)(head + 1);
> >> +       cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
> >> +       cap->ver = 1;
> >> +       cap->compat = 1;
> >> +       cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
> >> +       cap->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_hit));
> >> +       cap->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_mis));
> >> +       cap->total = cpu_to_le64(nr_caps);
> >> +       items++;
> >> +
> >> +       dout("cap metric hit %lld, mis %lld, total caps %lld",
> >> +            le64_to_cpu(cap->hit), le64_to_cpu(cap->mis),
> >> +            le64_to_cpu(cap->total));
> >> +
> >> +       /* encode the read latency metric */
> >> +       read = (struct ceph_metric_read_latency *)(cap + 1);
> >> +       read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
> >> +       read->ver = 1;
> >> +       read->compat = 1;
> >> +       read->data_len = cpu_to_le32(sizeof(*read) - 10);
> >> +       total = percpu_counter_sum(&mdsc->metric.total_reads),
> >> +       sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
> >> +       jiffies_to_timespec64(sum, &ts);
> >> +       read->sec = cpu_to_le32(ts.tv_sec);
> >> +       read->nsec = cpu_to_le32(ts.tv_nsec);
> >> +       items++;
> >> +       dout("read latency metric total %lld, sum lat %lld", total, sum);
> >> +
> >> +       /* encode the write latency metric */
> >> +       write = (struct ceph_metric_write_latency *)(read + 1);
> >> +       write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
> >> +       write->ver = 1;
> >> +       write->compat = 1;
> >> +       write->data_len = cpu_to_le32(sizeof(*write) - 10);
> >> +       total = percpu_counter_sum(&mdsc->metric.total_writes),
> >> +       sum = percpu_counter_sum(&mdsc->metric.write_latency_sum);
> >> +       jiffies_to_timespec64(sum, &ts);
> >> +       write->sec = cpu_to_le32(ts.tv_sec);
> >> +       write->nsec = cpu_to_le32(ts.tv_nsec);
> >> +       items++;
> >> +       dout("write latency metric total %lld, sum lat %lld", total, sum);
> >> +
> >> +       /* encode the metadata latency metric */
> >> +       meta = (struct ceph_metric_metadata_latency *)(write + 1);
> >> +       meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
> >> +       meta->ver = 1;
> >> +       meta->compat = 1;
> >> +       meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
> >> +       total = percpu_counter_sum(&mdsc->metric.total_metadatas),
> >> +       sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
> >> +       jiffies_to_timespec64(sum, &ts);
> >> +       meta->sec = cpu_to_le32(ts.tv_sec);
> >> +       meta->nsec = cpu_to_le32(ts.tv_nsec);
> >> +       items++;
> >> +       dout("metadata latency metric total %lld, sum lat %lld", total, sum);
> >> +
> >> +       /* encode the dentry lease metric */
> >> +       lease = (struct ceph_metric_dentry_lease *)(meta + 1);
> >> +       lease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
> >> +       lease->ver = 1;
> >> +       lease->compat = 1;
> >> +       lease->data_len = cpu_to_le32(sizeof(*lease) - 10);
> >> +       lease->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_hit));
> >> +       lease->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_mis));
> >> +       lease->total = cpu_to_le64(atomic64_read(&mdsc->metric.total_dentries));
> >> +       items++;
> >> +       dout("dentry lease metric hit %lld, mis %lld, total dentries %lld",
> >> +            le64_to_cpu(lease->hit), le64_to_cpu(lease->mis),
> >> +            le64_to_cpu(lease->total));
> >> +
> >> +       put_unaligned_le32(items, &head->num);
> >> +       msg->front.iov_len = cpu_to_le32(len);
> >> +       msg->hdr.version = cpu_to_le16(1);
> >> +       msg->hdr.compat_version = cpu_to_le16(1);
> >> +       msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
> >> +       dout("send metrics to mds%d %p\n", s->s_mds, msg);
> >> +       ceph_con_send(&s->s_con, msg);
> >> +
> >> +       return true;
> >> +}
> >> +
> >> +#define CEPH_WORK_DELAY_DEF 5
> >> +static void __schedule_delayed(struct delayed_work *work, int delay)
> >> +{
> >> +       unsigned int hz = round_jiffies_relative(HZ * delay);
> >> +
> >> +       schedule_delayed_work(work, hz);
> >> +}
> >> +
> >>   static void schedule_delayed(struct ceph_mds_client *mdsc)
> >>   {
> >> -       int delay = 5;
> >> -       unsigned hz = round_jiffies_relative(HZ * delay);
> >> -       schedule_delayed_work(&mdsc->delayed_work, hz);
> >> +       __schedule_delayed(&mdsc->delayed_work, CEPH_WORK_DELAY_DEF);
> >> +}
> >> +
> >> +static void metric_schedule_delayed(struct ceph_mds_client *mdsc)
> >> +{
> >> +       /* delay CEPH_WORK_DELAY_DEF seconds when idle */
> >> +       int delay = metric_send_interval ? : CEPH_WORK_DELAY_DEF;
> >> +
> >> +       __schedule_delayed(&mdsc->metric_delayed_work, delay);
> >> +}
> >> +
> >> +static bool check_session_state(struct ceph_mds_client *mdsc,
> >> +                               struct ceph_mds_session *s)
> >> +{
> >> +       if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
> >> +               dout("resending session close request for mds%d\n",
> >> +                               s->s_mds);
> >> +               request_close_session(mdsc, s);
> >> +               return false;
> >> +       }
> >> +       if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
> >> +               if (s->s_state == CEPH_MDS_SESSION_OPEN) {
> >> +                       s->s_state = CEPH_MDS_SESSION_HUNG;
> >> +                       pr_info("mds%d hung\n", s->s_mds);
> >> +               }
> >> +       }
> >> +       if (s->s_state == CEPH_MDS_SESSION_NEW ||
> >> +           s->s_state == CEPH_MDS_SESSION_RESTARTING ||
> >> +           s->s_state == CEPH_MDS_SESSION_REJECTED)
> >> +               /* this mds is failed or recovering, just wait */
> >> +               return false;
> >> +
> >> +       return true;
> >>   }
> >>
> >> +/*
> >> + * delayed work -- periodically trim expired leases, renew caps with mds
> >> + */
> >>   static void delayed_work(struct work_struct *work)
> >>   {
> >>          int i;
> >> @@ -4116,23 +4267,8 @@ static void delayed_work(struct work_struct *work)
> >>                  struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
> >>                  if (!s)
> >>                          continue;
> >> -               if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
> >> -                       dout("resending session close request for mds%d\n",
> >> -                            s->s_mds);
> >> -                       request_close_session(mdsc, s);
> >> -                       ceph_put_mds_session(s);
> >> -                       continue;
> >> -               }
> >> -               if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
> >> -                       if (s->s_state == CEPH_MDS_SESSION_OPEN) {
> >> -                               s->s_state = CEPH_MDS_SESSION_HUNG;
> >> -                               pr_info("mds%d hung\n", s->s_mds);
> >> -                       }
> >> -               }
> >> -               if (s->s_state == CEPH_MDS_SESSION_NEW ||
> >> -                   s->s_state == CEPH_MDS_SESSION_RESTARTING ||
> >> -                   s->s_state == CEPH_MDS_SESSION_REJECTED) {
> >> -                       /* this mds is failed or recovering, just wait */
> >> +
> >> +               if (!check_session_state(mdsc, s)) {
> >>                          ceph_put_mds_session(s);
> >>                          continue;
> >>                  }
> >> @@ -4164,8 +4300,53 @@ static void delayed_work(struct work_struct *work)
> >>          schedule_delayed(mdsc);
> >>   }
> >>
> >> -static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
> >> +static void metric_delayed_work(struct work_struct *work)
> >> +{
> >> +       struct ceph_mds_client *mdsc =
> >> +               container_of(work, struct ceph_mds_client, metric_delayed_work.work);
> >> +       struct ceph_mds_session *s;
> >> +       u64 nr_caps = 0;
> >> +       bool ret;
> >> +       int i;
> >> +
> >> +       if (!metric_send_interval)
> >> +               goto idle;
> >> +
> >> +       dout("mdsc metric_delayed_work\n");
> >> +
> >> +       mutex_lock(&mdsc->mutex);
> >> +       for (i = 0; i < mdsc->max_sessions; i++) {
> >> +               s = __ceph_lookup_mds_session(mdsc, i);
> >> +               if (!s)
> >> +                       continue;
> >> +               nr_caps += s->s_nr_caps;
> >> +               ceph_put_mds_session(s);
> >> +       }
> >> +
> >> +       for (i = 0; i < mdsc->max_sessions; i++) {
> >> +               s = __ceph_lookup_mds_session(mdsc, i);
> >> +               if (!s)
> >> +                       continue;
> >> +               if (!check_session_state(mdsc, s)) {
> >> +                       ceph_put_mds_session(s);
> >> +                       continue;
> >> +               }
> >> +
> >> +               /* Only send the metric once in any available session */
> >> +               ret = ceph_mdsc_send_metrics(mdsc, s, nr_caps);
> >> +               ceph_put_mds_session(s);
> >> +               if (ret)
> >> +                       break;
> >> +       }
> >> +       mutex_unlock(&mdsc->mutex);
> >> +
> >> +idle:
> >> +       metric_schedule_delayed(mdsc);
> > Looks like this will schedule metric_delayed_work() every 5 seconds
> > even if metric_send_interval = 0 (i.e. sending is disabled).  What is
> > the reason for that?
>
> Hi Ilya,
>
> Before I folded the metric_delayed_work() into delayed_work(). But for
> the this version since the interval is settable, so it hard to calculate
> the next schedule delay for that.
>
> When it is idle just looping every 5 seconds, I thought though this is
> not a very graceful approach it won't introduce too much overload. If we
> do not like this, let's switch it to a completion.

Take a look at module_param_cb macro.  I think you can provide a
setter and schedule the first work / modify the delay from there.

That said, I'm not sure making the interval configurable is a good
idea.  I'm not saying you need to change anything -- just that if it
was me, I would send these metrics once per tick (i.e. delayed_work)
with an on/off switch and no other tunables.

Thanks,

                Ilya
