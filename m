Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BCF6A81F2
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Mar 2023 13:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjCBMN5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Mar 2023 07:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCBMN4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Mar 2023 07:13:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158E7113E1
        for <ceph-devel@vger.kernel.org>; Thu,  2 Mar 2023 04:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677759188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4CuTOrxEShAdXMMt2R6KC2PcBaOY8iO2mVNE4DeM/1E=;
        b=AVw9rU3nBKcTDxcjHWtP8kgH+CTRopF27xjFToVnJqIDS0RLeiMW61HMlQeaxzc0x49A0b
        YA+mPW05orYBSQIx5TaEUhY6Hk6vrMyCl7uHfsRadcrQzOEoPilBdjwuN4G/IBiWsnSNZq
        xziDl76rvfHxuXeWreW6Kz+qQ9ZbXY4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-265-pudIR9MHPPS5vLL_IkSrwQ-1; Thu, 02 Mar 2023 07:13:07 -0500
X-MC-Unique: pudIR9MHPPS5vLL_IkSrwQ-1
Received: by mail-pj1-f69.google.com with SMTP id m1-20020a17090a668100b00237d84de790so1189800pjj.0
        for <ceph-devel@vger.kernel.org>; Thu, 02 Mar 2023 04:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677759186;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CuTOrxEShAdXMMt2R6KC2PcBaOY8iO2mVNE4DeM/1E=;
        b=H5go3m7n4uiMy9IBmcSkEKmDeG5qtlvD/a7SSbHR/9G0tGPsdfiGUswrBYbDVWSmEK
         IDvbnVYHgR6LjlA1OpKFrVkaqE8Q3lXGYLjiesnhAqzfFxzQgDsBaafwag9AAfhfSih0
         ImZuirW7By1U5Z+UIXyhXlo5yQTZFlBPJXgNAvza8qrGO6dIFSbk9m86if/OCn7Wfe29
         8k/0pZTa+xMqchxj3kdmAHL0febOs3P1xZm1HsOkEqL/GUxOjvR/P7iZeXVt9Rgc8puP
         i2aAj/z6gXz2GwV1k/Y1SleALQG8EAMLDCAbVngj45hmoho5TPYxgOvQ0MMc1KlnqBXc
         zvRQ==
X-Gm-Message-State: AO0yUKXKm+mddQ0oSQ6H/p760LNc3DtrJMnYftTFxy9FTwfi6BNTYK8Z
        mYsYm21vHBxJjHgkUbhj3RmlOH2Emoq4CcjVPnfSiYL/hzYOsUsFIB75CoLbNknQFCpNRR7koOx
        8pTZqErBviYFRvslEOaFN4w==
X-Received: by 2002:a05:6a20:1592:b0:cd:7040:10d4 with SMTP id h18-20020a056a20159200b000cd704010d4mr12719362pzj.62.1677759186120;
        Thu, 02 Mar 2023 04:13:06 -0800 (PST)
X-Google-Smtp-Source: AK7set9Tly7y7rEX58NFz7c4ZNvoQgvUQzZBWv4/BberA9J5bn2t+qurP/l9ZqbKOkWiJb9CUmQMfg==
X-Received: by 2002:a05:6a20:1592:b0:cd:7040:10d4 with SMTP id h18-20020a056a20159200b000cd704010d4mr12719345pzj.62.1677759185851;
        Thu, 02 Mar 2023 04:13:05 -0800 (PST)
Received: from [10.72.12.72] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x12-20020aa784cc000000b0058e08796e98sm9680588pfn.196.2023.03.02.04.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 04:13:05 -0800 (PST)
Message-ID: <d11bfcfc-ec4d-40a9-81b3-9af48c6255f6@redhat.com>
Date:   Thu, 2 Mar 2023 20:13:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3] ceph: do not print the whole xattr value if it's too
 long
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, lhenriques@suse.de,
        vshankar@redhat.com, mchangir@redhat.com
References: <20230302032649.407500-1-xiubli@redhat.com>
 <CAOi1vP_Ghb9F1ccrj-d=GQu9xrUw4wSBRJur_LET+-Rm0QLHTg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_Ghb9F1ccrj-d=GQu9xrUw4wSBRJur_LET+-Rm0QLHTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 02/03/2023 19:03, Ilya Dryomov wrote:
> On Thu, Mar 2, 2023 at 4:26 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the xattr's value size is long enough the kernel will warn and
>> then will fail the xfstests test case.
>>
>> Just print part of the value string if it's too long.
>>
>> URL: https://tracker.ceph.com/issues/58404
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V3:
>> - s/MAX_XATTR_VAL/MAX_XATTR_VAL_PRINT_LEN/g
>> - removed the CCing stable mail list
>>
>>
>>   fs/ceph/xattr.c | 15 +++++++++++----
>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index b10d459c2326..25a585e63a2d 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -561,6 +561,8 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
>>          return NULL;
>>   }
>>
>> +#define MAX_XATTR_VAL_PRINT_LEN 256
>> +
>>   static int __set_xattr(struct ceph_inode_info *ci,
>>                             const char *name, int name_len,
>>                             const char *val, int val_len,
>> @@ -654,8 +656,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
>>                  dout("__set_xattr_val p=%p\n", p);
>>          }
>>
>> -       dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s\n",
>> -            ceph_vinop(&ci->netfs.inode), xattr, name_len, name, val_len, val);
>> +       dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s%s\n",
> Hi Xiubo,
>
> The function name is incorrect here and above, it should be __set_xattr.

yeah, I noticed it. I will revise it.

>> +            ceph_vinop(&ci->netfs.inode), xattr, name_len, name,
>> +            min(val_len, MAX_XATTR_VAL_PRINT_LEN), val,
>> +            val_len > MAX_XATTR_VAL_PRINT_LEN ? "..." : "");
>>
>>          return 0;
>>   }
>> @@ -681,8 +685,11 @@ static struct ceph_inode_xattr *__get_xattr(struct ceph_inode_info *ci,
>>                  else if (c > 0)
>>                          p = &(*p)->rb_right;
>>                  else {
>> -                       dout("__get_xattr %s: found %.*s\n", name,
>> -                            xattr->val_len, xattr->val);
>> +                       int len = xattr->val_len;
>> +
>> +                       dout("__get_xattr %s: found %.*s%s\n", name,
>> +                            min(len, MAX_XATTR_VAL_PRINT_LEN), xattr->val,
>> +                            len > MAX_XATTR_VAL_PRINT_LEN ? "..." : "");
> It looks like len variable is introduced just to save a few characters?
> If you make it meaningful, dout would actually be more compact:
>
>      int len = min(xattr->val_len, MAX_XATTR_VAL_PRINT_LEN);
>
>      dout("__get_xattr %s: found %.*s%s\n", name, len,
>           xattr->val, xattr->val_len > len ? "..." : "");

Just introduced the len var to make sure each line won't exceed 80 chars.

This also looks good. I can revise it together to fix the function name 
issue.

Thanks,

- Xiubo

> Thanks,
>
>                  Ilya
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

