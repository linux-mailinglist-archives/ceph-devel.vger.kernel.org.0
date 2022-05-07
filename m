Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BA651E2D4
	for <lists+ceph-devel@lfdr.de>; Sat,  7 May 2022 02:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445117AbiEGA4P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 May 2022 20:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiEGA4O (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 May 2022 20:56:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D79150B2F
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 17:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651884748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+Sd09LjxpSkX8Dd3zahBF+AiOGs/WjlRso0xiZTdXA=;
        b=Tte3CBR3tVdsV0rnd6tO1vPmGHhsB4CtFnz6TntJsNJErBjiqscwQqaQmjyn9DVXp1cY7E
        X45fXL2EqqndkRUq/sxJOkJghDzVMe4KE8DYs9JcjNGNECWp7Y3PPMleQeQRoo5QNOe9T3
        xMh2L6CW/UklY1qjZd7bpyUjOtF243Q=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-tC9kupWMMtufgKQiJI8bsw-1; Fri, 06 May 2022 20:52:27 -0400
X-MC-Unique: tC9kupWMMtufgKQiJI8bsw-1
Received: by mail-pj1-f70.google.com with SMTP id q14-20020a17090a178e00b001dc970bf587so5422240pja.1
        for <ceph-devel@vger.kernel.org>; Fri, 06 May 2022 17:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=i+Sd09LjxpSkX8Dd3zahBF+AiOGs/WjlRso0xiZTdXA=;
        b=BRsnBRb9BzpuLtCzZ9gqz1F5JKbDWW4SS/sdudSP2JZqB1uYByPcu6S3/LCOyWTct7
         TfpS9nJAhksrwKszLIs7M7IHuPd5ba3pzQK56rT43Ezk/WXZN3OssW2Aq/bosvrkUwNZ
         xR80r8H3aZDFDf4ONbwPPlT51GRHbeKDVsaUr2TmnBnQgOmFp3eWm3sxuUitaDVKNLcN
         YxUo+vZ2/LbMzuuG10Ta7CrzY3S1CoPYNtErZeupBkKF2lBPSKelL2VX3Yn+99dAQni1
         mRO5w7MlaNp6KScHVxGYszqmObAOfsFDRQFNSu3i5khhAACqPdFy7+wJH4UH8HXmc7ct
         BkDg==
X-Gm-Message-State: AOAM530K4p7SwxgTi6WeARbj7aWCvxvpf+mhdJvFOOTglgCFz2owcUwa
        i05FHgOowm3/jmsnxo/uZkUpsz3bRLnGSTw+JR1u8M8d2fUAsxqcnRHnqNhxoBsEPXlkP/OkRBR
        84ozjndiSE4J/I8yxg6ZeVlSNDH/3DwHLEEe7bxc+yZkO7H/kQKBo34SZwHLWPEKF+EgQOS0=
X-Received: by 2002:a17:902:f549:b0:15e:aa35:425a with SMTP id h9-20020a170902f54900b0015eaa35425amr6368089plf.1.1651884745628;
        Fri, 06 May 2022 17:52:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9FqiWNtbHlzNzdCEqlKefr+PR4QUJswxFZSCk+4xnLWdltWy58mAorJBKZBSty0GJBEXWzQ==
X-Received: by 2002:a17:902:f549:b0:15e:aa35:425a with SMTP id h9-20020a170902f54900b0015eaa35425amr6368053plf.1.1651884745015;
        Fri, 06 May 2022 17:52:25 -0700 (PDT)
Received: from [10.72.12.57] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e3-20020a170902ef4300b0015e8d4eb212sm2428029plx.92.2022.05.06.17.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 17:52:23 -0700 (PDT)
Subject: Re: [PATCH v3] ceph: always try to uninline inline data when opening
 files
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220506153843.515915-1-xiubli@redhat.com>
 <b3d35209c39b01aeb51632227f92994e5289a43c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <194c652e-c3e2-39b5-31b1-c7dd7bfd2b0e@redhat.com>
Date:   Sat, 7 May 2022 08:52:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b3d35209c39b01aeb51632227f92994e5289a43c.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/7/22 12:33 AM, Jeff Layton wrote:
> On Fri, 2022-05-06 at 23:38 +0800, Xiubo Li wrote:
>> This will help reduce possible deadlock while holding Fcr to use
>> getattr for read case.
>>
>
> Ok, so I guess the situation here is that if we can't uninline the file,
> then we just take our chances with the deadlock possibilities? I think
> we have to consider to still be a problem then.

Right.

>
> We've been aware that the inlining code is problematic for a long time.
> Maybe it's just time to rip this stuff out. Still, it'd be good to have
> it in working state before we do that, in case we need to revert it for
> some reason...
>
Okay, sounds good.


>> Usually we shouldn't use getattr to fetch inline data after getting
>> Fcr caps, because it can cause deadlock. The solution is try uniline
>> the inline data when opening files, thanks David Howells' previous
>> work on uninlining the inline data work.
>>
>> It was caused from one possible call path:
>>    ceph_filemap_fault()-->
>>       ceph_get_caps(Fcr);
>>       filemap_fault()-->
>>          do_sync_mmap_readahead()-->
>>             page_cache_ra_order()-->
>>                read_pages()-->
>>                   aops->readahead()-->
>>                      netfs_readahead()-->
>>                         netfs_begin_read()-->
>>                            netfs_rreq_submit_slice()-->
>>                               netfs_read_from_server()-->
>>                                  netfs_ops->issue_read()-->
>>                                     ceph_netfs_issue_read()-->
>>                                        ceph_netfs_issue_op_inline()-->
>>                                           getattr()
>>        ceph_pu_caps_ref(Fcr);
>>
>> This because if the Locker state is LOCK_EXEC_MIX for auth MDS, and
>> the replica MDSes' lock state is LOCK_LOCK. Then the kclient could
>> get 'Frwcb' caps from both auth and replica MDSes.
>>
>> But if the getattr is sent to any MDS, the MDS needs to do Locker
>> transition to LOCK_MIX first and then to LOCK_SYNC. But when
>> transfering to LOCK_MIX state the MDS Locker need to revoke the Fcb
>> caps back, but the kclient already holding it and waiting the MDS
>> to finish.
>>
> My hat's is off to you who can comprehend the LOCK_* state transitions!
> I don't quite grok the problem fully, but I'll take your word for it.

I have confirmed this with Zheng too. And we already have several 
similar fixes about this before.


>
> The page should already be uptodate if we hold Fc, AFAICT, so this is
> only a problem for the case where we can get Fr but not Fc.
>
> Is there any way we could ensure that we send the getattr to the same
> MDS that we got the Fr caps from? Presumably it can satisfy the request
> without a revoking anything at that point.

Days ago I sent one patch to do this in [1], but I am not very sure this 
could cover all possible cases.

[1] 
https://github.com/ceph/ceph-client/commit/c99bb1ee6ce7a92b4720afd7208944ab182697de

--Xiubo


> I'll have to think about this a bit more.
>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 8c8226c0feac..5d5386c7ef01 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -241,11 +241,16 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>>   	INIT_LIST_HEAD(&fi->rw_contexts);
>>   	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
>>   
>> -	if ((file->f_mode & FMODE_WRITE) &&
>> -	    ci->i_inline_version != CEPH_INLINE_NONE) {
>> -		ret = ceph_uninline_data(file);
>> -		if (ret < 0)
>> +	if (ci->i_inline_version != CEPH_INLINE_NONE) {
>> +		ret = ceph_pool_perm_check(inode, CEPH_CAP_FILE_WR);
>> +		if (!ret) {
>> +			ret = ceph_uninline_data(file);
>> +			/* Ignore the error for readonly case */
>> +			if (ret < 0 && (file->f_mode & FMODE_WRITE))
>> +				goto error;
>> +		} else if (ret != -EPERM) {
>>   			goto error;
>> +		}
>>   	}
>>   
>>   	return 0;
>
> Maybe instead of doing this, we should

