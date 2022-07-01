Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE4F562849
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Jul 2022 03:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiGABbz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jun 2022 21:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiGABby (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jun 2022 21:31:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22EAB41635
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jun 2022 18:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656639112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cITqGGsnkP2NfyMbjeasIEraQRNT1tLAJaQCxIcDUlc=;
        b=OD6IYhYPsT92Nq1KdJeQiiMTth8ppi/s+IlnqbkrpI6TFFNukvwjpKYmCBJgG3SF/ln7HR
        nPdXWwtW5OkjsUp7LPlaBjIDvPmolLfXBjtW/z0RrSFlGCI4koTS03KoWOxyaOcoIUnmjD
        x1duvpLMZWgZukNK3zSJe3aymorxZI8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-Qu67AxZSPbWuo5dliySHVA-1; Thu, 30 Jun 2022 21:31:51 -0400
X-MC-Unique: Qu67AxZSPbWuo5dliySHVA-1
Received: by mail-pj1-f70.google.com with SMTP id em12-20020a17090b014c00b001ed493d4f0cso566468pjb.4
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jun 2022 18:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cITqGGsnkP2NfyMbjeasIEraQRNT1tLAJaQCxIcDUlc=;
        b=VD7jpt0Xr+1BLRncRUmuDRwhPdbTg+k63TuwvzuF/RbQACRMWWeLAr+/CdFBo0TXEd
         XLDaPtnCW00M12FsR+WP1TUS8M8urF6CmGj7mEVlleA67O5Z42P8rc0ZWx7ma23J+NAy
         NzSIU6yPrLRGUGOlhxjC2HWXm20pklGbnYQkjfls+vhR6wZ6l0LgMcjhmbMaLMqrQFlJ
         3589gxfaLxg7nEP5WWEDnNXsMrmd2ZDGC0JIf4Yn0DIj0vWe/1H0dDO8aaqZYEFfeU3Z
         +gbtAfSWA4wsjKXbWrMpkGeMRlmDCki0t+G7+uW3+n+quWDG0AnqemftCwBnTrsY07FO
         OAzg==
X-Gm-Message-State: AJIora+gpCLESonS5cK24CGRq4ste3lOjj5mrJ/QiuZDwTpACz+UjQkh
        aN6L5sGRSR8vj6LOc9fuVl1aD2DkfzVPV6sgKnktRn3DlrB35sHtXICTA7dcrnWWMu4vNEI2kFm
        VnEM1W8Bi8LWUGU7CoBjUIttjBX588C3eY30Yuy0hORnxxn5WkUNDZHV1BlTWN19VzVyD9nQ=
X-Received: by 2002:a63:cc52:0:b0:3fd:69ac:f3f with SMTP id q18-20020a63cc52000000b003fd69ac0f3fmr9748092pgi.423.1656639109524;
        Thu, 30 Jun 2022 18:31:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1szG8XvJUVCtmI7LVpZbtUZZB3egPuMJPZZ1ZIrFvGVeGKNsFYiXEXMFALcewjWNOoZpziN3g==
X-Received: by 2002:a63:cc52:0:b0:3fd:69ac:f3f with SMTP id q18-20020a63cc52000000b003fd69ac0f3fmr9748069pgi.423.1656639109078;
        Thu, 30 Jun 2022 18:31:49 -0700 (PDT)
Received: from [10.72.12.186] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902e94500b0016a0f4af4b1sm14037574pll.183.2022.06.30.18.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 18:31:48 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't truncate file in atomic_open
To:     Hu Weiwen <sehuww@mail.scut.edu.cn>, ceph-devel@vger.kernel.org
References: <20220630020010.17148-1-sehuww@mail.scut.edu.cn>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6f7d30bf-a83d-efe6-4cd0-53e4f56ef352@redhat.com>
Date:   Fri, 1 Jul 2022 09:31:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220630020010.17148-1-sehuww@mail.scut.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/30/22 10:00 AM, Hu Weiwen wrote:
> Clear O_TRUNC from the flags sent in the MDS create request.
>
> `atomic_open' is called before permission check. We should not do any
> modification to the file here. The caller will do the truncation
> afterward.
>
> Fixes: 124e68e74099 ("ceph: file operations")
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>   fs/ceph/file.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index da59e836a06e..a5ecb97b6f41 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -757,6 +757,11 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   		/* If it's not being looked up, it's negative */
>   		return -ENOENT;
>   	}
> +	/*
> +	 * Do not truncate the file, since atomic_open is called before the
> +	 * permission check. The caller will do the truncation afterward.
> +	 */
> +	flags &= ~O_TRUNC;
>   retry:
>   	/* do the open */
>   	req = prepare_open_request(dir->i_sb, flags, mode);
> @@ -807,9 +812,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	}
>
>   	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
> -	err = ceph_mdsc_do_request(mdsc,
> -				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
> -				   req);
> +	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
>   	if (err == -ENOENT) {
>   		dentry = ceph_handle_snapdir(req, dentry);
>   		if (IS_ERR(dentry)) {
> --
> 2.25.1
>
Merged into the testing branch. Thanks Weiwen!

-- Xiubo


