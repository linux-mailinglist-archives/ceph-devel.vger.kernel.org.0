Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6483D24A002
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 15:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgHSNcl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 09:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgHSNcL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 09:32:11 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D776C061383
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 06:32:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g15so6930149plj.6
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 06:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vMNQ6WK7crIn272Njmors6Hr7L8KSr+wNL70fKp0QVw=;
        b=ER65C1q9ts0AvzjOkb5ItKsKgaGf+Stame9zTWvpH+W/eE3pfo8xbS5mVPX+ux1tp4
         NnqiJa1D6gM8lTIj0O0HudUaGnj0E72mbY46MdQo0gUKnYT/X7JR2uBAfGJ6BX73fswg
         mz+ZnPuT//vA4XteJ1mIJJfslSpiUu/LMXb14SvmTVML0uYnjnbvtvxYQqaHsO+HxWBS
         IsOX8kKXxfhQyYqVMKMcX58hvz9rTRCncpiIVTpkjkvttRIwOJnxucHhfMfHPPOiYIrs
         2NppMs6yKeZg/M2sJLG2KbPtsdsP7PKPWqP6giZHx6k1lh8oM+b8D8GrCwmeMnffJjmR
         2ZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vMNQ6WK7crIn272Njmors6Hr7L8KSr+wNL70fKp0QVw=;
        b=ee0ptzMfQ6/sZXzt2titL3RM9RU0YPKDimWcsqz8NjtnjNfzSJ8oucBth7XMml8TVr
         bUGSuJ2h/ehGnNgBnJNBCD486U9Itdvh9wzMVBfgTN+d8A23RoIa8kO+m5jSooY7/yvC
         vT/hi90gBjofMeyXsb/CEVUJizBw/hgUTUO6/v3FhcZ5eyCPXEXDpT8sbRAcYf9Abe8z
         Flmk0kiiXnmLpF9aNqP/IfcpG99M0GNF8hkeN91I0FS0JswNDIw+itWMOzmlTQ1vrkfG
         GsNz5oN90oPaXMztq/JVkIGax4O3K1JVfafmOeliNfZNgB9Pu5Jf1Md6tmKBl0X89T+O
         ksYQ==
X-Gm-Message-State: AOAM533DtLS4gZffekuLTNehGueCtsHtrC11sOQuWBSAl9Mvi6SWeTT/
        MAqpxCEiYAfkLBha+h6B8qaxlw==
X-Google-Smtp-Source: ABdhPJykv40VOJjwPlf0c0xhI2b3f3WFmQQZcnLGRKru6GMjGBGKeeJCa2+T+ArRdO1dlue8HV8LYw==
X-Received: by 2002:a17:902:6a8b:: with SMTP id n11mr5310699plk.75.1597843929467;
        Wed, 19 Aug 2020 06:32:09 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id fa14sm2190486pjb.14.2020.08.19.06.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 06:32:08 -0700 (PDT)
Subject: Re: [PATCH] rbd: Convert to use the preferred fallthrough macro
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200819085304.43653-1-linmiaohe@huawei.com>
 <1968d5b6-3543-a213-4118-9c36f9a48343@kernel.dk>
 <CAOi1vP85Jkc51LStsg9Mz0Q0W-s17LcOmvavc=k_X9KF9ML_2A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <338ecba5-c0ea-bdc0-1bcb-5b739f90cf9f@kernel.dk>
Date:   Wed, 19 Aug 2020 07:32:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP85Jkc51LStsg9Mz0Q0W-s17LcOmvavc=k_X9KF9ML_2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 8/19/20 6:31 AM, Ilya Dryomov wrote:
> On Wed, Aug 19, 2020 at 3:03 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/19/20 1:53 AM, Miaohe Lin wrote:
>>> Convert the uses of fallthrough comments to fallthrough macro.
>>
>> Applied, thanks.
> 
> Hi Jens,
> 
> This has already been folded into another patch in ceph-client.git.
> Please drop it.

Dropped.

-- 
Jens Axboe

