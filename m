Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DC43E1519
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Aug 2021 14:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241530AbhHEMxT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Aug 2021 08:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241535AbhHEMxQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Aug 2021 08:53:16 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89531C06179B;
        Thu,  5 Aug 2021 05:53:01 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so9153081pjb.2;
        Thu, 05 Aug 2021 05:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BU77sf7xzIvRwh5goFFmMNFMuNqmBOnkMiEiz3vg3H8=;
        b=lPu8QbrCC0GfZOFqovmt2ITkMV4/39Mn3HuQdnvfqMJ0/7ePozTMm45XiQU8R7bZYg
         wUgt9DgxjVuwrMXwvgtoL6eR8UFX3B4a5rONheat0OJnfUedXZKQ/kQesp7UYYbMNde5
         +hD9Nx/U6mVO4uG00X0xNLzwmSDuoEaQWVupk/XqESszul8IpNMIy5h7IKQmlk9Dpvnv
         yxMVlk/x4JTVM6Zr/gmIq9LJ3l2wnQChJ/STI64CL2IA5LYzi8pwgtRJQH9f0OXv6D3I
         fiyQWEAEqM4Ugw3kLe6j2ojLNItBuUU3p1E1NUicBh7s4ZPL3pTkwcTBYqhEgQ8gcwAt
         Qy4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BU77sf7xzIvRwh5goFFmMNFMuNqmBOnkMiEiz3vg3H8=;
        b=LXSl9IGc2BwaE25O5mYABbvxgsNtfjLINmp5aMfd7ksoKVTfF766UPiBVvt36ma8DY
         Vu9slHwceliXcaqBiFUq4DbciUn7+ggbdf7CMXF35IN+1bYwdkKlXjPYzVPFAG4tdAC3
         Hd0wPF5nd0vHjHbe8qaf5K3Kd9MvjcOMeTrK94j6A+rXd+yiksNib9g77wN9vvYd0B3k
         1c4+MblFLswNbNs2s8Jips59tjDAAR2E4cSS3JCXya19lc6YoFGfReWsZzJWllQvdZrN
         g4gHeNEbh3BtQ64sdF8Yfya7wwpL1oUaz0CtogMXjFOPL0aSRRwekQYXt1JkLeYG4dHm
         EkXQ==
X-Gm-Message-State: AOAM533iRDIgUVpJ0vIStGF8hn37Y1qGag7wVUcUQE0RJJ5f+9WaZkvc
        ytPMlsRCgwIo7E/59D7vldI=
X-Google-Smtp-Source: ABdhPJx7XRXisDhFAh4H/NwSHWH3YPmbdTyG/ODnMuWBcjqqHE1b+fjmlVXUmh7eLSqw67+7C1v/ug==
X-Received: by 2002:a17:90a:f002:: with SMTP id bt2mr4795630pjb.142.1628167981168;
        Thu, 05 Aug 2021 05:53:01 -0700 (PDT)
Received: from [10.114.0.66] ([45.135.186.81])
        by smtp.gmail.com with ESMTPSA id g6sm6789881pfh.111.2021.08.05.05.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 05:53:00 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix possible null-pointer dereference in
 ceph_mdsmap_decode()
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, TOTE Robot <oslab@tsinghua.edu.cn>
References: <20210805122015.129824-1-islituo@gmail.com>
 <ea6c827bcef4a0e424641f5eae2e17b2d0d8ebbe.camel@kernel.org>
From:   Tuo Li <islituo@gmail.com>
Message-ID: <2f3266d3-cf95-ca8c-2b61-8a906e21bc38@gmail.com>
Date:   Thu, 5 Aug 2021 20:52:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ea6c827bcef4a0e424641f5eae2e17b2d0d8ebbe.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks for your feedback. It sounds good to put an "if (m->m_info)" around
the for loop to fix this bug, as well as avoid other potential bugs 
caused by calling
ceph_mdsmap_destroy(). I think we can prepare a V2 patch according to 
your advice.


On 2021/8/5 20:29, Jeff Layton wrote:
> On Thu, 2021-08-05 at 05:20 -0700, Tuo Li wrote:
>> kcalloc() is called to allocate memory for m->m_info, and if it fails,
>> ceph_mdsmap_destroy() behind the label out_err will be called:
>>    ceph_mdsmap_destroy(m);
>>
>> In ceph_mdsmap_destroy(), m->m_info is dereferenced through:
>>    kfree(m->m_info[i].export_targets);
>>
>> To fix this possible null-pointer dereference, if memory allocation
>> for m->m_info fails, free m and return -ENOMEM.
>>
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Tuo Li <islituo@gmail.com>
>> ---
>>   fs/ceph/mdsmap.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>> index abd9af7727ad..7d73e4b64b12 100644
>> --- a/fs/ceph/mdsmap.c
>> +++ b/fs/ceph/mdsmap.c
>> @@ -166,8 +166,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>>   	m->possible_max_rank = max(m->m_num_active_mds, m->m_max_mds);
>>   
>>   	m->m_info = kcalloc(m->possible_max_rank, sizeof(*m->m_info), GFP_NOFS);
>> -	if (!m->m_info)
>> -		goto nomem;
>> +	if (!m->m_info) {
>> +		kfree(m);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>>   
>>   	/* pick out active nodes from mds_info (state > 0) */
>>   	for (i = 0; i < n; i++) {
> Good catch. This function is already pretty complex. How about we
> instead fix this in ceph_mdsmap_destroy and make it safe to call that
> with the mdsmap in this state?
>
> Basically, just put an "if (m->m_info)" around the for loop in that
> function. Sound ok?
>

