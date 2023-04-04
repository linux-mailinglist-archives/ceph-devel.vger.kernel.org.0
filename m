Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BFF6D559D
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Apr 2023 02:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjDDAnE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Apr 2023 20:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjDDAnD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Apr 2023 20:43:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82756358A
        for <ceph-devel@vger.kernel.org>; Mon,  3 Apr 2023 17:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680568935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8alL9B9MGuFDbGXBNQ2DFG+QpvEWHUasZM3DEh/KVgc=;
        b=Jqs9ma8XeffaD5BZmS/6Fqd0TRMYUm7+zMDjrqv1K/zl3mddjd0+oYh0mbWf4NCoOsQF/3
        e5M8HpAkPY+eLGL9wR1FZvtDk8gyW09lrZLUsCdR1gxpeWfMpmwiHPqEAV8CMQWvnPkHcT
        v2rpXtGQqehjwSeRtWMso9FwP1IC73o=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-v_4bi9c0P-G7FJkLlaApCA-1; Mon, 03 Apr 2023 20:42:13 -0400
X-MC-Unique: v_4bi9c0P-G7FJkLlaApCA-1
Received: by mail-pl1-f200.google.com with SMTP id h4-20020a170902f54400b001a1f5f00f3fso18220125plf.2
        for <ceph-devel@vger.kernel.org>; Mon, 03 Apr 2023 17:42:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680568932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8alL9B9MGuFDbGXBNQ2DFG+QpvEWHUasZM3DEh/KVgc=;
        b=0iyC4tn2SOGTzQqw/A7V3uIR1MJOZCxaOuiSBLeoZNo9l1KUTZQHoFMjPR/IcfKG8O
         kbioioHRHZ5cf57KNROZ/rlwAdinxPMUOrXJxPMk8Dx+onmyARWieOIY0y7KMejJdYhw
         HAXqBwIQIkr0Ln+Tabx9NEWS86FbSongYMbKX7ZvMRSdufRFT2V7vCnR6GyV+Ey/5t0t
         CO5Jpr4+DxqGBRJXy+olmzjf2RsXkTZOFznGyF/2mnlNpVCFMjLk3XaU5DBIsP+PoubE
         JZQzj9CAghxtw6sh/03Dr6Hrp0KBrW1zCVuxqstL8qKvxPNuiqP07d9MDNYpwVmlgHTY
         jUtQ==
X-Gm-Message-State: AAQBX9dEnQ/nlvq1caP16qop6/sFifDWQUI7gQcu+xf828Sq2RNWsPGl
        Lkco/Y9Qon/+4za1vYv6BZD3WlZIT2GtSi8DgwaetDTaCOueeuFlQek3MXAhBGRk32qrfR+RwzN
        Mu0t2n8IRDMD0ZuomGPIByA==
X-Received: by 2002:a62:1c13:0:b0:626:2984:8a76 with SMTP id c19-20020a621c13000000b0062629848a76mr317780pfc.34.1680568932374;
        Mon, 03 Apr 2023 17:42:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350YxnbUsf5u68CeTSNdvIwMQ+fGjXMvJUA+8KjsjnhlqlaBO9TVUFuvYzs1M6iRMSqM/2ZtgXw==
X-Received: by 2002:a62:1c13:0:b0:626:2984:8a76 with SMTP id c19-20020a621c13000000b0062629848a76mr317767pfc.34.1680568932077;
        Mon, 03 Apr 2023 17:42:12 -0700 (PDT)
Received: from [10.72.12.35] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j7-20020aa783c7000000b006251e1fdd1fsm7472247pfn.200.2023.04.03.17.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 17:42:11 -0700 (PDT)
Message-ID: <b1512c60-bd87-769a-2402-1c33618d2709@redhat.com>
Date:   Tue, 4 Apr 2023 08:42:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v17 00/71] ceph+fscrypt: full support
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
References: <20230323065525.201322-1-xiubli@redhat.com>
 <87wn2t3uqz.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87wn2t3uqz.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/3/23 22:28, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This patch series is based on Jeff Layton's previous great work and effort
>> on this and all the patches bas been in the testing branch since this
>> Monday(20 Mar)
> I've been going through this new rev[1] in the last few days and I
> couldn't find any issues with it.  The rebase on top of 6.3 added minor
> changes since last version (for example, there's no need to call
> fscrypt_add_test_dummy_key() anymore), but everything seems to be fine.
>
> So, FWIW, feel free to add my:
>
> Tested-by: Luís Henriques <lhenriques@suse.de>
> Reviewed-by: Luís Henriques <lhenriques@suse.de>
>
> to the whole series.
>
> And, again, thanks a lot for your work on this!
>
> [1] Actually, I've looked into what's currently in the 'testing' branch,
> which is already slightly different from this v17.

Yeah, as we discussed in another thread, I have fixed one patch and push 
it to the testing branch, this should be the difference.

Thanks Luis very much.

- Xiubo


> Cheers,

