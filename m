Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54F1721B9A
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 03:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjFEBmY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 4 Jun 2023 21:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjFEBmX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 4 Jun 2023 21:42:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C893BC
        for <ceph-devel@vger.kernel.org>; Sun,  4 Jun 2023 18:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685929299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dPxMNgp9Z5Jx7/cmyNMr458SLsz8+Wt5P0SKLMfTOM=;
        b=Oki/j2cu/fXZsnLiHLud7aMFF/x7HYe6zRmqi6Nh8H/I20IDc6p5cnLlPNcZKLZv13/rfT
        AgYvH+IJasdB4mmI4TIyVKVR5GJlM5rVjV9ZpEpARpdC8DkjKtnNZg01Qfw8l8dlASqLIr
        RKc3W56attBQLlwUW/OX1OURjrfmBso=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-jPvFT5BzOkmXslPc8Mq6bA-1; Sun, 04 Jun 2023 21:41:38 -0400
X-MC-Unique: jPvFT5BzOkmXslPc8Mq6bA-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6af9c82b407so4371750a34.0
        for <ceph-devel@vger.kernel.org>; Sun, 04 Jun 2023 18:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685929297; x=1688521297;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9dPxMNgp9Z5Jx7/cmyNMr458SLsz8+Wt5P0SKLMfTOM=;
        b=I9rHu0HHaVvblLUd1fXEgUW7oOEOMk3CROC4ynK3W1Lb0qQcekI6QwReHcFUo69mdK
         KQAMARwgTg8OWrTLsXMQRDUcTmdZcN+IHbJzxTKkcFY8O9pY5WIH3s9TRZkNXmuaLrX9
         xY4sWlTedljbwHx0oQIU9C8P0I64Ocf1VDKJa7dErmQwHkfHyNg1Abgs1CyIgghJsSYp
         DpxMbQAoP0gHkCR4/xSYfD3wX+s8nrmYHVHVnR2z7Y18/AOtPb9Ixkj6yXUNWpmH7Dhw
         7ESEd9kYOrFTZ3uRg6Q5CZIIzRyz69Yc/owlO69MewKmYad14jTOJsruy0t390WvLjo5
         1Axg==
X-Gm-Message-State: AC+VfDwv+N5WH1TlTcTVa7MYLmirh+erWRWr7HoPgC2EZkh9bf4KdSfx
        Pg0FHGtjHTyM6S/WVBvY1ayoKz9Iv3+rcNVl7AC0tgjeuznfpZi3NU8778go9hd1hIxdV0tss6X
        iFZCGe2DFFJWVReV9H8QqTw==
X-Received: by 2002:a05:6830:169a:b0:6ab:1c78:d5e with SMTP id k26-20020a056830169a00b006ab1c780d5emr8957182otr.5.1685929297711;
        Sun, 04 Jun 2023 18:41:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5+LD1A+zZFKBZya0yVPWFykITUF4pkHOOWCKXLjzSZzoZEuP2I7Fbrq+7zT8OGTW7freccug==
X-Received: by 2002:a05:6830:169a:b0:6ab:1c78:d5e with SMTP id k26-20020a056830169a00b006ab1c780d5emr8957166otr.5.1685929297480;
        Sun, 04 Jun 2023 18:41:37 -0700 (PDT)
Received: from [10.72.12.216] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q16-20020a62e110000000b0063d29df1589sm4089971pfh.136.2023.06.04.18.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 18:41:36 -0700 (PDT)
Message-ID: <a90b085c-8744-cdbc-9f4f-3221723a7bd3@redhat.com>
Date:   Mon, 5 Jun 2023 09:41:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] generic/020: add ceph-fuse support
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
References: <20230530071552.766424-1-xiubli@redhat.com>
 <20230602105038.tz2azxiaxzcrdu3l@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230602105038.tz2azxiaxzcrdu3l@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/2/23 18:50, Zorro Lang wrote:
> On Tue, May 30, 2023 at 03:15:52PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For ceph fuse client the fs type will be "ceph-fuse".
>>
>> Fixes: https://tracker.ceph.com/issues/61496
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   tests/generic/020 | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tests/generic/020 b/tests/generic/020
>> index e00365a9..da258aa5 100755
>> --- a/tests/generic/020
>> +++ b/tests/generic/020
>> @@ -56,7 +56,7 @@ _attr_get_max()
> Hmm... generic/020 is a very old test case, I think this _attr_get_max might
> can be a common helper in common/attr.
Yeah, sounds reasonable.
>>   {
>>   	# set maximum total attr space based on fs type
>>   	case "$FSTYP" in
>> -	xfs|udf|pvfs2|9p|ceph|fuse|nfs)
>> +	xfs|udf|pvfs2|9p|ceph|fuse|nfs|ceph-fuse)
> Anyway, that's another story, for the purpose of this patch:
>
> Reviewed-by: Zorro Lang <zlang@redhat.com>
>
Thanks

- Xiubo

>>   		max_attrs=1000
>>   		;;
>>   	ext2|ext3|ext4)
>> -- 
>> 2.40.1
>>

