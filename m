Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67FC40C560
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Sep 2021 14:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhIOMhn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Sep 2021 08:37:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232824AbhIOMhj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 08:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631709380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CD+fx5XEf0nS/ouApwkDuA2n8LL5Ran6pwtmgvls0hs=;
        b=KrM5qGJO1tlLsiSOjYsGM2UD+bKUkOkTr2r2ykvgcbHK0ylssTqL5IKRtontEfVrZlp6U3
        Vsuw6M84cF+RCdBaKUqHXg4+2zBbbvriP0O6zWIn58/S1iO9mFB2L4olcjG/KSiJrsOYgr
        2EIy9Mlgwg+BlrWjiHbPqg3kss4SjSs=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-YIRD7M51O2-rVQJfUMj8dw-1; Wed, 15 Sep 2021 08:36:19 -0400
X-MC-Unique: YIRD7M51O2-rVQJfUMj8dw-1
Received: by mail-il1-f200.google.com with SMTP id o12-20020a92dacc000000b00224baf7b16fso1903382ilq.12
        for <ceph-devel@vger.kernel.org>; Wed, 15 Sep 2021 05:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CD+fx5XEf0nS/ouApwkDuA2n8LL5Ran6pwtmgvls0hs=;
        b=zWCYIgW8ZYBaZPNrIwaRa3Gpl0jDp9LbC6rMXLSChMm7R4QoyXN1bMWHkY4ilcrjEg
         UxeNfWfJKWBqjuSC9FM+5okiwb9FTVXZJVaw3WXRYIy2/0brCPchcC0NA4GUacwgujxI
         O5Dbsc7f3ox9cSZyGPUz8eu9LPIv46B56l+SkP8nHqMmiddhWYJ+WPf9GyPdVpQABqtY
         phTOnfAmz1/A0HnwejYGN/W2nw5k6f973B4qYfqHMGGQIY0DndwtYiBEuKx6VMuULXvE
         13Gl9iFYV8ZpwHyJ53gJmaBVNq5KjkQJgSzV8dE6a+Cdx+WXG52ZGcfWYOJliBohmb5a
         Z66Q==
X-Gm-Message-State: AOAM531FHL7XALHXviGXD1W0l3WTfcF3KuyatdXWR4X+qsHt0TxCVMAN
        zw1klKXaHbvB9C/WEOUOkoWZLomSpsHMfJG3nc1p7dKkXlbot5OX+WIImo3ReDD6wdBdRwL7rQp
        g2lUstqi9rdpMDCvn8gwqCSvQ9atpMGjss3yD3dxYdzAfqmV3cweZ0QpSAjQlGxYccnUHqdSj
X-Received: by 2002:a6b:8f94:: with SMTP id r142mr18033712iod.183.1631709377883;
        Wed, 15 Sep 2021 05:36:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb2FlL9HPMyvJwf59DelQrO/gy5Z23wvKrOWz6OFvnlyUv9+pWzlgzKUVRQwd/hK9BBX49kA==
X-Received: by 2002:a6b:8f94:: with SMTP id r142mr18033694iod.183.1631709377633;
        Wed, 15 Sep 2021 05:36:17 -0700 (PDT)
Received: from [192.168.50.212] (c-73-94-106-141.hsd1.mn.comcast.net. [73.94.106.141])
        by smtp.gmail.com with ESMTPSA id t10sm8615428iol.34.2021.09.15.05.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 05:36:17 -0700 (PDT)
Subject: Re: CephFS optimizated for machine learning workload
To:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
From:   Mark Nelson <mnelson@redhat.com>
Message-ID: <95d4b624-2114-832f-ed80-f7f0e7d35a3c@redhat.com>
Date:   Wed, 15 Sep 2021 07:36:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Zheng,


This looks great!  Have you noticed any slow performance during 
directory splitting?  One of the things I was playing around with last 
year was pre-fragmenting directories based on a user supplied hint that 
the directory would be big (falling back to normal behavior if it grows 
beyond the hint size).  That way you can create the dirfrags upfront and 
do the migration before they ever have any associated files.  Do you 
think that might be worth trying again given your PRs below?


Mark


On 9/15/21 2:21 AM, Yan, Zheng wrote:
> Following PRs are optimization we (Kuaishou) made for machine learning
> workloads (randomly read billions of small files) .
>
> [1] https://github.com/ceph/ceph/pull/39315
> [2] https://github.com/ceph/ceph/pull/43126
> [3] https://github.com/ceph/ceph/pull/43125
>
> The first PR adds an option that disables dirfrag prefetch. When files
> are accessed randomly, dirfrag prefetch adds lots of useless files to
> cache and causes cache thrash. Performance of MDS can be dropped below
> 100 RPS. When dirfrag prefetch is disabled, MDS sends a getomapval
> request to rados for cache missed lookup.  Single mds can handle about
> 6k cache missed lookup requests per second (all ssd metadata pool).
>
> The second PR optimizes MDS performance for a large number of clients
> and a large number of read-only opened files. It also can greatly
> reduce mds recovery time for read-mostly wordload.
>
> The third PR makes MDS cluster randomly distribute all dirfrags.  MDS
> uses consistent hash to calculate target rank for each dirfrag.
> Compared to dynamic balancer and subtree pin, metadata can be
> distributed among MDSs more evenly. Besides, MDS only migrates single
> dirfrag (instead of big subtree) for load balancing. So MDS has
> shorter pause when doing metadata migration.  The drawbacks of this
> change are:  stat(2) directory can be slow; rename(2) file to
> different directory can be slow. The reason is, with random dirfrag
> distribution, these operations likely involve multiple MDS.
>
> Above three PRs are all merged into an integration branch
> https://github.com/ukernel/ceph/tree/wip-mds-integration.
>
> We (Kuaishou) have run these codes for months, 16 active MDS cluster
> serve billions of small files. In file random read test, single MDS
> can handle about 6k ops,  performance increases linearly with the
> number of active MDS.  In file creation test (mpirun -np 160 -host
> xxx:160 mdtest -F -L -w 4096 -z 2 -b 10 -I 200 -u -d ...), 16 active
> MDS can serve over 100k file creation per second.
>
> Yan, Zheng
>

