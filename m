Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECF352A069
	for <lists+ceph-devel@lfdr.de>; Tue, 17 May 2022 13:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345199AbiEQL32 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 May 2022 07:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiEQL31 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 May 2022 07:29:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A84B4BFC4
        for <ceph-devel@vger.kernel.org>; Tue, 17 May 2022 04:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652786966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fh0sLEHArFkZ82ul9WkaxvPGqdwNxMPYPt+FnDmvd5Y=;
        b=REMANsrP0TOBNuom4kmFFPBsHOrlsD1JWvbLuWD9LI4MvkN87NCBPPnMeGBlo1+i0pxGrL
        5KF7s+KIsEabsuvCVGjUZ+eclbA6VJzL4L7K10GvK7n73lo592T1P8he9mAH3lN4sDmq2y
        cuFYixoq1JEyBYwn0UnG6ebB6GQKf/A=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-qQiYxmdWMvSO8G2OGo4GNw-1; Tue, 17 May 2022 07:29:24 -0400
X-MC-Unique: qQiYxmdWMvSO8G2OGo4GNw-1
Received: by mail-pj1-f70.google.com with SMTP id oj9-20020a17090b4d8900b001df6cd6813cso1306728pjb.9
        for <ceph-devel@vger.kernel.org>; Tue, 17 May 2022 04:29:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Fh0sLEHArFkZ82ul9WkaxvPGqdwNxMPYPt+FnDmvd5Y=;
        b=qdndRT/XqsiBO9IRHubSJby86UvIjzPf26SL3pUmiKO9xGiNSiuUSsNK3hWwVSwELb
         mRAm4BJvACzPDLmpQSQCqNUUYIfaucvk9LthjUbFU8p2gS4IYTuaYg1KOXT865nVUmnH
         6/ikfXXn5leQ7XFFO5lOY2mw2M6S7zY6HhTyr4q4FmADb4nGeIkJjjSO7EZ6YeXACEDK
         7FQMpeyq70pLFEY0FlOTdTL83ShE7AJOeTWRL0703H/93WkETtDFdoLVIJDbpofspOW1
         NQKO9+aA9TumRcVvaNrsYifIYQSnWkKCxe6aIA4FYEA4obuDCj8VMxxiv453ubaGxnjC
         AAkw==
X-Gm-Message-State: AOAM530hSxmWJ3AVtAJbNFDcPIHKFhjZf/BrHr70+hvKJ4VPOSDCwI6z
        9MAEtMVMaDLtWmsb4Rp0nszyF6snjAXtuYvbrWv1eMmO2YQOxleuMCj6UCcdpcB6LejWqiQRHd2
        U8SLuglydug+SuqtOD9hV/w==
X-Received: by 2002:a63:f450:0:b0:3f2:6670:2092 with SMTP id p16-20020a63f450000000b003f266702092mr9270297pgk.488.1652786963600;
        Tue, 17 May 2022 04:29:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxY/YTMmGj6+cfFceWunCAiidekceAaVMbHZufJ6qX+flwcpMqLbN+UuZ0MM5NnLgx7uhdMTg==
X-Received: by 2002:a63:f450:0:b0:3f2:6670:2092 with SMTP id p16-20020a63f450000000b003f266702092mr9270286pgk.488.1652786963409;
        Tue, 17 May 2022 04:29:23 -0700 (PDT)
Received: from [10.72.12.136] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fv9-20020a17090b0e8900b001d953eb2412sm1516441pjb.19.2022.05.17.04.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 04:29:22 -0700 (PDT)
Subject: Re: [PATCH] libceph: fix misleading ceph_osdc_cancel_request()
 comment
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
References: <20220517095534.15288-1-idryomov@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <bf8afc00-9fe4-a837-cf13-7e4ff93254a4@redhat.com>
Date:   Tue, 17 May 2022 19:29:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220517095534.15288-1-idryomov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/17/22 5:55 PM, Ilya Dryomov wrote:
> cancel_request() never guaranteed that after its return the OSD
> client would be completely done with the OSD request.  The callback
> (if specified) can still be invoked and a ref can still be held.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   net/ceph/osd_client.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 4b88f2a4a6e2..9d82bb42e958 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -4591,8 +4591,13 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
>   EXPORT_SYMBOL(ceph_osdc_start_request);
>   
>   /*
> - * Unregister a registered request.  The request is not completed:
> - * ->r_result isn't set and __complete_request() isn't called.
> + * Unregister request.  If @req was registered, it isn't completed:
> + * r_result isn't set and __complete_request() isn't invoked.
> + *
> + * If @req wasn't registered, this call may have raced with
> + * handle_reply(), in which case r_result would already be set and
> + * __complete_request() would be getting invoked, possibly even
> + * concurrently with this call.
>    */
>   void ceph_osdc_cancel_request(struct ceph_osd_request *req)
>   {

Reviewed-by: Xiubo Li <xiubli@redhat.com>


