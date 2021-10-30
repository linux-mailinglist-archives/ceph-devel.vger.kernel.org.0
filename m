Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726CC4407B0
	for <lists+ceph-devel@lfdr.de>; Sat, 30 Oct 2021 08:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhJ3GXh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 Oct 2021 02:23:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbhJ3GXh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 02:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635574867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m5lLYTHO92hVzGrMMzhWoYd6SQdciVAR/mecDurPVGM=;
        b=b1MomGD15RpC/egWBsaNW8WwuUj3qaHdWKsm5WTT5M+mE8lXpZGMok+3CQXNPn+46HfVhd
        qWp4IV9JtT62L8ho8Hjo2eRRyK83jLzebEiWnzT99nxoYeqnOWjbYo9Afi19zVb8Logo6a
        +nNlUZNJTBIsgSaZHHFOQVepmrfdQ6M=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-MmQ3PqbjOgOaQTcyEbkkFQ-1; Sat, 30 Oct 2021 02:21:05 -0400
X-MC-Unique: MmQ3PqbjOgOaQTcyEbkkFQ-1
Received: by mail-pg1-f198.google.com with SMTP id n9-20020a63e049000000b002951886c1c5so6069343pgj.0
        for <ceph-devel@vger.kernel.org>; Fri, 29 Oct 2021 23:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=m5lLYTHO92hVzGrMMzhWoYd6SQdciVAR/mecDurPVGM=;
        b=niALebnynvyzjzwLRlM1luJbJVDqW9b6YnoJ6YiDtmuxhFNxz9pOViDtvaP27UVa3j
         J/3DeWbXRoHFUDPV74vtjYvmZ0LJ0tjCdf4L8NcPekYLq/nE1NiqJFZLU2cukZn58Lui
         iweje7dT/dY/cRKtYSJ7nWXs0GEvDlhFAUz17UqkL1bJ1zokxApdx8RR6+8tFwkfj5YB
         J1e/5UQ0ROvoj1cu61GaXyjT5lobmY5yePWtzmx3jQuWmuG1Sy2Z7bu6Qejz1v9FYvTv
         3AmR9ygzAdecVJZ7gYRw3Cxa+lu0v4oWd9o2jLvzhtpXqYCEEk6hFhrKhw6oPuoptEsK
         MH5A==
X-Gm-Message-State: AOAM532OtT6PEK5QmX7pYlZ3Szr++YaIiDXGMb6zoGInQgcQdJA3uBzA
        jvkj0WXFhxN9KtUt2Ze2j98GrpyX+7z8/WZKTFqlVv4iB8c/sZOsI3Ijn43qxnq7sPW5O4mgVyr
        6W3nPrWFFTZnEJ6E1yXR2jLZeXGxfIIsRQOJN52b+61ZfnOURAx3QVoWkfRQmlY8vPDT5JlQ=
X-Received: by 2002:a05:6a00:150f:b0:47c:1e13:b683 with SMTP id q15-20020a056a00150f00b0047c1e13b683mr15288416pfu.45.1635574864002;
        Fri, 29 Oct 2021 23:21:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZgpQj8iNay4E1n/mPaWJt3kUrFkbo+QN8Alfatwz5Gk8Du1l50AZz1Yny3IVTUJgnf1UyeQ==
X-Received: by 2002:a05:6a00:150f:b0:47c:1e13:b683 with SMTP id q15-20020a056a00150f00b0047c1e13b683mr15288393pfu.45.1635574863675;
        Fri, 29 Oct 2021 23:21:03 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c1sm5753349pfv.54.2021.10.29.23.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 23:21:03 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] ceph: add truncate size handling support for
 fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211028091438.21402-1-xiubli@redhat.com>
 <20211028091438.21402-5-xiubli@redhat.com>
 <37ca7a43ec7b9d796d4d8fb962309278c0df7d76.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8603888b-a9d3-21d6-441f-d358c5e9e1ea@redhat.com>
Date:   Sat, 30 Oct 2021 14:20:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <37ca7a43ec7b9d796d4d8fb962309278c0df7d76.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



[...]

>> @@ -2473,7 +2621,23 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   		req->r_args.setattr.mask = cpu_to_le32(mask);
>>   		req->r_num_caps = 1;
>>   		req->r_stamp = attr->ia_ctime;
>> +		if (fill_fscrypt) {
>> +			err = fill_fscrypt_truncate(inode, req, attr);
>> +			if (err)
>> +				goto out;
>> +		}
>> +
>> +		/*
>> +		 * The truncate will return -EAGAIN when some one
>> +		 * has updated the last block before the MDS hold
>> +		 * the xlock for the FILE lock. Need to retry it.
>> +		 */
>>   		err = ceph_mdsc_do_request(mdsc, NULL, req);
>> +		if (err == -EAGAIN) {
>> +			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
>> +			     inode, err, ceph_cap_string(dirtied), mask);
>> +			goto retry;
>> +		}
> The rest looks reasonable. We may want to cap the number of retries in
> case something goes really wrong or in the case of a livelock with a
> competing client. I'm not sure what a reasonable number of tries would
> be though -- 5? 10? 100? We may want to benchmark out how long this rmw
> operation takes and then we can use that to determine a reasonable
> number of tries.

<7>[  330.648749] ceph:  setattr 00000000197f0d87 issued pAsxLsXsxFsxcrwb
<7>[  330.648752] ceph:  setattr 00000000197f0d87 size 11 -> 2
<7>[  330.648756] ceph:  setattr 00000000197f0d87 mtime 
1635574177.43176541 -> 1635574210.35946684
<7>[  330.648760] ceph:  setattr 00000000197f0d87 ctime 
1635574177.43176541 -> 1635574210.35946684 (ignored)
<7>[  330.648765] ceph:  setattr 00000000197f0d87 ATTR_FILE ... hrm!
...

<7>[  330.653696] ceph:  fill_fscrypt_truncate 00000000197f0d87 size 
dropping cap refs on Fr
...

<7>[  330.697464] ceph:  setattr 00000000197f0d87 result=0 (Fx locally, 
4128 remote)

It takes around 50ms.

Shall we retry 20 times ?

>
> If you run out of tries, you could probably  just return -EAGAIN in that
> case. That's not listed in the truncate(2) manpage, but it seems like a
> reasonable way to handle that sort of problem.
>
[...]

