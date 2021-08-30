Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF493FB65B
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Aug 2021 14:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhH3MtK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Aug 2021 08:49:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51709 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232248AbhH3MtK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 08:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630327696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PR7/95QBaVE18RlzC38ACjlSui4TwR4fjVQ7XD+Q64=;
        b=L7t+nkMpH01uLYJKMLNvNr23c/Moibbk+uNdw3RNERf4yQ3RkuRm2b0Rx/yZLZfSPIaIHA
        dQHWTOY4wJPQIm95QqmMP9mrbSNZ2JKZBhLYzueS02QStNj210dw0MfhfL+zJrvrWTmZQm
        setS/Exus+UkRH68bwDpFY3gn8le39U=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-vgMzf_0kORau_6MAhIIejg-1; Mon, 30 Aug 2021 08:48:14 -0400
X-MC-Unique: vgMzf_0kORau_6MAhIIejg-1
Received: by mail-pj1-f69.google.com with SMTP id r13-20020a17090a4dcdb0290176dc35536aso1337639pjl.8
        for <ceph-devel@vger.kernel.org>; Mon, 30 Aug 2021 05:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9PR7/95QBaVE18RlzC38ACjlSui4TwR4fjVQ7XD+Q64=;
        b=qOFvqMrTN513FixhHTvWXH/Gju7Dtb91zJ2yk2XSF3EMJpoI/b/CnLKvn02Hdrz7+V
         TqQ+wSrPYCEttZd04zyYsBXfua2uesm4Q6qJV/1ak6LPz2fhELzo6DW451JlPhgiwuLz
         rHYORNNSSDNdLrdCYhYuWPQb1H4EE6vdWP0OgGm7qaaHsBdW7jtiVf0xa7epMQdFcVk2
         HcRmjj7GhF8US8q+gzonO29+m9yjXZl01NiictjS6LJ7rtLDqfZfN6GJIpm+pFJbAZTK
         K1jSPSmhag2uE7SS5y4vckD26BiwrSBtjGl2YYwm+21si42CcyQ2j6aGLF+spXHP9NOV
         qrjw==
X-Gm-Message-State: AOAM532hjnH0rGNW5MpTt1VGhaozRemM7v6BwPQNsd1Z68pbLE9j5QEe
        lmT5yCvYEBqj8IjNhSbrKQWhVTej9a2lXqls5BH4u+b9jkn9CZ5/RlQzNZOTqnwPfLJjUoTpqv+
        Mq7fJS6ExwaK9GGrOY/l5VB/gYhcnUwZ0Jzb5TvKbLQc5l80ffZzfFkQY/9jLqQSR+xQmauY=
X-Received: by 2002:a63:154d:: with SMTP id 13mr21408574pgv.404.1630327693514;
        Mon, 30 Aug 2021 05:48:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPIyuP7PbUe9tq4pcN0BNL4RgVwhTBokeljEdkISpUUpoeS5Yj+bCc/bp6dJVG1iJodJRQHA==
X-Received: by 2002:a63:154d:: with SMTP id 13mr21408550pgv.404.1630327693118;
        Mon, 30 Aug 2021 05:48:13 -0700 (PDT)
Received: from [10.72.12.157] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id br3sm18807810pjb.52.2021.08.30.05.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 05:48:12 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix incorrectly counting the export targets
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20210830123326.487715-1-xiubli@redhat.com>
 <4b2691ea8c503fcd0e1b25a61155bca8fe0cc2fd.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3e1d0567-e334-e190-7a9a-28ea744b7ee9@redhat.com>
Date:   Mon, 30 Aug 2021 20:48:07 +0800
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

Wait, I have sent the V2 to fix:

- s/m_num_active_mds/possible_max_rank/

Thanks.


>
> Thanks,

