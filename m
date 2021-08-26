Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A09D3F7F7A
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Aug 2021 02:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbhHZAtP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 20:49:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232139AbhHZAtP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 20:49:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629938908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZrixxZCprYEkGOzj+MU5Y/ghTCfhOIbcfyY1a1+vqI=;
        b=NLrlh0zNR6DDtaXNUw9TAZSdvEDP+xe25pAsB/WmQRvnsZte6pGM4Eo8copSvEjUxBUFzt
        tEg5OVb6zOtpxG0Rk4T/61wQSIqRUfVU6z+ZMFwkLcyxmnl8FhvnG5RTKLHKK6Jch/pFBJ
        em/ir6VVRQ0Erkws/q7vKL0lAznXDLs=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-AaBjru4OP-qzu7BfL77Cew-1; Wed, 25 Aug 2021 20:48:27 -0400
X-MC-Unique: AaBjru4OP-qzu7BfL77Cew-1
Received: by mail-pg1-f199.google.com with SMTP id k28-20020a63ff1c0000b029023b84262596so848541pgi.1
        for <ceph-devel@vger.kernel.org>; Wed, 25 Aug 2021 17:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tZrixxZCprYEkGOzj+MU5Y/ghTCfhOIbcfyY1a1+vqI=;
        b=a4Ljzn43W30/irIYo4DTfK9dqe2/OeyJ2xmGJH5cltCz8hFDU6JnIWQ0GcqsdLDmg2
         lsA1Eo2BHLZgGF3HkVhwScHP8cpmUxKTgVrsAex5VV5Ght7g2ic4BPxtr5e5uzbIgK4T
         GHDhj1fe6bWcgXanzsWkCZvjh5uiPG9w1UUIK0CgWqU3SL2EGz/jdtBDgqqezBbIGYta
         Z5UsZBknj2OQTOxHV1KflUNpG4wpd2pw9qU41gQYi+FsYQ6Fi169wVl3ps90Sa15Aev7
         AHRwPGQzpD/JytxY1Fp+9aMlmcw7U47U1rriWlE5LQ8LQClKW5EfCnObpc9dYIzsRfOh
         4H8g==
X-Gm-Message-State: AOAM530VlXtEuZcdivVzgpb0YUo2i0Lwv2ho/krBZsKHp70S+aeFYFtO
        6M643PmD30AgwbPd+iTFKYzJseL2izUuuohqNUVX1tA/4E3iWLQeTk/z4ovLTfWoazMq40b2HJv
        CvAlq4ETFKZHBHznXVxOtlA9VPf2kFDnDIsmV0RFm+hxY89htjeglbq79wlNWf/4P7E7VuDI=
X-Received: by 2002:a17:90a:a585:: with SMTP id b5mr13019546pjq.201.1629938905703;
        Wed, 25 Aug 2021 17:48:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpzrIYehYB8iJRXPSANepuG2cQDGRWTFkZjlQFev7Cdvuyaq1JX5bfAoSzGyGNvkxVmqdO7w==
X-Received: by 2002:a17:90a:a585:: with SMTP id b5mr13019518pjq.201.1629938905306;
        Wed, 25 Aug 2021 17:48:25 -0700 (PDT)
Received: from [10.72.12.157] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y8sm821352pfe.162.2021.08.25.17.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 17:48:24 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] ceph: remove the capsnaps when removing the caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20210825134545.117521-1-xiubli@redhat.com>
 <20210825134545.117521-2-xiubli@redhat.com>
 <4c9e45b40fb4c2f5e7b5c14df2507525d0710f54.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <475bce3a-8a26-5d6d-72ed-36eaabe76aef@redhat.com>
Date:   Thu, 26 Aug 2021 08:48:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4c9e45b40fb4c2f5e7b5c14df2507525d0710f54.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/25/21 10:25 PM, Jeff Layton wrote:
> On Wed, 2021-08-25 at 21:45 +0800, xiubli@redhat.com wrote:
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
>>   fs/ceph/caps.c       | 67 +++++++++++++++++++++++++++++++++-----------
>>   fs/ceph/mds_client.c | 31 +++++++++++++++++++-
>>   fs/ceph/super.h      |  6 ++++
>>   3 files changed, 86 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 1e6261a16fb5..61326b490b2b 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3162,7 +3162,15 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>>   				break;
>>   			}
>>   		}
>> -		BUG_ON(!found);
>> +
>> +		/*
>> +		 * The capsnap should already be removed when
>> +		 * removing auth cap in case likes force unmount.
>> +		 */
>> +		BUG_ON(!found && ci->i_auth_cap);
>> +		if (!found)
>> +			goto unlock;
>> +
>>   		capsnap->dirty_pages -= nr;
>>   		if (capsnap->dirty_pages == 0) {
>>   			complete_capsnap = true;
>> @@ -3184,6 +3192,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>>   		     complete_capsnap ? " (complete capsnap)" : "");
>>   	}
>>   
>> +unlock:
>>   	spin_unlock(&ci->i_ceph_lock);
>>   
>>   	if (last) {
>> @@ -3658,6 +3667,43 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>   		iput(inode);
>>   }
>>   
>> +void __ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
>> +			   bool *wake_ci, bool *wake_mdsc)
>> +{
>> +	struct ceph_inode_info *ci = ceph_inode(inode);
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>> +	bool ret;
>> +
>> +	lockdep_assert_held(&ci->i_ceph_lock);
> Hmm, your earlier patch had a note saying that the s_mutex needed to he
> held here too. Is that not the case?

The s_mutex is not needed here, I meant the i_ceph_lock and the comment 
was just copied from somewhere and forgot to modify it.



>
>> +
>> +	dout("removing capsnap %p, inode %p ci %p\n", capsnap, inode, ci);
>> +
>> +	list_del_init(&capsnap->ci_item);
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
>> +void ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
>> +			 bool *wake_ci, bool *wake_mdsc)
>> +{
>> +	struct ceph_inode_info *ci = ceph_inode(inode);
>> +
>> +	lockdep_assert_held(&ci->i_ceph_lock);
>> +
>> +	WARN_ON_ONCE(capsnap->dirty_pages || capsnap->writing);
>> +	__ceph_remove_capsnap(inode, capsnap, wake_ci, wake_mdsc);
>> +}
>> +
>>   /*
>>    * Handle FLUSHSNAP_ACK.  MDS has flushed snap data to disk and we can
>>    * throw away our cap_snap.
>> @@ -3695,23 +3741,10 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
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
>> index df3a735f7837..36ad0ebb2295 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1604,14 +1604,39 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>>   	return ret;
>>   }
>>   
>> +static int remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
>> +{
>> +	struct ceph_inode_info *ci = ceph_inode(inode);
>> +	struct ceph_cap_snap *capsnap;
>> +	int capsnap_release = 0;
>> +
>> +	lockdep_assert_held(&ci->i_ceph_lock);
>> +
>> +	dout("removing capsnaps, ci is %p, inode is %p\n", ci, inode);
>> +
>> +	while (!list_empty(&ci->i_cap_snaps)) {
>> +		capsnap = list_first_entry(&ci->i_cap_snaps,
>> +					   struct ceph_cap_snap, ci_item);
>> +		__ceph_remove_capsnap(inode, capsnap, NULL, NULL);
>> +		ceph_put_snap_context(capsnap->context);
>> +		ceph_put_cap_snap(capsnap);
>> +		capsnap_release++;
>> +	}
>> +	wake_up_all(&ci->i_cap_wq);
>> +	wake_up_all(&mdsc->cap_flushing_wq);
>> +	return capsnap_release;
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
>>   	bool invalidate = false;
>> +	int capsnap_release = 0;
>>   
>>   	dout("removing cap %p, ci is %p, inode is %p\n",
>>   	     cap, ci, &ci->vfs_inode);
>> @@ -1619,7 +1644,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   	__ceph_remove_cap(cap, false);
>>   	if (!ci->i_auth_cap) {
>>   		struct ceph_cap_flush *cf;
>> -		struct ceph_mds_client *mdsc = fsc->mdsc;
>>   
>>   		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
>>   			if (inode->i_data.nrpages > 0)
>> @@ -1683,6 +1707,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   			list_add(&ci->i_prealloc_cap_flush->i_list, &to_remove);
>>   			ci->i_prealloc_cap_flush = NULL;
>>   		}
>> +
>> +		if (!list_empty(&ci->i_cap_snaps))
>> +			capsnap_release = remove_capsnaps(mdsc, inode);
>>   	}
>>   	spin_unlock(&ci->i_ceph_lock);
>>   	while (!list_empty(&to_remove)) {
>> @@ -1699,6 +1726,8 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   		ceph_queue_invalidate(inode);
>>   	if (dirty_dropped)
>>   		iput(inode);
>> +	while (capsnap_release--)
>> +		iput(inode);
>>   	return 0;
>>   }
>>   
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 8f4f2747be65..445d13d760d1 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -1169,6 +1169,12 @@ extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
>>   					    int had);
>>   extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>>   				       struct ceph_snap_context *snapc);
>> +extern void __ceph_remove_capsnap(struct inode *inode,
>> +				  struct ceph_cap_snap *capsnap,
>> +				  bool *wake_ci, bool *wake_mdsc);
>> +extern void ceph_remove_capsnap(struct inode *inode,
>> +				struct ceph_cap_snap *capsnap,
>> +				bool *wake_ci, bool *wake_mdsc);
>>   extern void ceph_flush_snaps(struct ceph_inode_info *ci,
>>   			     struct ceph_mds_session **psession);
>>   extern bool __ceph_should_report_size(struct ceph_inode_info *ci);

