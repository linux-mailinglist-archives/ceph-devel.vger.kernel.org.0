Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544ED440D86
	for <lists+ceph-devel@lfdr.de>; Sun, 31 Oct 2021 10:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJaI7e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 31 Oct 2021 04:59:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229525AbhJaI7e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 31 Oct 2021 04:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635670622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sEdHPwcGycICwqd7CR2NCUIOwhCtdZkIpmLQTO+F46A=;
        b=bIB4BlhExvUobBrYT8HRkRMzGCd/FyO8rcvP6atY0Xe0CyK+YHkF+cz/iP2Q8ZZuMcgwex
        6hEQSZnmemDH9u5J1Fjt4m63I5rlX3U8al9yr4gwoC6xkWBtO2pdZhwHok66lUPmBHC7go
        zhWC3/1QnJD4vklkZ5fYo4Ptc8RHCbc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-HKzTlZMROySkUL8gz1VTWQ-1; Sun, 31 Oct 2021 04:57:00 -0400
X-MC-Unique: HKzTlZMROySkUL8gz1VTWQ-1
Received: by mail-pj1-f69.google.com with SMTP id jx2-20020a17090b46c200b001a62e9db321so4493116pjb.7
        for <ceph-devel@vger.kernel.org>; Sun, 31 Oct 2021 01:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sEdHPwcGycICwqd7CR2NCUIOwhCtdZkIpmLQTO+F46A=;
        b=XQuS8L6mulSzWhB8YJ6jmyYWGhprN8QnD3MCwuPhLI8dFxuB0Sr/fO+KWazc0fV0Jo
         Y1UieY3pcb7bNENm78xPIFC4rI/HqRxpoYmURcvmMzw/Rr5J8ex29DLMoUzmbxe3LQzh
         8gZnc9ZYPSWGiJ0ibyCZS+d7SljaT6fAdE4vouzgfxTQ8oGpEhHbmI0pJ1Ad3RFnuMAJ
         JHCtOLdCAKTvXYfNLl+kciOsa4Jj0b2UNQZ62Z+MY9gYgvd0hehvIaemeRD/2JD9gZHO
         RUIYUGcGzSfDKXCFAQkoc1ANLsCskIk7pNLiXOTgd1b/wDwFxkFinGl+ENqTVg2frbnO
         96hw==
X-Gm-Message-State: AOAM532GK2l5h8Xe2faOYNdz5Dv4LRzsMKuIvucUtJYWlREdFpoSfdWO
        wakXMAhk9Wkro7gTPVNtTr8brzpAbEgoCoy23jCbjlZb4WY/3DExQI1IiWTX3qmYe7us44dHqtS
        VmlDReUHYAFslI+a1SImXl7+irLH1m/5sMuy//gHkoylt31hJZu5USy0t8kH+tV/6vjHY114=
X-Received: by 2002:a17:90b:4a01:: with SMTP id kk1mr22524223pjb.208.1635670618906;
        Sun, 31 Oct 2021 01:56:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwD4Xnbq4JZJibQQs2B1F4u+z0D3Ob5ctTlwOj+6LrlkZSiQmwVifGxVjoXBg6Adgw7GpRNA==
X-Received: by 2002:a17:90b:4a01:: with SMTP id kk1mr22524199pjb.208.1635670618599;
        Sun, 31 Oct 2021 01:56:58 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o19sm6740228pfu.56.2021.10.31.01.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 01:56:57 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] ceph: add truncate size handling support for
 fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211028091438.21402-1-xiubli@redhat.com>
 <20211028091438.21402-5-xiubli@redhat.com>
 <37ca7a43ec7b9d796d4d8fb962309278c0df7d76.camel@kernel.org>
 <8603888b-a9d3-21d6-441f-d358c5e9e1ea@redhat.com>
 <fdf2815ac335c5a6ff71cd1baa9b93f488a0b05c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e8578a24-6c41-d652-019f-b2524ceb281b@redhat.com>
Date:   Sun, 31 Oct 2021 16:56:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <fdf2815ac335c5a6ff71cd1baa9b93f488a0b05c.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/30/21 6:52 PM, Jeff Layton wrote:
> On Sat, 2021-10-30 at 14:20 +0800, Xiubo Li wrote:
>> [...]
>>
>>>> @@ -2473,7 +2621,23 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>>>    		req->r_args.setattr.mask = cpu_to_le32(mask);
>>>>    		req->r_num_caps = 1;
>>>>    		req->r_stamp = attr->ia_ctime;
>>>> +		if (fill_fscrypt) {
>>>> +			err = fill_fscrypt_truncate(inode, req, attr);
>>>> +			if (err)
>>>> +				goto out;
>>>> +		}
>>>> +
>>>> +		/*
>>>> +		 * The truncate will return -EAGAIN when some one
>>>> +		 * has updated the last block before the MDS hold
>>>> +		 * the xlock for the FILE lock. Need to retry it.
>>>> +		 */
>>>>    		err = ceph_mdsc_do_request(mdsc, NULL, req);
>>>> +		if (err == -EAGAIN) {
>>>> +			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
>>>> +			     inode, err, ceph_cap_string(dirtied), mask);
>>>> +			goto retry;
>>>> +		}
>>> The rest looks reasonable. We may want to cap the number of retries in
>>> case something goes really wrong or in the case of a livelock with a
>>> competing client. I'm not sure what a reasonable number of tries would
>>> be though -- 5? 10? 100? We may want to benchmark out how long this rmw
>>> operation takes and then we can use that to determine a reasonable
>>> number of tries.
>> <7>[  330.648749] ceph:  setattr 00000000197f0d87 issued pAsxLsXsxFsxcrwb
>> <7>[  330.648752] ceph:  setattr 00000000197f0d87 size 11 -> 2
>> <7>[  330.648756] ceph:  setattr 00000000197f0d87 mtime
>> 1635574177.43176541 -> 1635574210.35946684
>> <7>[  330.648760] ceph:  setattr 00000000197f0d87 ctime
>> 1635574177.43176541 -> 1635574210.35946684 (ignored)
>> <7>[  330.648765] ceph:  setattr 00000000197f0d87 ATTR_FILE ... hrm!
>> ...
>>
>> <7>[  330.653696] ceph:  fill_fscrypt_truncate 00000000197f0d87 size
>> dropping cap refs on Fr
>> ...
>>
>> <7>[  330.697464] ceph:  setattr 00000000197f0d87 result=0 (Fx locally,
>> 4128 remote)
>>
>> It takes around 50ms.
>>
>> Shall we retry 20 times ?
>>
> Sounds like a good place to start.
>
Cool, will set it to 20 for now.

Thanks


>>> If you run out of tries, you could probably  just return -EAGAIN in that
>>> case. That's not listed in the truncate(2) manpage, but it seems like a
>>> reasonable way to handle that sort of problem.
>>>
>> [...]
>>

