Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC0A3FB67D
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Aug 2021 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhH3MyE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Aug 2021 08:54:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232454AbhH3MyD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 08:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630327989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b1faBPiJN3Bta+IpACtbZjO67c4OmK8mLkqFcOkSAjM=;
        b=PcUBkHTkx0WkJ++H545U8n4eB4W/TQyyLuWI+z8ivlcvyj+r4QpK14+6paUe7BTCuqp/zA
        mFdogkd2o+07K9h+m/D8aHoqys+6lJVVoQBTn+xqrJdTQsFr/M7lB2mh/tEBCtoLVKyay5
        ZmNZohsD/kgoiWvxxRoSmyDjHXHNLVo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-jIL3p8CONmqOEVrQxwsTsQ-1; Mon, 30 Aug 2021 08:53:08 -0400
X-MC-Unique: jIL3p8CONmqOEVrQxwsTsQ-1
Received: by mail-pf1-f197.google.com with SMTP id b65-20020a621b44000000b003edc0db6a05so342131pfb.19
        for <ceph-devel@vger.kernel.org>; Mon, 30 Aug 2021 05:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=b1faBPiJN3Bta+IpACtbZjO67c4OmK8mLkqFcOkSAjM=;
        b=Aj1ecJ9fzR9RZ1JthljUVUdja9wtzEjqDKhBtnEp4Cc6yAZWq8VhUro+JG5wvIqUNK
         fz+GJfNwHMvIk3HUaa9A5mneht8XEmIKVxNmkdHknmmovh2O1crT32il1oPtxxYVTRZD
         A4FCFZzcFbwnfjsDtiD0ZXnIBGxl9xfr/Sd+EuPk86yw+IslRDGicqyABLTwaxWmSXrx
         F1rJe2/C0KFDvs/B6CI53GgZYtVK9ql5HRD3G10215wtkhtZwBiJrS4us0/wGQVxB4dV
         z2CiwEnxlOqIfZe7qA/fS5I1ZOVcopy/AMCq7B7yn9TwQ1PZ7YzTDKySJRQVizVUV9ly
         8wJA==
X-Gm-Message-State: AOAM5327puo9pMcDkWm3lL1swlsGRpcOGBQXacO9Tk1h6tWbk9OtSIHt
        0geiyd3X/DJzLLjDvcqR4ZOz9mCmH2FdlZgZn7PDvMb91h2S1gkbA/3msCU5yJlN7i6uJI5gNL5
        REKUGsI5jkmZERrU49/MiKbDmlXkiRHqMQ7Kw7Q2UXaVfbr03ZenW5rYQ1uRP8TpRAuuN7Sc=
X-Received: by 2002:a17:902:6b8c:b0:12d:b95c:30fb with SMTP id p12-20020a1709026b8c00b0012db95c30fbmr21316207plk.81.1630327987120;
        Mon, 30 Aug 2021 05:53:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwP0iN5BGIDOFWGbtFByFH+z8GnKOoS8iUKf6zImttyhlxmgB6jdcsyOC3r6GW1E9UeZlOkw==
X-Received: by 2002:a17:902:6b8c:b0:12d:b95c:30fb with SMTP id p12-20020a1709026b8c00b0012db95c30fbmr21316182plk.81.1630327986782;
        Mon, 30 Aug 2021 05:53:06 -0700 (PDT)
Received: from [10.72.12.157] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c64sm14125320pfc.8.2021.08.30.05.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 05:53:06 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix incorrectly counting the export targets
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20210830123326.487715-1-xiubli@redhat.com>
 <4b2691ea8c503fcd0e1b25a61155bca8fe0cc2fd.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <214b1f2c-e7a0-f1d6-5910-89e7e2c927d1@redhat.com>
Date:   Mon, 30 Aug 2021 20:53:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4b2691ea8c503fcd0e1b25a61155bca8fe0cc2fd.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/30/21 8:45 PM, Jeff Layton wrote:
> On Mon, 2021-08-30 at 20:33 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 7ddc36c14b92..aa0ab069db40 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4434,7 +4434,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   			  struct ceph_mdsmap *newmap,
>>   			  struct ceph_mdsmap *oldmap)
>>   {
>> -	int i, err;
>> +	int i, j, err;
>>   	int oldstate, newstate;
>>   	struct ceph_mds_session *s;
>>   	unsigned long targets[DIV_ROUND_UP(CEPH_MAX_MDS, sizeof(unsigned long))] = {0};
>> @@ -4443,8 +4443,10 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   	     newmap->m_epoch, oldmap->m_epoch);
>>   
>>   	if (newmap->m_info) {
>> -		for (i = 0; i < newmap->m_info->num_export_targets; i++)
>> -			set_bit(newmap->m_info->export_targets[i], targets);
>> +		for (i = 0; i < newmap->m_num_active_mds; i++) {
>> +			for (j = 0; j < newmap->m_info[i].num_export_targets; j++)
>> +				set_bit(newmap->m_info[i].export_targets[j], targets);
>> +		}
>>   	}
>>   
>>   	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
> Looks sane. I'll plan to fold this into "ceph: reconnect to the export
> targets on new mdsmaps".

Why my previous test worked well, it should be there has only one active 
mds. And for the 'newmap->m_info->export_target' it will always equal to 
'newmap->m_info[0].export_target', but I am not very sure why this could 
cause crash.


> Thanks,

