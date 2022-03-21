Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77884E21A1
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Mar 2022 08:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345069AbiCUH7G (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Mar 2022 03:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245531AbiCUH7F (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Mar 2022 03:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37874DD971
        for <ceph-devel@vger.kernel.org>; Mon, 21 Mar 2022 00:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647849459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vRN2KmfUcYyR2y6IhZh+giqwBKVc7dnEAAuiUs2n+NY=;
        b=WhsYz3ZiEIusD9kTBLKyGoBRLxORDUkkfiLIZGruywb01Z71JtoDJbr1yDDK37AVCbP0VR
        i1xESlr5CjDN6ZBdO7pudc1F493eGxPj7jpB3mHBkn4aFHH9LyRPgKlP+VPdQEH+gOqT5p
        74twvKBHXj0K9QWmEklZtYb4WV1Ixb4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-AYIdjvy_NOePO5wzp4hnzQ-1; Mon, 21 Mar 2022 03:57:38 -0400
X-MC-Unique: AYIdjvy_NOePO5wzp4hnzQ-1
Received: by mail-pf1-f200.google.com with SMTP id 138-20020a621690000000b004fa807ac59aso3514532pfw.19
        for <ceph-devel@vger.kernel.org>; Mon, 21 Mar 2022 00:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vRN2KmfUcYyR2y6IhZh+giqwBKVc7dnEAAuiUs2n+NY=;
        b=eMaUKCE0cZ26vEN2h8cdm0HOhmAN/pe/HwemBNQtNJvhIJEtvO5edd2nBU+KtzNATl
         HAOxv0UMdZZgclBZC1lCOs+vXqBsg4XgCrPW4ZhmcCGkgxx8NmoaotAlc3Pu64vnQ9hY
         2/1lFlabvhtDUyF2koNEQDjIBEwVddv8gxltnY34euQviAI9Fve9ksuKVCKsQq5khPHJ
         YLjkWXdQCpdRMZih0p6SUAv3WB0fqJ5ySASGTa9xCaZEuoQXJkz7AV2n8Lyj1DWWiRjz
         auap1Y8ZF43r8pElU3kaPY96IGL4/XF+UWnXRExijvY0zttmkdPckWk7tgROCcrSsFxR
         n7Lw==
X-Gm-Message-State: AOAM533Eu4aOmaYNsBnjFrBGkc6KxpCpUF1cncpx6U8wGUpwd6jvFASp
        e8nYJEWPJxlYJ49Y7vIUKHlnEjTK5IlGtvyBsKnRgHKbRWJEMwKHKfmTM803FOOnJ1pZkrR5ym3
        P21DHBsx04KeHcdz7TDdtwPUSrmTwrSAGtWZc4C891Qyw1x1cIjdp9pqWTBr4wUyek1lZc9k=
X-Received: by 2002:a17:902:f551:b0:153:b179:291a with SMTP id h17-20020a170902f55100b00153b179291amr11598489plf.13.1647849456484;
        Mon, 21 Mar 2022 00:57:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAeLW5bvdf4qrZ9o7rolskXPeLKolD4zXVM79eo8bT/2Kdc9ADMl8BCMN5AtjSiVG4eNSj5A==
X-Received: by 2002:a17:902:f551:b0:153:b179:291a with SMTP id h17-20020a170902f55100b00153b179291amr11598467plf.13.1647849456119;
        Mon, 21 Mar 2022 00:57:36 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a17-20020a17090a481100b001c6a662dd58sm9277352pjh.7.2022.03.21.00.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 00:57:35 -0700 (PDT)
Subject: Re: [PATCH v3 2/5] libceph: define struct ceph_sparse_extent and add
 some helpers
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
References: <20220318135013.43934-1-jlayton@kernel.org>
 <20220318135013.43934-3-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6895739a-8d02-3d04-f5ac-e0c50cea5f06@redhat.com>
Date:   Mon, 21 Mar 2022 15:57:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220318135013.43934-3-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/18/22 9:50 PM, Jeff Layton wrote:
> When the OSD sends back a sparse read reply, it contains an array of
> these structures. Define the structure and add a couple of helpers for
> dealing with them.
>
> Also add a place in struct ceph_osd_req_op to store the extent buffer,
> and code to free it if it's populated when the req is torn down.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   include/linux/ceph/osd_client.h | 31 ++++++++++++++++++++++++++++++-
>   net/ceph/osd_client.c           | 13 +++++++++++++
>   2 files changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 3122c1a3205f..00a5b53a6763 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -29,6 +29,17 @@ typedef void (*ceph_osdc_callback_t)(struct ceph_osd_request *);
>   
>   #define CEPH_HOMELESS_OSD	-1
>   
> +/*
> + * A single extent in a SPARSE_READ reply.
> + *
> + * Note that these come from the OSD as little-endian values. On BE arches,
> + * we convert them in-place after receipt.
> + */
> +struct ceph_sparse_extent {
> +	u64	off;
> +	u64	len;
> +} __attribute__((packed));
> +
>   /*
>    * A given osd we're communicating with.
>    *
> @@ -104,6 +115,8 @@ struct ceph_osd_req_op {
>   			u64 offset, length;
>   			u64 truncate_size;
>   			u32 truncate_seq;
> +			int sparse_ext_len;

To be more readable, how about

s/sparse_ext_len/sparse_ext_cnt/ ?

-- Xiubo

