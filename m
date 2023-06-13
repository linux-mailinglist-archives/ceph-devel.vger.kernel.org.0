Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5807E72D6A8
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 02:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbjFMA6l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jun 2023 20:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFMA6k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Jun 2023 20:58:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C256810DF
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 17:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686617871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1L20iVMOJ5OlmC71owTF4ic5jGHlw9v9d63Hi7ea1qw=;
        b=KXWldei9Eo5OqtC4LI6HJXHVCowXzkrOrIzD9AQlzIc5AREImZYgqogIpGyXBjyMmmOm7D
        hA9UxW772zskqaW3ocGH3Korc9+ZW9tS47K+lO4J4YQc31fzgCNktob10+yTmP+qy+4hSp
        gB9Ihxbk8eEob2EqiOB7KS1pfb2OcCE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-3C_v7ukyNNSuN5YYMxcdnw-1; Mon, 12 Jun 2023 20:57:49 -0400
X-MC-Unique: 3C_v7ukyNNSuN5YYMxcdnw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-25682c04fd7so2109471a91.2
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 17:57:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686617868; x=1689209868;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1L20iVMOJ5OlmC71owTF4ic5jGHlw9v9d63Hi7ea1qw=;
        b=HXVw1Dby2tqYZUzIcg3GZqi/SfbVShQhvoEGYK4DohAhiGEYKUXeGtyM3MAJWs16mC
         6dgMa5fgZ9XpzSJ4hjmobaCUpAXGbtSy+qTrpi0kLO0hsXeyDSD+2YQnlnhVcQW0T413
         1opFL/Qd9dWWu/JZ3M+OAWMj6HRNXWc5/rwD0FYjuZYB1/kYTt51MYX/wKp363wm79/7
         vFRAR2l4iWDouqaknMTNAqGoCuJpuuXoKVzvvywUUjHzUK5QkBt1Enm57YX5FBLbIap4
         NqyzBGMkGtXSdN9auRWUp7dH2jOGF1BYWMoIM1+0X1/WrXk9xQJWF1/QGMgOwDZ61L6W
         x2Og==
X-Gm-Message-State: AC+VfDwcZjfuPftZZcxE+PHHla8VR6TsVC6mffSky5qG02Ae038bhORj
        8dCmqRNAobqWXviUE/oL22OwKgmEqaCPcKBjn7BdjGaN0uKgw4FaxByL+wlNlEpiR5RkCW95+63
        Qw589zsGrl0ERXCEZIWOXjg==
X-Received: by 2002:a17:90a:ad82:b0:25b:f413:9a63 with SMTP id s2-20020a17090aad8200b0025bf4139a63mr2780090pjq.13.1686617867972;
        Mon, 12 Jun 2023 17:57:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4/ww7kuMV5yQimljej5pmsz7w0zJm6stTOxQPwN+MaQNvtumDEnVndvo0mwupjLSR2SVcExA==
X-Received: by 2002:a17:90a:ad82:b0:25b:f413:9a63 with SMTP id s2-20020a17090aad8200b0025bf4139a63mr2780082pjq.13.1686617867665;
        Mon, 12 Jun 2023 17:57:47 -0700 (PDT)
Received: from [10.72.12.125] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b00198d7b52eefsm8792953plh.257.2023.06.12.17.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 17:57:47 -0700 (PDT)
Message-ID: <099cc669-11b9-e5f1-e370-599679e87806@redhat.com>
Date:   Tue, 13 Jun 2023 08:57:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] ceph: set FMODE_CAN_ODIRECT instead of a dummy direct_IO
 method
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, idryomov@gmail.com,
        jlayton@kernel.org, ceph-devel@vger.kernel.org
References: <20230612053537.585525-1-hch@lst.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230612053537.585525-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/12/23 13:35, Christoph Hellwig wrote:
> Since commit a2ad63daa88b ("VFS: add FMODE_CAN_ODIRECT file flag") file
> systems can just set the FMODE_CAN_ODIRECT flag at open time instead of
> wiring up a dummy direct_IO method to indicate support for direct I/O.
> Do that for ceph so that noop_direct_IO can eventually be removed.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/ceph/addr.c | 1 -
>   fs/ceph/file.c | 2 ++
>   2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 6bb251a4d613eb..19c0f42540b600 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1401,7 +1401,6 @@ const struct address_space_operations ceph_aops = {
>   	.dirty_folio = ceph_dirty_folio,
>   	.invalidate_folio = ceph_invalidate_folio,
>   	.release_folio = ceph_release_folio,
> -	.direct_IO = noop_direct_IO,
>   };
>   
>   static void ceph_block_sigs(sigset_t *oldset)
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index f4d8bf7dec88a8..314c5d5971bf4a 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -368,6 +368,8 @@ int ceph_open(struct inode *inode, struct file *file)
>   	flags = file->f_flags & ~(O_CREAT|O_EXCL);
>   	if (S_ISDIR(inode->i_mode))
>   		flags = O_DIRECTORY;  /* mds likes to know */
> +	if (S_ISREG(inode->i_mode))
> +		file->f_mode |= FMODE_CAN_ODIRECT;
>   

Shouldn't we do the same in 'ceph_atomic_open()' too ?

Thanks

- Xiubo


>   	dout("open inode %p ino %llx.%llx file %p flags %d (%d)\n", inode,
>   	     ceph_vinop(inode), file, flags, file->f_flags);

