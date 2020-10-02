Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4019281F53
	for <lists+ceph-devel@lfdr.de>; Sat,  3 Oct 2020 01:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgJBXo0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Oct 2020 19:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgJBXoZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Oct 2020 19:44:25 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9499AC0613E2
        for <ceph-devel@vger.kernel.org>; Fri,  2 Oct 2020 16:44:25 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z19so2442059pfn.8
        for <ceph-devel@vger.kernel.org>; Fri, 02 Oct 2020 16:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T60HK5Q7D6JLnVa3qZA2HNweMkJrSWboQgR5a+8Fct8=;
        b=B7XEXV9M0OT5GTpwanKbTTtkEHvMmPsHY4Kc7Ve698U93E0ptn3c8qz/HZJolqb9WW
         ZVXA20ktYRV7UVpQawMwuWelUEcX+xC5JKh8aB516hjPPBcN1KwSA27VRE4+zDeNS+oj
         RlsLXbKdeqaVViYts3zepnnC2hXkvPT5vdR6tV888MJcNz37BhMLDa+lE8xC6wDZPDov
         jI4faa4jzKxRdl+NJwTrTA1PAwqghUpmKqtN/O8BIZP6pPhAqepFrk3Gilya1OzYOe7r
         BIE93gUTaxKkNfr9d4oJ++Sgmf9+RqqsdpL+4qRi8lPllSkY3Hw0lKvP27gAXblL5l5a
         OmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T60HK5Q7D6JLnVa3qZA2HNweMkJrSWboQgR5a+8Fct8=;
        b=raKbtPEioVzFfjmIoKT7UdxKQ+RJWqFvePkQoD8lN+Uzy6wyp1UIpmtWxFsJXF/tRC
         DWJb9EGQDf2JM6ywyUsEheL08VCK6B1WL7ZHdmEsIgV0na+YkewRrS7BDSOtwGp6EKR7
         Aou9wQZGn8otVYxPKvD0sBotzBGyZBMaS3nHbYnjsodLtdzM4NHTA9ujP13QasLF7xwH
         TmF9s3v8hO5Wq+slPgIh+k+3vOh+uUmZ9c6hyixM7tWjFnMIzi7WPBEqc8hIMuG7FtOt
         cgksm/R+sscq412wOV3tEt8TQvG1m9/2wt9rtSzmBpxL12jNDljZyLB2DDGvSowE12Dv
         HzWw==
X-Gm-Message-State: AOAM533mClNGfgXNtanChpJvTfzWBWAk4m32Nt5M0HrBQqA2NdWXbzY1
        prP2QHLv3YjJSoHynFZQG/8tIw==
X-Google-Smtp-Source: ABdhPJy0ZnLQs/bW0VZEl2sOXT3MyOLLZHiNoz0Wo/r5F+upgVHDHgaFm1w6+JvrEjyJBICPM3MyXA==
X-Received: by 2002:a63:f006:: with SMTP id k6mr4331497pgh.88.1601682264925;
        Fri, 02 Oct 2020 16:44:24 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id gw1sm2783871pjb.36.2020.10.02.16.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 16:44:24 -0700 (PDT)
Subject: Re: drivers/block/rbd.c: atomic_inc_return_safe() &
 atomic_dec_return_safe()
To:     Shuah Khan <skhan@linuxfoundation.org>, idryomov@gmail.com,
        dongsheng.yang@easystack.cn
Cc:     ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>
References: <ce2dbec5-00f8-831b-3138-cc4f3b8fdb51@linuxfoundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c2dd3223-bda1-be8c-fbc4-9c0eec63bc9d@kernel.dk>
Date:   Fri, 2 Oct 2020 17:44:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ce2dbec5-00f8-831b-3138-cc4f3b8fdb51@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 10/2/20 4:34 PM, Shuah Khan wrote:
> All,
> 
> I came across these atomic_inc_return_safe() & atomic_dec_return_safe()
> functions that hold the counters at safe values.
> 
> atomic_inc_return_safe()
> 
> If the counter is already 0 it will not be incremented.
> If the counter is already at its maximum value returns
> -EINVAL without updating it.
> 
> atomic_dec_return_safe()
> 
> Decrement the counter.  Return the resulting value, or -EINVAL
> 
> These two routines are static and only used in rbd.c.
> 
> Can these become part of atomic_t ops?

I think you just want to use refcount_t for this use case. They
have safe guards for under/overflow.

-- 
Jens Axboe

