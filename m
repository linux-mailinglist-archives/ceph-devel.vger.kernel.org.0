Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF574509ABD
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 10:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386712AbiDUIgg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Apr 2022 04:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386705AbiDUIge (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Apr 2022 04:36:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AF121DA5C
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 01:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650530024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9EtZbU/zeNwz0vdgFqcktI08evpHQJl4ymm0XDjMo4=;
        b=EJI02gtZXlNEYEVtphJf2UezNjvYOccCqc5gQqvjZ1Phf1dfZk/iYIGRLl79PDY4XU/A8t
        d7ownxJJAsLg4OIHugneYOG8WjXQOYGumWXGC/xNIS/P4uGu8DuvrfYVX0eTSYWZ+C8TxZ
        mWndQibuJUrqv73iZm07b88ChJ+88pc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-IoubFJQRPtG9Xe0x2vbI8w-1; Thu, 21 Apr 2022 04:33:43 -0400
X-MC-Unique: IoubFJQRPtG9Xe0x2vbI8w-1
Received: by mail-pj1-f72.google.com with SMTP id m8-20020a17090aab0800b001cb1320ef6eso4696483pjq.3
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 01:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=y9EtZbU/zeNwz0vdgFqcktI08evpHQJl4ymm0XDjMo4=;
        b=tDE+mNqiNLBDmtOjwc5T0aSsitX2ftsIpOsM+1QzIfVUEiDrJqS3U/suWHj8vkmJFl
         B2OfdTfVqYX0erwiopBNEJKT/FnRcp09RKF8I0MUL3S4OvrSYtBvg2dO1ZCyP8sts06G
         BSt4fpZPsXVwTRGNxfvByAlaVTaDKwZkaRWHRl5z+O4OpPHywhvS6vIkATDj/ffBi8cK
         ePHt95PAmiAdYnUrwTOAyuy2byxZ/uKgITEDhKcENY9qsEafyLxFVSL6rD3CwWur+V39
         fDoDRl0P+NpyIL12wMuAuOxfIsEGHosgvtvs4f7c7WZw40WSZ+UJ19diOXJ/onva9ej+
         +fFg==
X-Gm-Message-State: AOAM53250g1uqozwXwlbjfSlrRe4u+/LsopG+3IoqCED3UmQK/XrbuK3
        B0crUhI0VBCKkm3bohjLl6eol9Yk28elPrbXH0n5IDJA/HpjAlk7HioS24w5RV0cYx3Nfalb9Y9
        QQmNkoNO63ghUfbBUNcFq3g==
X-Received: by 2002:a63:af06:0:b0:378:3582:a49f with SMTP id w6-20020a63af06000000b003783582a49fmr22980151pge.125.1650530021737;
        Thu, 21 Apr 2022 01:33:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlQ/pHak+DU47e1bI6MFQIJnaNDBKbiYPCxj5E4Dvg9q28NJmjXE1/AjlvslGkCfeU7MNbEQ==
X-Received: by 2002:a63:af06:0:b0:378:3582:a49f with SMTP id w6-20020a63af06000000b003783582a49fmr22980143pge.125.1650530021548;
        Thu, 21 Apr 2022 01:33:41 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 189-20020a6217c6000000b0050aca6473e0sm5269198pfx.192.2022.04.21.01.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 01:33:40 -0700 (PDT)
Subject: Re: [PATCH v5 4/4] ceph: Remove S_ISGID clear code in
 ceph_finish_async_create
To:     Yang Xu <xuyang2018.jy@fujitsu.com>, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, david@fromorbit.com, djwong@kernel.org,
        brauner@kernel.org, willy@infradead.org, jlayton@kernel.org
References: <1650527658-2218-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <1650527658-2218-4-git-send-email-xuyang2018.jy@fujitsu.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <71fe92fc-9c91-1070-89f7-27dfba49acfe@redhat.com>
Date:   Thu, 21 Apr 2022 16:33:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1650527658-2218-4-git-send-email-xuyang2018.jy@fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/21/22 3:54 PM, Yang Xu wrote:
> Since vfs has stripped S_ISGID in the previous patch, the calltrace
> as below:
>
> vfs:	lookup_open
> 	...
> 	  if (open_flag & O_CREAT) {
>                  if (open_flag & O_EXCL)
>                          open_flag &= ~O_TRUNC;
>                  mode = prepare_mode(mnt_userns, dir->d_inode, mode);
> 	...
> 	   dir_inode->i_op->atomic_open
>
> ceph:	ceph_atomic_open
> 	...
> 	      if (flags & O_CREAT)
>              		ceph_finish_async_create
>
> We have stripped sgid in prepare_mode, so remove this useless clear
> code directly.
>
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
> ---
>   fs/ceph/file.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 6c9e837aa1d3..8e3b99853333 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -651,10 +651,6 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>   		/* Directories always inherit the setgid bit. */
>   		if (S_ISDIR(mode))
>   			mode |= S_ISGID;
> -		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
> -			 !in_group_p(dir->i_gid) &&
> -			 !capable_wrt_inode_uidgid(&init_user_ns, dir, CAP_FSETID))
> -			mode &= ~S_ISGID;
>   	} else {
>   		in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
>   	}

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


