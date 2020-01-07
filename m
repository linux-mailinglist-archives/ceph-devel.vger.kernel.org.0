Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F61013276D
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jan 2020 14:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgAGNTS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jan 2020 08:19:18 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726937AbgAGNTR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jan 2020 08:19:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578403156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k9ogoGMKGgQPxU00OBjQtArKFrd49hJnTvVOYz6IKhM=;
        b=fK+Aw4Haec9uet/X4WNdoG/BtPu6H8y/mmEJXmRcfV0C3hw1A70TcR20B8EMjBwtutF2Ci
        3Fvo9JLevd0ihjoeF5Et/i3HTvyK8Z+SHowfCJF0bYLam53XwYh0MwJuzw2fpl7K0kJBP5
        Glyb/qWB7OtS3xBK4ptcdy3vWlRF4Ng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-irUaJKQIOM-3OVKnzHvj2Q-1; Tue, 07 Jan 2020 08:19:12 -0500
X-MC-Unique: irUaJKQIOM-3OVKnzHvj2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A91491007303;
        Tue,  7 Jan 2020 13:19:11 +0000 (UTC)
Received: from [10.72.12.70] (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 637775C1BB;
        Tue,  7 Jan 2020 13:19:06 +0000 (UTC)
Subject: Re: [PATCH 4/4] ceph: add enable/disable sending metrics to MDS
 debugfs support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20191224040514.26144-1-xiubli@redhat.com>
 <20191224040514.26144-5-xiubli@redhat.com>
 <CAOi1vP-XGL1irAer-v8W0Jv9-aapARn-zoDdrxuutPAERtqPVw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <98ae6b33-7b5a-f983-8def-e99f3d02ef35@redhat.com>
Date:   Tue, 7 Jan 2020 21:19:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-XGL1irAer-v8W0Jv9-aapARn-zoDdrxuutPAERtqPVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/7 19:13, Ilya Dryomov wrote:
> On Tue, Dec 24, 2019 at 5:05 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Disabled as default, if it's enabled the kclient will send metrics
>> every second.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/debugfs.c    | 44 ++++++++++++++++++++++++++++++--
>>   fs/ceph/mds_client.c | 60 +++++++++++++++++++++++++++++++-------------
>>   fs/ceph/mds_client.h |  3 +++
>>   fs/ceph/super.h      |  1 +
>>   4 files changed, 89 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>> index c132fdb40d53..a26e559473fd 100644
>> --- a/fs/ceph/debugfs.c
>> +++ b/fs/ceph/debugfs.c
>> @@ -124,6 +124,40 @@ static int mdsc_show(struct seq_file *s, void *p)
>>          return 0;
>>   }
>>
>> +/*
>> + * metrics debugfs
>> + */
>> +static int sending_metrics_set(void *data, u64 val)
>> +{
>> +       struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
>> +       struct ceph_mds_client *mdsc = fsc->mdsc;
>> +
>> +       if (val > 1) {
>> +               pr_err("Invalid sending metrics set value %llu\n", val);
>> +               return -EINVAL;
>> +       }
>> +
>> +       mutex_lock(&mdsc->mutex);
>> +       mdsc->sending_metrics = (unsigned int)val;
>> +       mutex_unlock(&mdsc->mutex);
>> +
>> +       return 0;
>> +}
>> +
>> +static int sending_metrics_get(void *data, u64 *val)
>> +{
>> +       struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
>> +       struct ceph_mds_client *mdsc = fsc->mdsc;
>> +
>> +       mutex_lock(&mdsc->mutex);
>> +       *val = (u64)mdsc->sending_metrics;
>> +       mutex_unlock(&mdsc->mutex);
>> +
>> +       return 0;
>> +}
>> +DEFINE_DEBUGFS_ATTRIBUTE(sending_metrics_fops, sending_metrics_get,
>> +                        sending_metrics_set, "%llu\n");
>> +
>>   static int metric_show(struct seq_file *s, void *p)
>>   {
>>          struct ceph_fs_client *fsc = s->private;
>> @@ -279,11 +313,9 @@ static int congestion_kb_get(void *data, u64 *val)
>>          *val = (u64)fsc->mount_options->congestion_kb;
>>          return 0;
>>   }
>> -
>>   DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
>>                          congestion_kb_set, "%llu\n");
>>
>> -
>>   void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>>   {
>>          dout("ceph_fs_debugfs_cleanup\n");
>> @@ -293,6 +325,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>>          debugfs_remove(fsc->debugfs_mds_sessions);
>>          debugfs_remove(fsc->debugfs_caps);
>>          debugfs_remove(fsc->debugfs_metric);
>> +       debugfs_remove(fsc->debugfs_sending_metrics);
>>          debugfs_remove(fsc->debugfs_mdsc);
>>   }
>>
>> @@ -333,6 +366,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>>                                                  fsc,
>>                                                  &mdsc_show_fops);
>>
>> +       fsc->debugfs_sending_metrics =
>> +                       debugfs_create_file_unsafe("sending_metrics",
>> +                                                  0600,
>> +                                                  fsc->client->debugfs_dir,
>> +                                                  fsc,
>> +                                                  &sending_metrics_fops);
> Hi Xiubo,
>
> Same question as to Chen.  Why are you using the unsafe variant
> with DEFINE_DEBUGFS_ATTRIBUTE instead of just mirroring the existing
> writeback_congestion_kb?  Have you verified that it is safe?

Just copied the code from some other place.

Any struct file_operations defined by means of the 
DEFINE_DEBUGFS_ATTRIBUTE macro is protected against file removals, so it 
should be okay.

> I was a little confused by this series as a whole too.  Patch 3 says
> that these metrics will be sent every 5 seconds, which matches the caps
> tick interval.  This patch changes that to 1 second and makes sending
> metrics optional.  Perhaps merge patches 3 and 4 into a single patch
> with a better changelog?

Just to make each patch as small as possible, which will be easier to 
review.

I am okay to merge them with a better changelog.

>
> Do we really need to send metrics more often than we potentially renew
> caps?

I had the same question, while the user client is tied to Client::tick() 
and sending the metrics every second.

Here will just keep it the same with the user client logic, but per 
second is not a must.

Thanks.


> Thanks,
>
>                  Ilya
>

