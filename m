Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DC1542B88
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 11:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbiFHJ01 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 05:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbiFHJZr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 05:25:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D469F65AB
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 01:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654678268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8dym9EftdGoVl7OEi571aoVb6AKAy7646sBQwCzRA1Q=;
        b=as+M+ijte/rVSmz5x9lBebSEKHanMJD1qIwIIn+w8miLIPB0yPtr8r3CW936d7DEijrIsN
        7ogZRsbCvpOHJR6RdafTxK64ucePh+Cp5mmLRWD8cgwdH4RH8Sj2BvqLgmI2HJo3/QBMit
        DmAoK3hJmPIPDzNTdR+bUG4ZD7zCBUo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-U-h2LHanOZeq2SK-DzC4dQ-1; Wed, 08 Jun 2022 04:51:07 -0400
X-MC-Unique: U-h2LHanOZeq2SK-DzC4dQ-1
Received: by mail-pl1-f200.google.com with SMTP id g3-20020a170902868300b00163cd75c014so10856999plo.14
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 01:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8dym9EftdGoVl7OEi571aoVb6AKAy7646sBQwCzRA1Q=;
        b=nvR6jXYjZ9xRj0y/W/+Yjup8sXPrxSypQlCuYbafXocQQniPGLPKuuhDe9V3am/NKv
         T2PZfqWugC4oTJQWXSK22Tqh2nWAj7bIZRluB8P1czlMSHFJWEtQO6b5d6qpcP0B/wQQ
         c5nIoEu4dJiJjZnFvxCz/WKsegE/0Kr7WpKlMSP954jpRCIRoRmWiEClSVDiccbO3bSh
         brHNQGPr9Pp29E92qrjvqU8V09wK5cxdOgIeKuRMP9Cx2BSrTBiCi6Ol4+xxOaUQnJmB
         geN1zKJL6XQinX5kcbQO0mxNTRQeuKakUhaqAFPIBKhKYywWmy4SA4a+uogLBcvQ/e0X
         GPpg==
X-Gm-Message-State: AOAM533KYEnAiChy6UAMC3U2FjHPINYOabjYsNLJdCezaYWxQU/aFC88
        Gplu4wqMMgzZgf/a2LPBBp730ldRIxbwc/IXFv8W6vonz96aVl+uF2HWeylPC6Fa1bkpozi4cHa
        /DlEDMQdb5LmsjKiTFDTqQdt9nkjFQuRw8Ti2QDc9OOGWfzi7v3m/yfD8uCzjm4htpa3kHfA=
X-Received: by 2002:a17:902:7884:b0:167:4d5b:7a2f with SMTP id q4-20020a170902788400b001674d5b7a2fmr25777669pll.18.1654678265507;
        Wed, 08 Jun 2022 01:51:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwo4c1UCwpEO/e8Etgde4xDUTc27MdW+5+/TzajzYSjrZdrUco1wv6ysIEUSUwQLl1eOpuRmg==
X-Received: by 2002:a17:902:7884:b0:167:4d5b:7a2f with SMTP id q4-20020a170902788400b001674d5b7a2fmr25777640pll.18.1654678265160;
        Wed, 08 Jun 2022 01:51:05 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id iz18-20020a170902ef9200b0016363b15acasm14193827plb.112.2022.06.08.01.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 01:51:04 -0700 (PDT)
Subject: Re: [PATCH 2/2] src/attr_replace_test: dynamically adjust the max
 xattr size
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220607151513.26347-1-lhenriques@suse.de>
 <20220607151513.26347-3-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <eff21787-0981-f779-fce8-925c26105c96@redhat.com>
Date:   Wed, 8 Jun 2022 16:50:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220607151513.26347-3-lhenriques@suse.de>
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


On 6/7/22 11:15 PM, Luís Henriques wrote:
> CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
> size for the full set of an inode's xattrs names+values, which by default
> is 64K but it can be changed by a cluster admin.
>
> Test generic/486 started to fail after fixing a ceph bug where this limit
> wasn't being imposed.  Adjust dynamically the size of the xattr being set
> if the error returned is -ENOSPC.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   src/attr_replace_test.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
> index cca8dcf8ff60..de18e643f469 100644
> --- a/src/attr_replace_test.c
> +++ b/src/attr_replace_test.c
> @@ -62,7 +62,10 @@ int main(int argc, char *argv[])
>   
>   	/* Then, replace it with bigger one, forcing short form to leaf conversion. */
>   	memset(value, '1', size);
> -	ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
> +	do {
> +		ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
> +		size -= 256;
> +	} while ((ret < 0) && (errno == ENOSPC) && (size > 0));
>   	if (ret < 0) die();
>   	close(fd);
>   

And also here, we shouldn't worry about users will change the default 
value, and we can just assume that users should test it with default value.

I am afraid this won't test real bug of the related code then.

Or as I mentioned in another thread, add one ioctl cmd to get the value ?

