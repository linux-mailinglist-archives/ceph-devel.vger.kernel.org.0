Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9254F153C5F
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2020 01:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgBFA5n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 19:57:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37220 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727149AbgBFA5n (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Feb 2020 19:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580950662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TbzGPTt17vaz1OKWG7eSkGVphUIcB6gOY/R+QL0EI4k=;
        b=WeurwFEF+skC/8Quy+0wLOOfse9lADYt4o0asmxjMFnbG5q9JBo4Kx26sEtebnQIZllooo
        uIFSvgyq6UppWB2hRYgOuOv9VmJKGJEXAhoIMyIRfnGbCVitGWHoBj0/kX1F+pa/cLguh2
        4Vp6xVRa/Zge9rrsM459+pxR7HXyuFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-ie8wNQUHPRSbKBH7TuYCXQ-1; Wed, 05 Feb 2020 19:57:38 -0500
X-MC-Unique: ie8wNQUHPRSbKBH7TuYCXQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 515BD141B;
        Thu,  6 Feb 2020 00:57:37 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 827C510013A1;
        Thu,  6 Feb 2020 00:57:32 +0000 (UTC)
Subject: Re: [PATCH resend v5 04/11] ceph: add r_end_stamp for the osdc
 request
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200129082715.5285-1-xiubli@redhat.com>
 <20200129082715.5285-5-xiubli@redhat.com>
 <6edd0eca025a4e1f1da719406219f8770e6cef91.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d8657812-f8d7-cc94-cdd0-ca495137032a@redhat.com>
Date:   Thu, 6 Feb 2020 08:57:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6edd0eca025a4e1f1da719406219f8770e6cef91.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/6 3:14, Jeff Layton wrote:
> On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Grab the osdc requests' end time stamp.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   include/linux/ceph/osd_client.h | 1 +
>>   net/ceph/osd_client.c           | 2 ++
>>   2 files changed, 3 insertions(+)
>>
>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>> index 9d9f745b98a1..00a449cfc478 100644
>> --- a/include/linux/ceph/osd_client.h
>> +++ b/include/linux/ceph/osd_client.h
>> @@ -213,6 +213,7 @@ struct ceph_osd_request {
>>   	/* internal */
>>   	unsigned long r_stamp;                /* jiffies, send or check time */
>>   	unsigned long r_start_stamp;          /* jiffies */
>> +	unsigned long r_end_stamp;          /* jiffies */
>>   	int r_attempts;
>>   	u32 r_map_dne_bound;
>>   
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 8ff2856e2d52..108c9457d629 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -2389,6 +2389,8 @@ static void finish_request(struct ceph_osd_request *req)
>>   	WARN_ON(lookup_request_mc(&osdc->map_checks, req->r_tid));
>>   	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
>>   
>> +	req->r_end_stamp = jiffies;
>> +
>>   	if (req->r_osd)
>>   		unlink_request(req->r_osd, req);
>>   	atomic_dec(&osdc->num_requests);
> Maybe fold this patch into #6 in this series? I'd prefer to add the new
> field along with its first user.

Sure, will merge it.

Thanks.

