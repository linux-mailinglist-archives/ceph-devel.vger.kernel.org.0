Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E670153C90
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2020 02:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbgBFBZG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 20:25:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25132 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727170AbgBFBZG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Feb 2020 20:25:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580952305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+MSTME2CJbQZHJYBbKFdDbXIZcJ7SBkHu55uWEaFPDA=;
        b=d3J9AZSBbMPpz1m/B9H9OmlTJDfY0VHhWjXVk17fWnXIS8c5XRaUcRX701Dz14wLCiqwph
        vW1TA5BFzOu2zVqmSW4zq6LNN38uQFbwHjKTdp0FghbZ66r+4vlN/3u9zXJqfm3m/Un6qF
        rh8ri+PrMNHQZuSX9RK3f3agewORQyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-xYK2_GiZPnS0mx1F2w-bqg-1; Wed, 05 Feb 2020 20:25:02 -0500
X-MC-Unique: xYK2_GiZPnS0mx1F2w-bqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3DD41084420;
        Thu,  6 Feb 2020 01:25:00 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E2B160BEC;
        Thu,  6 Feb 2020 01:24:50 +0000 (UTC)
Subject: Re: [PATCH resend v5 05/11] ceph: add global read latency metric
 support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200129082715.5285-1-xiubli@redhat.com>
 <20200129082715.5285-6-xiubli@redhat.com>
 <e0bbe210d52c69458828f8245f1252434713f4a9.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <54b8ba7d-fc5e-8bb3-5853-fd74c87cbf1f@redhat.com>
Date:   Thu, 6 Feb 2020 09:24:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e0bbe210d52c69458828f8245f1252434713f4a9.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/6 4:15, Jeff Layton wrote:
> On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
[...]
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 20e5ebfff389..0435a694370b 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -195,6 +195,7 @@ static int ceph_sync_readpages(struct ceph_fs_client *fsc,
>>   			       int page_align)
>>   {
>>   	struct ceph_osd_client *osdc = &fsc->client->osdc;
>> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
> nit: I think you can drop this variable and just dereference the metric
> field directly below where it's used. Ditto in other places where
> "metric" is only used once in the function.

Will fix them all.

>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 141c1c03636c..101b51f9f05d 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4182,14 +4182,29 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>>   	atomic64_set(&metric->total_dentries, 0);
>>   	ret = percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
>>   	if (ret)
>> -		return ret;
>> +		return ret;;
> drop this, please ^^^

Will fix it.

Thanks.

