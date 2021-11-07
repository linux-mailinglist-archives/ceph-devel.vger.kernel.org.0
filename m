Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E1844725E
	for <lists+ceph-devel@lfdr.de>; Sun,  7 Nov 2021 10:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhKGJrZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 7 Nov 2021 04:47:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235317AbhKGJrY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 7 Nov 2021 04:47:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636278281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBLstVJBJmAi1sbvKoO8flEz2oGze52TjMxF63au2jk=;
        b=C5OHskTZZF5VVXtGXibZ99/o09rUmBG4XrVY9l3jXh5hYA/DCPUptrq6y+OgkUQj1LB9z9
        qrRVees9puj1WrMJ4uQmsC3NM4uWknRs3nquahdXWtgiwany8JKAgBqay/EQsa2WMGY5s/
        QQYT7eLvblJ42zXfjNfEQihAM4CN9No=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-pUyp7bEbNbSpdlD7zz8McQ-1; Sun, 07 Nov 2021 04:44:40 -0500
X-MC-Unique: pUyp7bEbNbSpdlD7zz8McQ-1
Received: by mail-pj1-f72.google.com with SMTP id p12-20020a17090b010c00b001a65bfe8054so4947628pjz.8
        for <ceph-devel@vger.kernel.org>; Sun, 07 Nov 2021 01:44:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CBLstVJBJmAi1sbvKoO8flEz2oGze52TjMxF63au2jk=;
        b=36nNHmcmeiNwZM5UA4nOdLBLA+yT0dpHITtop9tP7H7UkO3tGZTKype77hm189kt9s
         MePuBaj5z1AerqYEBUI0XBHunF2jqR+J/CQ8f5mJ+eo7XMmm2gII+0oEwhwdfQEeg176
         J2G/aW0/wXrY+xHCrpIs+TpFKSr9y7s6D+M0/I0AFsMFAJBUR7wwXt++FUMr37aV6XB1
         j24Yxw0IfKYoclfAlLoJq+CcGDTr/GKMT0XI9JFCD8OOlOLlCD18kooqrmJEzH1p3uy1
         NDUSnU/Ui6Y0uKAk4cVmd6hrlxVUIV8r6b5VLPOp0D1g0TjDOlIQK83lkAYRXX34WV1s
         M02g==
X-Gm-Message-State: AOAM532mmkD/5gp94ynfznFhPiMs2BJl2W+vfhg3eWqf4jsjciBZWql5
        QstkyUyFh3slq1znZtDRcZ9PNW47WFO3b5imLPIClLV9MuzpQKy71QiSw5IPVe9Zs64sLVvHZIf
        59GNwxzPkSWVFa2e4ZeBIYx2VWUgu9Rnm3j48EbPB+DrUlqezkSYx4n+xsDk7U77EVpVq5+w=
X-Received: by 2002:a17:90b:3807:: with SMTP id mq7mr1307134pjb.38.1636278278477;
        Sun, 07 Nov 2021 01:44:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyY+z/SHDNfHD76GXH8jiOGMcwFCxXC0JTZRauhljyEzl9lezANwBGiD77B1X6Xtyiathh6XA==
X-Received: by 2002:a17:90b:3807:: with SMTP id mq7mr1307097pjb.38.1636278278092;
        Sun, 07 Nov 2021 01:44:38 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d14sm9622660pgt.64.2021.11.07.01.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 01:44:37 -0800 (PST)
Subject: Re: [PATCH v7 0/9] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211105142215.345566-1-xiubli@redhat.com>
 <946e4c63292ae901e9a0925cc678609ba9e2ba9c.camel@kernel.org>
 <3ea75e3a6ab79ea090d6ea301633716846992db2.camel@kernel.org>
 <e0fcee87-68bd-8c33-b920-867fd0ef8fa9@redhat.com>
 <98d31e0fac7d2bfb8b81b252c1b75aea40e759dc.camel@kernel.org>
 <d31b2241f72115896bc38a7ed84beecdff409afa.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a833a310-f43e-5873-afb7-dfc9e4e933b2@redhat.com>
Date:   Sun, 7 Nov 2021 17:44:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d31b2241f72115896bc38a7ed84beecdff409afa.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

[...]

>>>>> I think this patch should fix it:
>>>>>
>>>>> [PATCH] SQUASH: ensure we unset lock_snap_rwsem after unlocking it
>>>>>
>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>> ---
>>>>>    fs/ceph/inode.c | 4 +++-
>>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>>> index eebbd0296004..cb0ad0faee45 100644
>>>>> --- a/fs/ceph/inode.c
>>>>> +++ b/fs/ceph/inode.c
>>>>> @@ -2635,8 +2635,10 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>>>>    
>>>>>    	release &= issued;
>>>>>    	spin_unlock(&ci->i_ceph_lock);
>>>>> -	if (lock_snap_rwsem)
>>>>> +	if (lock_snap_rwsem) {
>>>>>    		up_read(&mdsc->snap_rwsem);
>>>>> +		lock_snap_rwsem = false;
>>>>> +	}
>>>>>    
>>>>>    	if (inode_dirty_flags)
>>>>>    		__mark_inode_dirty(inode, inode_dirty_flags);
>>>> Testing with that patch on top of your latest series looks pretty good
>>>> so far.
>>> Cool.
>>>
>>>>    I see some xfstests failures that need to be investigated
>>>> (generic/075, in particular). I'll take a harder look at that next week.
>>> I will also try this.
>>>> For now, I've gone ahead and updated wip-fscrypt-fnames to the latest
>>>> fnames branch, and also pushed a new wip-fscrypt-size branch that has
>>>> all of your patches, with the above SQUASH patch folded into #9.
>>>>
>>>> I'll continue the testing next week, but I think the -size branch is
>>>> probably a good place to work from for now.
>>> BTW, what's your test script for the xfstests ? I may miss some important.
>>>
>> I'm mainly running:
>>
>>      $ sudo ./check -g quick -E ./ceph.exclude
>>
>> ...and ceph.exclude has:
>>
>> ceph/001
>> generic/003
>> generic/531
>> generic/538
>>
>> ...most of the exclusions are because they take a long time to run.
> Oh and I should say...most of the failures I've seen with this patchset
> are intermittent. I suspect there is some race condition we haven't
> addressed yet.

Okay, my test was stuck and finally I found it just ran out of disks.

I have ran the truncate related tests all worked well till now.

I will try this more.

Thanks,

> Thanks,

