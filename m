Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F24E50889C
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Apr 2022 14:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352598AbiDTNAb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Apr 2022 09:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbiDTNA3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Apr 2022 09:00:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8CE33E5C6
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 05:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650459462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOYjob0bS2UizQ54TRhXtv1QCS1nCGd+WUsWcZn6UPk=;
        b=D7ukK4IKdHlikcbwQYW5gpT7S3uAEtQEk9Z+h2eLIS8GJljYdi9UQONl55JDiqVyZCbypv
        7e00LoonYT7f0rykRnrs4EBOYiCQ0vs7f8cEmzUr3+O56ApBqFjvPGqW33aSEELwrxRD2h
        UJXRVCqVfJdGtAf/uc9Gt3DG+IWAJ3E=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-2DhU5kFxNOSGeagcWOieEg-1; Wed, 20 Apr 2022 08:57:41 -0400
X-MC-Unique: 2DhU5kFxNOSGeagcWOieEg-1
Received: by mail-pg1-f197.google.com with SMTP id l14-20020a63f30e000000b0039cc65bdc47so1001179pgh.17
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 05:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vOYjob0bS2UizQ54TRhXtv1QCS1nCGd+WUsWcZn6UPk=;
        b=uyDH666G5o3vatBL9AXBqqlmONQnn5rNRSkf2gH6RocPnVv0ICa2pwS+6uq9fDRm+n
         KNMdh3wuU/HcL4P/oYTOiOjQNEG14uVC7ejxy95e2KoqsTHfZH5zENkhoKYrI05MAydZ
         NgkxiE/NDlWrZTxB/gzck/3AtlKCawdlT+Qgkr9FHtTGohJPDqzTs0L4/zVHRRHF6yTY
         r7d2Kv4Al2cfg8v6YnGtxLKgHNBgSYM4V8m6UPjLYrCsMw4mex7c6vTAnTQ62eLFyHwy
         tRJC7CNDTOugw69fI1WuPhW4M/cVmAdnlIPGxOz7+6+ZCK5dozkjXEyVrEa7fcwMg9UI
         frqQ==
X-Gm-Message-State: AOAM531VD9n436cTi7omtPk8LoMMs8g7Rq7ogmxYCkBxg/x0jtsHrFyR
        qGzrj7y+FZmVhJCqaEJ6EclEWBbvlly1eDqqDQFHhTdqikuq6o8JpFnzvqfWsFyRsKZrOu/EzjB
        cYjWWDoCktSk43raDL7WhmkcnbqMpllnw9814jON4ymScMH6quyvkYMJao6kuSrQE+C1X+m0=
X-Received: by 2002:a05:6a00:2992:b0:505:cf4b:baef with SMTP id cj18-20020a056a00299200b00505cf4bbaefmr22926059pfb.61.1650459460294;
        Wed, 20 Apr 2022 05:57:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6bwHZ+mV2sUm0w/A3To8fX+gordLWKUEI9KstmL3utTcrdJK/DZfyNJgkgdM8FojrGuaqkw==
X-Received: by 2002:a05:6a00:2992:b0:505:cf4b:baef with SMTP id cj18-20020a056a00299200b00505cf4bbaefmr22926034pfb.61.1650459459938;
        Wed, 20 Apr 2022 05:57:39 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b001b8efcf8e48sm22774866pjn.14.2022.04.20.05.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 05:57:39 -0700 (PDT)
Subject: Re: [RFC PATCH] ceph: disable updating the atime since cephfs won't
 maintain it
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220420052404.1144209-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0abb3f97-4f43-f2c9-ff34-1d350966508c@redhat.com>
Date:   Wed, 20 Apr 2022 20:57:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220420052404.1144209-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff, Venky

There has one example about the atime issue in 
https://tracker.ceph.com/issues/53844#note-2.

-- Xiubo


On 4/20/22 1:24 PM, Xiubo Li wrote:
> Since the cephFS makes no attempt to maintain atime, we shouldn't
> try to update it in mmap and generic read cases and ignore updating
> it in direct and sync read cases.
>
> And even we update it in mmap and generic read cases we will drop
> it and won't sync it to MDS. And we are seeing the atime will be
> updated and then dropped to the floor again and again.
>
> URL: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/VSJM7T4CS5TDRFF6XFPIYMHP75K73PZ6/
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/addr.c  | 1 -
>   fs/ceph/super.c | 1 +
>   2 files changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index aa25bffd4823..02722ac86d73 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1774,7 +1774,6 @@ int ceph_mmap(struct file *file, struct vm_area_struct *vma)
>   
>   	if (!mapping->a_ops->readpage)
>   		return -ENOEXEC;
> -	file_accessed(file);
>   	vma->vm_ops = &ceph_vmops;
>   	return 0;
>   }
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index e6987d295079..b73b4f75462c 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1119,6 +1119,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
>   	s->s_time_gran = 1;
>   	s->s_time_min = 0;
>   	s->s_time_max = U32_MAX;
> +	s->s_flags |= SB_NODIRATIME | SB_NOATIME;
>   
>   	ret = set_anon_super_fc(s, fc);
>   	if (ret != 0)

