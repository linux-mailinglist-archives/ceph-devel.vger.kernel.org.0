Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0C673D574
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Jun 2023 03:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjFZBFL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 25 Jun 2023 21:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjFZBFJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 25 Jun 2023 21:05:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B63194
        for <ceph-devel@vger.kernel.org>; Sun, 25 Jun 2023 18:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687741461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HnPIjne0x1y1DoyjPxRNCutxaRJPDQqxcvlLV/KyJEA=;
        b=PEOea9VELkAswgt9d5O6wiBqbRp6f0X2KSPZbfTaxSnN9cEelC1XuPKJQu5M6J5NCZCaAz
        tqKyGWMb1kgT3iZbcW1a4suwMUArH504YxZoPiFlYXCynd9/PTNZegd6WgV3TuzLu+7in4
        euwcNCOEIQuak9e3Ulh60G9VlW3vOpA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-En-CD2U7NUGqcfiOPQVDZg-1; Sun, 25 Jun 2023 21:04:12 -0400
X-MC-Unique: En-CD2U7NUGqcfiOPQVDZg-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3ff263bfb9bso42143461cf.2
        for <ceph-devel@vger.kernel.org>; Sun, 25 Jun 2023 18:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687741452; x=1690333452;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HnPIjne0x1y1DoyjPxRNCutxaRJPDQqxcvlLV/KyJEA=;
        b=KSZeLafqQY85n/qmva/8/jLQtOgYStN06FcN9wCwjFqGyLNVwlN6Qk8MJAOgVzpJnI
         aPq/cS6kRpmExhj5CWgJR4ClL3STTR3gMYsNdoXno2Gk5/E79Th0qTuXnf0gZ6G2OLi+
         HDjzE4tAtDmYJH/N34cQ3LzJCbooB0D9wAyJx0YkV2mP721/ZnAcimV0iwuNe3f40IMj
         qTdDxs/YFADFsxPS29tCHnsTfy9M85V+An6/5YZhAOyUZrGj+I5PRXocg4MCZvykgtS+
         g5r7C7U4+ar+iSy5zOfAi9lpQuceD4QdTm0FtUt6DcUhkGLtsfm2mgJH4RY0b74P8i3V
         5dew==
X-Gm-Message-State: AC+VfDxMGH6jwFaSPu6OAQ67WG2sPZ7VD5z3GmpUVmBkyEcxHzuoR7c1
        kGG8shBkfoz6bKRBSqWkYJ4piMlRmlfzdiSZa7prX1KRhXBniWVeGhT8x1U8vgM7/zllC+NV5mV
        DCPaouDRZ/hsR1kIZ36FN1j57BaN65gsH
X-Received: by 2002:a05:622a:1746:b0:3ff:3013:d2aa with SMTP id l6-20020a05622a174600b003ff3013d2aamr23516663qtk.12.1687741451950;
        Sun, 25 Jun 2023 18:04:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4idNNjnMM8gpr1GtyoBrIaFW7cf3mYtsIZ4nJK2ezWCuF96/z5OGWIK/9rLURs/Xj24jHDUg==
X-Received: by 2002:a05:622a:1746:b0:3ff:3013:d2aa with SMTP id l6-20020a05622a174600b003ff3013d2aamr23516640qtk.12.1687741451626;
        Sun, 25 Jun 2023 18:04:11 -0700 (PDT)
Received: from [10.72.13.91] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d26-20020aa7869a000000b0063d2dae6247sm776415pfo.77.2023.06.25.18.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jun 2023 18:04:11 -0700 (PDT)
Message-ID: <07b01202-9c38-70a7-8701-be8992a1d17e@redhat.com>
Date:   Mon, 26 Jun 2023 09:04:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 00/14] ceph: support idmapped mounts
Content-Language: en-US
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        Christian Brauner <brauner@kernel.org>, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
 <f3864ed6-8c97-8a7a-f268-dab29eb2fb21@redhat.com>
 <CAEivzxcRsHveuW3nrPnSBK6_2-eT4XPvza3kN2oogvnbVXBKvQ@mail.gmail.com>
 <20230609-alufolie-gezaubert-f18ef17cda12@brauner>
 <CAEivzxc_LW6mTKjk46WivrisnnmVQs0UnRrh6p0KxhqyXrErBQ@mail.gmail.com>
 <ac1c6817-9838-fcf3-edc8-224ff85691e0@redhat.com>
 <CAJ4mKGby71qfb3gd696XH3AazeR0Qc_VGYupMznRH3Piky+VGA@mail.gmail.com>
 <977d8133-a55f-0667-dc12-aa6fd7d8c3e4@redhat.com>
 <CAEivzxcr99sERxZX17rZ5jW9YSzAWYvAjOOhBH+FqRoso2=yng@mail.gmail.com>
 <626175e2-ee91-0f1a-9e5d-e506aea366fa@redhat.com>
 <bb20aebe-e598-9212-1533-c777ea89948a@redhat.com>
 <CAEivzxdBoWrN1cNrotAcKrfRHg+0oajwSFT3OBAKTrjvmn=MKA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAEivzxdBoWrN1cNrotAcKrfRHg+0oajwSFT3OBAKTrjvmn=MKA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/15/23 20:54, Aleksandr Mikhalitsyn wrote:
> On Thu, Jun 15, 2023 at 2:29 PM Xiubo Li <xiubli@redhat.com> wrote:
>> [...]
>>
>>   > > >
>>   > > > I thought about this too and came to the same conclusion, that
>> UID/GID
>>   > > > based
>>   > > > restriction can be applied dynamically, so detecting it on mount-time
>>   > > > helps not so much.
>>   > > >
>>   > > For this you please raise one PR to ceph first to support this, and in
>>   > > the PR we can discuss more for the MDS auth caps. And after the PR
>>   > > getting merged then in this patch series you need to check the
>>   > > corresponding option or flag to determine whether could the idmap
>>   > > mounting succeed.
>>   >
>>   > I'm sorry but I don't understand what we want to support here. Do we
>> want to
>>   > add some new ceph request that allows to check if UID/GID-based
>>   > permissions are applied for
>>   > a particular ceph client user?
>>
>> IMO we should prevent users to set UID/GID-based MDS auth caps from ceph
>> side. And users should know what has happened.
> ok, we want to restrict setting of UID/GID-based permissions if there is an
> idmapped mount on the client. IMHO, idmapping mounts is truly a
> client-side feature
> and server modification looks a bit strange to me.

Yeah, agree.

But without fixing the lookup issue in kclient side it will be buggy and 
may make some tests fail too.

We need to support this more smoothly.

Thanks

- Xiubo

>> Once users want to support the idmap mounts they should know that the
>> MDS auth caps won't work anymore.
> They will work, but permission rule configuration should include
> non-mapped UID/GID-s.
> As I mentioned here [1] it's already the case even without mount idmappings.
>
> It would be great to discuss this thing as a concept and synchronize
> our understanding of this
> before going into modification of a server side.
>
> [1] https://lore.kernel.org/lkml/CAEivzxcBBJV6DOGzy5S7=TUjrXZfVaGaJX5z7WFzYq1w4MdtiA@mail.gmail.com/
>
> Kind regards,
> Alex
>
>> Thanks
>>
>> - Xiubo
>>

