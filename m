Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9614BE89F
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Feb 2022 19:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358155AbiBUMmS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Feb 2022 07:42:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358149AbiBUMmQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Feb 2022 07:42:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9E072AC
        for <ceph-devel@vger.kernel.org>; Mon, 21 Feb 2022 04:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645447310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UqKSpF/0x5FUr09ncMNQfHwtam50fj836iFjBHW0IfQ=;
        b=ebvGiMjbU4SOAoxZiz/tUxFvdLdpg39oO6ehlJdhZ3UmH7ehT5mIhVm6DrPCMSd3uz3vZX
        +WRWyo5s9An3EsZmcD0b4deijFEgKkWL8FVale5apQ72RoTXLUwqZp9CKHHQ3suas7q49o
        hZs4Wd0fRdKYWxa3nJgD0kme//RRbsI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-zgqXnJ5COsGoXljluZ1XfQ-1; Mon, 21 Feb 2022 07:41:49 -0500
X-MC-Unique: zgqXnJ5COsGoXljluZ1XfQ-1
Received: by mail-pj1-f72.google.com with SMTP id y15-20020a17090a390f00b001b9fde42fd4so14308351pjb.0
        for <ceph-devel@vger.kernel.org>; Mon, 21 Feb 2022 04:41:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UqKSpF/0x5FUr09ncMNQfHwtam50fj836iFjBHW0IfQ=;
        b=8DzeQWoRlYrrEo/HoQ58vamkA1ZUE1ri2VeSPPSIPu/IKVPwU942rsNvEDnNqi0RkV
         fIEr90xcOkhGKpdWl3u7uAPxvKp4aPBfss0jpKhIDMw9D60R92dPLm+H7Pu8LZG8lwTa
         /xGtjYpFsoQofe9CAUKfwO1ptNrUmbVHC/JMx92uj5gHZszSBzmmdP8pBYjzIUnmhc1S
         jp9V7QpqPI9hTKmNiA/lmegyJZVIhbLzTF1G1qlvcRU8YK/K+pXrrJdMPyx64GsjTIxe
         eYLGOh5gYrYry9BcrP1vyOudm2cQasYKn8taxLOd2sV+9OR3WdXT4An/tJLa//nH28EI
         G7FA==
X-Gm-Message-State: AOAM531G71RXvtPBqk/tzgwCVneKjFh91xS0pHOxM95w7Gk5sG0hVgIP
        gaHagv8DBpgBijbfor7QI2ERqHmPoPWb72YF+OWFhGb8Po+r60C+pYB7jkpwDQmjvdXg76WxGRX
        LXoD+wmxjtDLqv3kMG0niDw==
X-Received: by 2002:a05:6a02:184:b0:373:a24e:5ab with SMTP id bj4-20020a056a02018400b00373a24e05abmr16169529pgb.400.1645447307964;
        Mon, 21 Feb 2022 04:41:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxofLfNvubUQrBahPgQwNLVlNtZrvHtt1xlKEsAOXAqNbvUPKoEZT0Q5LrsvyIB6sPef5RPnw==
X-Received: by 2002:a05:6a02:184:b0:373:a24e:5ab with SMTP id bj4-20020a056a02018400b00373a24e05abmr16169511pgb.400.1645447307699;
        Mon, 21 Feb 2022 04:41:47 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f3sm13038962pfe.137.2022.02.21.04.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 04:41:47 -0800 (PST)
Subject: Re: [PATCH] MAINTAINERS: add Xiubo Li as cephfs co-maintainer
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, linux-fsdevel@vger.kernel.org
References: <20220221121515.10443-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3747040a-058f-5c0f-fd20-77f3f02a5d93@redhat.com>
Date:   Mon, 21 Feb 2022 20:41:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220221121515.10443-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/21/22 8:15 PM, Jeff Layton wrote:
> Xiubo has been doing stellar kernel work lately, and has graciously
> volunteered to help with maintainer duties. Add him on as co-maintainer
> in for ceph.ko and libceph.ko.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   MAINTAINERS | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f41088418aae..cee5ffb6061f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4443,6 +4443,7 @@ F:	drivers/power/supply/cw2015_battery.c
>   CEPH COMMON CODE (LIBCEPH)
>   M:	Ilya Dryomov <idryomov@gmail.com>
>   M:	Jeff Layton <jlayton@kernel.org>
> +M:	Xiubo Li <xiubli@redhat.com>
>   L:	ceph-devel@vger.kernel.org
>   S:	Supported
>   W:	http://ceph.com/
> @@ -4453,6 +4454,7 @@ F:	net/ceph/
>   
>   CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
>   M:	Jeff Layton <jlayton@kernel.org>
> +M:	Xiubo Li <xiubli@redhat.com>
>   M:	Ilya Dryomov <idryomov@gmail.com>
>   L:	ceph-devel@vger.kernel.org
>   S:	Supported

Acked-by: Xiubo Li <xiubli@redhat.com>


