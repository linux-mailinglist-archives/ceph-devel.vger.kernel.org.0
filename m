Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A4C4CB52A
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Mar 2022 03:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiCCC6U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 21:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbiCCC6T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 21:58:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80EDB18C
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 18:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646276253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N0Om0s0toRuZOMtemfumKR8pTI+MQ4imcpm+xvqVhoY=;
        b=aLeo8lqZcoKKJkI5kI1tPbmIri7DTTLruKwkUcV35O/bXDz8u76in3u2qHwwvqH/cAAmHw
        hh460XWjxLJdkHOVqoBE9gZrfVNSSSOpU6i7KoiX3nvaus+R+A5RXlx+OIpRh0ubhgwxUc
        uk1S+GMoqK4c0jmOjFm1KQ7UpxRD8Sw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-VGmj1vc1PPewqQLJK7bBlg-1; Wed, 02 Mar 2022 21:57:32 -0500
X-MC-Unique: VGmj1vc1PPewqQLJK7bBlg-1
Received: by mail-pj1-f69.google.com with SMTP id mm21-20020a17090b359500b001bf0de27d55so250717pjb.6
        for <ceph-devel@vger.kernel.org>; Wed, 02 Mar 2022 18:57:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=N0Om0s0toRuZOMtemfumKR8pTI+MQ4imcpm+xvqVhoY=;
        b=2DD3xixBVEG0NaNqWy+5zxofp/Nq1eQUwP3csaKw0gldCEIs9keL4vOROQ+FI2V8u+
         VBkml13GYuk2iKNen62y2oiubt/JaU0uE1eJ46qlwsfgSSmvAp+JyJi8GwH8n0OX4EiE
         sphp4YR/tG+m9XpiW14y0GwEj6jqgUI2PK4DgnGSnTf3hI+aJsdT0vDpiZMTxtCRrOm9
         Xqd5BrFmSeDivk17EXhCnuibCJkdJ7UHA/erjArDa2ZGxYZgq3el2FWXoOnYc3heht+A
         ybDepff/jpjMMmdHpgV95i+HxLGcoI4kRTUKd941c4rX8DD0pL17Iq1giYkgmB5K/jgq
         8xuQ==
X-Gm-Message-State: AOAM531jiHyWrwfs7e4K69QD4uy00eGRCcQEpE7F3IHA3J9H3guj+rVG
        Rk2M1FKiYWfLI4MUUH7msBtRE+zBO0ItrgRa23gyvrIbS5RSqwl1IR035TlZ15Whv/3nX02TkaR
        Jw828IcZYCRYoTBpYlB6BJSG/Aoftd6GQnk4qg7hb1EQZnntRp5SKypbrR4byfYrn8bgi/VQ=
X-Received: by 2002:a63:5758:0:b0:34e:b5da:7dac with SMTP id h24-20020a635758000000b0034eb5da7dacmr28271780pgm.515.1646276251251;
        Wed, 02 Mar 2022 18:57:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMoW/L9cnvTT1iDnw7CZ6ptOwXhAkm/snWA0HdkkHIIbMiMBFXpynItzp+t/IBlY0p1HcWeQ==
X-Received: by 2002:a63:5758:0:b0:34e:b5da:7dac with SMTP id h24-20020a635758000000b0034eb5da7dacmr28271763pgm.515.1646276250935;
        Wed, 02 Mar 2022 18:57:30 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nn5-20020a17090b38c500b001bf09d6c7d7sm775174pjb.26.2022.03.02.18.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 18:57:30 -0800 (PST)
Subject: Re: [PATCH v3 0/6] ceph: encrypt the snapshot directories
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220302121323.240432-1-xiubli@redhat.com>
 <87mti88isf.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c6e9a47b-1ca5-5ac6-7963-af7169827c16@redhat.com>
Date:   Thu, 3 Mar 2022 10:57:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87mti88isf.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
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


On 3/2/22 11:40 PM, Luís Henriques wrote:
> Hi Xiubo,
>
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This patch series is base on the 'wip-fscrypt' branch in ceph-client.
> I gave this patchset a try but it looks broken.  For example, if 'mydir'
> is an encrypted *and* locked directory doing:
>
> # ls -l mydir/.snap
>
> will result in:
>
> fscrypt (ceph, inode 1099511627782): Error -105 getting encryption context
>
> My RFC patch had an issue that I haven't fully analyzed (and that I
> "fixed" using the d_drop()).  But why is the much simpler approach I used
> not acceptable? (I.e simply use fscryt_auth from parent in
> ceph_get_snapdir()).

Hi Luis,

I will drop this patch series except the first 2:

   ceph: fail the request when failing to decode dentry names
   ceph: do not dencrypt the dentry name twice for readdir


Please go on with your RFC one.

I will fix the long snap issue after that or you can fix it in your next 
version.

Thanks.

BRs

- Xiubo


>
>> V3:
>> - Add more detail comments in the commit comments and code comments.
>> - Fix some bugs.
>> - Improved the patches.
>> - Remove the already merged patch.
>>
>> V2:
>> - Fix several bugs, such as for the long snap name encrypt/dencrypt
>> - Skip double dencypting dentry names for readdir
>>
>> ======
>>
>> NOTE: This patch series won't fix the long snap shot issue as Luis
>> is working on that.
> Yeah, I'm getting back to it right now.  Let's see if I can untangle this
> soon ;-)
>
> Cheers,

