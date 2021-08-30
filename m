Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA333FB6A5
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Aug 2021 15:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhH3NCb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Aug 2021 09:02:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231531AbhH3NCa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 09:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630328496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nBYIBZVwSFYhLxLW2re90pmZfx7a/pl5Rh3Gnv3R4CA=;
        b=c6W7UpP9n3O1vZoae9CUNKvUkfEtra705Sj391RcuJvfC0mmx9v1MkjpamOhDvJh2o8h1X
        7ccJ+0oTEcHqf+M8ogyxNuGFTl86D/+VUL0nFfWK4v2MD4/Tsa/lISv8fqYV3lGo3axBgq
        hBD96z7oIcvTF3dlUiq1gHiIjvNsbI8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-Dg0-YdXgMdu8hkBFnw5R7w-1; Mon, 30 Aug 2021 09:01:35 -0400
X-MC-Unique: Dg0-YdXgMdu8hkBFnw5R7w-1
Received: by mail-pg1-f200.google.com with SMTP id d1-20020a630e010000b029023afa459291so6351pgl.11
        for <ceph-devel@vger.kernel.org>; Mon, 30 Aug 2021 06:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nBYIBZVwSFYhLxLW2re90pmZfx7a/pl5Rh3Gnv3R4CA=;
        b=ofyUE20aAddSZMVwf2Qpfhe4um6rCHyWFnrcITq3XFrUGGmWKMoKy3H+ahjibeB/FI
         cgO6G8MyqE1n43kp86XZlrtX0eV1CzmXkjPNlhV+yH4SA3Vh+IeAOczD5xYNbUAVYWvR
         3prJ9bnLuZRiDFJC4+fi2fU/5266GjwHI8OC24b4Y3InHk7o9DuBv6kSIe1Ksz5Yad5W
         mFuTZ6TNGsW5Nes2XMmXTW4L55pBnAa1EgWn5G/jz/NZxsj+Y6uRuGuctLSGuDeHr8e2
         n2y58ZH+AG1mN7HXyGr8HuaU0IffbA79zJQrhznbDLi/JJo460vrwpYYCkvHaR+IQr1Q
         pY+Q==
X-Gm-Message-State: AOAM530M8NSPorOISEOZR2X3x9rT1hAnDHHlmEyYmqcW7cWNqBullVYL
        UFu35V45AzukWT/8P7StfXxqqA6R66fndM9dXBVtZBg3lFFEzH6i01OfGB5zGNlqubwCGeN1NfD
        MtqiVYj6J9qRAoDzvG8gm8A==
X-Received: by 2002:a17:90a:5b0f:: with SMTP id o15mr38517445pji.97.1630328494226;
        Mon, 30 Aug 2021 06:01:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdxPG4WNdxxhgfefmq2mEq3UctORsJwa7BBwFEHxSG5JkbpsoGL/aLLJw61+fuMZGHNyL+gQ==
X-Received: by 2002:a17:90a:5b0f:: with SMTP id o15mr38517403pji.97.1630328493837;
        Mon, 30 Aug 2021 06:01:33 -0700 (PDT)
Received: from [10.72.12.157] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p9sm14827379pfn.97.2021.08.30.06.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 06:01:33 -0700 (PDT)
Subject: Re: [PATCH] ceph: ensure we return an error when parsing corrupt
 mdsmap
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, idryomov@gmail.com
References: <20210830121045.13994-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3de857b0-8b74-46ff-5159-887d5a732f1c@redhat.com>
Date:   Mon, 30 Aug 2021 21:01:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210830121045.13994-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/30/21 8:10 PM, Jeff Layton wrote:
> Commit ba5e57de7b20 (ceph: reconnect to the export targets on new
> mdsmaps) changed ceph_mdsmap_decode to "goto corrupt" when given a
> bogus mds rank in the export targets. It did not set the err variable
> however, which caused that function to return a NULL pointer instead of
> a proper ERR_PTR value for the error.
>
> Fix this by setting err before doing the "goto corrupt".
>
> URL: https://tracker.ceph.com/issues/52436
> Fixes: ba5e57de7b20 ("ceph: reconnect to the export targets on new mdsmaps")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mdsmap.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> I'll plan to fold this change into the original patch since it hasn't
> been merged yet. Let me know if you have objections.
>
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index d995cb02d30c..61d67cbcb367 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -263,8 +263,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>   				goto nomem;
>   			for (j = 0; j < num_export_targets; j++) {
>   				target = ceph_decode_32(&pexport_targets);
> -				if (target >= m->possible_max_rank)
> +				if (target >= m->possible_max_rank) {
> +					err = -EIO;
>   					goto corrupt;
> +				}
>   				info->export_targets[j] = target;
>   			}
>   		} else {

Make sense and LGTM.


