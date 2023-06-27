Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D2F7406F6
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Jun 2023 01:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjF0Xs3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 19:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjF0Xs3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 19:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F019C1BF6
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 16:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687909661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p5tWvEnlmXukdOzBaVvF5tNsi5RYXX4F3T1gzeDRE1U=;
        b=hLPxX2CVsYuAbQUUe4Ely1HG12sSWt21vFPa54hsZGAEzxoQizMvMN153Jmy8M1S7DFu1Z
        dyF+kSuIeKudWb4ixBYRHpqNrn7UwlIKjJJzEZnsRU2bmxl/OMRA7PgNqbG1G1lnYvKoDc
        jnNNs1sllOAKotajYBjInIFy+vHIxsQ=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-h6eAgQCAMauqiPsd74CRRw-1; Tue, 27 Jun 2023 19:47:39 -0400
X-MC-Unique: h6eAgQCAMauqiPsd74CRRw-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b80c1966d4so1964405ad.1
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 16:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687909659; x=1690501659;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p5tWvEnlmXukdOzBaVvF5tNsi5RYXX4F3T1gzeDRE1U=;
        b=dqIQaFCq3MAwWjlfEHkOy4njn5lQFFPnCWFWBxTg9aqn4QiHZL30sEeV69uMDZHB5v
         mzA96c7A+Z4+xvFkmX61dVH6bRRWjldeCF7yAuju06GBblbb0VeX6WwiZ/hzLRHVKg8P
         0upnVur1P7QbLq3hAdQ1KwPOihKGky3Jr5kRyb6xraSltGNQno5g10CMxSecg8KqThzQ
         EmRSvOouJroK6s9gMURu1o/Elp/TXqN+CHrflwfXUtveU/LhuPDKAE6R8a1seNjy4dId
         4eew32GMiGmQt46hf9dRsoBfAp+B19fmT5DyQC9KDK/jWYx58/lV76gUlKbc+p5PWF1v
         NwBw==
X-Gm-Message-State: AC+VfDxsFaKnWnJn4CfmTabeNJEqDtInh0TosTCikVpDBCd2smJB1l7l
        ZqY22711n24FXMalsVe1+4Oly1RiJ+064XMgzZP8PeuZ5bLINIPCbE/cZYb8S+AKu96S2TAUxBG
        yLZs7fgdYD/sq3VRcVCT4Xw==
X-Received: by 2002:a17:903:2343:b0:1b5:674d:2aa5 with SMTP id c3-20020a170903234300b001b5674d2aa5mr14923081plh.13.1687909658914;
        Tue, 27 Jun 2023 16:47:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6CqylpYf1D1YvxjOr/FiwXzRr1Zjo1GdpTzMi1IjHCXr5turKAdMTmed7U8sU3JLvLExrSTw==
X-Received: by 2002:a17:903:2343:b0:1b5:674d:2aa5 with SMTP id c3-20020a170903234300b001b5674d2aa5mr14923071plh.13.1687909658568;
        Tue, 27 Jun 2023 16:47:38 -0700 (PDT)
Received: from [10.72.13.91] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902bccb00b001a0448731c2sm6473755pls.47.2023.06.27.16.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 16:47:38 -0700 (PDT)
Message-ID: <b4f3c2d2-14e6-f400-bb8d-0a6287b56084@redhat.com>
Date:   Wed, 28 Jun 2023 07:47:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] ceph: don't let check_caps skip sending responses for
 revoke msgs
Content-Language: en-US
To:     Milind Changire <mchangir@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
References: <20230627070101.170876-1-xiubli@redhat.com>
 <CAED=hWCAMVX-Y8GDCU7VOSEgB_aBZxZWqdjdVsF6_jAzdAfyMA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAED=hWCAMVX-Y8GDCU7VOSEgB_aBZxZWqdjdVsF6_jAzdAfyMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/27/23 21:57, Milind Changire wrote:
> On Tue, Jun 27, 2023 at 12:33 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If just before the revoke request, which will increase the 'seq', is
>> sent out the clients released the corresponding caps and sent out
>> the cap update request to MDS with old 'seq', the mds will miss
>> checking the seqs and calculating the caps.
>>
>> We should always send an ack for revoke requests.
> I think the commit message needs to be rephrased for better
> understanding to something like:
>
> If a client sends out a cap update request with the old 'seq' just
> before a pending cap revoke request, then the MDS might miscalculate
> the 'seqs' and caps. It's therefore always a good idea to ack the cap
> revoke request with the bumped up 'seq'.
>
> Xiubo, please let me know if this sounds okay to you.
>
Milind,

Yeah, this looks much better.

I will update it.

Thanks

- Xiubo


>> Cc: stable@vger.kernel.org
>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>> URL: https://tracker.ceph.com/issues/61782
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 1052885025b3..eee2fbca3430 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3737,6 +3737,15 @@ static void handle_cap_grant(struct inode *inode,
>>          }
>>          BUG_ON(cap->issued & ~cap->implemented);
>>
>> +       /* don't let check_caps skip sending a response to MDS for revoke msgs */
>> +       if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
>> +               cap->mds_wanted = 0;
>> +               if (cap == ci->i_auth_cap)
>> +                       check_caps = 1; /* check auth cap only */
>> +               else
>> +                       check_caps = 2; /* check all caps */
>> +       }
>> +
>>          if (extra_info->inline_version > 0 &&
>>              extra_info->inline_version >= ci->i_inline_version) {
>>                  ci->i_inline_version = extra_info->inline_version;
>> --
>> 2.40.1
>>
>

