Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B458C4AF159
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Feb 2022 13:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiBIMVq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Feb 2022 07:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbiBIMVg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Feb 2022 07:21:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8BD7E019251
        for <ceph-devel@vger.kernel.org>; Wed,  9 Feb 2022 03:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644407856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sjYUaOD6P5QX31JnmnwKSgLLvr9hKp+c5Cjqafh7uCo=;
        b=GVyyG6647JWS6U/Jubi6LtcqhAewfBDvws0+enV3l62Yl48j4d6amsWWi7evyXx9rZeVWX
        z2r9sQ3fbaZZqte5zf/rQYmDA8UQyKA8hkWESpqk0oW4f92cdmCSPz17yqbEmxEsGEJ3sa
        ogs+2L0Lk1O09Ob6l2mN7mnbZbLz0wY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-i9vS1x_CM7egOlZChOZJOQ-1; Wed, 09 Feb 2022 06:57:35 -0500
X-MC-Unique: i9vS1x_CM7egOlZChOZJOQ-1
Received: by mail-pj1-f72.google.com with SMTP id iy10-20020a17090b16ca00b001b8a7ed5b2cso3667046pjb.7
        for <ceph-devel@vger.kernel.org>; Wed, 09 Feb 2022 03:57:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sjYUaOD6P5QX31JnmnwKSgLLvr9hKp+c5Cjqafh7uCo=;
        b=rwVuPdJXVc49pYnfWXf65VPptqjwfUAk9761a6yPwOACXoDIgCyrnDg9LnSk+p4J5C
         WeuazeTR3Cha7yk/+mOvsvC8R+WJKaAq3ebb5Mr614s1fKdRV8WLmvmpkI0qFDlVzjSn
         vUNW8H9Fm6u1zWdJt2M09ulfmc5XKnohK6Ahlgcqu2FoVHooM2x3p7CPjQqCXYhgRgIT
         CS63YrggTdzGQC7MdyItQ8FXKGK/88gTIDQKxKwsaQ9Pp5U5xNFQcool6lXbftRNJV/7
         rZRmMzACNDgTAXaciNpICrnwLnsMhxJd0XsmLnLwjPgPkCA3JAyUrBgIygfRkFiQII9i
         lRRg==
X-Gm-Message-State: AOAM533atx+9bF3ybxkHO+djPJM/N9YgwBYku8RBl/qmqr6R2FnV32Hg
        fI/FdqZHbarok/6Q4iaBOY4ejW6H4NJzXZkMU06/iDbBw/JoI+pIVeCzsCwQVyb77tEa/9WsrDe
        /AYg8Fmgy4JZCrE5vQAt/uGA13uPnMta4a309+YIoY8UNBbXC1VN8PwO0sb85EgowmrtT0Nc=
X-Received: by 2002:a63:690a:: with SMTP id e10mr1571241pgc.599.1644407853935;
        Wed, 09 Feb 2022 03:57:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydfNs64/i1FNvJ5YoEjfAgtG82K5OF13+hIcbFz5qTSx1OwxcF7h0HxjUAVW1R12NXzZ+pQQ==
X-Received: by 2002:a63:690a:: with SMTP id e10mr1571219pgc.599.1644407853586;
        Wed, 09 Feb 2022 03:57:33 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id pc4sm6603851pjb.3.2022.02.09.03.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 03:57:32 -0800 (PST)
Subject: Re: [PATCH] ceph: wake waiters after failed async create
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ridave@redhat.com,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20220208194648.190652-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b47b4e88-f537-7828-cbb8-adb0af91de0b@redhat.com>
Date:   Wed, 9 Feb 2022 19:57:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220208194648.190652-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/9/22 3:46 AM, Jeff Layton wrote:
> Currently, we only wake the waiters if we got a req->r_target_inode
> out of the reply. In the case where the create fails though, we may not
> have one.
>
> If there is a non-zero result from the create, then ensure that we wake
> anything waiting on the inode after we shut it down.
>
> URL: https://tracker.ceph.com/issues/54067
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/file.c | 51 ++++++++++++++++++++++++++++++++------------------
>   1 file changed, 33 insertions(+), 18 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 22ca724aef36..feb75eb1cd82 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -532,52 +532,67 @@ static void restore_deleg_ino(struct inode *dir, u64 ino)
>   	}
>   }
>   
> +static void wake_async_create_waiters(struct inode *inode,
> +				      struct ceph_mds_session *session)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +	spin_lock(&ci->i_ceph_lock);
> +	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> +		ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
> +		wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
> +	}
> +	ceph_kick_flushing_inode_caps(session, ci);
> +	spin_unlock(&ci->i_ceph_lock);
> +}
> +
>   static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
>                                    struct ceph_mds_request *req)
>   {
> +	struct dentry *dentry = req->r_dentry;
> +	struct inode *dinode = d_inode(dentry);
> +	struct inode *tinode = req->r_target_inode;
>   	int result = req->r_err ? req->r_err :
>   			le32_to_cpu(req->r_reply_info.head->result);
>   
> +	WARN_ON_ONCE(dinode && tinode && dinode != tinode);
> +
> +	/* MDS changed -- caller must resubmit */
>   	if (result == -EJUKEBOX)
>   		goto out;
>   
>   	mapping_set_error(req->r_parent->i_mapping, result);
>   
>   	if (result) {
> -		struct dentry *dentry = req->r_dentry;
> -		struct inode *inode = d_inode(dentry);
>   		int pathlen = 0;
>   		u64 base = 0;
>   		char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
>   						  &base, 0);
>   
> +		pr_warn("ceph: async create failure path=(%llx)%s result=%d!\n",
> +			base, IS_ERR(path) ? "<<bad>>" : path, result);
> +		ceph_mdsc_free_path(path, pathlen);
> +
>   		ceph_dir_clear_complete(req->r_parent);
>   		if (!d_unhashed(dentry))
>   			d_drop(dentry);
>   
> -		ceph_inode_shutdown(inode);
> -
> -		pr_warn("ceph: async create failure path=(%llx)%s result=%d!\n",
> -			base, IS_ERR(path) ? "<<bad>>" : path, result);
> -		ceph_mdsc_free_path(path, pathlen);
> +		if (dinode) {
> +			mapping_set_error(dinode->i_mapping, result);
> +			ceph_inode_shutdown(dinode);
> +			wake_async_create_waiters(dinode, req->r_session);
> +		}
>   	}
>   
> -	if (req->r_target_inode) {
> -		struct ceph_inode_info *ci = ceph_inode(req->r_target_inode);
> -		u64 ino = ceph_vino(req->r_target_inode).ino;
> +	if (tinode) {
> +		u64 ino = ceph_vino(tinode).ino;
>   
>   		if (req->r_deleg_ino != ino)
>   			pr_warn("%s: inode number mismatch! err=%d deleg_ino=0x%llx target=0x%llx\n",
>   				__func__, req->r_err, req->r_deleg_ino, ino);
> -		mapping_set_error(req->r_target_inode->i_mapping, result);
>   
> -		spin_lock(&ci->i_ceph_lock);
> -		if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> -			ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
> -			wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
> -		}
> -		ceph_kick_flushing_inode_caps(req->r_session, ci);
> -		spin_unlock(&ci->i_ceph_lock);
> +		mapping_set_error(tinode->i_mapping, result);
> +		wake_async_create_waiters(tinode, req->r_session);
>   	} else if (!result) {
>   		pr_warn("%s: no req->r_target_inode for 0x%llx\n", __func__,
>   			req->r_deleg_ino);

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>



