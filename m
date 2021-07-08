Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10443BF418
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 04:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGHC7n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jul 2021 22:59:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230229AbhGHC7m (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jul 2021 22:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625713021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bTwhpLi/vIUO55WyGqUrYH/trfR5psNmZ2zj2iPipmo=;
        b=R4q+3vIgLDq6casE2/UXjnCrIIn48D2MRy1kLaDR3HFGbbV/RtebosiWw7vtG3Q1lRdChH
        qcffweWJhwXF+t6ljcg5XtjG+Mg/P66aZmZTeN3sDSH1jJEGSPbjA5hhAdixiYUmvWH7Hk
        W+6k2KX8K1rM1pfc+5mNhPbBOBp37rw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-0Koi5be1P9WmBI4y2cFaMg-1; Wed, 07 Jul 2021 22:56:57 -0400
X-MC-Unique: 0Koi5be1P9WmBI4y2cFaMg-1
Received: by mail-pj1-f71.google.com with SMTP id k92-20020a17090a14e5b02901731af08bd7so2769238pja.2
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jul 2021 19:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bTwhpLi/vIUO55WyGqUrYH/trfR5psNmZ2zj2iPipmo=;
        b=VvnYNXRQ8a/TaXTFuZRSnvNKPX94s0vOg+Lh4m4Laz4KoxqFDt0Qg2y8MGCtBWVEr+
         98IkRTRO3EV7imHOzZadMeJ1FHr/ZBqykKDvStTWR44AvqP30EZLwfA0kbczxRPw6SWv
         zuYN3W2ASDojJyEYI+ciaH3za35/SZCQlw/ONoqP8TWhxeXb6HEjnRwlH4+vXsOfBdVE
         khmB3uVxswQTu53gjR8FEAVFmuP8YxU/keSWdhnGFnpc1/YrliSMouUl8WLhSZuvW01N
         9bC0ETJcMmlGCcYNisOmoNzLtBZdTNjfsEA6e6O3qcerANLFRqBti/Dkv5qeT+mxPWTT
         ZAoA==
X-Gm-Message-State: AOAM532YKZieuRE/BmOeiymRlwlXT4zmbvD9qdE+rPA78BGtmIuvOHns
        ivcBv6E/Q7i6gzEdGgVsNGAtAW1qA2cR3ef6EUvm6qjdoF5/O7Jg/lbohznELi/typmMG85nhh0
        Dwj+bf5njt+SoJBgoO/gsAw==
X-Received: by 2002:a17:90a:1d43:: with SMTP id u3mr2313378pju.121.1625713016636;
        Wed, 07 Jul 2021 19:56:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDzbtefmgnEs6gYTiMc6Yil/v90cqF6rRwD4lHqSZVOi/TnLanW2/c9WX1PMwjJBUuF8cWlA==
X-Received: by 2002:a17:90a:1d43:: with SMTP id u3mr2313361pju.121.1625713016382;
        Wed, 07 Jul 2021 19:56:56 -0700 (PDT)
Received: from [10.72.13.124] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q17sm744222pgd.39.2021.07.07.19.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 19:56:55 -0700 (PDT)
Subject: Re: [RFC PATCH v7 06/24] ceph: parse new fscrypt_auth and
 fscrypt_file fields in inode traces
To:     Luis Henriques <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, dhowells@redhat.com
References: <20210625135834.12934-1-jlayton@kernel.org>
 <20210625135834.12934-7-jlayton@kernel.org> <YOWGPv099N7EsMVA@suse.de>
 <14d96eb9-c9b5-d854-d87a-65c1ab3be57e@redhat.com>
 <d9a56cc0d568bbf59cc76ad618b4d0f92c021fed.camel@kernel.org>
 <YOW67YA8e6vivdkh@suse.de> <YOXAo8Q0GQoWaAQE@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <732d3526-5979-f276-80fa-2bc56ccd946c@redhat.com>
Date:   Thu, 8 Jul 2021 10:56:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YOXAo8Q0GQoWaAQE@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/7/21 10:56 PM, Luis Henriques wrote:
> On Wed, Jul 07, 2021 at 03:32:13PM +0100, Luis Henriques wrote:
>> On Wed, Jul 07, 2021 at 08:19:25AM -0400, Jeff Layton wrote:
>>> On Wed, 2021-07-07 at 19:19 +0800, Xiubo Li wrote:
>>>> On 7/7/21 6:47 PM, Luis Henriques wrote:
>>>>> On Fri, Jun 25, 2021 at 09:58:16AM -0400, Jeff Layton wrote:
>>>>>> ...and store them in the ceph_inode_info.
>>>>>>
>>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>>> ---
>>>>>>    fs/ceph/file.c       |  2 ++
>>>>>>    fs/ceph/inode.c      | 18 ++++++++++++++++++
>>>>>>    fs/ceph/mds_client.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>>>>>    fs/ceph/mds_client.h |  4 ++++
>>>>>>    fs/ceph/super.h      |  6 ++++++
>>>>>>    5 files changed, 74 insertions(+)
>>>>>>
>>>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>>>> index 2cda398ba64d..ea0e85075b7b 100644
>>>>>> --- a/fs/ceph/file.c
>>>>>> +++ b/fs/ceph/file.c
>>>>>> @@ -592,6 +592,8 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
>>>>>>    	iinfo.xattr_data = xattr_buf;
>>>>>>    	memset(iinfo.xattr_data, 0, iinfo.xattr_len);
>>>>>>    
>>>>>> +	/* FIXME: set fscrypt_auth and fscrypt_file */
>>>>>> +
>>>>>>    	in.ino = cpu_to_le64(vino.ino);
>>>>>>    	in.snapid = cpu_to_le64(CEPH_NOSNAP);
>>>>>>    	in.version = cpu_to_le64(1);	// ???
>>>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>>>> index f62785e4dbcb..b620281ea65b 100644
>>>>>> --- a/fs/ceph/inode.c
>>>>>> +++ b/fs/ceph/inode.c
>>>>>> @@ -611,6 +611,13 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>>>>>>    
>>>>>>    	ci->i_meta_err = 0;
>>>>>>    
>>>>>> +#ifdef CONFIG_FS_ENCRYPTION
>>>>>> +	ci->fscrypt_auth = NULL;
>>>>>> +	ci->fscrypt_auth_len = 0;
>>>>>> +	ci->fscrypt_file = NULL;
>>>>>> +	ci->fscrypt_file_len = 0;
>>>>>> +#endif
>>>>>> +
>>>>>>    	return &ci->vfs_inode;
>>>>>>    }
>>>>>>    
>>>>>> @@ -619,6 +626,9 @@ void ceph_free_inode(struct inode *inode)
>>>>>>    	struct ceph_inode_info *ci = ceph_inode(inode);
>>>>>>    
>>>>>>    	kfree(ci->i_symlink);
>>>>>> +#ifdef CONFIG_FS_ENCRYPTION
>>>>>> +	kfree(ci->fscrypt_auth);
>>>>>> +#endif
>>>>>>    	kmem_cache_free(ceph_inode_cachep, ci);
>>>>>>    }
>>>>>>    
>>>>>> @@ -1021,6 +1031,14 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>>>>>>    		xattr_blob = NULL;
>>>>>>    	}
>>>>>>    
>>>>>> +	if (iinfo->fscrypt_auth_len && !ci->fscrypt_auth) {
>>>>>> +		ci->fscrypt_auth_len = iinfo->fscrypt_auth_len;
>>>>>> +		ci->fscrypt_auth = iinfo->fscrypt_auth;
>>>>>> +		iinfo->fscrypt_auth = NULL;
>>>>>> +		iinfo->fscrypt_auth_len = 0;
>>>>>> +		inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
>>>>>> +	}
>>>>> I think we also need to free iinfo->fscrypt_auth here if ci->fscrypt_auth
>>>>> is already set.  Something like:
>>>>>
>>>>> 	if (iinfo->fscrypt_auth_len) {
>>>>> 		if (!ci->fscrypt_auth) {
>>>>> 			...
>>>>> 		} else {
>>>>> 			kfree(iinfo->fscrypt_auth);
>>>>> 			iinfo->fscrypt_auth = NULL;
>>>>> 		}
>>>>> 	}
>>>>>
>>>> IMO, this should be okay because it will be freed in
>>>> destroy_reply_info() when putting the request.
>>>>
>>>>
>>> Yes. All of that should get cleaned up with the request.
>> Hmm... ok, so maybe I missed something because I *did* saw kmemleak
>> complaining.  Maybe it was on the READDIR path.  /me goes look again.
> Ah, that was indeed the problem.  So, here's a quick hack to fix
> destroy_reply_info() so that it also frees the extra memory from READDIR:
>
> @@ -686,12 +686,23 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
>   
>   static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
>   {
> +	int i = 0;
> +
>   	kfree(info->diri.fscrypt_auth);
>   	kfree(info->diri.fscrypt_file);
>   	kfree(info->targeti.fscrypt_auth);
>   	kfree(info->targeti.fscrypt_file);
>   	if (!info->dir_entries)
>   		return;
> +
> +	for (i = 0; i < info->dir_nr; i++) {
> +		struct ceph_mds_reply_dir_entry *rde = info->dir_entries + i;
> +		if (rde->inode.fscrypt_auth_len)
> +			kfree(rde->inode.fscrypt_auth);
> +	}
> +	
>   	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
>   }
>   

Yeah, this looks nice.


> Cheers,
> --
> Luís
>

