Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB49620941
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Nov 2022 06:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiKHF6C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Nov 2022 00:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbiKHF6B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Nov 2022 00:58:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1817D2F66F
        for <ceph-devel@vger.kernel.org>; Mon,  7 Nov 2022 21:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667887021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wEr+gwc6Fx3MZQR8wUVVYNov2+NG0e6VFbLpOkCoHbg=;
        b=KTadc7B7jftuvcH9RJPI+b0YsYFufUC8IH+OopP9iPswhRL+j+tZ04C/fyz+rSr0zaPypL
        YwcHAuBig98uudVYmHJYOFybm5W6CKSMnZa9wx9EDcm/VFc1fHMxqU9J+Ce8boIVO6M+OK
        yyQAfe3rBS1C1CmqaYrRCWcE38K7bdQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-191-g1SssfJoMPiurYYEB1_VaQ-1; Tue, 08 Nov 2022 00:56:58 -0500
X-MC-Unique: g1SssfJoMPiurYYEB1_VaQ-1
Received: by mail-pg1-f198.google.com with SMTP id k16-20020a635a50000000b0042986056df6so7338101pgm.2
        for <ceph-devel@vger.kernel.org>; Mon, 07 Nov 2022 21:56:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wEr+gwc6Fx3MZQR8wUVVYNov2+NG0e6VFbLpOkCoHbg=;
        b=1kvXUC9P8vFeVxcDbQOBSXCeL4COJNn+EdrLSY7rfAbkUtuxBk2BzcO4yZUgct4piO
         e6sUlCYDx5ybUslpzEWj82pwwsLVfrtpmn3IQsIK9JqlVtG1nkcDVsH9IcKzAEAXBml/
         wVpuVe5T2DuwPX5UH7hqrPFWBgUJUrxfVycihtKhW062eMqz3Zl8DkFuromy0hySzLIf
         h6Fbmz+ozyHqNUTF5lu3Qlqar5cv0puvMUbZBD4m2dIBtqxoO2BKk/yRkE2IHmvKR9jD
         bXoLiuTvnCXSumNzg74fkn9ETQIS5Xh9tTjXCy8V3nObIxifgQaGyl9FuelcuuFXXZBg
         waTg==
X-Gm-Message-State: ACrzQf1XLAlDodV2Wjn0zj7uK8QbI9ruiBEf1ZYyIsE/pZrqwocThXZo
        8EfUKiffRQq54uOJwJdhZj+oBpxlM1tiwX9/UktsOIfUNq4FbPuVTEG1WyBVyYxo6A1cGdSjy0K
        hilH02dsuHtgBwm5+l3snow==
X-Received: by 2002:a63:2a44:0:b0:46e:9fda:219b with SMTP id q65-20020a632a44000000b0046e9fda219bmr44751353pgq.347.1667887017742;
        Mon, 07 Nov 2022 21:56:57 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4WRPPxlPDE6S+wZkQh44SJyEtTdw7CpVHTXBbZlbu7xL8iSORsLkulbKmecmL3l6S4bHQAjA==
X-Received: by 2002:a63:2a44:0:b0:46e:9fda:219b with SMTP id q65-20020a632a44000000b0046e9fda219bmr44751334pgq.347.1667887017508;
        Mon, 07 Nov 2022 21:56:57 -0800 (PST)
Received: from [10.72.12.88] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a143-20020a621a95000000b005629b6a8b53sm5687844pfa.15.2022.11.07.21.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 21:56:56 -0800 (PST)
Subject: Re: [PATCH] ceph: fix memory leak in mount error path when using
 test_dummy_encryption
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221103153619.11068-1-lhenriques@suse.de>
 <700018a6-aff7-6e7a-98df-2fc8cca39acb@redhat.com> <Y2jcrbZxgmLO/psM@suse.de>
 <afd5902a-3e79-a6d9-fcd7-abee276c5504@redhat.com> <Y2kT/UJfGeYAd92s@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <758c4a16-c99f-a188-8b91-f26cfc19cf9a@redhat.com>
Date:   Tue, 8 Nov 2022 13:56:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y2kT/UJfGeYAd92s@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 07/11/2022 22:19, Lu�s Henriques wrote:
> On Mon, Nov 07, 2022 at 07:06:40PM +0800, Xiubo Li wrote:
>> On 07/11/2022 18:23, Lu�s Henriques wrote:
>>> On Mon, Nov 07, 2022 at 03:47:23PM +0800, Xiubo Li wrote:
>>>> On 03/11/2022 23:36, Lu�s Henriques wrote:
>>>>> Because ceph_init_fs_context() will never be invoced in case we get a
>>>>> mount error, destroy_mount_options() won't be releasing fscrypt resources
>>>>> with fscrypt_free_dummy_policy().  This will result in a memory leak.  Add
>>>>> an invocation to this function in the mount error path.
>>>>>
>>>>> Signed-off-by: Lu�s Henriques <lhenriques@suse.de>
>>>>> ---
>>>>>     fs/ceph/super.c | 1 +
>>>>>     1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>>>> index 2224d44d21c0..6b9fd04b25cd 100644
>>>>> --- a/fs/ceph/super.c
>>>>> +++ b/fs/ceph/super.c
>>>>> @@ -1362,6 +1362,7 @@ static int ceph_get_tree(struct fs_context *fc)
>>>>>     	ceph_mdsc_close_sessions(fsc->mdsc);
>>>>>     	deactivate_locked_super(sb);
>>>>> +	fscrypt_free_dummy_policy(&fsc->fsc_dummy_enc_policy);
>>>> Hi Luis,
>>>>
>>>> BTW, any reason the following code won't be triggered ?
>>>>
>>>> deactivate_locked_super(sb);
>>>>
>>>>   � --> fs->kill_sb(s);
>>>>
>>>>   ������� --> ceph_kill_sb()
>>>>
>>>>   ������������� --> kill_anon_super()
>>>>
>>>>   ������������������� --> generic_shutdown_super()
>>>>
>>>>   ������������������������� --> sop->put_super()
>>>>
>>>>   ������������������������������� --> ceph_put_super()
>>>>
>>>>   ������������������������������������� --> ceph_fscrypt_free_dummy_policy()
>>>>
>>>>   ������������������������������������������ --> fscrypt_free_dummy_policy(
>>>>
>>> Here's what I'm seeing here:
>>>
>>>     sys_mount->path_mount->do_new_mount->vfs_get_tree->ceph_get_tree
>>>
>>> ceph_get_tree() fails due to ceph_real_mount() returning an error.  My
>>> understanding is that that, since fc->root is never set, that code path
>>> will never be triggered.  Does that make sense?
>> Okay, you are right!
>>
>> How about fixing it in ceph_real_mount() instead ?
> Sure, I can send a patch for doing that instead.  However, my opinion is
> that it makes more sense to do it, mostly because ceph_get_tree() is
> already doing clean-up work on the error path (ceph_mdsc_close_sessions()
> and deactivate_locked_super()).
>
> But let me know if you really prefer doing in ceph_read_mount() and I'll
> send v2.

IMO it'd better to do this in ceph_real_mount(), which will make the 
code to be easier to read.

Thanks!

- Xiubo

>>> An easy way to reproduce is by running fstest ceph/005 with the
>>> 'test_dummy_encryption' option.  (I'll probably need to send a patch to
>>> disable this test when this option is present.)
>> Anyway this should be fixed in kceph.
> Yes, agreed.
>
> Cheers,
> --
> Lu�s
>

