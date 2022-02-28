Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1564C63B9
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Feb 2022 08:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiB1HT3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Feb 2022 02:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbiB1HT2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Feb 2022 02:19:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E41350B2A
        for <ceph-devel@vger.kernel.org>; Sun, 27 Feb 2022 23:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646032727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vFm8p5IXIKz0bVgLVa7cMEQL8DbYdhtcINVwekuTi74=;
        b=C1F7Ho3SvZlwCzU9eLkIiSIpWq0c5soVjpJqiUFv0nakpM6tq0j4nFfGtpXMaGsQHe9gkM
        aawv8g2fvnP3z4+iiFJ+UToqsZYLdGDug3EmNVKQuLbHfMp5Hd77tVSfhzqAr+mAcolQSQ
        dV21c1WDyHIzUHyrbKtZy0t7tL4DxWQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-WgDBwcNCNtS9jRJfzMcGPQ-1; Mon, 28 Feb 2022 02:18:43 -0500
X-MC-Unique: WgDBwcNCNtS9jRJfzMcGPQ-1
Received: by mail-pg1-f198.google.com with SMTP id x4-20020a63b344000000b00375662f4a7bso6109558pgt.15
        for <ceph-devel@vger.kernel.org>; Sun, 27 Feb 2022 23:18:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vFm8p5IXIKz0bVgLVa7cMEQL8DbYdhtcINVwekuTi74=;
        b=jn+RPppIT3by0e7QI7OfycOjrq/BzpnjFSlVt8UxZdt3ir0VfjjX0sVEs2g029O8nD
         Uwi5aF7X5JvOhvxVLzRT1j/IQ2t+DdxT7KvVAbwazJKpZSr5t4V3jqwjblHSmcrGDBOt
         ENmcMtpt9qBhoHsYdZoZSRvTRJCZTPCeiVSj+eFemxSArXY4c1XYPDipEvh9KNxNkxT1
         JuXh4S8tr6JgmiGjfypYQD1dT8+wn2ci2uoEAFHTiDH8Iub0eNhs8z1TnA4p9LoOGhHz
         VjjVLXDBez+V0ohvNrnCgLLVoV0Pi7aA4D+vmVlLLGRqM8y9RInKpy8cQeennrZnLt/h
         4oxg==
X-Gm-Message-State: AOAM532DGIVlC2JUILzWxWkgA1ulLiaYF9+HVwh8o9lHi3RM11hd8ww8
        FhBXZs7IL9PzPQTmNBnEIlsY7Z7zozbrGeS7ne/WFUnF7s3jO+2Y8Aocu2luMBtZkFp3PqKmEDl
        Fg6weaTWywB2za5n/HGkq6e2wJlAnkc5e949p2DXsxUtdb8tsW4tvUcYA5J6BeqyO6CeR2tE=
X-Received: by 2002:a17:903:110d:b0:14d:ca16:2c7 with SMTP id n13-20020a170903110d00b0014dca1602c7mr19369731plh.68.1646032722473;
        Sun, 27 Feb 2022 23:18:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzx+AtO1nq5DIi6lnKTz0xN9FmQc4rSnAMxCuMYqS+jTnTSecFJKI87PJJnRNdjB+aat5tl+g==
X-Received: by 2002:a17:903:110d:b0:14d:ca16:2c7 with SMTP id n13-20020a170903110d00b0014dca1602c7mr19369716plh.68.1646032722154;
        Sun, 27 Feb 2022 23:18:42 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b22-20020a17090a10d600b001b8e6841ca5sm16086533pje.51.2022.02.27.23.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 23:18:41 -0800 (PST)
Subject: Re: [PATCH] ceph: increase the offset when fail to decode dentry
 names
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220228071442.48733-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f72452a2-4355-fb99-0e17-694425d8cc9a@redhat.com>
Date:   Mon, 28 Feb 2022 15:18:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220228071442.48733-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Forgot to mention, this patch is fixing a crash bug in 'wip-fscrypt' branch.

- Xiubo


On 2/28/22 3:14 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> ------------[ cut here ]------------
> kernel BUG at fs/ceph/dir.c:537!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 16 PID: 21641 Comm: ls Tainted: G            E     5.17.0-rc2+ #92
> Hardware name: Red Hat RHEV Hypervisor, BIOS 1.11.0-2.el7 04/01/2014
>
> The corresponding code in ceph_readdir() is:
>
> 	BUG_ON(rde->offset < ctx->pos);
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/dir.c   | 13 +++++++------
>   fs/ceph/inode.c |  3 ++-
>   2 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index a449f4a07c07..f28eb568e0e2 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -534,6 +534,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   					    .ctext_len	= rde->altname_len };
>   		u32 olen = oname.len;
>   
> +		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> +		if (err) {
> +			pr_warn("Unable to decode %.*s. Skipping it.\n", rde->name_len, rde->name);
> +			ctx->pos++;
> +			continue;
> +		}
> +
>   		BUG_ON(rde->offset < ctx->pos);
>   		BUG_ON(!rde->inode.in);
>   
> @@ -542,12 +549,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   		     i, rinfo->dir_nr, ctx->pos,
>   		     rde->name_len, rde->name, &rde->inode.in);
>   
> -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> -		if (err) {
> -			dout("Unable to decode %.*s. Skipping it.\n", rde->name_len, rde->name);
> -			continue;
> -		}
> -
>   		if (!dir_emit(ctx, oname.name, oname.len,
>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 8b0832271fdf..b1552e6a6f0e 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1898,7 +1898,8 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   
>   		err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
>   		if (err) {
> -			dout("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
> +			fpos_offset++;
> +			pr_warn("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
>   			continue;
>   		}
>   

