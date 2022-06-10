Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1813E545BB8
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 07:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346157AbiFJFfy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 01:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245020AbiFJFfv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 01:35:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C118A76FB
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 22:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654839349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OFlevMwIDu7LawrDoTiYTRWWQHh5j6a3JOKqHMlKkRg=;
        b=D5bCNcArYT/sQ8Wk5rnnRyUkbt9S3ZITTkRlTkpQYRn8k9u+K5B1EZkrlHcPP6AcP4iH7i
        9UELuObJE8MM9woNZXGUIxpz0niFXQjgx0Cd1RYpebNGcdvPjxprbPux8MvvLRRZ0wDfbi
        9pExwFbvRyOJUoUh7Xrvur1i7u1z/g8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-Nf3nVa25OziRlSErmkSCpw-1; Fri, 10 Jun 2022 01:35:46 -0400
X-MC-Unique: Nf3nVa25OziRlSErmkSCpw-1
Received: by mail-pl1-f199.google.com with SMTP id c10-20020a170903234a00b00168b5f7661bso1061361plh.6
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jun 2022 22:35:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OFlevMwIDu7LawrDoTiYTRWWQHh5j6a3JOKqHMlKkRg=;
        b=GXa8bWJsFa0yYHPxaVW9NTdhFYcBFBypYF2bkwlVxjvqY8QweOpk4tTduwRbIa/LFx
         fevHM0qRcXA/DbFn6q+dYNv90u/WX3CFcnYnX/R+7SdAU5Upx0D+ueC47xmR2YjQ1N/u
         4QC9qBSjcudDw7AS8A+sb8swO4RwwxAjR3Ym3ci5+dpfpQk/h0jFz863GE+YncRBH63X
         Ln78Hs7LLOTptsQ23+xRAJHfU7YfezGWJ3dJI0AKJV6jJiOoupVysCeGJii4wdHkFGbL
         Jur1ckLhL/JUU+qY/nOe29ljMbTgz2+/wOG/ymaluHTDdRo9sVc8OxQi4q83G7l6SIhO
         izMw==
X-Gm-Message-State: AOAM533DANzGrgUDXDMQm6DV3G0UEB4qpE5lWYE7NZzMF8Myzu2EApcV
        CZQ3oc+pjdmY/biaFSoVEc8ub4QRm6Owk01SxTlCTSl8mtgByDEQ3tozvFWPccRqBdQP4lq2Xw0
        zK1yzw0YKpU9suZdb6Rqsp2TGaVCRk9dJEL/FD+V7eMuz1xhovpXeuXc2v2uaPKXHYztlSxk=
X-Received: by 2002:a17:90a:7b89:b0:1e8:9f24:26b2 with SMTP id z9-20020a17090a7b8900b001e89f2426b2mr7081808pjc.106.1654839344406;
        Thu, 09 Jun 2022 22:35:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydIOmo5y2rqRqDvviWZQbO3l1Bf+HEM47vyMQaqAK1n1xzJCYMZj9MjXPEophwdTPH/HzP3A==
X-Received: by 2002:a17:90a:7b89:b0:1e8:9f24:26b2 with SMTP id z9-20020a17090a7b8900b001e89f2426b2mr7081773pjc.106.1654839343994;
        Thu, 09 Jun 2022 22:35:43 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j64-20020a62c543000000b0051e6b11e595sm2589114pfg.116.2022.06.09.22.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 22:35:43 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] generic/486: adjust the max xattr size
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220609105343.13591-1-lhenriques@suse.de>
 <20220609105343.13591-3-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4c4572a2-2681-c2f7-a8dc-55eb2f5fc077@redhat.com>
Date:   Fri, 10 Jun 2022 13:35:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220609105343.13591-3-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/9/22 6:53 PM, Luís Henriques wrote:
> CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
> size for the full set of xattrs names+values, which by default is 64K.
> And since ceph reports 4M as the blocksize (the default ceph object size),
> generic/486 will fail in this filesystem because it will end up using
> XATTR_SIZE_MAX to set the size of the 2nd (big) xattr value.
>
> The fix is to adjust the max size in attr_replace_test so that it takes
> into account the initial xattr name and value lengths.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   src/attr_replace_test.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
> index cca8dcf8ff60..1c8d1049a1d8 100644
> --- a/src/attr_replace_test.c
> +++ b/src/attr_replace_test.c
> @@ -29,6 +29,11 @@ int main(int argc, char *argv[])
>   	char *value;
>   	struct stat sbuf;
>   	size_t size = sizeof(value);
> +	/*
> +	 * Take into account the initial (small) xattr name and value sizes and
> +	 * subtract them from the XATTR_SIZE_MAX maximum.
> +	 */
> +	size_t maxsize = XATTR_SIZE_MAX - strlen(name) - 1;

Why not use the statfs to get the filesystem type first ? And then just 
minus the strlen(name) for ceph only ?


>   
>   	if (argc != 2)
>   		fail("Usage: %s <file>\n", argv[0]);
> @@ -46,7 +51,7 @@ int main(int argc, char *argv[])
>   	size = sbuf.st_blksize * 3 / 4;
>   	if (!size)
>   		fail("Invalid st_blksize(%ld)\n", sbuf.st_blksize);
> -	size = MIN(size, XATTR_SIZE_MAX);
> +	size = MIN(size, maxsize);
>   	value = malloc(size);
>   	if (!value)
>   		fail("Failed to allocate memory\n");
>

