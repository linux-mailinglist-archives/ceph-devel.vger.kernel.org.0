Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74636A3F03
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 10:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjB0J7q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Feb 2023 04:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjB0J7m (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Feb 2023 04:59:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597C510431
        for <ceph-devel@vger.kernel.org>; Mon, 27 Feb 2023 01:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677491935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1S2jcg7n5klNnHvSxPgXdJtkhC9UGV39AxYri+0D1oM=;
        b=ei0xfjXZIk09iyJpLJfLNFNF8uHP65BwCQXmBr93QdSe80mR/vfUaFXFBnJSqNBh/6zT5M
        EZqgRasLOjqxx+7EesQtYB8Qt7FUepVuMn7/y34UpHuI08TvzJ5fbIeqUfK0vTdOHpChPa
        PZklGwiJ8Ve7QHG5Nexg7DTOly5ubyk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-130-1GBNL_cDPTWkOrxo5mXopA-1; Mon, 27 Feb 2023 04:58:54 -0500
X-MC-Unique: 1GBNL_cDPTWkOrxo5mXopA-1
Received: by mail-pg1-f200.google.com with SMTP id s3-20020a632c03000000b0050300a8089aso1709698pgs.0
        for <ceph-devel@vger.kernel.org>; Mon, 27 Feb 2023 01:58:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1S2jcg7n5klNnHvSxPgXdJtkhC9UGV39AxYri+0D1oM=;
        b=OUsWRiwMUj2p0OFglajtVMvY/MRePBGZC/cuM0cID8eQ36j8Zzt4NjmWyj+vbpswwi
         E0Qg4uOTHhacWtkrCHYSYyoGWBVr6gGSR/yNPmdL7EzpD86tH0isdinT//Vlkv/colyc
         yQvbjXswIDPvQZ1BdhlJqemFBUJWMFFbU5kRAvDXrRYoJbqgHC/sOkUVjNzhls080wTp
         w2IMAD14oWtzWbMyA8QjQctSC+iWubt6jfN62yisClG6wnpSJKH1bocWt1O6Hz2NQAMa
         u/Z0G1TSFOMq+dLQNKFHrvq/NXUSp67tPAE56BearicM50L8o/3b+WynvLDs3/QFhijg
         6mjA==
X-Gm-Message-State: AO0yUKUWnxA/Lq3RQb8ZFGDnfeG8vLlqL4nlXHyyet3t23nQePfCka9N
        97tPBB3gTuvwEXMyg/VoxXFBHNwW5LjkzcNULTzDTZVQ96HRMUajX40mPlAnBQexurx4fmd67hl
        LSxRZEdezmiT7S7xbyZDrBQ==
X-Received: by 2002:a17:902:6b85:b0:19c:a9b8:43b6 with SMTP id p5-20020a1709026b8500b0019ca9b843b6mr14956601plk.10.1677491933046;
        Mon, 27 Feb 2023 01:58:53 -0800 (PST)
X-Google-Smtp-Source: AK7set81HVAKdaV8tgFIIgNP2WKwogJL8ASvE7TbCk+X4G7yRRC9g/NEtHPFjA6p/gAEoiuPUbMRdA==
X-Received: by 2002:a17:902:6b85:b0:19c:a9b8:43b6 with SMTP id p5-20020a1709026b8500b0019ca9b843b6mr14956590plk.10.1677491932667;
        Mon, 27 Feb 2023 01:58:52 -0800 (PST)
Received: from [10.72.12.226] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id im16-20020a170902bb1000b0019a983f0119sm4131685plb.307.2023.02.27.01.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 01:58:52 -0800 (PST)
Message-ID: <ca5b6f7e-f3e6-7f35-a9b4-23acc0ff0747@redhat.com>
Date:   Mon, 27 Feb 2023 17:58:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v16 00/68] ceph+fscrypt: full support
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
References: <20230227032813.337906-1-xiubli@redhat.com>
 <87fsar791v.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87fsar791v.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Luis,

On 27/02/2023 17:27, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This patch series is based on Jeff Layton's previous great work and effort
>> on this.
>>
>> Since v15 we have added the ceph qa teuthology test cases for this [1][2],
>> which will test both the file name and contents encryption features and at
>> the same time they will also test the IO benchmarks.
>>
>> To support the fscrypt we also have some other work in ceph [3][4][5][6][7][8]:
>>
>> [1] https://github.com/ceph/ceph/pull/48628
>> [2] https://github.com/ceph/ceph/pull/49934
>> [3] https://github.com/ceph/ceph/pull/43588
>> [4] https://github.com/ceph/ceph/pull/37297
>> [5] https://github.com/ceph/ceph/pull/45192
>> [6] https://github.com/ceph/ceph/pull/45312
>> [7] https://github.com/ceph/ceph/pull/40828
>> [8] https://github.com/ceph/ceph/pull/45224
>> [9] https://github.com/ceph/ceph/pull/45073
>>
>> The [8] and [9] are still undering testing and will soon be merged after
>> that. All the others had been merged long time ago.
> Thanks a lot for your work on this, Xiubo (and Jeff!).  I assume this set
> is what's on the 'testing' branch.  I've done some testing on that branch
> recently, but I'll start having another look at v16 and run some more
> tests.

Yeah, this full fscrypt patch series has been in the 'testing' branch 2 
months ago as we discussed in the IRC. After that I just appended the 
following two commits:


   libceph: defer removing the req from osdc just after req->r_callback
   ceph: drop the messages from MDS when unmounting


And also 2 small other minor fixes in the commit comments and folded the 
following double free fixing patch reported by Ilya:

https://patchwork.kernel.org/project/ceph-devel/patch/20230111011403.570964-1-xiubli@redhat.com/


> Am I right assuming that this v16 patchset means we are NOT getting this
> merged into 6.3?

Yeah, not get merged yet. Because we were never able to put this to test 
since we had lots of infra issues with teuthology in last 2 months.

Since the teuthology Labs are back to work now we are running the tests 
and after that the patches will be ready.

Thanks

- Xiubo


>
> Cheers,

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

