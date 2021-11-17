Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E53A4547A2
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Nov 2021 14:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbhKQNnm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Nov 2021 08:43:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231565AbhKQNnk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 08:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637156441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5tUjmegcTd/0DGc4T0iBy//K8I3d50oEwB1Pu9pZQ5g=;
        b=jSjHI7u2tlw7D6WdcCM1fKcNOwyOq0DriAhgI1W5gQTeFctrs+z5i4E0yfA0ZXVcvitvXE
        spdovnSBSOix3kWj4Ap1ZDADk8FPidDVTY+ii8NErMNC45QwSzlzr/1ymduEDIyZKMZANP
        +PyAxAWBerbu28IVjNH8ZG+6gEvEb/E=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-40-bbrhPTcmOUmgaS2WAVhseg-1; Wed, 17 Nov 2021 08:40:40 -0500
X-MC-Unique: bbrhPTcmOUmgaS2WAVhseg-1
Received: by mail-pl1-f198.google.com with SMTP id j6-20020a17090276c600b0014377d8ede3so1106646plt.21
        for <ceph-devel@vger.kernel.org>; Wed, 17 Nov 2021 05:40:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5tUjmegcTd/0DGc4T0iBy//K8I3d50oEwB1Pu9pZQ5g=;
        b=dYdhbYF/9c0fD8BTf+gl3Y1JI1kjkQqoOqUJS6SvC2mEq0Fs0gCzGSI27nBBHqEB27
         69R1H8QSZKpBC3idb6OwBOEBebtZ2C5hqHyhIyLrmFD9oqaHhaEDrQ5lrQMemgp0amg8
         chItGBxKuES0xtWSnNrOlVe9xT40RE++4QKEFcBlok/KNYE0jepi3X6tHY9EdyAfe10f
         ufrlz8O362DaGurtp1tfBiSxTXjs+FjfyvmUb1EQz/hOghkdyIks4Rq4iGDepYyHLqsl
         GrXgWPb8+6Nggv8zWRfRhJ8TH5+7EafRLi5uQ+UQmUAbifIV/a/sOy1ff884EeGlSQ3G
         aAgg==
X-Gm-Message-State: AOAM533Ym1jl6NEv2zNqipqhBQ64C5MyUeYUjCW89nCgp4n84KatHCRa
        97jmHC1QnSRTRiGINtuefo9MbUbd026tkhPc7XXURkamA/W4qH/+Qr7lhOdw8DeqeKcmaW0KPjm
        OS77jhtpcJMyNmJ/NTPDT5xvZe3uqR1YSPnls524EcPv+TZSSoWc9SOz6XLvXs4oI3fcFLTA=
X-Received: by 2002:a17:90a:a396:: with SMTP id x22mr9682669pjp.14.1637156438076;
        Wed, 17 Nov 2021 05:40:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwE/v2a49xMD7/mNSxJCMiQpPCPjYg1l411CSPcr1dyCiHl4TO3a3b8QvhxBf0LhwnrsOh4Lg==
X-Received: by 2002:a17:90a:a396:: with SMTP id x22mr9682620pjp.14.1637156437769;
        Wed, 17 Nov 2021 05:40:37 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z3sm22512606pfh.79.2021.11.17.05.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 05:40:36 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
 <672440f9-e812-e97f-1c85-0343d7e8359e@redhat.com>
 <e49bbb32e8c76e441c6d24f98774187c4e913a22.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <62aadd46-5bed-3f51-40e0-04780ed7e97b@redhat.com>
Date:   Wed, 17 Nov 2021 21:40:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e49bbb32e8c76e441c6d24f98774187c4e913a22.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/17/21 9:28 PM, Jeff Layton wrote:
> On Wed, 2021-11-17 at 09:21 +0800, Xiubo Li wrote:
>> On 11/17/21 4:06 AM, Jeff Layton wrote:
>>> On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
[...]
>>>> So when filling the inode it will truncate the pagecache by using
>>>> truncate_sizeA again, which makes no sense and will trim the inocent
>>>> pages.
>>>>
>>> Is there a reproducer for this? It would be nice to put something in
>>> xfstests for it if so.
>> In xfstests' generic/075 has already testing this, but i didn't see any
>> issue it reproduce.
>>
>> I just found this strange logs when it's doing
>> something like:
>>
>> truncateA 0x10000 --> 0x2000
>>
>> truncateB 0x2000   --> 0x8000
>>
>> truncateC 0x8000   --> 0x6000
>>
>> For the truncateC, the log says:
>>
>> ceph:  truncate_size 0x2000 -> 0x6000
>>
>>
>> The problem is that the truncateB will also do the vmtruncate by using
>> the 0x2000 instead, the vmtruncate will not flush the dirty pages to the
>> OSD and will just discard them from the pagecaches. Then we may lost
>> some new updated data in case there has any write before the truncateB
>> in range [0x2000, 0x8000).
>>
>>
> Is that reproducible without the fscrypt size handling changes? I
> haven't seen generic/075 fail on stock kernels.

Yeah, there is no error about this, since there has no any write between 
truncateA and truncateB, if there has I am afraid the test will fail in 
theory.


>
> If this is a generic bug, then we should go ahead and fix it in
> mainline. If it's a problem only with fscrypt enabled, then let's plan
> to roll this patch into those changes.
>
I think it makes sense always to check the truncate_seq and 
truncate_size here in kclient, or at least should we warn it in case the 
MDS will do this again in future ?

The truncate_seq and truncate_size should always be changed at the same 
time.

Make sense ?



>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/inode.c | 5 +++--
>>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>> index 1b4ce453d397..b4f784684e64 100644
>>>> --- a/fs/ceph/inode.c
>>>> +++ b/fs/ceph/inode.c
>>>> @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>>>>    			 * don't hold those caps, then we need to check whether
>>>>    			 * the file is either opened or mmaped
>>>>    			 */
>>>> -			if ((issued & (CEPH_CAP_FILE_CACHE|
>>>> +			if (ci->i_truncate_size != truncate_size &&
>>>> +			    ((issued & (CEPH_CAP_FILE_CACHE|
>>>>    				       CEPH_CAP_FILE_BUFFER)) ||
>>>>    			    mapping_mapped(inode->i_mapping) ||
>>>> -			    __ceph_is_file_opened(ci)) {
>>>> +			    __ceph_is_file_opened(ci))) {
>>>>    				ci->i_truncate_pending++;
>>>>    				queue_trunc = 1;
>>>>    			}

