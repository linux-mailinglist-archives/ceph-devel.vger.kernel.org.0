Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB42D3F554C
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Aug 2021 03:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhHXBFs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 21:05:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234010AbhHXBFk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 21:05:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629767096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Itlv2b0LO6WNZyI+eQwmDJUcesJAu8WvVNghEiEd7kM=;
        b=jS6L0+qQc6bQqr3hSY4XC5eGScCTXVr9a26iSNuU32siI9acqqwkd6CisdsFmczyjjJe4u
        LgNG63kWd7ijLx0NZIsVE8ap64F3rDvLIOrZf6z+L5Ojpri42boi4N/LnA+hY56kZ4arsh
        OAshFITjNO3rM79PO+pHmhPT+z2BfT0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-lhi3cV8jPBWEKZlu8Ut_Nw-1; Mon, 23 Aug 2021 21:04:55 -0400
X-MC-Unique: lhi3cV8jPBWEKZlu8Ut_Nw-1
Received: by mail-pg1-f197.google.com with SMTP id d1-20020a630e010000b029023afa459291so11219371pgl.11
        for <ceph-devel@vger.kernel.org>; Mon, 23 Aug 2021 18:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Itlv2b0LO6WNZyI+eQwmDJUcesJAu8WvVNghEiEd7kM=;
        b=dQ0zjLQTGuTvtYUOkuqphH6aq5cXag3DPzN8/71YFTwSjcKBj5aFscOpEL8EmMQwwM
         hyiA7Sk5v8rn9GDqZ+UZXWZTyYvl0iVWjfBqz5pepcHuvBilqrUtziYdX+G/O3TZC7v0
         qJKG8BEWm/FXqRGoJtSij0pNwpL2c4eZmnvYEPAtn3zor8qeurJnX7fOzSsmPk09hz/Y
         nL6Mq2gIwPTFwns9yiHKyJB7UEmWcKMgXUSlc4EiSgtUIux4lM7Bp88tn582VYAwzBVB
         zkY0vL9vr/shSnBcNQuZRLamyw5XnPEtyymXozPsJSTuLkBo3LQlABWyX9LYlC5jl89y
         ZzTQ==
X-Gm-Message-State: AOAM533DXkIqll5ojjMSSnNI88s4nd1s5nxmERgXIGL7jNr+5RBAapHp
        MaTYtVuOwLd5/4kVNtmVbqtEHekJuj0gg+jQ1TuYwRb6eG5sSwAvVXOev/IBK/OZDzQWV6Y3BnH
        Itco7qburxfuoNOG48u+AFXMMdwbp394L04MsQuLGv01/7j5EQesTfqt3+juUgOcf/2Z7FWg=
X-Received: by 2002:aa7:86d5:0:b0:3e1:abc7:890b with SMTP id h21-20020aa786d5000000b003e1abc7890bmr36515603pfo.4.1629767094210;
        Mon, 23 Aug 2021 18:04:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4ELJAkF2PAiI0CoQJScEfPMgxXBmFCkj2CxIjnVkuFUPuiPgwiuIxrlESOQZuRoRWanV2ew==
X-Received: by 2002:aa7:86d5:0:b0:3e1:abc7:890b with SMTP id h21-20020aa786d5000000b003e1abc7890bmr36515582pfo.4.1629767093883;
        Mon, 23 Aug 2021 18:04:53 -0700 (PDT)
Received: from [10.72.12.33] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s1sm13706728pfd.13.2021.08.23.18.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 18:04:53 -0700 (PDT)
Subject: Re: [PATCH 1/3] ceph: remove the capsnaps when removing the caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210818080603.195722-1-xiubli@redhat.com>
 <20210818080603.195722-2-xiubli@redhat.com>
 <eb61f75726e7e1a08a5669b507e035055d18beb3.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <155a6e1c-98f8-a937-94e6-21d0eaaa6a20@redhat.com>
Date:   Tue, 24 Aug 2021 09:04:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <eb61f75726e7e1a08a5669b507e035055d18beb3.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/23/21 9:47 PM, Jeff Layton wrote:
> On Wed, 2021-08-18 at 16:06 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The capsnaps will ihold the inodes when queuing to flush, so when
>> force umounting it will close the sessions first and if the MDSes
>> respond very fast and the session connections are closed just
>> before killing the superblock, which will flush the msgr queue,
>> then the flush capsnap callback won't ever be called, which will
>> lead the memory leak bug for the ceph_inode_info.
>>
>> URL: https://tracker.ceph.com/issues/52295
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c       | 47 +++++++++++++++++++++++++++++---------------
>>   fs/ceph/mds_client.c | 23 +++++++++++++++++++++-
>>   fs/ceph/super.h      |  3 +++
>>   3 files changed, 56 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index e239f06babbc..7def99fbdca6 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3663,6 +3663,34 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>   		iput(inode);
>>   }
>>   
>> +/*
>> + * Caller hold s_mutex and i_ceph_lock.
>> + */
> Why add comments like this when we have lockdep_assert_held() ? It's
> generally better to use that as they illustrate the same relationship
> and also help catch those who violate the rules.
>
Okay, I will switch to lockdep_assert_held().

Thanks

>> +void ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
>> +			 bool *wake_ci, bool *wake_mdsc)
>> +{
>> +	struct ceph_inode_info *ci = ceph_inode(inode);
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>> +	bool ret;
>> +
>> +	dout("removing capsnap %p, inode %p ci %p\n", capsnap, inode, ci);
>> +
>> +	WARN_ON(capsnap->dirty_pages || capsnap->writing);
>> +	list_del(&capsnap->ci_item);
>> +	ret = __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
>> +	if (wake_ci)
>> +		*wake_ci = ret;
>> +
>> +	spin_lock(&mdsc->cap_dirty_lock);
>> +	if (list_empty(&ci->i_cap_flush_list))
>> +		list_del_init(&ci->i_flushing_item);
>> +
>> +	ret = __detach_cap_flush_from_mdsc(mdsc, &capsnap->cap_flush);
>> +	if (wake_mdsc)
>> +		*wake_mdsc = ret;
>> +	spin_unlock(&mdsc->cap_dirty_lock);
>> +}
>> +
>>   /*
>>    * Handle FLUSHSNAP_ACK.  MDS has flushed snap data to disk and we can
>>    * throw away our cap_snap.
>> @@ -3700,23 +3728,10 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
>>   			     capsnap, capsnap->follows);
>>   		}
>>   	}
>> -	if (flushed) {
>> -		WARN_ON(capsnap->dirty_pages || capsnap->writing);
>> -		dout(" removing %p cap_snap %p follows %lld\n",
>> -		     inode, capsnap, follows);
>> -		list_del(&capsnap->ci_item);
>> -		wake_ci |= __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
>> -
>> -		spin_lock(&mdsc->cap_dirty_lock);
>> -
>> -		if (list_empty(&ci->i_cap_flush_list))
>> -			list_del_init(&ci->i_flushing_item);
>> -
>> -		wake_mdsc |= __detach_cap_flush_from_mdsc(mdsc,
>> -							  &capsnap->cap_flush);
>> -		spin_unlock(&mdsc->cap_dirty_lock);
>> -	}
>> +	if (flushed)
>> +		ceph_remove_capsnap(inode, capsnap, &wake_ci, &wake_mdsc);
>>   	spin_unlock(&ci->i_ceph_lock);
>> +
>>   	if (flushed) {
>>   		ceph_put_snap_context(capsnap->context);
>>   		ceph_put_cap_snap(capsnap);
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index fa4c0fe294c1..a632e1c7cef2 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1604,10 +1604,30 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>>   	return ret;
>>   }
>>   
>> +static void remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
>> +{
>> +	struct ceph_inode_info *ci = ceph_inode(inode);
>> +	struct ceph_cap_snap *capsnap;
>> +
>> +	dout("removing capsnaps, ci is %p, inode is %p\n", ci, inode);
>> +
>> +	while (!list_empty(&ci->i_cap_snaps)) {
>> +		capsnap = list_first_entry(&ci->i_cap_snaps,
>> +					   struct ceph_cap_snap, ci_item);
>> +		ceph_remove_capsnap(inode, capsnap, NULL, NULL);
>> +		ceph_put_snap_context(capsnap->context);
>> +		ceph_put_cap_snap(capsnap);
>> +		iput(inode);
>> +	}
>> +	wake_up_all(&ci->i_cap_wq);
>> +	wake_up_all(&mdsc->cap_flushing_wq);
>> +}
>> +
>>   static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   				  void *arg)
>>   {
>>   	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
>> +	struct ceph_mds_client *mdsc = fsc->mdsc;
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	LIST_HEAD(to_remove);
>>   	bool dirty_dropped = false;
>> @@ -1619,7 +1639,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   	__ceph_remove_cap(cap, false);
>>   	if (!ci->i_auth_cap) {
>>   		struct ceph_cap_flush *cf;
>> -		struct ceph_mds_client *mdsc = fsc->mdsc;
>>   
>>   		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
>>   			if (inode->i_data.nrpages > 0)
>> @@ -1684,6 +1703,8 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   			ci->i_prealloc_cap_flush = NULL;
>>   		}
>>   	}
>> +	if (!list_empty(&ci->i_cap_snaps))
>> +		remove_capsnaps(mdsc, inode);
>>   	spin_unlock(&ci->i_ceph_lock);
>>   	while (!list_empty(&to_remove)) {
>>   		struct ceph_cap_flush *cf;
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 0bc36cf4c683..51ec17d12b26 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -1168,6 +1168,9 @@ extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
>>   					    int had);
>>   extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>>   				       struct ceph_snap_context *snapc);
>> +extern void ceph_remove_capsnap(struct inode *inode,
>> +				struct ceph_cap_snap *capsnap,
>> +				bool *wake_ci, bool *wake_mdsc);
>>   extern void ceph_flush_snaps(struct ceph_inode_info *ci,
>>   			     struct ceph_mds_session **psession);
>>   extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
> Patch looks reasonable otherwise.

