Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B8450613D
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Apr 2022 03:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbiDSBEl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 21:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiDSBEk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 21:04:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72F71286F0
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 18:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650330118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FYkrKfNIBLQtS3HbxIo7id1W7oCKSJTgQzWZrffF/J4=;
        b=LqhF7dsJ/v568I4wqqNVJ6/9KS5a7hIJ5mfJyltV631an3Q10egY7lrMdPErCvxAlKQGPe
        bZCQQMDL7kZTeToqBzzDvvMtLh/sn0cAfcQmIL4OZ5CJWmgJkCkVP7AM23f3ZlE1g2fBf7
        B3sMaHTIq9ykn2GC6q53INsvNs1ahek=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-nKTcgktLOmCVSY6082kfbw-1; Mon, 18 Apr 2022 21:01:57 -0400
X-MC-Unique: nKTcgktLOmCVSY6082kfbw-1
Received: by mail-pj1-f69.google.com with SMTP id oj16-20020a17090b4d9000b001c7552b7546so573779pjb.8
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 18:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FYkrKfNIBLQtS3HbxIo7id1W7oCKSJTgQzWZrffF/J4=;
        b=WdkTm3bX4EU0HiRypgsRoe6OF5kdNihTe8n+VAA6E8SUYmiI/XY+X/iT9DP8up5wMB
         JEDgorct1KxvVwRRHlFqTIEUIcp7BSVvoigtqHYVrDMB+hB//6BRTpbWoWE4CvIKpwkQ
         nS4NJ0UXdNh0/zHxEa2yaXhYjHUt0Hxs8Cgyo1k1yqKfbaTjwfUuIGTHAUltNUkUVIMh
         HZMoW7swV6cBCbFKRkD+0ng/CXltCnumkXTmQxs8TyP/P9MivSkJx8qqJiLFD1yfZG1F
         /3SR24YRU2J0TiEspcDVUOCXgOyZVKdahT16ix0JO+LGxH4UMU7r+NoM536VZfCPLI8Z
         0W5g==
X-Gm-Message-State: AOAM532QYWWI+Djujw7hOz7rGoVv7oi57q73Uj4kMKk87cU8rPytdYZX
        4BJIgsorvupVhc1/B7BVErGf7FdpYDWvsakD5hHUDgxisDU28e6f1vebZx63JP+QRbIID/FrSsQ
        mfvR8CJ18dit8h9b0L/LtBgBBC//4mzogL30pvvkWfTyLGgbMb5TVc60F16f77uDYljtf+RY=
X-Received: by 2002:aa7:86cf:0:b0:506:cd1:34a2 with SMTP id h15-20020aa786cf000000b005060cd134a2mr15321502pfo.5.1650330116135;
        Mon, 18 Apr 2022 18:01:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwIwy4Y/Rk9NSkd3Uq++dCqBFA9MUicgJD3Kc+uZ6xCZWPj7hdyDLeaDGCsv7RW6NPpy4ZHw==
X-Received: by 2002:aa7:86cf:0:b0:506:cd1:34a2 with SMTP id h15-20020aa786cf000000b005060cd134a2mr15321461pfo.5.1650330115778;
        Mon, 18 Apr 2022 18:01:55 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v17-20020aa78511000000b0050609c2438esm13626232pfn.57.2022.04.18.18.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 18:01:55 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: fix possible NULL pointer dereference for
 req->r_session
To:     Aaron Tomlin <atomlin@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220418014440.573533-1-xiubli@redhat.com>
 <20220418104318.4fb3jpdgnhje4b5d@ava.usersys.com>
 <53d24ea4-554b-2df3-e4ee-6761f6ae5c8e@redhat.com>
 <20220418144554.i7m6omhtulb2nq22@ava.usersys.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7a636228-263a-248c-cb41-a1872acd28f1@redhat.com>
Date:   Tue, 19 Apr 2022 09:01:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220418144554.i7m6omhtulb2nq22@ava.usersys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/18/22 10:45 PM, Aaron Tomlin wrote:
> On Mon 2022-04-18 18:52 +0800, Xiubo Li wrote:
>> Hi Aaron,
> Hi Xiubo,
>
>> Thanks very much for you testing.
> No problem!
>
>> BTW, did you test this by using Livepatch or something else ?
> I mostly followed your suggestion here [1] by modifying/or patching the
> kernel to increase the race window so that unsafe_request_wait() may more
> reliably see a newly registered request with an unprepared session pointer
> i.e. 'req->r_session == NULL'.
>
> Indeed, with this patch we simply skip such a request while traversing the
> Ceph inode's unsafe directory list in the context of unsafe_request_wait().

Okay, cool.

Thanks again for your help Aaron :-)

-- Xiubo


> [1]: https://tracker.ceph.com/issues/55329
>
> Kind regards,
>

