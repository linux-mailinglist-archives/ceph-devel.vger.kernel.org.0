Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153C063723C
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Nov 2022 07:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiKXGGg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 24 Nov 2022 01:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiKXGGc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 24 Nov 2022 01:06:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DC762C2
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 22:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669269935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ychXybStwuiwH+16Z3KvFyXKihd+CKffz1NArMrRPUc=;
        b=Iaifx3EJWmbs9xwFVwAspaHx9V3V3vLPxU8H7E6Mwst7YBeuqYHkz+ozExz9G11i40kukN
        6B1e73PkVVnzxniCbhgLPYhli08hRa7Cc2Cv03RLhnnuB8u42ErEvHQMqwAzFaFEOQa3IE
        l0+Womj8uMays9NfEdM9timbGYP1Psc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-547-GPbb6DILO6msvXy-QSew2g-1; Thu, 24 Nov 2022 01:05:33 -0500
X-MC-Unique: GPbb6DILO6msvXy-QSew2g-1
Received: by mail-pf1-f199.google.com with SMTP id v16-20020a62a510000000b005745a58c197so610507pfm.23
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 22:05:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ychXybStwuiwH+16Z3KvFyXKihd+CKffz1NArMrRPUc=;
        b=5smIFF3PYUOBrTOCqWSxW0qD9j5n94LvsiNsx3Txjt0ld2b5uGd2JynC5WvQ7IDfB0
         hoZbOIGj98a8vf5GMnQn94DlVN74GBaofUPgR3tOd0kybehuDXB5ouwdtFT07oLdaEtG
         jXGqGRvSiuBk9sWZVi/WlKlWR2DCiRaVdAmCrB7ZJGjG+XN8y4hiVipFT5URbicT/KjG
         fNWRrcDlqJRlxuJH9Cdu4DUByUf5KIzPSagaRnpByIpZX3xlVG2wPC1l0gtTYMoHsfGl
         8aF3X/Sgb0ppSRxkt2XAhCvhFPw9LNz5uXiQ58hE4LtLp6NitYXoeXv/G/gxsXIigOb4
         zkDg==
X-Gm-Message-State: ANoB5pkwNhPSwFX/hi1C6NaI/QV+rb+JUW5ayC/LaMc6GI9AijRQyfoK
        ngTuQuf8pYOY/FQQ3asR485zf6XyAWr1XaDMrIiiMROM3wn0pvYICrcEamOHPBbLDa+8ny9nQW6
        3eLI2sxA4TwtA95yCGvvGSw==
X-Received: by 2002:a17:90b:24f:b0:218:96da:b09a with SMTP id fz15-20020a17090b024f00b0021896dab09amr18790401pjb.118.1669269932052;
        Wed, 23 Nov 2022 22:05:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6mExkEEIZbXLvMKSw/fR/Qp6rTtuXStnr/YYjeP9fnuG06v+y4gcj/MT1aNcPKBukmgEjvnw==
X-Received: by 2002:a17:90b:24f:b0:218:96da:b09a with SMTP id fz15-20020a17090b024f00b0021896dab09amr18790380pjb.118.1669269931786;
        Wed, 23 Nov 2022 22:05:31 -0800 (PST)
Received: from [10.72.12.138] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p16-20020a1709027ed000b0018685aaf41dsm296836plb.18.2022.11.23.22.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 22:05:31 -0800 (PST)
Subject: Re: [PATCH] filelock: new helper: vfs_inode_has_locks
To:     Jeff Layton <jlayton@kernel.org>, linux-fsdevel@vger.kernel.org
Cc:     ceph-devel@vger.kernel.org, chuck.lever@oracle.com,
        Christoph Hellwig <hch@infradead.org>
References: <20221116112658.8793-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <18904f74-8d73-752e-bfdc-c18483493b9a@redhat.com>
Date:   Thu, 24 Nov 2022 14:05:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221116112658.8793-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff,

I have tested this and it worked very well for ceph.

Tested-by: Xiubo Li <xiubli@redhat.com>

Thanks!

- Xiubo

On 16/11/2022 19:26, Jeff Layton wrote:
> Ceph has a need to know whether a particular inode has any locks set on
> it. It's currently tracking that by a num_locks field in its
> filp->private_data, but that's problematic as it tries to decrement this
> field when releasing locks and that can race with the file being torn
> down.
>
> Add a new vfs_inode_has_locks helper that just returns whether any locks
> are currently held on the inode.
>
> Cc: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/locks.c         | 23 +++++++++++++++++++++++
>   include/linux/fs.h |  1 +
>   2 files changed, 24 insertions(+)
>
> diff --git a/fs/locks.c b/fs/locks.c
> index 5876c8ff0edc..9ccf89b6c95d 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -2672,6 +2672,29 @@ int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
>   }
>   EXPORT_SYMBOL_GPL(vfs_cancel_lock);
>   
> +/**
> + * vfs_inode_has_locks - are any file locks held on @inode?
> + * @inode: inode to check for locks
> + *
> + * Return true if there are any FL_POSIX or FL_FLOCK locks currently
> + * set on @inode.
> + */
> +bool vfs_inode_has_locks(struct inode *inode)
> +{
> +	struct file_lock_context *ctx;
> +	bool ret;
> +
> +	ctx = smp_load_acquire(&inode->i_flctx);
> +	if (!ctx)
> +		return false;
> +
> +	spin_lock(&ctx->flc_lock);
> +	ret = !list_empty(&ctx->flc_posix) || !list_empty(&ctx->flc_flock);
> +	spin_unlock(&ctx->flc_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfs_inode_has_locks);
> +
>   #ifdef CONFIG_PROC_FS
>   #include <linux/proc_fs.h>
>   #include <linux/seq_file.h>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e654435f1651..d6cb42b7e91c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1170,6 +1170,7 @@ extern int locks_delete_block(struct file_lock *);
>   extern int vfs_test_lock(struct file *, struct file_lock *);
>   extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
>   extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
> +bool vfs_inode_has_locks(struct inode *inode);
>   extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl);
>   extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
>   extern void lease_get_mtime(struct inode *, struct timespec64 *time);

