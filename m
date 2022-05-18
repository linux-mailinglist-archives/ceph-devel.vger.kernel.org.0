Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5475E52BE8E
	for <lists+ceph-devel@lfdr.de>; Wed, 18 May 2022 17:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbiEROXg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 May 2022 10:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238583AbiEROXf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 18 May 2022 10:23:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9FB518358
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 07:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652883813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xEnVe+thJMrj0C89/i9QBXS8K26hkY9sQCbQCmrjIxg=;
        b=QaYS5HiPyscs3S0K6uYLrjm6Os45LLbCsNPutNDhdEIX5CslkZzc7x03II4DbUfkLFXk6U
        620LtB/vUfU/9GP2frmKWuFa5TWt9MwJN6IrxQdzG3g7E3ZDY9uo9uoKpB9Vfr/CscFaRJ
        wi7YIiArGPQgb8CbSSBkOU2snYOY96Y=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-Y2Cq0VKZNM6ALujhcToQ8A-1; Wed, 18 May 2022 10:23:32 -0400
X-MC-Unique: Y2Cq0VKZNM6ALujhcToQ8A-1
Received: by mail-pf1-f200.google.com with SMTP id f82-20020a623855000000b005182d5d2cdbso881122pfa.15
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 07:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xEnVe+thJMrj0C89/i9QBXS8K26hkY9sQCbQCmrjIxg=;
        b=PR+Rh0106kLH5w1W+PUp89i0OfAvVdCXJiQgtWSTKWd4nQyJ889aqBYygpy9p/v4uU
         4ff4eYNtJSwPdxEodTeCVA98EfTKsUIVjSGUETvZLjh8Vikf1rMl7ACnn42jgU8p9aYT
         JHpEYmb2I9PS5ygE6W++JejKROLpEs9an+NmIenrhY4CBa2MxEclGAz6m1fkaAGlubhj
         z3yapWEFKsQ5J7qYcSuJatsTcqB7+KLvJMhU2l1tFJiFjuFAC+4e34KV7lefKWeupFaR
         8wxwJToES9HXnlGBFFgp1BQpcuxwKZ5vjLZY6GSIk+s8WclwgcA3Bk0SeO+31OF2Ryi9
         ReSw==
X-Gm-Message-State: AOAM530tT9Z6DcR5JXnBoFBBqQJbTmQ/n/5qDBfYhcHVpMgU2RlMJM/j
        KjU0wm0Z4cDbO13CsTCJPEYACPEDurWAkvgopfkE7VEeTfraK0uJpqdGgLjirHcwOAbyGZTCxbJ
        eCtFse2F4G8LMQ9dzvA8FuQ==
X-Received: by 2002:a17:90b:1c8e:b0:1bf:364c:dd7a with SMTP id oo14-20020a17090b1c8e00b001bf364cdd7amr225172pjb.103.1652883811484;
        Wed, 18 May 2022 07:23:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7BLP1J1H8f7oD1TY5TGuF+QDjgPJtGJ1rzPMQGjEi3Mxt4eMzgGqbzqjFJq4C8NXIHPKx2A==
X-Received: by 2002:a17:90b:1c8e:b0:1bf:364c:dd7a with SMTP id oo14-20020a17090b1c8e00b001bf364cdd7amr225147pjb.103.1652883811225;
        Wed, 18 May 2022 07:23:31 -0700 (PDT)
Received: from [10.72.12.136] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r19-20020a63ce53000000b003c6a80e54cfsm1620634pgi.75.2022.05.18.07.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 07:23:30 -0700 (PDT)
Subject: Re: [PATCH] ceph: remove redundant variable ino
To:     Colin Ian King <colin.i.king@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220518085508.509104-1-colin.i.king@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5398e036-8150-ffd0-844e-719257c6e2f7@redhat.com>
Date:   Wed, 18 May 2022 22:23:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220518085508.509104-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/18/22 4:55 PM, Colin Ian King wrote:
> Variable ino is being assigned a value that is never read. The variable
> and assignment are redundant, remove it.
>
> Cleans up clang scan build warning:
> warning: Although the value stored to 'ino' is used in the enclosing
> expression, the value is never actually read from 'ino'
> [deadcode.DeadStores]
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   fs/ceph/mds_client.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 00c3de177dd6..20197f05faec 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -437,7 +437,7 @@ static int ceph_parse_deleg_inos(void **p, void *end,
>   	ceph_decode_32_safe(p, end, sets, bad);
>   	dout("got %u sets of delegated inodes\n", sets);
>   	while (sets--) {
> -		u64 start, len, ino;
> +		u64 start, len;
>   
>   		ceph_decode_64_safe(p, end, start, bad);
>   		ceph_decode_64_safe(p, end, len, bad);
> @@ -449,7 +449,7 @@ static int ceph_parse_deleg_inos(void **p, void *end,
>   			continue;
>   		}
>   		while (len--) {
> -			int err = xa_insert(&s->s_delegated_inos, ino = start++,
> +			int err = xa_insert(&s->s_delegated_inos, start++,
>   					    DELEGATED_INO_AVAILABLE,
>   					    GFP_KERNEL);
>   			if (!err) {

Merged into ceph-client/testing branch. Thanks!

-- Xiubo


