Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B8250AF69
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Apr 2022 07:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444102AbiDVFMZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Apr 2022 01:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444105AbiDVFMX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 Apr 2022 01:12:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6210E4F441
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 22:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650604169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e5mxsi9RiB61WUB6kBBDeKAI3oddIGu4GrwfnFM8xLI=;
        b=UEx1/5X83ELcHVV5r+Vomw1DrFVq7nhGU7AmFwJu8G9Sv0BSgi6gGWxW27mOBsmvJouBK4
        2AiA/00yuQNN3HqbHYqOOYLUN9N2pQMz062HuKQ9hxZeTn58Vmkd4FeDixVLhVVkHvnly8
        Q5xYCjm/FFQnHR8E6jCzxefOFSNyndE=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-K2blFDx2NrmwzU6nge0Uqw-1; Fri, 22 Apr 2022 01:09:27 -0400
X-MC-Unique: K2blFDx2NrmwzU6nge0Uqw-1
Received: by mail-pg1-f198.google.com with SMTP id k5-20020a636f05000000b003aab7e938a5so1168907pgc.21
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 22:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=e5mxsi9RiB61WUB6kBBDeKAI3oddIGu4GrwfnFM8xLI=;
        b=vLNNOsTtyPWy1rriTbgSIu+ao2JpgEWmANZPzqWadKyqX65NgZCpy4U0pArLnMs8pK
         /iGnwJ6QxaRiZdUALZjIZqhz3xyUCUC2nG1TkZcvImJlm3i8EK8grZFMX7Qm5PY4kdPW
         mC7dYrU51aGR4MTcIIhnVd0MzD1XuKFNQlTCdem/tI7Q6IlaBJFBUIohQJsKV/DguDWN
         Dg7IHB45FZfsqvyzl/QBGMKqtp2/iz3+LUyFE9fII0tYZkV87pnpTulSrrWnXx0Provq
         VrvAo1X14rpc8GIrwb+cEjo1j2LqSUh7lBbKf+2IccwJDL7MoOJvf3s1dQje82iRvt88
         g2fg==
X-Gm-Message-State: AOAM531UBkPu+DEtcjK9btwURDyUe+/nekEWF3CG2kt5Sfo9GEVZ1eBz
        4d4IQsXqYqO+iCLlInr5YRYi1Kv3ZVOB405Ry+DBPPWL7VSEPTJkgHBDJUEAp2umj2UrM6JWTbE
        Vh4nrjdwBo0k2a6mbbNsmOCcHiHJH3iP5qDW2iTnioJzzAiFlBZC83sAIpBW8hG1GG83h+kA=
X-Received: by 2002:a17:90a:8583:b0:1d0:ad7f:2452 with SMTP id m3-20020a17090a858300b001d0ad7f2452mr3334513pjn.203.1650604166095;
        Thu, 21 Apr 2022 22:09:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKWYKNWTj1o8kpjj+4OPK8Nl8BBXxn/7sfOxoysLgHQwHwqgjkrMPjwxFdwFdfO1xp6PpgVA==
X-Received: by 2002:a17:90a:8583:b0:1d0:ad7f:2452 with SMTP id m3-20020a17090a858300b001d0ad7f2452mr3334486pjn.203.1650604165793;
        Thu, 21 Apr 2022 22:09:25 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n13-20020a654ccd000000b0039db6f73e9dsm821314pgt.28.2022.04.21.22.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 22:09:25 -0700 (PDT)
Subject: Re: [PATCH] ceph: skip reading from Rados if pos exceeds i_size
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20220421083619.161391-1-xiubli@redhat.com>
 <CAJ4mKGZzaEB0Sf5kWtJekx0iD1+BZurS-P3caRr06HciLLvfUA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ad989c0b-150d-c364-bb6f-72d84f60e58e@redhat.com>
Date:   Fri, 22 Apr 2022 13:09:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAJ4mKGZzaEB0Sf5kWtJekx0iD1+BZurS-P3caRr06HciLLvfUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/21/22 9:19 PM, Gregory Farnum wrote:
> On Thu, Apr 21, 2022 at 1:37 AM Xiubo Li <xiubli@redhat.com> wrote:
>> Since we have held the Fr capibility it's safe to skip reading from
>> Rados if the ki_pos is larger than or euqals to the file size.
> I'm not sure this is correct, based on the patch description. If
> you're in a mixed mode where there are writers and readers, they can
> all have Frw and extend the file size by issuing rados writes up to
> the max_size without updating each other. The client needs to have Fs
> before it can rely on knowing the file size, so we should check that
> before skipping a read, right?

There still need some other fixes in kclient, that is fixing the 
__ceph_should_report_size() to report the size to the MDS when the 
i_size changed and dirty the Fw caps before check_caps() for each 
write.  Then the MDS Locker code will issue new caps to all the clients.

While I think there still has a gap with this fixing. Because the 
readers may need a little time to get the notification and to update the 
new file size.

For now I will drop this change.

-- Xiubo




> -Greg
>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 6c9e837aa1d3..330e42b3afec 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -1614,7 +1614,9 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>                  return ret;
>>          }
>>
>> -       if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
>> +       if (unlikely(iocb->ki_pos >= i_size_read(inode))) {
>> +               ret = 0;
>> +       } else if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
>>              (iocb->ki_flags & IOCB_DIRECT) ||
>>              (fi->flags & CEPH_F_SYNC)) {
>>
>> --
>> 2.36.0.rc1
>>

