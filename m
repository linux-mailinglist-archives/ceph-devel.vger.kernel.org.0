Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2A646D3A3
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Dec 2021 13:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhLHMxT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Dec 2021 07:53:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233750AbhLHMxS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Dec 2021 07:53:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638967786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fadD3jsktIIzpxZnshgJSAADnoPGytJgwBg8svWXus4=;
        b=TpjMJzgY4f5lcT/Mt5EBRC7MjYZoymbyOEnpZk2Uo+K24B8a5ZAP+wB646+ldD2nzA1dMB
        7DciKkERr/5q3Cgrht5NlC2K+QJQsKa6aRb9Lf0bV5Rh9LFY7Z+ni5MsLvtb+22MKWw0Kc
        nuvkOTFHtk7FXApdEQE9X+lTE/Icgc0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-o36llqeOPUWTeOCsuorq1g-1; Wed, 08 Dec 2021 07:49:45 -0500
X-MC-Unique: o36llqeOPUWTeOCsuorq1g-1
Received: by mail-pf1-f200.google.com with SMTP id a207-20020a621ad8000000b004aed6f7ec3fso1536647pfa.2
        for <ceph-devel@vger.kernel.org>; Wed, 08 Dec 2021 04:49:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fadD3jsktIIzpxZnshgJSAADnoPGytJgwBg8svWXus4=;
        b=mEEY/yICNyukmtzufO1U+ZJs70B/ckMovhEB1OKpPNEnHYF1Kc3Ltzhhe/AZA/LIGb
         USW80bh/z0Iq/gRCach7nlnjBjBqr/7FoJSOQ9Q/Hqwyz9PQjGBq+iUbyJVQjE4Y1tII
         pKMqE/zgeynJUZT1g8cL/NB4dQ8JwJn+ptjIHbOrWydd3H9cyYj6Lj10SDRB25ksoDQN
         urDjY9CH9HVER5+BfJ6kTkNStdro8d4mqE9Q7UZGpTl6hzYqF+4V/DU2SLsYn6+4tRzu
         adQ6Cuk6w7T4fAGJLoxPV+thlpyjSMeeddjje8LUckbrQgDUhR54auDKIDSzHwmt5rP9
         GlEw==
X-Gm-Message-State: AOAM532X2ATu50vU3SDy4vu6acMBAeGl5Y6XacFQCyAS1ZyOfe2ZQt5i
        C/k6WxTNYDzPFKwJlDLTihqQYHs4aCcm76EidecYZZyhE0T+lCzoUnWPxyrhi/gQK0xG5yf5VE8
        Vz3nLUeHKqehm1z6X4imUkSb6vO+UVqC03reP1FHLzi2MvRGDtgcJLykn3pxxpphK3kPa1TQ=
X-Received: by 2002:a17:902:728e:b0:143:a388:868b with SMTP id d14-20020a170902728e00b00143a388868bmr59610982pll.33.1638967783863;
        Wed, 08 Dec 2021 04:49:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzCvM/9Cm2hm5FBdux7rpitfF9+xKNUYm5KkPhBvpEfwcLTI372c9MgEscJ7QMVXdsiSo3Tpw==
X-Received: by 2002:a17:902:728e:b0:143:a388:868b with SMTP id d14-20020a170902728e00b00143a388868bmr59610953pll.33.1638967783570;
        Wed, 08 Dec 2021 04:49:43 -0800 (PST)
Received: from [10.72.12.131] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c21sm3755454pfl.138.2021.12.08.04.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 04:49:43 -0800 (PST)
Subject: Re: [PATCH v7 0/9] ceph: size handling for the fscrypt
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211208124528.679831-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <65a770f9-f951-1ced-57ee-2aac597d8951@redhat.com>
Date:   Wed, 8 Dec 2021 20:49:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211208124528.679831-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

Please replace the #8 and #9 patches on top of "wip-fscrypt-size" branch.

Thanks,

On 12/8/21 8:45 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> Changed in V7:
> - Use the u64 instead of object version struct.
>
>
> Changed in V6:
> - Fixed the file hole bug, also have updated the MDS side PR.
> - Add add object version support for sync read in #8.
>
>
> Xiubo Li (2):
>    ceph: add object version support for sync read
>    ceph: add truncate size handling support for fscrypt
>
>   fs/ceph/crypto.h |  21 +++++
>   fs/ceph/file.c   |   8 +-
>   fs/ceph/inode.c  | 223 +++++++++++++++++++++++++++++++++++++++++++----
>   fs/ceph/super.h  |   8 +-
>   4 files changed, 242 insertions(+), 18 deletions(-)
>

