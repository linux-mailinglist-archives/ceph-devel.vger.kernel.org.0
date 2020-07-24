Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A222D1DF
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Jul 2020 00:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGXWjk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Jul 2020 18:39:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52544 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726154AbgGXWjk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 Jul 2020 18:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595630379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0/yrVVvBFpbVLGtjg9BIVcVSpGW/KIfg/pzZfnVMQo=;
        b=EPVjtaO+NHuOR/9ASzCKXcrM4e91/QqJU+GCfa0wye1X5F8X71dLPEnUUTXQcJfeEa3W0l
        gGriqzdvEUcO23d3HXnzQRsxQ8sK9QC8NS06Zs3uL2nbv+gJVZcsb1Wxn8s5fPPhi3kz85
        Tj38tGwPhvrsV+cu+kYptojYLMsCTlA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-1GVeH211NVSSxWx0s8jABg-1; Fri, 24 Jul 2020 18:39:37 -0400
X-MC-Unique: 1GVeH211NVSSxWx0s8jABg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 008CC800468;
        Fri, 24 Jul 2020 22:39:36 +0000 (UTC)
Received: from [10.72.12.99] (ovpn-12-99.pek2.redhat.com [10.72.12.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0A1287E01;
        Fri, 24 Jul 2020 22:39:34 +0000 (UTC)
Subject: Re: [PATCH] ceph: eliminate unused "total" variable in
 ceph_mdsc_send_metrics
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
References: <20200724194534.61016-1-jlayton@kernel.org>
 <c4268b969311a56f1411ac2e893b473d47662c22.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a938e6b6-7fdb-2030-deff-bda4ba0a438e@redhat.com>
Date:   Sat, 25 Jul 2020 06:39:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c4268b969311a56f1411ac2e893b473d47662c22.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/25 4:10, Jeff Layton wrote:
> On Fri, 2020-07-24 at 15:45 -0400, Jeff Layton wrote:
>> Cc: Xiubo Li <xiubli@redhat.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>   fs/ceph/metric.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
> Xiubo, if this looks OK I can squash this into the original patch since
> it's not merged upstream yet.

Hi Jeff,

Yeah, this is okay. Thanks.

BRs


> Thanks,
> Jeff
>
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index 252d6a3f75d2..2466b261fba2 100644
>> --- a/fs/ceph/metric.c
>> +++ b/fs/ceph/metric.c
>> @@ -20,7 +20,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>>   	u64 nr_caps = atomic64_read(&m->total_caps);
>>   	struct ceph_msg *msg;
>>   	struct timespec64 ts;
>> -	s64 sum, total;
>> +	s64 sum;
>>   	s32 items = 0;
>>   	s32 len;
>>   
>> @@ -53,7 +53,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>>   	read->ver = 1;
>>   	read->compat = 1;
>>   	read->data_len = cpu_to_le32(sizeof(*read) - 10);
>> -	total = m->total_reads;
>>   	sum = m->read_latency_sum;
>>   	jiffies_to_timespec64(sum, &ts);
>>   	read->sec = cpu_to_le32(ts.tv_sec);
>> @@ -66,7 +65,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>>   	write->ver = 1;
>>   	write->compat = 1;
>>   	write->data_len = cpu_to_le32(sizeof(*write) - 10);
>> -	total = m->total_writes;
>>   	sum = m->write_latency_sum;
>>   	jiffies_to_timespec64(sum, &ts);
>>   	write->sec = cpu_to_le32(ts.tv_sec);
>> @@ -79,7 +77,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>>   	meta->ver = 1;
>>   	meta->compat = 1;
>>   	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
>> -	total = m->total_metadatas;
>>   	sum = m->metadata_latency_sum;
>>   	jiffies_to_timespec64(sum, &ts);
>>   	meta->sec = cpu_to_le32(ts.tv_sec);


