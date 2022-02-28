Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B1A4C655D
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Feb 2022 10:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiB1JF3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Feb 2022 04:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiB1JFY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Feb 2022 04:05:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC83360069
        for <ceph-devel@vger.kernel.org>; Mon, 28 Feb 2022 01:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646039055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+mp1Gsc68V8Jg+6zptzQKSeXDN79CiroH1hEmeErD0=;
        b=S1aYBH8mYNHIZVIfnA7TIABO5LJyDsENvi73Pg0hqWvnuTmCwsOgfdr5eXr7WovZGQM7N8
        kXTsyOtoR0b9ncvjkitulBffetJDCmh049yXF4NQeLhd3VTMP1N/u5ratFYTtVnOzCZWuu
        ZzgDnYQL5argF0Oq6mybDDvwWpfNelA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-12i9MWBtNmSmcwUUOZZ7nQ-1; Mon, 28 Feb 2022 04:04:14 -0500
X-MC-Unique: 12i9MWBtNmSmcwUUOZZ7nQ-1
Received: by mail-pj1-f72.google.com with SMTP id c15-20020a17090a674f00b001bc9019ce17so8447455pjm.8
        for <ceph-devel@vger.kernel.org>; Mon, 28 Feb 2022 01:04:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=i+mp1Gsc68V8Jg+6zptzQKSeXDN79CiroH1hEmeErD0=;
        b=pTrCrbhJ/bbAlXmrpSw69zZoXHBiKPmJiie+0P/fCsVmNSVb0weMKWqlple3Slw+Qv
         fZKi4wTAF60OhZb9fU1ZTlDFYR2L832sjtRsWhlmtrVoqGftGiVxswasHOUFKbEQGr9e
         FGV30pBQ6x2szajflWQThSN0GK61HgnX5HgLeCMTRdo9RsyDYR4UAAZ2p72Bx6C5EFdO
         pBjCvvQbPiFCz6RX5D9B8o0ZVpyuYjUXMVobecLasRWGZfEuU4Qvdarvs+RVPzAbpN3d
         DKVUj12KTDNUBe+zpfMDEgatFIvlVE8HcRpNzIV7csCDbst1SMorQLj5DVK1axRK21ws
         IYOA==
X-Gm-Message-State: AOAM530IZfk0MuEGQ1uonUgqiVy3yQVH3yIAdfsyUHNBWqZZ90K1GdI1
        IwDr1j2RSqlm/dRl7mLV3sOwFKoSDUVWmPbFILf7xqfVek6x2TsOM8QbeFRvvfh7hItVpfbvz4C
        GJ8J5yEjmsjTF/5QMorgxRcyR33wbn1mDgcROkCiV++lZ2uGns8Rl77l57U/6aWDywaVMvck=
X-Received: by 2002:a17:902:ce8a:b0:14f:fd0e:e4a4 with SMTP id f10-20020a170902ce8a00b0014ffd0ee4a4mr19812962plg.47.1646039053302;
        Mon, 28 Feb 2022 01:04:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz3ieaPo8l+pWtoVeF3WBJ9jEM4Jt7ZtCn3bLlsBuTAPLpwxASPmMKZw7X+nW3dhz8/BV0EAw==
X-Received: by 2002:a17:902:ce8a:b0:14f:fd0e:e4a4 with SMTP id f10-20020a170902ce8a00b0014ffd0ee4a4mr19812928plg.47.1646039052914;
        Mon, 28 Feb 2022 01:04:12 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id on18-20020a17090b1d1200b001b9cfbfbf00sm9628551pjb.40.2022.02.28.01.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 01:04:12 -0800 (PST)
Subject: Re: [PATCH v2] ceph: fail the request when failing to decode dentry
 names
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220228090239.159467-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0ab61353-50cc-314e-9710-9dced59e957a@redhat.com>
Date:   Mon, 28 Feb 2022 17:04:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220228090239.159467-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Tag as V2.


On 2/28/22 5:02 PM, xiubli@redhat.com wrote:
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
>
> V2:
> - fail the request instead, because it's hard to handle the
>    corresponding code in ceph_readdir(). At the same time we
>    should propagate the error to user space.
>
>
>
>   fs/ceph/dir.c        | 13 +++++++------
>   fs/ceph/inode.c      |  5 +++--
>   fs/ceph/mds_client.c |  2 +-
>   3 files changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index a449f4a07c07..6be0c1f793c2 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -534,6 +534,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   					    .ctext_len	= rde->altname_len };
>   		u32 olen = oname.len;
>   
> +		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> +		if (err) {
> +			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> +			       rde->name_len, rde->name, err);
> +			goto out;
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
> index 8b0832271fdf..2bc2f02b84e8 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1898,8 +1898,9 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   
>   		err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
>   		if (err) {
> -			dout("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
> -			continue;
> +			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> +			       rde->name_len, rde->name, err);
> +			goto out;
>   		}
>   
>   		dname.name = oname.name;
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 914a6e68bb56..94b4c6508044 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3474,7 +3474,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>   	if (err == 0) {
>   		if (result == 0 && (req->r_op == CEPH_MDS_OP_READDIR ||
>   				    req->r_op == CEPH_MDS_OP_LSSNAP))
> -			ceph_readdir_prepopulate(req, req->r_session);
> +			err = ceph_readdir_prepopulate(req, req->r_session);
>   	}
>   	current->journal_info = NULL;
>   	mutex_unlock(&req->r_fill_mutex);

