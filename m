Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DFEFB94F
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2019 21:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfKMUDS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 15:03:18 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35483 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfKMUDS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Nov 2019 15:03:18 -0500
Received: by mail-io1-f66.google.com with SMTP id x21so4019500ior.2
        for <ceph-devel@vger.kernel.org>; Wed, 13 Nov 2019 12:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3No+CT4C6JsgDaXFKC6VJCRaElPlsQe+bs7JiqU9zJE=;
        b=U7YGMTkYUQQSWT2sdMwDkGNQMBG533vsx9qFRPFIxRTU/MOwb9vyi1XAN7rUEgMuVl
         SwWQ8PoYgtbWaAk7LMEMUCkS6O1HK0zerq4rapEar2ZHa0Abqqirv/lKgRn4/JUtg0Uh
         jf+wK2kcq8FCWvv8GnPKQyyrOpTMaly68KHfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3No+CT4C6JsgDaXFKC6VJCRaElPlsQe+bs7JiqU9zJE=;
        b=Tdb1OxNxRVTwOufS82MDH92hWDng4nWYefQ/HgsypropQz8EPqPy9lD1ydQniSoaqI
         s4plMZ1P503Mco2yllKac5vpDLP+HWtWoIFP8oGGbsAnXQDDqkKFVogo8TrzNfmAopIJ
         1QDojpTe3J95uNLEbY7wFlDt9ldbyqe7K0tELdFjwHccsGi3R/w60HJ1fdcXMSDQMM4P
         J57wWPE/CZWectalxk1dXwGljlVnJ3y05I4K4AdpGy0aTCdqD1vzFFQzhUqdQncI6yOd
         wjFKMzgA0zZP4YnWRuYx8HDwwiVuyx82QBxKNZR4K67NXROv8+PSdKE8yvrExr/RuZml
         5gdQ==
X-Gm-Message-State: APjAAAUPMWxfHnUEUZOqg/wyWhvu2JeWi5BRobqCnKGnKB4kKQRAzyGp
        AKCdHmPatrJDdbMI/I20FcVXTSZcEUg=
X-Google-Smtp-Source: APXvYqwsO1zvIKHGr3qBK1bn5xdDFB8wplrHP1lS9PYLe+bPZNXHDGNnpgoSecnn94zTyUGBzW9ifA==
X-Received: by 2002:a6b:2b8b:: with SMTP id r133mr4502855ior.253.1573675397359;
        Wed, 13 Nov 2019 12:03:17 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id r22sm327241ioh.77.2019.11.13.12.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 12:03:16 -0800 (PST)
Subject: Re: [PATCH] rbd: update MAINTAINERS info
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Alex Elder <elder@kernel.org>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Sage Weil <sage@redhat.com>
References: <20191113200151.30674-1-idryomov@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <db22198a-3aaf-3e93-b742-c34d783ee4d9@ieee.org>
Date:   Wed, 13 Nov 2019 14:02:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191113200151.30674-1-idryomov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/13/19 2:01 PM, Ilya Dryomov wrote:
> Alex has got plenty on his plate aside from rbd and hasn't really been
> active in recent years.  Remove his maintainership entry.
> 
> Dongsheng is very familiar with the code base and has been reviewing rbd
> patches for a while now.  Add him as a reviewer.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Thanks Ilya.  Much as I'd like to, I can't keep up with
this very well, so I think this is the right thing to do.

Acked-by: Alex Elder <elder@kernel.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index eb19fad370d7..073cacc1b23c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13582,7 +13582,7 @@ F:	drivers/media/radio/radio-tea5777.c
>  RADOS BLOCK DEVICE (RBD)
>  M:	Ilya Dryomov <idryomov@gmail.com>
>  M:	Sage Weil <sage@redhat.com>
> -M:	Alex Elder <elder@kernel.org>
> +R:	Dongsheng Yang <dongsheng.yang@easystack.cn>
>  L:	ceph-devel@vger.kernel.org
>  W:	http://ceph.com/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
> 

