Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C646FD7C2
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 09:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbjEJHDW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 May 2023 03:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236286AbjEJHDD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 May 2023 03:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA27EDB
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 00:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683702139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wDtkOwb7rKpwoUK6Ei9wdesk6YyvpzkQRJOz+o6YgcQ=;
        b=cWBDUbM5V6zUHEn6OKH9y9RLRv9h/XWB1uWga8jSGjmHsvYLssUaJyzSbA3wKtFmkjq5dH
        0vuQD7uI2Us4wlMDzwpRScmp53PVsgm+OkRs7YJMdi5/OWb0J9eLkYDd1kxMQ6H08gXDRU
        G3c+U6mN8Dj+B/ahpJe8AqWMP+3RPgw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-Yn2bV6WxML2JIG9tKuccOA-1; Wed, 10 May 2023 03:02:17 -0400
X-MC-Unique: Yn2bV6WxML2JIG9tKuccOA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-24e1e0263daso6658436a91.2
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 00:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683702137; x=1686294137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wDtkOwb7rKpwoUK6Ei9wdesk6YyvpzkQRJOz+o6YgcQ=;
        b=I3dU4uj4QnFrENs51Mpifp9Yyqyn5LF1nsYAYLS7w981y1FULzazANtu58PEXdxho0
         q0poYD+4nakYLvh61jxtz7huG7pirR0spGwArwymop+RRK6GUwrPkisqqrY3oH97K9cB
         gaLOPLfehDT9WWvk1vvgUix6XG68za52ib4uoUvMJbVqszZrBDOS1/4SVUcH+N6bwY0S
         FPFgVdk6H6m0rwESbvCObcFK+dyoMtZh/TzSMD3MRDUV5WLoxE1pnl72ZWfCmDxrsMkU
         8QeiLstTEtx7EmtiJed1wx4w7UW1inB88qM51vq8vYW+8LFe2LzfNlg75df/VSU233W0
         TZdg==
X-Gm-Message-State: AC+VfDyHeCTDxN+PXtf1bwwiK2G+aNfY/JjNTtcQdIDPBCCphKqSOYOm
        bRCgc7XlxDcOYSAw+dl9rFrW6o12+KYfa76M+cKlD9VGXP9YDzxXToEwAZD12KVex61aOSRjlPp
        1/dWxd8haZ21Q5un+zliJhA==
X-Received: by 2002:a17:90a:df0c:b0:250:8834:307f with SMTP id gp12-20020a17090adf0c00b002508834307fmr9056627pjb.0.1683702136917;
        Wed, 10 May 2023 00:02:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7E6FK8mAM6oRNzOIemzVoF6WPkaCyk08LDX0afH0P4LwYa8Cf0nVOJX9XvGOw0yMytJUGSZg==
X-Received: by 2002:a17:90a:df0c:b0:250:8834:307f with SMTP id gp12-20020a17090adf0c00b002508834307fmr9056613pjb.0.1683702136605;
        Wed, 10 May 2023 00:02:16 -0700 (PDT)
Received: from [10.72.12.156] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c20d00b0019e5fc21663sm2902995pll.218.2023.05.10.00.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 00:02:16 -0700 (PDT)
Message-ID: <00479efd-529e-0b98-7f45-3d6c97f0e281@redhat.com>
Date:   Wed, 10 May 2023 15:02:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/3] libceph: reject mismatching name and fsid
Content-Language: en-US
To:     Hu Weiwen <huww98@outlook.com>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB2066D19A68A9176E289BB4FDC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <TYCP286MB2066D19A68A9176E289BB4FDC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/8/23 01:55, Hu Weiwen wrote:
> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
>
> These are present in the device spec of cephfs. So they should be
> treated as immutable.  Also reject `mount()' calls where options and
> device spec are inconsistent.
>
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>   net/ceph/ceph_common.c | 26 +++++++++++++++++++++-----
>   1 file changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 4c6441536d55..c59c5ccc23a8 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -440,17 +440,33 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>   		break;
>   
>   	case Opt_fsid:
> -		err = ceph_parse_fsid(param->string, &opt->fsid);
> +	{

BTW, do we need the '{}' here ?


> +		struct ceph_fsid fsid;
> +
> +		err = ceph_parse_fsid(param->string, &fsid);
>   		if (err) {
>   			error_plog(&log, "Failed to parse fsid: %d", err);
>   			return err;
>   		}
> -		opt->flags |= CEPH_OPT_FSID;
> +
> +		if (!(opt->flags & CEPH_OPT_FSID)) {
> +			opt->fsid = fsid;
> +			opt->flags |= CEPH_OPT_FSID;
> +		} else if (ceph_fsid_compare(&opt->fsid, &fsid)) {
> +			error_plog(&log, "fsid already set to %pU",
> +				   &opt->fsid);
> +			return -EINVAL;
> +		}
>   		break;
> +	}
>   	case Opt_name:
> -		kfree(opt->name);
> -		opt->name = param->string;
> -		param->string = NULL;
> +		if (!opt->name) {
> +			opt->name = param->string;
> +			param->string = NULL;
> +		} else if (strcmp(opt->name, param->string)) {
> +			error_plog(&log, "name already set to %s", opt->name);
> +			return -EINVAL;
> +		}
>   		break;
>   	case Opt_secret:
>   		ceph_crypto_key_destroy(opt->key);

