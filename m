Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5B5281F60
	for <lists+ceph-devel@lfdr.de>; Sat,  3 Oct 2020 01:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgJBXuL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Oct 2020 19:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgJBXuL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Oct 2020 19:50:11 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39473C0613E2
        for <ceph-devel@vger.kernel.org>; Fri,  2 Oct 2020 16:50:11 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id v8so3348036iom.6
        for <ceph-devel@vger.kernel.org>; Fri, 02 Oct 2020 16:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y34GUHs7y+dhv/PBEvBFpzMJQXZxzed838y/lOyLkeg=;
        b=OwYWHVGo0duTZnucRDmSw4KE0SR/5oK6MjUHXkaXaZfKd4ZipqfpuD49mVhiJKjZlv
         foof3M7EwOlISDCGFPniEcCoGb9R3GMBYpjtj1kdCbWhzCtglUC2Y3AhMXI56dvI4IB3
         12EP7mBPUzV7Y/Dkj7rbuTUXufEgWwpYYDz5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y34GUHs7y+dhv/PBEvBFpzMJQXZxzed838y/lOyLkeg=;
        b=hApP+VZpFKQ92xIW8OCO1ltVzMEG6lyE4pQqrllKLzka3P+yrsYT0ZRd9oOKL93Ucz
         hwhthfweMfN9FPtRNvMPevejvq9p4wh1wBKkEG6hqBDVt9F9NvuE0gkMro+kEz8e0Nkp
         U8wp3XuxZgU85Ctf9fKupZNlj2FmwOZd2wOK284aba/vvCyj658Qe8BAJV3m5uX4UZEk
         BGSffnktcG0BgX5E7K+LZIQD83KzlsIxMmtqVoIU+qY25+KJ5w1DCcctQA+na+BTjbxP
         gR4ezm7TTLTZ1/CfhhZNACfVvcfrlLX0AbKsogFVI3ggKfT3HmlH1NXFPr2j8xIL07Un
         i/xg==
X-Gm-Message-State: AOAM5339JmhSvB80pDAOoOKMjzDPioXD1UwfkmgWKLwDcDqOnyN0hple
        0Vo0xsMYZ2sC3e82ysf9QU5DnyM+jUuV0g==
X-Google-Smtp-Source: ABdhPJzSBEr+9V1AlHXCphfVeGtDS7AVdMlZMDMld9vw+ZO1HhBVd/1CspUbOw5A51Sn4k2ViZQJgQ==
X-Received: by 2002:a6b:7909:: with SMTP id i9mr3399241iop.98.1601682610398;
        Fri, 02 Oct 2020 16:50:10 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z13sm1571063ilm.53.2020.10.02.16.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 16:50:09 -0700 (PDT)
Subject: Re: drivers/block/rbd.c: atomic_inc_return_safe() &
 atomic_dec_return_safe()
To:     Jens Axboe <axboe@kernel.dk>, idryomov@gmail.com,
        dongsheng.yang@easystack.cn
Cc:     ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <ce2dbec5-00f8-831b-3138-cc4f3b8fdb51@linuxfoundation.org>
 <c2dd3223-bda1-be8c-fbc4-9c0eec63bc9d@kernel.dk>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a3f6c88f-5b0f-0da0-c5ad-dd40ea36f4a5@linuxfoundation.org>
Date:   Fri, 2 Oct 2020 17:50:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c2dd3223-bda1-be8c-fbc4-9c0eec63bc9d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 10/2/20 5:44 PM, Jens Axboe wrote:
> On 10/2/20 4:34 PM, Shuah Khan wrote:
>> All,
>>
>> I came across these atomic_inc_return_safe() & atomic_dec_return_safe()
>> functions that hold the counters at safe values.
>>
>> atomic_inc_return_safe()
>>
>> If the counter is already 0 it will not be incremented.
>> If the counter is already at its maximum value returns
>> -EINVAL without updating it.
>>
>> atomic_dec_return_safe()
>>
>> Decrement the counter.  Return the resulting value, or -EINVAL
>>
>> These two routines are static and only used in rbd.c.
>>
>> Can these become part of atomic_t ops?
> 
> I think you just want to use refcount_t for this use case. They
> have safe guards for under/overflow.
> 

Makes sense. Guess these came before refcount_t.

I will track this for refcount_t conversion.

thanks,
-- Shuah
