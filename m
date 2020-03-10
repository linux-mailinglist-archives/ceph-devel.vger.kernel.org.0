Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A73317ED48
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 01:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbgCJA0J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 20:26:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51599 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727322AbgCJA0J (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 20:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583799968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vVdzdl7TzB4du/PT6NB+5EsDYXv/oNN61iCOkxmkev0=;
        b=HgANRHjEVhs+hu2lYD3/aIWUaBWgb+5qXrBPWbRxQxBizCI/jRciS4nW9B8Vw7KrNUclHO
        LodWDVN5ura9UKE/Pd43S82YcrMODOpqc2HOZINE7hS8ElZ4ACVHTvupw9IJSj3uHU05mj
        OmVW+lJ747kuj7n5zpjVzNLpNQPsY3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-kftpNrvmMA-YHnholJsrQQ-1; Mon, 09 Mar 2020 20:26:04 -0400
X-MC-Unique: kftpNrvmMA-YHnholJsrQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A99B1005512;
        Tue, 10 Mar 2020 00:26:03 +0000 (UTC)
Received: from [10.72.13.87] (ovpn-13-87.pek2.redhat.com [10.72.13.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F8315C1C3;
        Tue, 10 Mar 2020 00:25:57 +0000 (UTC)
Subject: Re: [PATCH v9 2/5] ceph: add caps perf metric for each session
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
 <1583739430-4928-3-git-send-email-xiubli@redhat.com>
 <16b9a2a5bfbd8802ce2f2c435aba7331cd1adb35.camel@kernel.org>
 <215d32cb86ead14dea44e74f5ac75f569349a794.camel@kernel.org>
 <f61ce4e4-17e0-0888-2ecd-57374544ccf7@redhat.com>
 <7ebfe1b51f2558a08c9d4768e38ffb337d988129.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d2b0d584-652f-9913-0c01-4dc32e57c934@redhat.com>
Date:   Tue, 10 Mar 2020 08:25:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <7ebfe1b51f2558a08c9d4768e38ffb337d988129.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/10 2:22, Jeff Layton wrote:
> On Mon, 2020-03-09 at 20:36 +0800, Xiubo Li wrote:
>> On 2020/3/9 20:05, Jeff Layton wrote:
>>> On Mon, 2020-03-09 at 07:51 -0400, Jeff Layton wrote:
>>>> On Mon, 2020-03-09 at 03:37 -0400, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> This will fulfill the cap hit/mis metric stuff per-superblock,
>>>>> it will count the hit/mis counters based each inode, and if one
>>>>> inode's 'issued & ~revoking == mask' will mean a hit, or a miss.
>>>>>
>>>>> item          total           miss            hit
>>>>> -------------------------------------------------
>>>>> caps          295             107             4119
>>>>>
>>>>> URL: https://tracker.ceph.com/issues/43215
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>    fs/ceph/acl.c        |  2 +-
>>>>>    fs/ceph/caps.c       | 19 +++++++++++++++++++
>>>>>    fs/ceph/debugfs.c    | 16 ++++++++++++++++
>>>>>    fs/ceph/dir.c        |  5 +++--
>>>>>    fs/ceph/inode.c      |  4 ++--
>>>>>    fs/ceph/mds_client.c | 26 ++++++++++++++++++++++----
>>>>>    fs/ceph/metric.h     | 13 +++++++++++++
>>>>>    fs/ceph/super.h      |  8 +++++---
>>>>>    fs/ceph/xattr.c      |  4 ++--
>>>>>    9 files changed, 83 insertions(+), 14 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
>>>>> index 26be652..e046574 100644
>>>>> --- a/fs/ceph/acl.c
>>>>> +++ b/fs/ceph/acl.c
>>>>> @@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>>>>>    	struct ceph_inode_info *ci = ceph_inode(inode);
>>>>>    
>>>>>    	spin_lock(&ci->i_ceph_lock);
>>>>> -	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
>>>>> +	if (__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 0))
>>>>>    		set_cached_acl(inode, type, acl);
>>>>>    	else
>>>>>    		forget_cached_acl(inode, type);
>>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>>> index 342a32c..efaeb67 100644
>>>>> --- a/fs/ceph/caps.c
>>>>> +++ b/fs/ceph/caps.c
>>>>> @@ -912,6 +912,20 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>>>>>    	return 0;
>>>>>    }
>>>>>    
>>>>> +int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
>>>>> +				   int touch)
>>>>> +{
>>>>> +	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
>>>>> +	int r;
>>>>> +
>>>>> +	r = __ceph_caps_issued_mask(ci, mask, touch);
>>>>> +	if (r)
>>>>> +		ceph_update_cap_hit(&fsc->mdsc->metric);
>>>>> +	else
>>>>> +		ceph_update_cap_mis(&fsc->mdsc->metric);
>>>>> +	return r;
>>>>> +}
>>>>> +
>>>>>    /*
>>>>>     * Return true if mask caps are currently being revoked by an MDS.
>>>>>     */
>>>>> @@ -2680,6 +2694,11 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>>>>>    	if (snap_rwsem_locked)
>>>>>    		up_read(&mdsc->snap_rwsem);
>>>>>    
>>>>> +	if (!ret)
>>>>> +		ceph_update_cap_mis(&mdsc->metric);
>>>> Should a negative error code here also mean a miss?
>>>>
>>>>> +	else if (ret == 1)
>>>>> +		ceph_update_cap_hit(&mdsc->metric);
>>>>> +
>>>>>    	dout("get_cap_refs %p ret %d got %s\n", inode,
>>>>>    	     ret, ceph_cap_string(*got));
>>>>>    	return ret;
>>> Here's what I'd propose on top. If this looks ok, then I can just fold
>>> this patch into yours before merging. No need to resend just for this.
>>>
>>> ----------------8<----------------
>>>
>>> [PATCH] SQUASH: count negative error code as miss in try_get_cap_refs
>>>
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>    fs/ceph/caps.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>> index efaeb67d584c..3be928782b45 100644
>>> --- a/fs/ceph/caps.c
>>> +++ b/fs/ceph/caps.c
>>> @@ -2694,9 +2694,9 @@ static int try_get_cap_refs(struct inode *inode,
>>> int need, int want,
>>>    	if (snap_rwsem_locked)
>>>    		up_read(&mdsc->snap_rwsem);
>>>    
>>> -	if (!ret)
>>> +	if (ret <= 0)
>>>    		ceph_update_cap_mis(&mdsc->metric);
>>> -	else if (ret == 1)
>>> +	else
>>>    		ceph_update_cap_hit(&mdsc->metric);
>>>    
>>>    	dout("get_cap_refs %p ret %d got %s\n", inode,
>> For the try_get_cap_refs(), maybe this is the correct approach to count
>> hit/miss as the function comments.
>>
> I decided to just merge your patches as-is. Given that those are error
> conditions, and some of them may occur before we ever check the caps, I
> think we should just opt to not count those cases.
>
> I did clean up the changelogs a bit, so please have a look and let me
> know if they look ok to you.

Cool, it looks nice to me.

Thanks Jeff.

BRs


> Thanks!


