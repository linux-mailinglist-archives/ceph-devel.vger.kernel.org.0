Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7617753F33D
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 03:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbiFGBLa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 21:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbiFGBL3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 21:11:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AEF649C9A
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 18:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654564283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MWpKaK1y6zUB1Coaxjypijmg/v9jHES+CCmAVxY5res=;
        b=PO3Bsf0x1GzlC+GSure3z6h5EqL3vYcTWZAwaMpaU7yi0jsSILl2rkER9OZTPh1zOnBXae
        /D2Bf1dkiH/CALAvkE0QChB58VxDowPMl0MtgCXVaBLgpnql5g1Jb4tEQYz8RjTpT2gj3G
        vvAPyezuirWN0pvmJeQ8/qo5FbRtpI4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-v0I2hHTnNeK3ksby5jOxgw-1; Mon, 06 Jun 2022 21:11:22 -0400
X-MC-Unique: v0I2hHTnNeK3ksby5jOxgw-1
Received: by mail-pg1-f200.google.com with SMTP id h11-20020a65638b000000b003fad8e1cc9bso7765544pgv.2
        for <ceph-devel@vger.kernel.org>; Mon, 06 Jun 2022 18:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MWpKaK1y6zUB1Coaxjypijmg/v9jHES+CCmAVxY5res=;
        b=iVcA37BRwPBysnctj4kf7DIba6dG6j/4fqlp0J0tENEx+ikpKuYJCH6CB9zClHj+ot
         C6jJCXIvX99aNCbw2PWNt+LUYbal9SRulluGupNn140leALzIvPBGm7FUXqHfs+IaVwe
         nBkBDd4fxn1Qg6lOVWJAqe1B5iWro10DEywf55bZzV3/cZ8XU9ocZl+wxZzfTPLbMs+0
         G79pMtjgoxgsPqEX8p39g6UBwt4hVxOqdxC7bxQ8cM/7trUmI/kADcsKbGp6eETMjx9e
         HqWfeNRE7a+c3QLiShH3/M3jMRwSuY/4qdKG2wCVC5PBpSiYO61qARshOw9k4GeK+EEe
         yHkw==
X-Gm-Message-State: AOAM530VUOcX6RbiqXJMS0QFPp1WbDrvQPIwmQhbOtBMar5J//KOzEKp
        srFhaceEmS+XQKX+EARvdgwAX9rwgzONFU1aN8XhtcV4gpgfb4Nuy4tu+TOEH/uRUbxlSBd1e8o
        8YOpKEKJRaa9FD8H2Z4wjeLOwSh3tiCoV7sXaez1ImTT+Od0fpcbIz+7MTLzsLjspGSAAJCU=
X-Received: by 2002:a17:90a:1588:b0:1e0:a45c:5c1 with SMTP id m8-20020a17090a158800b001e0a45c05c1mr29885131pja.65.1654564281296;
        Mon, 06 Jun 2022 18:11:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKwjrkTo0nzW+lemGTyFsk8794a9Xmklq15G4XMtm6gXl5HzD/2j0Q83reQfNbSUbykMSxOw==
X-Received: by 2002:a17:90a:1588:b0:1e0:a45c:5c1 with SMTP id m8-20020a17090a158800b001e0a45c05c1mr29885104pja.65.1654564280968;
        Mon, 06 Jun 2022 18:11:20 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090340cc00b00166489ef8a4sm8385426pld.211.2022.06.06.18.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 18:11:19 -0700 (PDT)
Subject: Re: [PATCH] ceph: wait on async create before checking caps for
 syncfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220606233142.150457-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e0dac29b-f6e6-84bd-c548-06106e345554@redhat.com>
Date:   Tue, 7 Jun 2022 09:11:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220606233142.150457-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/7/22 7:31 AM, Jeff Layton wrote:
> Currently, we'll call ceph_check_caps, but if we're still waiting on the
> reply, we'll end up spinning around on the same inode in
> flush_dirty_session_caps. Wait for the async create reply before
> flushing caps.
>
> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
> URL: https://tracker.ceph.com/issues/55823
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c | 1 +
>   1 file changed, 1 insertion(+)
>
> I don't know if this will fix the tx queue stalls completely, but I
> haven't seen one with this patch in place. I think it makes sense on its
> own, either way.
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 0a48bf829671..5ecfff4b37c9 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
>   		ihold(inode);
>   		dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
>   		spin_unlock(&mdsc->cap_dirty_lock);
> +		ceph_wait_on_async_create(inode);
>   		ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
>   		iput(inode);
>   		spin_lock(&mdsc->cap_dirty_lock);

This looks good.

Possibly we can add one dedicated list to store the async creating 
inodes instead of getting stuck all the others ?

-- Xiubo


