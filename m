Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEBF4D6B66
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Mar 2022 01:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiCLAU2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 19:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiCLAU0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 19:20:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC324DB1
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 16:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647044360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJVnshard9KzzxyN4KnMo3a4e9qM8q0HuuqbVgKpwbc=;
        b=AiEpSeG8RfGcEU6pIcSbFOKhnxsoXdHq+AjoBpHReTWy4zXgO87yxcxwOMUVATF+iPoQ8/
        9O0sse3FZT5C34nu/2gwMAw/xvRGA+Zi9c4xFSZZ39YDs9MK0p9uNzpJEcfgGYdFKPMZPx
        r2uAy2X+/zob3wH3uTXjCIZZR8eqDbc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-RtVwB2CcN1CbFlIBlwBwWw-1; Fri, 11 Mar 2022 19:19:19 -0500
X-MC-Unique: RtVwB2CcN1CbFlIBlwBwWw-1
Received: by mail-pj1-f69.google.com with SMTP id e14-20020a17090a684e00b001bf09ac2385so6247412pjm.1
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 16:19:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RJVnshard9KzzxyN4KnMo3a4e9qM8q0HuuqbVgKpwbc=;
        b=lbQAH7CLULLQ7C/nKtkoxZeqk776caFIGKg7xabZ2BYiQWvQbTt3t2Wj1Gm3eNdLHj
         oqzGLmUPG1qWEn1U9PbeuQArhEeKiwzy6ra/mthjyOe1eB6Ftvzj9AN84WzhSLmSLRTO
         gz44qg/AFhXsq0XBbELIGX2mEEfdXG0kbMhwZvlCHJBXMa5YRFIGeCkLJI/kHvQ9ximN
         61MgVciZPaspeFA0FRBQXj8hAi3kvxoE8eqtwsoXIyoX9B5kPY+j+qbocS9ODwu+mPLy
         SvG4opVU90ciWcvCkampqKmMimoyR2oJ3Su0uqaFV8+cEQ/c75Xs1aM3H/h2F5FlHtq/
         zmMQ==
X-Gm-Message-State: AOAM532ec+eLtNcdzRqx+4M7YxM6yURW94VceaFLOvwp76QGson1Q0V+
        qkl5xtMpHZP+JLLjPArsc/R2B8cBbj3dvdQqne3KTqkGttiyYwidr0zknG8xKecTcOr4qNm72/B
        aEx5qVcTVrKQMw7gO0rYsA1MyZmh9wY1PORxV+Utwfd5p+41WKNP3SFrLLJiC1tjcr2ZIiUE=
X-Received: by 2002:a05:6a00:1687:b0:4e1:45d:3ded with SMTP id k7-20020a056a00168700b004e1045d3dedmr12652091pfc.0.1647044358409;
        Fri, 11 Mar 2022 16:19:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7sRh7KkvMwtUVQ/Rm2kG6UwPM8qpSLiKDn1RqO1ZWwtJw+pVJTkah+jvp9V231Z6gWgt/Ew==
X-Received: by 2002:a05:6a00:1687:b0:4e1:45d:3ded with SMTP id k7-20020a056a00168700b004e1045d3dedmr12652060pfc.0.1647044358070;
        Fri, 11 Mar 2022 16:19:18 -0800 (PST)
Received: from [10.72.12.132] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l2-20020a637c42000000b003644cfa0dd1sm9181815pgn.79.2022.03.11.16.19.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 16:19:17 -0800 (PST)
Subject: Re: [PATCH] ceph: fix base64 encoded name's length check in
 ceph_fname_to_usr()
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220311041505.160241-1-xiubli@redhat.com>
 <e20170a5767809cdf82ce052d2bc09b559df0a50.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ffba1784-3472-4b7e-1cd5-da6562758a62@redhat.com>
Date:   Sat, 12 Mar 2022 08:19:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e20170a5767809cdf82ce052d2bc09b559df0a50.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/12/22 1:14 AM, Jeff Layton wrote:
> On Fri, 2022-03-11 at 12:15 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The fname->name is based64_encoded names and the max long shouldn't
>> exceed the NAME_MAX.
>>
>> The FSCRYPT_BASE64URL_CHARS(NAME_MAX) will be 255 * 4 / 3.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Note:
>>
>> This patch is bansed on the wip-fscrpt branch in ceph-client repo.
>>
>>
>>   fs/ceph/crypto.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
>> index 5a87e7385d3f..560481b6c964 100644
>> --- a/fs/ceph/crypto.c
>> +++ b/fs/ceph/crypto.c
>> @@ -205,7 +205,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
>>   	}
>>   
>>   	/* Sanity check that the resulting name will fit in the buffer */
>> -	if (fname->name_len > FSCRYPT_BASE64URL_CHARS(NAME_MAX))
>> +	if (fname->name_len > NAME_MAX || fname->ctext_len > NAME_MAX)
>>   		return -EIO;
>>   
>>   	ret = __fscrypt_prepare_readdir(fname->dir);
> Thanks, Xiubo. Merged into wip-fscrypt branch. For now I've left this as
> a separate patch, but I may squash it into the patch that adds
> ceph_fname_to_usr eventually.
>
Yeah, sure. Maybe just as one separate patch to help other to understand 
the code here ?

Thanks Jeff.

- Xiubo


