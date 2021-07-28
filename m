Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8698F3D8562
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Jul 2021 03:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhG1Bbh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jul 2021 21:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbhG1Bbg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jul 2021 21:31:36 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2653AC0613C1
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jul 2021 18:31:36 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e14so729057plh.8
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jul 2021 18:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yHc64D7GeFGFvPKcL3/klEXdsXGAyEbOGkW4X7dqYZk=;
        b=fhSYS231qJ3sqkIYNi8KPw8MsfS0+ziEaNeUJJgkWRoGnsw+X6Zela3vLGucwxsOnQ
         T/2eQecJMaDAtj1/fJv4pRgNYPjG5MBwhmQRzKVK7XHucRr9VlsyFnemk7Az0cFRvaoj
         SXA55eSG8LWFjpI5M4/vVkrChJvWZRFUIvXxtX/YyI6Hetmvo8xUU0IsYqW0uPaYORh+
         7fbNsmk6bU1nDAoUQ8bBanH/4Fg5DnH45lOS4h8rnJCcsSof3DVR671BuFi4Ezu9qGFc
         pniezhy1QlK6TDYbbPRo+6/gzTozJcEPXqbmDtUTOLhYVoF+8NtbsE0cFeksRw7VSH/K
         7dzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yHc64D7GeFGFvPKcL3/klEXdsXGAyEbOGkW4X7dqYZk=;
        b=X5JWxuI04XOSKFUb2dCKuqntKT986gMW7TFvTcZw9BCWJ5DmA0iV+vWFZ+NH+Oiwo+
         ud4tNHgW/eBw03ak82MCj4YKrTLsPJYdqp1Enh7CMFlSiEouuO6ZMX0bT+M7G6UhH2Hi
         Y627/wqOBJ9rxpGKYQVvBNLltEYU128ZItOF/t0C6+iykOSyyxPUvc96LeUTEgfCDJpA
         58hpn36xU8WJFifdt9lJ5ndsG+foFjHzG9An9ptiJqvQLzg6OENe+uHKb+3vLqxC+YDP
         Mgn4rettmSFaVL49qmCpVSVYGtHWjcDDPHYPpCnZXqCxAbF0GMYKKMkXvKRjFjo8Q9dE
         O11g==
X-Gm-Message-State: AOAM533vWbia9SzrwqoR/7GUOemcN+wF9BNhfqiFjert+cJLihUxL0FE
        bTxctjJsPK2dZ6aUAw0FSQ2yrA==
X-Google-Smtp-Source: ABdhPJzWMYJQkYrSLemCw68WHvxxx2yrrdVHcAiwavOx0x2TeSqkNy6ZylLwTbIdJTyjO+rAuqNUqw==
X-Received: by 2002:a62:b414:0:b029:317:52d:7fd5 with SMTP id h20-20020a62b4140000b0290317052d7fd5mr25840599pfn.30.1627435895354;
        Tue, 27 Jul 2021 18:31:35 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id a16sm5054336pfo.66.2021.07.27.18.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 18:31:34 -0700 (PDT)
Subject: Re: switch the block layer to use kmap_local_page v3
To:     Christoph Hellwig <hch@lst.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Mike Snitzer <snitzer@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ira Weiny <ira.weiny@intel.com>, dm-devel@redhat.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        ceph-devel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20210727055646.118787-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eba0b98f-5b0e-32c4-3b09-fa1946192517@kernel.dk>
Date:   Tue, 27 Jul 2021 19:31:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210727055646.118787-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 7/26/21 11:56 PM, Christoph Hellwig wrote:
> Hi all,
> 
> this series switches the core block layer code and all users of the
> existing bvec kmap helpers to use kmap_local_page.  Drivers that
> currently use open coded kmap_atomic calls will converted in a follow
> on series.
> 
> To do so a new kunmap variant is added that calls
> flush_kernel_dcache_page.  I'm not entirely sure where to call
> flush_dcache_page vs flush_kernel_dcache_page, so I've tried to follow
> the documentation here, but additional feedback would be welcome.
> 
> Note that the ps3disk has a minir conflict with the
> flush_kernel_dcache_page removal in linux-next through the -mm tree.
> I had hoped that change would go into 5.14, but it seems like it is
> being held for 5.15.

Applied for 5.15, thanks.

-- 
Jens Axboe

