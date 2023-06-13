Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8165772E031
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 12:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238691AbjFMKz4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 06:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240821AbjFMKzq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 06:55:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DAD1B4
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 03:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686653696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NCCpRPpC7o/jUPYT2JGHPatO2qX0WzuyBGzzDu1VDNM=;
        b=Y2J983DOHOGwah8jGJbam7U+NOZ3x2mhjSIPXNgRBU8TPL4MpOY3Z0wzOUkenhAqvqTzTR
        cgsCyPc2ie8Ns+PiXOtbGiRQhoEohCY0OO+Boceve29YA0FR37PV4IavBWDMKaAKzMwxNX
        k0RQ9TfozE8hJ/4GTIoJfJIaCVioJuA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-gYPs43QxOlipARBxwKEPgg-1; Tue, 13 Jun 2023 06:54:55 -0400
X-MC-Unique: gYPs43QxOlipARBxwKEPgg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-75d53bab5a9so134051385a.2
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 03:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686653695; x=1689245695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NCCpRPpC7o/jUPYT2JGHPatO2qX0WzuyBGzzDu1VDNM=;
        b=AzxAPMaijn5+6Mce6/nCNj4AZrC1W6BPBnRbBxtLthoD7IC0Gkk1U/Higxvt5kwdnZ
         eS39HFEMk81RznTzxIll0PudIntOH903kNrtAwjMAptMNZawNZ1TI/Qpmy5SxrLIa8Ft
         VT5jNL4AUjNm+M9rtGMQ+pzpUkOLQ65GE9x42Z84WFPHCdtiZ1UBc+7EPUSA8gWdO+8I
         bgMyXGNuqE6X7ingMo9bR3mx9QGBLVdYFE6mCrLJljw9WgAnLnIB4BK+HSl6k/SwOtfe
         WzhRKefk4vld13nF+PJIOz5H8intdRsA2k86EAVkKzZAlK0puA5AcZ9c6M8CDjLHrxo+
         7BkA==
X-Gm-Message-State: AC+VfDyM7W6qWvdLqkBiOGnPt7bkEBkFG0MdN2c8I0a9wNaQDVFDthdy
        P+eXgg0Vbq94Mg8WO4Fi1tmsdMH3LZE2xYiwc5hxFQCfhNrNEZSCOhY3heRqz2rTmvdFwVDjBcI
        qH3Jy628GNY/zP7ye/f1hiA==
X-Received: by 2002:a05:620a:2791:b0:75d:5321:fa40 with SMTP id g17-20020a05620a279100b0075d5321fa40mr11970937qkp.51.1686653694803;
        Tue, 13 Jun 2023 03:54:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7WzrMoUswJgD5EJH+dH1HnCt5Pty11WIhjsy9R0ljzvTX29IEeZKX6wVf3Bmrmv+ShVLOKIQ==
X-Received: by 2002:a05:620a:2791:b0:75d:5321:fa40 with SMTP id g17-20020a05620a279100b0075d5321fa40mr11970928qkp.51.1686653694557;
        Tue, 13 Jun 2023 03:54:54 -0700 (PDT)
Received: from [10.72.12.155] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bk17-20020a17090b081100b00256b9d26a2bsm10664686pjb.44.2023.06.13.03.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 03:54:54 -0700 (PDT)
Message-ID: <a57ffe99-641e-876e-7f11-9e5e8075e810@redhat.com>
Date:   Tue, 13 Jun 2023 18:54:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 1/6] ceph: add the *_client debug macros support
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, khiremat@redhat.com, mchangir@redhat.com,
        pdonnell@redhat.com
References: <20230612114359.220895-1-xiubli@redhat.com>
 <20230612114359.220895-2-xiubli@redhat.com>
 <CAOi1vP-u-UR-jd=ALxJTwjq4AJpQ7_=chMqwwBmrxsyQqXCqVQ@mail.gmail.com>
 <2a947e0d-5773-2032-c054-d99eeace1ddc@redhat.com>
 <CAOi1vP8F2kyd1j_oAdj0CqX-0wqE4j7sTsoV62tQG7D7Ync93g@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8F2kyd1j_oAdj0CqX-0wqE4j7sTsoV62tQG7D7Ync93g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/13/23 18:08, Ilya Dryomov wrote:
> On Tue, Jun 13, 2023 at 11:27 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/13/23 16:39, Ilya Dryomov wrote:
>>> On Mon, Jun 12, 2023 at 1:46 PM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This will help print the client's global_id in debug logs.
>>> Hi Xiubo,
>>>
>>> There is a related concern that clients can belong to different
>>> clusters, in which case their global IDs might clash.  If you chose
>>> to disregard that as an unlikely scenario, it's probably fine, but
>>> it would be nice to make that explicit in the commit message.
>>>
>>> If account for that, the identifier block could look like:
>>>
>>>     [<cluster fsid> <gid>]
>> The fsid string is a little long:
>>
>> [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4236]
>>
>> Maybe we could just print part of that as:
>>
>> [5ea1e13c.. 4236]
>>
>> ?
> If printing it at all, I would probably print the entire UUID.  But
> I don't have a strong opinion here.

I am okay with this, then it will be:

<7>[117633.216478] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_do_getattr inode 00000000f7600773 1.fffffffffffffffe mask As mode 
040755
<7>[117633.216486] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_caps_issued_mask mask ino 0x1 cap 00000000a1dd2c71 issued 
pAsLsXsFs (mask As)
<7>[117633.216493] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__touch_cap 00000000f7600773 cap 00000000a1dd2c71 mds0
<7>[117633.216501] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
ceph_d_revalidate 0000000013595462 'a.txt' inode 000000008738cf69 offset 
0xff5cc5890000002 nokey 0
<7>[117633.216509] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
dentry_lease_is_valid - dentry 0000000013595462 = 0
<7>[117633.216515] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_caps_issued_mask mask ino 0x1 cap 00000000a1dd2c71 issued 
pAsLsXsFs (mask Fs)
<7>[117633.216521] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__touch_cap 00000000f7600773 cap 00000000a1dd2c71 mds0
<7>[117633.216528] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_dentry_dir_lease_touch 0000000045691e1a 0000000013595462 'a.txt' 
(offset 0xff5cc5890000002)
<7>[117633.216535] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
dir_lease_is_valid dir 1.fffffffffffffffe v2 dentry 0000000013595462 
'a.txt' = 1
<7>[117633.216542] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
ceph_d_revalidate 0000000013595462 'a.txt' valid
<7>[117633.216551] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_do_getattr inode 000000008738cf69 10000000000.fffffffffffffffe 
mask As mode 0100644
<7>[117633.216558] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_caps_issued_mask mask ino 0x10000000000 cap 00000000610f13ac 
issued pAsLsXsFscr (mask As)
<7>[117633.216565] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__touch_cap 000000008738cf69 cap 00000000610f13ac mds0
<7>[117633.216572] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_caps_issued_mask mask ino 0x1 cap 00000000a1dd2c71 issued 
pAsLsXsFs (mask Fs)
<7>[117633.216599] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_do_getattr inode 00000000f7600773 1.fffffffffffffffe mask As mode 
040755
<7>[117633.216607] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_caps_issued_mask mask ino 0x1 cap 00000000a1dd2c71 issued 
pAsLsXsFs (mask As)
<7>[117633.216613] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__touch_cap 00000000f7600773 cap 00000000a1dd2c71 mds0
<7>[117633.216620] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
ceph_d_revalidate 0000000013595462 'a.txt' inode 000000008738cf69 offset 
0xff5cc5890000002 nokey 0
<7>[117633.216627] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
dentry_lease_is_valid - dentry 0000000013595462 = 0
<7>[117633.216633] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__ceph_caps_issued_mask mask ino 0x1 cap 00000000a1dd2c71 issued 
pAsLsXsFs (mask Fs)
<7>[117633.216639] ceph: [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4245] 
__touch_cap 00000000f7600773 cap 00000000a1dd2c71 mds0

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>

