Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B156FBC49
	for <lists+ceph-devel@lfdr.de>; Tue,  9 May 2023 03:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbjEIBFw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 May 2023 21:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjEIBFv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 May 2023 21:05:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAF95FD2
        for <ceph-devel@vger.kernel.org>; Mon,  8 May 2023 18:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683594303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uIE74BUA1oHNbvYIy62PAKKBhyZ/HUsZLV1ch2GmGu4=;
        b=RDmtdcvuPzItCt501yRCsf0mxrqwx0mh6ttcMAGujqNLm61GhgV3gSZ+MsBPZMuqKip88L
        5BuPK4ntOmXbMfMCsCBbtS3ZLArjfc42OaUhchismePzVSILGkIjur3X+Suz4+HYHiR7h/
        DIpvlAtkCfvf0hvl6Q1Ln2R/TTSgx10=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-IdFXBwEoO5mtkQSZYEs76w-1; Mon, 08 May 2023 21:05:02 -0400
X-MC-Unique: IdFXBwEoO5mtkQSZYEs76w-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-51f10bda596so2366292a12.1
        for <ceph-devel@vger.kernel.org>; Mon, 08 May 2023 18:05:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683594301; x=1686186301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uIE74BUA1oHNbvYIy62PAKKBhyZ/HUsZLV1ch2GmGu4=;
        b=eDZtJjrKQnTN5d5/Z2nQF8MAHFlk6h4um4KL74ZEeExh0VCIr+b8hUiVwvNTwiuR0w
         yUEkiodW87tC3bglCNRhQOoRNcv0jDWre3CVXENNN4/LxjbAxP7dx4HcoDWtJ8L4h9WS
         /e/Y0JXsxhWc/3jOBIrpD8mdGRqD9VbJnPSsswsdVMfT2Xf/K/gRL8VviJfvcU2fAWao
         H5ZYHs4bfqrwiRw3unw359sqr3QsDpOa+oW3XjjsiW3IVld+1z3+Blh5tXrIBukG+K6s
         sKIvDF8iR7yZkV7C5cwhd2yo5jRqpC/O7YnqApTGYITud5UblMIiHvehSEU99AI8XpXp
         4ajg==
X-Gm-Message-State: AC+VfDy6Nb7tj141kzsGvTl20+NdUKdiRQCLmwRF7oqXtEp8y+nYMqsb
        TnF2bpwr1VUWJVxUOsm7LzW4nNXX0k6Tbapu926wjOo00bqck/slWTNvdMGK+6uhNkIHtLMSQD3
        15TxXIpWsbEvJpcf8Gw2HKrkr3iCtYI1f
X-Received: by 2002:a17:903:24e:b0:1a8:431:9e14 with SMTP id j14-20020a170903024e00b001a804319e14mr13922593plh.25.1683594301018;
        Mon, 08 May 2023 18:05:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5O4jIbsm7CAnIGZw7d3G0PS9uxiAAxC7VoIVSjoNEChHl6w+yqRzdGTKEQe/ESqA4WVXX5lQ==
X-Received: by 2002:a17:903:24e:b0:1a8:431:9e14 with SMTP id j14-20020a170903024e00b001a804319e14mr13922571plh.25.1683594300723;
        Mon, 08 May 2023 18:05:00 -0700 (PDT)
Received: from [10.72.12.156] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m18-20020a63ed52000000b0052c9d1533b6sm99688pgk.56.2023.05.08.18.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 18:05:00 -0700 (PDT)
Message-ID: <ce388c9d-97f1-57fb-4ed2-745596e1bd5f@redhat.com>
Date:   Tue, 9 May 2023 09:04:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] ceph: refactor mds_namespace comparing
Content-Language: en-US
To:     Hu Weiwen <huww98@outlook.com>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB2066C89FCBD9FB30AFDF2D70C0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <TYCP286MB2066C89FCBD9FB30AFDF2D70C0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/8/23 01:55, Hu Weiwen wrote:
> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
>
> Same logic, slightly less code.  Make the following changes easier.
>
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>   fs/ceph/super.c | 34 ++++++++++++++--------------------
>   1 file changed, 14 insertions(+), 20 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 3fc48b43cab0..4e1f4031e888 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -235,18 +235,10 @@ static void canonicalize_path(char *path)
>   	path[j] = '\0';
>   }
>   
> -/*
> - * Check if the mds namespace in ceph_mount_options matches
> - * the passed in namespace string. First time match (when
> - * ->mds_namespace is NULL) is treated specially, since
> - * ->mds_namespace needs to be initialized by the caller.
> - */
> -static int namespace_equals(struct ceph_mount_options *fsopt,
> -			    const char *namespace, size_t len)
> +/* check if s1 (null terminated) equals to s2 (with length len2) */
> +static int strstrn_equals(const char *s1, const char *s2, size_t len2)
>   {
> -	return !(fsopt->mds_namespace &&
> -		 (strlen(fsopt->mds_namespace) != len ||
> -		  strncmp(fsopt->mds_namespace, namespace, len)));
> +	return !strncmp(s1, s2, len2) && strlen(s1) == len2;
>   }

Could this helper be defined as inline explicitly ?

>   
>   static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
> @@ -297,12 +289,13 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
>   	++fs_name_start; /* start of file system name */
>   	len = dev_name_end - fs_name_start;
>   
> -	if (!namespace_equals(fsopt, fs_name_start, len))
> +	if (!fsopt->mds_namespace) {
> +		fsopt->mds_namespace = kstrndup(fs_name_start, len, GFP_KERNEL);
> +		if (!fsopt->mds_namespace)
> +			return -ENOMEM;
> +	} else if (!strstrn_equals(fsopt->mds_namespace, fs_name_start, len)) {
>   		return invalfc(fc, "Mismatching mds_namespace");
> -	kfree(fsopt->mds_namespace);
> -	fsopt->mds_namespace = kstrndup(fs_name_start, len, GFP_KERNEL);
> -	if (!fsopt->mds_namespace)
> -		return -ENOMEM;
> +	}
>   	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
>   
>   	fsopt->new_dev_syntax = true;
> @@ -417,11 +410,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>   		param->string = NULL;
>   		break;
>   	case Opt_mds_namespace:
> -		if (!namespace_equals(fsopt, param->string, strlen(param->string)))
> +		if (!fsopt->mds_namespace) {
> +			fsopt->mds_namespace = param->string;
> +			param->string = NULL;
> +		} else if (strcmp(fsopt->mds_namespace, param->string)) {
>   			return invalfc(fc, "Mismatching mds_namespace");
> -		kfree(fsopt->mds_namespace);
> -		fsopt->mds_namespace = param->string;
> -		param->string = NULL;
> +		}
>   		break;
>   	case Opt_recover_session:
>   		mode = result.uint_32;

