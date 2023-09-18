Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718997A3EF8
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Sep 2023 02:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbjIRA0d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 17 Sep 2023 20:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbjIRA0c (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 17 Sep 2023 20:26:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAF412B
        for <ceph-devel@vger.kernel.org>; Sun, 17 Sep 2023 17:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694996739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AJdGHYJg1hgtR/OBv+kksXjfIjKSJaQgEUNRz4rnSZ4=;
        b=GmvybUmbNk8i2sLKHAOQ32EYyqORBflUfHrtEJ7Jl3jrkIDbRxRMZs2rkTWI5TzA3gEV3I
        CiavIzGjOTojrxEHBjMnh69I0A+udoNebwV3ypt5Q5kWpsanoCBAS+NbVMRvdOFoYa5vjV
        BlICdikFAN3lMizc57hZTXREia3pNFc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-r1cqP6qKOHuupMX1NutN4Q-1; Sun, 17 Sep 2023 20:25:38 -0400
X-MC-Unique: r1cqP6qKOHuupMX1NutN4Q-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-27484fabc22so2135041a91.3
        for <ceph-devel@vger.kernel.org>; Sun, 17 Sep 2023 17:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694996737; x=1695601537;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AJdGHYJg1hgtR/OBv+kksXjfIjKSJaQgEUNRz4rnSZ4=;
        b=oHrtdTySlEupiKeIJwEL1UgeY0Py5ldvJogxJVy99jSU8XPhl1m9c1fd5yT9lzH8Ao
         DzrNJ0llPa5GoCbmPsNdBWb9bjxTV65fNGyZ4lTd+ZXKGNSTWAvr81l90v2hE4nwAi7w
         LGvShfBUJlKbzLV8sOPomYfJertaIBkGPEfrFWpT8UCddYHxmk55PT5K6KC5Ow7DCevu
         p1O+N5BoTF17pp8rMYvib5cIctTsAlpdr626jx2I28neBPB6pDOODV3tiE1YRScUfygh
         DsuUs6LQZqRl2VPiq8p6aYGAItKQ+uf//MybTTA5JPNikwv9jSUWxpOIVkMAcx2YgHCp
         QuZQ==
X-Gm-Message-State: AOJu0YzhTegPhe/9eMfhl4lN18pyx0qerXezaVpVSF20ZWu/1vYL9F/P
        cR+dxVu1e3kdPeDkE8/i6DspE/re9+8rgjeu0CXVwF2YiWybfp/oAQoJHvdRLnSUA571Z/55J6/
        044lYYoO4D+mjw2kvpJnZaQ==
X-Received: by 2002:a17:90a:fd0f:b0:26d:2b42:cdae with SMTP id cv15-20020a17090afd0f00b0026d2b42cdaemr5172613pjb.3.1694996737001;
        Sun, 17 Sep 2023 17:25:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLXF0oBCb3Jg8l98K1Q8D+w9gzQ6POlmU6bqJG7rj6YyYltCayunR+jeerTVRAYQhzNW9o9g==
X-Received: by 2002:a17:90a:fd0f:b0:26d:2b42:cdae with SMTP id cv15-20020a17090afd0f00b0026d2b42cdaemr5172602pjb.3.1694996736663;
        Sun, 17 Sep 2023 17:25:36 -0700 (PDT)
Received: from [10.72.113.158] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q8-20020a17090a178800b0026f39c90111sm6713718pja.20.2023.09.17.17.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Sep 2023 17:25:35 -0700 (PDT)
Message-ID: <246eda77-09c9-ae8a-996a-44d69fca84a4@redhat.com>
Date:   Mon, 18 Sep 2023 08:25:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: Annotate struct ceph_osd_request with __counted_by
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
References: <20230915201517.never.373-kees@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230915201517.never.373-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/16/23 04:15, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
>
> As found with Coccinelle[1], add __counted_by for struct ceph_osd_request.
>
> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: Xiubo Li <xiubli@redhat.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: ceph-devel@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   include/linux/ceph/osd_client.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index bf9823956758..b8610e9d2471 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -278,7 +278,7 @@ struct ceph_osd_request {
>   	int r_attempts;
>   	u32 r_map_dne_bound;
>   
> -	struct ceph_osd_req_op r_ops[];
> +	struct ceph_osd_req_op r_ops[] __counted_by(r_num_ops);
>   };
>   
>   struct ceph_request_redirect {

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thanks!

- Xiubo


