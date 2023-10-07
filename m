Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5F27BC38D
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Oct 2023 03:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbjJGBRW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Oct 2023 21:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjJGBRV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Oct 2023 21:17:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2DEBF
        for <ceph-devel@vger.kernel.org>; Fri,  6 Oct 2023 18:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696641393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yU/b+qW/jt3Ky9sBFDgWU60T0gwP2Mtv1jApxG731v4=;
        b=EKdzrSTZthcSIy1YZ2snK3Oh6d5JhYXFNOVJBmloD/OcT8twKYPJNy+bPZJMfQ2NxUSyTi
        DMYCsAzxopdAsDclkiGDeGyT+eZHIeAFRtHsCPZK/5zzqUtsuFWQG1UrIpMumt86pDcS+I
        vdcLjQkCcHBEB0NTnE68NIxg7oTVL3A=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-b58ImknHPNKTzQqL_LLwKw-1; Fri, 06 Oct 2023 21:16:31 -0400
X-MC-Unique: b58ImknHPNKTzQqL_LLwKw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1c5b80fe118so25717465ad.3
        for <ceph-devel@vger.kernel.org>; Fri, 06 Oct 2023 18:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696641389; x=1697246189;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yU/b+qW/jt3Ky9sBFDgWU60T0gwP2Mtv1jApxG731v4=;
        b=aHcBXF80SdZ8sIjbGNwWg3xP/Br7+gaYlobkNWYuk0FWDwyYqz3B42ed/gRhg/1ahI
         dC8tIC1QVKD/1TVADgck2rhBQ/3Qco2pO4C7O1m/McWRJ6CdMvmt+L3104dkEn/2USGx
         ncEgN2iB/b/1voa4qOxdUbK8siIa6LeH1CKk2+DsYM4gt2YtV4XHRrDawAv4qdjhyE/d
         wNWf7ZVA4ZAItaYjD8V6ud3WgYemx9DSbQMVTNbDL6K/78jVVN7lo18THjPADnY82Wrm
         AEWneUfyQ6TfO/wt4iCrVvpaJrWkuQpUs14hceWyJZsDS9dz04EJpUvm5kJWUzptAqO2
         ueQw==
X-Gm-Message-State: AOJu0YyWxuSe5vOc59Foewh/snH3Z5QMtwrUFZknkLm5xFNSpaAqhd/S
        JD16TVu+L789pZQNTfNiqbilnZkPfZr8nQ1grQXFQvqSJBM31TeA2AiYrYBGQTXEc+BRg/xJrUb
        PncuKnQMK7XyWyg8BGuKtgw==
X-Received: by 2002:a17:902:dacd:b0:1c7:54ee:c53c with SMTP id q13-20020a170902dacd00b001c754eec53cmr10904151plx.57.1696641389373;
        Fri, 06 Oct 2023 18:16:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoX2lEJYWtMv9rwsseuuXQ5aYB9vEQQGyLl1giWXgmoCkf2Xo+AEx7Bku9vkGdyREy38KXgQ==
X-Received: by 2002:a17:902:dacd:b0:1c7:54ee:c53c with SMTP id q13-20020a170902dacd00b001c754eec53cmr10904138plx.57.1696641388931;
        Fri, 06 Oct 2023 18:16:28 -0700 (PDT)
Received: from [10.72.112.33] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e18-20020a17090301d200b001b89b1b99fasm4549150plh.243.2023.10.06.18.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Oct 2023 18:16:28 -0700 (PDT)
Message-ID: <db938fb9-9e33-279a-1284-fe39cdbd2834@redhat.com>
Date:   Sat, 7 Oct 2023 09:16:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] Revert "ceph: enable async dirops by default"
To:     Venky Shankar <vshankar@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, mchangir@redhat.com
References: <20231003110556.140317-1-vshankar@redhat.com>
 <CAOi1vP89eWiqUy9yZhWcSzujFre8YSnrCiNMczE_cX3QbDRsEg@mail.gmail.com>
 <CACPzV1nwAubtY2dxp88_sNNNA2DU0sOtCaSJiSoKjXcD0LHJQA@mail.gmail.com>
 <CACPzV1mWhaoPor4T8n=kX5oFjRjkbtQr5t9kZ6uCgsGciBafMA@mail.gmail.com>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1mWhaoPor4T8n=kX5oFjRjkbtQr5t9kZ6uCgsGciBafMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/4/23 21:15, Venky Shankar wrote:
> Hi Ilya,
>
> After some digging and talking to Jeff, I figured that it's possible
> to disable async dirops from the mds side by setting
> `mds_client_delegate_inos_pct` config to 0:
>
>          - name: mds_client_delegate_inos_pct
>            type: uint
>            level: advanced
>            desc: percentage of preallocated inos to delegate to client
>            default: 50
>            services:
>            - mds
>
> So, I guess this patch is really not required. We can suggest this
> config update to users and document it for now. We lack tests with
> this config disabled, so I'll be adding the same before recommending
> it out. Will keep you posted.

Venky, Jeff

This option could disable the async create operation but could it also 
disable the async unlink operation ?

Thanks

- Xiubo


> On Wed, Oct 4, 2023 at 10:16 AM Venky Shankar <vshankar@redhat.com> wrote:
>> Hi Ilya,
>>
>> On Tue, Oct 3, 2023 at 5:00 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>>> On Tue, Oct 3, 2023 at 1:06 PM Venky Shankar <vshankar@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This reverts commit f7a67b463fb83a4b9b11ceaa8ec4950b8fb7f902.
>>>>
>>>> We have identified an issue in the MDS affecting CephFS users using
>>>> the kernel driver. The issue was first introduced in the octopus
>>>> release that added support for clients to perform asynchronous
>>>> directory operations using the `nowsync` mount option. The issue
>>>> presents itself as an MDS crash resembling (any of) the following
>>>> crashes:
>>>>
>>>>          https://tracker.ceph.com/issues/61009
>>>>          https://tracker.ceph.com/issues/58489
>>>>
>>>> There is no apparent data loss or corruption, but since the underlying
>>>> cause is related to an (operation) ordering issue, the extent of the
>>>> problem could surface in other forms - most likely MDS crashes
>>>> involving preallocated inodes.
>>>>
>>>> The fix is being reviewed and is being worked on priority:
>>>>
>>>>          https://github.com/ceph/ceph/pull/53752
>>>>
>>>> As a workaround, we recommend (kernel) clients be remounted with the
>>>> `wsync` mount option which disables asynchronous directory operations
>>>> (depending on the kernel version being used, the default could be
>>>> `nowsync`).
>>>>
>>>> This change reverts the default, so, async dirops is disabled (by default).
>>> Hi Venky,
>>>
>>> Given that the fix is now up and being reviewed on priority, does it
>>> still make sense to change the default?
>>>
>>> According to Xiubo, https://tracker.ceph.com/issues/58489 which morphed
>>> into https://tracker.ceph.com/issues/61009 isn't the only concern -- he
>>> also brought up https://tracker.ceph.com/issues/62810.  If the move to
>>> revert (change of default) is also prompted by that issue, it should be
>>> described in the patch.
>> Fair enough -- I'll push out with an updated commit message.
>>
>>> Thanks,
>>>
>>>                  Ilya
>>>
>>
>> --
>> Cheers,
>> Venky
>
>

