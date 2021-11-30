Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FFE46352D
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Nov 2021 14:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbhK3NQM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Nov 2021 08:16:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238465AbhK3NQL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 08:16:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638277972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nTAoi7aJ2EhLj/Js7Q5W5Z/M/lszBPdHNqQKI7AaIGc=;
        b=ewN2mjuG0TjS6EgAaEywSlbXxBMwU4bxx5TANY+mUE9Inc1LkRg6mG/YNXve++COagkWgx
        FLQHi475wkHJmqqCJqXrTn/ePkA0E7D01PFCrTctfNSPgOllDBYzwH+NjytklGvoQi0z2g
        jAKYOdSbmABuSztS5/B9h7WhY2LevRA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-vBIJN52fM42ZxfxbDsG3iQ-1; Tue, 30 Nov 2021 08:12:51 -0500
X-MC-Unique: vBIJN52fM42ZxfxbDsG3iQ-1
Received: by mail-pf1-f199.google.com with SMTP id e7-20020aa798c7000000b004a254db7946so12820475pfm.17
        for <ceph-devel@vger.kernel.org>; Tue, 30 Nov 2021 05:12:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nTAoi7aJ2EhLj/Js7Q5W5Z/M/lszBPdHNqQKI7AaIGc=;
        b=bTvwNDo32L29P2MYPDFZfO2bE8SwXsSOokSTqb+3rfJM3lgKwaBfm2XDQUb6lIVZei
         3J0zA7DymRoPd6bFVx9rdmY/MDzwZmfPeh4gtTwOxTZF+/qb9Z1fEhQAHao+34zYbuhi
         jwPbK6JsXUb427eY8OfDkZl9QvcBhkyAaIPX4vjN+17ndECY2WdAhL2+LJW65QKX6ZDb
         Aaiet2FU2V2GChMICx4HTJ2Hd6rPNb3NEtRP0A5XbbYmeH3yK4G263rE8vsDPt2NEfJZ
         l5DAiexCzUUKq0phfL4i1HdkdixnonEF2mlS9HYEW+Mnh0OyodPLMDak46+xM/UzCt/Z
         x2aQ==
X-Gm-Message-State: AOAM531Ie37BNjbrHm+YpIjqIsiqwMMABg6PcajUHepSmLp/JcdthBNz
        a52AB2o8afhodlnPTFWorB0MS+GNaCMfPnyFn3kgrCzwqcyE1tof/czbvaT/ZMUZZPTs00gi4I2
        gnZxLMif/bHyJR7YaWJQhgg==
X-Received: by 2002:a63:f654:: with SMTP id u20mr10260143pgj.187.1638277969599;
        Tue, 30 Nov 2021 05:12:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyt5t19jucrn1jJ/0H+BIyvw+Ef/EF4zmstWij6LZbgjk0v7ovSkone0gFVwDbynz/UOMrjtQ==
X-Received: by 2002:a63:f654:: with SMTP id u20mr10260114pgj.187.1638277969364;
        Tue, 30 Nov 2021 05:12:49 -0800 (PST)
Received: from [10.72.12.65] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 186sm14610471pgf.94.2021.11.30.05.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 05:12:48 -0800 (PST)
Subject: Re: [PATCH] ceph: initialize pathlen variable in reconnect_caps_cb
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org, dan.carpenter@oracle.com
References: <20211130112034.2711318-1-xiubli@redhat.com>
 <41b05af2020a3cb345a16f5dfca15f6f5f41bfe4.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d14840f4-3ad8-55ce-480c-4d8cf3234893@redhat.com>
Date:   Tue, 30 Nov 2021 21:12:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <41b05af2020a3cb345a16f5dfca15f6f5f41bfe4.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/30/21 8:07 PM, Jeff Layton wrote:
> On Tue, 2021-11-30 at 19:20 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Silence the potential compiler warning.
>>
>> Fixes: a33f6432b3a6 (ceph: encode inodes' parent/d_name in cap reconnect message)
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Is this something we need to fix? AFAICT, there is no bug here.
>
> In the case where ceph_mdsc_build_path returns an error, "path" will be
> an ERR_PTR and then ceph_mdsc_free_path will be a no-op. If we do need
> to take this, we should probably also credit Dan for finding it.
>
As I remembered, when I was paying the gluster-block project, the 
similar cases will always give a warning like this with code sanity 
checking.

>> ---
>>   fs/ceph/mds_client.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 87f20ed16c6e..2fc2b0a023e4 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3711,7 +3711,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   	struct ceph_pagelist *pagelist = recon_state->pagelist;
>>   	struct dentry *dentry;
>>   	char *path;
>> -	int pathlen, err;
>> +	int pathlen = 0, err;
>>   	u64 pathbase;
>>   	u64 snap_follows;
>>   
> If we do take this, you can also get rid of the place where pathlen is
> set in the !dentry case.
>

