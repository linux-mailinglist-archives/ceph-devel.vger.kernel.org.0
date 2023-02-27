Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A856A3A13
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 05:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjB0ERW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 23:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0ERU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 23:17:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6CED525
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 20:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677471399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iH5lhD99crTciZ/1cWavxMhs6gi2mCL6wUGS4DiNbR0=;
        b=dBglu4vDgGbdsZNO26xLRaBfEITej4cKNLN1zAeqWiWuBPQ6ybqy5TEFywmM541QzpEZdr
        0gvxHQbecr268xLIBCR7Wzq/qm/qa2Y9k5RshdvZzKIBkCXPOY+db4JRTvjpV26qRu/diF
        ViqReKtlJLbF+PszB0K7ggX5I1b8g68=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-91-Kye5cYXWNrezX4bDO5pkwA-1; Sun, 26 Feb 2023 23:16:37 -0500
X-MC-Unique: Kye5cYXWNrezX4bDO5pkwA-1
Received: by mail-pl1-f200.google.com with SMTP id q5-20020a170902788500b0019b0c60afa8so2957237pll.12
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 20:16:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iH5lhD99crTciZ/1cWavxMhs6gi2mCL6wUGS4DiNbR0=;
        b=EDELjxcwpVLW9Hm2qLKVFh9aCrYO5YyRJBJkqJxAAxfoPGzK6sf+TkmaZPnzWLsG3k
         ZzAjljNO4sQkr4fuUq2cAyFnEhcJtMCIZNZYI2OCYqjAZ0RQ51kFoTRr0+tgVI0970bS
         7RbLprmrbzf4N5qf3VlhHvqD0NvvTjUdaoLvCO9eygw8UnFdZp6bA5wJVM9WhRpaS9N1
         pya+TMaSEKuNaYK12s69gZHqDu7Jlyt/9dIWQNdawC/fb5Y+wub3xWBkUWG9Y2CXK/yT
         655RYMIPf7O/IPaQx6vQaef2+yV5vtlXmvgp1r0r8Nxm74URdjDJ09uXyMT+F7wANfKp
         bRGw==
X-Gm-Message-State: AO0yUKUO1k66zhbSP32S4Vgsob2Spk2cLWf1kiXYDfCJhVBnTxyqRV8M
        NsudX/Yg5J7knUv7Ro29jvpKj5SEnIZEfmmhtS6FmhoT6o1GLUnvvxpe1sTiL0y0AOT4iMfnVTu
        L6hzl2gP0wLpqDwtDiyiXHA==
X-Received: by 2002:a17:90b:4d8e:b0:237:b121:670b with SMTP id oj14-20020a17090b4d8e00b00237b121670bmr8805347pjb.7.1677471396506;
        Sun, 26 Feb 2023 20:16:36 -0800 (PST)
X-Google-Smtp-Source: AK7set8eodbzBVrU0yaJ49ulecqX0z7SpaZHkSXpZ8j86xsPTUYZGr+baty4w4Cytcj0/KnnxbJ+Ow==
X-Received: by 2002:a17:90b:4d8e:b0:237:b121:670b with SMTP id oj14-20020a17090b4d8e00b00237b121670bmr8805337pjb.7.1677471396225;
        Sun, 26 Feb 2023 20:16:36 -0800 (PST)
Received: from [10.72.12.143] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l12-20020a17090a660c00b002343e59709asm5041396pjj.46.2023.02.26.20.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 20:16:35 -0800 (PST)
Message-ID: <3607fd4c-cc4d-ae97-ed58-ecbecc55d838@redhat.com>
Date:   Mon, 27 Feb 2023 12:16:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] generic/020: fix really long attr test failure for
 ceph
Content-Language: en-US
To:     fstests@vger.kernel.org
Cc:     david@fromorbit.com, djwong@kernel.org, ceph-devel@vger.kernel.org,
        vshankar@redhat.com, zlang@redhat.com
References: <20230227041358.350309-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230227041358.350309-1-xiubli@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The test results of this:

[root@lxbceph1 xfstests-dev]# ./check generic/020
FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 lxbceph1 6.2.0-rc7-00074-gd9ba97321a89 
#211 SMP PREEMPT_DYNAMIC Wed Feb 22 14:28:15 CST 2023
MKFS_OPTIONS  -- 10.72.47.117:40602:/testB
MOUNT_OPTIONS -- -o 
test_dummy_encryption,name=admin,nowsync,copyfrom,rasize=4096 -o 
context=system_u:object_r:root_t:s0 10.72.47.117:40602:/testB /mnt/kcephfs.B

generic/020 32s ...  34s
Ran: generic/020
Passed all 1 tests

On 27/02/2023 12:13, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> If the CONFIG_CEPH_FS_SECURITY_LABEL is enabled the kernel ceph
> itself will set the security.selinux extended attribute to MDS.
> And it will also eat some space of the total size.
>
> Fixes: https://tracker.ceph.com/issues/58742
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - make the 'size' and the 'selinux_size' to be local
>
>   tests/generic/020 | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/tests/generic/020 b/tests/generic/020
> index be5cecad..538a24c6 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -150,9 +150,11 @@ _attr_get_maxval_size()
>   		# it imposes a maximum size for the full set of xattrs
>   		# names+values, which by default is 64K.  Compute the maximum
>   		# taking into account the already existing attributes
> -		max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
> +		local size=$(getfattr --dump -e hex $filename 2>/dev/null | \
>   			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
> -		max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
> +		local selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
> +			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
> +		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
>   		;;
>   	*)
>   		# Assume max ~1 block of attrs

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

