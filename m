Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9C762BF6C
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Nov 2022 14:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiKPN22 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Nov 2022 08:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238678AbiKPN1q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Nov 2022 08:27:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B15CDAD
        for <ceph-devel@vger.kernel.org>; Wed, 16 Nov 2022 05:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668605209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Crhfvdh/6hwfHAYMQFKTfoyNarKH4ZK6jMrps7b+KPM=;
        b=Av66lq/ovsGBTDLwCs/KhFbXI4zmdV3/pqBt5eDbGgzXV4m8solKmaBUBXotu9Ckfwzz0b
        UpP3HRpER3RbNnP2V8wglFMsjFEFCTtGxTzmOgpiv6vfeurrcebt05HYvr2+vhgYHkDLFa
        9UXPcINiXEuCS96JPFf5phFEZh9zn2k=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-I9hRQQKNPyi0YyfpPl4g2w-1; Wed, 16 Nov 2022 08:26:48 -0500
X-MC-Unique: I9hRQQKNPyi0YyfpPl4g2w-1
Received: by mail-pl1-f199.google.com with SMTP id n12-20020a170902e54c00b00188515e81a6so13960188plf.23
        for <ceph-devel@vger.kernel.org>; Wed, 16 Nov 2022 05:26:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Crhfvdh/6hwfHAYMQFKTfoyNarKH4ZK6jMrps7b+KPM=;
        b=Yg9H/mFhu2HEN3Bs8EG2IADv4MQRgeOS/JqAHaZVwbORSMDIub/oeRvA7AX1uyLE+p
         L35mtNuKH2VjHHzXbeDDTlHRbBSO8C0ylokUuFynanSjQOqBLIOovzZdyWQYDMbOz4xl
         Kx1hDVhou/KagaqfzHsj+LXmu7IAHB9nBoVOHrwR7T7lDiZOKEhB8xi+/nCWgPvUkmJx
         gPgE7Vjh5yF0nUxwEgZO5gFkUTeG0c9XM4N0q4mOkRR+xnOB5c74NrPM2FCj5xb02gO2
         y9O17jGjlXxduR/YJglCYduqIxIA7gz+XJAufq2XTAraAOx4LG4hyRvlcFQf16u+vOi0
         lAGQ==
X-Gm-Message-State: ANoB5plsOCtzfqwq89GgyRifgH3RfAK0QFncbv6ZX4QCNGOL4oEH/9jT
        //NSOrw73NfjZD2z9W9ZERXFjp6OCWLZZ+5LE8BM5PCAF32rphoPHErBHUswfHO87VUd9CGFAbv
        jW5oDZSBoZTZJlVW4PKKtdQ==
X-Received: by 2002:a17:90a:df03:b0:213:1a9f:8d77 with SMTP id gp3-20020a17090adf0300b002131a9f8d77mr3669597pjb.102.1668605207232;
        Wed, 16 Nov 2022 05:26:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7QXEEGdnuKOERdbmDwc3Y5g2vioSr+xkjZ0IMpKUe3ir/xKyLgTu3dg5u0UrvgmK0rkh171w==
X-Received: by 2002:a17:90a:df03:b0:213:1a9f:8d77 with SMTP id gp3-20020a17090adf0300b002131a9f8d77mr3669582pjb.102.1668605206964;
        Wed, 16 Nov 2022 05:26:46 -0800 (PST)
Received: from [10.72.12.148] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p188-20020a6342c5000000b0047685ed724dsm5753795pga.40.2022.11.16.05.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 05:26:46 -0800 (PST)
Subject: Re: [PATCH] filelock: new helper: vfs_inode_has_locks
To:     Jeff Layton <jlayton@kernel.org>, linux-fsdevel@vger.kernel.org
Cc:     ceph-devel@vger.kernel.org, chuck.lever@oracle.com,
        Christoph Hellwig <hch@infradead.org>
References: <20221116112658.8793-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <141e657d-4182-f945-4827-a931e3b0e769@redhat.com>
Date:   Wed, 16 Nov 2022 21:26:42 +0800
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


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

Reviewed-by: Xiubo Li <xiubli@redhat.com>

I will send the V3 patch series to fix the ceph's filelock bug basing on 
this.

Thanks Jeff.

- Xiubo

