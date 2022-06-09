Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8085441DB
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 05:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiFIDTH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 23:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiFIDTH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 23:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96D38DF01
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 20:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654744740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WAZNZhPUbrfRJfm2uZbPeSoBDc5f0RrM1an0rkAiYhY=;
        b=C3jb+Bv1YxrEyCwnHLUeGJ2UVIhXs6qrhwxmx1/vwGk2qmhA/bjcAqtqOiJ7mxITIu77AD
        Cy1KLagwSxs8V2s78DaRIgs/Udld6XMQ7lcWzYsGADDb1veDsJe8gNvtEC3vazsNn/LAZP
        PgxUrpKLWYaeAZ0yZsJWnBxVtgGb4hI=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-Wk6YQFDIOh6Hc6U0HKaaFQ-1; Wed, 08 Jun 2022 23:18:59 -0400
X-MC-Unique: Wk6YQFDIOh6Hc6U0HKaaFQ-1
Received: by mail-pg1-f198.google.com with SMTP id 15-20020a63020f000000b003fca9ebc5cbso10865726pgc.22
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 20:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WAZNZhPUbrfRJfm2uZbPeSoBDc5f0RrM1an0rkAiYhY=;
        b=1r7ClWKiGw596OTAh8kmCsu3/VErQxqlAFU2zZzfEumZu2HjVmjaMfMX0O92QCQqDQ
         VEwO6hXzNjxDpnyDKh+SBTynFvLQkjweVnElV7bRdrsP2S1WepAJF7iW87fL+WJjSgUy
         UVdnViHvJkKKCBCheTTiuAD+yAmlLdDqRZYkxoJ1WJnClrmS+PuN7LVRTg6ZMMCvkVvM
         xKWhrXOuZWGrCqagkTXZz2+DZHJ533loqXotnRYHOcnNcAfulMTr2Ilx5cuFCXeuJo5N
         6hThocDaviiuAgejnqGMs4fckgVmJE5iINuM2zHBtTArncIoTCTXIP5HJUlIFpWFueXg
         E4Xg==
X-Gm-Message-State: AOAM533VAtOP71FXK3mj1cudVpCzhXy3SlQOVOGrcPImVRnRcScbpfO1
        1oIxXelA1KgDteMXlPXqloDXgLLC8y7XDANL8W8CaILhiAYjTYSYI9dEQcNWMMSOGNLkSVYMF12
        FpFr/xOVTtILFEsIxqn3h4SVPGtLJCjiOjt9QZJk2/k+QqE+nST8BnQRs1MDkkdqDhn0nM7Q=
X-Received: by 2002:a17:90b:38c2:b0:1e8:747f:a13b with SMTP id nn2-20020a17090b38c200b001e8747fa13bmr1222041pjb.166.1654744738027;
        Wed, 08 Jun 2022 20:18:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGVJ9OehhDgWNQh/XQZMeRG9rlT6osocl609+3DlRzADIvpD5HrFW1nKr/vLVex9eA0K2WCA==
X-Received: by 2002:a17:90b:38c2:b0:1e8:747f:a13b with SMTP id nn2-20020a17090b38c200b001e8747fa13bmr1222022pjb.166.1654744737681;
        Wed, 08 Jun 2022 20:18:57 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cp9-20020a056a00348900b0051c15bb876esm7792777pfb.174.2022.06.08.20.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 20:18:56 -0700 (PDT)
Subject: Re: [PATCH] ceph: wait on async create before checking caps for
 syncfs
To:     "Yan, Zheng" <ukernel@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20220606233142.150457-1-jlayton@kernel.org>
 <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <eaa4e405-d7a5-7cf2-d9e2-4cce55f3c1f9@redhat.com>
Date:   Thu, 9 Jun 2022 11:18:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/9/22 10:15 AM, Yan, Zheng wrote:
> The recent series of patches that add "wait on async xxxx" at various
> places do not seem correct. The correct fix should make mds avoid any
> wait when handling async requests.
>
In this case I am thinking what will happen if the async create request 
is deferred, then the cap flush related request should fail to find the 
ino.

Should we wait ? Then how to distinguish from migrating a subtree and a 
deferred async create cases ?


> On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
>> Currently, we'll call ceph_check_caps, but if we're still waiting on the
>> reply, we'll end up spinning around on the same inode in
>> flush_dirty_session_caps. Wait for the async create reply before
>> flushing caps.
>>
>> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
>> URL: https://tracker.ceph.com/issues/55823
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>   fs/ceph/caps.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> I don't know if this will fix the tx queue stalls completely, but I
>> haven't seen one with this patch in place. I think it makes sense on its
>> own, either way.
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 0a48bf829671..5ecfff4b37c9 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
>>                  ihold(inode);
>>                  dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
>>                  spin_unlock(&mdsc->cap_dirty_lock);
>> +               ceph_wait_on_async_create(inode);
>>                  ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
>>                  iput(inode);
>>                  spin_lock(&mdsc->cap_dirty_lock);
>> --
>> 2.36.1
>>

