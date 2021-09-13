Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486084096D5
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 17:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344965AbhIMPO2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 11:14:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346601AbhIMPOU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 11:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631545983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aMTXnPIYOjMpokXaw5YGq+J6wk5pTT12sO3I3k96zWA=;
        b=G8bywEOJ0mCpHdYPTRjQZHIAuE/pdZxqLZ7HTbriKLEiMJLBtD1qS7j7Ciu7RzcT0d8BNe
        a1vbxpwtnRZHklAIFaRMy6wkIeSTFojhj2ik9VUFZ4YGlq8+qNL/PCFGtoojXYmo9nzjWt
        jbtlPjQsyKSFa4UFawKaP7oXs/jlmsA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-WyHYifvKOwmM0ZfwlEGfWA-1; Mon, 13 Sep 2021 11:13:02 -0400
X-MC-Unique: WyHYifvKOwmM0ZfwlEGfWA-1
Received: by mail-qv1-f69.google.com with SMTP id u8-20020a0cee88000000b00363b89e1c50so55976680qvr.16
        for <ceph-devel@vger.kernel.org>; Mon, 13 Sep 2021 08:13:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=aMTXnPIYOjMpokXaw5YGq+J6wk5pTT12sO3I3k96zWA=;
        b=idtQZZKIlatEndqtC/W9cVXNqRnPNGtxzvCCgHeQDrciwnV5iN0sDInpE0oaOxtW7q
         kWEY6LLhAEd6NcHgrLbIrIeXyOABR1DympOEECcBpGxzh7jcx0Za53f9koGpdtpwlNfS
         WQ7GtQQHILgOXbhxoxRAPwJmD2PK/wu1KbyDkMqLZrHWU3DeVtLBkUqByGF/RkmZnARI
         hcPG9/YNRnd9szPiTBY4C7Ok7dtRIjNUhrUUVWBxQQpRBYXtpaRIS8VwqoiNSTEsj4wX
         8Bz8sYITXwJeF34HgTUN9/4+Jy69aYK1eou12KqllPsNUnBAy7efsUEas2AqXT589SGz
         dV2Q==
X-Gm-Message-State: AOAM530uGAC5i8wNdXVjYe93+pFLC9tRh4PbCPjAnXdneDXxyiurIw2j
        4Tq9ORZKX7SmHM0SHq8ejzeJP7BaDVtZwbsNMDgT6KN+m09Gy1HBF6yC7SnP3995WjiciYlUOrx
        BDE8oN79ssqovoSr5UBpXkw==
X-Received: by 2002:a37:58b:: with SMTP id 133mr107054qkf.146.1631545982253;
        Mon, 13 Sep 2021 08:13:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwL1Y0MRfC0Ph9zZ/34K8iLGY3gLQJKe1uKG81eJAwh3XUnnIflG6WnTIuMw6YFgxHh8hCQbw==
X-Received: by 2002:a37:58b:: with SMTP id 133mr107035qkf.146.1631545982076;
        Mon, 13 Sep 2021 08:13:02 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id w20sm4288184qtj.72.2021.09.13.08.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 08:13:01 -0700 (PDT)
Message-ID: <22e110d00df3d02157222754f01fc6143cb40764.camel@redhat.com>
Subject: Re: [PATCH v1 0/4] ceph: forward average read/write/metadata latency
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com,
        xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Mon, 13 Sep 2021 11:13:00 -0400
In-Reply-To: <20210913131311.1347903-1-vshankar@redhat.com>
References: <20210913131311.1347903-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-09-13 at 18:43 +0530, Venky Shankar wrote:
> Right now, cumulative read/write/metadata latencies are tracked
> and are periodically forwarded to the MDS. These meterics are not
> particularly useful. A much more useful metric is the average latency
> and standard deviation (stdev) which is what this series of patches
> aims to do.
> 
> The userspace (libcephfs+tool) changes are here::
> 
>           https://github.com/ceph/ceph/pull/41397
> 
> The math involved in keeping track of the average latency and stdev
> seems incorrect, so, this series fixes that up too (closely mimics
> how its done in userspace with some restrictions obviously) as per::
> 
>           NEW_AVG = OLD_AVG + ((latency - OLD_AVG) / total_ops)
>           NEW_STDEV = SQRT(((OLD_STDEV + (latency - OLD_AVG)*(latency - NEW_AVG)) / (total_ops - 1)))
> 
> Note that the cumulative latencies are still forwarded to the MDS but
> the tool (cephfs-top) ignores it altogether.
> 
> Venky Shankar (4):
>   ceph: use "struct ceph_timespec" for r/w/m latencies
>   ceph: track average/stdev r/w/m latency
>   ceph: include average/stddev r/w/m latency in mds metrics
>   ceph: use tracked average r/w/m latencies to display metrics in
>     debugfs
> 
>  fs/ceph/debugfs.c | 12 +++----
>  fs/ceph/metric.c  | 81 +++++++++++++++++++++++++----------------------
>  fs/ceph/metric.h  | 64 +++++++++++++++++++++++--------------
>  3 files changed, 90 insertions(+), 67 deletions(-)
> 

This looks reasonably sane. I'll plan to go ahead and pull this into the
testing kernels and do some testing with them. If anyone has objections
(Xiubo?) let me know and I can take them out.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

