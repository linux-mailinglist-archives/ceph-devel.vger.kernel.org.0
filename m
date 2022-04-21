Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD4F509482
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 03:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377605AbiDUBLl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Apr 2022 21:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbiDUBLl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Apr 2022 21:11:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1BC010C5
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 18:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650503331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EeONomDrIIfhai7gFNC0RbEltJjs/EzDwUCLuQLqWE=;
        b=GnH86+PS+zZ/bZh8kSujOCZCochkTuo3Ct1j7MSpCDqJpzd+6KpDVvqKEm8COpizBkzmMa
        ClONXYzdPs4/U2MD3pqdJRKvx4Q/DRSIv0+ET+L5VOcbxi1QXsUIDSWcHisnU6b2Ca+Qfn
        5tti5+ii/P3iqVDFTOhGkS3i7+4c/Rk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-3LBew84KOueGbq8_mNULXg-1; Wed, 20 Apr 2022 21:08:50 -0400
X-MC-Unique: 3LBew84KOueGbq8_mNULXg-1
Received: by mail-pg1-f200.google.com with SMTP id i69-20020a636d48000000b003aa4ae583bcso1930688pgc.14
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 18:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8EeONomDrIIfhai7gFNC0RbEltJjs/EzDwUCLuQLqWE=;
        b=JrIePmgH+C7oeE5K3WrmDY99zw6emHZ6Cz9yU7OEeYwzZ6IjH24LUeogchp2a3EnKg
         g56Je/HDsjPiqCsCozu2tjD8MRHkA9clP20rtZGLMohhmK3c4OkNUvRTrKTuO54kc8Te
         taJ/Z51NJmtfa6h1tHMYnNEdSZOrHDglv+J9vjKCbAkDmhciiy/uhzCadZdzkvlSj6vI
         hlwKXta+D74nKZ/Jos2ggtA/Td7GwWJjTbhiQADN7Lb90gmg4TLPA4LjgxY/bJSVnetn
         NO43/H76egPNWMwLKz3Xdcy2ADpNxQ/XQ8pQnrsHoCaZp1bjvv2y2tGowPQLUxqZCxNS
         Fl5Q==
X-Gm-Message-State: AOAM533i2bYz/VTTH7YEgfP7wg8qjSqzUsesdh3IKjqrQsGFoOCXej7+
        zheCAGwgNs/u8x26Y1ssMcX3AjQ9HOabrV30pkFJHPRPEJIvjhu8rh5plAjHAF+XD18MhYOTLdX
        bM0x0yRi5SjOHt0D4ZIxQwA==
X-Received: by 2002:a17:902:d645:b0:158:f267:83b1 with SMTP id y5-20020a170902d64500b00158f26783b1mr20814154plh.11.1650503328708;
        Wed, 20 Apr 2022 18:08:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAKR2d92srP9wGbxXCmFRJ0wBSJD4JCf/U/qsgACzWEh0WL4tCuSuCvwaUqsmmdJjaqMR4ZA==
X-Received: by 2002:a17:902:d645:b0:158:f267:83b1 with SMTP id y5-20020a170902d64500b00158f26783b1mr20814133plh.11.1650503328425;
        Wed, 20 Apr 2022 18:08:48 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y131-20020a626489000000b00505a8f36965sm21162813pfb.184.2022.04.20.18.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 18:08:47 -0700 (PDT)
Subject: Re: [RFC PATCH] ceph: disable updating the atime since cephfs won't
 maintain it
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Gregory Farnum <gfarnum@redhat.com>
References: <20220420052404.1144209-1-xiubli@redhat.com>
 <5b6832315f8561010bb2a7dd93638752ebf8166b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6c3dfe35-36fb-89a9-95fb-9b2fcb20e47c@redhat.com>
Date:   Thu, 21 Apr 2022 09:08:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5b6832315f8561010bb2a7dd93638752ebf8166b.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/20/22 9:56 PM, Jeff Layton wrote:
> On Wed, 2022-04-20 at 13:24 +0800, Xiubo Li wrote:
>> Since the cephFS makes no attempt to maintain atime, we shouldn't
>> try to update it in mmap and generic read cases and ignore updating
>> it in direct and sync read cases.
>>
>> And even we update it in mmap and generic read cases we will drop
>> it and won't sync it to MDS. And we are seeing the atime will be
>> updated and then dropped to the floor again and again.
>>
>> URL: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/VSJM7T4CS5TDRFF6XFPIYMHP75K73PZ6/
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c  | 1 -
>>   fs/ceph/super.c | 1 +
>>   2 files changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index aa25bffd4823..02722ac86d73 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -1774,7 +1774,6 @@ int ceph_mmap(struct file *file, struct vm_area_struct *vma)
>>   
>>   	if (!mapping->a_ops->readpage)
>>   		return -ENOEXEC;
>> -	file_accessed(file);
>>   	vma->vm_ops = &ceph_vmops;
>>   	return 0;
>>   }
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index e6987d295079..b73b4f75462c 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -1119,6 +1119,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
>>   	s->s_time_gran = 1;
>>   	s->s_time_min = 0;
>>   	s->s_time_max = U32_MAX;
>> +	s->s_flags |= SB_NODIRATIME | SB_NOATIME;
>>   
>>   	ret = set_anon_super_fc(s, fc);
>>   	if (ret != 0)
> (cc'ing Greg since he claimed this...)
>
> I confess, I've never dug into the MDS code that should track atime, but
> I'm rather surprised that the MDS just drops those updates onto the
> floor.

Yeah, it is. But that's because the client doesn't correctly handle it 
and it must dirty the Fx caps:


3706     if ((dirty & CEPH_CAP_FILE_EXCL) && atime != pi->atime) {
3707       dout(7) << "  atime " << pi->atime << " -> " << atime
3708               << " for " << *in << dendl;
3709       pi->atime = atime;
3710     }

I think the MDS code is only handling the setattr with Fx caps issued 
case, which in client will buffer the atime changing and then flush it 
back to MDS via the cap update requests.

Except the setattr in MDS there has no other place is handling the atime.

In libcephfs it never handle the atime in any case. While the in kclient 
the vfs will do that.
>
> It's obviously updated when the mtime changes. The SETATTR operation
> allows the client to set the atime directly, and there is an "atime"
> slot in the cap structure that does get populated by the client. I guess
> though that it has never been 100% clear what cap the atime should be
> governed by so maybe it just always ignores that field?

IMO if we want to maintain the atime we need to check and dirty the Frc 
caps instead when reading from a file in none setattr case.

Currently since we don't maintain the atime, the setattr just assumes 
it's a metadata attribute and will be simply handled by the Fsx caps. I 
think in setattr will allow to set the atime just used for backup use case.


> Anyway, I've no firm objection to this since no one in their right mind
> should use the atime anyway, but you may see some complaints if you just
> turn it off like this. There are some applications that use it.
> Hopefully no one is running those on ceph.

Partially supporting and incorrectly handling the atime are confusing, 
usually assuming as a bug.

Before we thoroughly supporting it, maybe in future when needed, let's 
disable it for now.

> It would be nice to document this somewhere as well -- maybe on the ceph
> POSIX conformance page?
>
>      https://docs.ceph.com/en/latest/cephfs/posix/

Yeah, let's document here.

-- Xiubo

