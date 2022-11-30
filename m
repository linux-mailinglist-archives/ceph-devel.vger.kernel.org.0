Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400E663D0A4
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Nov 2022 09:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbiK3Iaa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Nov 2022 03:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiK3IaF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Nov 2022 03:30:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EAA76143
        for <ceph-devel@vger.kernel.org>; Wed, 30 Nov 2022 00:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669796727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cLhw+4YCDLU54mdWJRFJtop//lKH4CfPzwb9WT359CY=;
        b=ZInIOHv01wg/+CnRmt0iHmu0827EtwYELhiWg4+ssKcXe39fRinMhFSkzwET1nUAmPIvet
        NdmdzR95YXmIOuqSNc4ieJa3cdO2JxjcpImjUTv9S+bjpX8MNvLNvEaoY0HGMwGjbaFTea
        UVkFprKABUA8bX9D4XRmDNcQXXSI/YA=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-205-DiwbN4sDMcuvylFVnTDgjw-1; Wed, 30 Nov 2022 03:25:26 -0500
X-MC-Unique: DiwbN4sDMcuvylFVnTDgjw-1
Received: by mail-pg1-f197.google.com with SMTP id e37-20020a635025000000b00476bfca5d31so11525155pgb.21
        for <ceph-devel@vger.kernel.org>; Wed, 30 Nov 2022 00:25:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cLhw+4YCDLU54mdWJRFJtop//lKH4CfPzwb9WT359CY=;
        b=e25G0aiRF3SSG5CBV+UW87QcfCVV5fMFETi6LJZx6I+KDqjRaQXezSuAWrDCD64hFq
         FKpshH7VSAcN2dz0t0jGzt6i0q5Oo2u/+lxinRCobX159kIbVkaNEjHTGkan+nWUrWso
         moYFPa/Ucoe9AtKLGrprzTMR2f71ZAfxaPjmLLF5zgrom3Er/O7vkrht22eSwA89AfWy
         2gM7oHf63OJiAub1bcJqF7fOlweeBMyVc7e2OpF2GMQnRWjDnFkWZwZFYYfxHRu4MX87
         nsvUqjsJ/V4859Tom1e6JgosEJV0JkN9tlwti1VPU+1zukTteyVByA2R8r6PFJa3HmNf
         kr+A==
X-Gm-Message-State: ANoB5pm159EKP1STFGq5mkJKMxMjOy947RN+plDkkuJGXaFtpeQxEz7V
        6ltFQsETXHFQ4zArbu7pMHd2Q/pkBxCOn8lXcxGEcXUFthi6NUWa2cjfIgM7veU5Rf5kbb6Ljse
        YnknwxgfXfjz5EmXpJU3AJA==
X-Received: by 2002:a63:f003:0:b0:45f:bf86:c917 with SMTP id k3-20020a63f003000000b0045fbf86c917mr53684622pgh.201.1669796724966;
        Wed, 30 Nov 2022 00:25:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5l6HxGuRdUgFze8Xav0NBiW2FtnsKMFNGxrQXmyLUy40JkncqzspqWNEwMQWjmDlzniGmdCQ==
X-Received: by 2002:a63:f003:0:b0:45f:bf86:c917 with SMTP id k3-20020a63f003000000b0045fbf86c917mr53684612pgh.201.1669796724713;
        Wed, 30 Nov 2022 00:25:24 -0800 (PST)
Received: from [10.72.13.22] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c10-20020a056a00008a00b0057255b82bd1sm790295pfj.217.2022.11.30.00.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 00:25:24 -0800 (PST)
Subject: Re: [PATCH v4] ceph: mark directory as non-complete complete after
 loading key
To:     Gregory Farnum <gfarnum@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221129103949.19737-1-lhenriques@suse.de>
 <4914a195-edc0-747b-6598-9ac9868593a1@redhat.com>
 <CAOi1vP8raoFP2dsc6RY1fONCsHh5FYv2xifFY7pHXZWX=-vePw@mail.gmail.com>
 <20e0674a-4e51-a352-9ce2-d939cd4f3725@redhat.com>
 <CAOi1vP_H8jE4ZU4a4srhQev3odECgZD1LyxA8dv+Fk-bVDvoyQ@mail.gmail.com>
 <CAJ4mKGb=_CWTh5rrAFiib66-S6WeT=ajjkN_pOAac4d8uC9fDQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4b7ccbee-1135-09a7-9255-2f84e8907614@redhat.com>
Date:   Wed, 30 Nov 2022 16:25:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAJ4mKGb=_CWTh5rrAFiib66-S6WeT=ajjkN_pOAac4d8uC9fDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 30/11/2022 14:54, Gregory Farnum wrote:
> On Tue, Nov 29, 2022 at 7:21 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>> On Tue, Nov 29, 2022 at 3:50 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>
>>> On 29/11/2022 22:32, Ilya Dryomov wrote:
>>>> On Tue, Nov 29, 2022 at 3:15 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>> On 29/11/2022 18:39, Luís Henriques wrote:
>>>>>> When setting a directory's crypt context, ceph_dir_clear_complete() needs to
>>>>>> be called otherwise if it was complete before, any existing (old) dentry will
>>>>>> still be valid.
>>>>>>
>>>>>> This patch adds a wrapper around __fscrypt_prepare_readdir() which will
>>>>>> ensure a directory is marked as non-complete if key status changes.
>>>>>>
>>>>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>>>>> ---
>>>>>> Hi Xiubo,
>>>>>>
>>>>>> Here's a rebase of this patch.  I did some testing but since this branch
>>>>>> doesn't really have full fscrypt support, I couldn't even reproduce the
>>>>>> bug.  So, my testing was limited.
>>>>> I'm planing not to update the wip-fscrypt branch any more, except the IO
>>>>> path related fixes, which may introduce potential bugs each time as before.
>>>>>
>>>>> Since the qa tests PR has finished and the tests have passed, so we are
>>>>> planing to merge the first none IO part, around 27 patches. And then
>>>>> pull the reset patches from wip-fscrypt branch.
>>>> I'm not sure if merging metadata and I/O path patches separately
>>>> makes sense.  What would a user do with just filename encryption?
>>> Hi Ilya,
>>>
>>> I think the IO ones should be followed soon.
>>>
>>> Currently the filename ones have been well testes. And the contents will
>>> be by passed for now.
>>>
>>> Since this is just for Dev Preview feature IMO it should be okay (?)
>> I don't think there is such a thing as a Dev Preview feature when it
>> comes to the mainline kernel, particularly in the area of filesystems
>> and storage.  It should be ready for users at least to some extent.  So
>> my question stands: what would a user do with just filename encryption?
> I think how this merges is up to you guys and the kernel practices.
> Merging only the filename encryption is definitely of *limited*
> utility, but I don't think it's totally pointless -- the data versus
> metadata paths are different and you are protecting against somewhat
> different vulnerabilities and threat models with them. For instance,
> MDS logs dump filenames, but OSD logs do not dump object data. There's
> some obvious utility there even if you basically trust your provider,
> or run your own cluster but want to be more secure about sending logs
> via ceph-post-file.

Hi Greg,

Sounds reasonable to me.

I will leave this to Ilya.

Thanks!

- Xiubo

> -Greg
>
>> Thanks,
>>
>>                  Ilya
>>

