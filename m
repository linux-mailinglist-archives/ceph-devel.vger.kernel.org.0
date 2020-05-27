Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADDE1E4297
	for <lists+ceph-devel@lfdr.de>; Wed, 27 May 2020 14:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgE0Mpd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 May 2020 08:45:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728513AbgE0Mpc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 May 2020 08:45:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590583530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZuRYtpg/w/wKtv3q2GHRKntjkLXhZCHuUaNL/pLcGqo=;
        b=TNwRKBmSkQh11BrQXQ5UkggkgDokIxzL2Av1W4gABYoI8qJhzELHlCoOfcLkpZ6CbmDy7K
        +IBDMP+7xefYZTMLFoaWRrvUuQHkSjqbDruwMgv/mBlJSzIKNF/u76Diqivni/wYrhkJkp
        YYlAYOPBvUGKyGYFrVPogK46vup16jM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-eSgQ45xCO3GgM-iLPYPLnw-1; Wed, 27 May 2020 08:45:27 -0400
X-MC-Unique: eSgQ45xCO3GgM-iLPYPLnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A599107B46F;
        Wed, 27 May 2020 12:45:26 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4625D5C1B0;
        Wed, 27 May 2020 12:45:23 +0000 (UTC)
Subject: Re: [PATCH v4] ceph: skip checking the caps when session reconnecting
 and releasing reqs
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1590562634-29610-1-git-send-email-xiubli@redhat.com>
 <a271a1f31b98caa26f634ddc23930ccb7973543c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <32467f5a-26e3-4042-84de-dfaf57bf1977@redhat.com>
Date:   Wed, 27 May 2020 20:45:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <a271a1f31b98caa26f634ddc23930ccb7973543c.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/5/27 20:19, Jeff Layton wrote:
> On Wed, 2020-05-27 at 02:57 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> It make no sense to check the caps when reconnecting to mds. And
>> for the async dirop caps, they will be put by its _cb() function,
>> so when releasing the requests, it will make no sense too.
>>
>> URL: https://tracker.ceph.com/issues/45635
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V2:
>> - do not check the caps when reconnecting to mds
>> - switch ceph_async_check_caps() to ceph_async_put_cap_refs()
>>
>> Changed in V3:
>> - fix putting the cap refs leak
>>
>> Changed in V4:
>> - drop ceph_async_check_caps() stuff.
>>
>>
> Sigh. I guess this will fix the original issue, but it's just more
> evidence that the locking in this code are an absolute shitshow,
> particularly when it comes to the session mutex.
>
> Rather than working around it like this, we ought to be coming up with
> ways to reduce the need for the session mutex altogether, particularly
> in the cap handling code. Doing that means that we need to identify what
> the session mutex actually protects of course, and so far I've not been
> very successful in determining that.
>
> Mostly, it looks like it's used to provide high-level serialization much
> like the client mutex in libcephfs, but it's per-session, and ends up
> having to be inverted wrt the mdsc mutex all over the place.
>
> Maybe instead of this, we ought to look at getting rid of the session
> mutex altogether -- fold the existing usage of it into the mdsc->mutex.
> We'd end up serializing things even more that way, but the session mutex
> is already so coarse-grained that it'd probably not affect performance
> that much. It would certainly make the locking a _lot_ simpler.

Yeah, this sound good, but it will be a great amount of work IMO.


[...]
>>   
>> -void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req)
>> +void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req,
>> +				bool skip_checking_caps)
> Can we add a ceph_mdsc_release_dir_caps_no_check() instead of a boolean
> argument? That at least better communicates what the function does to
> someone reading the code.
>
> Those can just be wrappers around the function that does take a boolean
> if need be (similar to ceph_put_cap_refs[_no_check_caps]).

Yeah, sure. Will fix it.

Thanks
BRs
Xiubo

