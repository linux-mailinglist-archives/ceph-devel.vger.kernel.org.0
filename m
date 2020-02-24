Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2067C169C93
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2020 04:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgBXDRq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Feb 2020 22:17:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47100 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727156AbgBXDRq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 23 Feb 2020 22:17:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582514264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EIrhXn2i5DQ8q/o49XaGa2rE4/WANztIamWRK3Ronzk=;
        b=g/JudbUd/I3R/+Mnq5ZWddkOPrxsFpNbmMqXtYbtixvjhnXoilWEn04a6VIJ3azlIICuKj
        FG6i390P5/lFmpbHxpNQaN11QQsR/JQyDjwYQJFdORWXGbuQLlzDv4/P0DHfwZ8nuFW0HZ
        BR6bAa7o8H7gUmls5LkfGLkCQbj0SX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-hJjNsmURO_ykhJzRuHLP7w-1; Sun, 23 Feb 2020 22:17:41 -0500
X-MC-Unique: hJjNsmURO_ykhJzRuHLP7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9557313E2;
        Mon, 24 Feb 2020 03:17:40 +0000 (UTC)
Received: from [10.72.13.212] (ovpn-13-212.pek2.redhat.com [10.72.13.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44C6491843;
        Mon, 24 Feb 2020 03:17:38 +0000 (UTC)
Subject: Re: [PATCH v2 1/4] ceph: always renew caps if mds_wanted is
 insufficient
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20200221131659.87777-1-zyan@redhat.com>
 <20200221131659.87777-2-zyan@redhat.com>
 <f1e5924fb183b738e4103130ec1197cacea0047e.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <8126e83a-0732-b44a-6858-4c9cc13c3231@redhat.com>
Date:   Mon, 24 Feb 2020 11:17:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <f1e5924fb183b738e4103130ec1197cacea0047e.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2/22/20 1:17 AM, Jeff Layton wrote:
> On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
>> original code only renews caps for inodes with CEPH_I_CAP_DROPPED flags.
>> The flag indicates that mds closed session and caps were dropped. This
>> patch is preparation for not requesting caps for idle open files.
>>
>> CEPH_I_CAP_DROPPED is no longer tested by anyone, so this patch also
>> remove it.
>>
>> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>> ---
>>   fs/ceph/caps.c       | 36 +++++++++++++++---------------------
>>   fs/ceph/mds_client.c |  5 -----
>>   fs/ceph/super.h      | 11 +++++------
>>   3 files changed, 20 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index d05717397c2a..293920d013ff 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2659,6 +2659,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>>   		}
>>   	} else {
>>   		int session_readonly = false;
>> +		int mds_wanted;
>>   		if (ci->i_auth_cap &&
>>   		    (need & (CEPH_CAP_FILE_WR | CEPH_CAP_FILE_EXCL))) {
>>   			struct ceph_mds_session *s = ci->i_auth_cap->session;
>> @@ -2667,32 +2668,27 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>>   			spin_unlock(&s->s_cap_lock);
>>   		}
>>   		if (session_readonly) {
>> -			dout("get_cap_refs %p needed %s but mds%d readonly\n",
>> +			dout("get_cap_refs %p need %s but mds%d readonly\n",
>>   			     inode, ceph_cap_string(need), ci->i_auth_cap->mds);
>>   			ret = -EROFS;
>>   			goto out_unlock;
>>   		}
>>   
>> -		if (ci->i_ceph_flags & CEPH_I_CAP_DROPPED) {
>> -			int mds_wanted;
>> -			if (READ_ONCE(mdsc->fsc->mount_state) ==
>> -			    CEPH_MOUNT_SHUTDOWN) {
>> -				dout("get_cap_refs %p forced umount\n", inode);
>> -				ret = -EIO;
>> -				goto out_unlock;
>> -			}
>> -			mds_wanted = __ceph_caps_mds_wanted(ci, false);
>> -			if (need & ~(mds_wanted & need)) {
>> -				dout("get_cap_refs %p caps were dropped"
>> -				     " (session killed?)\n", inode);
>> -				ret = -ESTALE;
>> -				goto out_unlock;
>> -			}
>> -			if (!(file_wanted & ~mds_wanted))
>> -				ci->i_ceph_flags &= ~CEPH_I_CAP_DROPPED;
>> +		if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
>> +			dout("get_cap_refs %p forced umount\n", inode);
>> +			ret = -EIO;
>> +			goto out_unlock;
>> +		}
>> +		mds_wanted = __ceph_caps_mds_wanted(ci, false);
>> +		if (need & ~mds_wanted) {
>> +			dout("get_cap_refs %p need %s > mds_wanted %s\n",
>> +			     inode, ceph_cap_string(need),
>> +			     ceph_cap_string(mds_wanted));
>> +			ret = -ESTALE;
>> +			goto out_unlock;
>>   		}
>>   
> 
> I was able to reproduce softlockups with xfstests reliably for a little
> while, but it doesn't always happen. I bisected it down to this patch
> though. I suspect the problem is in the hunk above. It looks like it's
> getting into a situation where this is continually returning ESTALE.
> 
> I cranked up debug logging in this function and I see this:
> 
> [  259.284839] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> [  259.284848] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> [  259.284855] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> [  259.284863] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> [  259.284868] ceph:  get_cap_refs 000000003d7d65fa need Fr > mds_wanted -
> [  259.284877] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> [  259.284885] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> [  259.284890] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> [  259.284899] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> [  259.284908] ceph:  get_cap_refs 000000003d7d65fa need Fr > mds_wanted -
> [  259.284918] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> [  259.284926] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> [  259.284945] ceph:  get_cap_refs 000000003d7d65fa need Fr > mds_wanted -
> [  259.284950] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> [  259.284961] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> [  259.284969] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> [  259.284975] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> [  259.284984] ceph:  get_cap_refs 000000003d7d65fa need Fr > mds_wanted -
> [  259.284994] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> [  259.285003] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> 

Looks like ceph_check_caps did update caps' mds_wanted. Did you test 
this patch with async dirops patches? please try reproducing this issue 
again with debug log of try_get_cap_refs(), ceph_check_caps() and 
ceph_renew_caps().

Thanks
Yan, Zheng


> ...not sure I understand the logical flow in this function well enough
> to suggest a fix yet though.
> 
>> -		dout("get_cap_refs %p have %s needed %s\n", inode,
>> +		dout("get_cap_refs %p have %s need %s\n", inode,
>>   		     ceph_cap_string(have), ceph_cap_string(need));
>>   	}
>>   out_unlock:
>> @@ -3646,8 +3642,6 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>>   		goto out_unlock;
>>   
>>   	if (target < 0) {
>> -		if (cap->mds_wanted | cap->issued)
>> -			ci->i_ceph_flags |= CEPH_I_CAP_DROPPED;
>>   		__ceph_remove_cap(cap, false);
>>   		goto out_unlock;
>>   	}
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index fab9d6461a65..98d746b3bb53 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1411,8 +1411,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   	dout("removing cap %p, ci is %p, inode is %p\n",
>>   	     cap, ci, &ci->vfs_inode);
>>   	spin_lock(&ci->i_ceph_lock);
>> -	if (cap->mds_wanted | cap->issued)
>> -		ci->i_ceph_flags |= CEPH_I_CAP_DROPPED;
>>   	__ceph_remove_cap(cap, false);
>>   	if (!ci->i_auth_cap) {
>>   		struct ceph_cap_flush *cf;
>> @@ -1578,9 +1576,6 @@ static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
>>   			/* mds did not re-issue stale cap */
>>   			spin_lock(&ci->i_ceph_lock);
>>   			cap->issued = cap->implemented = CEPH_CAP_PIN;
>> -			/* make sure mds knows what we want */
>> -			if (__ceph_caps_file_wanted(ci) & ~cap->mds_wanted)
>> -				ci->i_ceph_flags |= CEPH_I_CAP_DROPPED;
>>   			spin_unlock(&ci->i_ceph_lock);
>>   		}
>>   	} else if (ev == FORCE_RO) {
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 37dc1ac8f6c3..48e84d7f48a0 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -517,12 +517,11 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
>>   #define CEPH_I_POOL_RD		(1 << 4)  /* can read from pool */
>>   #define CEPH_I_POOL_WR		(1 << 5)  /* can write to pool */
>>   #define CEPH_I_SEC_INITED	(1 << 6)  /* security initialized */
>> -#define CEPH_I_CAP_DROPPED	(1 << 7)  /* caps were forcibly dropped */
>> -#define CEPH_I_KICK_FLUSH	(1 << 8)  /* kick flushing caps */
>> -#define CEPH_I_FLUSH_SNAPS	(1 << 9)  /* need flush snapss */
>> -#define CEPH_I_ERROR_WRITE	(1 << 10) /* have seen write errors */
>> -#define CEPH_I_ERROR_FILELOCK	(1 << 11) /* have seen file lock errors */
>> -#define CEPH_I_ODIRECT		(1 << 12) /* inode in direct I/O mode */
>> +#define CEPH_I_KICK_FLUSH	(1 << 7)  /* kick flushing caps */
>> +#define CEPH_I_FLUSH_SNAPS	(1 << 8)  /* need flush snapss */
>> +#define CEPH_I_ERROR_WRITE	(1 << 9)  /* have seen write errors */
>> +#define CEPH_I_ERROR_FILELOCK	(1 << 10) /* have seen file lock errors */
>> +#define CEPH_I_ODIRECT		(1 << 11) /* inode in direct I/O mode */
>>   
>>   /*
>>    * Masks of ceph inode work.
> 

