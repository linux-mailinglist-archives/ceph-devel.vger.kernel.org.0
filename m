Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441A06B1C70
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Mar 2023 08:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCIHe6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Mar 2023 02:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjCIHez (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Mar 2023 02:34:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30EDDB6E4
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 23:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678347234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2eI75EI2bEfBrzO7ljqtkrRx9cCPWQmstR3/D9o91c=;
        b=HSeqMONAO867/mh1+5/uC+3WVi+ushnSi9qG71jvDYkUGNN9TKA/sZ0wszWjxDbzIGGdba
        0uy2w3LzdOfa3FwVubnkFHOa0cJdgw3Nqs3rTiUfqf1YlsI//b4E1cY9gyVb7pmGRRun7k
        fgsdFpTXXvC209PdXwJlCbYkulrX4qw=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-5tdRyXEYMn2saRc2A2QW7g-1; Thu, 09 Mar 2023 02:33:52 -0500
X-MC-Unique: 5tdRyXEYMn2saRc2A2QW7g-1
Received: by mail-pl1-f199.google.com with SMTP id x10-20020a170902ea8a00b0019cdb7d7f91so683711plb.4
        for <ceph-devel@vger.kernel.org>; Wed, 08 Mar 2023 23:33:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678347231;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2eI75EI2bEfBrzO7ljqtkrRx9cCPWQmstR3/D9o91c=;
        b=x5DLN5bK8az2Jj0EwiVoohWAhATKtmafnbwUF8BkY4Y2u5q6B9b+64PSEfiinwbg3r
         GB+AW76VWQtOj3GQLwVT4i1diqr6XJ/FKfrOcntVy3sI9uhRDt7WZtNgmn9DUXoDOR5t
         ixcRisZKJTeKet12DxCmxH+SiqT/PWj5agCEDYVeLm6cVCSGqcH2dbONY7qfCZDsKzjw
         O91nNWe8jrm0/NB8hWLC+0ZQzo8Wx0wE/Avk0HkpntR8Pv2LeGTgR/pQClpf4mqdRHIO
         sbNgvNB2GvjMAcDW2AjJssUP4uME1SUE0X3u0cVToObdW44rXyRypy4HWVNnq0HDyxAy
         aUow==
X-Gm-Message-State: AO0yUKWZftH0W1DvGxgW7XmBJnpTqyRwCT3/Xkv06kZ5OWP1vwRbdq1g
        opqPeqSyeDnSCmZ52tUI1xLEFVH9ArsLCyvzKtX3DFusx0wwy4KjwrG935OFsAZFjNIA0jqagbV
        ZltV6T7VuC/QgMgyG6TqSJA==
X-Received: by 2002:a17:90b:4ac5:b0:233:ca14:6ae8 with SMTP id mh5-20020a17090b4ac500b00233ca146ae8mr22001484pjb.45.1678347231372;
        Wed, 08 Mar 2023 23:33:51 -0800 (PST)
X-Google-Smtp-Source: AK7set/dW6MqQ3ILRER0QVrnho4NKjeKEmnrKxg3LwqOnLbM60mqEDfosx62kAURLpWjFBEbHUW3jw==
X-Received: by 2002:a17:90b:4ac5:b0:233:ca14:6ae8 with SMTP id mh5-20020a17090b4ac500b00233ca146ae8mr22001477pjb.45.1678347231113;
        Wed, 08 Mar 2023 23:33:51 -0800 (PST)
Received: from [10.72.13.99] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q10-20020a63504a000000b004fcda0e59c3sm10102052pgl.69.2023.03.08.23.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 23:33:50 -0800 (PST)
Message-ID: <c8d44e19-6e4c-9c62-2f5e-300013e0adf8@redhat.com>
Date:   Thu, 9 Mar 2023 15:33:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] fs/ceph/mds_client: ignore responses for waiting requests
Content-Language: en-US
To:     Max Kellermann <max.kellermann@ionos.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230302130650.2209938-1-max.kellermann@ionos.com>
 <c2f9e0d3-0242-1304-26ea-04f25c3cdee4@redhat.com>
 <CAKPOu+_1ee8QDkuB4TxQBaUwnHi4bRKuszWzCb-BCY44cp1aJQ@mail.gmail.com>
 <cf545923-e782-76a7-dd94-f8586530502b@redhat.com>
 <CAKPOu+-jCt6NoVaR=z6c-D-PY1skdt6u-2sKkzd8GFDHbsQdxQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAKPOu+-jCt6NoVaR=z6c-D-PY1skdt6u-2sKkzd8GFDHbsQdxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 09/03/2023 15:30, Max Kellermann wrote:
> On Thu, Mar 9, 2023 at 6:31 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>> I attached one testing patch based yours, just added more debug logs,
>> which won't be introduce perf issue since all the logs should be printed
>> in corner cases.
>>
>> Could you help test it ?
> The patch now runs on one of our clusters, and I'll get back to you as
> soon as the problem occurs again. Thanks so far!

Cool, thanks very much.

- Xiubo

