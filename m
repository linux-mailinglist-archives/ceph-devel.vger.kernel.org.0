Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A506B63D642
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Nov 2022 14:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbiK3NEo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Nov 2022 08:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiK3NEn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Nov 2022 08:04:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5445F85D
        for <ceph-devel@vger.kernel.org>; Wed, 30 Nov 2022 05:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669813389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g2+Y+FVxr8rMK88htgWTuTuScnJMXGjZ6V1dViw2hbU=;
        b=PdozjhH7hCVSsmfdJZxEU6p0iJp/f2EaXlB+IIGYcy0eqlZkTh0jxnK0MLlVBUZT8VcOlu
        q4vRIuZs9Z5vSsuIBxQhmTsaQ4KJtS59DFoo7A7a8SvsygOsSgv7uZaA4iVpU7Dp3pBDOz
        LSaqVQ9fyeEDwup0Xqg9UOdpM0cqmJM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-474-RbIE1IT-PA6g7fyBB0q13Q-1; Wed, 30 Nov 2022 08:03:06 -0500
X-MC-Unique: RbIE1IT-PA6g7fyBB0q13Q-1
Received: by mail-pj1-f72.google.com with SMTP id x6-20020a17090a46c600b002190cdd7bcdso1948675pjg.6
        for <ceph-devel@vger.kernel.org>; Wed, 30 Nov 2022 05:03:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2+Y+FVxr8rMK88htgWTuTuScnJMXGjZ6V1dViw2hbU=;
        b=QDPoibaW2ecga0j0LK7G6s2Nul/z6JeGnDJXaAHwYcJB3db3V1ZkiDtM8sHGwdakrg
         DpqIGTsZUKZbEKJWYDAo8JiYrAf3Q8wCbNOj8zzYucKIM3XLuaYee4JVZfw1TqwGJtIL
         sVcFe8ScX9S8YrLjdv/kOcD5YG4rw9+v4yj2OGWrtctLMcQk49qu5x80DMUz+fTSlLEq
         9sm1Qei9sgpACvDYGZqKYqhGntS041E6qmLrlNirVN4KdkPS9GTtYUjIaSapbUud0koR
         AUqRMw3U3p29X/nl/dN2LqFKOTy4YPjEpVZQUQNawsCko2OsIQoWC2x0vRvkLocVagOG
         jezQ==
X-Gm-Message-State: ANoB5plxMBjMl6tLMzS/sdrB/IXESixsGfN2SFxRJzd+lIqYYhqpin5d
        Lo1g+GO4bTdZem0zIq13PXYDOUVs5q9QbOBiyjKD+bVx+J4knrIgp+75PEA6ngWhcr+s87/xcOx
        bAnbDsf1BwgQteqNJYuWlkQ==
X-Received: by 2002:a63:9dce:0:b0:478:936:3427 with SMTP id i197-20020a639dce000000b0047809363427mr17226501pgd.432.1669813385151;
        Wed, 30 Nov 2022 05:03:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7MLRftRnCqNFGkYSzWH4NeisI8sJdP6rxBCj2MhohyXEq9HOJbw6kTnbkFGYp4Xn/ayg/4Zg==
X-Received: by 2002:a63:9dce:0:b0:478:936:3427 with SMTP id i197-20020a639dce000000b0047809363427mr17226472pgd.432.1669813384849;
        Wed, 30 Nov 2022 05:03:04 -0800 (PST)
Received: from [10.72.12.171] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z7-20020a17090a398700b0021912989f81sm3054876pjb.51.2022.11.30.05.03.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 05:03:04 -0800 (PST)
Subject: Re: [PATCH v4] ceph: mark directory as non-complete complete after
 loading key
To:     Jeff Layton <jlayton@kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221129103949.19737-1-lhenriques@suse.de>
 <4914a195-edc0-747b-6598-9ac9868593a1@redhat.com>
 <CAOi1vP8raoFP2dsc6RY1fONCsHh5FYv2xifFY7pHXZWX=-vePw@mail.gmail.com>
 <20e0674a-4e51-a352-9ce2-d939cd4f3725@redhat.com>
 <CAOi1vP_H8jE4ZU4a4srhQev3odECgZD1LyxA8dv+Fk-bVDvoyQ@mail.gmail.com>
 <CAJ4mKGb=_CWTh5rrAFiib66-S6WeT=ajjkN_pOAac4d8uC9fDQ@mail.gmail.com>
 <4b7ccbee-1135-09a7-9255-2f84e8907614@redhat.com>
 <1401f070248db62f0b41092db4bb3550861063af.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b74b486a-1159-1b89-74c9-263bacb75452@redhat.com>
Date:   Wed, 30 Nov 2022 21:02:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1401f070248db62f0b41092db4bb3550861063af.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
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


On 30/11/2022 18:11, Jeff Layton wrote:
> On Wed, 2022-11-30 at 16:25 +0800, Xiubo Li wrote:
>> On 30/11/2022 14:54, Gregory Farnum wrote:
>>> On Tue, Nov 29, 2022 at 7:21 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>>>> On Tue, Nov 29, 2022 at 3:50 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>> On 29/11/2022 22:32, Ilya Dryomov wrote:
>>>>>> On Tue, Nov 29, 2022 at 3:15 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>>>> On 29/11/2022 18:39, Luís Henriques wrote:
>>>>>>>> When setting a directory's crypt context, ceph_dir_clear_complete() needs to
>>>>>>>> be called otherwise if it was complete before, any existing (old) dentry will
>>>>>>>> still be valid.
>>>>>>>>
>>>>>>>> This patch adds a wrapper around __fscrypt_prepare_readdir() which will
>>>>>>>> ensure a directory is marked as non-complete if key status changes.
>>>>>>>>
>>>>>>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>>>>>>> ---
>>>>>>>> Hi Xiubo,
>>>>>>>>
>>>>>>>> Here's a rebase of this patch.  I did some testing but since this branch
>>>>>>>> doesn't really have full fscrypt support, I couldn't even reproduce the
>>>>>>>> bug.  So, my testing was limited.
>>>>>>> I'm planing not to update the wip-fscrypt branch any more, except the IO
>>>>>>> path related fixes, which may introduce potential bugs each time as before.
>>>>>>>
>>>>>>> Since the qa tests PR has finished and the tests have passed, so we are
>>>>>>> planing to merge the first none IO part, around 27 patches. And then
>>>>>>> pull the reset patches from wip-fscrypt branch.
>>>>>> I'm not sure if merging metadata and I/O path patches separately
>>>>>> makes sense.  What would a user do with just filename encryption?
>>>>> Hi Ilya,
>>>>>
>>>>> I think the IO ones should be followed soon.
>>>>>
>>>>> Currently the filename ones have been well testes. And the contents will
>>>>> be by passed for now.
>>>>>
>>>>> Since this is just for Dev Preview feature IMO it should be okay (?)
>>>> I don't think there is such a thing as a Dev Preview feature when it
>>>> comes to the mainline kernel, particularly in the area of filesystems
>>>> and storage.  It should be ready for users at least to some extent.  So
>>>> my question stands: what would a user do with just filename encryption?
>>> I think how this merges is up to you guys and the kernel practices.
>>> Merging only the filename encryption is definitely of *limited*
>>> utility, but I don't think it's totally pointless -- the data versus
>>> metadata paths are different and you are protecting against somewhat
>>> different vulnerabilities and threat models with them. For instance,
>>> MDS logs dump filenames, but OSD logs do not dump object data. There's
>>> some obvious utility there even if you basically trust your provider,
>>> or run your own cluster but want to be more secure about sending logs
>>> via ceph-post-file.
>> Hi Greg,
>>
>> Sounds reasonable to me.
>>
>> I will leave this to Ilya.
>>
>> Thanks!
> For the record, the only reason I proposed merging them in multiple sets
> was that it is a large set of changes and I was leery of regressions. I
> don't see a lot of value in enabling just filename encryption without
> the content piece.
>
> I'd be fine with merging it all en-masse, though it's a bit more to wade
> through if we end up having to bisect to track down a bug.
>   

Hi Jeff,

After Ilya reviewing the testing's non-encrypt patches to make sure I 
won't do the rebase again and again for a large number of patches, I 
will begin to pick the contents patches from wip-fscrypt branch.

And then run the qa test again.

Thanks all :-)

- Xiubo


