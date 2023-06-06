Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3737F723BF8
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 10:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbjFFIim (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 04:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbjFFIij (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 04:38:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1843F3
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 01:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686040671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ru8vUyvI+zAUoGVmjVk+HIfVMAL1ZCkIP8iPMHf+5Ak=;
        b=iPKmoDdbN6DFYI9QXTTvHuBXu18Tv2VCOOLEIRV3hLoi9+OSot9xKh5s0YP71YsRxPGaB7
        8kQaR7bprYk2OE1MSztCBsWtKSH5DtLk/55NoFGrbIGjtttXQa7XqWrfXVeNTNyXPO5zpg
        crQEV99dZNVml7g8lB+4Bh63WOUAU38=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-Wa-4Q6vYOMq1h5_geIa5sQ-1; Tue, 06 Jun 2023 04:37:49 -0400
X-MC-Unique: Wa-4Q6vYOMq1h5_geIa5sQ-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-39a06b3b71aso5520024b6e.2
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jun 2023 01:37:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686040668; x=1688632668;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ru8vUyvI+zAUoGVmjVk+HIfVMAL1ZCkIP8iPMHf+5Ak=;
        b=SbLR7Wjh9IA5Icyk9pci/GW7+bJ/U7A2MMRcHABu/CFeVC4kwB5zI2PxsnEMYDaFwa
         DHe2i6CUVKdkZ+mZoXb5kh2ORxp+Oli2i8XaM3/UyBzlDemftbYSi5KurARK1zx3oeRZ
         bp04Ap0aWKvsQ9neXfo+6VKK7w5DFYTVbeupZfzcw5N/oe+YxRnm8TqILjKdjRkJvYQI
         vbqjXUuOEJBErBw56HkOG1054P48AWzyFsGrWgkynGXyHlcxsvz0NeU4nKLf45DJMEKf
         Gguspw9kg2gkAd7mjHzZz601VODdmDSgJic+25iEP8iJrOc3/D5MWpjLURh/BNttTHui
         DBpg==
X-Gm-Message-State: AC+VfDz15gMJ2ejbOghVRaecfvkuQEAP2Ai8A+HA63W9H3BgSEG6ikOE
        gAgCbM7YDmPDYzCVF30LDrzfRHZaiDC9MNyi7bepWY83yd2gE031OVwsVbECFAdDmFBV+h4bO1R
        X/f4JIbNuCmlluLmsNkCd5D3zLn9TdD6Y
X-Received: by 2002:a05:6808:105:b0:398:55ff:1fb5 with SMTP id b5-20020a056808010500b0039855ff1fb5mr1696821oie.0.1686040668737;
        Tue, 06 Jun 2023 01:37:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ749cybZ/mFGtKdfV8cTFhdRWht5h6iBWj100nMNmZJHp8LOXEa0CzXohGtoQU46ihbR9omkg==
X-Received: by 2002:a05:6808:105:b0:398:55ff:1fb5 with SMTP id b5-20020a056808010500b0039855ff1fb5mr1696799oie.0.1686040668426;
        Tue, 06 Jun 2023 01:37:48 -0700 (PDT)
Received: from [10.72.12.128] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090311c300b001b0f727bc44sm7906256plh.16.2023.06.06.01.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 01:37:48 -0700 (PDT)
Message-ID: <0d27c653-7b32-c9d2-764f-08fb82f1ca51@redhat.com>
Date:   Tue, 6 Jun 2023 16:37:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v19 69/70] ceph: switch ceph_open() to use new fscrypt
 helper
Content-Language: en-US
To:     Milind Changire <mchangir@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, lhenriques@suse.de
References: <20230417032654.32352-1-xiubli@redhat.com>
 <20230417032654.32352-70-xiubli@redhat.com>
 <CAED=hWACph6FJwKfE-qBr9hL5NGmr9iSoKSHPsOjVxWE=4+6GQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAED=hWACph6FJwKfE-qBr9hL5NGmr9iSoKSHPsOjVxWE=4+6GQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/6/23 14:25, Milind Changire wrote:
> nit:
> the commit title refers to ceph_open() but the code changes are
> pertaining to ceph_lookup()

Good catch.

I couldn't remember why we didn't fix this before as I remembered I have 
found this.

Thanks

- Xiubo


> Otherwise it looks good to me.
>
> Reviewed-by: Milind Changire <mchangir@redhat.com>
>
> On Mon, Apr 17, 2023 at 9:03 AM <xiubli@redhat.com> wrote:
>> From: Luís Henriques <lhenriques@suse.de>
>>
>> Instead of setting the no-key dentry in ceph_lookup(), use the new
>> fscrypt_prepare_lookup_partial() helper.  We still need to mark the
>> directory as incomplete if the directory was just unlocked.
>>
>> Tested-by: Luís Henriques <lhenriques@suse.de>
>> Tested-by: Venky Shankar <vshankar@redhat.com>
>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/dir.c | 13 +++++++------
>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index fe48a5d26c1d..c28de23e12a1 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -784,14 +784,15 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>>                  return ERR_PTR(-ENAMETOOLONG);
>>
>>          if (IS_ENCRYPTED(dir)) {
>> -               err = ceph_fscrypt_prepare_readdir(dir);
>> +               bool had_key = fscrypt_has_encryption_key(dir);
>> +
>> +               err = fscrypt_prepare_lookup_partial(dir, dentry);
>>                  if (err < 0)
>>                          return ERR_PTR(err);
>> -               if (!fscrypt_has_encryption_key(dir)) {
>> -                       spin_lock(&dentry->d_lock);
>> -                       dentry->d_flags |= DCACHE_NOKEY_NAME;
>> -                       spin_unlock(&dentry->d_lock);
>> -               }
>> +
>> +               /* mark directory as incomplete if it has been unlocked */
>> +               if (!had_key && fscrypt_has_encryption_key(dir))
>> +                       ceph_dir_clear_complete(dir);
>>          }
>>
>>          /* can we conclude ENOENT locally? */
>> --
>> 2.39.1
>>
>

