Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F056E1B0F
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Apr 2023 06:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjDNE3W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Apr 2023 00:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjDNE3U (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Apr 2023 00:29:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F8844B2
        for <ceph-devel@vger.kernel.org>; Thu, 13 Apr 2023 21:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681446512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nupoZ/NBqH5ZbvoXope7ANgV6bto6D/JxRLpEXNNT/E=;
        b=Sz8VQ4H012EklriQyYA5FdUHUHvQRvQXYGJJE3/IBrV704hjhumuB82z+LWX22BziDLLWQ
        F7JugfKHIulDHrpv05SgJOcrYM2d9vDpTBDP+BrQpy1d0sjQI5GPJ1xpNKuRjkWAkQQXEX
        TJE6GWvIqgPSTVueHOERq6A6RQpz76o=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-fhpXLT6VPFq9R_bLehAG6Q-1; Fri, 14 Apr 2023 00:28:31 -0400
X-MC-Unique: fhpXLT6VPFq9R_bLehAG6Q-1
Received: by mail-pg1-f198.google.com with SMTP id k191-20020a6384c8000000b0051b6cf91f74so432481pgd.2
        for <ceph-devel@vger.kernel.org>; Thu, 13 Apr 2023 21:28:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681446510; x=1684038510;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nupoZ/NBqH5ZbvoXope7ANgV6bto6D/JxRLpEXNNT/E=;
        b=MarOxKZ3qBrHFWO66QfgUFoWgkdlx2tJ4VxidGy/fxN/WDofNnpus0PVyTGgADVC6A
         9/1XDUrsJg8tj///z8Dqpto1NxwhIp4+iAb1e/bcNK1vvfYifbT5uYOWMQMGHuUnSMdm
         ww0nI7UcCV1Rd+XG+zZpWTBgyls1tcSlM/7N2pO7IDdJD5nxsBuJbflosGLajMVx7MK+
         Vksokph4xEP+aBEJYIVMCF+H+P9FQVGWjRRdlu2hJ8hfkyQ3c8GVaVM6gbfnhnY6jKI7
         oxUbdV+OQiAW8NABbLLbmjgLAZ2BlxCRbdN26rm10VfyLMsGru5oeerYLl0XPAkZtyM0
         5tLQ==
X-Gm-Message-State: AAQBX9dEXogXOApO/huzq075XonegtF1unjuW8ouiY/BUrj/YQffYevK
        LNnbEeC9ZYLT/VDrOq9USCeT6ivOo9fBrWXb/hOpp0pTA4l0Xe16ZXfnyBFe1VlMe9a1zda/tqo
        htyRM3eIlyIFVnsCoGq0RpA==
X-Received: by 2002:a17:90a:4598:b0:247:471:143b with SMTP id v24-20020a17090a459800b002470471143bmr4015600pjg.26.1681446510156;
        Thu, 13 Apr 2023 21:28:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350bdpV+1o2F1sLfVCVTgt5LjrBPEPywyWBSeporUhxdEiBKvEAB6qhYC8dfDOKcsaQ84ctwU7w==
X-Received: by 2002:a17:90a:4598:b0:247:471:143b with SMTP id v24-20020a17090a459800b002470471143bmr4015590pjg.26.1681446509881;
        Thu, 13 Apr 2023 21:28:29 -0700 (PDT)
Received: from [10.72.12.157] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r10-20020a63d90a000000b0051b72ef978fsm183355pgg.20.2023.04.13.21.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 21:28:29 -0700 (PDT)
Message-ID: <9cfedcd7-f7f8-60b2-e362-872b29e387de@redhat.com>
Date:   Fri, 14 Apr 2023 12:28:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] ceph: do not touch cap when trimming the caps
Content-Language: en-US
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        stable@vger.kernel.org
References: <20230414024123.263120-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230414024123.263120-1-xiubli@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/14/23 10:41, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> When trimming the caps it maybe queued to release in the next loop,
> and just after the 'session->s_cap_lock' lock is released the
> 'session->s_cap_iterator' will be set to NULL and the cap also has
> been removed from 'session->s_caps' list, then the '__touch_cap()'
> could continue and add the cap back to the 'session->s_caps' list.
>
> That means this cap could be iterated twice to call 'trim_caps_cb()'
> and the second time will trigger use-after-free bug.
>
> Cc: stable@vger.kernel.org
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2186264
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/caps.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index cf29e395af23..186c9818ab0d 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -846,7 +846,7 @@ static void __touch_cap(struct ceph_cap *cap)
>   	struct ceph_mds_session *s = cap->session;
>   
>   	spin_lock(&s->s_cap_lock);
> -	if (!s->s_cap_iterator) {
> +	if (!s->s_cap_iterator && !list_empty(&cap->session_caps) && !cap->queue_release) {

Comment it myself.

The s_cap_iterator will always be true during trimming the caps. So this 
check here is incorrect.

>   		dout("__touch_cap %p cap %p mds%d\n", &cap->ci->netfs.inode, cap,
>   		     s->s_mds);
>   		list_move_tail(&cap->session_caps, &s->s_caps);

