Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0C2138927
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jan 2020 02:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgAMBMp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 12 Jan 2020 20:12:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31620 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727222AbgAMBMp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 12 Jan 2020 20:12:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578877962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hdqhM815UDYLDrJMTEJNejdl0UOy2pTSEtjAWYd0xjs=;
        b=dAOGSYmEaoCdE498zxbeejmtBeQjDTDWffRGGs+BOlftXykAT0zDmLiHdx+WuE7R6Haw89
        MoAWOuEcCCshUfL6lp6V4MAidYRNERy3z1qRIF+zb+f4FoZ23nTirn1er4OEZbb61pfscN
        PXfHMTmiKxbxY7KMx2FgFjI8QODjSXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-Gzleo2JNMVqkI_65z09P0A-1; Sun, 12 Jan 2020 20:12:41 -0500
X-MC-Unique: Gzleo2JNMVqkI_65z09P0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EB5F184C700;
        Mon, 13 Jan 2020 01:12:40 +0000 (UTC)
Received: from [10.72.12.97] (ovpn-12-97.pek2.redhat.com [10.72.12.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 715BA5C1D4;
        Mon, 13 Jan 2020 01:12:35 +0000 (UTC)
Subject: Re: [PATCH v2 2/8] ceph: add caps perf metric for each session
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200108104152.28468-1-xiubli@redhat.com>
 <20200108104152.28468-3-xiubli@redhat.com>
 <38fc860f80d251d5cbb5ee49c253a725625190d9.camel@kernel.org>
 <a2ccd54f-11a3-a3e0-f299-00de28cca92d@redhat.com>
 <2290d0986978eb65519f2c4842a9e40db9ee7c85.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7075061f-2614-4bb2-cf8b-86b8b94a1f5f@redhat.com>
Date:   Mon, 13 Jan 2020 09:12:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <2290d0986978eb65519f2c4842a9e40db9ee7c85.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/10 19:51, Jeff Layton wrote:
> On Fri, 2020-01-10 at 11:38 +0800, Xiubo Li wrote:
>> On 2020/1/9 22:52, Jeff Layton wrote:
>>> On Wed, 2020-01-08 at 05:41 -0500, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This will fulfill the caps hit/miss metric for each session. When
>>>> checking the "need" mask and if one cap has the subset of the "need"
>>>> mask it means hit, or missed.
>>>>
>>>> item          total           miss            hit
>>>> -------------------------------------------------
>>>> d_lease       295             0               993
>>>>
>>>> session       caps            miss            hit
>>>> -------------------------------------------------
>>>> 0             295             107             4119
>>>> 1             1               107             9
>>>>
>>>> Fixes: https://tracker.ceph.com/issues/43215
>>> For the record, "Fixes:" has a different meaning for kernel patches.
>>> It's used to reference an earlier patch that introduced the bug that =
the
>>> patch is fixing.
>>>
>>> It's a pity that the ceph team decided to use that to reference track=
er
>>> tickets in their tree. For the kernel we usually use a generic "URL:"
>>> tag for that.
>> Sure, will fix it.
>>
>> [...]
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index 28ae0c134700..6ab02aab7d9c 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -567,7 +567,7 @@ static void __cap_delay_cancel(struct ceph_mds_c=
lient *mdsc,
>>>>    static void __check_cap_issue(struct ceph_inode_info *ci, struct =
ceph_cap *cap,
>>>>    			      unsigned issued)
>>>>    {
>>>> -	unsigned had =3D __ceph_caps_issued(ci, NULL);
>>>> +	unsigned int had =3D __ceph_caps_issued(ci, NULL, -1);
>>>>   =20
>>>>    	/*
>>>>    	 * Each time we receive FILE_CACHE anew, we increment
>>>> @@ -787,20 +787,43 @@ static int __cap_is_valid(struct ceph_cap *cap=
)
>>>>     * out, and may be invalidated in bulk if the client session time=
s out
>>>>     * and session->s_cap_gen is bumped.
>>>>     */
>>>> -int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented=
)
>>>> +int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented=
, int mask)
>>> This seems like the wrong approach. This function returns a set of ca=
ps,
>>> so it seems like the callers ought to determine whether a miss or hit
>>> occurred, and whether to record it.
>> Currently this approach will count the hit/miss for each i_cap entity =
in
>> ci->i_caps, for example, if a i_cap has a subset of the requested cap
>> mask it means the i_cap hit, or the i_cap miss.
>>
>> This approach will be like:
>>
>> session       caps            miss            hit
>> -------------------------------------------------
>> 0             295             107             4119
>> 1             1               107             9
>>
>> The "caps" here is the total i_caps in all the ceph_inodes we have.
>>
>>
>> Another approach is only when the ci->i_caps have all the requested ca=
p
>> mask, it means hit, or miss, this is what you meant as above.
>>
>> This approach will be like:
>>
>> session       inodes            miss            hit
>> -------------------------------------------------
>> 0             295             107             4119
>> 1             1               107             9
>>
>> The "inodes" here is the total ceph_inodes we have.
>>
>> Which one will be better ?
>>
>>
> I think I wasn't clear. My objection was to adding this "mask" field to
> __ceph_caps_issued and having the counting logic in there. It would be
> cleaner to have the callers do that instead. __ceph_caps_issued returns
> the issued caps, so the callers have all of the information they need t=
o
> increment the proper counters without having to change
> __ceph_caps_issued.

Do you mean if the (mask & issued =3D=3D mask) the caller will increase 1=
 to=20
the hit counter, or increase 1 miss counter, right ?

For currently approach of this patch, when traversing the ceph_inode's=20
i_caps and if a i_cap has only a subset or all of the "mask" that means=20
hit, or miss.

This is why changing the __ceph_caps_issued().


>
>>>>    {
>> [...]
>>>>   =20
>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>> index 382beb04bacb..1e1ccae8953d 100644
>>>> --- a/fs/ceph/dir.c
>>>> +++ b/fs/ceph/dir.c
>>>> @@ -30,7 +30,7 @@
>>>>    const struct dentry_operations ceph_dentry_ops;
>>>>   =20
>>>>    static bool __dentry_lease_is_valid(struct ceph_dentry_info *di);
>>>> -static int __dir_lease_try_check(const struct dentry *dentry);
>>>> +static int __dir_lease_try_check(const struct dentry *dentry, bool =
metric);
>>>>   =20
>>> AFAICT, this function is only called when trimming dentries and in
>>> d_delete. I don't think we care about measuring cache hits/misses for
>>> either of those cases.
>> Yeah, it is.
>>
>> This will ignore the trimming dentries case, and will count from the
>> d_delete.
>>
>> This approach will only count the cap hit/miss called from VFS layer.
>>
> Why do you need this "metric" parameter here? We _know_ that we won't b=
e
> counting hits and misses in this codepath, so it doesn't seem to serve
> any useful purpose.
>
We need to know where the caller comes from:

In Case1:=C2=A0 caller is vfs

This will count the hit/miss counters.

ceph_d_delete() --> __dir_lease_try_check(metric =3D true) -->=20
__ceph_caps_issued_mask(mask =3D XXX, metric =3D true)


In Case2: caller is ceph.ko itself

This will ignore the hit/miss counters.

ceph_trim_dentries() --> __dentry_lease_check() -->=20
__dir_lease_try_check(metric =3D false) --> __ceph_caps_issued_mask(mask =
=3D=20
XXX, metric =3D false)


Thanks.




