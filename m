Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D0263C32D
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Nov 2022 15:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbiK2Ovn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Nov 2022 09:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiK2Ovc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Nov 2022 09:51:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3EDE20
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 06:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669733405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIj+Nbz6AgLqQCcGS/FsFSBmr6PKvS7lGQO6Xq5OhrQ=;
        b=RNdmPvfPMoOzrWDi/naupTddDT71lgdsoHHWgx+9U90Zve5VcgYAcJ8FwD5QzWN54bsZpO
        QYY+4dHF8Sqd3bdW+aufs2yIATawNryYtqHYHQieFb4n5LTtwa/N+8OwJKE/cU11hGw5uj
        IjfHX9AgJkTONcLhptQaj/GPWB6vBJY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-1-_D2pQHK7NoyiLdjgnM5X8Q-1; Tue, 29 Nov 2022 09:49:59 -0500
X-MC-Unique: _D2pQHK7NoyiLdjgnM5X8Q-1
Received: by mail-pg1-f199.google.com with SMTP id a33-20020a630b61000000b00429d91cc649so9251931pgl.8
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 06:49:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rIj+Nbz6AgLqQCcGS/FsFSBmr6PKvS7lGQO6Xq5OhrQ=;
        b=Q/dJGIqhrtqfinwuCyUFS2mUBCnhXp0oMw3exPJmS7kWlBa5xsLI6Expr5DngtPJ3q
         Ek+jgCk+VMkOnu42dKQeVWaWd7qtNOvWCk89aZERlmPShfzsq0I9z5AWi3swa8LavG+d
         cEn1yR0m3+2ulqiP2GTXKZ+Uc/JtEwqFTfnO0SWDOGDzoShns7Dw3jkpGgXSxP9iKWi4
         KSr7/cUBpRF4oKGeE3OzrQ1V9M/CS0zOPNVq6F6sboCLepXwHMkI2pBaFMkew9d7Q9mL
         3lmTEABx8w3KIcAOEzL8goxxJVH+BBuUqgUAFfJDYV1ttQFL1ezHdVQSiHD6eFwTFTYQ
         p3JA==
X-Gm-Message-State: ANoB5pnYHgMOWqRv1Mu3zFH3jgtZGL8cvFpz7uB3yLBKtbJUJHffHs9j
        FY+Q3cdeitpcu9tR5rWNsfmZaRMv1EIxhrigsCXE4mnzXmtTm9+OMgED+EsJismn0GDuAUeTGpC
        xv2haDWTgHueL6cru8Es1NA==
X-Received: by 2002:a17:90a:77c9:b0:218:7bf1:386b with SMTP id e9-20020a17090a77c900b002187bf1386bmr57033008pjs.65.1669733398081;
        Tue, 29 Nov 2022 06:49:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5nZA8ECCkd9OhgwdfN5enInsLFG6AGdiZctNBhdjYv3mrM+xKnAW0AgSq0QNXPwjqRxxBzqw==
X-Received: by 2002:a17:90a:77c9:b0:218:7bf1:386b with SMTP id e9-20020a17090a77c900b002187bf1386bmr57032990pjs.65.1669733397822;
        Tue, 29 Nov 2022 06:49:57 -0800 (PST)
Received: from [10.72.12.126] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nh10-20020a17090b364a00b002195819d541sm763567pjb.8.2022.11.29.06.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 06:49:57 -0800 (PST)
Subject: Re: [PATCH v4] ceph: mark directory as non-complete complete after
 loading key
To:     Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>
Cc:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221129103949.19737-1-lhenriques@suse.de>
 <4914a195-edc0-747b-6598-9ac9868593a1@redhat.com>
 <CAOi1vP8raoFP2dsc6RY1fONCsHh5FYv2xifFY7pHXZWX=-vePw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <20e0674a-4e51-a352-9ce2-d939cd4f3725@redhat.com>
Date:   Tue, 29 Nov 2022 22:49:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8raoFP2dsc6RY1fONCsHh5FYv2xifFY7pHXZWX=-vePw@mail.gmail.com>
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


On 29/11/2022 22:32, Ilya Dryomov wrote:
> On Tue, Nov 29, 2022 at 3:15 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 29/11/2022 18:39, Luís Henriques wrote:
>>> When setting a directory's crypt context, ceph_dir_clear_complete() needs to
>>> be called otherwise if it was complete before, any existing (old) dentry will
>>> still be valid.
>>>
>>> This patch adds a wrapper around __fscrypt_prepare_readdir() which will
>>> ensure a directory is marked as non-complete if key status changes.
>>>
>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>> ---
>>> Hi Xiubo,
>>>
>>> Here's a rebase of this patch.  I did some testing but since this branch
>>> doesn't really have full fscrypt support, I couldn't even reproduce the
>>> bug.  So, my testing was limited.
>> I'm planing not to update the wip-fscrypt branch any more, except the IO
>> path related fixes, which may introduce potential bugs each time as before.
>>
>> Since the qa tests PR has finished and the tests have passed, so we are
>> planing to merge the first none IO part, around 27 patches. And then
>> pull the reset patches from wip-fscrypt branch.
> I'm not sure if merging metadata and I/O path patches separately
> makes sense.  What would a user do with just filename encryption?

Hi Ilya,

I think the IO ones should be followed soon.

Currently the filename ones have been well testes. And the contents will 
be by passed for now.

Since this is just for Dev Preview feature IMO it should be okay (?)

> Once fscrypt test suite is merged, I think we should let it bake
> for for a few weeks and then merge the whole thing together.

Talked with Jeff before we both agreed to split the patches to make it 
to be easier to handle.

But this also should be okay for me.

Venky, Greg

What do you think ?

Thanks.

- Xiubo


>
> Thanks,
>
>                  Ilya
>

