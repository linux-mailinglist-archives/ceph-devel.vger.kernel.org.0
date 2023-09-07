Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D66796DE7
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Sep 2023 02:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242493AbjIGAPD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Sep 2023 20:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjIGAPD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Sep 2023 20:15:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3DD19BA
        for <ceph-devel@vger.kernel.org>; Wed,  6 Sep 2023 17:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694045654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5UGvSiuErQB8lp1gKFnemutfQ3p91ij8pwBcSGcOyE=;
        b=Si34C3/0zGB/qohTmh/6AK4W7KrUcJebl8XHXek9U83WqAevQbtww8aJWQMDnk2ayqzDOZ
        p83qXwzO5XPuGTOhjweerD2rDfI+8dKea/1CflHP4wW07IfvUqNQF+5DY1nLs3dEPXZM7c
        ZGpGky9do5ormiRw3YVbD/Y2VwPV+d4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-lcHnkOKQPkayWG2cTC-wvQ-1; Wed, 06 Sep 2023 20:14:13 -0400
X-MC-Unique: lcHnkOKQPkayWG2cTC-wvQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-68a3ba17c7bso528730b3a.2
        for <ceph-devel@vger.kernel.org>; Wed, 06 Sep 2023 17:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694045652; x=1694650452;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z5UGvSiuErQB8lp1gKFnemutfQ3p91ij8pwBcSGcOyE=;
        b=f2sPEZgCbP0C5+SVwClfG1v7F0Zua74XV3SKUZPyysqfn4u+8eHhUysp9jjFYAQ6ru
         zWTCOmJN7M/OBuvbOw8LipJAOku2kwqJpC0c+r/P7c6zTJBhy/g/xtfI7cBwoyy7wkJR
         vcvE7Z9imISLhTByfBXCladBkmZ89ir85Xn7QroV/phpqcB+dZgqTcVyaNuqmetO3qSK
         V6RdI6z25pM96KRAYrkQnVruHNUR4/K9qHVZmtQvTaDZBo+5bmo2d5V6HNpvy3HlOiL8
         YfNoqYJk+CNFqLv0zG6eV5NGxLamhYkzHPBpv3VQl09ncGmbcyY2XVt550wYONYUWbvn
         mf5w==
X-Gm-Message-State: AOJu0YxA/k4SmvVcZrhGkFKzg1PUSNffyWi8VEYgA5Gtg0KVi0RvMJ4b
        KfoU8CvXmQcyXpy4PWTIMk4wITklkSQOyjecoyWPR+EK+6+xElij9J4KspzK4JsEnaOecFUL9/n
        aLMXEcF24kf+iJvKr86pClUDKwEJRyER4jj4=
X-Received: by 2002:a05:6a00:4791:b0:68e:3e1c:53a6 with SMTP id dh17-20020a056a00479100b0068e3e1c53a6mr322217pfb.5.1694045652404;
        Wed, 06 Sep 2023 17:14:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjCMtdsPO+4BElHFINliOrQ9CrFpHp4V8UkiZyLS8l1Yu+STU9YPcr9Y5So8LM1VEnbxUt9w==
X-Received: by 2002:a05:6a00:4791:b0:68e:3e1c:53a6 with SMTP id dh17-20020a056a00479100b0068e3e1c53a6mr322203pfb.5.1694045652065;
        Wed, 06 Sep 2023 17:14:12 -0700 (PDT)
Received: from [10.72.112.106] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p26-20020a62ab1a000000b0068a690b44basm11354863pff.31.2023.09.06.17.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Sep 2023 17:14:11 -0700 (PDT)
Message-ID: <43d88af6-9955-d65d-1949-c1b4ddec7070@redhat.com>
Date:   Thu, 7 Sep 2023 08:14:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: remove the incorrect caps check in _file_size()
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230906121747.618289-1-xiubli@redhat.com>
 <2023090626-overgrown-probation-a58d@gregkh>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <2023090626-overgrown-probation-a58d@gregkh>
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


On 9/6/23 22:45, Greg KH wrote:
> On Wed, Sep 06, 2023 at 08:17:47PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When truncating the inode the MDS will acquire the xlock for the
>> ifile Locker, which will revoke the 'Frwsxl' caps from the clients.
>> But when the client just releases and flushes the 'Fw' caps to MDS,
>> for exmaple, and once the MDS receives the caps flushing msg it
>> just thought the revocation has finished. Then the MDS will continue
>> truncating the inode and then issued the truncate notification to
>> all the clients. While just before the clients receives the cap
>> flushing ack they receive the truncation notification, the clients
>> will detecte that the 'issued | dirty' is still holding the 'Fw'
>> caps.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/56693
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
> What commit id does this fix?

Oh, I forgot to mention that in the commit comment, it will fix:

b0d7c2231015 ceph: introduce i_truncate_mutex

Let me update the patch and send out the V2 for it.

Thanks

- Xiubo



> thanks,
>
> greg k-h
>

