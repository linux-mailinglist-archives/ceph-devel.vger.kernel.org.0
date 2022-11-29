Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACEB63CB1E
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Nov 2022 23:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbiK2Wim (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Nov 2022 17:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbiK2Wij (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Nov 2022 17:38:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1326012771
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 14:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669761464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nn5S5p+3X2iJPOWnTWOqifTtu6vA9YRlhoSe/H1ILk8=;
        b=Rg/vOuWfmo1qABhoBJIm5DuaHbR0oSZk1aHLaLNwc0Oz2iE2UGW/vNMzDh803vUQa9NL3W
        jSx70y0kwi2BxSY6IN1T6YLIDCpCGkskM/jCjhO2lJKZ4H0f51qPa4eTu+lCb/+ZHzSjGm
        YsyzRWk3IN28z17c9CT8zds6BqkNOKM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-9-YQ9ycnLxNrSE-YbBHpurJg-1; Tue, 29 Nov 2022 17:37:35 -0500
X-MC-Unique: YQ9ycnLxNrSE-YbBHpurJg-1
Received: by mail-pj1-f69.google.com with SMTP id l2-20020a17090add8200b00218daa1a812so9911907pjv.3
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 14:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nn5S5p+3X2iJPOWnTWOqifTtu6vA9YRlhoSe/H1ILk8=;
        b=HHQTDm2ZQTuBtHNHsu7kJvT7C1YaPyvblU/nWAYoFK86qGgJQhmYqn9thm1Ydp2SJT
         CI6cqEXUpmhDDykQqjsuQhNR6EObBy+rQJy9H2YzeNIc6Au8Uxziu4lB1siKMmd2ch35
         g/DyLSPlkjywNvLfaYf0fgZ8ptWeO361ytBABsilzExBQeyA9uIytOcVJg7IxEiSTy9D
         2z+HMe4xMdTJBwQhRjs/LGpbWpgzH+EGjFo2JcQV+qYtS/uAtzlpBOARJAR/nCaenVkL
         HVwvPtzvUSv5b1R+EVSuAuGN2HeNWpWXMRpdw2MGu4Lf0/b2cCEpAuAdJDXNnu2lWEPT
         dZdg==
X-Gm-Message-State: ANoB5plbKziUj4g7PPxlXw5LgN3ZxVzUZHum2X1b4dnAoYAP8YGhtwhK
        TNxfWPbEOtrftqzBqxdfYTVJGZZDzNt5RTMFQ0tZrq9yFcZ6rgazlDij38/mxDWpz6IhkmpmLB5
        K7CMAZIMt2jD9em8HswAVZw==
X-Received: by 2002:a17:902:8b89:b0:186:9c43:5969 with SMTP id ay9-20020a1709028b8900b001869c435969mr50706376plb.32.1669761454371;
        Tue, 29 Nov 2022 14:37:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UgvM3kKHX8zA0TDXg2cT1SfeYPj1CCQNC2IU+eO5niMvjHNPCf+uu6vVJdRWK6trsR5ZxzQ==
X-Received: by 2002:a17:902:8b89:b0:186:9c43:5969 with SMTP id ay9-20020a1709028b8900b001869c435969mr50706354plb.32.1669761454083;
        Tue, 29 Nov 2022 14:37:34 -0800 (PST)
Received: from [10.72.12.126] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090a2a4c00b0021952b5e9bcsm1739923pjg.53.2022.11.29.14.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 14:37:33 -0800 (PST)
Subject: Re: [PATCH v4] ceph: mark directory as non-complete complete after
 loading key
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221129103949.19737-1-lhenriques@suse.de>
 <4914a195-edc0-747b-6598-9ac9868593a1@redhat.com>
 <CAOi1vP8raoFP2dsc6RY1fONCsHh5FYv2xifFY7pHXZWX=-vePw@mail.gmail.com>
 <20e0674a-4e51-a352-9ce2-d939cd4f3725@redhat.com>
 <CAOi1vP_H8jE4ZU4a4srhQev3odECgZD1LyxA8dv+Fk-bVDvoyQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <fcbba3e5-9187-c174-a783-ddf08925b3da@redhat.com>
Date:   Wed, 30 Nov 2022 06:37:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_H8jE4ZU4a4srhQev3odECgZD1LyxA8dv+Fk-bVDvoyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 29/11/2022 23:21, Ilya Dryomov wrote:
> On Tue, Nov 29, 2022 at 3:50 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 29/11/2022 22:32, Ilya Dryomov wrote:
>>> On Tue, Nov 29, 2022 at 3:15 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 29/11/2022 18:39, Luís Henriques wrote:
>>>>> When setting a directory's crypt context, ceph_dir_clear_complete() needs to
>>>>> be called otherwise if it was complete before, any existing (old) dentry will
>>>>> still be valid.
>>>>>
>>>>> This patch adds a wrapper around __fscrypt_prepare_readdir() which will
>>>>> ensure a directory is marked as non-complete if key status changes.
>>>>>
>>>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>>>> ---
>>>>> Hi Xiubo,
>>>>>
>>>>> Here's a rebase of this patch.  I did some testing but since this branch
>>>>> doesn't really have full fscrypt support, I couldn't even reproduce the
>>>>> bug.  So, my testing was limited.
>>>> I'm planing not to update the wip-fscrypt branch any more, except the IO
>>>> path related fixes, which may introduce potential bugs each time as before.
>>>>
>>>> Since the qa tests PR has finished and the tests have passed, so we are
>>>> planing to merge the first none IO part, around 27 patches. And then
>>>> pull the reset patches from wip-fscrypt branch.
>>> I'm not sure if merging metadata and I/O path patches separately
>>> makes sense.  What would a user do with just filename encryption?
>> Hi Ilya,
>>
>> I think the IO ones should be followed soon.
>>
>> Currently the filename ones have been well testes. And the contents will
>> be by passed for now.
>>
>> Since this is just for Dev Preview feature IMO it should be okay (?)
> I don't think there is such a thing as a Dev Preview feature when it
> comes to the mainline kernel, particularly in the area of filesystems
> and storage.  It should be ready for users at least to some extent.  So
> my question stands: what would a user do with just filename encryption?

Before why split these patches was that, the content patches will change 
a lot and this may will stay in the testing branch for months. This will 
make it hard to test and rebase the non-encrypt patches based on encrypt 
ones when trying to pick and merge them.

The filename ones are simple and won't have the issue.

No worry, I can try to pick the content patches from wip-fscrypt branch 
soon. But before that please help check the existing non-encypt patches 
in the testing branch are okay and won't do big change later, which will 
always make me to rebase the content patches again and again and may 
involve many changes and potential bugs.

Thanks!

- Xiubo


> Thanks,
>
>                  Ilya
>

