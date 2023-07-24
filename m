Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F04375F632
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jul 2023 14:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjGXMVh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jul 2023 08:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjGXMVe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jul 2023 08:21:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AD91FFE
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 05:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690201225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=16bws0qf1eK2snTxL0KnDiIJKu7INDftZkzK6rYqevI=;
        b=cWir4y1pHT2+QeQB5sAUb2DFCK7M+xOOWLT9TKVHgk3FWu7eHgLmGqatJezJ+u6k3KD2Bz
        rMJA/nHHetmHjvHtFBSofpIXEalf9VAfYsut67iFax6mKruWPL6zrU+QQZikXWovCLJW4B
        jdjhxibw0ZvIbkszrvTFqIU2ttIOSKY=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-GtamXwuWMa-B-rxLaMiq7A-1; Mon, 24 Jul 2023 08:20:24 -0400
X-MC-Unique: GtamXwuWMa-B-rxLaMiq7A-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-348c7a1eb9cso4806205ab.3
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 05:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690201223; x=1690806023;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=16bws0qf1eK2snTxL0KnDiIJKu7INDftZkzK6rYqevI=;
        b=Tor/VrD4HOm+pxLB/8fRCpBzBDsRYOYR7YII/RJ+cGRPqB7FleFhUir7dZEHKCzFEH
         XQZlkQ+2T2X9bFYq2Sd60M4X3aurRbDLL5KGDANDCMINvj1ByCjRhWYVaD+mis7FRzS3
         zOnP7PMpIZSE+MTxUkmVCtsmw/p39zb+VoE63Otcc3ikNdTWymtgiSLP8R3xwPs1rjl1
         BkojY6cDcFp/x0G/RABM3cRktBB832m0vkPl7eG5E0j+SJJnAn+smCvqQ1Z3XfThfof7
         TGN2jltcPaKbHJ7tBkew8Cq7DDFnxP/mi9PL+E7wPK1MymQ1Jlg1WdSHpkUlldm5uZgZ
         DbyQ==
X-Gm-Message-State: ABy/qLYUoOecnYrQjKWfC+xWoxn1bywkDn8S/whxSxmN+2ob9OO6+FOw
        au28nNwlHExYVmtjdrmDbkJrB/HPc5not8BOF0o8aOGFveKluifrWxzvheyemQUl6gE/tdUZFj0
        dX9z7v2fiCO25eBqj4XCe3w==
X-Received: by 2002:a05:6e02:216f:b0:346:3eec:c893 with SMTP id s15-20020a056e02216f00b003463eecc893mr7136115ilv.0.1690201223483;
        Mon, 24 Jul 2023 05:20:23 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHeMG/0a9FLNlW+LgYiPQNwIEt1/4XxnmoP0bUKH6yFHLYejFMH9HiYHC4gU5puuW6vSpgAjw==
X-Received: by 2002:a05:6e02:216f:b0:346:3eec:c893 with SMTP id s15-20020a056e02216f00b003463eecc893mr7136102ilv.0.1690201223234;
        Mon, 24 Jul 2023 05:20:23 -0700 (PDT)
Received: from [10.72.12.127] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2-20020a17090a6f0200b00256799877ffsm1371157pjk.47.2023.07.24.05.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 05:20:22 -0700 (PDT)
Message-ID: <e28b9ea0-a62c-5aae-50d0-bc092675e20d@redhat.com>
Date:   Mon, 24 Jul 2023 20:20:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] ceph: defer stopping the mdsc delayed_work
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230724084214.321005-1-xiubli@redhat.com>
 <CAOi1vP9Yygpavo8fS=Tz8YGeQJ7Wmieo=14+HS20+MSMErb79A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9Yygpavo8fS=Tz8YGeQJ7Wmieo=14+HS20+MSMErb79A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/24/23 19:12, Ilya Dryomov wrote:
> On Mon, Jul 24, 2023 at 10:44 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Flushing the dirty buffer may take a long time if the Rados is
>> overloaded or if there is network issue. So we should ping the
>> MDSs periodically to keep alive, else the MDS will blocklist
>> the kclient.
>>
>> Cc: stable@vger.kernel.org
> Hi Xiubo,
>
> The stable tag doesn't make sense here as this commit enhances commit
> 2789c08342f7 ("ceph: drop the messages from MDS when unmounting") which
> isn't upstream.  It should probably just be folded there.

No, Ilya. This is not an enhancement for commit 2789c08342f7.

They are for different issues here. This patch just based on that. We 
can apply this first and then I can rebase the testing branch.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>

