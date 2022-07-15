Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD9A5759EF
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Jul 2022 05:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiGODUs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Jul 2022 23:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiGODUr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Jul 2022 23:20:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C7CA76E99
        for <ceph-devel@vger.kernel.org>; Thu, 14 Jul 2022 20:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657855243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RqYYqXivfHO0f0JVP8BTJ8InJ2eafO5OMUs1B319nyE=;
        b=ZgrwfuNlwwwMWNiBoWurwr0W6CwLiyu9F73hMeN/1QmSdrzCWfOW8guu3uY3p511byR00i
        njgtv0KhMHQd3z6+iYMbtPz5YXODoUfbTJLlLlwgxxzjvucovrBey2VABn2ffxA87pxq44
        bPzNK29ADwEVb803wpwd4mnlmf9PYr0=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-SMqcxXePM1aoV6hVjc8PGg-1; Thu, 14 Jul 2022 23:20:36 -0400
X-MC-Unique: SMqcxXePM1aoV6hVjc8PGg-1
Received: by mail-pg1-f198.google.com with SMTP id x17-20020a631711000000b0041240801d34so2161305pgl.17
        for <ceph-devel@vger.kernel.org>; Thu, 14 Jul 2022 20:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RqYYqXivfHO0f0JVP8BTJ8InJ2eafO5OMUs1B319nyE=;
        b=sc2oL4fyw1kfqY0epHYAMlKgsZLIysNehZrVgR85pzkKRxBK/8dJERPz1mix2FmKlf
         BsQT5fLFG44V+JiaNDP7Q7IodpmlIgk6xq/jd0QPhF1+UJ7YwLOl4gldZlrFdxeFm3hf
         oxZB8Ldm0VjHdc2PIMBWOWkFU17SDj/Hc9T0kfEefOnPHFAYxy8s9Y9L2y7C6QGG0p2H
         6VLeOr6K0krWlB6I7CA9Yl1RkBy/24Ba9wok55NrAKZDD06VFXT8gqbk4TgJNSCfPN9b
         WZRYLGDrzsbSXlpJSuzU/gmVekyDCdD3/9OCrYYA+npKX+fZrAqGGKMzDpCRyS6OjiVu
         bRpA==
X-Gm-Message-State: AJIora8QiCrxvCTt072xTDxWtjrRzuLSw4wlp7xrPKoEp0QhxsAASWQ2
        TyfP39PNH/YlJnb+uosWelfd7ypgCRftPaF75XSfJDPzHwcSOAE6/W2xR74zbxg0m4zV7a3RdLS
        C1QnPsoJHlnhkBiNCBiZMfA==
X-Received: by 2002:a17:902:e54e:b0:16c:33f7:55f7 with SMTP id n14-20020a170902e54e00b0016c33f755f7mr11549016plf.111.1657855234961;
        Thu, 14 Jul 2022 20:20:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sNJQEZWUiCU73RVActNcAsa9VV++IhVZHZM+T0YcOYJQCI4IGYXcgPGxGJOYqq6u1omkBd2A==
X-Received: by 2002:a17:902:e54e:b0:16c:33f7:55f7 with SMTP id n14-20020a170902e54e00b0016c33f755f7mr11548977plf.111.1657855234526;
        Thu, 14 Jul 2022 20:20:34 -0700 (PDT)
Received: from [10.72.14.22] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f27-20020aa7969b000000b005251fff13dfsm2481753pfk.155.2022.07.14.20.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 20:20:33 -0700 (PDT)
Subject: Re: [PATCH 2/3] ceph: only send the metrices supported by the MDS for
 old cephs
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Venky Shankar <vshankar@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        Milind Changire <mchangir@redhat.com>
References: <20220331065241.27370-1-xiubli@redhat.com>
 <20220331065241.27370-3-xiubli@redhat.com>
 <756cb0c834b8cc4005291132066d411f35d88274.camel@kernel.org>
 <a20c3a97-4a4d-70fc-509a-b96d8fe27751@redhat.com>
Message-ID: <7366fb97-56d4-79da-9f27-446839a7104a@redhat.com>
Date:   Fri, 15 Jul 2022 11:20:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a20c3a97-4a4d-70fc-509a-b96d8fe27751@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

More info.

Check the upstream ceph code:

The commit c669de12e076bcedf3fe6cfe52377713f06d7ceb introduced the 
ceph_abort() code when received an unknown metric from clients.

$ git tag --contain c669de12e076bcedf3fe6cfe52377713f06d7ceb
v16.1.0
v16.2.0
v16.2.1
v16.2.2
v16.2.3
v16.2.4
v16.2.5
v16.2.6
v16.2.7
v16.2.8
v16.2.9
v17.0.0
v17.1.0
v17.2.0
v17.2.1

And a following commit b1b44d775df3160d937c068d5e1079e24199ed6b has 
fixed it:

diff --git a/src/include/cephfs/metrics/Types.h 
b/src/include/cephfs/metrics/Types.h
index 8def1aa7101..d5589136de2 100644
--- a/src/include/cephfs/metrics/Types.h
+++ b/src/include/cephfs/metrics/Types.h
@@ -53,7 +53,7 @@ inline std::ostream &operator<<(std::ostream &os, 
const ClientMetricType &type)
      os << "OPENED_INODES";
      break;
    default:
-    ceph_abort();
+    os << "Unknown metric type: " << type;
    }

    return os;


$ git tag --contain b1b44d775df3160d937c068d5e1079e24199ed6b
v17.1.0
v17.2.0
v17.2.1

For the backported commit for the above patch in Pacific:

$ git tag --contain 48396a2a6effc09768e83e7b2709a0dc42d08199
v16.2.5
v16.2.6
v16.2.7
v16.2.8
v16.2.9

That means for all the Pacific version of:

v16.1.0
v16.2.0
v16.2.1
v16.2.2
v16.2.3
v16.2.4

We must disable the client metrics in kclient if users are using these 
version with newer kernels, or if they are using this ceph versions the 
couldn't see anything about the client metrics even for those they support.

Checked the downstream ceph versions, there are 159 tags gap between the 
bug and fix.

-- Xiubo





On 7/13/22 9:25 AM, Xiubo Li wrote:
> Jeff,
>
> I think this still makes sense, more detail please see [1], which is 
> as I worried for the older ceph and when users want to upgrade the 
> cluster.
>
> Though this is a MDS side bug and have already been fixed in the MDS, 
> but if there are existing clusters running before that fix, so when 
> upgrading the kclient only or if the upgrade the kclient first, they 
> will complain the same issue in [1].
>
> [1] https://tracker.ceph.com/issues/56529
>
> -- Xiubo
>
>
> On 3/31/22 8:11 PM, Jeff Layton wrote:
>> On Thu, 2022-03-31 at 14:52 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> For some old ceph versions when receives unknown metrics it will
>>> abort the MDS daemons. This will only send the metrics which are
>>> supported by MDSes.
>>>
>>> Defautly the MDS won't fill the s_metrics in the MClientSession
>>> reply message, so with this patch will only force sending the
>>> metrics to MDS since Quincy version, which is safe to receive
>>> unknown metrics.
>>>
>>> Next we will add one module option to force enable sending the
>>> metrics if users think that is safe.
>>>
>>
>> Is this really a problem we need to work around in the client?
>>
>> This is an MDS bug and the patches to fix that abort are being
>> backported (or already have been). I think we shouldn't do this at all
>> and instead insist that this be fixed in the MDS.
>>
>>> URL: https://tracker.ceph.com/issues/54411
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/mds_client.c |  19 +++-
>>>   fs/ceph/mds_client.h |   1 +
>>>   fs/ceph/metric.c     | 206 
>>> ++++++++++++++++++++++++-------------------
>>>   3 files changed, 131 insertions(+), 95 deletions(-)
>>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index f476c65fb985..65980ce97620 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -3422,7 +3422,7 @@ static void handle_session(struct 
>>> ceph_mds_session *session,
>>>       void *end = p + msg->front.iov_len;
>>>       struct ceph_mds_session_head *h;
>>>       u32 op;
>>> -    u64 seq, features = 0;
>>> +    u64 seq, features = 0, metrics = 0;
>>>       int wake = 0;
>>>       bool blocklisted = false;
>>>   @@ -3452,11 +3452,21 @@ static void handle_session(struct 
>>> ceph_mds_session *session,
>>>           }
>>>       }
>>>   +    /* version >= 4, metric bits */
>>> +    if (msg_version >= 4) {
>>> +        u32 len;
>>> +        /* struct_v, struct_compat, and len */
>>> +        ceph_decode_skip_n(&p, end, 2 + sizeof(u32), bad);
>>> +        ceph_decode_32_safe(&p, end, len, bad);
>>> +        if (len) {
>>> +            ceph_decode_64_safe(&p, end, metrics, bad);
>>> +            p += len - sizeof(metrics);
>>> +        }
>>> +    }
>>> +
>>> +    /* version >= 5, flags   */
>>>       if (msg_version >= 5) {
>>>           u32 flags;
>>> -        /* version >= 4, struct_v, struct_cv, len, metric_spec */
>>> -            ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 2, bad);
>>> -        /* version >= 5, flags   */
>>>                   ceph_decode_32_safe(&p, end, flags, bad);
>>>           if (flags & CEPH_SESSION_BLOCKLISTED) {
>>>                   pr_warn("mds%d session blocklisted\n", 
>>> session->s_mds);
>>> @@ -3490,6 +3500,7 @@ static void handle_session(struct 
>>> ceph_mds_session *session,
>>>               pr_info("mds%d reconnect success\n", session->s_mds);
>>>           session->s_state = CEPH_MDS_SESSION_OPEN;
>>>           session->s_features = features;
>>> +        session->s_metrics = metrics;
>>>           renewed_caps(mdsc, session, 0);
>>>           if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, 
>>> &session->s_features))
>>>               metric_schedule_delayed(&mdsc->metric);
>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>> index 32107c26f50d..0f2061f5388d 100644
>>> --- a/fs/ceph/mds_client.h
>>> +++ b/fs/ceph/mds_client.h
>>> @@ -188,6 +188,7 @@ struct ceph_mds_session {
>>>       int               s_state;
>>>       unsigned long     s_ttl;      /* time until mds kills us */
>>>       unsigned long      s_features;
>>> +    unsigned long      s_metrics;
>>>       u64               s_seq;      /* incoming msg seq # */
>>>       struct mutex      s_mutex;    /* serialize session messages */
>>>   diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>>> index c47347d2e84e..f01c1f4e6b89 100644
>>> --- a/fs/ceph/metric.c
>>> +++ b/fs/ceph/metric.c
>>> @@ -31,6 +31,7 @@ static bool ceph_mdsc_send_metrics(struct 
>>> ceph_mds_client *mdsc,
>>>       struct ceph_client_metric *m = &mdsc->metric;
>>>       u64 nr_caps = atomic64_read(&m->total_caps);
>>>       u32 header_len = sizeof(struct ceph_metric_header);
>>> +    bool force = test_bit(CEPHFS_FEATURE_QUINCY, &s->s_features);
>> I don't necessarily have a problem with adding extra CEPHFS_FEATURE_*
>> enum values for different releases, as they're nice for documentation
>> purposes. In the actual client code however, we should ensure that we
>> only test for the _actual_ feature flag, and not the one corresponding
>> to a particular release.
>>
>>
>>>       struct ceph_msg *msg;
>>>       s64 sum;
>>>       s32 items = 0;
>>> @@ -51,117 +52,140 @@ static bool ceph_mdsc_send_metrics(struct 
>>> ceph_mds_client *mdsc,
>>>       head = msg->front.iov_base;
>>>         /* encode the cap metric */
>>> -    cap = (struct ceph_metric_cap *)(head + 1);
>>> -    cap->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
>>> -    cap->header.ver = 1;
>>> -    cap->header.compat = 1;
>>> -    cap->header.data_len = cpu_to_le32(sizeof(*cap) - header_len);
>>> -    cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
>>> -    cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
>>> -    cap->total = cpu_to_le64(nr_caps);
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_CAP_INFO, 
>>> &s->s_metrics)) {
>>> +        cap = (struct ceph_metric_cap *)(head + 1);
>>> +        cap->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
>>> +        cap->header.ver = 1;
>>> +        cap->header.compat = 1;
>>> +        cap->header.data_len = cpu_to_le32(sizeof(*cap) - header_len);
>>> +        cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
>>> +        cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
>>> +        cap->total = cpu_to_le64(nr_caps);
>>> +        items++;
>>> +    }
>>>         /* encode the read latency metric */
>>> -    read = (struct ceph_metric_read_latency *)(cap + 1);
>>> -    read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
>>> -    read->header.ver = 2;
>>> -    read->header.compat = 1;
>>> -    read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
>>> -    sum = m->metric[METRIC_READ].latency_sum;
>>> -    ktime_to_ceph_timespec(&read->lat, sum);
>>> -    ktime_to_ceph_timespec(&read->avg, 
>>> m->metric[METRIC_READ].latency_avg);
>>> -    read->sq_sum = cpu_to_le64(m->metric[METRIC_READ].latency_sq_sum);
>>> -    read->count = cpu_to_le64(m->metric[METRIC_READ].total);
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_READ_LATENCY, 
>>> &s->s_metrics)) {
>>> +        read = (struct ceph_metric_read_latency *)(cap + 1);
>>> +        read->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
>>> +        read->header.ver = 2;
>>> +        read->header.compat = 1;
>>> +        read->header.data_len = cpu_to_le32(sizeof(*read) - 
>>> header_len);
>>> +        sum = m->metric[METRIC_READ].latency_sum;
>>> +        ktime_to_ceph_timespec(&read->lat, sum);
>>> +        ktime_to_ceph_timespec(&read->avg, 
>>> m->metric[METRIC_READ].latency_avg);
>>> +        read->sq_sum = 
>>> cpu_to_le64(m->metric[METRIC_READ].latency_sq_sum);
>>> +        read->count = cpu_to_le64(m->metric[METRIC_READ].total);
>>> +        items++;
>>> +    }
>>>         /* encode the write latency metric */
>>> -    write = (struct ceph_metric_write_latency *)(read + 1);
>>> -    write->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
>>> -    write->header.ver = 2;
>>> -    write->header.compat = 1;
>>> -    write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
>>> -    sum = m->metric[METRIC_WRITE].latency_sum;
>>> -    ktime_to_ceph_timespec(&write->lat, sum);
>>> -    ktime_to_ceph_timespec(&write->avg, 
>>> m->metric[METRIC_WRITE].latency_avg);
>>> -    write->sq_sum = 
>>> cpu_to_le64(m->metric[METRIC_WRITE].latency_sq_sum);
>>> -    write->count = cpu_to_le64(m->metric[METRIC_WRITE].total);
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_WRITE_LATENCY, 
>>> &s->s_metrics)) {
>>> +        write = (struct ceph_metric_write_latency *)(read + 1);
>>> +        write->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
>>> +        write->header.ver = 2;
>>> +        write->header.compat = 1;
>>> +        write->header.data_len = cpu_to_le32(sizeof(*write) - 
>>> header_len);
>>> +        sum = m->metric[METRIC_WRITE].latency_sum;
>>> +        ktime_to_ceph_timespec(&write->lat, sum);
>>> +        ktime_to_ceph_timespec(&write->avg, 
>>> m->metric[METRIC_WRITE].latency_avg);
>>> +        write->sq_sum = 
>>> cpu_to_le64(m->metric[METRIC_WRITE].latency_sq_sum);
>>> +        write->count = cpu_to_le64(m->metric[METRIC_WRITE].total);
>>> +        items++;
>>> +    }
>>>         /* encode the metadata latency metric */
>>> -    meta = (struct ceph_metric_metadata_latency *)(write + 1);
>>> -    meta->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
>>> -    meta->header.ver = 2;
>>> -    meta->header.compat = 1;
>>> -    meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
>>> -    sum = m->metric[METRIC_METADATA].latency_sum;
>>> -    ktime_to_ceph_timespec(&meta->lat, sum);
>>> -    ktime_to_ceph_timespec(&meta->avg, 
>>> m->metric[METRIC_METADATA].latency_avg);
>>> -    meta->sq_sum = 
>>> cpu_to_le64(m->metric[METRIC_METADATA].latency_sq_sum);
>>> -    meta->count = cpu_to_le64(m->metric[METRIC_METADATA].total);
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_METADATA_LATENCY, 
>>> &s->s_metrics)) {
>>> +        meta = (struct ceph_metric_metadata_latency *)(write + 1);
>>> +        meta->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
>>> +        meta->header.ver = 2;
>>> +        meta->header.compat = 1;
>>> +        meta->header.data_len = cpu_to_le32(sizeof(*meta) - 
>>> header_len);
>>> +        sum = m->metric[METRIC_METADATA].latency_sum;
>>> +        ktime_to_ceph_timespec(&meta->lat, sum);
>>> +        ktime_to_ceph_timespec(&meta->avg, 
>>> m->metric[METRIC_METADATA].latency_avg);
>>> +        meta->sq_sum = 
>>> cpu_to_le64(m->metric[METRIC_METADATA].latency_sq_sum);
>>> +        meta->count = cpu_to_le64(m->metric[METRIC_METADATA].total);
>>> +        items++;
>>> +    }
>>>         /* encode the dentry lease metric */
>>> -    dlease = (struct ceph_metric_dlease *)(meta + 1);
>>> -    dlease->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
>>> -    dlease->header.ver = 1;
>>> -    dlease->header.compat = 1;
>>> -    dlease->header.data_len = cpu_to_le32(sizeof(*dlease) - 
>>> header_len);
>>> -    dlease->hit = cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
>>> -    dlease->mis = cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
>>> -    dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_DENTRY_LEASE, 
>>> &s->s_metrics)) {
>>> +        dlease = (struct ceph_metric_dlease *)(meta + 1);
>>> +        dlease->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
>>> +        dlease->header.ver = 1;
>>> +        dlease->header.compat = 1;
>>> +        dlease->header.data_len = cpu_to_le32(sizeof(*dlease) - 
>>> header_len);
>>> +        dlease->hit = 
>>> cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
>>> +        dlease->mis = 
>>> cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
>>> +        dlease->total = 
>>> cpu_to_le64(atomic64_read(&m->total_dentries));
>>> +        items++;
>>> +    }
>>>         sum = percpu_counter_sum(&m->total_inodes);
>>>         /* encode the opened files metric */
>>> -    files = (struct ceph_opened_files *)(dlease + 1);
>>> -    files->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
>>> -    files->header.ver = 1;
>>> -    files->header.compat = 1;
>>> -    files->header.data_len = cpu_to_le32(sizeof(*files) - header_len);
>>> -    files->opened_files = 
>>> cpu_to_le64(atomic64_read(&m->opened_files));
>>> -    files->total = cpu_to_le64(sum);
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_OPENED_FILES, 
>>> &s->s_metrics)) {
>>> +        files = (struct ceph_opened_files *)(dlease + 1);
>>> +        files->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
>>> +        files->header.ver = 1;
>>> +        files->header.compat = 1;
>>> +        files->header.data_len = cpu_to_le32(sizeof(*files) - 
>>> header_len);
>>> +        files->opened_files = 
>>> cpu_to_le64(atomic64_read(&m->opened_files));
>>> +        files->total = cpu_to_le64(sum);
>>> +        items++;
>>> +    }
>>>         /* encode the pinned icaps metric */
>>> -    icaps = (struct ceph_pinned_icaps *)(files + 1);
>>> -    icaps->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
>>> -    icaps->header.ver = 1;
>>> -    icaps->header.compat = 1;
>>> -    icaps->header.data_len = cpu_to_le32(sizeof(*icaps) - header_len);
>>> -    icaps->pinned_icaps = cpu_to_le64(nr_caps);
>>> -    icaps->total = cpu_to_le64(sum);
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_PINNED_ICAPS, 
>>> &s->s_metrics)) {
>>> +        icaps = (struct ceph_pinned_icaps *)(files + 1);
>>> +        icaps->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
>>> +        icaps->header.ver = 1;
>>> +        icaps->header.compat = 1;
>>> +        icaps->header.data_len = cpu_to_le32(sizeof(*icaps) - 
>>> header_len);
>>> +        icaps->pinned_icaps = cpu_to_le64(nr_caps);
>>> +        icaps->total = cpu_to_le64(sum);
>>> +        items++;
>>> +    }
>>>         /* encode the opened inodes metric */
>>> -    inodes = (struct ceph_opened_inodes *)(icaps + 1);
>>> -    inodes->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
>>> -    inodes->header.ver = 1;
>>> -    inodes->header.compat = 1;
>>> -    inodes->header.data_len = cpu_to_le32(sizeof(*inodes) - 
>>> header_len);
>>> -    inodes->opened_inodes = 
>>> cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
>>> -    inodes->total = cpu_to_le64(sum);
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_OPENED_INODES, 
>>> &s->s_metrics)) {
>>> +        inodes = (struct ceph_opened_inodes *)(icaps + 1);
>>> +        inodes->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
>>> +        inodes->header.ver = 1;
>>> +        inodes->header.compat = 1;
>>> +        inodes->header.data_len = cpu_to_le32(sizeof(*inodes) - 
>>> header_len);
>>> +        inodes->opened_inodes = 
>>> cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
>>> +        inodes->total = cpu_to_le64(sum);
>>> +        items++;
>>> +    }
>>>         /* encode the read io size metric */
>>> -    rsize = (struct ceph_read_io_size *)(inodes + 1);
>>> -    rsize->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_READ_IO_SIZES);
>>> -    rsize->header.ver = 1;
>>> -    rsize->header.compat = 1;
>>> -    rsize->header.data_len = cpu_to_le32(sizeof(*rsize) - header_len);
>>> -    rsize->total_ops = cpu_to_le64(m->metric[METRIC_READ].total);
>>> -    rsize->total_size = cpu_to_le64(m->metric[METRIC_READ].size_sum);
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_READ_IO_SIZES, 
>>> &s->s_metrics)) {
>>> +        rsize = (struct ceph_read_io_size *)(inodes + 1);
>>> +        rsize->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_READ_IO_SIZES);
>>> +        rsize->header.ver = 1;
>>> +        rsize->header.compat = 1;
>>> +        rsize->header.data_len = cpu_to_le32(sizeof(*rsize) - 
>>> header_len);
>>> +        rsize->total_ops = cpu_to_le64(m->metric[METRIC_READ].total);
>>> +        rsize->total_size = 
>>> cpu_to_le64(m->metric[METRIC_READ].size_sum);
>>> +        items++;
>>> +    }
>>>         /* encode the write io size metric */
>>> -    wsize = (struct ceph_write_io_size *)(rsize + 1);
>>> -    wsize->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_IO_SIZES);
>>> -    wsize->header.ver = 1;
>>> -    wsize->header.compat = 1;
>>> -    wsize->header.data_len = cpu_to_le32(sizeof(*wsize) - header_len);
>>> -    wsize->total_ops = cpu_to_le64(m->metric[METRIC_WRITE].total);
>>> -    wsize->total_size = cpu_to_le64(m->metric[METRIC_WRITE].size_sum);
>>> -    items++;
>>> +    if (force || test_bit(CLIENT_METRIC_TYPE_WRITE_IO_SIZES, 
>>> &s->s_metrics)) {
>>> +        wsize = (struct ceph_write_io_size *)(rsize + 1);
>>> +        wsize->header.type = 
>>> cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_IO_SIZES);
>>> +        wsize->header.ver = 1;
>>> +        wsize->header.compat = 1;
>>> +        wsize->header.data_len = cpu_to_le32(sizeof(*wsize) - 
>>> header_len);
>>> +        wsize->total_ops = cpu_to_le64(m->metric[METRIC_WRITE].total);
>>> +        wsize->total_size = 
>>> cpu_to_le64(m->metric[METRIC_WRITE].size_sum);
>>> +        items++;
>>> +    }
>>> +
>>> +    if (!items)
>>> +        return true;
>>>         put_unaligned_le32(items, &head->num);
>>>       msg->front.iov_len = len;

