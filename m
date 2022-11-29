Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD6C63BBF8
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Nov 2022 09:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiK2IsM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Nov 2022 03:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiK2IsK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Nov 2022 03:48:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A2224BCD
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 00:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669711636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uS/a77kxOTkdzpwkhaoeuYUzFostshRkgcYfunpl60=;
        b=SApyAycrkKf+OAXmhyq2ls9mKaEcx2XpiCVizyPwgLXmEZq1vYPVYWuKub3cQhZn4/+BU6
        JorgO8Np7XYQrxEDiJRD8PQzRbnknKwdq2s3w66wXSL7bn9Muwa2zTA48edLphDrUT9Rzd
        p7iimTRlCHr2uHCzgfyToAXRuLnn8pU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-618-xR0McHD6NguZ47nV4TSMIQ-1; Tue, 29 Nov 2022 03:47:14 -0500
X-MC-Unique: xR0McHD6NguZ47nV4TSMIQ-1
Received: by mail-pg1-f197.google.com with SMTP id e37-20020a635025000000b00476bfca5d31so8744468pgb.21
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 00:47:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3uS/a77kxOTkdzpwkhaoeuYUzFostshRkgcYfunpl60=;
        b=twIuBEukR9+EHlYzh7u0S6FoSjoXTLZVWRK384kCSvR4+wW6rXCZUScrZ9CZsNMuf8
         hDVoIVCL/oO2ijkVYYMfgksrtba8jz6F/T7Pc3R94e+8gM36l6HLKxLoxUwnJpT5lWzq
         ozdhpkgfC68rguqKrrIFw5Z0PxuVib/22LrHvfsIDVjY6rMaOyO4pXAhhmE5NEE9k4CG
         iokL0XUOqy3MstwwMkb6KXqCPAqKs+eZzrF/3iDhcVr5MZymEPRMlG6j2PEafzngbe8X
         BEPgGGl+PuDdFIsgjDtU01BnxW1B+yPsGD3pb9FX1gT0n9hxo0L4ExSrw2vHQGCRJqDr
         pXqQ==
X-Gm-Message-State: ANoB5pkEIdAA4SqtOZdoPQkpTbpTbfyJWAu8mz/t/DnZJH6EnIgn/NuA
        eAANtbjU9ftm9ouY8bxuAD8VUw5h62wLU4gU+3uSW9Ic5ghJsPaXFrRf3z1vYSKkqHRYm8Dd9gL
        F/pF0FYX1fa+FeDc8920cvQ==
X-Received: by 2002:a17:902:8347:b0:188:f570:7bb6 with SMTP id z7-20020a170902834700b00188f5707bb6mr49406996pln.74.1669711633287;
        Tue, 29 Nov 2022 00:47:13 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4BICOdP5OgwMhqAwHuMW+T39R7rsEajVKkLPFGQtx3ZG101fE+f3ls+TVx19JimHMrAvbDIw==
X-Received: by 2002:a17:902:8347:b0:188:f570:7bb6 with SMTP id z7-20020a170902834700b00188f5707bb6mr49406983pln.74.1669711633011;
        Tue, 29 Nov 2022 00:47:13 -0800 (PST)
Received: from [10.72.12.126] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902e9d100b0018544ad1e8esm10238357plk.238.2022.11.29.00.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 00:47:12 -0800 (PST)
Subject: Re: [PATCH v3] ceph: mark directory as non-complete complete after
 loading key
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221122145920.17025-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <dd36f5c2-5eab-760c-0fb2-eae6764a8222@redhat.com>
Date:   Tue, 29 Nov 2022 16:47:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221122145920.17025-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Luis,

BTW, which branch are you using to generate this patch ?

Could you rebase to the testing branch ?

Thanks

- Xiubo


On 22/11/2022 22:59, Luís Henriques wrote:
> When setting a directory's crypt context, ceph_dir_clear_complete() needs to
> be called otherwise if it was complete before, any existing (old) dentry will
> still be valid.
>
> This patch adds a wrapper around __fscrypt_prepare_readdir() which will
> ensure a directory is marked as non-complete if key status changes.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Hi!
>
> Hopefully I'm not breaking anything else.  I've run a bunch of fstests and
> didn't saw any (new) failures.
>
> Changes since v2:
> - Created helper wrapper for __fscrypt_prepare_readdir()
> - Added calls to the new helper
>
> Changes since v1:
> - Moved the __ceph_dir_clear_complete() call from ceph_crypt_get_context()
>    to ceph_lookup().
> - Added an __fscrypt_prepare_readdir() wrapper to check key status changes
>
>   fs/ceph/crypto.c     | 35 +++++++++++++++++++++++++++++++++--
>   fs/ceph/crypto.h     |  6 ++++++
>   fs/ceph/dir.c        |  8 ++++----
>   fs/ceph/mds_client.c |  6 +++---
>   4 files changed, 46 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index 35a2ccfe6899..5ef65a06af98 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -397,8 +397,8 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
>   		goto out_inode;
>   	}
>   
> -	ret = __fscrypt_prepare_readdir(dir);
> -	if (ret)
> +	ret = ceph_fscrypt_prepare_readdir(dir);
> +	if (ret < 0)
>   		goto out_inode;
>   
>   	/*
> @@ -636,3 +636,34 @@ int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
>   	}
>   	return ret;
>   }
> +
> +/**
> + * ceph_fscrypt_prepare_readdir - simple __fscrypt_prepare_readdir() wrapper
> + * @dir: directory inode for readdir prep
> + *
> + * Simple wrapper around __fscrypt_prepare_readdir() that will mark directory as
> + * non-complete if this call results in having the directory unlocked.
> + *
> + * Returns:
> + *     1 - if directory was locked and key is now loaded (i.e. dir is unlocked)
> + *     0 - if directory is still locked
> + *   < 0 - if __fscrypt_prepare_readdir() fails
> + */
> +int ceph_fscrypt_prepare_readdir(struct inode *dir)
> +{
> +	bool had_key = fscrypt_has_encryption_key(dir);
> +	int err;
> +
> +	if (!IS_ENCRYPTED(dir))
> +		return 0;
> +
> +	err = __fscrypt_prepare_readdir(dir);
> +	if (err)
> +		return err;
> +	if (!had_key && fscrypt_has_encryption_key(dir)) {
> +		/* directory just got unlocked, mark it as not complete */
> +		ceph_dir_clear_complete(dir);
> +		return 1;
> +	}
> +	return 0;
> +}
> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> index c6ee993f4ec8..cad53ec916fd 100644
> --- a/fs/ceph/crypto.h
> +++ b/fs/ceph/crypto.h
> @@ -154,6 +154,7 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page, u64 of
>   				 struct ceph_sparse_extent *map, u32 ext_cnt);
>   int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
>   				int len, gfp_t gfp);
> +int ceph_fscrypt_prepare_readdir(struct inode *dir);
>   
>   static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
>   {
> @@ -254,6 +255,11 @@ static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
>   {
>   	return page;
>   }
> +
> +static inline int ceph_fscrypt_prepare_readdir(struct inode *dir)
> +{
> +	return 0;
> +}
>   #endif /* CONFIG_FS_ENCRYPTION */
>   
>   static inline loff_t ceph_fscrypt_page_offset(struct page *page)
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index edc2bf0aab83..5829f27d058d 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -343,8 +343,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   		ctx->pos = 2;
>   	}
>   
> -	err = fscrypt_prepare_readdir(inode);
> -	if (err)
> +	err = ceph_fscrypt_prepare_readdir(inode);
> +	if (err < 0)
>   		return err;
>   
>   	spin_lock(&ci->i_ceph_lock);
> @@ -784,8 +784,8 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>   		return ERR_PTR(-ENAMETOOLONG);
>   
>   	if (IS_ENCRYPTED(dir)) {
> -		err = __fscrypt_prepare_readdir(dir);
> -		if (err)
> +		err = ceph_fscrypt_prepare_readdir(dir);
> +		if (err < 0)
>   			return ERR_PTR(err);
>   		if (!fscrypt_has_encryption_key(dir)) {
>   			spin_lock(&dentry->d_lock);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 9518ac8e407d..4becc9eada4b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2551,8 +2551,8 @@ static u8 *get_fscrypt_altname(const struct ceph_mds_request *req, u32 *plen)
>   	if (!IS_ENCRYPTED(dir))
>   		goto success;
>   
> -	ret = __fscrypt_prepare_readdir(dir);
> -	if (ret)
> +	ret = ceph_fscrypt_prepare_readdir(dir);
> +	if (ret < 0)
>   		return ERR_PTR(ret);
>   
>   	/* No key? Just ignore it. */
> @@ -2668,7 +2668,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
>   			spin_unlock(&cur->d_lock);
>   			parent = dget_parent(cur);
>   
> -			ret = __fscrypt_prepare_readdir(d_inode(parent));
> +			ret = ceph_fscrypt_prepare_readdir(d_inode(parent));
>   			if (ret < 0) {
>   				dput(parent);
>   				dput(cur);
>

