Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61D16331C0
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Nov 2022 02:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiKVBDV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Nov 2022 20:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiKVBDU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Nov 2022 20:03:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE60A2894
        for <ceph-devel@vger.kernel.org>; Mon, 21 Nov 2022 17:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669078943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCliI++SK2VwVV/mu+efqGEn8wYMsS23lZMFREzOpN0=;
        b=BSwQtWjKyOJegHRiB1FVNg5+j4jxWlYhN0lq4FfqA4MewWDycq8hMSH1ofI/V3gkrsp1fi
        w+HPEvv9TXxKTs5PBbYz0Zon5Qef9k4Vwm/F0m3ZmOSHYQ7mRb/CnG9S9inbFx/HneBIZ9
        tcTld50RHYYiWBBD5ZlustumT3+zoeI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-543-03VhipPwPwivj_I8bcVQHw-1; Mon, 21 Nov 2022 20:02:21 -0500
X-MC-Unique: 03VhipPwPwivj_I8bcVQHw-1
Received: by mail-pj1-f72.google.com with SMTP id my9-20020a17090b4c8900b002130d29fd7cso12933997pjb.7
        for <ceph-devel@vger.kernel.org>; Mon, 21 Nov 2022 17:02:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TCliI++SK2VwVV/mu+efqGEn8wYMsS23lZMFREzOpN0=;
        b=yACbBYKIZdbW1theszk0Ui99yVIZ35+S48SJh9Hl0UfODR781u5MztoPSwB3rImtFr
         7W3r7E1f6GkgNxK3uGTMQV+J0Oeqs7GX1YntCAndGezjkQ55lyKXUsgmUofxwBBfoLZR
         W9kwwVAnmVoa5lrKwoBaBTeOT/IJRWSr3kk40Np/zEOSzixF8TXC7QHJqyPxHDzgkilB
         qbY4/kvJQiKNhthiksUZ8CyaYO3bya0kxzWtLCXTgj3OkjU75yNIrj048CO6Y9NYOrOF
         llwokaxzdVD2oKzPAl0OPoH4O3IbvK90YIyDKFEcbcr2n+bAO8LaHy5TnXG7twF6H+TK
         HEQg==
X-Gm-Message-State: ANoB5pnZYi6DMC7/9F8/y/e8Dd6L/BRNo/BeB7Sj1nFzRTLLAb+Z4Dwa
        8UcUYOYkJd7BIWs9TRJPuO5PlOTGS7WpoZa3HLxLW4Q3kHDQ2fDl6wtid1un5ogn2Pu/a9IBSn8
        tgKez5XFblTajFB7nCKnA+w==
X-Received: by 2002:a17:902:aa44:b0:189:fdf:a3d9 with SMTP id c4-20020a170902aa4400b001890fdfa3d9mr12342221plr.9.1669078940787;
        Mon, 21 Nov 2022 17:02:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5O6IFyyfSw7LoXbfb4uwV76C9iA2jeH6mN+OGq5TnncolVxXSYhHP5kr4vQZ22bw1Qb6nxaQ==
X-Received: by 2002:a17:902:aa44:b0:189:fdf:a3d9 with SMTP id c4-20020a170902aa4400b001890fdfa3d9mr12342192plr.9.1669078940509;
        Mon, 21 Nov 2022 17:02:20 -0800 (PST)
Received: from [10.72.12.200] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id om10-20020a17090b3a8a00b001fde655225fsm521612pjb.2.2022.11.21.17.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 17:02:19 -0800 (PST)
Subject: Re: [PATCH v2] ceph: make sure directories aren't complete after
 setting crypt context
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221121180004.8038-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <fbce8a0b-340b-0d82-ffbc-1245e30876f9@redhat.com>
Date:   Tue, 22 Nov 2022 09:02:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221121180004.8038-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 22/11/2022 02:00, Luís Henriques wrote:
> When setting a directory's crypt context, __ceph_dir_clear_complete() needs
> to be used otherwise, if it was complete before, any old dentry that's still
> around will be valid.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Hi Xiubo!
>
> I've added the __fscrypt_prepare_readdir() wrapper as you suggested, but I
> had to change it slightly because we also need to handle the error cases.
>
> Changes since v1:
> - Moved the __ceph_dir_clear_complete() call from ceph_crypt_get_context()
>    to ceph_lookup().
> - Added an __fscrypt_prepare_readdir() wrapper to check key status changes
>
>   fs/ceph/dir.c | 31 ++++++++++++++++++++++++++++---
>   1 file changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index edc2bf0aab83..2cac7e3ab352 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -763,6 +763,27 @@ static bool is_root_ceph_dentry(struct inode *inode, struct dentry *dentry)
>   		strncmp(dentry->d_name.name, ".ceph", 5) == 0;
>   }
>   
> +/*
> + * Simple wrapper around __fscrypt_prepare_readdir() that will return:
> + *
> + * - '1' if directory was locked and key is now loaded (i.e. dir is unlocked),
> + * - '0' if directory is still locked, or
> + * - an error (< 0) if __fscrypt_prepare_readdir() fails.
> + */
> +static int ceph_fscrypt_prepare_readdir(struct inode *dir)
> +{
> +	bool had_key = fscrypt_has_encryption_key(dir);
> +	int err;
> +
> +	err = __fscrypt_prepare_readdir(dir);
> +	if (err)
> +		return err;
> +	/* is directory now unlocked? */
> +	if (!had_key && fscrypt_has_encryption_key(dir))
> +		return 1;
> +	return 0;
> +}
> +
>   /*
>    * Look up a single dir entry.  If there is a lookup intent, inform
>    * the MDS so that it gets our 'caps wanted' value in a single op.
> @@ -784,10 +805,14 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>   		return ERR_PTR(-ENAMETOOLONG);
>   
>   	if (IS_ENCRYPTED(dir)) {
> -		err = __fscrypt_prepare_readdir(dir);
> -		if (err)
> +		err = ceph_fscrypt_prepare_readdir(dir);
> +		if (err < 0)
>   			return ERR_PTR(err);
> -		if (!fscrypt_has_encryption_key(dir)) {
> +		if (err) {
> +			/* directory just got unlocked */
> +			__ceph_dir_clear_complete(ceph_inode(dir));

Luis,

Could we just move this into ceph_fscrypt_prepare_readdir() ? IMO we 
should always clear the complete flag always whenever the key is first 
loaded.

> +		} else {
> +			/* no encryption key */

I think you also need to fix all the other places, which are calling the 
__fscrypt_prepare_readdir() or fscrypt_prepare_readdir() in ceph. 
Because we don't know the ceph_lookup() will always be the first caller 
to trigger __fscrypt_prepare_readdir() for a dir.

Thanks!

- Xiubo

>   			spin_lock(&dentry->d_lock);
>   			dentry->d_flags |= DCACHE_NOKEY_NAME;
>   			spin_unlock(&dentry->d_lock);
>

