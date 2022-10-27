Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD660F6E5
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 14:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbiJ0MMq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 08:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235526AbiJ0MMn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 08:12:43 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F194D18FE
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 05:12:42 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id s9so842512ilu.1
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 05:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YatRoCHU/prBuQvhSuWxys1gjK3BiZzhdawxQF0M6F4=;
        b=B1N6OX1U1cX5YvB7aP1R+VTu7TtGkXtGL9wAXu12pynVNaoQnFk4SWKvkjYhQ8FuQn
         1h9qSDpGHif3jet0wA8OuvjUGNyHEw3kbolGqJ/kMWl26OhTFlX29MCqkFwI0ZlR+Wjy
         y5rOBZID8+nu/AnKslAryElPRIjSPje0CIem8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YatRoCHU/prBuQvhSuWxys1gjK3BiZzhdawxQF0M6F4=;
        b=1/h0C+iWXKXY6qQsGurj+yJXh635HtDEUJJ0HgCaZ0SmgvaXABzEScxv9VwJ3zMTgp
         FtR8Y3Bh+WnSfljfwPLe1sv91s+yDWDb3WnjXmoAkwGgGELd9II5rH56AGHryq15hwGP
         67zSibFMXsQ3OKcnqI8CIE7PBch4UdKkrWi7URt4st/TRqM2b7qItwUzeOQ3wCRVqZnN
         nz0emD0yq9D4IzmR+Jdp9sRgFhUsSahbHRGImP4oFktPwnikkeEhwzE7fupJv8682vwj
         HyUI0VHaIfFRW7PDFyh/pCXSBKbo3ylDWE8a9oBnTqsSxi4uhRnT972NowqxSGTCZBua
         eMfw==
X-Gm-Message-State: ACrzQf2zLajkBYbMN0WMkaqZCqvBQBrqF0kV6KSYNR62eEoDDtr+Hu/p
        0Z7nzFtkKwtaf8eJaqA5X53PFA==
X-Google-Smtp-Source: AMsMyM50E3Zi2Pi2Qi15nwMvBIFqLj3tfj/bD2I2FXiF+frDTWgfyyRlmXYx8MSzxyAyNPLyHC0hiQ==
X-Received: by 2002:a92:c548:0:b0:2f9:fe3f:f4c2 with SMTP id a8-20020a92c548000000b002f9fe3ff4c2mr29477770ilj.180.1666872761398;
        Thu, 27 Oct 2022 05:12:41 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id g26-20020a05663810fa00b003717c1df569sm506543jae.165.2022.10.27.05.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 05:12:40 -0700 (PDT)
Message-ID: <e3d2e090-8349-927a-9d47-3c6c121c43a7@ieee.org>
Date:   Thu, 27 Oct 2022 07:12:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] rbd: fix possible memory leak in rbd_sysfs_init()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
Cc:     idryomov@gmail.com, dongsheng.yang@easystack.cn, axboe@kernel.dk,
        yehuda@hq.newdream.net
References: <20221027091918.2294132-1-yangyingliang@huawei.com>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20221027091918.2294132-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 10/27/22 4:19 AM, Yang Yingliang wrote:
> If device_register() returns error in rbd_sysfs_init(), name of kobject
> which is allocated in dev_set_name() called in device_add() is leaked.
> 
> As comment of device_add() says, it should call put_device() to drop
> the reference count that was set in device_initialize() when it fails,
> so the name can be freed in kobject_cleanup().
> 
> Fault injection test can trigger this problem:
> 
> unreferenced object 0xffff88810173aa78 (size 8):
>    comm "modprobe", pid 247, jiffies 4294714278 (age 31.789s)
>    hex dump (first 8 bytes):
>      72 62 64 00 81 88 ff ff                          rbd.....
>    backtrace:
>      [<00000000f58fae56>] __kmalloc_node_track_caller+0x44/0x1b0
>      [<00000000bdd44fe7>] kstrdup+0x3a/0x70
>      [<00000000f7844d0b>] kstrdup_const+0x63/0x80
>      [<000000001b0a0eeb>] kvasprintf_const+0x10b/0x190
>      [<00000000a47bd894>] kobject_set_name_vargs+0x56/0x150
>      [<00000000d5edbf18>] dev_set_name+0xab/0xe0
>      [<00000000f5153e80>] device_add+0x106/0x1f20
> 
> Fixes: dfc5606dc513 ("rbd: replace the rbd sysfs interface")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

This looks right to me.

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
>   drivers/block/rbd.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index f9e39301c4af..04453f4a319c 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -7222,8 +7222,10 @@ static int __init rbd_sysfs_init(void)
>   	int ret;
>   
>   	ret = device_register(&rbd_root_dev);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		put_device(&rbd_root_dev);
>   		return ret;
> +	}
>   
>   	ret = bus_register(&rbd_bus_type);
>   	if (ret < 0)

