Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E2A72D6B2
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 03:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbjFMBHD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jun 2023 21:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbjFMBHC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Jun 2023 21:07:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFC410C6
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 18:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686618374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b+7RXAK5Aza+QrckE5Cl8TK12tN4Z6vUkI02RT6l6XY=;
        b=QcrmWDtTxnxu26PycJ4pPtwUe7/Isi0hSOySqQmQ1VuAYk8qmu9E4JQafrrrSVZ5W+yBLG
        iINrTLloHeGGYtImviUUc9RrbtHDVThgUoReSjcQA1z3haM7Xq0/PpSMKBFkCCVWqOBTMg
        lCLD5cZRm4mXAl41fvT+dHYNm1SfX4A=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226--IaNoegbPeyjmGVtjDWa4w-1; Mon, 12 Jun 2023 21:06:13 -0400
X-MC-Unique: -IaNoegbPeyjmGVtjDWa4w-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b3d2f59863so12762415ad.0
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 18:06:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686618372; x=1689210372;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+7RXAK5Aza+QrckE5Cl8TK12tN4Z6vUkI02RT6l6XY=;
        b=aNnmebeEVbSo/aAoQTfjeR3cjmQBdQb0rcJJNViw0Jpd5cOMWOdg59gZAO9Wer0UaL
         +FJ3t0KNIK36qoPDVpOlPkxIqPnAVSR9shNC3Ne/QN2Jp2OWzYvynsODHMMKuL5AU2Xl
         zY4x8cWMAeOSUKNCpmvaI2ALQ4gYbtrB/LGZzQL0M+mVPkLhHodSp0YA6TwNwHRk+xex
         uNNy3ShewH0ZNiocNfNKmlj9RmqmBurG5hIyn6szTOCs9G2P1uxza67SaS/Naw0cIAhE
         t5iD4LPf5bf5EwfiS8abxrvMeDMeqErHfOQ9qk/gh4KnCWaOk8KNF5QXfDLX/DO1sJ18
         nDVw==
X-Gm-Message-State: AC+VfDz0avqwXLIJAkvKaDgMthMbZdodiYtogv29Ai7LTKxmYuMYosAi
        1Vrk+INAcA0wtHXXXMN8IukCKB5y1d30E1D9AtaCSfbS6nJIuHNWI4lr8s1cSuKP3SSsB8/GlS6
        KU1tWvwKZ6utpeUZnRHK9f+dU+UV01yGg
X-Received: by 2002:a17:902:9a4b:b0:1b3:c98c:329d with SMTP id x11-20020a1709029a4b00b001b3c98c329dmr4918160plv.63.1686618371869;
        Mon, 12 Jun 2023 18:06:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7vkyockk1iFIEGXvRivJJYeyvqT9+DsxN3eYCtQVSwrwLG6gyTaVNmPxTZxEZsj58a3zH+sA==
X-Received: by 2002:a17:902:9a4b:b0:1b3:c98c:329d with SMTP id x11-20020a1709029a4b00b001b3c98c329dmr4918153plv.63.1686618371586;
        Mon, 12 Jun 2023 18:06:11 -0700 (PDT)
Received: from [10.72.12.125] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id iw6-20020a170903044600b001a980a23802sm3359894plb.111.2023.06.12.18.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 18:06:11 -0700 (PDT)
Message-ID: <366e91fa-53b9-008d-8aea-7498d452b234@redhat.com>
Date:   Tue, 13 Jun 2023 09:06:05 +0800
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

BTW, the commit a2ad63daa88b ("VFS: add FMODE_CAN_ODIRECT file flag") 
doesn't check the S_ISREG, and I couldn't see this commit and NFS 
confine it to regular files, is that okay ?

Thanks

- Xiubo


> +		file->f_mode |= FMODE_CAN_ODIRECT;
>   
>   	dout("open inode %p ino %llx.%llx file %p flags %d (%d)\n", inode,
>   	     ceph_vinop(inode), file, flags, file->f_flags);

