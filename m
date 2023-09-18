Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025037A45EB
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Sep 2023 11:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbjIRJaZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Sep 2023 05:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240916AbjIRJaO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Sep 2023 05:30:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2DE10F
        for <ceph-devel@vger.kernel.org>; Mon, 18 Sep 2023 02:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695029362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kFohnrp4LZIXdlKJ3yigY2HhFEsskl2+KbH3E1NV224=;
        b=E7nD93ZdLMihEMng0LdfQSo8g8m2ZaIAWvK0MSmpUscO1xquzSdHMihCWBopyPRU2vWdM1
        QkU8jCif4ykgBKhaW/qvKPaJvPKk5BntZ6c8mRvJHoiMW4myQ42AQKIKfXSOgHFFLJ1IA3
        yVthYeIX9ZumC2YHK6R6NUdHtuq7jZo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-SfHOYvH_MCyeckT7FJ9YPw-1; Mon, 18 Sep 2023 05:29:19 -0400
X-MC-Unique: SfHOYvH_MCyeckT7FJ9YPw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-68fc6f92088so4722951b3a.3
        for <ceph-devel@vger.kernel.org>; Mon, 18 Sep 2023 02:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695029358; x=1695634158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kFohnrp4LZIXdlKJ3yigY2HhFEsskl2+KbH3E1NV224=;
        b=wNBbD4NjHC4GioTMgUzix4JO5tdZDp4CCmWkXId4eWbPq2L/Fd1fy6T+WfhCo2fUcR
         JFJtHBfVA6dMysmQBbtnGCmwWc/KUvwQ7oxnqbxLNor8zQ53mtG0s3QZP9EBMR4Kz02R
         FAIquM46i4IsXbexSEiZgK/adLTNGHDk27WVtpTLmzakL6R5lKWaM7/hR+zZ0fuvntnM
         qn73XWKtEqEZBST2e9RpBzJjkEIVzcmhyv+/4oBJzQLvLiu3HvXyxjFk2/ne9p3Jrale
         25MdZzy5GgPV5Y4IQye765CGRr8w34/LV8ZIeS2HLUNW9C1WYu+8nNLyCZlSjf2am/Mt
         J1Og==
X-Gm-Message-State: AOJu0YzkIuAn92zIWfrXW/uYbUzKFXrHxhEhYNGs8leBgNhZocyO/wME
        rWBy6vUQnjYi0QFXpwW973fg7FJnxL81Yd9NWBUDridYofkKPkZhrpkAQkU34frhrIxG1O4luM+
        BGv8i8eR0s+7+0dczOgu60RFHkmSwpZ2w
X-Received: by 2002:a05:6a20:1602:b0:15a:3b83:24d1 with SMTP id l2-20020a056a20160200b0015a3b8324d1mr12278002pzj.18.1695029358258;
        Mon, 18 Sep 2023 02:29:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZVvmfydvPkS9tcXtsLlBEk+zr8eeiKA5AejHbKH7748WguCbHR58bPOZ/3iMbUCXDQDiE/w==
X-Received: by 2002:a05:6a20:1602:b0:15a:3b83:24d1 with SMTP id l2-20020a056a20160200b0015a3b8324d1mr12277990pzj.18.1695029357938;
        Mon, 18 Sep 2023 02:29:17 -0700 (PDT)
Received: from [10.72.113.158] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902968300b001bdc5023783sm7942628plp.179.2023.09.18.02.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 02:29:17 -0700 (PDT)
Message-ID: <bbc7d840-ae5a-8520-10b9-5b717813dd2a@redhat.com>
Date:   Mon, 18 Sep 2023 17:29:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] Revert "ceph: make members in struct
 ceph_mds_request_args_ext a union"
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
References: <20230918085509.55682-1-idryomov@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230918085509.55682-1-idryomov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/18/23 16:55, Ilya Dryomov wrote:
> This reverts commit 3af5ae22030cb59fab4fba35f5a2b62f47e14df9.
>
> ceph_mds_request_args_ext was already (and remains to be) a union.  An
> additional anonymous union inside is bogus:
>
>      union ceph_mds_request_args_ext {
>          union {
>              union ceph_mds_request_args old;
>              struct { ... } __attribute__ ((packed)) setattr_ext;
>          };
>      }
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   include/linux/ceph/ceph_fs.h | 24 +++++++++++-------------
>   1 file changed, 11 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 5f2301ee88bc..f3b3593254b9 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -467,19 +467,17 @@ union ceph_mds_request_args {
>   } __attribute__ ((packed));
>   
>   union ceph_mds_request_args_ext {
> -	union {
> -		union ceph_mds_request_args old;
> -		struct {
> -			__le32 mode;
> -			__le32 uid;
> -			__le32 gid;
> -			struct ceph_timespec mtime;
> -			struct ceph_timespec atime;
> -			__le64 size, old_size;       /* old_size needed by truncate */
> -			__le32 mask;                 /* CEPH_SETATTR_* */
> -			struct ceph_timespec btime;
> -		} __attribute__ ((packed)) setattr_ext;
> -	};
> +	union ceph_mds_request_args old;
> +	struct {
> +		__le32 mode;
> +		__le32 uid;
> +		__le32 gid;
> +		struct ceph_timespec mtime;
> +		struct ceph_timespec atime;
> +		__le64 size, old_size;       /* old_size needed by truncate */
> +		__le32 mask;                 /* CEPH_SETATTR_* */
> +		struct ceph_timespec btime;
> +	} __attribute__ ((packed)) setattr_ext;
>   };
>   
>   #define CEPH_MDS_FLAG_REPLAY		1 /* this is a replayed op */

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thanks

- Xiubo

