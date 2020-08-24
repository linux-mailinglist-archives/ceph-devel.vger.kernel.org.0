Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D18A24F7B6
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Aug 2020 11:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbgHXJUj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 05:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730500AbgHXJUa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Aug 2020 05:20:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29522C061575
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 02:20:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q93so3094631pjq.0
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 02:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KQzdEJUadSVD+lgD6sVSSDMTvkRGkwdel+4+TdgeUE4=;
        b=S1z/AmmNOCH9afSNr/qrDInALgK0j4q5VYp45vGoszL08gQOq77XWvhovm91maa4+P
         FqKO0IvQQ1zgFOTeD7xwiYdXCC4eSy866y0i4iOHUdhtIcu9OyTLXqq9sIjITeHIlDP/
         TqDQL3++BGqzXH8U95cUEVFQg9f7Oyelz1pTusAebmjo7UGy1iK4oNwyu8zu1fDcAfPX
         nbF7uSCxB/11Zqo85kx55hx/wYlWNGXWIUW2MXqUz8acgYZGRkoKmiKOAMbN76qrQ5Ur
         CsLY7wA5OwEKSwWBknbMM6OhsOsgmjQ3BQKlOzM52TKrjGMbACD7aubcslrIXV21mpIp
         D4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KQzdEJUadSVD+lgD6sVSSDMTvkRGkwdel+4+TdgeUE4=;
        b=mo7Gx7P+Cub25VtW3pe1sSf+65P5BOv7pozECmk8XzAp1/dhVUrwWvPkOpkMVOCvzR
         I9AWKJO4IZSyGbUfhWO8u/k7GxP8upYhqTiNKBM0KXddmDn3xk0bFKKwhJyg+8Bdgi4z
         Ih9cyJ6l0/hsGvLA5ebJRlig3xK5p9gY5MwCVW0sP4ill4Hy2cHpiLir79iUCf+cWL8Q
         P3o5FhrGXdMMkT0cZFw5A1PUgembmYYk+6NCJuNn4zZngXxzMCiFqueJv/SpFqBQq8cG
         3srdFtB8yrjKNF+wLWhL1y9lKXi87cAKG8+yh9BNS1GASpHfx0QrLPCyVIb4m5qVeiA1
         862A==
X-Gm-Message-State: AOAM532/j3rYkdnkmUbDhqRl6OYQWjOFtQexjd2FhXVuZnoSdSfSyZvZ
        C2r/+fK17M/iTDQXjkehdjfWVA==
X-Google-Smtp-Source: ABdhPJyCrZvD6mxlThjGGxFBbEkhy5RNyLB5+uuwXeW5h1XhNu5PQ5mV/pcyDAllrzYkYjEheHn/mA==
X-Received: by 2002:a17:90a:f994:: with SMTP id cq20mr3717444pjb.229.1598260828641;
        Mon, 24 Aug 2020 02:20:28 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x144sm897257pfc.82.2020.08.24.02.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 02:20:27 -0700 (PDT)
Subject: Re: [PATCH 4/5] bio: introduce BIO_FOLL_PIN flag
To:     Christoph Hellwig <hch@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20200822042059.1805541-1-jhubbard@nvidia.com>
 <20200822042059.1805541-5-jhubbard@nvidia.com>
 <20200823062559.GA32480@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d75ce230-6c8d-8623-49a2-500835f6cdfc@kernel.dk>
Date:   Mon, 24 Aug 2020 03:20:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200823062559.GA32480@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 8/23/20 12:25 AM, Christoph Hellwig wrote:
> On Fri, Aug 21, 2020 at 09:20:58PM -0700, John Hubbard wrote:
>> Add a new BIO_FOLL_PIN flag to struct bio, whose "short int" flags field
>> was full, thuse triggering an expansion of the field from 16, to 32
>> bits. This allows for a nice assertion in bio_release_pages(), that the
>> bio page release mechanism matches the page acquisition mechanism.
>>
>> Set BIO_FOLL_PIN whenever pin_user_pages_fast() is used, and check for
>> BIO_FOLL_PIN before using unpin_user_page().
> 
> When would the flag not be set when BIO_NO_PAGE_REF is not set?
> 
> Also I don't think we can't just expand the flags field, but I can send
> a series to kill off two flags.

(not relevant to this series as this patch has thankfully already been
dropped, just in general - but yes, definitely need a *strong* justification
to bump the bio size).

Would actually be nice to kill off a few flags, if possible, so the
flags space isn't totally full.

-- 
Jens Axboe

