Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676F453E618
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbiFFL6x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 07:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbiFFL6n (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 07:58:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 816A6283B57
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 04:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654516716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uApRl+thzEyBqexo1bDPboldYvFUEaIQE32eZL1LrNs=;
        b=UHpGRFCRXUJCbENboovQeAVlClVwwYW84pwkq19zA9ged0TCN96ZUsrQq7p22qEnhkItDE
        zQKfjjbNu9gJ28owviEAMpL8w0rhgOOoZiZCrQsUGa3g8ralPvDLlZqGNDujUHq1lRY1tN
        iMt8c6oUuQmJ9QzmQ3H88xjRaQQabiw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-PzcVZYm-MMWcJehP1V4eag-1; Mon, 06 Jun 2022 07:58:35 -0400
X-MC-Unique: PzcVZYm-MMWcJehP1V4eag-1
Received: by mail-pj1-f69.google.com with SMTP id mh12-20020a17090b4acc00b001e32eb45751so11957565pjb.9
        for <ceph-devel@vger.kernel.org>; Mon, 06 Jun 2022 04:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uApRl+thzEyBqexo1bDPboldYvFUEaIQE32eZL1LrNs=;
        b=PQsRnrpTpPZflO4blYnVDOBB6lxoD310AKxT/wvPOlMRQuloKpuL4ZbHNl6+ZEaWS4
         r5bog23QiA4lNDxIUockZzZRuaQ413kIWPJ3mOQo9MdDM4jda/RDYsoukwcljzalxnKZ
         EgR3jkjLKyDPJUQ/PrOQSyaNjyE29JZPRpY4Kaoeq2Zp39x8y7zRDT9ULATHqHgQuc99
         Lpgn7Uv+MOUMW6UM3c5jEqj3hIZ5uwcBIwUDWH6nZY+oSI5+y+Mtl+POBXJtxYvqgLpe
         SRH1cO9neb+CX2Wk/4bEYSC3CHCCZdE1rZ2qEI8Hncy7HMGvsbPJIYvVn8VJ4gvPyoF0
         sXnQ==
X-Gm-Message-State: AOAM530On/QlwqB8GKD5W9Hwh5YZ8JDD7l+qzUEVvG8V3kEPxizw7H62
        qhPVtLiUUepQn83QejDTDYgcNc1jpIV+TODJpwmHUHC8+yUsSw6Sn8oVPj+zuWUKkP0agplruz7
        SuPZURxagAo4suJelbFaPsFDg+zNcCE49fUXbUwQVi4wXjisl++HUIT8stGEg3h5G0/wtJTo=
X-Received: by 2002:a63:f011:0:b0:3fb:c86f:821e with SMTP id k17-20020a63f011000000b003fbc86f821emr21300957pgh.217.1654516713954;
        Mon, 06 Jun 2022 04:58:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKcqh3kY1WqhOffk2WkNwqZy4sZq1kP4hbGWL7G0fWbcBSriwgoKhmCi+0ctIMWNjqwwgioQ==
X-Received: by 2002:a63:f011:0:b0:3fb:c86f:821e with SMTP id k17-20020a63f011000000b003fbc86f821emr21300928pgh.217.1654516713562;
        Mon, 06 Jun 2022 04:58:33 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i4-20020aa787c4000000b0051bc581b62asm8507699pfo.121.2022.06.06.04.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 04:58:33 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't leak snap_rwsem in handle_cap_grant
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220603203957.55337-1-jlayton@kernel.org>
 <87fski2j89.fsf@brahms.olymp>
 <9a484d2b73dc18b37da2ad2b770d15681057cb18.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2655cad0-dd20-6d50-cc63-89c4fd4473a7@redhat.com>
Date:   Mon, 6 Jun 2022 19:58:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9a484d2b73dc18b37da2ad2b770d15681057cb18.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
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


On 6/6/22 6:36 PM, Jeff Layton wrote:
> On Mon, 2022-06-06 at 11:12 +0100, Luís Henriques wrote:
>> Jeff Layton <jlayton@kernel.org> writes:
>>
>>> When handle_cap_grant is called on an IMPORT op, then the snap_rwsem is
>>> held and the function is expected to release it before returning. It
>>> currently fails to do that in all cases which could lead to a deadlock.
>>>
>>> URL: https://tracker.ceph.com/issues/55857
>> This looks good.  Maybe it could have here a 'Fixes: e8a4d26771547'.
>> Otherwise:
>>
>> Reviewed-by: Luís Henriques <lhenriques@suse.de>
>>
>> Cheers,
> Thanks,
>
> Actually, I think this got broken in 6f05b30ea063a2 (ceph: reset
> i_requested_max_size if file write is not wanted).

Have updated it.

-- Xiubo


> The problem is the && part of the condition. We need to release the
> rwsem regardless of whether ci->i_auth_cap == cap.

