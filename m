Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E4A7274C0
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 04:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjFHCLn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 22:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFHCLm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 22:11:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E530826A6
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 19:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686190250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JVDf6yzD7BE64muiRXWiwqHaSixH+a5wIJ9qFhiY3KY=;
        b=HfwPSD77tG8/RbaWMN/vvm9YdnUyg0zrP68JO1Fv9v6epyVqDBT6ohTWigMNJdGp/cQWED
        nvWRSeBiIjFac2iSdwQW1vOiuum/ItsH+AuqoykXZvnq8Qc+KwKW4PpewBTe7ch183xgbf
        dSi4r1ZoK94unz7RhYOeH1fDby3QmvM=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-Fd4NCxHCOzyut_iqMgEdjQ-1; Wed, 07 Jun 2023 22:10:48 -0400
X-MC-Unique: Fd4NCxHCOzyut_iqMgEdjQ-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-558a4e869bcso107042eaf.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 19:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686190248; x=1688782248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JVDf6yzD7BE64muiRXWiwqHaSixH+a5wIJ9qFhiY3KY=;
        b=EIxns3ZZyMzLh8zbSOnE+J5Hvyk18vMFT8qEDqyJb8RdYJcObnrSmzQoM1N9R1dPyY
         jUhWTx3SgOG2ZRAJJHmtVCaRti/UzFdgbNDl584AJyMzhYAxgwZX1pQ/AaQYfzCrhnU4
         wpeBEURLsRsG6zRnSHbSFNWyXLrG79H3zJtZ7j1HkO0IHZ43JCNEj1owR6iHBCZavj3o
         D8ljPqeeizzgZ+LU6/wPpfRYABEgy5WGhd34tZ2Lw8SUBqctKhyNkOOqC6qRqwfYzA44
         5YXkMIi771GBk7AyVyhx65EPmJro4s2YE1WTyUYaxGksQKIQYJotHii+iL9qgylGIPl4
         gi6w==
X-Gm-Message-State: AC+VfDwFYD8emVMeNO/RSVqGkHky9EZdt9vL1S/Mz+7l/x56fhPwNtjY
        Ke7iV3DhyyOhA73ZIo1f2qZBWRDFJemTDcY1QyDFyPoaO3i1lkgumK2CXdfHLSS7wLGOD8NeEuI
        /6paQLnidTAXRps4JUkOCyw==
X-Received: by 2002:a05:6359:208:b0:129:c9fa:e66b with SMTP id ej8-20020a056359020800b00129c9fae66bmr5295985rwb.1.1686190247961;
        Wed, 07 Jun 2023 19:10:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7wL9p58ANFD0Z8a/Uwy54G2YBsHDRxeH2wqcos5yt+wZGjaltOonmlto/blRNIcDEzjkl/Yw==
X-Received: by 2002:a05:6359:208:b0:129:c9fa:e66b with SMTP id ej8-20020a056359020800b00129c9fae66bmr5295961rwb.1.1686190247651;
        Wed, 07 Jun 2023 19:10:47 -0700 (PDT)
Received: from [10.72.13.135] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i26-20020a63585a000000b00543f7538d64sm132023pgm.31.2023.06.07.19.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 19:10:47 -0700 (PDT)
Message-ID: <53f6d18b-0340-5648-6b65-c12140b3382b@redhat.com>
Date:   Thu, 8 Jun 2023 10:10:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 0/2] ceph: fix fscrypt_destroy_keyring use-after-free
 bug
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
References: <20230606033212.1068823-1-xiubli@redhat.com>
 <87pm689asx.fsf@suse.de> <7ab9007b-763b-aacf-2297-62f1989e2efd@redhat.com>
 <87h6rj8wav.fsf@suse.de>
 <CAOi1vP9+rTB=EcfWNLxmB=67YYxxan=69A7AM67wMxh_4+feDA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9+rTB=EcfWNLxmB=67YYxxan=69A7AM67wMxh_4+feDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/7/23 18:00, Ilya Dryomov wrote:
> On Wed, Jun 7, 2023 at 11:18 AM Luís Henriques <lhenriques@suse.de> wrote:
>> Xiubo Li <xiubli@redhat.com> writes:
>>
>>> On 6/6/23 17:53, Luís Henriques wrote:
>>>> xiubli@redhat.com writes:
>>>>
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> V2:
>>>>> - Improve the code by switching to wait_for_completion_killable_timeout()
>>>>>     when umounting, at the same add one umount_timeout option.
>>>> Instead of adding yet another (undocumented!) mount option, why not re-use
>>>> the already existent 'mount_timeout' instead?  It's already defined and
>>>> kept in 'struct ceph_options', and the default value is defined with the
>>>> same value you're using, in CEPH_MOUNT_TIMEOUT_DEFAULT.
>>> This is for mount purpose. Is that okay to use the in umount case ?
>> Yeah, you're probably right.  It's just that adding yet another knob for a
>> corner case that probably will never be used and very few people will know
>> about is never a good thing (IMO).  Anyway, I think that at least this new
>> mount option needs to be mentioned in 'Documentation/filesystems/ceph.rst'.
> It's OK and in fact preferrable to stick to mount_timeout to avoid new
> knobs.  There is even a precedent for this: RBD uses mount_timeout both
> when waiting for the latest osdmap (on "rbd map") and when tearing down
> a watch (on "rbd unmap").

If so let's reuse the 'mount_timeout' here.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>

