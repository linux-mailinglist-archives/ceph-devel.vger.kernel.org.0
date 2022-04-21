Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D663509883
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 09:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385530AbiDUHH2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Apr 2022 03:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242436AbiDUHH1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Apr 2022 03:07:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9733415704
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 00:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650524677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KcAUn+Y2DHaySNcNw4nIdklOi/+FyTdW1gH/f/6Fw3E=;
        b=Ua7yN6xnq5vAc0i7N33jozi2EeXwesmQiQCJzpZ+oOt1jfMwVhsFelRA66UJ3mbxBA2FHG
        IlCbS7LPJRiaR/YiuKKVEIEAg1RbKGfl66QoubfEml+3GqJSJlwqKbF+SXhXUyIvbThE8e
        jZHm0nIDlAziJ0wPgS1O0Q1UuXNgs4A=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-DvwnNL_4NkSQFIQsq13N3w-1; Thu, 21 Apr 2022 03:04:35 -0400
X-MC-Unique: DvwnNL_4NkSQFIQsq13N3w-1
Received: by mail-pj1-f72.google.com with SMTP id d15-20020a17090a3b0f00b001cd5528627eso3139941pjc.1
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 00:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KcAUn+Y2DHaySNcNw4nIdklOi/+FyTdW1gH/f/6Fw3E=;
        b=QbK2d9NFtqPPZ1GTYlEu8kHVzccYZWY/NATuik95rtoLKMfuUA3rDlrV3yyLdCbLcG
         tXsUDqR4EieBEqgwmdWZa4e7WoMp75TUQWhnhIveNQGYT6ieWt7OkVDQBjf3b1cZbLdo
         gCoWrICMIT82AOvTfNAlCm0mgm1Hxc+X9Ub3vEhacmYw8VxTHgyKe7d+g0xSFTjAd3fe
         z4rMl2Kqxsmum3mt1zViA0eG/bPk7u7CGoCyeG+tcf1jYhpYx1TY71zlbUFkpD6NZ7wh
         YdQ57GhPDf7YlXrhDV6/wcHrkxUNSpedadlXroOR7MOpkK014q/XX71GB/MqN/BCkJwS
         NIJg==
X-Gm-Message-State: AOAM530Nq3uEAv8LJYSgmae4v3uy7Im7stcXjIku+pxE3qHhINOhAg24
        lZgHb5Qbmw7ab2bBy3sI1G1oiPHnfguDpEUPURnmFLoJHCXkZEeQy0M27T8Wwxb/EQtQIidzDrF
        +W+W90+IJm2mTHjFewvJVaCZuz0VbLMGEBDsxXMnO43d5jQymWp7ZBmbNCnL7+wgSsjkz5qU=
X-Received: by 2002:a63:40c7:0:b0:39d:8c29:2f57 with SMTP id n190-20020a6340c7000000b0039d8c292f57mr22815392pga.202.1650524673979;
        Thu, 21 Apr 2022 00:04:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBMyZ95GVjQjnp8U/ajakU8HE4ZaE6uSmjeJa76aWDijCE/QGOtGlHav4kBfb0HeUCqkY6TQ==
X-Received: by 2002:a63:40c7:0:b0:39d:8c29:2f57 with SMTP id n190-20020a6340c7000000b0039d8c292f57mr22815367pga.202.1650524673595;
        Thu, 21 Apr 2022 00:04:33 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a190300b001cd4989ff60sm1440778pjg.39.2022.04.21.00.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 00:04:32 -0700 (PDT)
Subject: Re: [PATCH] ceph: try to choose the auth MDS if possible for getattr
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220421042028.92787-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2da31e4f-8cc7-150b-95ff-41bd951645f1@redhat.com>
Date:   Thu, 21 Apr 2022 15:04:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220421042028.92787-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Will send a V2 to fix the same issue in ceph_netfs_issue_op_inline().

-- Xiubo


On 4/21/22 12:20 PM, Xiubo Li wrote:
> If any 'x' caps is issued we can just choose the auth MDS instead
> of the random replica MDSes. Because only when the Locker is in
> LOCK_EXEC state will the loner client could get the 'x' caps. And
> if we send the getattr requests to any replica MDS it must auth pin
> and tries to rdlock from the auth MDS, and then the auth MDS need
> to do the Locker state transition to LOCK_SYNC. And after that the
> lock state will change back.
>
> This cost much when doing the Locker state transition and usually
> will need to revoke caps from clients.
>
> URL: https://tracker.ceph.com/issues/55240
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/inode.c | 20 +++++++++++++++++++-
>   1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index b45f321910af..2a5023b1272d 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2270,6 +2270,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>   	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
>   	struct ceph_mds_client *mdsc = fsc->mdsc;
>   	struct ceph_mds_request *req;
> +	int issued = ceph_caps_issued(ceph_inode(inode));
>   	int mode;
>   	int err;
>   
> @@ -2283,7 +2284,24 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>   	if (!force && ceph_caps_issued_mask_metric(ceph_inode(inode), mask, 1))
>   			return 0;
>   
> -	mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
> +	/*
> +	 * If any 'x' caps is issued we can just choose the auth MDS
> +	 * instead of the random replica MDSes. Because only when the
> +	 * Locker is in LOCK_EXEC state will the exclusive client could
> +	 * get the 'x' caps. And if we send the getattr requests to any
> +	 * replica MDS it must auth pin and tries to rdlock from the auth
> +	 * MDS, and then the auth MDS need to do the Locker state transition
> +	 * to LOCK_SYNC. And after that the lock state will change back.
> +	 *
> +	 * This cost much when doing the Locker state transition and
> +	 * usually will need to revoke caps from clients.
> +	 */
> +	if (((mask & CEPH_CAP_ANY_SHARED) && (issued & CEPH_CAP_ANY_EXCL))
> +	    || (mask & CEPH_STAT_RSTAT))
> +		mode = USE_AUTH_MDS;
> +	else
> +		mode = USE_ANY_MDS;
> +
>   	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
>   	if (IS_ERR(req))
>   		return PTR_ERR(req);

