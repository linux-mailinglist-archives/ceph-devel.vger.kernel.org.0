Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E39402994
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Sep 2021 15:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344746AbhIGNUt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Sep 2021 09:20:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344724AbhIGNUs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Sep 2021 09:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631020781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dVZ+L7wm6I2ZatZxJhubVxNvlKRLtcuz1pYcgVBsHL8=;
        b=KLoDmMzkEJp+YMpwtH+Nf6jkzq08sp5dyKvno9x+0W/RSXEQ2HhlhMyFdAa+yRZAnVAJIO
        AD5h9SSlz2Jbd74G+EGrfn9cOe4IvM3cWbb0k1Oc/kOnp/IAMFaQzfnHc6O0b5a1bgHtYJ
        xWSoPlcTqbLxjK/NMVwH1k714oOnoQk=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-VOBCiwbfPkSMsrpoHs9Xwg-1; Tue, 07 Sep 2021 09:19:40 -0400
X-MC-Unique: VOBCiwbfPkSMsrpoHs9Xwg-1
Received: by mail-pf1-f199.google.com with SMTP id g17-20020aa781910000b0290360a5312e3eso5099611pfi.7
        for <ceph-devel@vger.kernel.org>; Tue, 07 Sep 2021 06:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dVZ+L7wm6I2ZatZxJhubVxNvlKRLtcuz1pYcgVBsHL8=;
        b=biGqPJHLd+wZ9fbnqsKEmWdINPb1eW20E4WZA7G8qIugBGhj+b/y75kIPLUgfGbgxa
         hFUD8ude4ZV9dTPqtFyJ/ZpefxMp/d4RtkRuhBvR+IRxJnhUWlb1NOK46uoHK//+Yvrl
         TYV2nComngwOwmQ+C0uMYFQtwFS3LwYWadYDlBrOn5j96kztEyGIRXctmgn5QmIHJcKz
         k377JJP/BCShWJr/4fFKwovgi0XSf6YRTiCwdTIze1IKGQAfvt86Ty6uN70T+6BcwnQa
         SyGlUOj5oek4AIze55rglIwmrCGlEO0soXxeB4jEc+gsTd7NCCpfr3DvhRmD/OkPfoHf
         lg+A==
X-Gm-Message-State: AOAM5335pqQPxo3/litrFUvoSAeE8YwNXLfLGaPDZRdkb2B+1mRxlkva
        S+8NP1hOeiRg1jCDsnWjKS68v23MPVPpBvNH5NlFgwCdm+gSNGFs7j25i3Sv2Kjx0Y3+Fn/oHEt
        XLoA5gNb7NkGdAQ0dSgwof8u5tb5QTyUxc9psQ2USCquDbm0tJ53THf5GHQNMKAjZrA0PNEI=
X-Received: by 2002:a63:3d8c:: with SMTP id k134mr10060404pga.394.1631020778485;
        Tue, 07 Sep 2021 06:19:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx54QD4sA4WitLC+UAnBeu1eD80YxxMp4EjuIwFi9FL8waynVfOBY7paBUNcelvAhiR2vMYNQ==
X-Received: by 2002:a63:3d8c:: with SMTP id k134mr10060369pga.394.1631020778075;
        Tue, 07 Sep 2021 06:19:38 -0700 (PDT)
Received: from [10.72.12.125] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f16sm2484359pja.38.2021.09.07.06.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 06:19:37 -0700 (PDT)
Subject: Re: [PATCH RFC 0/2] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20210903081510.982827-1-xiubli@redhat.com>
 <02f2f77423ec1e6e5b23b452716b21c36a5b67da.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <71db1836-4f1e-1c3d-077a-018bff32f60d@redhat.com>
Date:   Tue, 7 Sep 2021 21:19:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <02f2f77423ec1e6e5b23b452716b21c36a5b67da.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/7/21 8:35 PM, Jeff Layton wrote:
> On Fri, 2021-09-03 at 16:15 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This patch series is based Jeff's ceph-fscrypt-size-experimental
>> branch in https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
>>
>> This is just a draft patch and need to rebase or recode after Jeff
>> finished his huge patch set.
>>
>> Post the patch out for advices and ideas. Thanks.
>>
> I'll take a look. Going forward though, it'd probably be best for you to
> just take over development of the entire ceph-fscrypt-size series
> instead of trying to develop on top of my branch.
>
> That branch is _very_ rough anyway. Just clone the branch into your tree
> and then you can drop or change patches in it as you see fit.

Sure.


>> ====
>>
>> This approach will not do the rmw immediately after the file is
>> truncated. If the truncate size is aligned to the BLOCK SIZE, so
>> there no need to do the rmw and only in unaligned case will the
>> rmw is needed.
>>
>> And the 'fscrypt_file' field will be cleared after the rmw is done.
>> If the 'fscrypt_file' is none zero that means after the kclient
>> reading that block to local buffer or pagecache it needs to do the
>> zeroing of that block in range of [fscrypt_file, round_up(fscrypt_file,
>> BLOCK SIZE)).
>>
>> Once any kclient has dirty that block and write it back to ceph, the
>> 'fscrypt_file' field will be cleared and set to 0. More detail please
>> see the commit comments in the second patch.
>>
> That sounds odd. How do you know where the file ends once you zero out
> fscrypt_file?
>
> /me goes to look at the patches...

The code in the ceph_fill_inode() is not handling well for multiple 
ftruncates case, need to be fixed.

Maybe we need to change the 'fscrypt_file' field's logic and make it 
opaqueness for MDS, then the MDS will use it to do the truncate instead 
as I mentioned in the previous reply in your patch set.

Then we can do the defer rmw in any kclient when necessary as this patch 
does.

>
>> There also need on small work in Jeff's MDS PR in cap flushing code
>> to clear the 'fscrypt_file'.
>>
>>
>> Xiubo Li (2):
>>    Revert "ceph: make client zero partial trailing block on truncate"
>>    ceph: truncate the file contents when needed when file scrypted
>>
>>   fs/ceph/addr.c  | 19 ++++++++++++++-
>>   fs/ceph/caps.c  | 24 ++++++++++++++++++
>>   fs/ceph/file.c  | 65 ++++++++++++++++++++++++++++++++++++++++++++++---
>>   fs/ceph/inode.c | 48 +++++++++++++++++++-----------------
>>   fs/ceph/super.h | 13 +++++++---
>>   5 files changed, 138 insertions(+), 31 deletions(-)
>>

