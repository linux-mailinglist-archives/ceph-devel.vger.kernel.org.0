Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C573FD080
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Sep 2021 02:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241513AbhIAAzA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 Aug 2021 20:55:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241514AbhIAAy7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 20:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630457642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/KDS3MmqRp7iUJtrLFXQI3iPGCRnyo2zicC0/TFY91s=;
        b=VFT5VLuu4Gt2JmBXYWfLK4btap9mTYMergBXt8jD8phBHNiAfZkVwhubvzpgv4fDL3GpK8
        m2rp5hkeUrSHO6moKw60vHVDtVnglBVwlAkOGKa8X1Uw6WDFiMhCO33ljzLvJMTPWf9k2Q
        GRbBqDLgDXB//mjKAozaV6n00DNN7vk=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-ZF2FT0AjP5ajNd6LK3LROg-1; Tue, 31 Aug 2021 20:54:01 -0400
X-MC-Unique: ZF2FT0AjP5ajNd6LK3LROg-1
Received: by mail-pf1-f200.google.com with SMTP id g17-20020aa781910000b0290360a5312e3eso508737pfi.7
        for <ceph-devel@vger.kernel.org>; Tue, 31 Aug 2021 17:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/KDS3MmqRp7iUJtrLFXQI3iPGCRnyo2zicC0/TFY91s=;
        b=K+W9s6CjmthznIu5paxc6zrsyuOwfPSEooFBUvo7FTxc+VxswpYnPg1Tk1/wO44zKJ
         y9pxyLOSzdgbPnVG0E6+YyU6vY1CB5oWkT8TMnZtlvJrSKBZKoxJNF/MD/P7wGln2GyW
         Mzyyd8xvfvRWBgTWtbrDtO6jiW6GtsG6PuMf5n+B+2NFjY1PVXbWsjvaAg2VBz8k78QS
         zgLG4qLrfczZdIcj90OHfYadB85wzr5FSa6f6a5pm218zlI0ZKUX25TXGw8WixByv2tH
         4t6rUG6JPX2r3t7GgqXlxRBQT0BUS2GMx8xmh9Jo+Q60aB7hlSkblvWWmRIcBAA7BVvk
         DJ5g==
X-Gm-Message-State: AOAM530nKr8jRt9vQ1AWHc7GB/+4duWBzp7u5qdLv2lCFmmOLSpjtImv
        ZZNrsz2u3coEE3QJmMl/6NcS6eyXczjGDxLAUdLasJgr3GB7G7vdslAtH2Zzau0xBwRDeX1khao
        +IqQKqa6UwG5c1hLq8IeVAw==
X-Received: by 2002:a17:90a:8b8d:: with SMTP id z13mr8541265pjn.1.1630457640250;
        Tue, 31 Aug 2021 17:54:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzS5trT2YZS8nyXzMcVEsTAyvQzVnxPq2aM6lBpZp+y8GsHgkjBT2yyrXZYpp/K8yryie5HCQ==
X-Received: by 2002:a17:90a:8b8d:: with SMTP id z13mr8541244pjn.1.1630457639932;
        Tue, 31 Aug 2021 17:53:59 -0700 (PDT)
Received: from [10.72.12.157] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v20sm22108951pgi.39.2021.08.31.17.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 17:53:59 -0700 (PDT)
Subject: Re: [RFC PATCH v8 09/24] ceph: add ability to set fscrypt_auth via
 setattr
To:     Eric Biggers <ebiggers@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, dhowells@redhat.com,
        lhenriques@suse.de, khiremat@redhat.com
References: <20210826162014.73464-1-jlayton@kernel.org>
 <20210826162014.73464-10-jlayton@kernel.org>
 <27f6a038-94a6-ec58-c7a5-0fafc2c9d779@redhat.com>
 <e92545e2d652179dd5d72f953ef58398c41a4abf.camel@kernel.org>
 <60291569-aace-cc83-88de-3de24cefb750@redhat.com>
 <7f231e95bd397394eba44c3e346524bac44a069b.camel@kernel.org>
 <YS5s5mYZtc3r+K/E@sol.localdomain>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <fca1da91-07aa-61ab-8d43-17a15a72691b@redhat.com>
Date:   Wed, 1 Sep 2021 08:53:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YS5s5mYZtc3r+K/E@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/1/21 1:54 AM, Eric Biggers wrote:
> On Tue, Aug 31, 2021 at 09:50:32AM -0400, Jeff Layton wrote:
>>>>>> +		/* It should never be re-set once set */
>>>>>> +		WARN_ON_ONCE(ci->fscrypt_auth);
>>>>>> +
>>>>> Maybe this should return -EEXIST if already set ?
>>>>>
>>>> I don't know. In general, once the context is set on an inode, we
>>>> shouldn't ever reset it. That said, I think we might need to allow
>>>> admins to override an existing context if it's corrupted.
>>>>
>>>> So, that's the rationale for the WARN_ON_ONCE. The admins should never
>>>> do this under normal circumstances but they do have the ability to
>>>> change it if needed (and we'll see a warning in the logs in that case).
>>> I may miss some code in the fs/crypto/ layer.
>>>
>>> I readed that once the directory/file has set the policy context, it
>>> will just return 0 if the new one matches the existence, if not match it
>>> will return -EEXIST, or will try to call ceph layer to set it.
>>>
>>> So once this is set, my understanding is that it shouldn't be here ?
>>>
>> Where did you read that? If we have documented semantics we need to
>> follow here, then we should change it to comply with them.
>>
> That is how FS_IOC_SET_ENCRYPTION_POLICY behaves, but the check for an existing
> policy already happens in fscrypt_ioctl_set_policy(), so ->set_context doesn't
> need to worry about it.

Yeah, the FS_IOC_SET_ENCRYPTION_POLICY section in 
"Documentation/filesystems/fscrypt.rst".


> - Eric
>

