Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5638C16B85E
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Feb 2020 05:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgBYEDK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Feb 2020 23:03:10 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41671 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727402AbgBYEDK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 23:03:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582603389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=loBqf8RVtgoFZedtpoRKOgl47bK6eIaLZIGRnVSEPL4=;
        b=IKSXD3eTxQ+zH5xA6Q8d1n0cIrWAwvfm2E1Ao8enVf/wUkobarb33/ncaG9e1++0uPQhEn
        Equh7TDp0YAmoBA5SYyAnAzyAZ7sYxQuIdgWkhs38aUMz13hz5GoYDWcCnOoEcb95jCN5O
        /IGJgXWFaUpn3S4UYDAJJzhqf/9S5Xg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-Xs9NENZGM1mn-8pkkA2ymw-1; Mon, 24 Feb 2020 23:02:55 -0500
X-MC-Unique: Xs9NENZGM1mn-8pkkA2ymw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF9BFDB2E;
        Tue, 25 Feb 2020 04:02:53 +0000 (UTC)
Received: from [10.72.12.161] (ovpn-12-161.pek2.redhat.com [10.72.12.161])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C5E18ED01;
        Tue, 25 Feb 2020 04:02:48 +0000 (UTC)
Subject: Re: [PATCH] ceph: add 'fs' mount option support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200223021440.40257-1-xiubli@redhat.com>
 <552341c730d2835b1492599fce319ae91a34f504.camel@kernel.org>
 <33fb49fe-87bc-b5d3-f717-3c22c7a15030@redhat.com>
 <19a375d6b80aaaeab0133f53e3bba2d067e3699d.camel@kernel.org>
 <8a9c3239eab504f47b93377998312c447a1eec41.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <93a7da7e-2db7-4a8e-4a64-27749445cea0@redhat.com>
Date:   Tue, 25 Feb 2020 12:02:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <8a9c3239eab504f47b93377998312c447a1eec41.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/25 6:24, Jeff Layton wrote:
> On Mon, 2020-02-24 at 14:20 -0800, Jeff Layton wrote:
>> On Mon, 2020-02-24 at 10:41 +0800, Xiubo Li wrote:
>>> On 2020/2/23 22:56, Jeff Layton wrote:
>>>> On Sat, 2020-02-22 at 21:14 -0500, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> The 'fs' here will be cleaner when specifying the ceph fs name,
>>>>> and we can easily get the corresponding name from the `ceph fs
>>>>> dump`:
>>>>>
>>>>> [...]
>>>>> Filesystem 'a' (1)
>>>>> fs_name	a
>>>>> epoch	12
>>>>> flags	12
>>>>> [...]
>>>>>
>>>>> The 'fs' here just an alias name for 'mds_namespace' mount options,
>>>>> and we will keep 'mds_namespace' for backwards compatibility.
>>>>>
>>>>> URL: https://tracker.ceph.com/issues/44214
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> It looks like mds_namespace feature went into the kernel in 2016 (in
>>>> v4.7). We're at v5.5 today, so that's a large swath of kernels in the
>>>> field that only support the old option.
>>>>
>>>> While I agree that 'fs=' would have been cleaner and more user-friendly,
>>>> I've found that it's just not worth it to add mount option aliases like
>>>> this unless you have a really good reason. It all ends up being a huge
>>>> amount of churn for little benefit.
>>>>
>>>> The problem with changing it after the fact like this is that you still
>>>> have to support both options forever. Removing support isn't worth the
>>>> pain as you can break working environments. When working environments
>>>> upgrade they won't change to use the new option (why bother?)
>>>>
>>>> Maybe it would be good to start this change by doing a "fs=" to
>>>> "mds_namespace=" translation in the mount helper? That would make the
>>>> new option work across older kernel releases too, and make it simpler to
>>>> document what options are supported.
>>> This sounds a pretty good idea for me.
>>>
>>>
>>>>> @@ -561,8 +562,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>>>>>    	if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
>>>>>    		seq_puts(m, ",copyfrom");
>>>>>    
>>>>> -	if (fsopt->mds_namespace)
>>>>> -		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
>>>>> +	if (fsopt->fs_name)
>>>>> +		seq_show_option(m, "fs", fsopt->fs_name);
>>>> Someone will mount with mds_namespace= but then that will be converted
>>>> to fs= when displaying options here. It's not necessarily a problem but
>>>> it may be noticed by some users.
>>> Yeah, but if we convert 'fs=' to 'mds_namespace=' in userland and here
>>> it will always showing with 'mds_namespace=', won't it be the same issue?
>>>
>>> Or should we covert it to "fs/mds_namespace=" here ? Will it make sense ?
>>>
>> Now that I think about it more, it's probably not a problem either way,
>> but we should probably convert it to read 'fs=' here since that's what
>> we're planning to encourage people to use long-term.
>>
> To be even more clear:
>
> We should probably take your initial patch (or something like it) into
> the kernel as well, but also change the mount helper to smooth over the
> difference in the option handling there.  Once your userland changes
> are merged, let me know and I'll plan to re-review and merge this.
>
Sure.

Thanks.

>

