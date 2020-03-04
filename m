Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB0F17924E
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 15:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgCDO0V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 09:26:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34099 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729386AbgCDO0V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Mar 2020 09:26:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583331980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DF+BiTjBEuhY1RitH6bbYUkGM6BbF+SVW+FfkxbThqA=;
        b=SOKPQq6/f5KyAvNbPUcI1OQojrdmBlWGceIgYJodm+aPVSyO7VG8s//lZkI0WX6Xwamn1V
        fDscJ/Si6vC6AqVHivNQ4C38w+rHay/UzmEAEAPq1pic+S1xtjLTCT6tW5GlaULuXLxqtw
        /X64nXvV+QlOk3HxvExrmEaoh92RcAY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-vi-gUtmsPGqzATuHpVRl2A-1; Wed, 04 Mar 2020 09:26:18 -0500
X-MC-Unique: vi-gUtmsPGqzATuHpVRl2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86CC98010EC;
        Wed,  4 Mar 2020 14:26:17 +0000 (UTC)
Received: from [10.72.12.198] (ovpn-12-198.pek2.redhat.com [10.72.12.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DDBC388;
        Wed,  4 Mar 2020 14:26:16 +0000 (UTC)
Subject: Re: [PATCH] mds: update dentry lease for async create
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20200304132220.41238-1-zyan@redhat.com>
 <88afc25efd69e9d07df88bb2efbc3e989e14fd9a.camel@kernel.org>
 <29ed368fce6cb62f2bbc9b5d181eacf2cdf990bb.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <6642e002-9e9b-4e73-a160-726e6d164173@redhat.com>
Date:   Wed, 4 Mar 2020 22:26:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <29ed368fce6cb62f2bbc9b5d181eacf2cdf990bb.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 3/4/20 10:05 PM, Jeff Layton wrote:
> On Wed, 2020-03-04 at 08:55 -0500, Jeff Layton wrote:
>> On Wed, 2020-03-04 at 21:22 +0800, Yan, Zheng wrote:
>>> Otherwise ceph_d_delete() may return 1 for the dentry, which makes
>>> dput() prune the dentry and clear parent dir's complete flag.
>>>
>>> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>>> ---
>>>   fs/ceph/file.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 53321bf517c2..671b141aedfe 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -480,6 +480,9 @@ static int try_prep_async_create(struct inode *dir, struct dentry *dentry,
>>>   	if (d_in_lookup(dentry)) {
>>>   		if (!__ceph_dir_is_complete(ci))
>>>   			goto no_async;
>>> +		spin_lock(&dentry->d_lock);
>>> +		di->lease_shared_gen = atomic_read(&ci->i_shared_gen);
>>> +		spin_unlock(&dentry->d_lock);
>>>   	} else if (atomic_read(&ci->i_shared_gen) !=
>>>   		   READ_ONCE(di->lease_shared_gen)) {
>>>   		goto no_async;
>>
>> Good catch, merged into testing (with small update to changelog
>> s/mds:/ceph:/)
>>
> 
> One related comment though. This patch implies that lease_shared_gen is
> protected by the d_lock, but it's not held when it's assigned in
> ceph_lookup. Should it be?
> 

we only assign and compare lease_shared_gen, I think it doesn't matter 
if it's protected by d_lock or not

