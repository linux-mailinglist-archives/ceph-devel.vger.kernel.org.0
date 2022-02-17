Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E0E4B9ADB
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 09:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbiBQI1D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Feb 2022 03:27:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237513AbiBQI1A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Feb 2022 03:27:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 821B02CCA9
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 00:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645086403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TeFnEmJWZq4X2Wn53QOuaBv1oKw/hLXJfx6e+aIgAbM=;
        b=gO9wq41L/5eSeR5/oHdUAWBPKjLWgzSEpBvg1+9sA7N8qk1WVwQwfY+xYwELFa2+Zo0lEf
        0C31hB6msX7S1DVRTNuxTiq2udgCQ5StT/gKI+YaDBzHXUANUARakI4UuUgGqKs74rE2F2
        jCZ39+xRfL47eVd7SAC7SAhakDHm0vY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-Lac5Q4maNy-FSv4KxuiT7w-1; Thu, 17 Feb 2022 03:26:42 -0500
X-MC-Unique: Lac5Q4maNy-FSv4KxuiT7w-1
Received: by mail-pg1-f198.google.com with SMTP id 37-20020a630e65000000b0036c461afa9aso2608212pgo.20
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 00:26:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TeFnEmJWZq4X2Wn53QOuaBv1oKw/hLXJfx6e+aIgAbM=;
        b=u3OqAy4CkDmq3dnVl5m3LS7MQZNrQpW3gBLu5C0GAI2QTRh3uMWfjUUFz/TbxvnVrF
         gdBtQztLxnUkfMtUqPDWnPsQBQ0UxJCBNTEEH/q+grfCT9+ZGO0wtjYFITtezbUhO+i9
         YNWqrTdcNkNyAqir/yWoKYeDw6JyXIg+OX9ugAidNuDFh1++qLXR2SDXdr6sYyr9cqWm
         0CoZmpa0gU/hzk/RE9U36roZrHhv9MZAs/EZSEB647jX1w6sn789YmraC3NlSQoL8kpw
         oyxtjN6kse5j1R28xvgWGfwr5BeANGh1I4xVHqZtM5WuOcJkJkEkhXZ83t2sOUbKKfkZ
         4l4A==
X-Gm-Message-State: AOAM531edp5CfV17MzaB4fcPJPHjBqpjz7JhGlJgkyXPFsPZMKglhvxn
        G86ASX0Gt11hF5KLsdhiRBMwMxQBk745yQZiP9OIuYels/c1yAe9urabf2eM2/1AyFw/PYfMFLH
        +SHMDhA9xRA+OvFHtaRJ1a9zaWyQNbyrpmHz/GiW0BI6QSWIGLhm7LCp3QRJ833ed670NvcE=
X-Received: by 2002:a63:4005:0:b0:373:9ac7:fec1 with SMTP id n5-20020a634005000000b003739ac7fec1mr1579453pga.12.1645086401221;
        Thu, 17 Feb 2022 00:26:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYggSZlZ+aMeyAXtqjrzeAVqndFQsNd2xV5fgXjCwb8c0BdUpIT8NLDBP4BRZ9j/V96B8UUg==
X-Received: by 2002:a63:4005:0:b0:373:9ac7:fec1 with SMTP id n5-20020a634005000000b003739ac7fec1mr1579433pga.12.1645086400825;
        Thu, 17 Feb 2022 00:26:40 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o8sm1668429pfu.90.2022.02.17.00.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 00:26:40 -0800 (PST)
Subject: Re: [PATCH] ceph: zero the dir_entries memory when allocating it
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220217081542.21182-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <aff12af7-f420-6acc-9c64-2cf8897865ef@redhat.com>
Date:   Thu, 17 Feb 2022 16:26:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220217081542.21182-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

This could resolve the issue I mentioned in the fscrypt mail thread.

cp: cannot access './dir___683': No buffer space available
cp: cannot access './dir___686': No buffer space available
cp: cannot access './dir___687': No buffer space available
cp: cannot access './dir___688': No buffer space available
cp: cannot access './dir___689': No buffer space available
cp: cannot access './dir___693': No buffer space available

...

[root@lxbceph1 kcephfs]# diff ./dir___997 /data/backup/kernel/dir___997
diff: ./dir___997: No buffer space available


The dmesg logs:

<7>[ 1256.918228] ceph:  do_getattr inode 0000000089964a71 mask AsXsFs
mode 040755
<7>[ 1256.918232] ceph:  __ceph_caps_issued_mask ino 0x100000009be cap
0000000014f1c64b issued pAsLsXsFs (mask AsXsFs)
<7>[ 1256.918237] ceph:  __touch_cap 0000000089964a71 cap
0000000014f1c64b mds0
<7>[ 1256.918250] ceph:  readdir 0000000089964a71 file 00000000065cb689
pos 0
<7>[ 1256.918254] ceph:  readdir off 0 -> '.'
<7>[ 1256.918258] ceph:  readdir off 1 -> '..'
<4>[ 1256.918262] fscrypt (ceph, inode 1099511630270): Error -105
getting encryption context
<7>[ 1256.918269] ceph:  readdir 0000000089964a71 file 00000000065cb689
pos 2
<4>[ 1256.918273] fscrypt (ceph, inode 1099511630270): Error -105
getting encryption context
<7>[ 1256.918288] ceph:  release inode 0000000089964a71 dir file
00000000065cb689
<7>[ 1256.918310] ceph:  __ceph_caps_issued_mask ino 0x1 cap
00000000aa2afb8b issued pAsLsXsFs (mask Fs)
<7>[ 1257.574593] ceph:  mdsc delayed_work


On 2/17/22 4:15 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> This potentially will cause bug in future if using the old ceph
> version and some members may skipped initialized in handle_reply.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/mds_client.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 93e5e3c4ba64..c3b1e73c5fbf 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2286,7 +2286,8 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>   	order = get_order(size * num_entries);
>   	while (order >= 0) {
>   		rinfo->dir_entries = (void*)__get_free_pages(GFP_KERNEL |
> -							     __GFP_NOWARN,
> +							     __GFP_NOWARN |
> +							     __GFP_ZERO,
>   							     order);
>   		if (rinfo->dir_entries)
>   			break;

