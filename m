Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4127249EFD
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 15:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgHSNEL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 09:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbgHSNDx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 09:03:53 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50FCC061383
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 06:03:52 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mt12so1085720pjb.4
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 06:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xSNMFlLKMxGrhzSOSB0eVoDmjD0XhuL86GrYJiKVF9s=;
        b=GHo2+XclsexMdeg0w7FyVGIexz5XELUhRHnUFYi4SnpLXT5E1N7oEzYpR8ESQgtniR
         wnVamMa7081QYZKDuDgIyLiIdkMMLbAKLRYSAGMkSTD8yqB1mcSsQuq9+UfA9E1tbzrC
         j1Cw6sJd2TwupmTCxK8wYYZgh2FnwZkkXnshSViILSmakfWAHMXRE9k+VBLDMS9la8zb
         9qzrsVI3w7V9phaJDNQk6u/A7IPGj7R5+M3BksfnHX4Wa2HO+n1VpHS7mHhXu7oDJ4C/
         LzEi33SzL7tu/LHzIK1SsOYn+7kqGMG9eVk1BnEPgtcKr85GLb1OQNiJjr8hqFM38faL
         RHTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xSNMFlLKMxGrhzSOSB0eVoDmjD0XhuL86GrYJiKVF9s=;
        b=uTYoAFqn3z/TulwW+xEp6etiE7x8yMGp73axowF6JTgiYjmWspTlTCI7B2kI2jS85P
         LwSviH5vWGYR93BHyzqOgwprIUvB6MCjf5hrz3JkwxnU7wu7MerHMyu3+qW3r5yv1z9t
         2osRe7osDog6ooM8NZtg1cKuuStO1S+T7iTimY0cPdy49VECPjieFDLQWB2tfi1BoMsn
         S+vqZYPSINSgUYqlY4IEovNp8wB1RXMsbssGYu/1RK24GJ6Tb3EztqO/q3jMVspNzrMg
         v2NsbqtFYu0kZUYOnbkj/TY/QdOC3rQNQAYB6e4OcFIJsy+pzOb1ekK+OyRoyAUaFjQS
         LkWw==
X-Gm-Message-State: AOAM530bb6RQFV67VguJHZ1DriYhs7qItq8oapDZE6kMVoPpk/JPcknd
        t2z/2qqtGNOrQ3lUZQ3e01Qskg==
X-Google-Smtp-Source: ABdhPJyAqDKTIKjRMLUlf2JvyMO4Oq4Y9F0jTYUv2JtPFsTI/9cHbkbI6REdfYKzhINRhOdB2CHhWQ==
X-Received: by 2002:a17:90a:cc14:: with SMTP id b20mr3862322pju.1.1597842232486;
        Wed, 19 Aug 2020 06:03:52 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z23sm24146798pgv.57.2020.08.19.06.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 06:03:51 -0700 (PDT)
Subject: Re: [PATCH] rbd: Convert to use the preferred fallthrough macro
To:     Miaohe Lin <linmiaohe@huawei.com>, idryomov@gmail.com,
        dongsheng.yang@easystack.cn
Cc:     ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200819085304.43653-1-linmiaohe@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1968d5b6-3543-a213-4118-9c36f9a48343@kernel.dk>
Date:   Wed, 19 Aug 2020 07:03:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200819085304.43653-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 8/19/20 1:53 AM, Miaohe Lin wrote:
> Convert the uses of fallthrough comments to fallthrough macro.

Applied, thanks.

-- 
Jens Axboe

