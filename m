Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B583440AE49
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 14:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhINMzP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 08:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232664AbhINMzP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 08:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631624037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UpdRELsmhQ7xDCOPyRLAF8zxPxIHMHp2sJaW5LXdMM4=;
        b=TMtC31oHFNAMlvf3Uke1tnc1ZZPszCOMCdCTX24sezs+9HrKMrgy7RJiJzfPYAtXYf+cl4
        MqidMSLhsnedeBVn2wTJo2kNjGB59lm6oebzx6c/tHdC6SCBEJ38lcAcMR9CCu47X+4pQE
        dNtGI6rlK9Mg0hh5EgP05p+vt8FJmJc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-mfO_wtBDM-KjS_cWK2aPIw-1; Tue, 14 Sep 2021 08:53:56 -0400
X-MC-Unique: mfO_wtBDM-KjS_cWK2aPIw-1
Received: by mail-pf1-f199.google.com with SMTP id q8-20020aa79828000000b0043d5595dad4so3951341pfl.13
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 05:53:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UpdRELsmhQ7xDCOPyRLAF8zxPxIHMHp2sJaW5LXdMM4=;
        b=j3TeiHHmLerpQHNdln8epjzFHN+IKBbRtWSvPtIzLg7YRm5XzjED+iz+FbF2dArG/o
         4AeR9+J7AwkQ4uqhTLYBm8Ela/6JULcoz9fApABv2OM5hCjKS4cUvBXV1rzcF+aU7iZh
         ISdpVOih7oBdRzN3qNo3h04V9Xirvimt8kljMcRaARTKhpyfZtVrAkEf0wOttrriK+e8
         6/oxw10yjh4BgQk2eMMP4S85xUjyiQe56oZxKJJ+cu311t4bh57mSjCAgigzkw4iXnfJ
         sOXgVXDhNLGmUSTO5CzdJ0W75Sp0aYnDDpx1aPi4H9Gm2A4HNeBRz1URIuO1jFqYQLb2
         5FVQ==
X-Gm-Message-State: AOAM530AE2+hY7hc78iJAPsyDonKIFZRfSwrcodBrjZEjW0XkYT+t4nG
        a+0L7FGPDeDj4vTXQzpUThw+XAYbk2Ud8SaRr0e0pXbM7eTZpWTJn+CtxO7Xna9NKNa8RHXYnOP
        AuAeKz7G4WL+DRyutTpWrSOoEUBIxQMKF63AuOTrfKRixDN6876U2//Z/BKkiC/7wK8BP4LM=
X-Received: by 2002:a17:902:7c83:b0:13b:721d:f786 with SMTP id y3-20020a1709027c8300b0013b721df786mr15059480pll.70.1631624035261;
        Tue, 14 Sep 2021 05:53:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7BULxosOzuMTyWxb8DluFq84pT/WWpB3wSJiDM3ETIx+dBOMIlNJnVFpEGKkvkddWHlVoQw==
X-Received: by 2002:a17:902:7c83:b0:13b:721d:f786 with SMTP id y3-20020a1709027c8300b0013b721df786mr15059458pll.70.1631624034892;
        Tue, 14 Sep 2021 05:53:54 -0700 (PDT)
Received: from [10.72.12.89] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u24sm10600378pfm.85.2021.09.14.05.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 05:53:54 -0700 (PDT)
Subject: Re: [PATCH v1 0/4] ceph: forward average read/write/metadata latency
To:     Jeff Layton <jlayton@redhat.com>,
        Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
References: <20210913131311.1347903-1-vshankar@redhat.com>
 <22e110d00df3d02157222754f01fc6143cb40764.camel@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d5c42a81-a8c4-0e10-d713-cc78c3081d4b@redhat.com>
Date:   Tue, 14 Sep 2021 20:53:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <22e110d00df3d02157222754f01fc6143cb40764.camel@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/13/21 11:13 PM, Jeff Layton wrote:
> On Mon, 2021-09-13 at 18:43 +0530, Venky Shankar wrote:
>> Right now, cumulative read/write/metadata latencies are tracked
>> and are periodically forwarded to the MDS. These meterics are not
>> particularly useful. A much more useful metric is the average latency
>> and standard deviation (stdev) which is what this series of patches
>> aims to do.
>>
>> The userspace (libcephfs+tool) changes are here::
>>
>>            https://github.com/ceph/ceph/pull/41397
>>
>> The math involved in keeping track of the average latency and stdev
>> seems incorrect, so, this series fixes that up too (closely mimics
>> how its done in userspace with some restrictions obviously) as per::
>>
>>            NEW_AVG = OLD_AVG + ((latency - OLD_AVG) / total_ops)
>>            NEW_STDEV = SQRT(((OLD_STDEV + (latency - OLD_AVG)*(latency - NEW_AVG)) / (total_ops - 1)))
>>
>> Note that the cumulative latencies are still forwarded to the MDS but
>> the tool (cephfs-top) ignores it altogether.
>>
>> Venky Shankar (4):
>>    ceph: use "struct ceph_timespec" for r/w/m latencies
>>    ceph: track average/stdev r/w/m latency
>>    ceph: include average/stddev r/w/m latency in mds metrics
>>    ceph: use tracked average r/w/m latencies to display metrics in
>>      debugfs
>>
>>   fs/ceph/debugfs.c | 12 +++----
>>   fs/ceph/metric.c  | 81 +++++++++++++++++++++++++----------------------
>>   fs/ceph/metric.h  | 64 +++++++++++++++++++++++--------------
>>   3 files changed, 90 insertions(+), 67 deletions(-)
>>
> This looks reasonably sane. I'll plan to go ahead and pull this into the
> testing kernels and do some testing with them. If anyone has objections
> (Xiubo?) let me know and I can take them out.

Sorry I think I missed this patch set.

Comment it in the V2.

Thanks.


>
> Thanks,

