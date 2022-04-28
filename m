Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0674D513512
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 15:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347372AbiD1NaM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 09:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347140AbiD1NaL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 09:30:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6AB3B1891
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 06:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651152415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZIjZD/uYiXoBJkaXltP/GipTqZ5fDgHfvutIlXshBaQ=;
        b=NWOwXNfyrA7QtdQ9dxATcdAZv8Fz00NJtrsTCTVYrRMris5Ubh9LBoAi71+9aHzYawukA3
        +cUTP3EaXphgyzkU1UUfQCYJbg0v+HZkYoVlLbY/lYbncaFsDrlFM9HhX0tnqB4na00fPQ
        1Ov6ee1GVsGHbWUEHXBhyTBfghpMi+4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-Slc6hoFNP--4TdmGA2SNyA-1; Thu, 28 Apr 2022 09:26:54 -0400
X-MC-Unique: Slc6hoFNP--4TdmGA2SNyA-1
Received: by mail-pf1-f198.google.com with SMTP id k14-20020aa790ce000000b0050d3b201122so2760788pfk.20
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 06:26:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZIjZD/uYiXoBJkaXltP/GipTqZ5fDgHfvutIlXshBaQ=;
        b=aS95wpxjaI+6RcU7PatmuuA8rr6XfNyp6ZhjfMAt9xnhEfb/J1HhGKD9VGmYpoCz2i
         lBlNI87mDS0hJgPeehU2BJl6gA2V0k7O0gKqub8LqjLk3OYmkOFuXXiayk7dxvZKr+AA
         SEvgwxaH3KDDXr4JVqaCVf3j6IG0KwyQTjKnjRE1h1F2pIY5GvQjrOQyLzBahrRVybVU
         7lkXO4LxLl1yfhEMlu2B5dPzDn9QADUlzU/b/JCqUvz4HqLzgZym7mZJjvtVWT8Z3Z63
         UOKYEnp2xUDXeXR1frKkkKq6PkLNudi32/ZOVpCSitrzH08d/6FL2P5+2ebgsOZdnTYB
         KyEw==
X-Gm-Message-State: AOAM5332ihOnuEYWepbereYhBRyAPoLHol+x0OLwV19WnBp1U5gcOXS9
        C8ZudZXhAPWS6aYhI6gZ49x8XAwPghHHgSCkWPoxM0BIZmKo8OINBWEqxeZCyE676eIORiBCmO5
        +CC47Dl7fP12rr8PdncGd4uM1b3YGFV0FIJMbdyrrUqpKdHf5pZBlvGbaHwZay5Q8ZJm332U=
X-Received: by 2002:a17:903:124a:b0:154:c7a4:9374 with SMTP id u10-20020a170903124a00b00154c7a49374mr33811200plh.68.1651152413002;
        Thu, 28 Apr 2022 06:26:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2JAjhludgyPEkr4if3Zi0r+VoKS19KnmLVOlIaIoqrkfkuSWLwv1APJm6UydST9MV4j59RQ==
X-Received: by 2002:a17:903:124a:b0:154:c7a4:9374 with SMTP id u10-20020a170903124a00b00154c7a49374mr33811168plh.68.1651152412630;
        Thu, 28 Apr 2022 06:26:52 -0700 (PDT)
Received: from [10.72.12.57] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v1-20020a62c301000000b00505bc0b970dsm23330357pfg.178.2022.04.28.06.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 06:26:52 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't retain the caps if they're being revoked and
 not used
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220428121318.43125-1-xiubli@redhat.com>
 <4d9eaa5f86ab1d4d4b33b0308de12d9384b0daba.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3a6a89c3-38ff-d84e-5d8c-e1c5917605e9@redhat.com>
Date:   Thu, 28 Apr 2022 21:26:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4d9eaa5f86ab1d4d4b33b0308de12d9384b0daba.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/28/22 8:29 PM, Jeff Layton wrote:
> On Thu, 2022-04-28 at 20:13 +0800, Xiubo Li wrote:
>> For example if the Frwcb caps are being revoked, but only the Fr
>> caps is still being used then the kclient will skip releasing them
>> all. But in next turn if the Fr caps is ready to be released the
>> Fw caps maybe just being used again. So in corner case, such as
>> heavy load IOs, the revocation maybe stuck for a long time.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 0c0c8f5ae3b3..7eb5238941fc 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1947,6 +1947,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>>   
>>   	/* The ones we currently want to retain (may be adjusted below) */
>>   	retain = file_wanted | used | CEPH_CAP_PIN;
>> +
>> +	/*
>> +	 * Do not retain the capabilities if they are under revoking
>> +	 * but not used, this could help speed up the revoking.
>> +	 */
>> +	retain &= ~((revoking & retain) & ~used);
>> +
>>   	if (!mdsc->stopping && inode->i_nlink > 0) {
>>   		if (file_wanted) {
>>   			retain |= CEPH_CAP_ANY;       /* be greedy */
> Actually maybe something like this would be simpler to understand?
>
> /* Retain any caps that are actively in use */
> retain = used | CEPH_CAP_PIN;
>
> /* Also retain caps wanted by open files, if they aren't being revoked */
> retain |= (file_wanted & ~revoking);

This won't work, because the caps maybe '|' back again in the following 
code:

1950         if (!mdsc->stopping && inode->i_nlink > 0) {
1951                 if (file_wanted) {
1952                         retain |= CEPH_CAP_ANY;       /* be greedy */
                  ...

1979        }


I have adjust the code and simplified it in V2.

-- Xiubo



>

