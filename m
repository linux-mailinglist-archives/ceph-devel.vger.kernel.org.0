Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86F24DA6B0
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Mar 2022 01:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352271AbiCPAJV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 20:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348800AbiCPAJU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 20:09:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E62012AE8
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 17:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647389284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PCFdOZxI4solGcrGUbRWwk0o4xvSLZiBmIOjrXXHesE=;
        b=Q83DizALJBHWo+ln15hTih4DvVqWV7+vzYtCyaH4Y1Ge60f1GTW/mP8sg0JnykIo92uyY7
        VeAa3s3bz2EZaQvTkaUOi4Z181T0LxbXwpypVPR44m6q3okIvusHs4TYwFFa2vt10qaJ9P
        rxrd0/giSJM0/iNHNGCosVg6ff2qQPI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-agIWZX38N2-eUes7uKnaRw-1; Tue, 15 Mar 2022 20:08:01 -0400
X-MC-Unique: agIWZX38N2-eUes7uKnaRw-1
Received: by mail-pl1-f199.google.com with SMTP id ik24-20020a170902ab1800b00153ae512603so291989plb.14
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 17:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PCFdOZxI4solGcrGUbRWwk0o4xvSLZiBmIOjrXXHesE=;
        b=LcAREFrzmZ9pEMPYBMjw8WkaO4siuka/wV0wpMWOw1U/lRjFgBo1eH8X1kdpN5aAHQ
         nmGYPm3DJf/Iy0u3tVOI/Yr6GNoAhb2VM596IuERwOUgHL0kaaVlZE0v2FYXlfl7ycBM
         kaKYCoNR7Zcg3hNXj2dFkp1j29/lQ30Nyg/v/gJA8YXWQDZsSH4vZcGBSa9cxWVCCKdC
         mMRCzuHsgME9Ba2vS3bQNIOXq3y6BdRmU4Q28MiI8Vci8y4+8ToD2VnHBfpbbDjB0Lp4
         i3biL+TBGV0Xc4kzspqYC7OZcHAOyEaqPSCpMtK7rWkWiiYxehrY8SYQmSWzxCMe7nfR
         OkiQ==
X-Gm-Message-State: AOAM531X/bjNO9TaXj5gha+oRTegwWl/JYZg6NSZzyPMJgIGLUgqPi/T
        FjGNg8eWf/LYO8peJEcVpmkGYERCwye1hGULmeT/nHW66X/Tz0Ck506C5DufxjGEk84P89RyeCR
        hUiLa8UlwJwrbNK2tmyvCDw==
X-Received: by 2002:a63:f04f:0:b0:373:bd70:af2 with SMTP id s15-20020a63f04f000000b00373bd700af2mr26173237pgj.497.1647389280084;
        Tue, 15 Mar 2022 17:08:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzS4mf7yK4bBygxB0gR0dzVc38ESt/I83boPKsAH9Kd8PcoayeY3vqFLLDFpj4J+2h8hoPJtA==
X-Received: by 2002:a63:f04f:0:b0:373:bd70:af2 with SMTP id s15-20020a63f04f000000b00373bd700af2mr26173232pgj.497.1647389279843;
        Tue, 15 Mar 2022 17:07:59 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o5-20020a655bc5000000b00372f7ecfcecsm366556pgr.37.2022.03.15.17.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 17:07:59 -0700 (PDT)
Subject: Re: [RFC PATCH v2 1/3] ceph: add support for encrypted snapshot names
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220315161959.19453-1-lhenriques@suse.de>
 <20220315161959.19453-2-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d55a7f85-b85b-8bb8-c89c-31579f173541@redhat.com>
Date:   Wed, 16 Mar 2022 08:07:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220315161959.19453-2-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
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


On 3/16/22 12:19 AM, Luís Henriques wrote:
> Since filenames in encrypted directories are already encrypted and shown
> as a base64-encoded string when the directory is locked, snapshot names
> should show a similar behaviour.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   fs/ceph/inode.c | 31 +++++++++++++++++++++++++++----
>   1 file changed, 27 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 7b670e2405c1..359e29896f16 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -91,9 +91,15 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
>   	if (err < 0)
>   		goto out_err;
>   
> -	err = ceph_fscrypt_prepare_context(dir, inode, as_ctx);
> -	if (err)
> -		goto out_err;
> +	/*
> +	 * We'll skip setting fscrypt context for snapshots, leaving that for
> +	 * the handle_reply().
> +	 */
> +	if (ceph_snap(dir) != CEPH_SNAPDIR) {
> +		err = ceph_fscrypt_prepare_context(dir, inode, as_ctx);
> +		if (err)
> +			goto out_err;
> +	}
>   
>   	return inode;
>   out_err:
> @@ -157,6 +163,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>   	};
>   	struct inode *inode = ceph_get_inode(parent->i_sb, vino, NULL);
>   	struct ceph_inode_info *ci = ceph_inode(inode);
> +	int ret = -ENOTDIR;
>   
>   	if (IS_ERR(inode))
>   		return inode;
> @@ -182,6 +189,22 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>   	ci->i_rbytes = 0;
>   	ci->i_btime = ceph_inode(parent)->i_btime;
>   
> +	/* if encrypted, just borrow fscrypt_auth from parent */
> +	if (IS_ENCRYPTED(parent)) {
> +		struct ceph_inode_info *pci = ceph_inode(parent);
> +
> +		ci->fscrypt_auth = kmemdup(pci->fscrypt_auth,
> +					   pci->fscrypt_auth_len,
> +					   GFP_KERNEL);
> +		if (ci->fscrypt_auth) {
> +			inode->i_flags |= S_ENCRYPTED;
> +			ci->fscrypt_auth_len = pci->fscrypt_auth_len;
> +		} else {
> +			dout("Failed to alloc snapdir fscrypt_auth\n");
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +	}
>   	if (inode->i_state & I_NEW) {
>   		inode->i_op = &ceph_snapdir_iops;
>   		inode->i_fop = &ceph_snapdir_fops;
> @@ -195,7 +218,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>   		discard_new_inode(inode);
>   	else
>   		iput(inode);
> -	return ERR_PTR(-ENOTDIR);
> +	return ERR_PTR(ret);
>   }
>   
>   const struct inode_operations ceph_file_iops = {
>
LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


