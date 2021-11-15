Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C896144FE72
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Nov 2021 06:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhKOFpq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 15 Nov 2021 00:45:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhKOFp0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 00:45:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636954951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H60OVM8IBGfzMmj2s8bJjQOezkCJ5pP0+IzFvCgtRqg=;
        b=YYPa5eyBEcA+0lVI8xlHYAFy3lFftna9glS9sViU2eHfDRXOqx4Bdx0ejwIeOFdwsaJoIO
        0l5xvuN8iCsAR9fNvUH1BENGHCDj8LqVEed6WwszbytvpRid0Kw74qn+fOQ3CuwUuG32Ut
        f0+cBPsJOsGamn0DPB797qkHmu7wIs0=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-uaLSt34hN2WE0zDNl91Csg-1; Mon, 15 Nov 2021 00:42:30 -0500
X-MC-Unique: uaLSt34hN2WE0zDNl91Csg-1
Received: by mail-pj1-f71.google.com with SMTP id n2-20020a17090a2fc200b001a1bafb59bfso4738434pjm.1
        for <ceph-devel@vger.kernel.org>; Sun, 14 Nov 2021 21:42:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=H60OVM8IBGfzMmj2s8bJjQOezkCJ5pP0+IzFvCgtRqg=;
        b=72hedjgGODrV6uJbHo3Ma1WngjYXr3o0n2ZRLRdqMpQqd5IBsCcMXoyBK3CDfXxo1K
         JVrpxMoJhm9OLLZJgSym16nd42J/UbEH86u31lAgCQbn1nKLH+gFSnO+7fl7u6dzfJ0K
         3HFUIwiskoVeGx9Nrug0mQ7pfMbfBwFDs/phoneNiuGpHxG4NbMGrmwkmhcHNY4BTcxn
         tF8eejUfeLpvSILFrU4+F6TwlVXzwGQCXqVwWIkOegcfltnlh2xb/yN1kKRTi83QwrBK
         wOIM5gBjB4j/W9HHHOrYnlZG/SZw6CbgnbBhHh+KiQadyhZ3gPvI7Uzr3pdcM/bWQ/B7
         fF0Q==
X-Gm-Message-State: AOAM533bOxkTBoQU7Ea6yoN9gsODg8gWfvczCGeAhYOYNEwUl+uZcKlI
        ejUth8KfyXXvNnvbi8HfJ8gDzg0okEeMszhDLoFFkzq/bPhBEAzW4AHXUM+0wenl5S2aBAx4CLu
        UFeRAdprEMcSk70X692e7FZ7S2ZXsamH4XsPfjDS08sY1WG9QNHHUyzr0lgfDnoqFzsurk3Y=
X-Received: by 2002:a17:90b:2504:: with SMTP id ns4mr10946266pjb.175.1636954948312;
        Sun, 14 Nov 2021 21:42:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0HbZQwEqZ9xmmZiI0dbJKBrx4zgIkSR9wkvKxlLEOMTcoC4WQvIHv9qBBPQvRrKF2D3JCPA==
X-Received: by 2002:a17:90b:2504:: with SMTP id ns4mr10946223pjb.175.1636954947967;
        Sun, 14 Nov 2021 21:42:27 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f21sm8139061pfc.191.2021.11.14.21.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 21:42:27 -0800 (PST)
Subject: Re: [PATCH v2 1/1] ceph: Fix incorrect statfs report for small quota
To:     Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>, ceph-devel@vger.kernel.org
References: <20211110180021.20876-1-khiremat@redhat.com>
 <20211110180021.20876-2-khiremat@redhat.com>
 <2bbf6340-0814-bbfa-0d35-2e1d1fff23de@redhat.com>
 <CAPgWtC4jv86+hjrBXfDpMm4r0b08sNspCKVsN994qwmHjQx1Ww@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1afd1adb-6bda-0714-1d82-33ac4745e4c4@redhat.com>
Date:   Mon, 15 Nov 2021 13:42:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAPgWtC4jv86+hjrBXfDpMm4r0b08sNspCKVsN994qwmHjQx1Ww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/15/21 1:30 PM, Kotresh Hiremath Ravishankar wrote:
> On Mon, Nov 15, 2021 at 8:24 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 11/11/21 2:00 AM, khiremat@redhat.com wrote:
>>> From: Kotresh HR <khiremat@redhat.com>
>>>
>>> Problem:
>>> The statfs reports incorrect free/available space
>>> for quota less then CEPH_BLOCK size (4M).
>> s/then/than/
>>
>>
>>> Solution:
>>> For quota less than CEPH_BLOCK size, smaller block
>>> size of 4K is used. But if quota is less than 4K,
>>> it is decided to go with binary use/free of 4K
>>> block. For quota size less than 4K size, report the
>>> total=used=4K,free=0 when quota is full and
>>> total=free=4K,used=0 otherwise.
>>>
>>> Signed-off-by: Kotresh HR <khiremat@redhat.com>
>>> ---
>>>    fs/ceph/quota.c | 14 ++++++++++++++
>>>    fs/ceph/super.h |  1 +
>>>    2 files changed, 15 insertions(+)
>>>
>>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>>> index 620c691af40e..24ae13ea2241 100644
>>> --- a/fs/ceph/quota.c
>>> +++ b/fs/ceph/quota.c
>>> @@ -494,10 +494,24 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>>>                if (ci->i_max_bytes) {
>>>                        total = ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
>>>                        used = ci->i_rbytes >> CEPH_BLOCK_SHIFT;
>>> +                     /* For quota size less than 4MB, use 4KB block size */
>>> +                     if (!total) {
>>> +                             total = ci->i_max_bytes >> CEPH_4K_BLOCK_SHIFT;
>>> +                             used = ci->i_rbytes >> CEPH_4K_BLOCK_SHIFT;
>>> +                             buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;

If the quota size is less than 4MB, the 'buf->f_frsize' will always be 
set here, including less than 4KB.


>>> +                     }
>>>                        /* It is possible for a quota to be exceeded.
>>>                         * Report 'zero' in that case
>>>                         */
>>>                        free = total > used ? total - used : 0;
>>> +                     /* For quota size less than 4KB, report the
>>> +                      * total=used=4KB,free=0 when quota is full
>>> +                      * and total=free=4KB, used=0 otherwise */
>>> +                     if (!total) {
>>> +                             total = 1;
>>> +                             free = ci->i_max_bytes > ci->i_rbytes ? 1 : 0;
>>> +                             buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
>> The 'buf->f_frsize' has already been assigned above, this could be removed.
>>
> If the quota size is less than 4KB, the above assignment is not hit.
> This is required.
>
>> Thanks
>>
>> -- Xiubo
>>
>>> +                     }
>>>                }
>>>                spin_unlock(&ci->i_ceph_lock);
>>>                if (total) {
>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>> index ed51e04739c4..387ee33894db 100644
>>> --- a/fs/ceph/super.h
>>> +++ b/fs/ceph/super.h
>>> @@ -32,6 +32,7 @@
>>>     * large volume sizes on 32-bit machines. */
>>>    #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
>>>    #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
>>> +#define CEPH_4K_BLOCK_SHIFT 12  /* 4 KB */
>>>
>>>    #define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blocklisted */
>>>    #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
>

