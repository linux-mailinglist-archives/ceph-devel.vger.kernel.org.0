Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8966B968F
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Mar 2023 14:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjCNNlz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Mar 2023 09:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjCNNlW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 14 Mar 2023 09:41:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E638DCDB
        for <ceph-devel@vger.kernel.org>; Tue, 14 Mar 2023 06:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678801082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5BAWO2qfjAP5ai7L1LtGmvg+Fl4YdyMs+HI76CK4big=;
        b=SQF9ZvccdgECBZbf8lqlTb2sXKRw2vKjJWxckxRw3VLYYzbDIJxA4sUlaUYAV2q7h76rGN
        Re5zQGK2NhLXlgOqxdyhHsIxOwHziwa5nzwyvD0nItoPSU00mRbUf0qI6ORb7V01b/6PpU
        ZIIFUb7r+PMCrCMwMuHf9vvwcISPi9U=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-gpU8ThloONGMauMv9BqgMA-1; Tue, 14 Mar 2023 09:38:01 -0400
X-MC-Unique: gpU8ThloONGMauMv9BqgMA-1
Received: by mail-pl1-f198.google.com with SMTP id l10-20020a17090270ca00b0019caa6e6bd1so8777428plt.2
        for <ceph-devel@vger.kernel.org>; Tue, 14 Mar 2023 06:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678801080;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5BAWO2qfjAP5ai7L1LtGmvg+Fl4YdyMs+HI76CK4big=;
        b=kQuesa9ta+WKqMsDXd+m/jEnyiSlTQy7OucybLyS+WAEo8u4kR0W1wcaYDIc2aVjOL
         MPy/Qdgim83jQFykwtdhlI35N0JSJpDq7v/Tgj6L424gawIU/QebrazG3fKbAbi5yunv
         zy05lM1+LuIsOL92WerwKCOZ4dWuvs/cMYacEgdPtCgpVvaCwGZHqSdUXEqrt2WZHb7E
         A4cH89On8FL7XfB+CskPFPUUNlcmxwUdC/o7/ZmGfYbzjE821NkVMCe8u0K/Uy6HQ937
         8Z2tpY7tcxHeBPc7l2cySOzoJYH35nExjZ7nvHifaOEQo0q1JsHrnJ8VjJ3jL8vYQ9b2
         /acg==
X-Gm-Message-State: AO0yUKUoEOOCyCarGLBf9zbLDDVzL48pRcbfekt8BX721XDQ8E66BQ/m
        WsA4LrDZc8MujIHcpAfaPbvNPzT9NDMPfVWSRkbHOd/AfJ8SFsgD5WX6+7yF+dHrR1S66EBdAXH
        tyFnzITGZnOkZlktdqly6GA==
X-Received: by 2002:a17:902:8683:b0:19b:107b:698e with SMTP id g3-20020a170902868300b0019b107b698emr30836110plo.14.1678801080242;
        Tue, 14 Mar 2023 06:38:00 -0700 (PDT)
X-Google-Smtp-Source: AK7set+Y5jue++oAKPHoeQOXRpzv2zdGLstHN8zleYNHRXdsZaynbJUQTpRxV5T5pWf8zTD7wH73Aw==
X-Received: by 2002:a17:902:8683:b0:19b:107b:698e with SMTP id g3-20020a170902868300b0019b107b698emr30836098plo.14.1678801079883;
        Tue, 14 Mar 2023 06:37:59 -0700 (PDT)
Received: from [10.72.12.147] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902c3c600b00183c6784704sm1738753plj.291.2023.03.14.06.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 06:37:59 -0700 (PDT)
Message-ID: <0e2c9678-55ed-2b71-8abd-e7c85c814e27@redhat.com>
Date:   Tue, 14 Mar 2023 21:37:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 1/2] fscrypt: new helper function -
 fscrypt_prepare_atomic_open()
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Eric Biggers <ebiggers@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230314103902.32592-1-lhenriques@suse.de>
 <20230314103902.32592-2-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230314103902.32592-2-lhenriques@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 14/03/2023 18:39, Luís Henriques wrote:
> This patch introduces a new helper function which prepares an atomic_open.
> Because atomic open can act as a lookup if handed a dentry that is negative,
> we need to set DCACHE_NOKEY_NAME if the key for the parent isn't available.
>
> The reason for getting the encryption info before checking if the directory has
> the encryption key is because we may have the key available but the encryption
> info isn't yet set (maybe due to a drop_caches).  The regular open path will
> call fscrypt_file_open() which uses function fscrypt_require_key() for setting
> the encryption info if needed.  The atomic open needs to do something similar.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   fs/crypto/hooks.c       | 33 +++++++++++++++++++++++++++++++++
>   include/linux/fscrypt.h |  7 +++++++
>   2 files changed, 40 insertions(+)
>
> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> index 7b8c5a1104b5..165ddf01bf9f 100644
> --- a/fs/crypto/hooks.c
> +++ b/fs/crypto/hooks.c
> @@ -117,6 +117,39 @@ int __fscrypt_prepare_readdir(struct inode *dir)
>   }
>   EXPORT_SYMBOL_GPL(__fscrypt_prepare_readdir);
>   
> +/**
> + * fscrypt_prepare_atomic_open() - prepare an atomic open on an encrypted directory
> + * @dir: inode of parent directory
> + * @dentry: dentry being open
> + *
> + * Because atomic open can act as a lookup if handed a dentry that is negative,
> + * we need to set DCACHE_NOKEY_NAME if the key for the parent isn't available.
> + *
> + * The reason for getting the encryption info before checking if the directory
> + * has the encryption key is because the key may be available but the encryption
> + * info isn't yet set (maybe due to a drop_caches).  The regular open path will
> + * call fscrypt_file_open() which uses function fscrypt_require_key() for
> + * setting the encryption info if needed.  The atomic open needs to do something
> + * similar.
> + *
> + * Return: 0 on success, or an error code if fscrypt_get_encryption_info()
> + * fails.
> + */
> +int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)
> +{
> +	int err;
> +
> +	err = fscrypt_get_encryption_info(dir, true);
> +	if (!err && !fscrypt_has_encryption_key(dir)) {
> +		spin_lock(&dentry->d_lock);
> +		dentry->d_flags |= DCACHE_NOKEY_NAME;
> +		spin_unlock(&dentry->d_lock);
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(fscrypt_prepare_atomic_open);
> +
>   int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr)
>   {
>   	if (attr->ia_valid & ATTR_SIZE)
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index 4f5f8a651213..c70acb2a737a 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -362,6 +362,7 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
>   int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
>   			     struct fscrypt_name *fname);
>   int __fscrypt_prepare_readdir(struct inode *dir);
> +int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry);
>   int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr);
>   int fscrypt_prepare_setflags(struct inode *inode,
>   			     unsigned int oldflags, unsigned int flags);
> @@ -688,6 +689,12 @@ static inline int __fscrypt_prepare_readdir(struct inode *dir)
>   	return -EOPNOTSUPP;
>   }
>   
> +static inline int fscrypt_prepare_atomic_open(struct inode *dir,
> +					      struct dentry *dentry)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>   static inline int __fscrypt_prepare_setattr(struct dentry *dentry,
>   					    struct iattr *attr)
>   {
>
Reviewed-by: Xiubo Li <xiubli@redhat.com>


