Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101AE2AA1E9
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Nov 2020 01:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgKGAzx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Nov 2020 19:55:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726447AbgKGAzx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Nov 2020 19:55:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604710551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wMOuyvqRY1nON+lJg9EOI1TObfOl9wiEUzacGUy4hmw=;
        b=eiLOxoHVKT6t06HbiqDW2qazbvquk7tCnPd8MjTrjFqbKhOF8P0PORYlziTzifwKL+loon
        uvacUF887wGc088bCdN1ztmd5W2Lt9iqc4ARsfKhg8/qmGQN2uJqaY7aILkv9Y+6khEtdv
        veHD7ygl27/A7DD2BSLm29YyRryL5iU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-6iIQaBizOnai-xMro-D_Ow-1; Fri, 06 Nov 2020 19:55:49 -0500
X-MC-Unique: 6iIQaBizOnai-xMro-D_Ow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDC858049C9;
        Sat,  7 Nov 2020 00:55:47 +0000 (UTC)
Received: from [10.72.12.50] (ovpn-12-50.pek2.redhat.com [10.72.12.50])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 676EC5B4CC;
        Sat,  7 Nov 2020 00:55:44 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: send dentry lease metrics to MDS daemon
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20201106043021.966064-1-xiubli@redhat.com>
 <f1ed301fe531b26c83769dec3c1cbc1820e5bead.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5282809b-e338-a897-d46c-7307f9da3f9a@redhat.com>
Date:   Sat, 7 Nov 2020 08:55:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <f1ed301fe531b26c83769dec3c1cbc1820e5bead.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/6 22:24, Jeff Layton wrote:
> On Thu, 2020-11-05 at 23:30 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For the old ceph version, if it received this one metric message
>> containing the dentry lease metric info, it will just ignore it.
>>
>> URL: https://tracker.ceph.com/issues/43423
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/metric.c | 18 +++++++++++++++---
>>   fs/ceph/metric.h | 14 ++++++++++++++
>>   2 files changed, 29 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index fee4c4778313..5ec94bd4c1de 100644
>> --- a/fs/ceph/metric.c
>> +++ b/fs/ceph/metric.c
>> @@ -16,6 +16,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>>   	struct ceph_metric_read_latency *read;
>>   	struct ceph_metric_write_latency *write;
>>   	struct ceph_metric_metadata_latency *meta;
>> +	struct ceph_metric_dlease *dlease;
>>   	struct ceph_client_metric *m = &mdsc->metric;
>>   	u64 nr_caps = atomic64_read(&m->total_caps);
>>   	struct ceph_msg *msg;
>> @@ -25,7 +26,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>>   	s32 len;
>>   
>>
>>   	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
>> -	      + sizeof(*meta);
>> +	      + sizeof(*meta) + sizeof(*dlease);
>>   
>>
>>   	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
>>   	if (!msg) {
>> @@ -42,8 +43,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>>   	cap->ver = 1;
>>   	cap->compat = 1;
>>   	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
>> -	cap->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_hit));
>> -	cap->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_mis));
>> +	cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
>> +	cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
>>   	cap->total = cpu_to_le64(nr_caps);
>>   	items++;
>>   
>>
>> @@ -83,6 +84,17 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>>   	meta->nsec = cpu_to_le32(ts.tv_nsec);
>>   	items++;
>>   
>>
>> +	/* encode the dentry lease metric */
>> +	dlease = (struct ceph_metric_dlease *)(meta + 1);
>> +	dlease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
>> +	dlease->ver = 1;
>> +	dlease->compat = 1;
>> +	dlease->data_len = cpu_to_le32(sizeof(*dlease) - 10);
>> +	dlease->hit = cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
>> +	dlease->mis = cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
>> +	dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
>> +	items++;
>> +
>>   	put_unaligned_le32(items, &head->num);
>>   	msg->front.iov_len = len;
>>   	msg->hdr.version = cpu_to_le16(1);
>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>> index 710f3f1dceab..af6038ff39d4 100644
>> --- a/fs/ceph/metric.h
>> +++ b/fs/ceph/metric.h
>> @@ -27,6 +27,7 @@ enum ceph_metric_type {
>>   	CLIENT_METRIC_TYPE_READ_LATENCY,	\
>>   	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
>>   	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
>> +	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
>>   						\
>>   	CLIENT_METRIC_TYPE_MAX,			\
>>   }
>> @@ -80,6 +81,19 @@ struct ceph_metric_metadata_latency {
>>   	__le32 nsec;
>>   } __packed;
>>   
>>
>> +/* metric dentry lease header */
>> +struct ceph_metric_dlease {
>> +	__le32 type;     /* ceph metric type */
>> +
>> +	__u8  ver;
>> +	__u8  compat;
>> +
>> +	__le32 data_len; /* length of sizeof(hit + mis + total) */
>> +	__le64 hit;
>> +	__le64 mis;
>> +	__le64 total;
>> +} __packed;
>> +
>>   struct ceph_metric_head {
>>   	__le32 num;	/* the number of metrics that will be sent */
>>   } __packed;
> Thanks Xiubo,
>
> Merged into testing branch and should make v5.11.

Thanks Jeff :-)

BRs


