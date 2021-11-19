Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3D1456931
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Nov 2021 05:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhKSEhC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Nov 2021 23:37:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42441 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233172AbhKSEhB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 23:37:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637296438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a7CslRJNldv49TVkayaLdDea0/X8b9W6w+cTZhBRvk8=;
        b=S+rjwOhUDtrckKfpiRoZOx7pqgtommKlZjip+kmsj2e0qIeklIUqLG0yfpA5z3VxtxneWd
        91m6OE7xMBR4vUFjIBlQUhgxScykuGrlXjfWUx5twtwEHI2A39iKkWJc9iPgIXaksVXhA0
        MgDooFUjqsKia5W1nAoVum9aDt+BNzQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-Pj4ZWkpWNLKXd-CX8Q1Eng-1; Thu, 18 Nov 2021 23:33:57 -0500
X-MC-Unique: Pj4ZWkpWNLKXd-CX8Q1Eng-1
Received: by mail-pl1-f200.google.com with SMTP id z3-20020a170903018300b0014224dca4a1so3941345plg.0
        for <ceph-devel@vger.kernel.org>; Thu, 18 Nov 2021 20:33:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=a7CslRJNldv49TVkayaLdDea0/X8b9W6w+cTZhBRvk8=;
        b=qYI2EXD0jFrYECiXhAOKiPbC2OUfPmXYKyD1yoYOI6k33lYOISzqy09ZPv3pFSxNq1
         LCI6AE9I0NwQGUDPVlStWcMkRGR5YPG03/6FRU/dXDgL3afvyOQGTPnGlmC+1gsxtE1j
         SgofbaFnGH5QMx94CS5IdEvpdfK731039F8la3p3OXcdnrFk9ixZy4SlTKfLtEceC/Iw
         qcKuw9bSKi4JmBiRFnt+B5wNdjw0ei1zTFoBAy2IX8YxLITx0GA1qGWCuzmn9NBjxRUK
         WhYFF5iGc8PYjWXfAmNv6fTgz2yweVM+Tfwl+5a5Rvja/QLTBNNQfymiQ1k87lYXcLGd
         2A5w==
X-Gm-Message-State: AOAM531wKZZgLwGluxkdsc+FFUelSBJTwxAMTnRjrGNH/crq0Xv/Ateo
        seszrah4bJqt+3tgdRPyn2xXBcF3w5B4eiyrnalO56lWmaKT5sy4SLCe232yuYA1bx+MwC6OoGq
        XrgTYdaCrNdB9K5XLTeq/vZkSA60ZEnczjV2rIDWPmhYjqifVwzqSgvciyaW+nsWLaWEFkQ8=
X-Received: by 2002:a63:f246:: with SMTP id d6mr15458604pgk.333.1637296436199;
        Thu, 18 Nov 2021 20:33:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxedEP9SadAa4XUGzyMF2nROiRVm9u4FZJ0xSkjidlRQoSxv5MTWsS76mDvYRswsyUiAkKGqg==
X-Received: by 2002:a63:f246:: with SMTP id d6mr15458579pgk.333.1637296435898;
        Thu, 18 Nov 2021 20:33:55 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j6sm878680pgf.60.2021.11.18.20.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 20:33:55 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <09babbaf077a76ace4793f2e6ae6127d2e7d6411.camel@kernel.org>
 <1a6b7a20-ba30-0b57-3927-2b61ad64be28@redhat.com>
Message-ID: <7e2280b9-c20b-d770-4144-be44a03ec653@redhat.com>
Date:   Fri, 19 Nov 2021 12:33:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1a6b7a20-ba30-0b57-3927-2b61ad64be28@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

[...]
> 3540 trunc    from 0x789289 to 0xd8b1
> 3542 write    0x8571af thru    0x85e2af    (0x7101 bytes)
> 3543 trunc    from 0x85e2b0 to 0x7dc986
> 3550 read    0x3b37bd thru    0x3b50a8    (0x18ec bytes)
> 3551 mapread    0x686907 thru    0x693eb9    (0xd5b3 bytes)
> READ BAD DATA: offset = 0x686907, size = 0xd5b3, fname = 112.2
> OFFSET    GOOD    BAD    RANGE
> 0x686907    0x0000    0x198f    0x00000
> operation# (mod 256) for the bad data may be 143
> 0x686908    0x0000    0x8fec    0x00001
> operation# (mod 256) for the bad data may be 143
>
> In theory that range should be truncated and zeroed in the first 
> "trunc" from 0x789289 to 0xd8b1 above. From the failure logs, it is 
> the same issue with before in generic/057 test case. But locally I 

s/057/075/


> couldn't reproduce it after I fixing the bug in ceph fsize_support 
> branch.
>
> BTW, could you reproduce this every time ? Or just occasionally ?
>
[...]

