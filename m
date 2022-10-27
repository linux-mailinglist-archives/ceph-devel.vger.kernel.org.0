Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0D960F3F3
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 11:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiJ0JqO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 05:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbiJ0JqL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 05:46:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F849187E
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 02:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666863969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hcr2VkaEWkydV00Wn6Im3FhUaVDRUldZFjHuCw1u1RA=;
        b=LkVnHRcSkjoFhaxJND4EhsayndO1XtD3mhFlRZnfoSioANYJ16KRKpUd/IwsZ1n48DFyTl
        XiVTHViCyJABrEbajJqacPJ20Qi++yQvdnyrRhPO+q2Lax1594CgrQceq36GsiH9YbXdAf
        Z45MmiOE0nHBvj/SGVklGHUDkLNvu0I=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-647--JqrhYFuOzyC3_jFNaSJXw-1; Thu, 27 Oct 2022 05:46:05 -0400
X-MC-Unique: -JqrhYFuOzyC3_jFNaSJXw-1
Received: by mail-pf1-f197.google.com with SMTP id s2-20020aa78282000000b00561ba8f77b4so599334pfm.1
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 02:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hcr2VkaEWkydV00Wn6Im3FhUaVDRUldZFjHuCw1u1RA=;
        b=vi8InfZCJHHeupNdpS8yakJopj6CoPqiU1FIbZ0df8OQkjcVU55knhJ2jXp34b91Kt
         B4G+VJSfvbShE+xW0ifmtd3Rxax9Aje/+2kwWi9nn3mNeDZIs9CqIluOwa+jPBEkxc3d
         /llvyVfKFSNEO6KnnHPESYq5D4d9/IEWfgO4EMMMsfi3yjkEHGMGBOFUhD4hdUludo1z
         pn3kfZWyERvIjd9Cx6UFBDL9sXp/kPj0iokhFwN2UgUc7vHShKTBrU5Lo1kOtJ0IHDj0
         zwK9x7rGIF7SUBiaBqQkXaij4wgVphWDywGZquGfZmH+J98XBgkMDhSx3jZ+jPxEQj42
         lPMw==
X-Gm-Message-State: ACrzQf0dAvdJfpxRKG4qdn5wLMx+Wj1lM7inWer7dFEF6FBwonIm0l/b
        ePRZh+EZ2r3rK6+vlDXJtfM/0BPnSA9l6in6gdbpA1Ffc1vjQeyY2uj5kkzJgL00Z+GAGcHVYN6
        BxNInRDBATVjq38Us1kw57Q==
X-Received: by 2002:a17:902:f707:b0:184:e44f:88cc with SMTP id h7-20020a170902f70700b00184e44f88ccmr48342465plo.42.1666863964157;
        Thu, 27 Oct 2022 02:46:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5suOPi4nooaUhl5ovg12q9wHO8FJwq5Py8R6x8b6DO1d1tMmJyPXyL4noKBF49hAdIHXjEFw==
X-Received: by 2002:a17:902:f707:b0:184:e44f:88cc with SMTP id h7-20020a170902f70700b00184e44f88ccmr48342444plo.42.1666863963879;
        Thu, 27 Oct 2022 02:46:03 -0700 (PDT)
Received: from [10.72.13.65] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id pj14-20020a17090b4f4e00b00212cf2fe8c3sm8924875pjb.1.2022.10.27.02.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 02:46:03 -0700 (PDT)
Subject: Re: [PATCH v2] encrypt: add ceph support
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        ceph-devel@vger.kernel.org, jlayton@kernel.org, mchangir@redhat.com
References: <20221027030021.296548-1-xiubli@redhat.com>
 <20221027032023.6arvnrkl7fymdjqj@zlang-mailbox> <Y1pQz8LICOT1idp+@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <72329809-7d5e-3962-f199-464d8892853c@redhat.com>
Date:   Thu, 27 Oct 2022 17:45:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y1pQz8LICOT1idp+@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 27/10/2022 17:35, Luís Henriques wrote:
> On Thu, Oct 27, 2022 at 11:20:23AM +0800, Zorro Lang wrote:
>> On Thu, Oct 27, 2022 at 11:00:21AM +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   common/encrypt | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/common/encrypt b/common/encrypt
>>> index 45ce0954..1a77e23b 100644
>>> --- a/common/encrypt
>>> +++ b/common/encrypt
>>> @@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
>>>   		# erase the UBI volume; reformated automatically on next mount
>>>   		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
>>>   		;;
>>> +	ceph)
>>> +		_scratch_cleanup_files
>>> +		;;
>> Any commits about that?

After I sent it out I found I forgot to add it.

Should I send V3 for it ?

>> Sorry I'm not familar with cephfs, is this patch enough to help ceph to test
>> encrypted ceph? Due to you tried to do some "checking" job last time.
>>
>> Can "./check -g encrypt" work on ceph? May you paste this test result to help
>> to review? And welcome review points from ceph list.
> I think Xiubo's patch is likely to be required for enabling encryption
> testing in ceph.  Simply doing a '_scratch_cleanup_files' is exactly what
> network filesystems are doing on _scratch_mkfs().  Thus it makes sense for
> ceph to do the same for testing fscrypt support, as we don't really have
> an 'mkfs.ceph' tool.
>
> Now, this patch alone is probably not enough to allow to do all the
> validation we're looking for.  (But note that I did *not* tried it myself,
> so I may be wrong.)  I think we'll need to go through each of the
> 'encrypt' tests, run it in ceph and see if they are really testing what
> they are supposed to.
>
> But that's just my two cents ;-)

This is my test output locally:

[root@lxbceph1 xfstests-dev]# ./check -g encrypt
FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 lxbceph1 6.1.0-rc1+ #164 SMP 
PREEMPT_DYNAMIC Mon Oct 24 10:18:33 CST 2022
MKFS_OPTIONS  -- 10.72.47.117:40267:/testB
MOUNT_OPTIONS -- -o name=admin,nowsync,copyfrom,rasize=4096 -o 
context=system_u:object_r:root_t:s0 10.72.47.117:40267:/testB /mnt/kcephfs.B

generic/395 187s ...  224s
generic/396 164s ...  219s
generic/397 177s ...  226s
generic/398       [not run] kernel doesn't support renameat2 syscall
generic/399       [not run] Filesystem ceph not supported in 
_scratch_mkfs_sized_encrypted
generic/419       [not run] kernel doesn't support renameat2 syscall
generic/421 170s ...  219s
generic/429 179s ...  237s
generic/435

...

Not finished yet.

 From my previous test only 395,396,397,421,429,440,593,595,598 test 
case will pass and all the other will be skipped like the 398,399,419 above.

Before this patch or my V1 patches, all the test cases will be skipped.

Thanks!

- Xiubo


> Cheers,
> --
> Luís
>
>> Thanks,
>> Zorro
>>
>> [1]
>> $ grep -rsn _scratch_mkfs_encrypted tests/generic/
>> tests/generic/395:22:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/396:21:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/580:23:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/581:36:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/595:35:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/613:29:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/621:57:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/429:36:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/397:28:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/398:28:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/421:24:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/440:29:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/419:29:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/435:33:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/593:24:_scratch_mkfs_encrypted &>> $seqres.full
>> tests/generic/576:34:_scratch_mkfs_encrypted_verity &>> $seqres.full
>>
>>>   	*)
>>>   		_notrun "No encryption support for $FSTYP"
>>>   		;;
>>> -- 
>>> 2.31.1
>>>

