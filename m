Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1904144640C
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 14:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhKENZN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 09:25:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232608AbhKENZM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Nov 2021 09:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636118548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBG5mOtNJOxtexJgD6dK2zf8UGOYXqdyAOexBF7Kdj0=;
        b=R6CXdPX6cloKMi78lRVp6wpK37Ld+V9twaAkvwY/C2+tb2a7vAKEYbBECpvpSZqS8Va+KC
        /JxMbsb74GZh9g8HtCBLSdGlry2VL4ICE4P9sKhmScK0buyBV+v/u6yPJalSvaNneWcKEB
        9zYoHR5ZAUPsBRWlCqmIWx3XIOiuPS8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-JDur6CJEM3OSd90jWO4QEg-1; Fri, 05 Nov 2021 09:22:27 -0400
X-MC-Unique: JDur6CJEM3OSd90jWO4QEg-1
Received: by mail-pj1-f72.google.com with SMTP id o4-20020a17090a3d4400b001a66f10df6cso2033058pjf.0
        for <ceph-devel@vger.kernel.org>; Fri, 05 Nov 2021 06:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OBG5mOtNJOxtexJgD6dK2zf8UGOYXqdyAOexBF7Kdj0=;
        b=wATIPYtyUOa4Tyyq+PHFEKpHe97U2krCzgfzTXOrPRJy/LkZLFxzns8HuXhHxkEAbW
         dJHYXR81OnW0psHI2qVWTFnCIyIox7LjZGCLAH/hLqqVCXkMFk3R0Dp0wye13xVDMsyE
         O4unoEvBOhZevN5ZS8VQGBJQ8JQB9g2sqGY4z/wJLszj+U09/0hU3lO/5KL6uQaVPugc
         Lp5JtxHb6xAm5Arkwh17m6tAKmny3dgXNmVIoI1mbVTgMCfkgIzAvkfFLJECJWJxpdvF
         DpT0sDvVu0WGTONG4wXalDpSj/vDKnrKbCfNaS93Gg0SVDRXk+Ts6M60/WnQs6v/99md
         9wFQ==
X-Gm-Message-State: AOAM530xg27YgIVDNSKA3Pr6W/G0j+wsiCz+rrHMmQBxAkG0h7Otu7HD
        jVzbSufw2T0uvD8dIZ9a+t9zuA9Oil7ciOA2yjnjx/IDgpOZ/reFQIhSLUF4l95bDsp0xyjfNMM
        krBWk9wHyMjUb7riRvBWB4oB+6RwvW92uK3xk+YyPzHOIZ45InyjOt52bTy7ZswmxLBmTWZQ=
X-Received: by 2002:a17:90a:7a81:: with SMTP id q1mr30377705pjf.1.1636118546418;
        Fri, 05 Nov 2021 06:22:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9s4G64kZrYLypETMDwvmtctP1oWTf26NkRa4oAk4MDWQdPT8Ha1SGuTfi5+6oDnf7If4sQw==
X-Received: by 2002:a17:90a:7a81:: with SMTP id q1mr30377664pjf.1.1636118546079;
        Fri, 05 Nov 2021 06:22:26 -0700 (PDT)
Received: from [10.72.12.174] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q21sm1576020pfu.124.2021.11.05.06.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 06:22:25 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix incorrectly decoding the mdsmap bug
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211105093418.261469-1-xiubli@redhat.com>
 <a8651d8cec901eff76d35f2ef9d05b093d1e1d1a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b8cc0800-ff3c-d3e8-bc72-c9b0a1e463dd@redhat.com>
Date:   Fri, 5 Nov 2021 21:22:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a8651d8cec901eff76d35f2ef9d05b093d1e1d1a.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/5/21 6:29 PM, Jeff Layton wrote:
> On Fri, 2021-11-05 at 17:34 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When decreasing the 'max_mds' in the cephfs cluster, when the extra
>> MDS or MDSes are not removed yet, the mdsmap may only decreased the
>> 'max_mds' but still having the that or those MDSes 'in' or in the
>> export targets list.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mdsmap.c | 4 ----
>>   1 file changed, 4 deletions(-)
>>
>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>> index 61d67cbcb367..30387733765d 100644
>> --- a/fs/ceph/mdsmap.c
>> +++ b/fs/ceph/mdsmap.c
>> @@ -263,10 +263,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>>   				goto nomem;
>>   			for (j = 0; j < num_export_targets; j++) {
>>   				target = ceph_decode_32(&pexport_targets);
>> -				if (target >= m->possible_max_rank) {
>> -					err = -EIO;
>> -					goto corrupt;
>> -				}
>>   				info->export_targets[j] = target;
>>   			}
>>   		} else {
> Thanks Xiubo, looks good. Given the severity when mdsmap decoding fails,
> I think we should probably mark this for stable too. Let me know if you
> have any objections.
Yeah, it should be.

