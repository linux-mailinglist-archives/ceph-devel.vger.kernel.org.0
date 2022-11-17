Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C74762D499
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Nov 2022 09:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbiKQIEs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Nov 2022 03:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiKQIEr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Nov 2022 03:04:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E48DC8
        for <ceph-devel@vger.kernel.org>; Thu, 17 Nov 2022 00:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668672225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lc6aO2jeVqUhMYtAzgGQ94NvGNINHdDrt/788aNpceE=;
        b=I1G32bgDcb9jfT49aUJKMTrhXOfQksEeBRtrMUR8tQC/4xu9co10vpSQrVhgiEhXcS9Glm
        cumiWYxmEc0iNtu7Lv8/zCacOQ2Vb+KkiyQDhAk3bh6lY8gm5GU1OVT17jXkcoBoQUe9cb
        ZeY0Y9Qmr3/nXUjgHqlbPsUY/Q2bheI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-145-KBKUPX0ZNXqkmHAV284R6w-1; Thu, 17 Nov 2022 03:03:41 -0500
X-MC-Unique: KBKUPX0ZNXqkmHAV284R6w-1
Received: by mail-pj1-f70.google.com with SMTP id nl16-20020a17090b385000b002138288fd51so3628239pjb.6
        for <ceph-devel@vger.kernel.org>; Thu, 17 Nov 2022 00:03:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lc6aO2jeVqUhMYtAzgGQ94NvGNINHdDrt/788aNpceE=;
        b=Y4dvuM70rbFxT3fs54EWyeotdvxqG7jTnuz9w55j4nY2lzwwS9v2uOkb5L+aChT0iv
         SpwgEmcYoRAjQNE/GpLoYYfiGOA2RksQUjeCJc7Cfmb44NVDb3W3x4z2VxOb3L8kwVyn
         pkLzzXLJgTaeaF3cAAD3kgedprF7ci83aylLbjuwaesgYTAOatd3HqtUHYKqHYv51lX2
         k5PTG9fqz8solHnMdH+1eBmlNzXY8eREeU52Jd3jdOXQHMrh5BAkFoI7dZBMhF1yCVt/
         HVbCpBt6nF0cwV//AWkMcfCcQtwCLTcbOkt7woremQAl6oZIuWTvL+HnOlujVUllij8h
         p9Lg==
X-Gm-Message-State: ANoB5pkZ6zOetvT0hA0hp+Jd/9iIlo+iphEyjwsZXLuowZfyIhrRCJTx
        B+zdr9b934BYv+aSBp2/TPXFdoTOsTRGBc9Fn/9lbtTtGYZB4am3IjTRVQK+1ggvo9c/7hcOfIg
        j9970Gux6dFBfM246yjMm9A==
X-Received: by 2002:aa7:9243:0:b0:56d:dd2a:f6b6 with SMTP id 3-20020aa79243000000b0056ddd2af6b6mr1848173pfp.30.1668672220563;
        Thu, 17 Nov 2022 00:03:40 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Ul0+6Ftaw44/dqSaV4XxhaLQGRUCY87AVvlj/XE3vDzVl3QE+GGR+9Tr/vnWSm8s2BI54bw==
X-Received: by 2002:aa7:9243:0:b0:56d:dd2a:f6b6 with SMTP id 3-20020aa79243000000b0056ddd2af6b6mr1848156pfp.30.1668672220340;
        Thu, 17 Nov 2022 00:03:40 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902684700b00186c5e8b1d0sm547141pln.149.2022.11.17.00.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 00:03:40 -0800 (PST)
Subject: Re: [PATCH] ceph: make sure directories aren't complete after setting
 crypt context
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221116153703.27292-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5de0ae69-5e3d-2ccb-64a3-971db66477f8@redhat.com>
Date:   Thu, 17 Nov 2022 16:03:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221116153703.27292-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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


On 16/11/2022 23:37, Luís Henriques wrote:
> When setting a directory's crypt context, __ceph_dir_clear_complete() needs
> to be used otherwise, if it was complete before, any old dentry that's still
> around will be valid.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Hi!
>
> Here's a simple way to trigger the bug this patch is fixing:
>
> # cd /cephfs
> # ls mydir
> nKRhofOAVNsAwVLvDw7a0c9ypsjbZfK3n0Npnmni6j0
> # ls mydir/nKRhofOAVNsAwVLvDw7a0c9ypsjbZfK3n0Npnmni6j0/
> Cyuer5xT+kBlEPgtwAqSj0WK2taEljP5vHZ,D8VXCJ8  u+46b2XVCt7Obpz0gznZyNLRj79Q2l4KmkwbKOzdQKw
> # fscrypt unlock mydir
> # touch /mnt/test/mydir/mysubdir/file
> touch: cannot touch '/mnt/test/mydir/mysubdir/file': No such file or directory
>
>   fs/ceph/crypto.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index 35a2ccfe6899..dc1557967032 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -87,6 +87,10 @@ static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
>   		return -ERANGE;
>   
>   	memcpy(ctx, cfa->cfa_blob, ctxlen);
> +
> +	/* Directory isn't complete anymore */
> +	if (S_ISDIR(inode->i_mode) && __ceph_dir_is_complete(ci))
> +		__ceph_dir_clear_complete(ci);

Hi Luis,

Good catch!

BTW, why do this in the ceph_crypt_get_context() ? As my understanding 
is that we should mark 'mydir' as incomplete when unlocking it. While as 
I remembered the unlock operation will do:


Step1: get_encpolicy via 'mydir' as ctx
Step2: rm_enckey of ctx from the superblock


Since I am still running the test cases for the file lock patches, so I 
didn't catch logs to confirm the above steps yet.

If I am right IMO then we should mark the dir as incomplete in the Step2 
instead, because for non-unlock operations they may also do the Step1.

Thanks!

- Xiubo

>   	return ctxlen;
>   }
>   
>

