Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639E169B6B4
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Feb 2023 01:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjBRA2y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Feb 2023 19:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjBRA2v (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Feb 2023 19:28:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4672A9B3
        for <ceph-devel@vger.kernel.org>; Fri, 17 Feb 2023 16:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676680083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0TVOvyAkMinBR6Y3/er05/0qs6PJZeW5sD0yVjgNqbU=;
        b=AGzd+DMW3fDFSIk9IAmqhI2msjUxNQZ/NQsTKHBZX/zBhSXMLqgS6UPx9JZ9s7taCPiRge
        g4mc+ZrsuxtgKZB8GGi3DyJmZMZrwRuqAT8G08lbz4e3bhCq72ZImXdjrajc6bSSOipacw
        NupW/7lRfF9BNjY2yuIS6kTkBaz/rJQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-2-upwwxCeFMOed7WpksQrQ3g-1; Fri, 17 Feb 2023 19:26:57 -0500
X-MC-Unique: upwwxCeFMOed7WpksQrQ3g-1
Received: by mail-pl1-f200.google.com with SMTP id p22-20020a170902b09600b0019ac5d9fdb3so1560917plr.9
        for <ceph-devel@vger.kernel.org>; Fri, 17 Feb 2023 16:26:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0TVOvyAkMinBR6Y3/er05/0qs6PJZeW5sD0yVjgNqbU=;
        b=ysX/nDxKRz3eUAD4CouIQntzwhU4a/TiA0DJDLRuGkyLGQNKMFcLT3mZ4pQr04WBia
         /wqf7LvrxKPAn+ws6UEMkZjCGTioCfEtL8s0a04slWnCYJAkj1eJsosI9dZCW+DJ5nTq
         oJE7oq7mHDWvwxduhSgLrTrDu7ubis2dnSNvaqMm+btPT47FHeLgp8uBw+dI2Al05qe8
         YMd/4bmr1dOVJhPLm9OUuJlfrbMSU4t+bnbRO8ANAWUSVGDJIgFtylZjDyVaaYG7pjqC
         nTLYCipGW4JElUE7Wt4nM2TwI17GMu5XJbsuFMFOdvGX/RYocanAZ2j5ZSePEa1JVpXx
         RkFQ==
X-Gm-Message-State: AO0yUKWr0ZGsQ2MPEKCi6logbJtkiLmWSamrGkN+ZkOKHooL+db52N4j
        aivnOzK6TEdLOVWwidwf3EyGDTffyiy/iG3a4FWGCXWZfFgyhXY7aVNljyRoqlNYZfkX4QH+aH3
        Tspo2DWgEIr2qUB6/iV4HZw==
X-Received: by 2002:a17:902:ec8c:b0:196:7bfb:f0d1 with SMTP id x12-20020a170902ec8c00b001967bfbf0d1mr2116122plg.34.1676680016117;
        Fri, 17 Feb 2023 16:26:56 -0800 (PST)
X-Google-Smtp-Source: AK7set/pTQPbTBejLC3ZlGmTrp0zRFUymVN4NfxARLQed13IM33bE8WinIA3xyIncb7RXbmXQLDfSQ==
X-Received: by 2002:a17:902:ec8c:b0:196:7bfb:f0d1 with SMTP id x12-20020a170902ec8c00b001967bfbf0d1mr2116099plg.34.1676680015714;
        Fri, 17 Feb 2023 16:26:55 -0800 (PST)
Received: from [10.72.12.155] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id bi12-20020a170902bf0c00b00194c1281ca9sm3654407plb.166.2023.02.17.16.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 16:26:55 -0800 (PST)
Message-ID: <3b1ea8e1-c6b0-1c5e-9db2-542861d12269@redhat.com>
Date:   Sat, 18 Feb 2023 08:26:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] generic/020: fix really long attr test failure for ceph
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, david@fromorbit.com,
        ceph-devel@vger.kernel.org, vshankar@redhat.com, zlang@redhat.com
References: <20230217124558.555027-1-xiubli@redhat.com>
 <Y++0t8qxK8et8fTg@magnolia>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <Y++0t8qxK8et8fTg@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 18/02/2023 01:09, Darrick J. Wong wrote:
> On Fri, Feb 17, 2023 at 08:45:58PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the CONFIG_CEPH_FS_SECURITY_LABEL is enabled the kernel ceph
>> itself will set the security.selinux extended attribute to MDS.
>> And it will also eat some space of the total size.
>>
>> Fixes: https://tracker.ceph.com/issues/58742
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   tests/generic/020 | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/tests/generic/020 b/tests/generic/020
>> index be5cecad..594535b5 100755
>> --- a/tests/generic/020
>> +++ b/tests/generic/020
>> @@ -150,9 +150,11 @@ _attr_get_maxval_size()
>>   		# it imposes a maximum size for the full set of xattrs
>>   		# names+values, which by default is 64K.  Compute the maximum
>>   		# taking into account the already existing attributes
>> -		max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
>> +		size=$(getfattr --dump -e hex $filename 2>/dev/null | \
>>   			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
>> -		max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
>> +		selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
>> +			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
>> +		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
> If this is a ceph bug, then why is the change being applied to the
> section for FSTYP=ext* ?  Why not create a case statement for ceph?

Hi Darrick,

The above change is already in the "ceph)" section:

143         nfs)
144                 # NFS doesn't provide a way to find out the 
max_attrval_size for
145                 # the underlying filesystem, so just use the lowest 
value above.
146                 max_attrval_size=1024
147                 ;;
148         ceph)
149                 # CephFS does not have a maximum value for 
attributes.  Instead,
150                 # it imposes a maximum size for the full set of xattrs
151                 # names+values, which by default is 64K. Compute the 
maximum
152                 # taking into account the already existing attributes
153                 size=$(getfattr --dump -e hex $filename 2>/dev/null | \
154                         awk -F "=0x" '/^user/ {len += length($1) + 
length($2) / 2} END {print len}')
155                 selinux_size=$(getfattr -n 'security.selinux' --dump 
-e hex $filename 2>/dev/null | \
156                         awk -F "=0x" '/^security/ {len += length($1) 
+ length($2) / 2} END {print len}')
157                 max_attrval_size=$((65536 - $size - $selinux_size - 
$max_attrval_namelen))
158                 ;;
159         *)
160                 # Assume max ~1 block of attrs
161                 BLOCK_SIZE=`_get_block_size $TEST_DIR`
162                 # leave a little overhead
163                 let max_attrval_size=$BLOCK_SIZE-256

I didn't find the ext* section in _attr_get_maxval_size(). Did I miss 
something here ?

I have double checked it again by pulling the latest source code, no any 
change about this since my last pull yesterday.

Thanks

- Xiubo


> --D
>
>>   		;;
>>   	*)
>>   		# Assume max ~1 block of attrs
>> -- 
>> 2.31.1
>>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

