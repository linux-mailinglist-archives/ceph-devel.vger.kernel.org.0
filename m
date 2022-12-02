Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D6863FDD4
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Dec 2022 02:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiLBBwN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Dec 2022 20:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiLBBwM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Dec 2022 20:52:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A27BA626
        for <ceph-devel@vger.kernel.org>; Thu,  1 Dec 2022 17:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669945877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u58ZGLNAV/zkJ3twGrNcncjImhSwPOBbLznejUWvQBU=;
        b=WCyVSxB1/hHnw6aO8H0vtpPaVu1w7vLaODO4OvLfU3d1QMiLi8oOWDtj2l7mlQE8llmuSl
        D3Lh2Q9kF1QvAIM6ALKzcJfus8FwwbBEsRng2dLHHQqYeGSTyWMNcfKLGeevi/h1TDPfOx
        Z5+tX1X6Ka7M0qnX8r87o0SR5mHm1GU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-231-AMzfKPmCM8eSPjp8SdaN8Q-1; Thu, 01 Dec 2022 20:51:16 -0500
X-MC-Unique: AMzfKPmCM8eSPjp8SdaN8Q-1
Received: by mail-pg1-f200.google.com with SMTP id g193-20020a636bca000000b00476a2298bd1so3260650pgc.12
        for <ceph-devel@vger.kernel.org>; Thu, 01 Dec 2022 17:51:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u58ZGLNAV/zkJ3twGrNcncjImhSwPOBbLznejUWvQBU=;
        b=WPrCrm1HaYKuB/4G8m0rD6Miyq8pt/KKn9VwtMeSYZP0WibeWW2qWxPckvv5jzVJl3
         nbXhcO3hRrS9UZZvPSJtQ5dckOk6N1ZxxkBGKbpwwC0qu4bWp7b91NtTUdXH/nn+CpZ9
         sqniMELkmv8MhFt9hSmNODdiVvJVmYFgMymUNnDwt9sBcm9n1B4bH9LO8EssEH4s4SOD
         vpaFQMXvxIwHn1jrxX/o1AQB4GP5O+VgBwrrJvqgH/DAWNOf04+tlJ7WZAXbo8v1YKsB
         f4E+4X+vbD4lhw7wOJT3t6mnFmENUIYemgCWWgLqxnZBMYBZVuzi5PEmd4Oh93RKpxQ7
         hDzQ==
X-Gm-Message-State: ANoB5pnS6W1s+1SyQOVrxHb8gN3bzVWLEKWeAHQfqopWA8COeVh3msX5
        t7/SM0AxcshWXzjNONj2BAz35KpDH1I73K3n1FiOzQZSk+xqWgCK7tadHGhbAJhINZ1Lut/a2gU
        FZkdfj4CnYPDYXOWb8DmZ3w==
X-Received: by 2002:a17:90b:710:b0:20a:2547:907 with SMTP id s16-20020a17090b071000b0020a25470907mr80382034pjz.37.1669945875055;
        Thu, 01 Dec 2022 17:51:15 -0800 (PST)
X-Google-Smtp-Source: AA0mqf63g4PEkAA8f1m1xX93m5s3YU0EdrKFFt34OlhkbMJ+r80MBWMnkinyVKxhjlWqSREdZJ1+fg==
X-Received: by 2002:a17:90b:710:b0:20a:2547:907 with SMTP id s16-20020a17090b071000b0020a25470907mr80382013pjz.37.1669945874842;
        Thu, 01 Dec 2022 17:51:14 -0800 (PST)
Received: from [10.72.12.244] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ik11-20020a170902ab0b00b00178143a728esm4251792plb.275.2022.12.01.17.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 17:51:14 -0800 (PST)
Subject: Re: [PATCH] ceph: make sure all the files successfully put before
 unmounting
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        khiremat@redhat.com, linux-fscrypt@vger.kernel.org
References: <20221201065800.18149-1-xiubli@redhat.com>
 <Y4j+Ccqzi6JxWchv@sol.localdomain>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <680bffc1-98b6-47c8-2438-904fa7e10048@redhat.com>
Date:   Fri, 2 Dec 2022 09:51:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y4j+Ccqzi6JxWchv@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 02/12/2022 03:18, Eric Biggers wrote:
> On Thu, Dec 01, 2022 at 02:58:00PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When close a file it will be deferred to call the fput(), which
>> will hold the inode's i_count. And when unmounting the mountpoint
>> the evict_inodes() may skip evicting some inodes.
>>
>> If encrypt is enabled the kernel generate a warning when removing
>> the encrypt keys when the skipped inodes still hold the keyring:
> This does not make sense.  Unmounting is only possible once all the files on the
> filesystem have been closed.

Yeah, but I didn't see any where is checking this. Maybe I missed 
something important.

- Xiubo

> - Eric
>

