Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39421365DC
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2020 04:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbgAJDik (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 22:38:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55806 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731086AbgAJDik (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jan 2020 22:38:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578627519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iogj9B3G3SNf7deZNmQRV7iCjApynMX1HgNjJUsBzE0=;
        b=AU4hQmX6DXjWdpOpXh/aAip9XeGQ+cK5ok8+dp2aDS1hZ9us31Fo3b79nzWhsk/nAhQXld
        md2mKLnAR+or4IFscLz2YJAGq72/YpCa3SbakQ2Ln6VdJyCr8wYj6cZYlmvqiAwnrALiX5
        r2HdVjDOYHAQEsfr3bodhu44XjZGtxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-VnjYbetGOUWxdtjq3Ruz3A-1; Thu, 09 Jan 2020 22:38:35 -0500
X-MC-Unique: VnjYbetGOUWxdtjq3Ruz3A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82D4B1005502;
        Fri, 10 Jan 2020 03:38:34 +0000 (UTC)
Received: from [10.72.12.70] (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFF1960CC0;
        Fri, 10 Jan 2020 03:38:29 +0000 (UTC)
Subject: Re: [PATCH v2 2/8] ceph: add caps perf metric for each session
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200108104152.28468-1-xiubli@redhat.com>
 <20200108104152.28468-3-xiubli@redhat.com>
 <38fc860f80d251d5cbb5ee49c253a725625190d9.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a2ccd54f-11a3-a3e0-f299-00de28cca92d@redhat.com>
Date:   Fri, 10 Jan 2020 11:38:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <38fc860f80d251d5cbb5ee49c253a725625190d9.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/9 22:52, Jeff Layton wrote:
> On Wed, 2020-01-08 at 05:41 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will fulfill the caps hit/miss metric for each session. When
>> checking the "need" mask and if one cap has the subset of the "need"
>> mask it means hit, or missed.
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> d_lease       295             0               993
>>
>> session       caps            miss            hit
>> -------------------------------------------------
>> 0             295             107             4119
>> 1             1               107             9
>>
>> Fixes: https://tracker.ceph.com/issues/43215
> For the record, "Fixes:" has a different meaning for kernel patches.
> It's used to reference an earlier patch that introduced the bug that the
> patch is fixing.
>
> It's a pity that the ceph team decided to use that to reference tracker
> tickets in their tree. For the kernel we usually use a generic "URL:"
> tag for that.

Sure, will fix it.

[...]
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 28ae0c134700..6ab02aab7d9c 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -567,7 +567,7 @@ static void __cap_delay_cancel(struct ceph_mds_client *mdsc,
>>   static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
>>   			      unsigned issued)
>>   {
>> -	unsigned had = __ceph_caps_issued(ci, NULL);
>> +	unsigned int had = __ceph_caps_issued(ci, NULL, -1);
>>   
>>   	/*
>>   	 * Each time we receive FILE_CACHE anew, we increment
>> @@ -787,20 +787,43 @@ static int __cap_is_valid(struct ceph_cap *cap)
>>    * out, and may be invalidated in bulk if the client session times out
>>    * and session->s_cap_gen is bumped.
>>    */
>> -int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented)
>> +int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented, int mask)
>
> This seems like the wrong approach. This function returns a set of caps,
> so it seems like the callers ought to determine whether a miss or hit
> occurred, and whether to record it.

Currently this approach will count the hit/miss for each i_cap entity in 
ci->i_caps, for example, if a i_cap has a subset of the requested cap 
mask it means the i_cap hit, or the i_cap miss.

This approach will be like:

session       caps            miss            hit
-------------------------------------------------
0             295             107             4119
1             1               107             9

The "caps" here is the total i_caps in all the ceph_inodes we have.


Another approach is only when the ci->i_caps have all the requested cap 
mask, it means hit, or miss, this is what you meant as above.

This approach will be like:

session       inodes            miss            hit
-------------------------------------------------
0             295             107             4119
1             1               107             9

The "inodes" here is the total ceph_inodes we have.

Which one will be better ?


>
>>   {
[...]
>>   
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index 382beb04bacb..1e1ccae8953d 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -30,7 +30,7 @@
>>   const struct dentry_operations ceph_dentry_ops;
>>   
>>   static bool __dentry_lease_is_valid(struct ceph_dentry_info *di);
>> -static int __dir_lease_try_check(const struct dentry *dentry);
>> +static int __dir_lease_try_check(const struct dentry *dentry, bool metric);
>>   
> AFAICT, this function is only called when trimming dentries and in
> d_delete. I don't think we care about measuring cache hits/misses for
> either of those cases.

Yeah, it is.

This will ignore the trimming dentries case, and will count from the 
d_delete.

This approach will only count the cap hit/miss called from VFS layer.

Thanks


