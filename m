Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F554D944B
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 07:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242212AbiCOGEC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 02:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiCOGEC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 02:04:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD8E3C02
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 23:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647324169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CWSgKVlEp4KAcoBdr+fksG63UoZ2qDhEF6WMavy+bUg=;
        b=DtZq0UyNBoDQ1mc06Sz+Ajc+lInCDKXsGuAJZJ86ybsy/pZ6EH71/z2cvVjbcx6PNmY+zX
        PX7q60VM1ZtZPMaNaXZ7Gn6ejhIbOXWOMWDxF9dzSLb02seyaz+fcWUd1wtkcsJBQhtN9B
        bz5Fj/Ab7pe0ehZ/ugsaEnzwI2upFzw=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-MjAXiXzPN1GLWte_BE5JIQ-1; Tue, 15 Mar 2022 02:02:48 -0400
X-MC-Unique: MjAXiXzPN1GLWte_BE5JIQ-1
Received: by mail-pf1-f198.google.com with SMTP id w68-20020a62dd47000000b004f6aa5e4824so11035009pff.4
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 23:02:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CWSgKVlEp4KAcoBdr+fksG63UoZ2qDhEF6WMavy+bUg=;
        b=OK0/2Ewj1yU6r373x6HIZDdSdKEUnP/bXAJPjR/xeLKvFvnv/7MlfOj+qpoNV4QPQS
         SvHZ6h1roc/97mKJcvQDNTdawlteIyxCgf1DVWZIXxkAc3Dj3FekTLDCuxfl2jA2wALo
         XK3eadHckxARApoE21snpAv0Xh+40cBkq7l7Sk9gtaU4Yf7iivofPLhQB4ZlsyUIsrFQ
         6nOiMdCmt6OuaZJQ1SNlZwWSx4lIhZv2lr2oC0Wp1u+iNdD7nzOTEbOQiY6bYhfXy6y7
         B9VXWU4Aj36kUAny7S7w/htI/oi3HEjlqrH1q05Wk7+snnQayAjuEqW4uk4tO8xQv+LJ
         2jjg==
X-Gm-Message-State: AOAM532YMBN4sdjm5poUGZCBuk2QtxwEB1jMCmADb06HsHib7rXe63Oj
        BJ0GLPrGbMxCFuovgvXWvOfntKd1zOzjVRUKm7W5vCbR1GlTKgLuxUUhLBmmpX98+Nrm1/O4+b8
        JYRrrELNDFiMTu6Kvq2hiFP7SQQetAEVxbWgV+NuC4E1bm4b9zaRlSAPY4TEcXAKacxup48U=
X-Received: by 2002:a63:1065:0:b0:376:30d7:781c with SMTP id 37-20020a631065000000b0037630d7781cmr23144210pgq.35.1647324167048;
        Mon, 14 Mar 2022 23:02:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1TXJs4z7pkRwoBbNJ/EWCG6B57vRYbERTtao++GL9k5qULPi4/tGdG73QHdAZUX4Hp/SF2A==
X-Received: by 2002:a63:1065:0:b0:376:30d7:781c with SMTP id 37-20020a631065000000b0037630d7781cmr23144181pgq.35.1647324166665;
        Mon, 14 Mar 2022 23:02:46 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t8-20020a056a00138800b004f724e9fb3esm23056223pfg.89.2022.03.14.23.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 23:02:46 -0700 (PDT)
Subject: Re: [PATCH] ceph: send the fscrypt_auth to MDS via request
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220315054539.276668-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <90b6490e-0673-5663-052c-bb0bd68f70fb@redhat.com>
Date:   Tue, 15 Mar 2022 14:02:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220315054539.276668-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
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


On 3/15/22 1:45 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> Currently when creating new files or directories the kclient will
> create a new inode and fill the fscrypt auth locally, without sending
> it to MDS via requests. Then the MDS reply with it to empty too.
> And the kclient will update it later together with the cap update
> requests.
>
> It's buggy if just after the create requests succeeds but the kclient
> crash and reboot, then in MDS side the fscrypt_auth will keep empty.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/dir.c  | 37 +++++++++++++++++++++++++++++++++++--
>   fs/ceph/file.c | 15 ++++++++++++++-
>   2 files changed, 49 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 123e3b9c8161..a63a4923e33b 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -926,8 +926,20 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
>   		goto out_req;
>   	}
>   
> -	if (S_ISREG(mode) && IS_ENCRYPTED(dir))
> -		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> +	if (IS_ENCRYPTED(dir)) {
> +		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
> +
> +		if (S_ISREG(mode))
> +			set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> +
> +		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
> +					      ci->fscrypt_auth_len,
> +					      GFP_KERNEL);
> +		if (!req->r_fscrypt_auth) {
> +			err = -ENOMEM;
> +			goto out_req;
> +		}
> +	}

Need to put this under the CONFIG_FS_ENCRYPTION macro, will send a v2 to 
fix it.

- Xiubo

>   
>   	req->r_dentry = dget(dentry);
>   	req->r_num_caps = 2;
> @@ -1030,9 +1042,19 @@ static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
>   	ihold(dir);
>   
>   	if (IS_ENCRYPTED(req->r_new_inode)) {
> +		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
> +
>   		err = prep_encrypted_symlink_target(req, dest);
>   		if (err)
>   			goto out_req;
> +
> +		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
> +					      ci->fscrypt_auth_len,
> +					      GFP_KERNEL);
> +		if (!req->r_fscrypt_auth) {
> +			err = -ENOMEM;
> +			goto out_req;
> +		}
>   	} else {
>   		req->r_path2 = kstrdup(dest, GFP_KERNEL);
>   		if (!req->r_path2) {
> @@ -1112,6 +1134,17 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>   		goto out_req;
>   	}
>   
> +	if (IS_ENCRYPTED(dir)) {
> +		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
> +
> +		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
> +					      ci->fscrypt_auth_len,
> +					      GFP_KERNEL);
> +		if (!req->r_fscrypt_auth) {
> +			err = -ENOMEM;
> +			goto out_req;
> +		}
> +	}
>   	req->r_dentry = dget(dentry);
>   	req->r_num_caps = 2;
>   	req->r_parent = dir;
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 61ffbda5b934..55db91be4d7b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -771,9 +771,22 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	req->r_args.open.mask = cpu_to_le32(mask);
>   	req->r_parent = dir;
>   	ihold(dir);
> -	if (IS_ENCRYPTED(dir))
> +	if (IS_ENCRYPTED(dir)) {
>   		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>   
> +		if (new_inode) {
> +			struct ceph_inode_info *ci = ceph_inode(new_inode);
> +
> +			req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
> +						      ci->fscrypt_auth_len,
> +						      GFP_KERNEL);
> +			if (!req->r_fscrypt_auth) {
> +				err = -ENOMEM;
> +				goto out_req;
> +			}
> +		}
> +	}
> +
>   	if (flags & O_CREAT) {
>   		struct ceph_file_layout lo;
>   

