Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF26724220
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 14:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbjFFMae (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 08:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbjFFMad (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 08:30:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A6A10CA
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 05:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686054589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CWyEio4K6bsbH2qJPjww7bqURttchoLvxs9PA3ubxgY=;
        b=RRXlQhTa5yxskvefServ/m8Oen+5+ZiWTwJRUWF2brDBxwz5CiBY/hPxviorg3LBsZkYRx
        oN32wh4Vt2dPUIo1fPvsAJtMhc+HG3DQwTQ2DZjgFsu+tHubAHa8GKID2IbJlDmBn18bgy
        J7ARHKt/8PJ6nk+FoXzc76ooX+roPPw=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-cercwoSRPzKhJQO9IucT-A-1; Tue, 06 Jun 2023 08:29:48 -0400
X-MC-Unique: cercwoSRPzKhJQO9IucT-A-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-53fa457686eso3919887a12.0
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jun 2023 05:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686054588; x=1688646588;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CWyEio4K6bsbH2qJPjww7bqURttchoLvxs9PA3ubxgY=;
        b=Sq7qlIuD0ZayKAHV0gvYRzxpdA7+3sZoph3N60dOqsEstiG+l4RwOE6rqijOgJS/8L
         K3nyMLItcNix3XI7NIbYl4/aRH8PmUFcs6W5eXScRDpHKE362td0hkTHono9QuJFXXxV
         3edW84bW3OfJsJkBaqlWABXqmb8fpQcSh2mc5IeOBdKLuOrsUXKH+9ApJLN7s3Az+EmC
         7eoyTx/e029qQONUcuz8ktjU+irGFI4erNU75MqRqX1iDJ/fku0pjTE4QtKLDUFHqb+S
         ioc4pktTka5eQGtWobjFCBm3kO3hXlYyv8jy/g2dm5pKgdz+waa5V8ndAwl/1Pkm3x34
         rd+g==
X-Gm-Message-State: AC+VfDy0+qH1lUIS/AYUK5iOiquHCIpKXB+mpqb8AaxpvpFq6DGcvynS
        kLp/6TBbwnDJxGKMMDiFCFO8N+x1srcafduXjjLpUawJOqDOuymtvgFp0YQHhsXV7lQ94feWlCt
        N7TVuS3wo/hvhTnVvPJHL4Q==
X-Received: by 2002:a17:903:11d0:b0:1b0:4a2:5928 with SMTP id q16-20020a17090311d000b001b004a25928mr12758476plh.8.1686054587868;
        Tue, 06 Jun 2023 05:29:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Yshgisfbro3BNAzGCz2Uj7YpVW57BTE406hG/m4CdieFs9uaGm+QGpiQXSQkjCx7mtdmYrA==
X-Received: by 2002:a17:903:11d0:b0:1b0:4a2:5928 with SMTP id q16-20020a17090311d000b001b004a25928mr12758465plh.8.1686054587608;
        Tue, 06 Jun 2023 05:29:47 -0700 (PDT)
Received: from [10.72.12.128] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902860700b001acad86ebc5sm8430931plo.33.2023.06.06.05.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 05:29:47 -0700 (PDT)
Message-ID: <7ab9007b-763b-aacf-2297-62f1989e2efd@redhat.com>
Date:   Tue, 6 Jun 2023 20:29:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 0/2] ceph: fix fscrypt_destroy_keyring use-after-free
 bug
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
References: <20230606033212.1068823-1-xiubli@redhat.com>
 <87pm689asx.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87pm689asx.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/6/23 17:53, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> V2:
>> - Improve the code by switching to wait_for_completion_killable_timeout()
>>    when umounting, at the same add one umount_timeout option.
> Instead of adding yet another (undocumented!) mount option, why not re-use
> the already existent 'mount_timeout' instead?  It's already defined and
> kept in 'struct ceph_options', and the default value is defined with the
> same value you're using, in CEPH_MOUNT_TIMEOUT_DEFAULT.

This is for mount purpose. Is that okay to use the in umount case ?

Thanks

- Xiubo

> Cheers,

