Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E404CE4D7
	for <lists+ceph-devel@lfdr.de>; Sat,  5 Mar 2022 13:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiCEMoH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 5 Mar 2022 07:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiCEMoG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 5 Mar 2022 07:44:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8958164D14
        for <ceph-devel@vger.kernel.org>; Sat,  5 Mar 2022 04:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646484194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8GqpN7gIPCwWSZ62iyPP0jbygDvqFyRDbk/03WQxzCo=;
        b=DUdq3FWxnuuFCBkfvRBwTI25R2gaE9jzQdSVhoEdMWxpfeAarvZsg/1dQ05sLh4uEZcu3s
        mLdc3dRMb/IvuMVpTHFV75Hlo2+Qnc9M89SoDgTUF2tlCjSqaEsLf/hC8+/3R3yETrDXUy
        tWw++/BI6HU2Kt2p08JE5jeEfrIqaq4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-Qz64j5brOum3mO7dGgE_Xw-1; Sat, 05 Mar 2022 07:43:14 -0500
X-MC-Unique: Qz64j5brOum3mO7dGgE_Xw-1
Received: by mail-pj1-f71.google.com with SMTP id lp2-20020a17090b4a8200b001bc449ecbceso9078905pjb.8
        for <ceph-devel@vger.kernel.org>; Sat, 05 Mar 2022 04:43:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8GqpN7gIPCwWSZ62iyPP0jbygDvqFyRDbk/03WQxzCo=;
        b=VKZM/UBSInLUa68Kz3p8cdv2Wg4vBMFglgexxM5L+m58HprbC0EjCTevsrw9IypahO
         /DkxlEA7ZzhTWUVeE6d33L0Ry4k8JaGP7roGA07EvHJrVzzNN4AXYZSXAyO6Pse4A0N8
         9cVPaMKlhebDFpyJ+dqtNxXPD5NClSLjm2dBC41Z2BmJjolkznZa1FrYSPODxLFlNzbx
         S4WYosRnJE7dKu0l6GcoiK7xDMemZdTra9rLI+LL5SOmad704pkEDiLhIKsppBtiAVvF
         g84xCP1QGrbshPqOg8I7D+34LaWnXLy/4Yamw9MfdWxOmz1mA/we1hz0Ia2ZeXH2EGUr
         2W+A==
X-Gm-Message-State: AOAM532YQ9Dqd8VT4i8HBZ8YFd1OdArWOtj9yoKNDtVkp+hEXRJbsgAi
        s3G3Jimt0n0b73nuFHLu5EN5pckH9ijqcpQJvTOhs51JybrBqCYlQgoXHOGK99jSjTmuILtEL3a
        ehdT1xxgIF52W/l/yeAGtiw==
X-Received: by 2002:a17:90a:4542:b0:1b9:bc2a:910f with SMTP id r2-20020a17090a454200b001b9bc2a910fmr3530232pjm.133.1646484192421;
        Sat, 05 Mar 2022 04:43:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQOfYR7Y7u5dlrB2KRWzLGnzKbsJUjzPINaLf3a/iXbCGyBHHPekYnv12fb+marCAiF0kIVg==
X-Received: by 2002:a17:90a:4542:b0:1b9:bc2a:910f with SMTP id r2-20020a17090a454200b001b9bc2a910fmr3530216pjm.133.1646484192159;
        Sat, 05 Mar 2022 04:43:12 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm7189298pgs.10.2022.03.05.04.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 04:43:11 -0800 (PST)
Subject: Re: [PATCH 2/3] ceph: fix use-after-free in ceph_readdir
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220304161403.19295-1-lhenriques@suse.de>
 <20220304161403.19295-3-lhenriques@suse.de>
 <55c6363a0ef0dcca3e6a7c882783f5d47dbbbdc7.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <79cd6979-cb02-c0a3-a4e9-d66f65d78976@redhat.com>
Date:   Sat, 5 Mar 2022 20:43:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <55c6363a0ef0dcca3e6a7c882783f5d47dbbbdc7.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/5/22 2:20 AM, Jeff Layton wrote:
> On Fri, 2022-03-04 at 16:14 +0000, Luís Henriques wrote:
>> After calling ceph_mdsc_put_request() on dfi->last_readdir, this field
>> should be set to NULL, otherwise we may end-up freeing it twince and get
>> the following splat:
>>
>>    refcount_t: underflow; use-after-free.
>>    WARNING: CPU: 0 PID: 229 at lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0
>>    ...
>>    Call Trace:
>>      <TASK>
>>      ceph_readdir+0xd35/0x1460 [ceph]
>>      ? _raw_spin_unlock+0x12/0x30
>>      ? preempt_count_add+0x73/0xa0
>>      ? _raw_spin_unlock+0x12/0x30
>>      ? __mark_inode_dirty+0x27c/0x3a0
>>      iterate_dir+0x7d/0x190
>>      __x64_sys_getdents64+0x80/0x120
>>      ? compat_fillonedir+0x160/0x160
>>      do_syscall_64+0x43/0x90
>>      entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>> ---
>>   fs/ceph/dir.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index 0bcb677d2199..934402f5e9e6 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -555,6 +555,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>>   			dout("filldir stopping us...\n");
>>   			ceph_mdsc_put_request(dfi->last_readdir);
>> +			dfi->last_readdir = NULL;
>>   			err = 0;
>>   			goto out;
>>   		}
> I think Xiubo fixed this in the testing branch late yesterday. It should
> no longer be needed.

Right and I have sent a new version of my previous patch to remove the 
buggy code.

- Xiubo

> Thanks,

