Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A16453203D
	for <lists+ceph-devel@lfdr.de>; Tue, 24 May 2022 03:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiEXBUR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 May 2022 21:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiEXBUQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 23 May 2022 21:20:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF57E972BB
        for <ceph-devel@vger.kernel.org>; Mon, 23 May 2022 18:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653355210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JjBAtLVuW+IVhdLGX+nEfh5D6ivneZdTFo7a8oOuupk=;
        b=DW23b66bfIacVVW4o4cYPG5XJNUAIUqWIRO5zJlEr1y4V1l2YLM6Wm3hzAkxeMprnd5rKM
        vj/DmV0syHWQmbQI6Hs2iHSp0qlR2VcUyAth0qaT/5dwaha+Sj9LJTFck6SZd3j03lVqiD
        2keEV8DRyKGJsR5iegSGSuOvCURCESo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-Q0eegsvmO_ak7UqGkrRpVA-1; Mon, 23 May 2022 21:20:09 -0400
X-MC-Unique: Q0eegsvmO_ak7UqGkrRpVA-1
Received: by mail-pj1-f71.google.com with SMTP id o8-20020a17090a9f8800b001dc9f554c7fso9000801pjp.4
        for <ceph-devel@vger.kernel.org>; Mon, 23 May 2022 18:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JjBAtLVuW+IVhdLGX+nEfh5D6ivneZdTFo7a8oOuupk=;
        b=k02Cg7UeoJu7swNX3PPNZeYfVxgVs6MzfQaIH4v3wL7NIvyKJLik674DKpB98gMzt/
         /25LbpM8ZrZR0txyB8X4fONZUqEcIounxi3j8H+CPZZ7iRZsJewQce6ILT1iKxshqms0
         SsS/w3IAMX4OocXtDrKxG0iVhM+LiRz7ciS6T4G7YXvd6AGzUAD+mc87Q2r5qil0+s2e
         zT2mEOxi+YRHK/RptiOAxFiwJdenrHI7d4AG5zMbHi2eSCOqVqGjP+gul+ajcklkqkTo
         /pLJnY4AdTp0ON5MYiZC/+WXvo8VRLqr+zaP9LInz+pANyobPTHZbKUQojxujPYSh07d
         OvPg==
X-Gm-Message-State: AOAM532/9xOhWnup9SBiYXcph++jeBZzx19EO1VOwi/gmnx8PPpsL7yA
        uft4Jb07M8N2Rvc1GzC69CZCH4gQisXprAregv0kzT4T2S1e9ZjIK7oLLqKAhn2kEYHA/e2SmZP
        X9dimGCPf9t3vo5qqvOtySA==
X-Received: by 2002:a17:902:b601:b0:162:17c5:1fd9 with SMTP id b1-20020a170902b60100b0016217c51fd9mr10221759pls.16.1653355208455;
        Mon, 23 May 2022 18:20:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8PCrx4B3hjo9pzEm6nSbe+G9eskEIB9IzZjjZEjvpJRh3t+L5TD02tmV2Gv0cxP1MxZ1kWQ==
X-Received: by 2002:a17:902:b601:b0:162:17c5:1fd9 with SMTP id b1-20020a170902b60100b0016217c51fd9mr10221741pls.16.1653355208208;
        Mon, 23 May 2022 18:20:08 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id it6-20020a17090afb0600b001d9927ef1desm311810pjb.34.2022.05.23.18.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 18:20:07 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix decoding of client session messages flags
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220523160951.8781-1-lhenriques@suse.de>
 <1e1f7397d516f8b9780b08763f6338cd4ce83506.camel@kernel.org>
 <87y1ysky25.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3a5e1fdc-6ace-d4bc-7bca-20854155d652@redhat.com>
Date:   Tue, 24 May 2022 09:20:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87y1ysky25.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/24/22 12:34 AM, Luís Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
>
>> On Mon, 2022-05-23 at 17:09 +0100, Luís Henriques wrote:
>>> The cephfs kernel client started to show  the message:
>>>
>>>   ceph: mds0 session blocklisted
>>>
>>> when mounting a filesystem.  This is due to the fact that the session
>>> messages are being incorrectly decoded: the skip needs to take into
>>> account the 'len'.
>>>
>>> While there, fixed some whitespaces too.
>>>
>>> Fixes: e1c9788cb397 ("ceph: don't rely on error_string to validate blocklisted session.")
>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>> ---
>>>   fs/ceph/mds_client.c | 14 +++++++++-----
>>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index 00c3de177dd6..1bd3e1bb0fdf 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -3375,13 +3375,17 @@ static void handle_session(struct ceph_mds_session *session,
>>>   	}
>>>   
>>>   	if (msg_version >= 5) {
>>> -		u32 flags;
>>> -		/* version >= 4, struct_v, struct_cv, len, metric_spec */
>>> -	        ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 2, bad);
>>> +		u32 flags, len;
>>> +
>>> +		/* version >= 4 */
>>> +		ceph_decode_skip_16(&p, end, bad); /* struct_v, struct_cv */
>>> +		ceph_decode_32_safe(&p, end, len, bad); /* len */
>>> +		ceph_decode_skip_n(&p, end, len, bad); /* metric_spec */
>>> +
>>>   		/* version >= 5, flags   */
>>> -                ceph_decode_32_safe(&p, end, flags, bad);
>>> +		ceph_decode_32_safe(&p, end, flags, bad);
>>>   		if (flags & CEPH_SESSION_BLOCKLISTED) {
>>> -		        pr_warn("mds%d session blocklisted\n", session->s_mds);
>>> +			pr_warn("mds%d session blocklisted\n", session->s_mds);
>>>   			blocklisted = true;
>>>   		}
>>>   	}
>> Good catch! Should we send this to stable too?
> Ah, yeah.  I didn't explicitly tagged it as I assumed the 'Fixes:' would
> be enough for that.  But it's probably better to do add the 'Cc: stable'
> too.

Good catch! Merged into the testing branch and added the 'Cc: stable'.

Thanks Luis.

-- Xiubo


>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Cheers,

