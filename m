Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03C82E783
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 23:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfE2ViC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 17:38:02 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:42582 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2ViC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 17:38:02 -0400
Received: by mail-qt1-f172.google.com with SMTP id s15so4469279qtk.9
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 14:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PiiJIeftjihjHHMx8Ga56gUr2H8qZ+gXEIXFsSanD5Y=;
        b=Tl893kpGqUKXO+AjkzyfPlMmSK0oK5D9A7VnT3zlxrxJEi+6CQpffGCpJDG7rNdd5g
         udCT0CkIt6KlCsgbxbCy+q/OGrHDvF6nENdm8z/kShsCQ1WuGsYR/MWneuaGlRIspWjy
         cRbwDunC1+f1Rbw+hwTD1yk6Zqg8P7ZqGvYx1ZHM75/IIWv96Pq5IFEItXCxc7Rgtv3M
         tVnVJ+z96p8O409mWoWlU6dSXI1sKZbIenkURRjUYtuMTL1ZihNGZoDsCudW8oxNtsEK
         TEOlhKXJP343K4i8elnaOHAFSUFLl3Etc9OLX3a+feffilQ9CfMK1uColSiENp4mezGX
         gyyQ==
X-Gm-Message-State: APjAAAVW/KyK/IjZTAFrp1p8WQGEfGZ0DMOcxzXjZY5aHk4czIlM9BMo
        KX5KQgfwcimL4bTa6bULPQqM+zChdQI=
X-Google-Smtp-Source: APXvYqzUEKQqmjvsNV+KMKBSLUCo+ZcRhzur/9EB4iHW2ehWrbhMT57H03htbGTy/rJu9Q10ZqimQg==
X-Received: by 2002:a0c:c12a:: with SMTP id f39mr191243qvh.217.1559165880794;
        Wed, 29 May 2019 14:38:00 -0700 (PDT)
Received: from [10.17.151.126] ([12.118.3.106])
        by smtp.gmail.com with ESMTPSA id i37sm405404qtb.31.2019.05.29.14.38.00
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 14:38:00 -0700 (PDT)
Subject: Re: Multisite sync corruption for large multipart obj
To:     Xiaoxi Chen <superdebuger@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
References: <CAEYCsVJ_k_HxRFxts_Vbk8KN8GQ73Kh_JBKf4upE46YrfHGnbA@mail.gmail.com>
 <349539bb-bbf2-e900-2972-bd309f2d4fa1@redhat.com>
 <CAEYCsVJBdy1RW-67ADZBx3t4G+_+qJYSVAZAYC9ZpGmjfhA5VQ@mail.gmail.com>
From:   Casey Bodley <cbodley@redhat.com>
Message-ID: <4c2e18dc-bfd8-6896-3b9c-3e9f26e452e0@redhat.com>
Date:   Wed, 29 May 2019 17:37:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAEYCsVJBdy1RW-67ADZBx3t4G+_+qJYSVAZAYC9ZpGmjfhA5VQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/28/19 5:43 AM, Xiaoxi Chen wrote:
> Hi Casey,
>      Thanks for the reply.   I couldnt find the log back to that time
> due to logroate remove anything older than 7 days...sorry for that.
>
>      It looks to me like the issue was trigger by restart/failure on
> src_zone rgw, which cause connection reset in our http client however
> the error is not popping up to upper layer. Then we finished out the
> object and adding metadata as-is.  The detecting we are missing in
> this case is the integrity of src obj.  As we lost the multipart
> information we cannot use ETAG to check the integrity for fetched obj.
> Maybe  a simple size check can help us to some extent as the first
> step (truncate is much more often than corruption as restart of RGW
> can easily trigger the issue) , very weak but better than none...


I agree that's useful as a short-term solution, yeah. I commented on 
your pr https://github.com/ceph/ceph/pull/28298 and proposed an 
alternative in https://github.com/ceph/ceph/pull/28303.

I'd also really like to figure out why our http wrappers aren't catching 
this already. I would expect libcurl to get a socket error from a 
truncated read.

>       The STREAMING-AWS4-HMAC-SHA256-PAYLOAD it seems more for ensuring
> the data integrity for putObj progress, but we are uploading through
> rados, not sure how can we get use of this?
>
>        Is there any possibility that we expose the multipart
> information(including part size, checksum of each part, as well as
> ETAG) from src zone though internal API? so that in
> RGWRados::fetch_remote_obj we can keep the multipart format and do
> integrity check?
>
> -Xiaoxi
>
> Casey Bodley <cbodley@redhat.com> 于2019年5月24日周五 上午4:15写道：
>
>>
>> On 5/21/19 9:16 PM, Xiaoxi Chen wrote:
>>> we have a two-zone multi-site setup, zone lvs and zone slc
>>> respectively. It works fine in general however we got reports from
>>> customer about data corruption/mismatch between two zone
>>>
>>> root@host:~# s3cmd -c .s3cfg_lvs ls
>>> s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
>>> 2019-05-14 04:30 410444223 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
>>> root@host-ump:~# s3cmd -c .s3cfg_slc ls
>>> s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
>>> 2019-05-14 04:30 62158776 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
>>>
>>> Object metadata in SLC/LVS can be found in
>>> https://pastebin.com/a5JNb9vb LVS
>>> https://pastebin.com/1MuPJ0k1 SLC
>>>
>>> SLC is a single flat object while LVS is a multi-part object, which
>>> indicate the object was uploaded by user in LVS and mirrored to
>>> SLC.The SLC object get truncated after 62158776, the first 62158776
>>> bytes are right.
>>>
>>> root@host:~# cmp -l slc_obj lvs_obj
>>> cmp: EOF on slc_obj after byte 62158776
>>>
>>> Both bucket sync status and overall sync status shows positive, and
>>> the obj was created 5 days ago. It sounds more like when pulling the
>>> object content from source zone(LVS), the transaction was terminated
>>> somewhere in between and cause an incomplete obj, and seems we dont
>>> have checksum verification in sync_agent so that the corrupted obj was
>>> there and be treated as a success sync.
>> It's troubling to see that sync isn't detecting an error from the
>> transfer. Do you see any errors from the http client in your logs such
>> as 'WARNING: client->receive_data() returned ret='?
>>
>> I agree that we need integrity checking, but we can't rely on ETags
>> because of the way that multipart objects sync as non-multipart. I think
>> the right way to address this is to add v4 signature support to the http
>> client, and rely on STREAMING-AWS4-HMAC-SHA256-PAYLOAD for integrity of
>> the body chunks
>> (https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-streaming.html).
>>
>>> root@host:~# radosgw-admin --cluster slc_ceph_ump bucket sync status
>>> --bucket=ms-nsn-prod-48
>>> realm 2305f95c-9ec9-429b-a455-77265585ef68 (metrics)
>>> zonegroup 9dad103a-3c3c-4f3b-87a0-a15e17b40dae (ebay)
>>> zone 6205e53d-6ce4-4e25-a175-9420d6257345 (slc)
>>> bucket ms-nsn-prod-48[017a0848-cf64-4879-b37d-251f72ff9750.432063.48]
>>>
>>> source zone 017a0848-cf64-4879-b37d-251f72ff9750 (lvs)
>>>                   full sync: 0/16 shards
>>>                   incremental sync: 16/16 shards
>>>                   bucket is caught up with source
>>>
>>>
>>> Re-sync on the bucket will not solve the inconsistency
>> Right. The GET requests that fetch objects use the If-Modified-Since
>> header to avoid transferring data unless the mtime has changed. In order
>> to force re-sync, you would have to do something that updates its mtime
>> - for example, setting an acl.
>>> radosgw-admin bucket sync init --source-zone lvs --bucket=ms-nsn-prod-48
>>>
>>> root@host:~# radosgw-admin bucket sync status --bucket=ms-nsn-prod-48
>>> realm 2305f95c-9ec9-429b-a455-77265585ef68 (metrics)
>>> zonegroup 9dad103a-3c3c-4f3b-87a0-a15e17b40dae (ebay)
>>> zone 6205e53d-6ce4-4e25-a175-9420d6257345 (slc)
>>> bucket ms-nsn-prod-48[017a0848-cf64-4879-b37d-251f72ff9750.432063.48]
>>>
>>> source zone 017a0848-cf64-4879-b37d-251f72ff9750 (lvs)
>>>                   full sync: 0/16 shards
>>>                   incremental sync: 16/16 shards
>>>                   bucket is caught up with source
>>>
>>> root@lvscephmon01-ump:~# s3cmd -c .s3cfg_slc ls
>>> s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
>>> 2019-05-14 04:30 62158776 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
>>>
>>>
>>> A tracker was submitted to
>>> https://tracker.ceph.com/issues/39992
