Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2F14DC44E
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Mar 2022 11:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiCQKyT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Mar 2022 06:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbiCQKyR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Mar 2022 06:54:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15AE712606
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 03:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647514380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3Y4/CLqhjaWTGSLzXYdOZpML+2A1bgpqt0T/9LDPBM=;
        b=XURyK2yVL4WDr5cDjKxCp5zzTv8fF+GlMItv4VyMXkzKabQg9+tjApnj3gZIKhFh35Fdcl
        C5nJmPPtNfD3kgAgXcxY32/HHECdXogGeA6E8IleQTj9Wxw+OIlP16JjeiXN7SQgw/NXwa
        ZTp9CrVbM1s3gloDlu8blHDvxiixDnA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-fSUaNAqPP4e4aBMBWySRoQ-1; Thu, 17 Mar 2022 06:52:59 -0400
X-MC-Unique: fSUaNAqPP4e4aBMBWySRoQ-1
Received: by mail-pj1-f71.google.com with SMTP id lr15-20020a17090b4b8f00b001c646e432baso4987951pjb.3
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 03:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=I3Y4/CLqhjaWTGSLzXYdOZpML+2A1bgpqt0T/9LDPBM=;
        b=xejXLGh7Xb1s91vEojV/JN8csU+LPxoKAg2+agH8tCyFLyQZhuyinmKzLjaHfuMXBT
         K4JNP/ekhFO8LN0w98bJyr59H6Vx+TukwFfpcHMaVCm+3AgnCOKT3rfbTYUTS/Edsz5w
         LtAJFkj8xn5p7HrRY44t6h7XbJ2uwytLh5hP2JdKx8grnUQhZfGUoszAYTtIbFuKUhFe
         0EFw9glB0AGHYi2N5bSDdl1N/2O/OSZGq17sgwLolzm+rtyPNFFRNpd1KoB/4EUvnG7V
         Maa+LHhmZluY1qrzteXb3rwweQxRNTnYK1n8lKNzjz61/YLFTIGXumhZ2/+MzJUqjf71
         /W5w==
X-Gm-Message-State: AOAM533dECfKAZPIoVUGyaFhHdeKbY2TvmhvTN2+sddtP1jcVUEr5xre
        Mw2Z49Li4uo4srm88HVfEpzpI7/aFHHNu8cuJHx1Jn0X3VCwM6lIvyQrYrahGA94YJxB1vq3RWv
        zKcgnw8u8OCyQV1/uYV6/VA==
X-Received: by 2002:a17:902:e748:b0:153:b484:bdf4 with SMTP id p8-20020a170902e74800b00153b484bdf4mr4354128plf.66.1647514377761;
        Thu, 17 Mar 2022 03:52:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxIHAji0XWgoCyeZFRlJJWn6FJI3OqUsIPbFtAonZujfJV8v0NR2E2ydutT0wtLk1xlHS8GQ==
X-Received: by 2002:a17:902:e748:b0:153:b484:bdf4 with SMTP id p8-20020a170902e74800b00153b484bdf4mr4354106plf.66.1647514377486;
        Thu, 17 Mar 2022 03:52:57 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 134-20020a63008c000000b00380e72483a6sm5219291pga.7.2022.03.17.03.52.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 03:52:56 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] ceph: add support for snapshot names
 encryption
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220315161959.19453-1-lhenriques@suse.de>
 <5b53e812-d49b-45f0-1219-3dbc96febbc1@redhat.com>
 <329abedd9d9938de95bf4f5600acdcd6a846e6be.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3c8b78c4-5392-b81c-e76f-64fcce4f3c0f@redhat.com>
Date:   Thu, 17 Mar 2022 18:52:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <329abedd9d9938de95bf4f5600acdcd6a846e6be.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/17/22 6:01 PM, Jeff Layton wrote:
> I'm not sure we want to worry about .snap directories here since they
> aren't "real". IIRC, snaps are inherited from parents too, so you could
> do something like
>
>      mkdir dir1
>      mkdir dir1/.snap/snap1
>      mkdir dir1/dir2
>      fscrypt encrypt dir1/dir2
>
> There should be nothing to prevent encrypting dir2, but I'm pretty sure
> dir2/.snap will not be empty at that point.

If we don't take care of this. Then we don't know which snapshots should 
do encrypt/dencrypt and which shouldn't when building the path in lookup 
and when reading the snapdir ?

-- Xiubo

>
> -- Jeff
>
> On Thu, 2022-03-17 at 13:27 +0800, Xiubo Li wrote:
>> Hi Luis,
>>
>> There has another issue you need to handle at the same time.
>>
>> Currently only the empty directory could be enabled the file encryption,
>> such as for the following command:
>>
>> $ fscrypt encrypt mydir/
>>
>> But should we also make sure that the mydir/.snap/ is empty ?
>>
>> Here the 'empty' is not totally empty, which allows it should allow long
>> snap names exist.
>>
>> Make sense ?
>>
>> - Xiubo
>>
>>
>> On 3/16/22 12:19 AM, Lu�s Henriques wrote:
>>> Hi!
>>>
>>> A couple of changes since v1:
>>>
>>> - Dropped the dentry->d_flags change in ceph_mkdir().  Thanks to Xiubo
>>>     suggestion, patch 0001 now skips calling ceph_fscrypt_prepare_context()
>>>     if we're handling a snapshot.
>>>
>>> - Added error handling to ceph_get_snapdir() in patch 0001 (Jeff had
>>>     already pointed that out but I forgot to include that change in previous
>>>     revision).
>>>
>>> - Rebased patch 0002 to the latest wip-fscrypt branch.
>>>
>>> - Added some documentation regarding snapshots naming restrictions.
>>>
>>> As before, in order to test this code the following PRs are required:
>>>
>>>     mds: add protection from clients without fscrypt support #45073
>>>     mds: use the whole string as the snapshot long name #45192
>>>     mds: support alternate names for snapshots #45224
>>>     mds: limit the snapshot names to 240 characters #45312
>>>
>>> Lu�s Henriques (3):
>>>     ceph: add support for encrypted snapshot names
>>>     ceph: add support for handling encrypted snapshot names
>>>     ceph: update documentation regarding snapshot naming limitations
>>>
>>>    Documentation/filesystems/ceph.rst |  10 ++
>>>    fs/ceph/crypto.c                   | 158 +++++++++++++++++++++++++----
>>>    fs/ceph/crypto.h                   |  11 +-
>>>    fs/ceph/inode.c                    |  31 +++++-
>>>    4 files changed, 182 insertions(+), 28 deletions(-)
>>>

