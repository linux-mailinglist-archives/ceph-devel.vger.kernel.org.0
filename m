Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945374B9525
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 01:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiBQAzN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 19:55:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiBQAzM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 19:55:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D285B2AB514
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 16:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645059297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bcpVB2Dj8N0u01W1gniu2E4cAZaoAhWyOxjtWb9Ereo=;
        b=XoSM3WdX51gdRU8r4eI5UxMqx945/v72d9Urud/G8Ys9yPRG8WimCcQRJrOn3F3BWLvSDF
        u+sn1N4cMTPXcLSAJNjBRflTa8WEUAIXxhUMdEGmDyjMCN2Zch3z0NvaWSmQ1mumRHgkiL
        9H3CnZamYMBY8Zbsoa5cbVwEcse+eqI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-pZPKHmkjOfqypSA_A8BFKg-1; Wed, 16 Feb 2022 19:54:56 -0500
X-MC-Unique: pZPKHmkjOfqypSA_A8BFKg-1
Received: by mail-pg1-f197.google.com with SMTP id f35-20020a631f23000000b0035ec54b3bbcso2048987pgf.0
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 16:54:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bcpVB2Dj8N0u01W1gniu2E4cAZaoAhWyOxjtWb9Ereo=;
        b=B6c3NO6nJuuaDf70O+rF0YM1iUFPAYBU1+so6YDND4ZdOsSkF6CZC8cW3g+7T166lB
         r8K/QrmtfGLNLrQqpPvmnR4HVsiL8lpS84VxsuISXjaGj38tWeuRPEGfclnBEmKKR9Bi
         NojLZQcU5RfLZZG1ZjDeUL9jVP2O+HUp9JFhVZX1SZd9AeQxXagrCSp7+DI9tABIc2n9
         g9MoqWTpVm363X4wnRnJxMekK/uBM/xOEbN+LhAL5R6SQ70mbfuhuXbfbi/F6+0WbrQx
         ImDetmpDiRYPqdfOhTEJKIFvnBTWO+eyr4oITDh5us32BV52fjm94bDHdo3hkJXT3OZC
         scYw==
X-Gm-Message-State: AOAM530tzWHPYftuOgO+6jCOw2BqP+W22y1ZGdZfliPgacR27inCTy70
        MpM5UXWslY6UIcnMjlY54EayH89mFTZyWkQtl8QvsU3cAx1TD9c/HXgnFEtflGOcFrQTO/8+5b0
        HXjuAAH23LS4aKbkmEIGxrhDFiyD/LfA2p+ybHMWLgdIwW2afwW8IrvUwmOYtUnrgCJtxK34=
X-Received: by 2002:a05:6a00:1c4f:b0:4e1:5bc:e63a with SMTP id s15-20020a056a001c4f00b004e105bce63amr444063pfw.53.1645059294828;
        Wed, 16 Feb 2022 16:54:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKWs7tbLB1epW3TOuU8Cz2BmK6uxDSDK9qtCwESmAt+26QXMnX+3efQHXnkDGmXSXHbKmxkw==
X-Received: by 2002:a05:6a00:1c4f:b0:4e1:5bc:e63a with SMTP id s15-20020a056a001c4f00b004e105bce63amr444046pfw.53.1645059294438;
        Wed, 16 Feb 2022 16:54:54 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e13sm12953061pfv.190.2022.02.16.16.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 16:54:53 -0800 (PST)
Subject: Re: [PATCH 1/3] ceph: move to a dedicated slabcache for ceph_cap_snap
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220215122316.7625-1-xiubli@redhat.com>
 <20220215122316.7625-2-xiubli@redhat.com>
 <28350c955afc4f07030ba465cb492605bf5889da.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <120d5aa0-f5c3-29d4-d120-0a901d63cc2d@redhat.com>
Date:   Thu, 17 Feb 2022 08:54:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <28350c955afc4f07030ba465cb492605bf5889da.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/16/22 10:58 PM, Jeff Layton wrote:
> On Tue, 2022-02-15 at 20:23 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> There could be huge number of capsnap queued in a short time, on
>> x86_64 it's 248 bytes, which will be rounded up to 256 bytes by
>> kzalloc. Move this to a dedicated slabcache to save 8 bytes for
>> each.
>>
>> For the kmalloc-256 slab cache, the actual size will be 512 bytes:
>> kmalloc-256        21797  74656    512   32    4 : tunables, etc
>>
>> For a dedicated slab cache the real size is 312 bytes:
>> ceph_cap_snap          0      0    312   52    4 : tunables, etc
>>
>> So actually we can save 200 bytes for each.
>>
> I dropped everything but the top paragraph in the description above. On
> non-debug kernels, kmalloc-256 is indeed 256 bytes. The inflation you're
> seeing is almost certainly from sort of kernel debugging options.

Yeah, checked it, you are right.


>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c               | 5 +++--
>>   fs/ceph/super.c              | 7 +++++++
>>   fs/ceph/super.h              | 2 +-
>>   include/linux/ceph/libceph.h | 1 +
>>   4 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index b41e6724c591..c787775eaf2a 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -482,7 +482,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>>   	struct ceph_buffer *old_blob = NULL;
>>   	int used, dirty;
>>   
>> -	capsnap = kzalloc(sizeof(*capsnap), GFP_NOFS);
>> +	capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
>>   	if (!capsnap) {
>>   		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
>>   		return;
>> @@ -603,7 +603,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>>   	spin_unlock(&ci->i_ceph_lock);
>>   
>>   	ceph_buffer_put(old_blob);
>> -	kfree(capsnap);
>> +	if (capsnap)
>> +		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
>>   	ceph_put_snap_context(old_snapc);
>>   }
>>   
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index bf79f369aec6..978463fa822c 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -864,6 +864,7 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
>>    */
>>   struct kmem_cache *ceph_inode_cachep;
>>   struct kmem_cache *ceph_cap_cachep;
>> +struct kmem_cache *ceph_cap_snap_cachep;
>>   struct kmem_cache *ceph_cap_flush_cachep;
>>   struct kmem_cache *ceph_dentry_cachep;
>>   struct kmem_cache *ceph_file_cachep;
>> @@ -892,6 +893,9 @@ static int __init init_caches(void)
>>   	ceph_cap_cachep = KMEM_CACHE(ceph_cap, SLAB_MEM_SPREAD);
>>   	if (!ceph_cap_cachep)
>>   		goto bad_cap;
>> +	ceph_cap_snap_cachep = KMEM_CACHE(ceph_cap_snap, SLAB_MEM_SPREAD);
>> +	if (!ceph_cap_snap_cachep)
>> +		goto bad_cap_snap;
>>   	ceph_cap_flush_cachep = KMEM_CACHE(ceph_cap_flush,
>>   					   SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
>>   	if (!ceph_cap_flush_cachep)
>> @@ -931,6 +935,8 @@ static int __init init_caches(void)
>>   bad_dentry:
>>   	kmem_cache_destroy(ceph_cap_flush_cachep);
>>   bad_cap_flush:
>> +	kmem_cache_destroy(ceph_cap_snap_cachep);
>> +bad_cap_snap:
>>   	kmem_cache_destroy(ceph_cap_cachep);
>>   bad_cap:
>>   	kmem_cache_destroy(ceph_inode_cachep);
>> @@ -947,6 +953,7 @@ static void destroy_caches(void)
>>   
>>   	kmem_cache_destroy(ceph_inode_cachep);
>>   	kmem_cache_destroy(ceph_cap_cachep);
>> +	kmem_cache_destroy(ceph_cap_snap_cachep);
>>   	kmem_cache_destroy(ceph_cap_flush_cachep);
>>   	kmem_cache_destroy(ceph_dentry_cachep);
>>   	kmem_cache_destroy(ceph_file_cachep);
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index c0718d5a8fb8..2d08104c8955 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -231,7 +231,7 @@ static inline void ceph_put_cap_snap(struct ceph_cap_snap *capsnap)
>>   	if (refcount_dec_and_test(&capsnap->nref)) {
>>   		if (capsnap->xattr_blob)
>>   			ceph_buffer_put(capsnap->xattr_blob);
>> -		kfree(capsnap);
>> +		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
>>   	}
>>   }
>>   
>> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
>> index edf62eaa6285..00af2c98da75 100644
>> --- a/include/linux/ceph/libceph.h
>> +++ b/include/linux/ceph/libceph.h
>> @@ -284,6 +284,7 @@ DEFINE_RB_LOOKUP_FUNC(name, type, keyfld, nodefld)
>>   
>>   extern struct kmem_cache *ceph_inode_cachep;
>>   extern struct kmem_cache *ceph_cap_cachep;
>> +extern struct kmem_cache *ceph_cap_snap_cachep;
>>   extern struct kmem_cache *ceph_cap_flush_cachep;
>>   extern struct kmem_cache *ceph_dentry_cachep;
>>   extern struct kmem_cache *ceph_file_cachep;

