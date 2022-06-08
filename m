Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BBB542B55
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 11:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbiFHJTr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 05:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiFHJTM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 05:19:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8016B2342B3
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 01:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654677694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x3ViZ7KMtV57nuYrL36SRIzOR46fHP7ZePPOQYVlfOE=;
        b=bZAQrI7hWxsfNiAWpDGJAHulwIFa4uGjNvhUBH4nM0tpOB9jH5c18pyy8NFbMvNVZRM68J
        QWFiVRVqljwUiM2GVZ87Fd03c+hDRQi/Xmcr5BugmoKa8iBDN7pY+Hj9sdLgafrJlI/ahZ
        1FyUg1pieN1lf9QGG45io+KZhFIuK78=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-DlPZ5i11MbWcm0uY6MSiLA-1; Wed, 08 Jun 2022 04:41:33 -0400
X-MC-Unique: DlPZ5i11MbWcm0uY6MSiLA-1
Received: by mail-pj1-f69.google.com with SMTP id u10-20020a17090a1d4a00b001e862680928so5372799pju.9
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 01:41:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=x3ViZ7KMtV57nuYrL36SRIzOR46fHP7ZePPOQYVlfOE=;
        b=8H+AUNfY3gT+M/DY/Fkr2gisFHQjRhAqlfYPiAz7DhOQjFYdI843syhfFBQi1YUkPi
         g/Ykw1rOYFYR5aQdvDPgLq6+hTZN9HE4zUnxubbMmOL466WBqYcMHbU4Ek2P4TQ1dsXS
         3ko1otTc9fuv91dB8tgEfhGjpZ/sdsRV8JlbZ8ZjxVZESNU44FBq0QLTEt6KSw5Qc/UK
         DlBlpA4WrL5vFGFzzb7MibHKBI969I+WfsFKultVRs59miZSmu6jFCphbzv2y3hIRKG3
         DRwAce5wqvBPtnlAPaIO+Qd51uJza4A4Xl0LoeY6eHnBJ1QdXvF46NTZxEDmX/XfuL6+
         5JJA==
X-Gm-Message-State: AOAM5314Edyju6hC3DBjs/4s+4FpbAS5JcoFfJ1/3E4FO+XU4pqb30IX
        z1KF/+bvwI4e5ZM3kxWcM21rECdfh+njElic0kYVrN2Dx6j21RIfd76N784CmsIWCD8jrOIUZnK
        QnnOBmkw03Z3oUzJAjJx4wecxWQ6EMF0y7dhLOkF/S7vAWHslmQhzejJDiOh8VzDwnRCw834=
X-Received: by 2002:a65:6bd3:0:b0:3fd:63c3:a84b with SMTP id e19-20020a656bd3000000b003fd63c3a84bmr17700988pgw.572.1654677691854;
        Wed, 08 Jun 2022 01:41:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUDtWFnME8QJhVfkuT6kfze8TJFII1OLM2ZYx9b1iaj0MN7TrxAzthRj2r/Fxn8GyVFfaEiA==
X-Received: by 2002:a65:6bd3:0:b0:3fd:63c3:a84b with SMTP id e19-20020a656bd3000000b003fd63c3a84bmr17700965pgw.572.1654677691539;
        Wed, 08 Jun 2022 01:41:31 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id go13-20020a17090b03cd00b001e667f932cdsm12764658pjb.53.2022.06.08.01.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 01:41:30 -0700 (PDT)
Subject: Re: [PATCH 1/2] generic/020: adjust max_attrval_size for ceph
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220607151513.26347-1-lhenriques@suse.de>
 <20220607151513.26347-2-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4196c96d-0ae8-a7ba-7a5f-b64483336d17@redhat.com>
Date:   Wed, 8 Jun 2022 16:41:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220607151513.26347-2-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/7/22 11:15 PM, Luís Henriques wrote:
> CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
> size for the full set of an inode's xattrs names+values, which by default
> is 64K but it can be changed by a cluster admin.
>
> Adjust max_attrval_size so that the test can be executed in this
> filesystem.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   tests/generic/020 | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/tests/generic/020 b/tests/generic/020
> index d8648e96286e..cadfce5f45e3 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -128,15 +128,16 @@ _attr_get_max()
>   	pvfs2)
>   		max_attrval_size=8192
>   		;;
> -	xfs|udf|9p|ceph)
> +	xfs|udf|9p)
>   		max_attrval_size=65536
>   		;;
>   	bcachefs)
>   		max_attrval_size=1024
>   		;;
> -	nfs)
> -		# NFS doesn't provide a way to find out the max_attrval_size for
> -		# the underlying filesystem, so just use the lowest value above.
> +	nfs|ceph)
> +		# NFS and CephFS don't provide a way to find out the
> +		# max_attrval_size for the underlying filesystem, so just use
> +		# the lowest value above.
>   		max_attrval_size=1024
>   		;;
>   	*)

Why not fixing this by making sure that the total length of 'name' + 
'value' == 64K instead for ceph case ?

IMO we shouldn't worry about the case that the max could be changeable, 
we just need to test the framework works well with the default is 
enough. And then print a warning if the test fails to let users to know 
that the max size must be as default, which is 64K, or if users didn't 
change it then it should be a real bug in ceph.


